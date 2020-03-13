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
    --Sub Query
    --서브쿼리는 select문만 사용하는 것이 아니다.
    --SELECT, FROM, WHERE절 등에서 사용되는 SUB QUERY는 단독 실행이 가능하다.
    --SELECT 절에서 사용하는 경우 하나의 컬럼에 한 행의 결과를 출력하는 경우에만 사용이 가능하다.
    --WHERE절에서 사용되는 경우 하나의 컬럼만 가능하며
    --      IN 절에서는 여러 행이 출력되어도 가능하지만
    --      =,> 등의 연산에서는 하나의 행만 가능하다.
    
    --최대 급여는?
    select MAX(sal) from emp;
    --최대 급여를 받는 사람은?
    select name, sal from emp
    where sal = (select max(sal) from emp);
    
--    where sal = (select max(sal),min(sal) from emp); -- 서브쿼리는 한 줄, 한 컬럼만 가능하다.
    
    
    --급여의 평균차이 구하기    
    select name, 
    sal-(select round(avg(sal)) from emp) 평균차이 
    from emp
    order by 평균차이 desc, name;
    
    select name, sal
    from emp
    where sal-(select round(avg(sal)) from emp)>=0
    order by sal desc;
    
    --[부서 인원수]가 [가장 많은 부서명과 인원수] 출력
    --1. 부서별 인원수
    select dept, count(dept) from emp group by dept;
    --2. 가장 많은 부서명과 인원수
    select dept, COUNT(*) from emp
    group by dept
    HAVING count(*) = (select max(count(*)) from emp group by dept);
    
    --입사년도별 인원수가 가장 많은 연도 및 인원수
    
    --1. 입사년도별 인원수
    select TO_CHAR(hiredate,'YYYY') 연도, count(*) 수 from emp
    group by TO_CHAR(hiredate,'YYYY')
    order by 수 desc;
    
    --2. 입사년도 중 인원수가 가장 많은...
    select max(count(*)) from emp
    group by TO_CHAR(hiredate,'YYYY');
    
    select TO_CHAR(hiredate,'YYYY') 연도, count(*) 수 from emp
    group by TO_CHAR(hiredate,'YYYY')
    HAVING count(*) = (select max(count(*)) from emp group by TO_CHAR(hiredate,'YYYY'));
    
    --문제1. name에서 성씨가 한 자라는 가정 하에 성씨별 인원수 구하기
    --1단계. 사원 성씨 모두 출력 (중복 제거)
    select distinct substr(name,1,1) from emp;
    --2단계. 성씨별 인원수 구하기
    select substr(name,1,1) 성씨, count(*) 인원수 from emp 
    group by substr(name,1,1)
    order by 성씨;
    
    --문제2. sal+bonus가 가장 큰 사람의 이름, sal, bonus 출력
    --1단계. sal+bonus가 가장 큰 금액 출력
    select max(sal+bonus) from emp;
    --2단계. 최종
    select name, sal, bonus, sal+bonus from emp
    where sal+bonus = (select max(sal+bonus) from emp);
    
    --문제3. 생일이 동일한 사람이 2명 이상인 경우의 name, birth 출력 (초고난도)
    --XXXXXXXXXXXXX 연도는 비교하지 말았어야 했는데...
    --1단계. 사원의 생년월일 출력하기
    select substr(rrn,1,6) from emp;
    --2단계. 생년월일이 같은 인원이 있는지 검색하기 840505 (2명) << 하나 나옴
    select substr(rrn,1,6), count(*) from emp group by substr(rrn,1,6);
    --3단계. 생년월일이 동일한 생년월일 출력하기
    select count(*) from emp group by substr(rrn,1,6) having count(*)>1;
    --4단계. 최종
    select name, substr(rrn,1,6) 생년월일 from emp
    where substr(rrn,1,6) in (select substr(rrn,1,6) from emp group by substr(rrn,1,6) having count(*)>1);
    
    --선생님 풀이
    --1단계. 사원명과 생일 순서대로 생년월일을 출력하기
    select name, TO_DATE(SUBSTR(rrn,1,6)) birth from emp
    order by TO_CHAR(birth,'MMDD');
    --생일만!! 같은 사람을 비교할 때는 홍길남=정정해,ㅡ 김정훈=유영희, 권옥경=이미경 등등... 많다
    --2. 생년월일이 같은 항목들의 개수를 각각 출력 
    select substr(rrn,3,4) from emp 
    group by substr(rrn,3,4)
    having count(*) >1;
    --3. 최종
    select name, TO_DATE(substr(rrn,1,6)) birth from emp
    where substr(rrn,3,4) in
    (
        select substr(rrn,3,4) from emp 
        group by substr(rrn,3,4)
        having count(*) >1
    )
    order by TO_CHAR(birth,'MMDD');

-- ※ ROLLUP 절과 CUBE 절
--    ο ROLLUP 절 예
--	   소계 및 총계 계산
--	      ROLLUP(a, b)
--		    a별 b의 소계 ==> group by a, b와 같은 효과
--			a별 소계 ==> a 카테고리 안에 모든 내용 합산한 결과까지 (group by a와 같은 효과)
--			전체 ===> 마지막에 한 번 전체 합산한 결과가 출력됨
--	        x, ROLLUP(a, b) : x에 대한 y(rollup(a,b))
--		    x에 대한 a에 대한 b에 대한 소계
--			x에 대한 a에 대한 소계
--			x에 대한 소계
--	        x, ROLLUP(a) => ROLLUP(a)는 a, 전체 총 2번의 결과가 나온다.
--		    x에 대한 a에 대한 소계
--			x에 대한 소계

       -- dept별 pos의 sal 소계, dept별소계, 마지막에 총계 출력
        select dept, pos, sum(sal) from emp
        group by dept, pos --부서별, 부서 안에서 직위별...
        order by dept;
        
        select dept, pos, sum(sal) from emp
        group by ROLLUP(dept, pos)
        order by dept;
        
        select pos, dept, sum(sal) from emp
        group by ROLLUP(pos, dept)
        order by pos;

       -- dept별 pos의 sal 소계, dept별 소계 출력하며 마지막에 총계는 출력하지 않는다.
        SELECT dept, pos, SUM(sal)
        FROM emp
		GROUP BY dept, ROLLUP(pos)
		ORDER BY dept;
        
        SELECT dept,  count(*)
        FROM emp
		GROUP BY dept;
        
        SELECT dept, count(*)
        FROM emp
		GROUP BY ROLLUP(dept);

--    ο CUBE 절 예
       -- dept별 pos의 sal 소계, dept별 소계, pos별 소계, 마지막에 총계 출력
        SELECT dept, pos, SUM(sal)
        FROM emp
		GROUP BY CUBE(dept, pos)
		ORDER BY dept, pos;
    
        SELECT city, dept, pos, SUM(sal)
        FROM emp
		GROUP BY CUBE(city, dept, pos)
		ORDER BY city, dept, pos;
    
        SELECT city, dept, pos, SUM(sal)
        FROM emp
		GROUP BY city, CUBE(dept, pos)
		ORDER BY city, dept, pos;
    
-- ※ GROUPING 함수와 GROUP_ID 함수
--    ο GROUPING 함수
        select dept, pos, GROUPING(dept), GROUPING(pos), sum(sal)
        from emp
        group by ROLLUP(dept, pos);
        
        select dept, pos, sum(sal)
        from emp
        group by ROLLUP(dept, pos)
        having GROUPING(pos)=1; 
    
        select dept, pos, GROUPING(dept), GROUPING(pos), sum(sal)
        from emp
        group by CUBE(dept, pos)
        order by dept, pos; 

        select empNo, name, sum(sal)
        from emp
        group by empNo, name;

        select dept, empNo, name, sum(sal)
        from emp
        group by ROLLUP(dept,(empNo, name)); -- (empNo, name)은 ROLLUP 안에 괄호로 묶였다.
        -- ROLLUP에 묶인 괄호를 하나의 개체로 간주하고 ROLLUP 연산을 수행한다.
        
--    ο GROUP_ID 함수

        -- 다음의 내용 먼저 점검하고 학습
        -- #1
        -- group by rollup(dept, empno)와
        -- group by dept, rollup(dept, empno)의 차이를 설명
        -- #2 select dept, empno, name from emp group by rollup(dept,(empno,name));
        -- 위의 SQL문에서 (empno, name)의 의미를 설명
        
        select dept, empno,  sum(sal) from emp group by rollup(dept, empno) --전체 총 연봉 하나를 더 구한다.
        MINUS
        select dept, empno,  sum(sal) from emp group by dept, rollup(dept, empno)
        order by dept, empno;
        
        select dept, empno, name, GROUP_ID() ,sum(sal) from emp group by dept, rollup(dept, (empno, name))
        order by dept, empno;


        --Group by에서 복제된 횟수를 GROUP_ID 함수로반환해주는 것이다.
        select dept, empNo, name, GROUP_ID(), sum(sal)
        from emp
        group by dept, ROLLUP(dept,(empNo, name))
        order by dept, empNo;

        --복제된 여부(1)를 활용하여 합계와 평균을 동시에 구해서 출력할 수도 있다.
        select dept, empNo, GROUP_ID(), 
            decode(GROUP_ID(),0,NVL(name,'합계'),'평균') name,
            decode(GROUP_ID(),0,sum(sal), ROUND(AVG(sal))) sal
        from emp
        group by dept, ROLLUP(dept,(empNo, name))
        order by dept, GROUP_ID(), empNo;

        SELECT dept, empNo, GROUP_ID(),
           DECODE(GROUP_ID(), 0, NVL(name, '합계'), '평균') name,
           DECODE(GROUP_ID(), 0, SUM(sal), ROUND(AVG(sal))) sal
        FROM emp
        GROUP BY dept, ROLLUP(dept, (empNo, name))
        ORDER BY dept, GROUP_ID(), empNo;

-- ※ GROUPING SETS (UNION ALL과 비슷하다)
    -- 하나로 결합할 때 사용하는 것이 GROUPING SETS이다.
    
    --GROUPING SET 적용 전
    select dept, pos, null, round(AVG(sal)) 평균 from emp GROUP BY dept, pos -- 부서별 직위별 평균
    UNION ALL
    select null , pos, city, round(AVG(sal)) 평균 from emp GROUP BY pos, city; -- 직위별 도시별 평균
    
    --GROUPING SET 적용 후
    select dept, pos, city, round(AVG(sal)) 평균 from emp 
    GROUP BY GROUPING SETS ((dept, pos), (pos,city));
    

