--제3장
--SQL 복수행 함수(그룹 함수)

--1. 그룹 함수의 종류
--COUNT
--SUM
--AVG
--MAX
--MIN
--STDDEV
--VARIANCE
--ROLLUP: 입력되는 데이터의 소계 값을 자동으로 계산하여 출력
--CUBE: 입력되는 데이터의 소계 및 전체 총계를 자동으로 계산하여 출력
--GROUPINGSET: 한 번의 쿼리로 여러 개의 함수들을 그룹으로 수행하기 
--LISTAGG
--PIVOT
--LAG
--LEAD
--RANK

--1.1 COUNT
select count(*), count(comm) from emp;

--1.2 SUM
select SUM(comm) from emp;

--1.3 AVG
select AVG(sal) from emp;

--1.4 MAX, MIN
select max(sal), min(sal) from emp;

--1.5 STDEV, VARIANCE
select round(STDDEV(sal)), round(VARIANCE(sal)) from emp;

--2. GROUP BY 절을 사용해 특정 조건으로 세부적인 그룹화
SELECT deptno, round(AVG(NVL(sal,0))) 평균 from emp
GROUP BY deptno;

--■■■ 사용 시 주의사항
--(1). SELECT절에 사용된 그룹 함수 이외의 컬럼이나 표현식은 반드시 GROUP BY절에 사용되어야 한다. 
--단, GROUP BY절에 언급된 컬럼명이라고 해서 꼭 SELECT에서 언급되어야 하는 것은 아님.

--(2) GROUP BY 절에는 반드시 컬럼명이 사용되어야 하며, 컬럼 Alias는 사용할 수 없음.
--이유는 FROM => WHERE => GROUP BY => HAVING => SELECT => ORDER BY 순으로 연산을 수행하기 때문!

--3. HAVING절을 사용해 그룹핑한 조건으로 검색하기
--emp테이블에서 평균 급여가 2000 이상인 부서의 부서 번호와 평균 급여?
select deptno, round(AVG(nvl(sal,0))) from emp
GROUP BY deptno HAVING AVG(nvl(sal,0)) >=2000;

--4. 반드시 알아야 하는 다양한 분석 함수
--ROLL UP

--(1)부서와 직업별 평균 급여 및 사원수와
--(2)부서별 평균 급여와 사원 수,
--(3)전체 사원의 평균 급여와 사원 수를 구하세요.

select deptno, job, round(AVG(sal)), count(*) from emp
group by ROLLUP(deptno, job);

--4.1 ROLLUP(deptno, job)
--(1) DEPTNO와 JOB별 데이터 산출
--(2) DEPTNO별 데이터 산출
--(3) 전체 데이터 산출

--ROLLUP이 없었더라면....
select deptno, job, round(avg(sal)) avg_sal, count(*) cnt_emp from emp group by deptno, job -- (1) DEPTNO와 JOB별 데이터 산출
UNION ALL
select deptno, NULL job, round(avg(sal)) avg_sal, count(*) cnt_emp from emp group by deptno -- (2) DEPTNO별 데이터 산출
UNION ALL
select NULL deptno, NULL, round(avg(sal)), count(*) cnt_emp from emp --전체 데이터 산출
order by deptno, job;

--
create table professor2
as select deptno, position ,pay
from professor;

INSERT INTO professor2 values(101, 'instructor',100);
insert into professor2 values(101,'a full professor',100);
insert into professor2 values(101,'assistant professor',100);
commit;

select * from professor2 order by deptno, position;

SELECT deptno, position, SUM(pay) from professor2
group by deptno, ROLLUP(position);

--4.2 CUBE함수 소계와 전체 합계까지 출력
-- (1) 부서별 평균 급여와 사원 수
-- (2) 직급별 평균 급여와 사원 수
-- (3) 부서와 직급별 평균 급여와 사원 수
-- (4) 전체 평균 월 급여와 사원 수

select deptno, job, round(AVG(sal)), count(*)
from emp
GROUP BY CUBE(deptno, job)
order by deptno, job;

--CUBE(부서, 직급)
--부서별과 직급별 데이터 산출
--부서별 데이터 산출
--직급별 데이터 산출
--총 데이터 산출

--CUBE가 없었더라면...
select deptno, NULL job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by deptno  --(1)부서별 평균 급여와 사원 수
UNION ALL
select NULL deptno, job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by job --(2) 직급별 평균 급여와 사원 수
UNION ALL
select deptno, job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by deptno, job --(3) 부서와 직급별 평균 급여와 사원 수
UNION ALL
select NULL, NULL, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp -- (4) 전체 평균 급여와 사원 수
order by deptno, job;

--4.3 GROUPING SETS() 함수
--그룹핑 조건이 여러 개일 경우 유용하게 사용된다.
--ex) 학생 테이블에서 학년별로 학생들의 인원수의 합계와 학과별로 인원수의 합계를 구할 경우
--기존에는 UNION연산으로 (1) 학년별 학생들의 인원수, (2) 학과별 인원수 합계를 구했다.

select grade, null, count(*) from student group by grade --학년별 학생의 수
UNION ALL
select null, deptno1, count(*) from student group by deptno1; -- 학과별 학생의 수

--위처럼 구한던 연산을
--간단하게 끝냈다.
select grade, deptno1, count(*) from student group by GROUPING SETS(grade, deptno1);
--학년별로, 학과별로 따로따로 합계를 구할 경우에 사용한다고 기억하면 되겠다!

-- 주의사항: group by grade, deptno1은 학년 중에서도 학과별로 그룹핑하는 것을 의미한다.
select grade, deptno1, count(*) from student group by grade, deptno1;


--일단 배운 곳까지만 정리!