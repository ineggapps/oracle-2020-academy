--데이터 정의언어
--만들면 자동으로 COMMIT되므로 ROLLBACK을 할 수 없음. (연산을 되돌릴 수 없음)
--데이터 사전
-- EX) TABS  테이블 목록
-- EX) COLS 테이블의 컬럼 목록

--CREATE TABLE, VIEW, INDEX 등을 정의
--ALTER 생성된 테이블 등의 객체를 수정
--DROP 테이블, 객체 등을 삭제
--RENAME 생성된 객체의 이름 변경
--TRUNCATE 테이블의 모든 데이터 삭제
--truncate: d. (컴퓨터) 절단하다, 계산 과정을 종결짓다 - 동아사전

--데이터 타입

--테이블의 컬럼 정보 출력
SELECT * FROM USER_TAB_COLUMNS;
SELECT * FROM COLS;
SELECT * FROM COL;
--desc emp;
--SELECT DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, CHAR_USED FROM USER_TAB_COLUMNS
--WHERE TABLE_NAME='테이블명';

--CHAR을 잘 사용하지 않는 EU
--최대 2000byte (한글 600여 자), 최솟값 1byte
--1) CHAR(4) → 한 글자(A) 삽입 시 "A"가 아니라 "A   "로 저장된다. 
--   SELECT ... FROM 테이블 WHERE 컬럼명='A' 비교할 때 결괏값이 의도한 대로 나오지 않는다.
--2) 메모리 효율성 CHAR(4)에서 로드하면 "A   "를 로드하여 메모리 효율성이 떨어진다.
--다만 고정된 값(주민등록번호 등)을 보관할 때는 사용하기도 한다.

--VARCHAR2(N) 꼭 알고 있어야 한다. (Mysql에서는 VARCHAR임)
--최대 4000byte (한글 1300여 자), 최솟값 1byte
--"A"라는 글자를 삽입할 때 크기를 1byte로 지정하여 삽입한다.
--따라서 SELECT ... FROM 테이블 WHERE 컬럼명='A'를 비교가 가능하다.
--"A"라는 글자가 추가된 상태에서 5자 "AAAAA" 삽입을 시도하면 오류가 발생한다.
--왜냐하면 "A"라는 글자가 입력될 때 이미 크기는 1byte로 지정하여 입력되었기 때문이다.

--■■■VARCHAR은 절대로 오라클에서 절대 절대 절대 사용하지 않는다■■■
--크기가 4byte인 공간에 "A"를 삽입하면 나머지 공간에는 null값으로 채워진다.
--오라클에서는 사용을 권장하지 않는다.
--궁금해 하지도 말 것.
--MYSQL의 VARCHAR과는 다른 개념이니까 주의할 것.

--숫자는 NUMBER (최대 정수 38자까지 입력 가능)
--
--NUMBER(지정안함): ±정수 38자
--NUMBER(±숫자 전체 P자리(소숫점 포함), 소숫점S자리(-84~+127)) 정밀도를 표현할 수 있는 옵션
--단, 소숫점은 세지 않는다. 숫자가 넘치면 오류가 발생한다.
--NUMBER(2,3)의 경우 소숫점 0.001~0.099까지만 가능하다 (0.01은 값이 넘치므로 저장이 불가능하다)
--NUMBER(3,-1)의 경우 1의자리는 저장할 수 없다는 이야기이다.
--NUMBER(10,3)에서 1234567.6789는 자릿수는 넘치지만 소숫점에서 반올림처리가 된다.
--NUMBER(10,3)에서 12345678.678 입력 시에는 오류가 발생한다.

--■ 데이터 정의 언어(Data Definition Language)
-- ※ 데이터 정의 언어(DDL) 및 데이터 타입
--
--   ο 데이터 타입 - 개요
--      - 데이터 타입 정보 확인
--         SELECT DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, CHAR_USED
--         FROM USER_TAB_COLUMNS
--         WHERE TABLE_NAME ='테이블명';
--
-- ※ 테이블 생성 및 수정 삭제
--   ο 테이블 생성 
--    CREATE TABLE 테이블명(
--        컬럼명 데이터타입(크기) [제약조건] [NOT NULL],
--        컬럼명 데이터타입(크기) [제약조건] [NOT NULL], ...
--    );
--     ---------------------------------------------------------------
--  테이블명: test=> 다른 객체명과 중복될 수 없다. 데이터 사전에는 대문자로 저장된다.
--    컬럼명, 컬럼 타입, 크기(폭), 제약 조건, NULL여부
--      num       숫자      10      기본키         X
--      name     문자       30                       X
--      birth      날짜      (고정)    
--      city       문자      30
    
        CREATE TABLE test(
            num NUMBER(10) primary key,
            name VARCHAR2(30) not null,
            birth DATE,
            city  VARCHAR2(30)
        );
        select * from tab; --테이블의 존재 여부
        select * from tab where tname='TEST'; --특정 테이블만 검색
        select * from tab where tname=UPPER('test');
   
        select * from COL where tname='TEST';
        select * from COLS where TABLE_NAME='TEST'; -- 테이블 구조 확인: 잘 생성되었음을 확인할 수 있음.
        desc TEST; --실제 기본 명령어는 아니다. JAVA에서 이 명령어를 통해 테이블 목록을 확인할 수 없다.
        --SQLPLUS, SQL DEVELOPER 등 지원해주는 툴에서만 가능한 명령어이다. 이 점에 유의한다.
        
--
--   ο 테이블 생성 - 가상 컬럼(virtual column)
--      GENERATED ALWAYS AS ~ VIRTUAL
--      디스크에 저장되지 않는 컬럼으로 보통 수식이나 함수 등을 기술한다
--      SYSDTE 등 동적인 결과는 가질 수 없다.
--      값을 추가하거나 수정할 수 없다.
--     ---------------------------------------------------------------
    CREATE TABLE demo(
        id VARCHAR2(30) PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL,
        --11g 이상에서는 수식을 저장할 수 있다. 
        --값을 저장하는 것이 아니라 수식을 저장하는 것을 가상 컬럼이라고 한다.
        tot NUMBER(3) GENERATED ALWAYS AS (kor+eng+mat) VIRTUAL,
        ave NUMBER(4,1) GENERATED ALWAYS AS ((kor+eng+mat)/3) VIRTUAL
    );
    SELECT * FROM tab;
    SELECT * FROM col WHERE tname='DEMO';
    DESC demo;
    SELECT * FROM demo;

--   ο 테이블 생성 - subquery를 이용한 테이블 생성 
--     ---------------------------------------------------------------
--     서브 쿼리 컬럼의 개수와 만들고자 하는 신규 테이블 컬럼의 개수가 일치해야 한다.
--     데이터도 복사: NOT NULL을 제외한 "제약조건"은 복사되지 않음.
--      아래에서 emp1의 테이블은 emp테이블의 내용이 복사되지만
--    NOT NULL을 제외한 기본키 등의 제약조건은 복사되지 않는다.
        CREATE TABLE emp1 AS 
        SELECT empno, name, sal, bonus, sal+bonus pay from emp;
        --오류: 컬럼명 규칙 위반 (sal+bonus)는 컬럼명으로 지정할 수 없음
        --따라서 별칭을 지정하여 해결하여야 한다.
        SELECT * FROM COL WHERE TNAME='EMP1';
        SELECT * FROM tab;
        DESC EMP;
        SELECT * FROM EMP1;
        --제약조건 확인
        SELECT * FROM USER_CONSTRAINTS; --각 테이블의 제약조건을 확인할 수 있다.
        --컬럼 중 CONSTRAINT_TYPE에서 P값은 PRIMARY KEY(기본키)를 의미한다.
        --컬럼 중 CONSTRAINT_TYPE에서 U값은 UNIQUE KEY를 의미한다.  
        --컬럼 중 CONSTRAINT_TYPE에서 C는 NOT NULL 등의 제약조건을 의미한다. 
        --바로 NOT NUL을 제외하고 이러한 제약조건들이 복사가 안 된다는 것이다.
        
        -- 컬럼명을 지정하여 존재하는 테이블을 이용해서 테이블을 만들고
        -- 테이블의 내용을 복사한다.
        -- 기존 테이블의 컬럼명과는 다르게 컬럼명을 각각 명명할 수 있다.
        CREATE TABLE emp2(num, name, birth) as 
        SELECT empno, name, to_date(substr(rrn,1,6))
        from emp;
        
        SELECT * FROM tab;
        DESC emp2;
        SELECT * FROM emp2; --데이터가 잘 삽입되었는지 확인하기
        
        --테이블의 구조만 그대로 가져오고 안에 든 데이터는 제외하여 가져오고 싶을 때
        SELECT * FROM emp;
        SELECT * FROM emp WHERE 1=2;

        CREATE TABLE emp3 AS SELECT * FROM emp WHERE 1=2;
        --NOT NULL을 제외한 제약 조건은 복사되지 않았다.
        
        SELECT * FROM emp3; --데이터가 삽입되어 있지 않은 것을 확인할 수 있다.
        DESC emp3;
        
--   ο ALTER TABLE ~ ADD 
--      테이블의 구조를 고치자! - 컬럼을 더해 보자!
--     ---------------------------------------------------------------
        DESC test;
        ALTER TABLE test ADD(
            dept VARCHAR2(30),
            sal NUMBER(3) NOT NULL
        );
        
        DESC emp2;
        SELECT * FROM emp2;
        ALTER TABLE emp2 ADD(city VARCHAR2(30)); --실행됨.  (기존 튜플들의 city 값은 NULL을 가진다)
        ALTER TABLE emp2 ADD(
            dept VARCHAR2(30) NOT NULL
            --오류: emp2테이블 내에 데이터가 이미 존재하므로 NOT NULL 제약조건이 불가능하다.
        );
        
        -- 예제1) emp 테이블을 이용하여 emp4 테이블 작성
        -- 1-1)    emp 자료 중 dept가 개발부인 empNo, name, rrn, dept 복사
                    CREATE TABLE emp4 AS 
                    SELECT empNo, name, rrn, dept FROM emp where dept='개발부';
                    SELECT * FROM emp4;
        -- 1-2)    emp4테이블에 birth 가상 컬럼 추가
                    ALTER TABLE emp4 ADD(
                    --GENERATED ALWAYS AS 수식 VIRTUAL
--                        birth date GENERATED ALWAYS AS (to_date(substr(rrn,1,6),'RRMMDD')) VIRTUAL --작성 답안
                          birth date GENERATED ALWAYS AS (substr(rrn,1,6)) VIRTUAL --선생님 답안
                        -- 날짜 형식으로 변환할 수 있는 문자열이라면 자동으로 변환을 수행해 준다.
                        --가상 컬럼에서는 'RRMMDD' 생략 불가능
                    );
        --          rrn을 이용하여 생일만 추출하여 대입 (DATE형으로)
                DESC emp4;
                SELECT * FROM emp4;
-- 막간의 TIP : PURGE RECYCLEBIN;
--purge 미국식 [p?ːrd?]  영국식 [p?ːd?]  중요
--1. (조직에서 사람을, 흔히 폭력적인 방법으로) 제거하다
--2. (나쁜 생각감정을) 몰아내다
--3. (조직에서 사람을, 흔히 폭력적인 방법으로) 제거

--   ο ALTER TABLE ~ MODIFY
--      테이블의 구조를 고치자! - 컬럼의 속성을 변경해 보자!
--     ---------------------------------------------------------------
--      컬럼 데이터 타입이나 폭 등을 변경한다.
--      단, 이미 데이터가 존재하는 데이터보다 적게 폭을 변경할 수 없다.
--      이미 데이터가 존재하는 경우 타입이 변경가능한 경우만 변경할 수 있다.
--     EX) 모든 숫자는 문자로 바꿀 수 있음 NUMBER => VARCHAR2
--          그러나 VARCHAR2 => NUMBER로는 항상 가능한 것은 아니다.
    
    ALTER TABLE test MODIFY(sal NUMBER(10)); --기존의 크기 3에서 10으로 변경되었다.
    DESC test;
    
    select * from emp2;
    ALTER TABLE emp2 MODIFY(
        name VARCHAR2(8)--오류 (일부 값이 지정한 8보다 크기가 크므로 열 길이를 줄일 수 없다.
    );