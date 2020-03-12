--■ SQL 함수
-- GROUP BY는 부하가 많이 걸리는 연산이므로 특수한 상황에서 DB관리자만 사용

-- ※ 집계 함수(Aggregate Function)와 GROUP BY 절
--    ο 집계 함수(Aggregate Function) 종류
--- COUNT( * )
    select count(*) from emp; --모든 행 수 구하기 (*의 경우 null도 카운트한다)
--- COUNT( DISTINCT | ALL ] expr )
    select count(empno) from emp; -- (NULL은 count에서 제외됨)
    --단 empNo에서는 기본키라서 NULL을 허용하지 않았으므로 실제 전체 행 수를 구한 결괏값이 반환된다.
    select count(tel) from emp; -- (NULL은 count에서 제외됨)
    select count(nvl(tel,0)) from emp; -- 60개의 레코드 모두 집계함
    
-- 단, Group by 절에 언급되지 않은 컬럼은 집계함수와 함께 사용될 수 없다.
    select dept, COUNT(dept) from emp; -- 오류 예시
    select dept, COUNT(dept) from emp group by dept; --group by에 언급된 dept는 select절에서 사용 가능
    
   select sal from emp;
   select sal from emp where 1=2; -- 0
   select count(sal) from emp where 1=2; -- 0
   select avg(sal) from emp where 1=2; -- null
   select NVL(avg(sal),0) from emp where 1=2;
   
   select count(dept) from emp; -- 60
   select count(distinct dept) from emp; -- 7 (부서의 종류 중복 배제하고)
    
   select count(dept) from emp where dept='개발부'; --개발부 소속 사원의 수
   select count(*) from emp where mod(substr(rrn,8,1),2)=1; --남자 사원의 수
   
   --전체, 남자, 여자 사원 수 구하기
   select rrn, 
   decode(mod(substr(rrn,8,1),2),1,'트루') 남자,
   decode(mod(substr(rrn,8,1),2),0,999999) 여자
   from emp;
   
   select count(*) 전체,
   COUNT(decode(mod(substr(rrn,8,1),2),1,1)) 남자, -- 조건에 만족하지 않으면 null이 반환됨
   COUNT(decode(mod(substr(rrn,8,1),2),0,1)) 여자 -- 조건에 만족하지 않으면 null이 반환됨
   from emp;
   
   --QUIZ1. 서울 사는 남자 인원 수 구하기
    select count(*) man from emp
    where city='서울' and mod(substr(rrn,8,1),2)=1;
    
   -- QUIZ2. 다음과 같이 출력
   -- 추후 피벗이라는 오라클의 개념을 이용하여 다음과 같이 출력할 것이다
   -- 일단은 배운 내용대로 UNION ALL을 이용하여 결괏값을 의도한 대로 출력한다.
   -- 전체 60
   -- 남자 31
   -- 여자 29
    select '전체' 구분, count(*) 인원 from emp
    UNION ALL
    select '남자' 구분, count(*) 인원 from emp where mod(substr(rrn,8,1),2)=1
    UNION ALL
    select '여자' 구분, count(*) 인원 from emp where mod(substr(rrn,8,1),2)=0;
    --예) 오라클 사원이름 X 튜플 수만큼 출력
    select '오라클', name from emp;
    
--- MAX([ DISTINCT | ALL ] expr
--- MIN([ DISTINCT | ALL ] expr)
    select max(sal), min(sal) from emp;
--- AVG([ DISTINCT | ALL ] expr)
--- SUM([ DISTINCT | ALL ] expr)
    select AVG(sal), SUM(sal) from emp;
    
    --QUIZ 3. 개발부 평균 급여(sal+bonus의 평균)
    select round(AVG(nvl(sal+bonus,0)),1) from emp where dept='개발부';
    --다음과 같이 출력
    --구분    최대  최소  평균
    --전체    xxx   xxxx   xxxx
    --남자    xxx   xxxx   xxxxx
    --여자    xxx   xxxx  xxxxx
    
    select '전체' 구분, MAX(sal) 최대, MIN(sal) 최소, round(AVG(sal)) 평균 from emp
    UNION ALL
    select '남자' 구분, MAX(sal) 최대, MIN(sal), round(AVG(sal)) 평균 from emp
    where mod(substr(rrn,8,1),2)=1
    UNION ALL
    select '여자' 구분, MAX(sal) 최대, MIN(sal) 최소, round(AVG(sal)) 평균 from emp
    where mod(substr(rrn,8,1),2)=0;
    
    --QUIZ 4. 
    --월별 입사 인원수 구하기
    -- 전체   1월  2월  ... 12월
    -- xx     xxx   xxxx      xxx
    
    select count(*) 전체, 
    count(decode(EXTRACT(MONTH from hireDate),1,1)) "1월",
    count(decode(EXTRACT(MONTH from hireDate),2,1)) "2월",
    count(decode(EXTRACT(MONTH from hireDate),3,1)) "3월",
    count(decode(EXTRACT(MONTH from hireDate),4,1)) "4월",
    count(decode(EXTRACT(MONTH from hireDate),5,1)) "5월",
    count(decode(EXTRACT(MONTH from hireDate),6,1)) "6월",
    count(decode(EXTRACT(MONTH from hireDate),7,1)) "7월",
    count(decode(EXTRACT(MONTH from hireDate),8,1)) "8월",
    count(decode(EXTRACT(MONTH from hireDate),9,1)) "9월",
    count(decode(EXTRACT(MONTH from hireDate),10,1)) "10월",
    count(decode(EXTRACT(MONTH from hireDate),11,1)) "11월",
    count(decode(TO_CHAR(hireDate,'MM'),'12',1)) "12월"
    from emp;
    
--- VARIANCE([ DISTINCT | ALL ] expr)
--- STDDEV([ DISTINCT | ALL ] expr)
    select VARIANCE(sal), STDDEV(bonus) from emp;
    
-- ※ GROUP BY 절과 HAVING 절
--    ο GROUP BY 절 사용 예
      -- dept의 pos별 급여 총합			
    select SUM(sal) from emp; --테이블 내 모든 급여의 총 합
--    select dept SUM(sal) from emp; -- (오류) group by에 명시하지 않은 컬럼을 집계함수와 같이 쓸 수 없음
    select SUM(sal) from emp GROUP BY dept;
    select dept, SUM(sal) from emp GROUP BY dept; --부서별 급여 합
    select dept, SUM(sal) from emp GROUP BY dept order by dept;
    
-- SELECT문 쿼리 실행 과정(복습)
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY

--    ο HAVING 절 사용 예
    select dept, COUNT(*) from emp
    GROUP BY dept;

    select dept, SUM(sal) from emp
    GROUP BY dept
    HAVING count(*) >= 10; -- GROUP BY 결과의 조건
    
    -- 부서 직위별 인원수
    -- 개발부(부장, 과장, 대리, 사원)
    -- 기획부(대리, 부장, 대리, 사원)
    select dept, pos, count(*) from emp
    group by dept, pos
    order by dept;
    -- 부장(개발부, 기획부, 영업부 ...)
    -- 과장(개발부, 기획부, 영업부 ...)
    select pos, dept, count(*) from emp
    group by pos, dept
    order by dept;
    
    --부서별 여자 인원수가 출력. 여자가 없는 부서는 출력하지 않음
    select dept, count(*) 인원수 -- where절에서 여성에 한정했으니까 여성 필터링(mod~~) 필요없음
    from emp 
    where mod(substr(rrn,8,1),2)=0 -- 대상은 여자이므로 where절에서 걸러준다.
    group by dept;

     -- 부서별 여자인원수 출력. 여자가 없는 부서는 0으로 출력    
    -- HINT: 부서 총무부, 개발부, 영업부, 자재부, 기획부, 홍보부, 인사부(여자 없음)
    select dept, 
    count(DECODE(mod(substr(rrn,8,1),2),0,9999)) "여자 인원수" from emp
    group by dept;
    
    select dept, 
    count(DECODE(mod(substr(rrn,8,1),2),0,9999)) "여자 인원수",
    count(DECODE(mod(substr(rrn,8,1),2),1,9999)) "남자 인원수"
    from emp
    group by dept;
    
    --부서명 성별 총합 평균
    --개발부 남  xxx  xxx
    --개발부 여  xxx xxx
    -- ....
    
    select dept 부서명,
    decode(mod(substr(rrn,8,1),2),1,'남','여') 성별,
    sum(sal) 총합,
    round(avg(sal)) 평균
    from emp
    group by dept, decode(mod(substr(rrn,8,1),2),1,'남','여')
    order by dept;
    
    --부서별 여자 인원수가 5명이상인 부서만 출력
    select dept, count(*) 인원수 -- where절에서 여성에 한정했으니까 여성 필터링(mod~~) 필요없음
    from emp 
    where mod(substr(rrn,8,1),2)=0 -- 대상은 여자이므로 where절에서 걸러준다.
    group by dept
    HAVING count(*)>=5; --having에서도 집계함수 사용이 가능하다
    
    --다음과 같이 출력
    --부서명 전체인원수 남자인원수 여자인원수
    select dept 부서명, 
    count(*) "전체 인원수",
    count(decode(mod(substr(rrn,8,1),2),1,1)) "남자 인원수",
    count(decode(mod(substr(rrn,8,1),2),0,1)) "여자 인원수"
    from emp
    group by dept;

    --city가 서울 사람 중 부서가 개발부인 인원수
    select count(*) 인원수
    from emp
    where city='서울' and dept='개발부';
    
    --부서 직위별 인원수
    -- 부서명 오름차순 정렬하고 부서가 같으면 인원수 내림차순
    -- 부서명 직위명 인원수
    select dept 부서명, pos 직위명, count(*) 인원수 from emp
    group by dept, pos
--    order by dept, count(*) desc; --orderby절에도 count(*)함수를 사용할 수 있다.
    order by dept, 인원수 desc;
    
    --입사년도별 인원수
    --연도 인원수
    select EXTRACT(YEAR from hiredate) 연도, count(*) 인원수 from emp
    group by EXTRACT(YEAR from hiredate)
--    GROUP BY TO_CHAR(hiredate, 'YYYY')
    order by 연도;

    select TO_CHAR(hiredate, 'YYYY') 연도, count(*) 인원수 from emp
    GROUP BY TO_CHAR(hiredate, 'YYYY')
    order by 연도;
    
    --월별 입사일을 기준으로 인원수 집계
    select TO_CHAR(hiredate, 'MM') 월별, count(*) 인원수 from emp
    GROUP BY TO_CHAR(hiredate, 'MM')
    order by 월별;
    
    --CITY가 서울 사람 중 부서별 남자와 여자 인원 수
    --부서별 오름차순 정렬
    --부서명 성별 인원수
    select dept 부서명, decode(mod(substr(rrn,8,1),2),1,'남자','여자') 성별, count(*) 인원수
    from emp
    where city='서울'
    group by dept, DECODE(mod(substr(rrn,8,1),2),1,'남자','여자')
    order by dept;
 
    --부서별 남자와 여자 비율 계산
    --부서명 남자비율 여자비율
    --개발부   51%      49%
    --참고: 데이터 중 인사부는 남자만 있음
    select dept 부서명,
    round((count(DECODE(mod(substr(rrn,8,1),2),1,1))/count(*))*100)||'%' 남자비율,
    round((count(DECODE(mod(substr(rrn,8,1),2),0,1))/count(*))*100)||'%'  여자비율 from emp
    group by dept;
    
    -- 83~87년생의 인원수
    select count(*) "83~87년생의 인원수" from emp
    where substr(rrn,1,2)>=83 and substr(rrn,1,2)<=87;
    
    ------------------------------------------------------
    --※ 서브 쿼리 이용 필요
    -- SELECT는 SELECT에도 올 수 있고 WHERE에서도 올 수 있다.
    --최대 급여를 받는 사람은?
    select name, sal from emp
    where sal = (select max(sal) from emp);
    --최소 급여를 받는 사람은?
    select name, sal from emp
    where sal = (select min(sal) from emp);
    
-- ※ ROLLUP 절과 CUBE 절
--    ο ROLLUP 절 예
       -- dept별 pos의 sal 소계, dept별소계, 마지막에 총계 출력


       -- dept별 pos의 sal 소계, dept별 소계 출력하며 마지막에 총계는 출력하지 않는다.


--    ο CUBE 절 예
       -- dept별 pos의 sal 소계, dept별 소계, pos별 소계, 마지막에 총계 출력



-- ※ GROUPING 함수와 GROUP_ID 함수
--    ο GROUPING 함수


--    ο GROUP_ID 함수


-- ※ GROUPING SETS

