--DQL(또는 DML) 중 SELECT문
--특정 컬럼만 출력? (선언한 컬럼의 순서대로 결괏값이 출력됨)
--DB에 정의된 컬럼의 순서는 이때 중요하지 않다.
select * from emp; -- 모든 컬럼 항목에 관한 데이터를 조회 
select empNo, name, sal from emp; 
select name, empNo, sal from emp;
--이하의 쿼리문에서는 오류가 발생한다.
--ORA-00904: "NO" 부적합한 식별자 오류가 발생한다.
--존재하지 않는 컬럼을 조회할 경우에 발생한다.
select no, name, sal from emp;  -- ORA-00904 오류 발생

--수식을 사용할 때
select empNo, name, sal+100000 from emp;
--||는 문자열 결합을 의미한다.
select name||'님', '기본급여: ' || sal from emp;

select 10+5 from emp; --레코드 수만큼 출력된다
select 10+5 from dual; --단순한 계산은 dual 테이블을 이용하여 계산한다.
select '결과: ' || (10+5) from dual; --연산자 우선순위도 고려하여 작성해야 하는 것에 주의한다.

--모든 컬럼을 출력한다.(emp 테이블: 모든 컬럼 출력)
select * from emp;
-- 모든 컬럼명을 출력하는 경우에도 * 대신에 모든 컬럼명을 기술한다.
-- 실제 코딩할 때는 테이블명세서를 이용하여 컬럼명을 기술하여 프로그래밍을 한다
-- *을 이용하면 컬럼명이 어떤 것이 존재하는지 알 수 없는 경우가 있다.
-- 또한 *을 이용하면 테이블을 만들 때 명시한 컬럼명의 순서대로 결괏값을 가져오므로 의도한 순서대로 컬럼명을 나열하여 가져오는 것이 바람직하다.

--컬럼명을 변경하여 출력(emp테이블: empNo, name, sal 컬럼)
select empNo, name, sal from emp;
--프로그램에서는 변경된 이름으로만 접근이 가능하다.
select empNo as "사번", name as "이름", sal as "기본급" from emp;
--as는 생략이 가능하다.
select empNo 사번, name 이름, sal 기본급 from emp;
select empNo, name ,sal, bonus, sal+bonus from emp;
select empNo, name ,sal, bonus, sal+bonus pay from emp;
select empNo, name ,sal, bonus, sal+bonus 급 여 from emp; -- alias는 따옴표로 감싸지 않으면 오류가 발생한다. (공백이 있으니까)
--별칭을 사용할 때만큼은 홑따옴표가 아닌 쌍따옴표를 이용하여 지정한다.
select empNo, name ,sal, bonus, sal+bonus "급 여" from emp;
--컬럼명을 바꾸는 이유는 프로그램에서 접근을 편리하게 하기 위함임. (수식을 사용한 경우 alias로 접근)
--수식을 사용한 경우 프로그램에서 접근할 때 이름을 지정하지 않으면 접근하기가 번거롭기 때문이다.

--ROWNUM: 쿼리의 결과로 나오는 각각의 행들에 대한 순서 값
select ROWNUM, empNo, name from emp;
--astrik(*)을 사용할 때는 다른 컬럼명과 혼합하여 사용할 수 없다
select ROWNUM, * from emp; -- ORA-00936 누락된 표현식
--emp에 있는 모든 것(*)이라고 명시해주었으므로 사용할 수 있는 구문이다
select ROWNUM, emp.* from emp; -- 값이 보인다.
--emp라는 테이블의 alias를 t라고 주었으므로 t.*로 바꾸어야 정상적으로 작동한다.
select ROWNUM, t.* from emp t;

-- SELECT문 구문 기술 순서
-- SELECT 컬럼명(표현식)
-- FROM 테이블
-- WHERE 조건
-- GROUP BY 컬럼명(표현식)
-- HAVING 집계함수 조건식
-- ORDER BY 컬럼명(표현식)

--SELECT 구문 실행 순서
--FROM 테이블명 - 내 계정에 해당하는 테이블이 있니? 먼저 검사한다
--WHERE 조건식  
--GROUP BY 컬럼명(표현식)
--HAVING 집계함수조건식
--SELECT 컬럼명(표현식)
--ORDER BY 컬럼명(표현식)

--------
--emp테이블에서 city가 서울인 자료 중 name, city컬럼을 출력
SELECT name, city  FROM emp WHERE city='서울';
--emp테이블에서 city가 서울이 아닌 자료 중 name, city 컬럼 출력
select name, city from emp where city<>'서울'; --ISO표준 표기법
select name, city from emp where city!='서울';
--emp테이블 중에서 sal+bonus가 2500000원 이상인 자료 중 name, sal, bonus 컬럼 출력
select name, sal, bonus from emp where sal+bonus>=2500000;
select name, sal, bonus, sal+bonus from emp where sal+bonus>=2500000; --검산용

--그룹비교 연산자
--OR을 사용할 때 컬럼명을 반드시 기술해주어야 한다. 다음과 같이 사용하면 오류가 발생한다.
select empNo, name, city from emp where city = '서울' or '경기' or '인천'; --오류 발생
--OR을 사용할 때 컬럼명을 바르게 기재한 예
select empNo, name, city from emp where city = '서울' or city = '경기' or city = '인천';
--any를 사용한 예제
select empNo, name, city from emp where city=ANY('서울','경기','인천');
--in을 사용한 예제
select empNo, name, city from emp where city in ('서울', '경기', '인천');
--emp테이블에서 sal가 2000000원 이상인 자료 중 empNo, name, sal 컬럼을 출력
select empNo, name, sal from emp where sal>=2000000;
--ANY는 OR개념과 유사하다
select empNo, name, sal from emp where sal >= ANY(2000000, 2500000, 3000000);
--emp테이블에서 sal가 3000000원 이상인 자료 중 empNo, name, sal 컬럼을 출력
select empNo, name, sal from emp where sal>=3000000;
--ALL은 AND개념과 유사하다
select empNo, name, sal from emp where sal >= ALL(2000000, 2500000, 3000000);

--논리연산자
--emp테이블: city가 서울이고 sal가 2000000원 이상인 자료 중 empNo, name, city, sal 컬럼 출력
select empNo, name, city, sal from emp where city='서울' and sal>=2000000;

--emp테이블에서 city가 서울, 경기, 인천인 자료 중 empNo, name, city, sal 컬럼을 출력
select empNo, name, city, sal from emp where city in ('서울','경기','인천');
select empNo, name, city, sal from emp where city=ANY('서울','경기','인천');
select empNo, name, city, sal from emp where city = '서울' or city = '경기' or city = '인천';

--emp테이블에서 sal에서 2000000~3000000을 제외한 자료 중 empNo, name, sal컬럼을 출력
--not의 연산은 경우에 따라 피해야 하는 경우가 있으므로 여러 가지 경우의 수를 고려하여 where조건문을 작성한다.
select empNo, name, city, sal from emp where not (sal>=2000000 and sal<=3000000);
select empNo, name, city, sal from emp where sal<2000000 or sal>3000000;

--BETWEEN조건식
--emp테이블: sal가 2000000~3000000사이인 자료 중 name, sal 출력
select name, sal from emp where sal >= 2000000 AND sal <= 3000000; --로도 표현할 수 있지만
select name, sal from emp where sal between 2000000 and 3000000; --BETWEEN으로 좀 더 편리하게 구문을 표현할 수 있음.
--BETWEEN은 함수이므로 데이터가 늘어나면 부하가 걸리므로 관계연산자와 논리연산자를 사용하는 것이 더 효율적이다.
--emp테이블 sal가 2000000~30000000을 제외한 자료 중  name, sal을 출력
select name, sal from emp where sal <2000000 or sal>3000000;
select name, sal from emp where sal not between 2000000 and 3000000;

--emp테이블에서 hireDate가 2000년도인 자료 중 name, sal 컬럼 출력
select name, hireDate from emp where hiredate between '2000-01-01' and '2000-12-31';
--(심화) 함수를 이용하여 연도만 추출할 수도 있다.
select name, hireDate from emp where EXTRACT(YEAR from hireDate) = 2000;

--★★★★★IN조건식
--emp테이블: city가 서울, 인천, 경기인 자료 중 name, city출력
select name, city from emp where city='서울' or city='인천' or city='경기'; --로도 사용할 수 있지만
select name, city from emp where city in ('서울','인천','경기'); --in을 사용하면 간편하게 조건식을 지정할 수 있다.
--emp테이블: city가 서울, 인천, 경기를 제외한 name, city 출력
select name, city from emp where city not in ('서울','인천','경기'); --in 앞에 not을 붙일 수 있음.
--emp테이블에: city와 pos가 서울이면서 부장이거나, 서울이면서 과장인 자료 중 name, city. pos 컬럼
select name, city, pos from emp where (city='서울' and pos='부장') or (city='서울' and pos='과장'); -- 로도 조건을 지정할 수 있지만
select name city, pos from emp where city='서울' and (pos='부장' or pos='과장'); --로도 지정이 가능하다
select name, city, pos from emp where city in ('서울') and pos in('부장', '과장'); --으로 간편하게 조건식을 지정할 수 있다.
select name, city, pos from emp where (city, pos) in (('서울','부장'), ('서울','과장')); --결괏값은 이것도 유사하다
--emp테이블에서 city와 pos가 서울이면서 부장인 자료 중 name, city, pos컬럼 출력 (subquery)
select name, city, pos from emp where city='서울' and pos='부장'; --일단, 이 방법으로 학습할 것
select name, city, pos from emp where (city, pos) in (select '서울', '부장' from dual); -- (심화) 아, 이런 것도 있구나!
select '서울', '부장' from dual;--(심화)


