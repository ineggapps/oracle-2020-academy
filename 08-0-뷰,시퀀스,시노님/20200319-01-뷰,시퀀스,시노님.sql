--■ 뷰 및 시퀀스, 시노님
-- ※ 뷰(VIEW)
--0. 뷰 작성 권한을 부여해야 한다. (관리자: sys, system 계정에서만 가능)
--뷰는 데이터를 가지고 있지 않음 (MATERIALIZED VIEW에서는 데이터를 가지고 있음)
--뷰 작성권한
--GRANT 부여할 권한 TO 사용자;
GRANT CREATE VIEW TO sky;--관리자 계정에서 실행
--사용자 계정에서 권한을 확인하는 방법
SELECT * FROM USER_SYS_PRIVS;
--SKY, CREATE VIEW, NO, NO, NO

--1. subquery문이 실행되는지 점검
--2. 연산 수식은 반드시 컬럼명을 가져야 한다.
     ------------------------------------------------------
        --ORA-01031: 권한이 불충분합니다
        --01031. 00000 -  "insufficient privileges"
        CREATE VIEW panmai 
        AS
            --판매 현황: b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            FROM book b
            JOIN pub p  ON  b.pNum = p.pNum
            JOIN dsale d  ON b.bCode = d.bCode
            JOIN sale s  ON  d.sNum = s.sNum
            JOIN cus c  ON s.cNum = c.cNum;

        --뷰 확인
        SELECT * FROM TAB WHERE tabtype='VIEW';
        --뷰는 만들어지면 tabtype이 VIEW로 표시된다.
        SELECT * FROM col WHERE tname='PANMAI';
        DESC panmai;
        --생성된 뷰의 SQL문 확인
        SELECT view_name, text FROM user_views;
        --테이블처럼 뷰도 내용을 조회할 수 있다.
        SELECT * FROM panmai;
        
        ----------------------------------------
        --뷰 수정
        --OR REPLACE를 사용하지 않으면...
        --ORA-00955: 기존의 객체가 이름을 사용하고 있습니다.
        --00955. 00000 -  "name is already used by an existing object"
        CREATE OR REPLACE VIEW panmai 
        AS
            SELECT b.bccode, bcsubject, 
            b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            FROM book b
            JOIN bclass bc ON b.bccode = bc.bccode
            JOIN pub p  ON  b.pNum = p.pNum
            JOIN dsale d  ON b.bCode = d.bCode
            JOIN sale s  ON  d.sNum = s.sNum
            JOIN cus c  ON s.cNum = c.cNum;    
        SELECT * FROM panmai;
        
        ----------------------------------
        --문제1) 뷰 만들기: ypanmai
        --연도, bcode, bname, qty합, qty*bprice 합
        --연도 내림차순 정렬하기
        
        CREATE OR REPLACE VIEW ypanmai
        AS
        SELECT TO_CHAR(sdate,'YYYY') 연도, b.bcode ,bname, 
            sum(qty) 수량합, 
            TO_CHAR(sum(qty*bprice),'L999,999,999') 금액합
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
        GROUP BY TO_CHAR(sdate,'YYYY'), b.bcode, bname
        ORDER BY 연도 DESC;
        
        SELECT view_name, text FROM USER_VIEWS;
        SELECT * FROM TAB WHERE tabtype='VIEW';
        SELECT * FROM ypanmai;
       
       --올해 것만 추출
       SELECT * FROM ypanmai WHERE 연도 = EXTRACT(YEAR from SYSDATE);
    
        -- book : bCode, bName, bPrice, pNum
        -- pub : pNum, pName
        -- sale : sNum, sDate, cNum
        -- dsale : sNum, bCode, qty
        -- cus : cNum, cName
    ------------------------------------------------
    --  뷰를 이용한 데이터 추가, 수정, 삭제
    select * from tab where tname like 'TEST%';
    DROP TABLE test1 cascade constraint purge;
    
    
    CREATE TABLE test1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        memo VARCHAR2(100)
    );
    
    CREATE TABLE test2(
        code NUMBER PRIMARY KEY,
        num NUMBER REFERENCES test1(num) ON DELETE CASCADE,
        score NUMBER(3)
    );
    
    INSERT INTO test1(num, name, memo) VALUES(1, 'a', NULL);
    INSERT INTO test1(num, name, memo) VALUES(2, 'b', NULL);
    INSERT INTO test1(num, name, memo) VALUES(3, 'c', 'java');
    
    INSERT INTO test2(code, num, score) VALUES(1, 1, 80);
    INSERT INTO test2(code, num, score) VALUES(2, 1, 70);
    INSERT INTO test2(code, num, score) VALUES(3, 1, 60);
    
    COMMIT;
    --자료가 입력이 정상적으로 되었는지 확인
    SELECT * FROM test1 JOIN test2 USING(num);
    --복합 뷰
    CREATE OR REPLACE VIEW testview1
    AS
        SELECT a.num, code, name, memo, score
        FROM test1 a, test2 b WHERE a.num = b.num;
        
    SELECT view_name, text FROM USER_VIEWS;
    SELECT * FROM testview1;
    
    CREATE OR REPLACE VIEW testview2
    AS
        SELECT num, name 
        FROM test1;
    
    --복합 뷰는 INSERT, UPDATE, DELETE를 할 수 없음
    --ORA-01779:키 보존된 것이 아닌 테이블로 대응한 열을 수정할 수 없습니다.
    INSERT INTO testview1(num, name, memo) VALUES(4,'d','oracle');
    UPDATE testview1 SET memo='JSP';
    DELETE FROM testview1 WHERE code=2;--어라? 되는데...
    
    --단순 뷰의 경우에는 제약조건을 위반하지만 않는다면 INSERT, UPDATE, DELETE가 가능하다. 
    INSERT INTO testview2(num, name) VALUES(4,'oracle');
    COMMIT;
    UPDATE testview2 SET name='java' WHERE num=4;
    select * from testview2;
    DELETE FROM testview2 WHERE num=1;
    COMMIT;
    
    SELECT * FROM TEST1;
    SELECT * FROM TEST2;
    
    --뷰 및 테이블 삭제
    DROP VIEW testview1;
    DROP VIEW testview2;
    DROP TABLE test2 PURGE;
    DROP TABLE test1 PURGE;
    
    --WITH CHECK OPTION
    CREATE TABLE emp1 AS
        SELECT empno, name, city, sal FROM emp WHERE dept='개발부';
    SELECT * FROM emp1;
    
    --뷰 생성
    CREATE OR REPLACE VIEW empView
    AS
    SELECT empno, name, city, sal FROM emp1
    WHERE city='서울';
    
    SELECT * FROM empview;
    UPDATE empview SET city='부산' WHERE empno = '1059';
    
    --수정하지 못하도록 뷰 다시 생성
    CREATE OR REPLACE VIEW empView
    AS
    SELECT empno, name, city, sal FROM emp1
    WHERE city='서울' WITH CHECK OPTION CONSTRAINT wc_empView;
    
    SELECT * FROM empview;
    --WITH CHECK OPTION: 뷰를 이용한 참조 무결성 검사
    --ORA-01402: 뷰의 WITH CHECK OPTION의 조건에 위배 됩니다
    UPDATE empview SET city='부산' WHERE empno = '1059';
    
-- ※ 시퀀스(sequence)
     -------------------------------------------------------
     SELECT * FROM SEQ;
    
    --1부터 증가하는 시퀀스 만들기
    CREATE SEQUENCE seq1;
    
    --현재 존재하는 시퀀스 목록 확인하기
    SELECT * FROM seq;
    
    --시퀀스 사용하기
    SELECT seq1.NEXTVAL, seq1.NEXTVAL, seq1.CURRVAL FROM dual;
    --SELECT문장 안에서는 NEXTVAL을 누적사여 사용하더라도 1번 호출한 것으로 간주한다.
    
    --시퀀스 삭제하기      
    DROP SEQUENCE seq1;
    
    CREATE TABLE t1(
        col1 NUMBER,
        col2 NUMBER,
        col3 NUMBER
    );
    CREATE SEQUENCE seq1;
    
    INSERT INTO t1 VALUES(seq1.NEXTVAL, seq1.NEXTVAL, seq1.CURRVAL);
    --CURRVAL은 항상 신뢰할 수 없다
    --CURRVAL은 캐시나 연산 처리 우선순위에 의해 CURRVAL값과 일치하지 않을 수도 있음.
    select * from t1;
    
    DROP TABLE t1 PURGE;
    DROP SEQUENCE seq1;
    
    SELECT * FROM SEQ;
    --시퀀스 여러 개 만들기
    CREATE SEQUENCE seq0;--캐시 20(기본값)
    
    --1부터 1씩 증가
    CREATE SEQUENCE seq1
        START WITH 1
        INCREMENT BY 1 --음수가 올 수 있음. (START WITH를 큰 값으로 지정하면 충분히 가능하다)
        NOMAXVALUE --SEQUENCE가 표현할 수 있는 가장 마지막 값까지 (기본값) 9999999999999999999999999999
        NOCYCLE
        NOCACHE --NOCACHE는 0;
    
    --100부터 1씩 증가
    CREATE SEQUENCE seq2
        START WITH 100
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 1000; --CACHE는 언급하지 않으면 20이 기본값
    --CACHE값만큼 미리 SEQUENCE값을 만들어 둔다.
    --EX) 20개의 CACHE를 만들고 2개를 사용하였다면 18개가 남았다.
    --하지만, 오라클 서버 작동이 꺼지거나 하는 등의 오류가 발생하면
    --미리 만들어 둔 18개의 숫자는 사용하지 못하고 그 다음 값부터 캐싱을 다시 시작한다,
    
    --3부터 999까지 3씩 증가. cache 5개
    CREATE SEQUENCE seq3
        START WITH 3
        INCREMENT BY 3
        MINVALUE 3
        MAXVALUE 999
        CACHE 5;
        
        
    --
    CREATE SEQUENCE seq4
        START WITH 9
        INCREMENT BY 4
        MINVALUE 3
        MAXVALUE 12
        CYCLE --주의사항: CYCLE을 형성할 때는 반드시 CACHE값을 지정해야만 한다.
        CACHE 2;
        
    SELECT * FROM seq;
    
    CREATE TABLE t1(
        col1 NUMBER,
        col2 NUMBER,
        col3 NUMBER,
        col4 NUMBER
    );
     
    INSERT INTO t1 VALUES(seq1.NEXTVAL, seq2.NEXTVAL, seq3.NEXTVAL, seq4.NEXTVAL);   
    SELECT * FROM t1;
    
    DROP TABLE t1 PURGE;
    DROP SEQUENCE seq0;
    DROP SEQUENCE seq1;
    DROP SEQUENCE seq2;
    DROP SEQUENCE seq3;
    DROP SEQUENCE seq4;
   
-- ※ 시노님(synonym)
     -------------------------------------------------------
     
     --0단계) SKY계정에서 HR사용자의 employees 테이블 내용 확인하기
     SELECT * FROM hr.employees;
     --ORA-00942: 테이블 또는 뷰가 존재하지 않습니다 (권한이 없어서 확인할 수 없음)
     
     --1단계) HR사용자가 SKY사용자에게 employees 테이블 조회할 수 있도록 권한을 부여
     GRANT SELECT ON employees TO sky;
     
     --2단계) SKY계정에서 다시 employees 테이블 내용 확인 시도하기
     --SELECT * FROM employees; 다른사용자명.테이블명으로 언급해야 한다.
     SELECT * FROM hr.employees; --잘 확인되는 것을 볼 수 있음.
     
     --3단계) hr.을 입력하기 번거로우므로 synonym을 주도록 한다 (HR계정에서 시노님 지정) -BUT 권한불충분 오류
     CREATE SYNONYM employees FOR hr.employees;

    --단, 관리자 계정에서 다음의 권한을 SKY에게 부여하여야만 시노님 생성이 가능하다
     GRANT CREATE SYNONYM TO sky;
    
    --최종) 만들어진 시노님을 사용해 본다
    SELECT * FROM employees;

     --시노님 확인
     SELECT * FROM syn;
    
    --삭제
    DROP SYNONYM employees;
    
    --이렇게 자기 자신의 테이블도 시노님으로 만들 수 있겠군!
    CREATE SYNONYM e FOR emp;
    select * from e;

     --권한 부여하기 (관리자 계정에서)
     GRANT CREATE SYNONYM TO sky;
     
     
    --참고: 오라클에서는 뷰를 자주 사용하지는 않는다.