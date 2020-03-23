--■ PL/SQL
-- ※ 프로시저 (Stored Procedure)
--  자주 사용되는 업무의 흐름을 데이터베이스에 저장하고 나중에 호출하여 사용한다.
--  선행컴파일되므로 처리 속도가 빠르다. 그냥 쿼리문을 사용하는 것보다 훨씬 좋다. (오류도 사전에 검증 되었고)
--  JAVA로 치면 void 메서드라고 생각하면 된다. (return 이 없음)
--  프로시저는 트랜잭션 작업을 할 때 편해진다.
--  중복 정의(오버로딩) 가능하다.
--     -------------------------------------------------------

    CREATE TABLE test ( 
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        score NUMBER(3) NOT NULL,
        grade VARCHAR2(10) NOT NULL
    );
    
    CREATE SEQUENCE test_seq;
    
    SELECT * FROM tab;
    SELECT * FROM seq;   

    --프로시저 만들기 (오류가 있음)
    --만들 때 오류가 있어도 프로시저 객체는 생성되므로 OR REPLACE키워드를 입력하여 다시 프로시저를 정의한다
    CREATE PROCEDURE pInsertTest
    IS--변수 선언부
    
    BEGIN--메서드 기술
        INSERT INTO test(num, name, score, grade) -- PL/SQL: ORA-00904: "NAM": 부적합한 식별자
        VALUES(test_seq.NEXTVAL, '홍길동', 80, '우');
        COMMIT;
    END;
    /
    
    SELECT * FROM user_procedures;
    SELECT * FROM user_dependencies; --test와 test_seq에 의존한다는 것을 확인할 수 있다.
    SELECT * FROM user_source; --프로시저 소스코드가 출력됨을 알 수 있음.

    --프로시저 실행
    EXEC pInsertTest;
    
    select * from test;
    
    --프로시저 수정 (IN 파라미터)
    CREATE OR REPLACE PROCEDURE pInsertTest(
        pName VARCHAR2, --※ 주의: 파라미터는 절대 크기를 명시하지 않는다.
--         pName test.name%TYPE,--test테이블의 name컬럼과 크기를 동일하게 설정
        pScore IN NUMBER -- IN은 생략할 수 있다.
    )
    IS--변수 선언부
        vgrade VARCHAR2(20);
    BEGIN--메서드 기술
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100점만 가능합니다');
            --예외처리를 오라클에서 하면 JAVA단의 try, catch문에서 쉽게 잡을 수 있다.
        END IF;
        IF pScore>=90 THEN vgrade := '수';
        ELSIF pSCore>=80 THEN vgrade := '우';  
        ELSIF pSCore>=70 THEN vgrade := '미';  
        ELSIF pSCore>=60 THEN vgrade := '양';  
        ELSE vgrade := '가';  
        END IF;
        
        INSERT INTO test(num, name, score, grade) -- PL/SQL: ORA-00904: "NAM": 부적합한 식별자
        VALUES(test_seq.NEXTVAL, pName, pScore, vGrade);
        COMMIT;
    END;
    /
    
    EXEC pInsertTest('가가가',88);
    EXEC pInsertTest('나나나',90);
    select * from test;

    --수정하는 프로시저
    --RAISE_APPLICATION_ERROR(error_number, message)
    --사용자 정의 예외 발생. --error_number:-20999 ~ -20000
    CREATE OR REPLACE PROCEDURE pUpdateTest(
        pNum IN test.num%TYPE,
        pName IN test.name%TYPE, 
        pScore IN test.score%TYPE
    )
    IS--변수 선언부
        vgrade VARCHAR2(20);
    BEGIN--메서드 기술
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100점만 가능합니다');
        END IF;
        
        IF pScore>=90 THEN vgrade := '수';
        ELSIF pSCore>=80 THEN vgrade := '우';  
        ELSIF pSCore>=70 THEN vgrade := '미';  
        ELSIF pSCore>=60 THEN vgrade := '양';  
        ELSE vgrade := '가';  
        END IF;
        
        UPDATE test SET name=pName, score=pScore, grade=vGrade 
        WHERE num=pNum;
        COMMIT;
    END;
    /
    
    EXEC pUpdateTest(1,'vvv',99);
    EXEC pUpdateTest(2,'aaa',90);
    EXEC pUpdateTest(2,'aaa',190);--사용자 정의 오류 및 메시지가 뜬다 (예외 발생)
    select * from test;
    
    --삭제 프로시저: pDeleteTest
    CREATE PROCEDURE pDeleteTest(
        pNum IN test.num%TYPE
    )
    IS
    BEGIN
        DELETE FROM test
        WHERE num=pNum;
    END;
    /
    
    EXEC pDeleteTest(22);
    
    
    -- 하나의 레코드를 출력하는 프로시저 작성하기
    CREATE OR REPLACE PROCEDURE pSelectOneTest(
        pNum IN NUMBER
    )
    IS
        rec test%ROWTYPE;
    BEGIN
        SELECT * INTO rec FROM test WHERE num = pNum;
        DBMS_OUTPUT.PUT_LINE(rec.num || ' : ' || rec.name || ' : ' || rec.score || ' : ' || rec.grade);
    END;
    /
    
    EXEC pSelectOneTest(2);
    EXEC pSelectOneTest(1);-- ORA-01403: 데이터를 찾을 수 없습니다. (select를 하였지만 결괏값이 없는 경우)
    
    select * from test;
    
    --테이블 전체 레코드를 가져오는 방법
    CREATE OR REPLACE PROCEDURE pSelectListTest --파라미터가 없으면 괄호를 쓰지 않는구나!
    IS
    BEGIN
        FOR rec IN (SELECT num, name, score, grade FROM test) LOOP 
        --FOR IN 안에 SELECT문에는 INTO를 쓰지 않음
            DBMS_OUTPUT.PUT_LINE(rec.num || ' : ' || rec.name || ' : ' || rec.score || ' : ' || rec.grade);
        END LOOP;
    END;
    /
    EXEC pSelectListTest;
    
    ------------------------------------
    --문제
    ------------------------------------
    --1) 3개의 테이블 작성
    --테이블명: EX1
    -- num NUMBER PRIMARY KEY,
    -- name VARCHAR2(30) NOT NULL,
    
    CREATE TABLE ex1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL
    );
    
    --테이블명: EX2
    -- num NUMBER 기본키, ex1 테이블 num의 참조키
    -- birth DATE NOT NULL
    
    CREATE TABLE ex2(
        num NUMBER PRIMARY KEY REFERENCES ex1(num),
        birth DATE NOT NULL
    );
    
    -- 테이블명: EX3
    -- num NUMBER 기본키, ex1 테이블 num의 참조키
    -- score NUMBER(3) NOT NULL
    -- grade NUMBER(2,1) NOT NULL
    
    CREATE TABLE ex3(
        num NUMBER PRIMARY KEY REFERENCES ex1(num),
        score NUMBER(3) NOT NULL,
        grade NUMBER(2,1) NOT NULL
    );
    
    --2) 시퀀스 작성 ex_seq
    --초기: 1, 증분: 1, 캐시: X 
    CREATE SEQUENCE ex_seq
        START WITH 1
        INCREMENT BY 1
        nocycle
        NOCACHE;
    
    --ex1, ex2, ex3 테이블에 데이터를 추가하는 프로시저: pInsertEx
    --num은 시퀀스 이용
    --score >=90: 4.0
    --score >=80: 3.0,
    --score >=70: 2.0,
    --score >=60: 1.0,
    --나머지 0
    
    CREATE OR REPLACE PROCEDURE pInsertEx(
        pName ex1.name%TYPE, --프로시저는 크기를 정의할 수 없고 VARCHAR2 형식으로만 정의가 가능하다.
        pBirth ex2.birth%TYPE, -- 혹은 DATE
        pScore ex3.score%TYPE 
    )
    IS
        vNum   ex1.num%TYPE;
        vGrade ex3.grade%TYPE;
    BEGIN
        IF pScore < 0 OR pScore > 100 THEN 
            RAISE_APPLICATION_ERROR(-20001, '점수는 0~100점 사이여야 합니다.');
        END IF;
        
        IF pScore >= 90 THEN vGrade := 4.0;
        ELSIF pScore >= 80 THEN vGrade := 3.0;
        ELSIF pScore >= 70 THEN vGrade := 2.0;
        ELSIF pScore >= 60 THEN vGrade := 1.0;
        ELSE vGrade := 0.0;
        END IF;
        
        vNum := ex_seq.NEXTVAL;
        INSERT INTO ex1(num, name) VALUES(vNum, pName);
        INSERT INTO ex2(num, birth) VALUES(ex_seq.CURRVAL, TO_DATE(pBirth));--ex1의것을 참조하는 ex2는 자식이다
        INSERT INTO ex3(num, score, grade) VALUES(vNum, pScore, vGrade);
        --프로시저의 특성상 하나의 작업이 실패하면 모든 작업이 롤백되는 것을 감안한다.
        --이래서 자바로 코딩할 떄 프로시저를 사용하면 쉽다는 것!
        COMMIT;
        --프로시저는 DML만 사용한 경우 COMMIT을 입력해야 DB에 반영된다.
    END;
    /
    
    --score가 0~100이 아니거나 세 개의 테이블 중 하나의 테이블에 데이터가 추가되지 않으면
    --모든 테이블에 데이터가 추가되지 않아야 한다.
    --ex1: 번호, 이름 / ex2: 번호(외래키) , 생일 / ex3) 번호(외래키) 점수, 평점
    --실행 예)
    EXEC pInsertEx('홍길동', '2000-10-10', 95);
    EXEC pInsertEx('박길동', '2001-10-10', 77);
    EXEC pInsertEx('유길동', '2000-10-10', 64);
    EXEC pInsertEx('윤길동', '2000-10-10', 82);
    
--    drop table ex1 purge;
--    drop table ex2 purge;
--    drop table ex3 purge;
--    drop sequence ex_seq;
    
    SELECT * FROM ex1
    JOIN ex2 USING(num)
    JOIN ex3 USING(num);
    
-- ※ 함수(사용자정의함수는 결과를 return)
-- function은 반드시 return이 있어야 한다.
--     -------------------------------------------------------
    SELECT * FROM user_procedures WHERE OBJECT_TYPE='FUNCTION'; --함수 정보 확인
    SELECT * FROM USER_SOURCE;
    
    UPDATE emp SET rrn='000707-4574812' WHERE empNo='1014';
    UPDATE emp SET rrn='010210-3111111' WHERE empNo='1021';
    
    CREATE OR REPLACE FUNCTION fnGender(
        rrn VARCHAR2 --크기 명시 안 함
    )
    RETURN VARCHAR2 --반환형도 크기를 명시하지 않는다.
    IS
        s VARCHAR2(6) := '여자';
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '주민번호 자릿수는 하이픈(-)을 포함하여 14자리입니다. ');
            --JAVA로 치자면 THROW ERROR을 한 것과 같다.
        END IF;
        
        IF MOD(SUBSTR(rrn,8,1),2)=1 THEN 
            s := '남자';
        END IF;
        
        RETURN s;
    END;
    /
    
    CREATE OR REPLACE FUNCTION fnBirth(
        rrn VARCHAR2 --크기 명시 안 함
    )
    RETURN DATE
    IS
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '주민번호 자릿수는 하이픈(-)을 포함하여 14자리입니다. ');
            --JAVA로 치자면 THROW ERROR을 한 것과 같다.
        END IF;        
        RETURN TO_DATE(substr(rrn,1,6),'RRMMDD');
    END;
    /
    
    CREATE OR REPLACE FUNCTION fnAge(
        rrn VARCHAR2 --크기 명시 안 함
    )
    RETURN NUMBER
    IS
        a NUMBER;
        b DATE;
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '주민번호 자릿수는 하이픈(-)을 포함하여 14자리입니다. ');
            --JAVA로 치자면 THROW ERROR을 한 것과 같다.
        END IF;    
        
        b := TO_DATE(substr(rrn,1,6), 'RRMMDD');
        a := TRUNC(MONTHS_BETWEEN(SYSDATE,b)/12);                
        
        RETURN a;
    END;
    /
    
    
    SELECT name, 
    rrn, fnGender(rrn) 성별, 
    TO_CHAR(fnBirth(rrn),'YYYY"년"MM"월"DD"일"') 생일,
    fnAge(rrn)||'세' 나이
    from emp;
    
--
--     -------------------------------------------------------
--     -- 문제
--     -- score1 테이블 작성
--          hak     문자(20)  기본키
--          name   문자(30)  NOT  NULL
--          kor      숫자(3)     NOT  NULL
--          eng      숫자(3)    NOT  NULL
--          mat      숫자(3)    NOT  NULL

    CREATE TABLE score1(
        hak VARCHAR2(20) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL
    );
    
--      -- score2 테이블 작성
--          hak     문자(20)  기본키, score1 테이블의 참조키
--          kor      숫자(2,1)     NOT  NULL
--          eng      숫자(2,1)    NOT  NULL
--          mat      숫자(2,1)    NOT  NULL

    CREATE TABLE score2(
        hak VARCHAR2(20) PRIMARY KEY REFERENCES score1(hak),
        kor NUMBER(2,1) NOT NULL,
        eng NUMBER(2,1) NOT NULL,
        mat NUMBER(2,1) NOT NULL
    );
    
--     -- 평점을 구하는 함수 작성
--         -- 함수명 : fnGrade(s)
--             95~100:4.5    90~94:4.0
--             85~89:3.5     80~84:3.0
--             75~79:2.5     70~74:2.0
--             65~69:1.5     60~64:1.0
--             60미만 0

    CREATE OR REPLACE FUNCTION fnGrade(
     pScore NUMBER
    )
    RETURN VARCHAR2
    IS 
        vGrade NUMBER;
    BEGIN
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '점수의 범위는 0~100점 사이입니다.');
        END IF;
        
        IF pScore>=95 THEN vGrade := 4.5;
        ELSIF pScore >= 90 THEN vGrade :=4.0;
        ELSIF pScore >= 85 THEN vGrade :=3.5;
        ELSIF pScore >= 80 THEN vGrade :=3.0;
        ELSIF pScore >= 75 THEN vGrade :=2.5;
        ELSIF pScore >= 70 THEN vGrade :=2.0;
        ELSIF pScore >= 65 THEN vGrade :=1.5;
        ELSIF pScore >= 60 THEN vGrade :=1.0;
        ELSE vGrade := 0;
        END IF;
        
        RETURN vGrade;
    END;
    /
        
--      -- score1 테이블과 score2 테이블에 데이터를 추가하는 프로시저 만들기
--         프로시저명 : pScoreInsert
--         실행예 : EXEC pScoreInsert('1111', '가가가', 80, 60, 75);

        CREATE OR REPLACE PROCEDURE pScoreInsert(
            pHak score1.hak%TYPE,
            pName score1.name%TYPE,
            pKor score1.kor%TYPE,
            pEng score1.eng%TYPE,
            pMat score1.mat%TYPE
        )
        IS
        BEGIN
            INSERT INTO score1(hak, name, kor, eng, mat) VALUES(pHak, pName, pKor, pEng, pMat);
            INSERT INTO score2(hak, kor, eng, mat) VALUES(pHak, fnGrade(pKor), fnGrade(pEng), fnGrade(pMat));            
            COMMIT;
        END;
        /
--         score1 테이블 => '1111', '가가가', 80, 60, 75  정보 추가
--         score2 테이블 => '1111',            3.0, 1.0, 2.5 정보 추가(국, 영, 수 점수가 평점으로 계산되어 추가)
        EXEC pScoreInsert('1111','가가가',80,60,74);
        
        select * from score1
        JOIN score2 USING(hak);
--         단, 국여, 영어, 수학 점수는 0~100 사이가 아니면 예외 발생하고 종료
-- 
--     -- score1 테이블과 score2 테이블에 데이터를 수정하는 프로시저 만들기
--         프로시저명 : pScoreUpdate

        CREATE OR REPLACE PROCEDURE pScoreUpdate(
            pHak score1.hak%TYPE,
            pName score1.name%TYPE,
            pKor score1.kor%TYPE,
            pEng score1.eng%TYPE,
            pMat score1.mat%TYPE
        )
        IS
        BEGIN
            UPDATE score1 SET
                name = pName,
                kor = pKor,
                eng = pEng,
                mat = pMat
            WHERE hak = pHak;
            
            UPDATE score2 SET
                kor = fnGrade(pKor),
                eng = fnGrade(pEng),
                mat  = fnGrade(pMat)
            WHERE hak = pHak;
            COMMIT;
        END;
        /
        EXEC pScoreUpdate('1111','가가가',90,60,75);
        
        select * from score1
        JOIN score2 USING(hak);

--         실행예 : EXEC pScoreUpdate('1111', '가가가', 90, 60, 75);
--   
--         score1 테이블 => 학번이 '1111' 인 자료를  '가가가', 90, 60, 75  으로 정보 수정
--         score2 테이블 => 학번이 '1111' 인 자료를           4.0, 1.0, 2.5 으로 정보 수정(국, 영, 수 점수가 평점으로 계산되어 수정)
--   
--         단, 국여, 영어, 수학 점수는 0~100 사이가 아니면 예외 발생하고 종료
--   
--      -- score1 테이블과 score2 테이블에 데이터를 삭제하는 프로시저 만들기
--         프로시저명 : pScoreDelete
--         실행예 : EXEC pScoreDelete('1111');
--         score1 과 score2 테이블 정보 삭제
        
        CREATE OR REPLACE PROCEDURE pScoreDelete(
            pHak score1.hak%TYPE
        )
        IS
        BEGIN
            DELETE FROM score2 WHERE hak=pHak;
            DELETE FROM score1 WHERE hak=pHak;
            COMMIT;
        END;
        /

        EXEC pScoreDelete('1111');
        
        select * from score1
        JOIN score2 USING(hak);