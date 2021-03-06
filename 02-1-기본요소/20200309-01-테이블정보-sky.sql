--★★★★★
-- DUAL, TAB, COL, DESCRIBE 반드시 숙지할 것.

--기본적인 테이블 내용 조회
select * from emp;
select name from emp;

--컬럼 + 문자열을 결합하여 결괏값을 출력
select name||'님' from emp;

--오라클에서는 문자열을 사용할 때 varchar2 << 를 써야 한다. (varchar 사용 금지)
--오라클에서도 varchar을 권장하지 않음.
--한글 1자 === 3byte in Oracle

--★★★★★
--DUAL 테이블
--Oracle에 의해 자동 생성되는 테이블로 사용자 SYS 스키마(shcema)에 존재함.
--모든 사용자가 사용이 가능하다.
select * from dual;
-- select 3+5는 from에서 어떠한 테이블을 지정하여도 가능하다.
-- 하지만 테이블의 튜플이 0이면 결괏값이 나오지 않고, 복수 개이면 튜플의 개수만큼 나온다.
-- 따라서 dual테이블을 이용하여 연산의 결괏값 등을 시험할 수 있다.
select 3+5 from emp;
select 3+5,3-5,3/5,3*5 from dual;
-- Dual테이블은 sys의 소유이지만 모든 사용자가 사용할 수 있다.

--딕셔너리는 Oracle이 자동으로 생성하여 소유한 테이블에 대한 정보를 제공해 준다. 
--sys계정에서 sky계정의 테이블에 대한 정보 조회할 때
--현재 사용자가 가진 테이블의 목록을 출력
-- USER_TABLES(TABS)
select * from TABS;
select * from user_tables; 
--TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME, IOT_NAME, STATUS, PCT_FREE ...  등의 컬럼 정보를 조회할 수 있음. 

--★★★★★
--TAB뷰(VIEW)
--사용자가 소유한 테이블의 목록 조회를 간편하게 할 수 있도록 만들어진 뷰
select * from tab;
-- TNAME, TABTYPE, CLUSTERID

-- 관리자 계정에서는 ALL_TABLES로 모든 사용자의 테이블을 조회할 수 있다.
-- select * from ALL_TABLES
-- 관리자 계정에서 HR사용자의 테이블만 조회하기 (HR은 대문자로 입력하여야 조회가 가능함)
-- select * from ALL_TABLES where owner='HR' 
-- select * from ALL_TALBES where owner='SKY'

-- 딕셔너리 (USER_TAB_COLUMNS => COLS)
-- 사용자의 모든 테이블에 있는 COLUMNS, 데이터 타입, 데이터 길이를 조회한다.
select * from USER_TAB_COLUMNS;
select * from COLS where table_name='EMP'; -- '대문자' --오라클은 대문자로 관리한다.
--★★★★★ 테이블 구조 확인하기
-- COL뷰(VIEW)
select * from COL;
select * from COL where tname = 'EMP';
--★★★★★
-- DESCRIBE(DESC)
-- DESCRIBE은 테이블에 대한 컬럼명, NULL조건 여부, 데이터 타입을 제공하는 명령어
-- DESCRIBE 테이블명;
DESCRIBE emp;
DESC emp;
                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
