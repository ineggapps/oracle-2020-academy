--복습

--테이블 만들기
--간단한 테이블 만들기 문법
--CREATE TABLE 테이블명(
--    컬럼명 타입[(크기)] [제약조건],
--    컬럼명 타입[(크기)] [제약조건],
--    컬럼명 타입[(크기)] [제약조건], ...
--);

--중요한 타입
--VARCHAR2: 텍스트 저장(1~4000bytes) --12c이상에서는 4000bytes 이상 저장 방법이 있음.
--DATE
--NUMBER: 유효자리 → 38자리
--CLOB: 대용량 텍스트 데이터 타입 (but, 속도가 떨어지므로 필요한 곳에만 타입을 지정)
--BLOB: 대용량 2진 파일을 저장

--테이블 컬럼 추가하기
--ALTER TABLE 테이블명 ★ADD★(
--    컬럼명 타입[(크기)] [제약조건],
--    컬럼명 타입[(크기)] [제약조건],
--    컬럼명 타입[(크기)] [제약조건], ...
--)

--테이블 컬럼 수정하기
--※주의사항 
--이미 데이터가 존재하면 컬럼의 구조를 수정할 수 없음.
--데이터가 존재하면 크기를 줄일 수 없음
--ALTER TABLE 테이블명 ★MODIFY★(
--  컬럼명 타입[(크기)] [제약조건],
--)

--가상 컬럼 (VIRTUAL)
--데이터를 가지고 있지는 않고 수식을 가지고 있음.
--GENERATED ALWAYS AS 수식 VIRTUAL

--   ο ALTER TABLE ~ RENAME COLUMN
--   컬럼의 이름을 변경한다
--  ---------------------------------------------------------------
    ALTER TABLE 테이블명 RENAME COLUMN 변경하고자 하는 컬럼명 TO 새로운 이름
    DESC emp2;
    --EMP2의 NUM => EMPNO라는 컬럼명으로 변경하는 방법
    ALTER TABLE emp2 RENAME COLUMN num TO empno;
    DESC emp2;
    
--
--   ο ALTER TABLE ~ DROP COLUMN
--  불필요한 컬럼을 삭제한다
--     ---------------------------------------------------------------
--    ALTER TABLE 테이블명 DROP COLUMN 컬럼명
    DESC test;
    --test 테이블의 desc 컬럼을 삭제하기
    ALTER TABLE test DROP COLUMN dept;
    DESC test;
    
    --emp2테이블의 name컬럼을 삭제하기
    SELECT * FROM emp2;
    ALTER TABLE emp2 DROP COLUMN name;
    --컬럼을 지우면 데이터가 이미 존재하는 경우 같이 삭제된다(당연하지).
    SELECT * FROM emp2;

--   ο ALTER TABLE ~ SET UNUSED
--   데이터가 존재하는 컬럼을 삭제하면 시간이 많이 소요되므로 컬럼은 삭제하지 않고
--   컬럼 사용을 논리적으로 제한 (∵ 데이터가 많이 존재하면 삭제하는 데에도 시간이 많이 걸린다)
--   ★ 데이터는 지워지지 않으나 절대 복구할 수 없음.
--1 Answer. You cannot reuse a unused column.
--  The only possible action on the column is to remove it from the table.
--  But you can add a new column with the same name, even without removing the unused column
-- https://stackoverflow.com/questions/13657497/how-to-reuse-the-unused-columns-again-in-oracle-db
-------------------------------------------------------------------------
    desc emp1;
    --emp1 테이블에서 pay 컬럼을 삭제
    ALTER TABLE emp1 SET UNUSED (pay);
    desc emp1;
    select * from emp1;
--
--
--   ο ALTER TABLE ~ SET UNUSED에 의해 논리적으로 삭제된 컬럼의 정보 확인
--  다만 테이블별로 지워진 컬럼의 개수만 확인이 가능하고 지워진 컬럼명에 대한 정보는 절대 확인이 불가능하다.
---------------------------------------------------------------
   SELECT * FROM USER_UNUSED_COL_TABS;
--   TABLE_NAME, COUNT
--   EMP1, 1

--   ο ALTER TABLE ~ DROP UNUSED COLUMNS
--   UNUSED_COLUMN에 의해 논리적으로 삭제된 컬럼을 실제로 삭제하는 방법
--     ---------------------------------------------------------------
    ALTER TABLE emp1 DROP UNUSED COLUMNS;
    --지워진 후 확인 방법
    SELECT * FROM USER_UNUSED_COL_TABS;
--
--   ο  테이블 삭제
--    한 번 지우면 물리적으로 지우는 작업을 수행하기 때문에 복구가 불가능하다고 기억!
--    구조도 지우고 내용도 지운다.
-----------------------------------------------------------------
    DROP TABLE 테이블명; --휴지통으로 이동(복구 가능)
    DROP TABLE 테이블명 PURGE; -- 바로 지워짐 (복구가 불가능하다)
--  테이블 구조 및 테이블의 내용 모두 삭제
--  테이블을 삭제할 경우 기본적으로는 휴지통에 들어간다.
--  명령어를 실행한다고 해서 무조건 지워지지는 않는다. 제약조건에 의해 삭제가 실패할 수도 있음.
--  강제로 삭제하는 옵션은 나중에...
    DESC demo;
    SELECT * FROM demo;
    DESC test;
    SELECT * FROM test;
    
    DROP TABLE demo; --휴지통으로
    DROP TABLE test; --휴지통으로
    SELECT * FROM TAB; -- 삭제한 테이블은 BIN$~ 로 이름이 변환되었을 것이다. 
    
    DROP TABLE emp4 PURGE; --휴지통을 거치지 않고 바로 삭제
    SELECT * FROM tab; --완전 삭제되었으므로 복구할 수 없다.
    
--  보충자료 ★ 사용자 추가 (기본 권한은 sys, system만이 가능하다)
--  오라클은 설치되면 1개의 데이터베이스를 공유하여 나눠쓰는 개념
--  데이터베이스를 만들 수 있는 권한은 유일하게 sys만 가능하다.
--  (∵ DB 1개당 프로세스 1개가 늘어난다)
--  Mysql의 경우에는 여러 개의 데이터베이스를 사용자별로 각자 쓰는 개념
--  1. 사용자 계정 생성
    CREATE USER sky IDENTIFIED BY "암호"; --12c버전부터는 이렇게 선언할 수 없음.
-- 18c에서 11g방식 사용자 추가 설정(12c이상은 기본적으로 c##사용자명 형식으로 사용자가 추가된다.
-- 11g처럼 만들기 위해서는 ALTER SESSION SET "_ORACLE_SCRIPT" = true; 로 선언하면 가능하다.
-- 옵션은 수행할 때마다...
--  2. 사용자에게 권한 부여
    GRANT CONNECT, RESOURCE TO sky; --사용자에게 접속할 수 있는 권한을 부여한다.
--  CONNECT: DB에 접속할 수 있는 권한
--  RESOURCE: 테이블 스페이스(논리적으로 저장할 수 있는 DB의 공간)에 접근가능하능한 권한
    ALTER USER sky DEFAULT TABLESPACE USERS;
--  3. 사용자가 사용할 테이블스페이스 지정
--  기본적으로 TABLESPACE를 사용할 권한을 주면 시스템 관리자가 사용하는 공간으로 지정된다.
--  이러한 경우 이 공간이 손상되면 시스템 계정까지 영향을 미치므로 다른 공간으로 할당한다.   
    ALTER USER sky TEMPORARY TABLESPACE TEMP; 
--  TEMPORARY는 GROUP BY 등의 연산을 수행하는 임시적인 공간을 의미함.
--  4. 사용자가 사용할 테이블스페이스 (12c이상부터) 용량을 지정해야 사용이 가능하다.
--  SKY에게 무제한으로 공간을 사용할 수 있도록 권한을 할당하여 줌.
    ALTER USER sky DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--
--   ο RENAME
--   객체명(테이블명)을 바꿀 때 사용
-----------------------------------------------------------------
--   RENAME 옛이름 TO 새이름;
    RENAME emp2 TO demo;
    SELECT * FROM tab;
--
--   ο 휴지통(RECYCLEBIN) 정보 확인
--    - 삭제된 개체(objects)확인
--     ---------------------------------------------------------------
    SELECT * FROM TAB; -- 삭제된 테이블 2개가 확인된다.
    SELECT * FROM RECYCLEBIN; --테이블, 인덱스 등 삭제된 정보를 확인할 수 있다.
    --테이블에서 사용된 인덱스가 삭제된 내역까지 보인다.
    --TIP: 기본키가 있어야 인덱스가 생성된다.
    DROP TABLE demo;
    SELECT * FROM RECYCLEBIN;

--   ο FLASHBACK TABLE
--  지워진 테이블 복원하기
----------------------------------------------------------------- 
    FLASHBACK TABLE 삭제 전 이름 TO BEFORE DROP [RENAME TO 바꿀이름의테이블명];    
    FLASHBACK TABLE 개체 이름(OBJECT_NAME BIN$으로 시작하는 것들...)TO BEFORE DROP;    
    
    FLASHBACK TABLE test TO BEFORE DROP;
    SELECT * FROM TAB;
    --단, 지워진 테이블 중 테이블명이 겹치는 경우에는 그중 하나가 살아난다
    FLASHBACK TABLE demo TO BEFORE DROP;
    SELECT * FROM TAB;
    SELECT * FROM DEMO;
    --지워진 테이블 중이 테이블명이 겹치는 경우에는 원하는 테이블 하나를 살릴 수 있다.
    --단, BIN$~은 특수문자가 있으므로 쌍따옴표로 감싸야 한다.
    FLASHBACK TABLE "BIN$dw6FEJa8S/WHNh6tOX26DA==$0" TO BEFORE DROP;
    SELECT * FROM TAB;
    SELECT * FROM demo;
    
    --다만, 이전에 지워진 똑같은 이름의 테이블은 기존의 이름으로는 복구할 수 없다.
    FLASHBACK TABLE demo TO BEFORE DROP;--ORA-38312: 원래 이름이 기존 객체에 의해 사용됨
    --따라서 이름을 변경하여 복원할 수 있다.
    FLASHBACK TABLE demo TO BEFORE DROP RENAME TO emp2;
    SELECT * FROM tab;
    
--   ο 휴지통 비우기
    PURGE RECYCLEBIN; 휴지통 전체 비우기
    PURGE TABLE 특정 테이블명
--     ---------------------------------------------------------------
    DROP TABLE test;
    DROP TABLE demo;
    DROP TABLE emp2;
    SELECT * FROM RECYCLEBIN;
--    휴지통에서 DEMO 테이블만 삭제
    PURGE TABLE demo;
    SELECT * FROM RECYCLEBIN;
--  휴지통 모두 비우기
    PURGE RECYCLEBIN;
    SELECT * FROM RECYCLEBIN;

--   ο TRUNCATE
--   테이블의 구조는 삭제하지 안고 데이터만 삭제한다.
--  자동으로 COMMIT되므로 복구할 수 없음에 유의
--  WHERE절이 없다.
--------------------------------------------------
    TRUNCATE TABLE 테이블명;
    
    SELECT * FROM emp1;
    TRUNCATE TABLE emp1;
    SELECT * FROM emp1;
    DESC emp1;
    DROP TABLE emp1 PURGE;
    