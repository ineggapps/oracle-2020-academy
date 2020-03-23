--■ 트랜잭션
-- ※ 트랜잭션(Transaction)
--   ο COMMIT 과 ROLLBACK
    CREATE TABLE emp1 AS SELECT empno, name, city FROM emp;
    INSERT INTO emp1 VALUES('9999','aaa','서울');
    SELECT * FROM emp1;
    SAVEPOINT a;
    
    UPDATE emp1 SET city='bbb';
    SELECT * FROM emp1;
    ROLLBACK TO a;--SAVEPOINT a를 선언한 이후에 작업한 내역까지만 ROLLBACK된다    

    COMMIT;--COMMIT이 끝나면 롤백되지 않는다.
        
--   ο 트랜잭션 관련 설정
--     1) SET TRANSACTION
    
    ---SQL PLUS에서만
    SHOW AUTOCOMMIT; -- autocommit off: DML은 자동으로 COMMIT되지 않는다.
    SET AUTOCOMMIT ON;
    SHOW AUTOCOMMIT; -- autocommit IMMEDIATE
    ---
    SELECT * FROM EMP1; -- 다른 콘솔 창에서 확인해 보아도 자동으로 AUTO COMMIT된 것을 알 수 있다.
    ---
    SET AUTOCOMMIT OFF;
    ---

    --DEVELOPER (CONNECTION#1)
    INSERT INTO emp1 VALUES('5555','b','b');
    --SQLPLUS (CONNECTION#2)
    SELECT * FROM emp1; --새로 추가된 행이 보이지 않음
    --DEVELOPER #1
    COMMIT; 
    --SQLPLUS #2 커밋 이후 다시 테이블 조회 시도
    SELECT * FROM emp1; --새로 추가된 행이 보이지 않음
    --DEVELOPER #1
    SET TRANSACTION  READ ONLY;--SELECT만 가능하도록 현재 트랜잭션 수정하기
    DELETE FROM EMP1;--ORA-01456: READ ONLY 트랜잭션은 삽입/삭제/업데이트 작업을 수행할 수 없습니다.
    ROLLBACK;
    SET TRANSACTION READ WRITE;--원래의 트랜잭션이 읽기쓰기가 가능하도록 수정
    
--     2) LOCK TABLE
    
    --DEVELOPER 커넥션#1
    SELECT * FROM emp1;
    UPDATE emp1 SET city='aaa' WHERE empno='1001';
    SET TIME ON;
    
    --SQLPLUS 커넥션#2
    SELECT * FROM emp1 FOR UPDATE WAIT 5;  --ORA-30006: 리소스 사용 중. WAIT 시간 초과로 획득이 만료됨 (5초 후 오류)
    
    --#1
    ROLLBACK;
    LOCK TABLE emp1 IN EXCLUSIVE MODE;--잠긴 테이블에 다른 커넥션들이 DML 명령어 사용하는 것을 허용하지 않음
    --현재 트랜잭션이 사용하고 있는 데이터에 대해 다른 트랜잭션의 검색이나 변경을 막는다.
    --DML 후 COMMIT 또는 ROLLBACK을 해야 DML이 가능하다.
    DELETE FROM emp1;
    
    --#2
    UPDATE emp1 SET city='aaa' WHERE empno='1001';
    
    --#1
    ROLLBACK;
    
--      -------------------------------------------------------
--      -- COMMIT이 되지 않는 상태 확인
--      -- 관리자(sys 또는 system) 계정에서 확인
        SELECT s.inst_id inst, s.sid||','||s.serial# sid, s.username,
                    s.program, s.status, s.machine, s.service_name,
                    '_SYSSMU'||t.xidusn||'$' rollname, --r.name rollname, 
                    t.used_ublk, 
                   ROUND(t.used_ublk * 8192 / 1024 / 1024, 2) used_bytes,
                   s.prev_sql_id, s.sql_id
        FROM gv$session s,
                  --v$rollname r,
                  gv$transaction t
        WHERE s.saddr = t.ses_addr
        ORDER BY used_ublk, machine;
        
    --
    DROP TABLE emp1 PURGE;