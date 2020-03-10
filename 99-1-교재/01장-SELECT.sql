--제1장
--SELECT 명령을 이용하여 데이터를 조회합니다.

--1. 모든 컬럼 조회하기
select * from emp;

--2. 원하는 컬럼만 조회하기
select empno, ename from emp;

--3. SELECT 명령에 표현식을 사용하여 출력하기
select ename, 'good morning~~!' "Good Morning" from emp;

--4. 컬럼에 별칭을 사용하여 출력하기
select empno, ename, job from emp;
select empno as "사원번호", ename as  "사원명", job as "직업" from emp;
select ename "사원명" from emp;
select ename 사원명 from emp;

--5. DISTINCT로 중복된 값을 제거하고 출력하기
select deptno from emp;
select DISTINCT deptno from emp;

--DISTINCT 사용 시 주의사항
--DISTINCT키워드를 입력하면 select 이하 조회하고자 하는 모든 컬럼에 적용된다.
select deptno, ename from emp; --12개의 결과
select DISTINCT deptno, ename from emp; --12개의 결과

--6. 연결(||)연산자로 컬럼을 붙여서 출력하기
--또는 합성 연산자라고도 함
select ename, job from emp;
select ename || job from emp;

--연결연산자를 사용하면 오라클에서는 1개의 컬럼으로 인식한다는 것을 명심하자.
select ename||'''s job is ' || job "Name and Job" from emp;

--연습문제1
--student테이블에서 모든 학생의 이름과 ID, 체중을 출력할 것. 컬럼명은 ID AND WEIGHT
--(테이블이 없어서 emp테이블로 대체하였음)
select ename||'''s ID: ' || empno || ', Salary is ' || sal as "ID AND SAL" from emp;

--연습문제2
--emp테이블을 조회하여 모든 사람의 이름과 직업을 아래와 같이 출력
-- SMITH(CLERK), SMITH';CLERK'
select ename||'('||job||'), '||ename||''''||job||'''' as "NAME AND JOB" from emp;

--연습문제3
--emp테이블을 조회하여 모든 사원의 이름과 급여를 아래와 같은 형태로 출력
--SMITH's sal is $800
select ename||'''s sal is $'||sal as "NAME AND SAL" from emp;

--7. 원하는 조건만 골라내기 (WHERE)
select empno, ename 
from emp 
where empno=7900;

--문자와 날짜를 조회하고 싶은 경우에는 작은 따옴표를 사용한다.
select empno, ename, sal
from emp
where ename='SMITH';

-- 문자 조회 시에는 작은따옴표와 대소문자를 구별하여야 한다.
-- 데이터베이스에는 SMITH라는 대문자로 적힌 데이터만 있으므로 smith를 조회할 경우 나타나지 않을 것이다.
select empno, ename, sal
from emp
where ename='smith'; --결과 없음

--날짜 표기 형식은 운영체제의 국가 설정에 따라 다르다.
--윈도와 유닉스 계열 사이에 데이터를 옮기는 작업을 할 때도 오류가 발생할 수 있으므로 주의해야 한다.
--날짜를 조회할 때도 마찬가지로 작은따옴표를 사용한다.
select ename, hiredate from emp
where ename='SMITH';

--날짜를 이용하여 검색하는 방법
select empno, ename, sal, hiredate
from emp
where hiredate='80/12/17';
--날짜에 영문자가 포함될 경우 대소문자를 구분하지 않는다.

select empno, ename, sal, hiredate
from emp
where hiredate='80-12-17';

--8. SQL에서 기본 산술 연산자 사용하기
select ename, sal from emp where deptno = 10;
select ename, sal, sal*10 from emp where deptno=10;
select ename, sal, sal*1.1 from emp where deptno=10;
--산술연산자 사용 시 연산자 우선순위 유의할 것.

--9. 다양한 연산자 활용하기
-- =
--  !=, <>
-- >
-- >=
-- <
-- <=
-- BETWEEN a AND b
-- IN(a,b,c)
-- LIKE
-- IS NULL / IS NOT NULL
-- A AND B
-- A OR B
-- NOT A 

select empno, ename, sal from emp
where sal >= 4000;

--문자 'W'보다 크거나 같은 ename을 찾아서 출력하기
select empno, ename, sal from emp
where ename >='W';

select ename, hiredate from emp order by hiredate desc;
select ename, hiredate from emp
where hiredate >= '81/12/25'; --날짜로도 대소구분이 가능하다 (이전/이후)

--emp테이블에서 sal이 2000과 3000 사이인 사람들의 empno, ename, sal 값을 출력
select empno, ename, sal from emp
where sal BETWEEN 2000 AND 3000;

--하지만 가급적이면 BETWEEN연산자보다는 비교 연산자를 사용할 것을 권장한다
select empno, ename, sal from emp 
where sal >= 2000 and sal <=3000;

select ename from emp order by ename;
--숫자 말고도 문자로도 범위를 지정하여 연산할 수 있음.
select ename from emp where ename BETWEEN 'JAMES' AND 'MARTIN'
order by ename;

--IN연산자로 조건을 간편하게 검색하기
---emp테이블에서 10번 부서와 20번 부서에 근무하는 사원들의 정보 검색
select empno, ename, deptno from emp
where deptno in (10,20);

--LIKE연산자로 비슷한 것들 모두 찾기
--봉급이 1로 시작
select empno, ename, sal from emp
where sal LIKE '1%';

--사원명이 A로 시작
select empno, ename, sal from emp
where ename LIKE 'A%';

--리눅스 운영체제에서........
--성능에 나쁜 영향을 주는 구문
--select empno, ename, hiredate from emp
--where hiredate LIKE '%80';
--영문 운영체제가 아니면 조횟값이 나오지 않을 수도 있음.

--입사월이 12월인 사람 모두 출력
select empno, ename, hiredate
from emp
where hiredate like '___12%'; -- _ 3개

--NULL값 조회하기 (IS NULL / IS NOT NULL)
select empno, ename, comm from emp
where comm IS NULL;

