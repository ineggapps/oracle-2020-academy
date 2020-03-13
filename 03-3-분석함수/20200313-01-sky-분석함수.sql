--■ SQL 함수
-- ※ 분석 함수(analytic functions) 와 윈도우 함수(window functions)
-- 함수명() OVER()에서 OVER(PARTITION과 ORDER BY)를 사용할 때 주의하자.
-- PARTITION은 단위별로 나누어 연산을 수행한다는 의미이고
-- ORDER BY는 나누어 연산을 수행하되 값을 누적시켜 나간다는 의미이다.
--    ο 순위 관련 함수
--      1) RANK() OVER() 함수: WHERE절에는 사용할 수 없다.
        --순위 주의사항: 동일한 값은 동일한 순위가 나온다.
        --점수 순위
        --100   1
        --100   1
        --90    3
        
        SELECT name, sal, RANK() OVER(ORDER BY sal desc) 순위 from emp; -- sal 내림차순 순위
        SELECT name, sal, RANK() OVER(ORDER BY sal) 순위 from emp; --sal 오름차순 순위
        
        SELECT name, sal, bonus, 
        RANK() OVER(ORDER BY sal desc, bonus desc) 순위 from emp; -- sal, bonus 내림차순 순위
        
        --부서별로 순위
        --부서별로 순위가 매겨진다. (부서별 1~n위)
        SELECT dept, name, sal, 
        RANK() OVER(PARTITION BY dept ORDER BY sal desc) 순위 from emp;
        
        SELECT dept, name, sal, 
        RANK() OVER(ORDER BY sal DESC) 전체,
        RANK() OVER(PARTITION BY dept ORDER BY sal desc) "부서별 순위",
        RANK() OVER(PARTITION BY dept, pos ORDER BY sal desc) "부서 및 직위별 순위" from emp;
        
        --예제1) 급여 순위가 1~10등만 출력하기
        --1단계. 급여 순위 출력하기
        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
        from emp;
	  
        --2단계. 1~10등만 출력하기
        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
        from emp
        where ROWNUM <= 10; -- 동점자가 있는 경우 의도하지 않은 결과가 나온다.
        
--        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
--        from emp
--        where RANK() OVER(ORDER BY sal DESC); -- WHERE절에 RANK OVER를 못 쓰는데 어떡하지?
        
        SELECT * FROM (
            Select name, sal, RANK() OVER(ORDER BY sal DESC) 순위
            from emp
        ) WHERE 순위 <= 10; --중첩 쿼리 사용.. 이런 식으로도 사용할 수 있구나!
        --중첩쿼리를 써야 한다는 접근법까지는 맞았는데 이렇게 써야 한다는 것까지는 생각지 못했음.
        --중첩쿼리를 WHERE절에 쓰는 접근법은 알지만
        --중첩쿼리를 FROM절에도 쓸 수 있다는 것을 기억하면 좋을 듯.
        
        --예제2) 급여 상위 10% 출력: name, sal
        --1단계. 급여 출력
        select name, sal from emp;
        --2단계. 급여 상위 몇 퍼센트인지 출력
        set timing on;
        TIMING START;
        SELECT TB.*, round((순위/(SELECT count(*) from emp))*100,2)||'%' "상위(%)" FROM (
            select name, sal, RANK() OVER(ORDER BY sal DESC) 순위 from emp
        ) TB WHERE 순위/(SELECT count(*) from emp) <= 0.1; --작성 답안
        TIMING STOP;

        set timing on;
        TIMING START;
        SELECT TB.*, round((순위/(SELECT count(*) from emp))*100,2)||'%' "상위(%)" FROM (
            select name, sal, RANK() OVER(ORDER BY sal DESC) 순위 from emp
            ) TB WHERE 순위 <= (SELECT COUNT(*) FROM emp) * 0.1; --선생님 답안
        --나눗셈을 하지 않았으니까 더 연산이 빠르겠다!
        TIMING STOP;

        --부서별(sal+bonus)가 가장 높은 사람은?
        --1단계. 부서별 순위 출력
        SELECT name, dept, pos, sal, bonus,
		     RANK() OVER(PARTITION BY dept ORDER BY (sal+bonus) DESC) 순위
        FROM emp;
        
        --2단계. 부서별 순위가 1위이면 가장 높은 사람이겠네?
        SELECT dept, name, 실급여 FROM (
            SELECT 
                dept, name, sal+bonus 실급여, 
                RANK() OVER(PARTITION BY dept ORDER BY sal+bonus DESC) 순위 
            from emp
        ) WHERE 순위=1; --작성 답안
        
        SELECT name, dept, pos, sal, bonus FROM (
	      SELECT name, dept, pos, sal, bonus,
		     RANK() OVER(PARTITION BY dept ORDER BY (sal+bonus) DESC) 순위
		  FROM emp
         ) WHERE 순위=1; --선생님 답안
        
        -- dept별 여자 인원수가 가장 많은 부서명 및 인원수 출력?
        -- 0단계. 각 부서별 여자인원수 구하기
         SELECT dept, COUNT(*) 여자인원수
          FROM emp
          WHERE MOD(SUBSTR(rrn,8,1),2)=0
          GROUP BY dept;
                
        --1단계. 부서별 여자 인원수 및 순위 출력
        SELECT dept, COUNT(*) 인원수,
	      RANK() OVER(ORDER BY COUNT(*) DESC) 순위
	  FROM emp
	  WHERE MOD(SUBSTR(rrn,8,1),2)=0
	  GROUP BY dept;
      
        --2단계. 가장 많은 부서명과 인원수만 출력하기
        SELECT dept, 여자인원수 FROM (
            SELECT dept, count(*) 여자인원수,
            RANK() OVER(ORDER BY count(DECODE(mod(substr(rrn,8,1),2),0,999)) DESC) 순위
            from emp group by dept
        ) WHERE 순위=1; --작성 답안
        
          SELECT dept, 인원수 FROM (
              SELECT dept, COUNT(*) 인원수,
                  RANK() OVER(ORDER BY COUNT(*) DESC) 순위
              FROM emp
              WHERE MOD(SUBSTR(rrn,8,1),2)=0
              GROUP BY dept
          ) WHERE 순위=1;-- 선생님 답안
          -- 어차피 여자만 구하는데 WHERE절에서 미리 필터링해주는 것이 좋지.            
                
--
--      2) DENSE_RANK() OVER() 함수
--      동점자가 나왔어도 등수는 순차적으로 매겨짐
--      1등, 1등, 2등, 3등 ... (DESNSE_RANK)
--      1등, 1등, 3등, 4등 ... (RANK)
--      1번, 2번, 3번, 4번 ...(ROW_NUMBER)
        
        
--
--      3) ROW_NUMBER() OVER( ) 함수
        SELECT name, sal, 
        ROW_NUMBER() OVER(ORDER BY sal desc) 순위
        from emp;

--
--     4) RANK() WITHIN GROUP() 함수
--      EX) SAL이 300만원인데 몇 등인지?
        SELECT RANK(3000000) WITHIN GROUP(ORDER BY sal DESC) "몇 등?"
        from emp;
        
--  ※ 집계함수가 아니라 분석함수임에 유의한다.
--  COUNT() OVER() 는 일반 함수와 결합하여 사용할 수 있다는 이야기이다.
--    ο COUNT() OVER(), SUM() OVER(), AVG() OVER(), MAX() OVER(), MIN() OVER() 함수
--      1) COUNT() OVER() 함수
--        SELECT name, sal, COUNT(*) from emp;     --오류...
          SELECT name, sal, (SELECT count(*) FROM emp) "총 인원" from emp; --SUBQUERY를 이용하여 사용할 수는 있었음.
         
         SELECT name, dept, sal, COUNT(*) OVER(ORDER BY empno) cnt  from emp; --현재 기준선까지의 인원수를 살핀다는 의미임
         --1 2 3 4 순으로 출력...
         --EMPNO는 사원번호이므로 사원번호는 같은 것이 없으니까 일일이 카운팅하는 것.
         
         SELECT name, dept, sal, COUNT(*) OVER(ORDER BY dept) cnt  from emp; 
         --1단계) DEPT를 기준으로 정렬하고
         --2단계) DEPT별로 COUNT를 집계한다. (같은 부서별 인원수를 집계하고 이전 부서 인원수를 누적하면서 출력)
         --주의사항: ORDER BY만 기술한 경우
         -- 부서별로 인원수를 집계하는 것은 맞지만 누적된다는 것에 유의한다.
         --단, 동일 부서에서는 계속 같은 결괏값만을 출력한다.
         --14, 14, 14, ..., 21, 21, ..., 37, 37, ...,  60.
         --SUM() OVER() 등 앞으로의 함수들도 마찬가지로 기준항목(ORDER BY ~)을 기준으로 하여 누적집계를 해나간다.

        SELECT name, dept, sal,
        COUNT(*) OVER() cnt
        --주의사항: 기준점이 없으므로 전체 인원수를 일괄적으로 출력한 결괏값이 나타난다.
        from emp;

        SELECT name, dept, sal,
        COUNT(*) OVER(PARTITION BY dept) cnt
        --주의사항: PARTITION BY를 기술한 경우
        -- ORDER BY 기준 항목에서 누적시켜나가는 것과는 다르게 
        -- PARTITION BY는 dept별로 집계한 총 인원수를 출력한다. (누적 아님)
        from emp;
        --결과:
        
        SELECT name, dept, pos, sal,
        COUNT(*) OVER(PARTITION BY dept) cnt1,
        COUNT(*) OVER(PARTITION BY dept ORDER BY empno) cnt2
        --주의사항: PARTITION BY + ORDER BY 를 결합한 경우
        -- PARTITION BY: 부서별로 인원수를 집계한다
        -- ORDER BY는 PARTITION BY에서 지정한 항목 안에서만 누적시켜서 더한 값을 출력한다.
        -- ORDER BY empno: 부서별로 사원을 하나씩 카운팅해나간다. 부서가 바뀌면 다시 1부터 카운팅을 시작한다.
        from emp;

--      2) SUM() OVER() 함수
        
        SELECT name, dept, sal, SUM(sal) OVER() from emp; --직원들의 총 급여금액이 출력
        SELECT name, dept, sal, SUM(sal) OVER(ORDER BY empNo) from emp; --사원별로 순차적으로 누적한 금액 출력
        --활용 예) 통신요금 누계 등...
        SELECT name, dept, sal, SUM(sal) OVER(ORDER BY dept) from emp; -- 부서별로 순차적으로 누적한 금액 출력
        --부서별 총합 => 부서가 바뀌면 이전 부서들의 금액을 누적시켜서 계속 출력함

        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept) from emp; --부서별 sal의 합계 출력 (누적X)
        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept ORDER BY empNo) from emp; 
        --각 부서 안에서 사원별로 순차적으로 누적한 금액 출력
--        SELECT name, dept, sal, pos, SUM(sal) OVER(PARTITION BY dept ORDER BY empNo) from emp; 
        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept ORDER BY sal) from emp;
        -- 각 부서 안에서 봉급별로 순차적으로 누적한 금액 출력
        -- 단, 같은 봉급이 있으면 같은 봉급끼리 합쳐 (135만 2명 => 이전 봉급 누계 +270만) 이런 식으로 집계하여 출력

        --예제1)
        -- 이름 부서명 부서 급여(sal) (부서총급여에 대한 백분율)
        SELECT name, dept, sal,  
        round((sal / SUM(sal) OVER(PARTITION BY dept))*100,2)||'%' "부서 총 급여에 대한 백분율",
        SUM(sal) OVER(PARTITION BY dept) "부서별 총 급여"
        from emp;r
        
        --예제2)
        -- 부서명  성별  인원수  부서성별백분율
        -- 개발부   남자  5         50%
        -- 개발부   여자  5         50%
        SELECT DISTINCT dept, 
        '남자' 성별, 
        count(DECODE(mod(substr(rrn,8,1),2),1,9999)) OVER(PARTITION BY dept) 인원수,
        round(count(DECODE(mod(substr(rrn,8,1),2),1,9999)) OVER(PARTITION BY dept) / count(*) OVER(PARTITION BY dept) * 100,2)||'%'성비
        from emp
        UNION ALL
        SELECT DISTINCT dept, 
        '여자' 성별, 
        count(DECODE(mod(substr(rrn,8,1),2),0,9999)) OVER(PARTITION BY dept) 인원수,
        round(count(DECODE(mod(substr(rrn,8,1),2),0,9999)) OVER(PARTITION BY dept) / count(*) OVER(PARTITION BY dept) * 100,2)||'%'성비
        from emp
        order by dept, 성별; --작성 답안
        
        --선생님 답안
        --1단계) 부서별로 남자, 여자 구분하여 인원수 세기
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자') 성별, count(*) 인원수 
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자');
        
        --2단계) 부서별 성별 인원수 표기하기
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자') 성별, count(*) 인원수,
            SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자');
        
        --3단계) 
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자') 성별, 
            count(*) 인원수, 
            --count(*)은 이미 group by에서 그룹 단위별로 나누었을 때의 총 인원을 의미한다.
            --GROUP BY에서 부서, 성별대로 나누었으므로 부서 안 성별에 의하여 계산된 집곗값이 나온다.
            --따라서 개발부 남자별 인원, 개발부 여자별 인원이 카운트되어 나온다.
            round(count(*)/SUM(COUNT(*)) OVER(PARTITION BY dept)*100)||'%' 비율,
            SUM(COUNT(*)) OVER(PARTITION BY dept) 부서인원
            --부서 인원은 SUM() OVER()함수를 이용하여 구할 수 있다. 2가지 사항을 조합하여 백분율을 구할 수 있다.
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'남자','여자'); --선생님 답안

--      3) AVG() OVER() 함수
        SELECT name, dept, sal, ROUND(AVG(sal) OVER()) from emp; -- 전체 직원의 봉급의 평균을 구한다.
        SELECT name, dept, sal, sal-ROUND(AVG(sal) OVER()) 편차 from emp; --전체 봉급 평균에서 자신의 평균을 제거.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(ORDER BY empno)) from emp;
        --직원별로 하나씩 누적하여 SAL의 평균값을 매긴다.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(ORDER BY dept)) from emp; 
        --부서 단위로 한 부서씩 누적하여 SAL의 평균값을 매긴다.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(PARTITION BY dept)) from emp; --부서별 평균 구하기
                
--      4) MAX() OVER()와 MIN() OVER() 함수
        SELECT name, dept, sal, 
        MAX(sal) OVER() 최대봉급, 
        MIN(sal) OVER() 최소봉급
        from emp;
        
        SELECT name, dept, sal, 
        MAX(sal) OVER() - sal 최대봉급과의차이, 
        sal - MIN(sal) OVER() 최소봉급과의차이
        from emp;
        
        SELECT name, dept, sal, 
        MAX(sal) OVER(PARTITION BY dept) "부서별 최댓값",
        MIN(sal) OVER(PARTITION BY dept) "부서별 최솟값"
        from emp;
        
--    ο RATIO_TO_REPORT() OVER() 함수 (11버전부터 등장)
-- 값의 세트의 합에 대한 값의 비율을 계산.
--      RATIO를 이용하지 않는 방법
        SELECT dept, ROUND(COUNT(*)/(SELECT COUNT(*) FROM emp)*100)||'%' 비율 
        from emp 
        GROUP BY dept;
        
--      RATIO를 이용한 방법
        SELECT dept, 
            ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() * 100)||'%' 비율
        FROM emp
        GROUP BY dept;

--    ο LISTAGG () WITHIN GROUP() 함수
--      그룹 단위별로 결합을 진행한다.
        SELECT dept, LISTAGG(name, ',') WITHIN GROUP(ORDER BY empno) "부서별 사원"
        from emp
        GROUP BY dept; -- 그룹짓는 함수이므로 GROUP BY를 꼭 명시해줘야 한다.

--    ο LAG () OVER() 함수와  LEAD() OVER()  함수
        SELECT name, sal,
        LAG(sal, 1, 0) OVER(ORDER BY SAL DESC) lag,
        --LAG(대상, 몇 칸 밀릴 것인가, 해당 위치가 맨 첫 부분이면 지정할 기본값)
        LEAD(sal, 1, 0) OVER(ORDER BY SAL DESC) lead
        --LEAD(대상, 몇 칸 앞의 값을 가져올 것인가, 해당 위치가 맨 끝부분이면 지정할 기본값)
        from emp;

--    ο NTILE() OVER() 함수
        SELECT name, sal,
        NTILE(6) OVER(ORDER BY sal DESC) 그룹 -- 전체 개수를 N개의 ORDER 단위별로 그룹으로 나눈다.
        from emp;
        
        SELECT v, NTILE(5) OVER(ORDER BY v) x from (
            SELECT LEVEL v from dual CONNECT BY LEVEL <= 17-- 쿼리 해당되는 내용을 반복시킴
        );
        
        --17/5 = 몫:3, 나머지:2
        --나머짓값은 앞 그룹에 하나씩 순차적으로 할당한다.
        
--    ο 윈도우 절(window clause)
--      - 형식
--       { ROWS | RANGE }
--         { BETWEEN
--               { UNBOUNDED PRECEDING  | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } } 
--              AND
--              { UNBOUNDED FOLLOWING | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } }
--         | { UNBOUNDED PRECEDING | CURRENT ROW | value_expr PRECEDING }
--        }

--
--    ο FIRST_VALUE() OVER
--      윈도우에서 정렬된 값 중에서 첫 번째 값을 반환하는 함수
        SELECT name, dept, sal,
        FIRST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC) from emp;
        --MAX() VALUE()와 유사한 효과를 낸다
        
        SELECT name, sal,
        FIRST_VALUE(sal) OVER(ORDER BY sal DESC) - sal 차이
        from emp;
        
--
--    ο LAST_VALUE() OVER() 함수
--       - 예
--         -- LAST_VALUE 함수는 윈도우절을 지정하지 않으면 디폴트로
--            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 가 적용되어
--            끝값으로 고정되어 있지 않으므로 예기치 않는 결과가 출력 되므로 반드시 윈도우절을 지정해야 한다.

        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC) from emp;
        --MIN() VALUE()와 유사한 효과를 낸다.
        
        --작은 것에서 큰 순
        SELECT name, dept, sal, LAST_VALUE(sal) OVER(ORDER BY sal) from emp 오름차순급여;
        --값을 누적하면서 오름차순으로 정렬된 데이터 중 가장 마지막 값이 출력된다. 
        
        --DB에 등록된 마지막 값 가져오기
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER() from emp; --BUT 항상 똑같은 순서를 보장받을 수는 없다.
        --오라클 버전에 따라 값이 다르게 출력될 수 있다.
        --정렬하는 방식이 버전별로 알고리즘에 차이가 있을 수 있기 때문이다.
        --따라서 정렬을 보장 받고 싶으면 order by 구문으로 정렬을 수행한다.
        
        --정렬된 값 중 가장 큰 값이 출력된다
        -- ∵ ORDER BY로 인해 오름차순으로 정렬되어 마지막 값은 가장 큰 값이 된다.
        --따라서 정렬된 값 중 가장 마지막 값을 가져오게 된다.
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER() from emp
        ORDER BY sal; 
        
        --OVER 안의 ORDER BY는 단위별 정렬된 대상을 기준으로 값을 누적시켜가면서 마지막 값을 비교한다.
        --따라서 금액이 달라질 때마다 단위별 정렬된 대상 중 마지막 값이 출력된다. 
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER(ORDER BY sal) from emp
        ORDER BY sal; 
        
        --위의 쿼리문 결과와 똑같다.
        SELECT name, dept, sal,
        LAST_VALUE(sal) 
        OVER(ORDER BY sal 
        --UNBOUNDED PRECEDING: 첫 번째 로우가 시작 지정으로 고정
        --범위를 첫 번째 로우부터 현재 로우까지로 지정하여 비교
        --따라서 값이 계속 달라지겠지?
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW--기본 옵션이라서 생략하여도 된다.
        ) 결과
        from emp
        ORDER BY sal; 
   
        --가장 큰 값
        SELECT name, dept, sal,
        LAST_VALUE(sal) 
        OVER(ORDER BY sal 
        --UNBOUNDED FOLLOWING: 시작 지점이 마지막 지점으로 고정
        --범위를 첫 번째 로우부터 끝 번째 로우로 지정하였음. 그러므로 LAST_VALUE에 의해서 마지막 로우의 값이 계속 나오겠지?
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 결과
        from emp
        ORDER BY sal; 
        
        
        
        
        