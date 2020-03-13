-- sal+bonus 의 총합, 평균, 최대, 최소값 출력 : emp 테이블
    -- 총합  평균  최대  최소

select sum(sal+bonus), avg(sal+bonus), max(sal+bonus), min(sal+bonus) from emp;

-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   성별   인원수

select city, '남자' 성별, count(DECODE(mod(substr(rrn,8,1),2),1,9999)) 인원수 from emp group by city
UNION ALL
select city, '여자' 성별, count(DECODE(mod(substr(rrn,8,1),2),0,9999)) 인원수 from emp group by city
order by city, 성별;

-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   남자인원수  여자인원수

select city,
count(DECODE(mod(substr(rrn,8,1),2),1,9999)) 남자인원수,
count(DECODE(mod(substr(rrn,8,1),2),0,9999)) 여자인원수
from emp group by city
order by city;

-- 부서(dept)별 남자 인원수가 7명 이상인 부서명과 인원수 출력 : emp 테이블
    -- dept  인원수

select dept, count(*) 인원수,
count(DECODE(mod(substr(rrn,8,1),2),1,9999)) "남자인원수(검산)"  from emp
group by dept
having count(DECODE(mod(substr(rrn,8,1),2),1,9999))>=7;


-- 부서(dept)별 인원수와 부서의 월별로 생일인 사람의 인원수 출력 : emp 테이블
    -- dept  인원수 M01  M02  M03 .... M12

select dept, count(*) 인원수,
TO_CHAR(substr(rrn,3,2),'MM')
from emp
group by dept;


-- sal를 가장 많이 받는 사람의 name, sal 출력 : emp 테이블
    -- name   sal

select name, sal from emp
where sal = (select max(sal) from emp);

-- ★
-- 출신도(city)별 여자 인원수가 가장 많은 출신도 및 여자 인원수를 출력 : emp 테이블
    -- city   인원수

--1단계) 도시별 여자 인원수 구하기
        select city, 
        count(DECODE(mod(substr(rrn,8,1),2),0,999)) 여자인원수
        from emp
        group by city;
        
-- 2단계) 여자 인원수가 가장 많은 곳 구하기
    WITH tb as ( 
        select city, 
        count(DECODE(mod(substr(rrn,8,1),2),0,999)) 여자인원수
        from emp
        group by city
    )
    select city, 여자인원수 from tb 
    where 여자인원수 = (select max(여자인원수) from tb);

-- 부서(dept)별 인원수 및 부서별 인원수가 전체 인원수의 몇 %인지 출력 : emp
    -- dept  인원수  백분율

    SELECT dept, round(count(dept) / (SELECT count(*) from emp)*100)||'%' "부서별 인원비"
    FROM emp
    group by dept;


-- 부서(dept) 직위(pos)별 인원수를 출력하며, 마지막에는 직위별 전체 인원수 출력 : emp 테이블
   -- ROLLUP을 사용하며, 부서별 오름차순 정렬
   -- 출력 예
--dept       pos    인원수
--개발부    과장    2
--개발부    사원    9
--개발부    부장    1
--개발부    대리    2
--기획부    사원    2
--     :
--           사원    32
--           부장    7
--           과장    8
--           대리    13

    select dept, pos, count(*) 인원수 from emp
    group by pos, rollup(dept, pos);


-- 부서(dept) 직위(pos)별 인원수를 출력 : emp 테이블
    -- 출력 예
--dept       부장  과장  대리  사원
--총무부    1       2      0      4
--개발부    1       2      2      9
--            :

-- 1단계) 부서, 직위별 인원수 각각 출력하기
select dept, pos, count(pos) from emp
group by dept, pos
order by dept, pos;

--2단계) 부서 직위별 인원수를 형식에 맞게 출력하기
SELECT 
dept 부서,  
count(DECODE(pos,'부장',999)) 부장,
count(DECODE(pos,'과장',999)) 과장, 
count(DECODE(pos,'대리',999)) 대리, 
count(DECODE(pos,'사원',999)) 사원 
from emp
group by dept;

-- 부서(dept) 직위(pos)별 인원수를 출력하고 마지막에 직위별 인원수 출력 : emp 테이블
    -- 출력 예
--dept       부장  과장  대리  사원
--개발부    1       2      2      9
--기획부    2       0      3      2
--            :
--            7        8     13     32

SELECT 
dept 부서,  
count(DECODE(pos,'부장',999)) 부장,
count(DECODE(pos,'과장',999)) 과장, 
count(DECODE(pos,'대리',999)) 대리, 
count(DECODE(pos,'사원',999)) 사원
from emp
group by rollup(dept)
order by 부서;
