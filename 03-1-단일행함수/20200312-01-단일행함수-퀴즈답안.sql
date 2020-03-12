-- SKY 계정에서 자신의 모든 테이블 목록 출력

SELECT * FROM TAB;
SELECT * FROM TABS;


-- emp 테이블의 구조 출력

DESC emp;
SELECT * FROM col WHERE tname='EMP';
SELECT * FROM cols WHERE table_name='EMP';


-- emp 테이블의 모든 자료 출력
SELECT * FROM emp;


-- emp 테이블에서 city가 서울인 사람중에서 김씨와 이씨만 출력
   -- name, city, sal 컬럼 출력
SELECT name, city, sal FROM emp  WHERE city='서울' AND SUBSTR(name,1,1) IN ('김' , '이');
SELECT name, city, sal FROM emp  WHERE city='서울' AND (SUBSTR(name,1,1)='김' OR SUBSTR(name,1,1)='이');
SELECT name, city, sal FROM emp  WHERE city='서울' AND (INSTR(name,'김')=1 OR INSTR(name,'이')=1);


-- name, rrn, city, dept, pos, 성별 컬럼 출력 : emp 테이블
   --  단, 컬럼명은 모두 한글로 출력하며, 성별은 rrn을 이용하여 계산
SELECT name 이름, rrn 주민번호, city 출신도, dept 부서, pos 직위, DECODE(MOD(SUBSTR(rrn, 8, 1),2), 1, '남자', '여자') 성별 FROM emp;


-- name, dept, hireDate 출력 : emp 테이블
   -- hireDate는 "2020-03-11 수요일" 형식으로 출력하고 컬럼명은 입사일로 변경
SELECT name, dept, TO_CHAR(hireDate, 'YYY-MM-DD DAY') 입사일 FROM emp;


-- name, city, sal, bonus, pay, tax, 실수령액 출력 : emp 테이블
   -- 단, pay=sal+bonus, tax=pay*2%, 실수령액=pay-tax
   -- 세금과 실수령액은 소수점 첫째자리에서 반올림하며 실수령액이 200만원 이상인 자료만 출력
   -- sal, bonus, pay, tax, 실수령액은 원화기호와 세자리마다 컴마를 출력
SELECT name, city, TO_CHAR(sal, 'L999,999,999') 기본급, TO_CHAR(bonus,'L999,999,999') 수당, 
      TO_CHAR(sal+bonus, 'L999,999,999') 총급여, TO_CHAR(ROUND((sal+bonus)*0.02),'L999,999,999') 세금, 
      TO_CHAR(ROUND((sal+bonus)-(sal+bonus)*0.02), 'L999,999,999') 실수령액
FROM emp
WHERE (sal+bonus)-(sal+bonus)*0.02 >=2000000;


-- 70년대생(rrn 이용) 중 city가 서울인 사람만 출력 : emp 테이블
   -- name, rrn, dept, city 출력
SELECT name, rrn, dept, city FROM emp WHERE SUBSTR(rrn,1,1)='7' AND city='서울';
SELECT name, rrn, dept, city FROM emp WHERE SUBSTR(rrn,1,2)>=70 AND SUBSTR(rrn,1,2)<=79 AND city='서울';


-- name, birth, city 출력 : emp 테이블
   -- 단 birth는 rrn을 이용하며, "2000년 10월 10일" 형식으로 출력
SELECT name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY"년" MM"월" DD"일"') birth, city FROM emp;


--근속년수가 10년이상 사람 출력 : emp 테이블
   -- name, 생년월일, 나이, 입사일, 근속년수 출력
   -- 생년월일과 나이는 rrn을 이용하고 근속년수는 hireDate 이용하여 계산
   -- 생년월일은 "2000-10-10" 형식으로 출력
SELECT  name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY-MM-DD') 생년월일,
      TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6)))/12) 나이, hireDate,
      TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 ) 근속년수
FROM emp
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 )>=10;
	  
WITH tb as (
    SELECT  name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY-MM-DD') 생년월일,
         TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6)))/12) 나이, hireDate,
         TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 ) 근속년수
  FROM emp
)
SELECT *
FROM tb WHERE 근속년수>=10;	  


-- dept 및 pos를 중복을 배제하여 출력 : emp 테이블
SELECT DISTINCT dept, pos FROM emp;


-- LIKE를 이용하여 이씨가 아닌 자료만 출력 : emp 테이블
  -- name, ciry 컬럼 출력
SELECT name, city FROM emp WHERE name NOT LIKE '이%';


-- INSTR를 이용하여 이씨가 아닌 자료만 출력 : emp 테이블
  -- name, ciry 컬럼 출력
SELECT name, city FROM emp WHERE INSTR(name, '이') !=1 ;


-- name, dept, pos 출력 : emp 테이블
   -- 부서별 오름차순으로 출력하고 부서가 같으면 직위는 다음순서로 출력
   -- 부장, 과장, 대리, 사원
SELECT name, dept, pos
FROM emp
ORDER BY dept, DECODE(pos, '부장', 0, '과장', 1, '대리', 2, 3);


-- name, dept 컬럼을 출력하며, dept가 총무부인 사람을 먼저 출력 : emp 테이블
SELECT name, dept FROM emp
ORDER BY CASE WHEN dept = '총무부' THEN 0 END;
SELECT name, dept FROM emp
ORDER BY DECODE(dept, '총무부', 0, 1);


-- name, rrn, dept, sal 컬럼 출력 : emp 테이블
   -- 단, 남자를 먼저 출력하고 여자를 출력하며 성별이 같으면 sal 오름차순으로 출력
SELECT name, rrn, dept, sal
FROM emp
ORDER BY 
MOD(SUBSTR(rrn,8,1), 2) DESC, sal;


-- name, dept, sal, bonus, pay, tax, 실수령액 출력 : emp 테이블
   -- 단, pay=sal+bonus,tax 실수령액=pay-tax
   -- tax는 pay가 300만원이상이면 pay의 3%, pay가 250만원이상이면 pay의 2%, 그렇지 않으면 0
   -- tax는 일의자리에서 절삭

WITH tb AS (
   SELECT name, city, sal, bonus,
       sal+bonus pay,
       CASE
            WHEN (sal+bonus) >= 3000000 THEN TRUNC((sal+bonus) * 0.03, -1)
            WHEN (sal+bonus) >= 2000000 THEN TRUNC((sal+bonus) * 0.02, -1)
            ELSE 0
       END AS tax
       FROM emp
)
SELECT name, city, sal, bonus, pay, tax, 
pay-tax 실수령액
FROM tb;


-- city가 서울인 사람 중 근무 개월 수가 60개월 이상인 사람만 출력 : emp 테이블
    -- name, hireDate 출력
SELECT name, hireDate FROM emp
WHERE city='서울' AND MONTHS_BETWEEN(SYSDATE, hireDate) >= 60;


-- tel이 NULL인 자료만 출력 : emp 테이블
   -- name, city, tel 컬럼 출력
SELECT name, city, tel FROM emp
WHERE tel IS NULL;


-- tel이 NULL인 경우 '000-0000-0000' 으로 출력 : emp 테이블
   -- name, city, tel 컬럼 출력
SELECT name, city, NVL(tel, '000-0000-0000') tel FROM emp;


-- tel이 NULL이 아닌 자료만 출력 : emp 테이블
   -- name, city, tel 컬럼 출력
SELECT name, city, tel FROM emp
WHERE tel IS NOT NULL;


-- name, city, tel 컬럼 출력 : emp 테이블
   -- 단, tel이 null인 자료를 먼저 출력
SELECT name, city, tel FROM emp
ORDER BY tel NULLS FIRST;


-- name, hireDate 출력 : emp 테이블
    -- 단, 입사일자가 월요일인 사람만 출력
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DAY') = '월요일';
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'D') = 2;
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DY') = '월';


-- name, hireDate 출력 : emp 테이블
    -- 단, 입사일자의 일자가 1일~5일인 사람만 출력
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DD') >=1 AND TO_CHAR(hireDate, 'DD') <= 5;
select name, hireDate from emp where EXTRACT(DAY from hireDate) >= 1 AND EXTRACT(DAY from hireDate)<=5;

-- 현재시간에서 '2020-03-12 09:00:00' 까지의 차이를 분으로 환산하여 출력 : dual 테이블 이용
SELECT TO_DATE('2020-03-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE FROM dual;
SELECT ROUND((TO_DATE('2020-03-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE) * 24 * 60) FROM dual;


-- 다음달 시작날자 출력(다음달 1일 0시 0분 0초) : dual 테이블 이용
  -- 출력 예 : 2020/04/01 00:00:00
SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, + 1),'MM') ,'YYYY/MM/DD HH24:MI:SS') FROM DUAL; 


-- 다음 쿼리에서 name은 첫글자와 마지막 글자를 제외한 나머지 글자는 *로 치환하여 출력하도록 쿼리를 수정한다.
  -- "김호" 처럼 이름이 두자인 경우는 "김*호" 처럼 출력하고 나머지는 해당 글자만큼 *로 치환한다.
  -- "김호호김"은 "김**김"처럼 출력한다.
WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '010-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel FROM tbs;

WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT SUBSTR(name, 1, 1) || NVL(LPAD('*', LENGTH(name)-2, '*'), '*') || SUBSTR(name, LENGTH(name), 1) AS name, tel FROM tbs;

  -- 이름 마스킹 예
  SELECT SUBSTR('김김', 1, 1) || LPAD('*', LENGTH('김김')-2, '*') || SUBSTR('김김', LENGTH('김김'), 1) FROM dual;
  SELECT SUBSTR('김김', 1, 1) || NVL(LPAD('*', LENGTH('김김')-2, '*'), '*') || SUBSTR('김김', LENGTH('김김'), 1) FROM dual;
  SELECT SUBSTR('김김김김', 1, 1) || LPAD('*', LENGTH('김김김김')-2, '*') || SUBSTR('김김김김', LENGTH('김김김김'), 1) FROM dual;

  SELECT SUBSTR(name, 1, 1) || NVL(LPAD('*', LENGTH(name)-2, '*'), '*') || SUBSTR(name, LENGTH(name), 1) FROM emp;


-- 다음쿼리에서 tel의 국번을 자리수 만큼 *로 치환하여 출력하도록 쿼리를 수정한다.
   -- 예를 들어 "010-1111-1111"는 "010-****-1111"로 출력한다.
WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel FROM tbs;

WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name, SUBSTR(tel, 1, INSTR(tel, '-')) || LPAD('*',INSTR(tel, '-', 1, 2)-INSTR(tel, '-')-1, '*') || SUBSTR(tel,INSTR(tel, '-', 1, 2)) tel FROM tbs;


-- name, rrn 출력 : emp 테이블
  -- 단, rrn은 성별 다음부터는 *로 출력. 예를 들어 "010101-1111111" 은 "010101-1******"
  -- SUBSTR(), LPAD() 함수를 이용한다.
SELECT name, SUBSTR(rrn, 1, 8) || LPAD('*', 6, '*') rrn FROM emp;


