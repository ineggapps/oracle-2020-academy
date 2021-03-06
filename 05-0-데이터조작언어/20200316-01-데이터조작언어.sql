--DML (Data Manupulation Language)

--INSERT
--UPDATE
--DELETE
--MERGE
--SELECT

--트랜잭션
--"한 번에 모두 수행되어야 하는 일련의 연산의 묶음"
--데이터베이스의 상태를 변환시키는 하나의 논리적 기능을 수행하기 위한 작업의 단위
--ex) 영화 선택 → 극장 선택 → 시간대 선택 → 인원수 및 좌석 선택 → 결제 → 티켓 발급
--  작업 단위를 완료하는 것을 COMMIT, 취소하는 것을 ROLLBACK이라고 한다.
-- + 팝콘 선택 → 구매 (이는 영화를 관람하기 위한 필수적인 연산이 아니며 별개의 연산이다)
--이러한 작업 단위(트랜잭션)이 컴퓨터 서버에 저장이 되어야 할 것이다.

--오라클에서는 INSERT, UPDATE, DELETE를 수행한 뒤에 자동으로 트랜잭션이 완료된 상태가 아니다.
--COMMIT: 트랜잭션을 완료하여 DB에 반영
-- INSERT 등 조작 이후에 COMMIT을 바로 하지 않으면 LOCK이 계속 걸려 있을 수 있음.
--ROLLBACK: 트랜잭션이 취소되므로 DB에 반영되지 않음
--단, DDL의 경우에는 자동 COMMIT된다.

--■ 데이터 조작언어(DML)
-- ※ INSERT
--   ο 단일 행 입력: 1개의 테이블에 1개의 행을 추가★
-------------------------------------------------------
    --기본 형식
    INSERT INTO 테이블명(컬럼명1, 컬럼명2, ...) VALUES (값1, 값2, ...);
    --모든 컬럼에 값을 추가하는 경우
    --단, 테이블을 선언했던 당시의 컬럼 순서대로 입력해야 한다는 것에 유념한다.
    INSERT INTO 테이블명(값1, 값2, ...);
    COMMIT 또는 ROLLBACK을 이용하여 연산을 확정하거나 취소하여 DB에 반영하여야 한다.
    --단, JAVA 등 외부에서 데이터를 추가하면 자동으로 COMMIT 연산을 수행해 준다.    
    --
    select * from tab;
    
    CREATE TABLE test1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        birth DATE NOT NULL,
        memo VARCHAR2(1000)
    );
    DESC test1;
    --모든 컬럼에 값을 추가하는 경우 컬럼명 생략 가능하다.
    --단, 테이블 작성 시 컬럼 작성 순서대로 입력해야 함.    
    INSERT INTO test1 VALUES(1,'김김김','2000-10-10','테스트입니다.'); --날짜는 자동변환되어 DATE형식으로 저장된다
    SELECT * FROM test1; 
    
    INSERT INTO test1 VALUES(2,'마마마','2000-10-10'); --오류: 컬럼 개수와 값이 일치하지 않는다. (컬럼은 4개인데, 값은 3개만 입력되었음)
    --ORA-00947:값의 수가 충분하지 않습니다.
    
    INSERT INTO test1 VALUES('마마마',2,'2000-10-10','테스트'); --오류: 테이블 컬럼의 자료형과 값이 불일치하다.
    --ORA-01722:수치가 부적합합니다.
    
    INSERT INTO test1 VALUES(2,'마마마','2000-10-10',''); --문자열의 길이가 0이면 NULL로 취급한다는 것 잊지 말자
    SELECT * FROM test1;

    --컬럼명 명시: 컬럼의 개수와 값이 다른 경우    
    INSERT INTO test1(num, name, birth) VALUES(3,'오오오','2000-10-10'); -- 언급하지 않은 MEMO항목에는 NULL값으로 삽입된다.
    INSERT INTO test1(num, name, birth, memo) VALUES(3,'노노노','2000-10-10','테스트'); --오류: ORA-00001: 무결성 제약 조건(기본키)에 위반됨
    SELECT * FROM test1;

    --현재 ORACLE DB 형식은 운영체제의 국가별 형식과 일치해야 한다.
    --현재 10/10/90은 한글 운영체제에서는 10년 10월 90일이므로 삽입이 불가능하다.
    INSERT INTO test1(num, name, birth, memo) VALUES(4,'노노노','10/10/90','테스트');--ORA001847: 달의 날짜는 1에서 말일 사이어야 합니다.
    --따라서 TO_DATE() 형식과 결합하여 사용하는 경우에는 지정한 형식에 따라 날짜를 알맞게 입력할 수 있다.
    INSERT INTO test1(num, name, birth, memo) 
    VALUES(4,'노노노',TO_DATE('10/10/90','MM/DD/RR'),'테스트');--ORA001847: 달의 날짜는 1에서 말일 사이어야 합니다.
    SELECT * FROM test1;
    
    INSERT INTO test1(num, name, memo) VALUES(5,'마마마','테스트');
    --NOT NULL 제약을 위반하였다. (BIRTH는 NOT NULL로 선언되어 있음)
    --오류: ORA-01400: NULL을 (SKY, TEST1, BIRTH) 안에 삽입할 수 없습니다.
    
    INSERT INTO test1(num, name, birth) VALUES(5,'마마마머머노노노가가가','2000-10-10');
    --name이 테이블 선언 당시 지정한 컬럼명의 타입 크기보다 크게 입력되었음.
    --ORA-12899: SKY.TEST1.NAME열에 대한 값이 너무 큼(실제:33, 최댓값:30)
    
    --★ TABLE에 데이터를 삽입할 때는 INTO 테이블명(컬럼명1, 컬럼명2, ..) 처럼 명시한 뒤에 VALUES를 지정해야 한다.
    COMMIT; -- COMMIT연산을 하지 않으면 다른 세션에서는 데이터가 추가되어 있지 않음을 확인할 수 있다.

    INSERT INTO test1(num, name, birth) VALUES(5,'마마마',SYSDATE);
    --시스템 날짜 추가
    SELECT * FROM test1;
    ROLLBACK; -- DB에 저장 취소
    SELECT * FROM test1;
    
    --test1테이블에 컬럼 추가하기
    ALTER TABLE test1 ADD (
        created TIMESTAMP --이미 데이터가 존재하므로 NOT NULL은 붙일 수 없음
    );
    DESC test1;
    SELECT * FROM test1;--이미 추가된 데이터에는 CREATED COLUMNS에는 NULL값으로 저장.
    
    -- 예제1) 데이터 추가
    --num:5번 name:가가가 birth:2000-10-10 created: 20101010
--    INSERT INTO test1(num,name, birth, created) VALUES(5,'가가가','20001010','20101010101010200'); --ORA-01830 날짜 형식의 지정에 불필요한 데이터가 포함되어 있습니다. (타임스탬프 형식에 맞지 않음)  
    INSERT INTO test1(num, name, birth, created) VALUES(5,'가가가','2000-10-10',TO_TIMESTAMP('20101010101010200','YYYYMMDDHHMISSFF3'));--FF3 밀리초를 3자리로 표시했다는 의미임
    COMMIT;
    SELECT * FROM test1;
    SELECT num, name, TO_CHAR(created,'YYYY-MM-DD HH:MI:SS.FF3') created from test1;
    
    -- 예제2) test2테이블 작성하기
    -- test2 테이블 작성
--		  hak   문자(30)  PRIMARY KEY
--		  name  문자(30)  NOT NULL
--		  kor   숫자(3)   NOT NULL
--		  eng   숫자(3)   NOT NULL
--		  mat   숫자(3)   NOT NULL
--		  tot   숫자(3)   가상컬럼  kor+eng+mat
--		  ave   숫자(4,1) 가상컬럼  (kor+eng+mat)/3
    CREATE TABLE test2(
        hak VARCHAR2(30) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL,
        tot NUMBER(3) GENERATED ALWAYS AS (kor+eng+mat) VIRTUAL ,
        ave NUMBER(4,1) GENERATED ALWAYS AS ((kor+eng+mat)/3) VIRTUAL
    );
    DESC test2;
    -- test2 테이블에 데이터 추가하기
    --hak:'1111', name:'이이이', kor:90, eng:80, mat:90
    INSERT INTO test2(hak, name, kor, eng, mat) VALUES('1111','이이이',90,80,90);
--    INSERT INTO test2 VALUES('1111','이이이',90,80,90,260,86.7); --오류 ORA-54013: insert 작업은 가상 열에서 허용되지 않습니다.
    COMMIT; -- COMMIT을 바로 수행하지 않으면 다른 곳에서 접근할 때 이전에 조작한(MANIPULATION) 데이터가 반영되지 않는다.
    SELECT * FROM test2;

--   ο subquery
--  동시에 1의 테이블에 2개 이상의 행을 추가할 수 있음.
--     -------------------------------------------------------
    --기존 테이블을 이용하여 새로운 테이블을 작성하고 기존 테이블의 데이터 값도 복사
    CREATE TABLE 테이블명 AS SELECT * FROM 데이터가 있는 테이블명 [WHERE 조건];
    --존재하는 테이블에 값을 복사
    INSERT INTO 테이블명[(컬럼명, 컬럼명)] subquery;
    --테이블의 구조만 복사하여 만들기
    CREATE TABLE emp1 AS
        SELECT empno, name, dept, pos from emp WHERE 1=0;
    --단, 제약조건 NOT NULL을 제외하고는 복사되지 않는다.
    SELECT * FROM emp1;
    DESC emp1;
    
    --emp테이블에서 개발부의 내용만 복사하여 emp1테이블에 삽입하기.
    INSERT INTO emp1
        SELECT empno, name, dept, pos FROM emp
        WHERE dept='개발부';
    SELECT * FROM emp1;
    COMMIT; --데이터 삽입이 올바르게 되었으면 COMMIT,
    --ROLLBACK; -- 데이터 삽입이 잘못되었다면 ROLLBACK을 실행하고 다시 올바른 연산을 수행하여 COMMIT;    
--
--
--   ο unconditional INSERT ALL (조건이 없는 INSERT ALL)
--  2개 이상의 테이블에 2개 이상의 값을 추가할 수 있다.
-------------------------------------------------------  
     CREATE TABLE emp3 AS
	   SELECT empNo, name, dept, pos FROM emp WHERE 1=0;
	 CREATE TABLE emp4 AS
	   SELECT empNo,sal, bonus FROM emp WHERE 1=0;
	 
     SELECT * FROM TABS;
     
	 INSERT ALL 
     INTO  emp3 VALUES(empNo, name, dept, pos)  --일치하면 emp3[(컬럼명)] <- 은 생략할 수 있다.
     INTO  emp4 (empNo,sal, bonus) VALUES(empNo,sal, bonus) --emp4(emp4의 컬럼명) values(emp의 컬럼명)
     SELECT * FROM emp; --source
     COMMIT;
     SELECT * FROM emp3;
     SELECT * FROM emp4;
    
    -- ★ 두 개의 테이블에 새로운 행 하나씩 추가하는 방법
    -- 알아두면 나중에 유용하게 사용할 수 있다.
    -- 예) 회원가입 시 신규 회원 하나의 정보를 여러 개의 테이블에 분할하여 저장할 때 유용
    INSERT ALL
    INTO emp3(empno, name, dept, pos) VALUES('9999', '머머머', '개발부', '사원')
    INTO emp4(empno, sal, bonus) VALUES ('9999', 1000000, 50000)
    SELECT * FROM dual;
    
    SELECT * FROM emp3; --입력 확인
    SELECT * FROM emp4; --입력 확인
    COMMIT;

--   ο conditional INSERT {ALL | FIRST} 조건이 있는 INSERT ALL
    --FIRST는 처음 것만 넣는다.
--      ------------------------------------------------------S
    CREATE TABLE emp5 AS
        SELECT empno, name, rrn, dept, pos FROM emp WHERE 1=0;
    CREATE TABLE emp6 AS
        SELECT empno, name, rrn, dept, pos FROM emp WHERE 1=0;
    
    --rrn컬럼을 이용하여 남자와 여자 사원을 분리하여 저장
    INSERT ALL
        WHEN mod(substr(rrn,8,1),2)=1 THEN 
            INTO emp5 VALUES(empno, name, rrn, dept, pos)
        WHEN mod(substr(rrn,8,1),2)=0 THEN
            INTO emp6 VALUES(empno, name, rrn, dept, pos)
        SELECT * FROM emp;
        
    SELECT * FROM emp5; --남자사원
    SELECT * FROM emp6; --여자사원
    COMMIT;
    
    DROP TABLE emp1 PURGE;
    DROP TABLE emp2 PURGE;
    DROP TABLE emp3 PURGE;
    DROP TABLE emp4 PURGE;
    DROP TABLE emp5 PURGE;
    DROP TABLE emp6 PURGE;
    
    SELECT * FROM tab;


-- ※ UPDATE
--   ο UPDATE 
--  기존 레코드 수정
--  실제로는 해당 레코드를 지우고 다시 삽입하는 과정을 수행하는 것이다. (그러므로 DML연산 중 가장 느리다고 할 수 있다.)
--     -------------------------------------------------------
    UPDATE 테이블명 SET 컬럼명1=값1, 컬럼명2=값2 WHERE 조건;
    --CAUTION: WHERE절이 없으면 모두 수정된다.
    --COMMIT 또는 ROLLBACK이 필요한 연산이다.
    -- 자바 등 외부에서 수정할 경우 기본적으로 COMMIT된다.
    
    SELECT * FROM EMP;
    UPDATE emp SET name='스프링'; 
    --위 쿼리는 모든 레코드가 수정되며, 실무에서 위의 SQL을 사용하지 않는다. 조건절 반드시 명시!!!
    SELECT * FROM EMP;
    ROLLBACK;
    
    --새로운 샘플 데이터 삽입 (emp_score 테이블)
    DESC emp_score;
    SELECT * FROM emp_score;
    
    --emp_score: empno=1002의 레코드의 com=90, excel=95로 변경
    UPDATE emp_score SET com=90, excel=95 WHERE empno=1002;
    SELECT * FROM emp_score WHERE empno=1002; --수정된 것을 확인할 수 있다.
    COMMIT; --DB에 반영
    
--  복습을 위한 예제
--  예제1) emp_score: empno, com, excel, word, tot, ave, grade
--  tot: com+excel+word
--  ave: (com+excel+word)/3 (단, 소숫점은 2째 자리에서 반올림)
--  grade: 모든 과목 점수가 40점 이상이고 평균이 60점 이상이면 합격
--  평균이 60점 이상이고 한 과목이라도 40점 미만이면 과락
--  평균이 60점 미만이면 과락
-- SELECT문으로 조회가 될 수 있도록 작성하기.
    SELECT 
        empno, com, excel, word, 
        (com+excel+word) tot, 
        round((com+excel+word)/3,2) ave,
        CASE 
            WHEN (com+excel+word)/3 >= 60 AND (com>=40 AND excel >=40 AND word >=40) THEN '합격'
            WHEN (com+excel+word)/3 <60 THEN '불합격'
            ELSE '과락'
        END grade
    FROM emp_score;

--  서브쿼리를 이용한 수정
    SELECT empno FROM emp WHERE dept='개발부';
    SELECT * FROM emp_score WHERE empno IN (SELECT empno FROM emp WHERE dept='개발부');

    --개발부 소속 직원들만 엑셀 점수를 100점 가산하기.
    UPDATE emp_score SET excel=excel+100 WHERE empno IN (SELECT empno FROM emp WHERE dept='개발부');
    SELECT * FROM emp_score;
    ROLLBACK; --연산을 DB에 반영하지 않음.
    
    UPDATE emp_score SET com=(SELECT 100 FROM dual) WHERE empNo = '1001'; --수정할 대상의 컬럼이 1개이므로 com=(SELECT문) 에서 SELECT문의 결괏값은 행이 1개여야 한다.
    SELECT * FROM emp_score WHERE empno = '1001';
    
    UPDATE emp_score SET (excel, word)=(SELECT 100, 100 FROM dual) WHERE empno='1001'; -- SET에서 지정한 컬럼의 개수만큼 SELECT문의 결과도 컬럼의 개수가 같아야 한다.
    SELECT * FROM emp_score WHERE empno = '1001';
    
    --제약조건에 위배되는 경우(EX: NOT NULL컬럼인데 NULL로 설정하는 경우 등)에는 수정할 수 없다.
    --따라서 반드시 수정되는 것은 아님.
    --제약조건을 위반한 예)
    SELECT * FROM emp_score;
    DESC emp_score;
--  empno: 기본키이면서 emp테이블의 참조키이다. PRIMARY KEY, FOREIGN KEY
    UPDATE emp_score SET empno='1002' WHERE empno='1001'; --오류ORA-00001: 무결성 제약조건에 위배됩니다. 
    --empno가 1002인 데이터가 이미 존재하므로 기본키를 가진 컬럼은 중복을 허용하지 않는다.
    UPDATE emp_score SET empno='9999' WHERE empno='1001'; --오류ORA-02291: 무결성 제약조건(SKY.FK_EMP_SCORE_NO)이 위배되었습니다. - 부모 키가 없습니다.
    --emp_scores의 empno는 emp의 empno를 참조키로 emp테이블에 없는 값으로는 수정이 불가능하다.
       
-- ※ DELETE
--   ο DELETE
---------------------------------------------------------
    -- 불필요한 레코드의 삭제
    -- UPDATE와 마찬가지로 WHERE조건절을 지정하지 않으면 테이블 안에 있는 모든 레코드가 일괄적으로 삭제된다.
    -- COMMIT 또는 ROLLBACK이 필요하지만 자바 등 외부에서 삭제 시 자동으로 COMMIT되는 것에 주의한다.
    DELETE [FROM] 테이블명 [WHERE 조건];
    --오라클에서는 DELETE 테이블명도 가능하지만, 타 DB에서는 DELETE FROM으로 선언해야 한다.

    CREATE TABLE emp1 AS SELECT * FROM emp;
    CREATE TABLE emp_score1 AS SELECT * FROM emp_score;
  
    SELECT * FROM emp1;
    SELECT * FROM emp_score1;

    --영업부 사원의 행만 삭제하는 방법
    SELECT * FROM emp1;
    DELETE FROM emp1 WHERE dept='영업부';
    SELECT * FROM emp1;
    COMMIT;
    
    --서브쿼리를 이용하여 삭제하는 방법
    DELETE FROM emp_score1 WHERE empNo IN(SELECT empno FROM emp1 WHERE dept='개발부');
    SELECT * FROM emp_score1;
    COMMIT;
    
    DELETE FROM emp1; --모두 삭제하는 방법. 구조는 삭제되지 않음.
    DELETE FROM emp_score1;
    COMMIT;
    
    DESC emp1;
    DESC emp_score1;
  
    DROP TABLE emp1 PURGE;
    DROP TABLE emp_score1 PURGE;
    
    SELECT * FROM TAB;
    
    --테이블 백업
    CREATE TABLE EMP_BACKUP AS SELECT * FROM EMP;
    
    --실수로 삭제한 경우... 어떻게 하는지?
    DELETE FROM emp WHERE city='서울';--ORA-02292: 무결성 제약조건(SKY.FK_EMP_SCORE_NO)에 위배되었습니다. - 자식 레코드가 발견되었습니다.
    DELETE FROM emp_score;
    DELETE FROM emp WHERE city='서울';--ORA-02292: 무결성 제약조건(SKY.FK_EMP_SCORE_NO)에 위배되었습니다. - 자식 레코드가 발견되었습니다.
    
    SELECT * FROM emp;
    COMMIT;
    SELECT * FROM emp WHERE city='서울';

    --실수로 삭제한 경우 
    --10분 전의 emp테이블을 확인한다
    SELECT * FROM emp;--현재의 행
    SELECT * FROM emp AS OF TIMESTAMP (SYSTIMESTAMP-INTERVAL '10' MINUTE);
    
    --10분의 emp테이블로 복원
    INSERT INTO emp (
        SELECT * FROM emp AS OF TIMESTAMP (SYSTIMESTAMP-INTERVAL '10' MINUTE)
        where city='서울'
    );
    COMMIT;
    SELECT * FROM emp;
    
    --10분의 emp_score 테이블로 복원
    SELECT * FROM emp_score; --다 지워버렸으므로... 조건 없이 그냥 실행한다
    SELECT * FROM emp_score AS OF TIMESTAMP (SYSTIMESTAMP-INTERVAL '10' MINUTE);
    INSERT INTO emp_score(
        SELECT * FROM emp_score AS OF TIMESTAMP (SYSTIMESTAMP-INTERVAL '10' MINUTE)
    );
    COMMIT;
    SELECT * FROM emp_score;
    
    SELECT * FROM EMP ORDER BY EMPNO;
    --만약에 DB작업이 꼬인 경우에는 웹서버를 중지하여 데이터의 변경을 방지하고, 빠른 시간 내에 복구를 시도한다.
    
-- ※ MERGE
--   ο MERGE
--  테이블을 병합하는 것
--  조건을 만족하면 기존에 존재하는 값을 수정할 수 있고,
--  조건을 만족하지 않으면 기존에 존재하는 값에다가 새로운 값을 추가하는 것이다.
--  merge문을 사용하면, 여러 개의 insert, update 및 delete dml문을 피할 수 있지만 보통은 따로 작성한다.
--  보통 테이블을 병합할 때 값이 존재하면 수정하고 값이 존재하지 않으면 새로운 값을 삽입할 목적으로 사용된다.
---------------------------------------------------------

    CREATE TABLE emp1 AS 
    SELECT empno, name, city, dept, pos, sal FROM emp
    WHERE city='인천';
    
    CREATE TABLE emp2 AS 
    SELECT empno, name, city, dept, pos, sal FROM emp
    WHERE dept='개발부';

    MERGE INTO emp1 e1 --출신지가 인천인 직원
                USING emp2 e2 --부서 소속이 개발부인 직원
                --테이블에 똑같은 컬럼이 존재하므로 어떤 테이블의 컬럼인지를 명시해야 한다.
                --ON(e1의 empno와 e2의 empno가 같은 것이 있으면) == 개발부이면서 출신지가 인천인 직원이라면?
                ON (e1.empno = e2.empno)
                WHEN MATCHED THEN --ON의 조건과 일치하면
                        UPDATE SET e1.sal = e1.sal + e2.sal --원 급여의 1배수를 더한다.
                WHEN NOT MATCHED THEN --ON의 조건과 일치하지 않으면 (USING테이블에만 있는 직원이면)
                        INSERT (e1.empno, e1.name, e1.city, e1.dept, e1.pos, e1.sal) --emp1의 컬럼을 지정하고
                        VALUES (e2.empno, e2.name, e2.city, e2.dept, e2.pos, e2.sal);  --emp2의 값을 emp1테이블에 삽입한다.
            
    SELECT * FROM emp1;
    COMMIT;
    
    