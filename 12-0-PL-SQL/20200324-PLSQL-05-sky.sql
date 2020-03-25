--■ PL/SQL
--작성된 트리거 보기
SELECT * FROM user_triggers;
--트리거 생성하기 위한 권한을 sky에게 부여하기 (dba관리자 계정에서만 가능하다.)
GRANT CREATE TRIGGER TO sky;
--사용자의 시스템 권한 확인
SELECT * FROM user_sys_privs;
-- ※ 트리거 (BEFORE, AFTER, INSTEAD OF)
--     -------------------------------------------------------
--     -- 문장 트리거: 
--      DML 실행횟수(EX: DELETE FROM EMP<- 60개의 레코드에 대해 실행)와 상관없이 단 한 번 실행
    
    CREATE TABLE ex(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL
    );
    
    CREATE TABLE ex_time(
        memo VARCHAR2(100),
        created DATE DEFAULT SYSDATE
    );
    
    --문장 트리거 작성하기
    CREATE OR REPLACE TRIGGER tri_ex
    AFTER INSERT OR UPDATE OR DELETE ON ex
    BEGIN
        IF INSERTING THEN
            INSERT INTO ex_time(memo) VALUES('추가');
        ELSIF UPDATING THEN
            INSERT INTO ex_time(memo) VALUES('수정');
        ELSIF DELETING THEN
            INSERT INTO ex_time(memo) VALUES('삭제');
        END IF;
        --트리거 안에서 INSERT, DELETE, UPDATE는 자동으로 COMMIT된다.
        --그러므로 COMMIT; 문을 기술하지 않는다.
    END;
    /
    
    SELECT * FROM user_triggers;
    SELECT * FROM user_source; --프로시저 및 트리거의 작성 소스가 그대로 보인다.
    
    INSERT INTO ex(num, name) VALUES(1, 'a');
    INSERT INTO ex(num, name) VALUES(2, 'b');
    COMMIT;
    UPDATE ex SET name='aa' WHERE num=1;
    COMMIT;
    
    SELECT * FROM ex;
    SELECT * FROM ex_time;
    
    DELETE FROM ex; --문장 트리거는 delete되는 개수에 상관없이 한 번만 트리거가 발생한다.
    
    --지정 시간이 지나면 작업을 하지 못하도록
    --(TO_CHAR(SYSDATE, 'HH24') < 9 AND TO_CHAR(SYSDATE,'HH24') > 18) THEN
            RAISE_APPLICATION_ERROR(-20001,'지금은 작업을 할 수 없습니다.');
    CREATE OR REPLACE TRIGGER tri_ex2
    AFTER INSERT OR UPDATE OR DELETE ON ex
    BEGIN
        IF TO_CHAR(SYSDATE, 'D') IN (1,7) OR
        (TO_CHAR(SYSDATE, 'HH24') >= 15 AND TO_CHAR(SYSDATE,'HH24') <= 16) THEN
            --오후 3~4시 대역
            RAISE_APPLICATION_ERROR(-20001,'지금은 작업을 할 수 없습니다.');
        END IF;
    END;
    /
    INSERT INTO ex(num, name) VALUES(1, 'a'); --ORA-20001: 지금은 작업을 할 수 없습니다.
    
    
--     -------------------------------------------------------
--     -- 행 트리거 
--      DML문장을 실행할 경우 하나의 DML 실행 횟수(행)만큼 TRIGGER 호출
--      예를 들어 10개의 해잉 삭제되면 트리거도 10번 실행
--      

    DROP TABLE score2 PURGE;
    DROP TABLE score1 PURGE;
    
    CREATE TABLE score1(
        hak VARCHAR2(20) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL
    );
    
    CREATE TABLE score2(
        hak VARCHAR2(20) PRIMARY KEY,
        kor NUMBER(2,1) NOT NULL,
        eng NUMBER(2,1) NOT NULL,
        mat NUMBER(2,1) NOT NULL,
        FOREIGN KEY(hak) REFERENCES score1(hak)
    );

    CREATE OR REPLACE FUNCTION fnGrade(
        pScore NUMBER
    )
    RETURN NUMBER
    IS
        n NUMBER(2,1);
    BEGIN
        IF pScore>=95 THEN n := 4.5;
        ELSIF pScore>=90 THEN n := 4.5;
        ELSIF pScore>=85 THEN n := 4.0;
        ELSIF pScore>=80 THEN n := 3.5;
        ELSIF pScore>=75 THEN n := 3.0;
        ELSIF pScore>=70 THEN n := 2.5;
        ELSIF pScore>=65 THEN n := 2.0;
        ELSIF pScore>=60 THEN n := 1.5;
        ELSIF pScore>=55 THEN n := 1.0;
        ELSE n := 0.0;
        END IF;
        RETURN n;
    END;
    /
    SELECT fnGrade(90) from dual;
    
    --행 트리거 만드는 방법
    CREATE OR REPLACE TRIGGER tri_scoreInsert
    AFTER INSERT ON score1
    FOR EACH ROW -- 행 트리거일 때 선언하는 문장
    DECLARE --변수선언부
    BEGIN
        -- :NEW -> 기존에(score1테이블에서) insert한 행 내용(행 트리거만 사용할 수 있음)
        INSERT INTO score2(hak, kor, eng, mat) 
        VALUES(:NEW.hak, fnGrade(:NEW.kor), fnGrade(:NEW.eng), fnGrade(:NEW.mat));
        --트리거는 자동 commit이 되므로 유의한다.
        --ROLLBACK도 사용할 수 없음
    END;
    /
    
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('1', 'aaa',90,85,70);
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('2', 'bbb',85,60,77);
    COMMIT;
    
    SELECT * FROM score1
    JOIN score2 USING(hak);
    
    --수정 트리거
    CREATE OR REPLACE TRIGGER tri_scoreUpdate
    AFTER UPDATE ON score1
    FOR EACH ROW -- 행 트리거일 때 선언하는 문장
    DECLARE --변수선언부
    BEGIN
        -- :OLD -> update하기 전 행 내용 (행 트리거만 사용할 수 있음)
        -- :NEW -> 기존에(score1테이블에서) insert한 행 내용(행 트리거만 사용할 수 있음)
        UPDATE score2 SET 
            kor = fnGrade(:NEW.kor),
            eng = fnGrade(:NEW.eng),
            mat = fnGrade(:NEW.mat)
        WHERE hak = :OLD.hak;
    END;
    /
    
    UPDATE score1 SET kor=100 WHERE hak='2';
    SELECT * FROM score1
    JOIN score2 USING(hak);

    --삭제 트리거
    CREATE OR REPLACE TRIGGER tri_scoreDelete
    --AFTER로 선언하더라도 오라클은 자동으로 테이블의 관게를 파악하여 쿼리 작업을 수행해 줌
    --∵ score1테이블에 참조되고 있으므로 원래 순서대로라면 AFTER로 설정하면 원래는!! 실행이 되지 않는 것이 맞다.
    BEFORE DELETE ON score1
    FOR EACH ROW -- 행 트리거일 때 선언하는 문장
    DECLARE --변수선언부
    BEGIN
        -- :OLD -> delete할 행 내용 (행 트리거만 사용할 수 있음)
        DELETE FROM score2 WHERE hak = :OLD.hak;
    END;
    /
    
    DELETE FROM score1;
    COMMIT;
    SELECT * FROM score1
    JOIN score2 USING(hak);
    
    --문제1)
    
    
    
-- ※ 패키지(Package)
--     -------------------------------------------------------
-- EXEC DBMS_OUTPUT.PUT_LINE(인수);
-- EXEC 패키지명.프로시저명(내용);
EXEC DBMS_OUTPUT.PUT_LINE('TEST');

--패키지 목록 확인
SELECT * FROM user_objects WHERE object_type = 'PACKAGE';
SELECT * FROM user_objects WHERE object_type = 'PACKAGE_BODY';
SELECT * FROM user_procedures; --WHERE object_type='PACKAGE';

SELECT * FROM user_objects; --테이블, 인덱스, 트리거, 뷰 등... 모든 객체를 조회할 수 있음.
