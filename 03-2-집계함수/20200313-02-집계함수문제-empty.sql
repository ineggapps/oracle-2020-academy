-- sal+bonus 의 총합, 평균, 최대, 최소값 출력 : emp 테이블
    -- 총합  평균  최대  최소



-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   성별   인원수



-- 출신도(city)별 남자와 여자 인원수 출력 : emp 테이블
    -- city   남자인원수  여자인원수



-- 부서(dept)별 남자 인원수가 7명 이상인 부서명과 인원수 출력 : emp 테이블
    -- dept  인원수



-- 부서(dept)별 인원수와 부서의 월별로 생일인 사람의 인원수 출력 : emp 테이블
    -- dept  인원수 M01  M02  M03 .... M12



-- sal를 가장 많이 받는 사람의 name, sal 출력 : emp 테이블
    -- name   sal



-- 출신도(city)별 여자 인원수가 가장 많은 출신도 및 여자 인원수를 출력 : emp 테이블
    -- city   인원수



-- 부서(dept)별 인원수 및 부서별 인원수가 전체 인원수의 몇 %인지 출력 : emp
    -- dept  인원수  백분율



-- 부서(dept) 직위(pos)별 인원수를 출력하며, 마지막에는 직위별 전체 인원수 출력 : emp 테이블
   -- ROLLUP을 사용하며, 부서별 오름차순 정렬
   -- 출력 예
dept       pos    인원수
개발부    과장    2
개발부    사원    9
개발부    부장    1
개발부    대리    2
기획부    사원    2
     :
           사원    32
           부장    7
           과장    8
           대리    13



-- 부서(dept) 직위(pos)별 인원수를 출력 : emp 테이블
    -- 출력 예
dept       부장  과장  대리  사원
총무부    1       2      0      4
개발부    1       2      2      9
            :



-- 부서(dept) 직위(pos)별 인원수를 출력하고 마지막에 직위별 인원수 출력 : emp 테이블
    -- 출력 예
dept       부장  과장  대리  사원
개발부    1       2      2      9
기획부    2       0      3      2
            :
            7        8     13     32



