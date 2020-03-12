--참고사항: 주민등록번호 연산 시 편의상 연도는 RR을 이용하기. (실제 연산 시에는 모든 경우의 수를 고려하여 작성해야 한다)

-- SKY 계정에서 자신의 모든 테이블 목록 출력
select * from tab;
select * from tabs;

-- emp 테이블의 구조 출력
desc emp;
select * from COL where tname='EMP';
select * from COLS where table_name ='EMP';

-- emp 테이블의 모든 자료 출력
select * from emp;

-- emp 테이블에서 city가 서울인 사람중에서 김씨와 이씨만 출력
   -- name, city, sal 컬럼 출력
select name, city, sal
from emp
where city='서울' and (substr(name,1,1)='김' or INSTR(name,'이')=1); -- 작성 답안
--where city='서울' and substr(name,1,1) in ('김','이'); -- 제시 답안

-- name, rrn, city, dept, pos, 성별 컬럼 출력.
   --  단, 컬럼명은 모두 한글로 출력하며, 성별은 rrn을 이용하여 계산
select 
name 이름, rrn 주민등록번호, city 지역, dept 부서, pos 지위,
decode(mod(substr(rrn,8,1),2),1,'남','여') 성별
from emp;

select
name 이름, rrn 주민등록번호, city 지역, dept 부서, pos 지위,
CASE mod(substr(rrn,8,1),2)
WHEN 1 THEN '남'
else '여'
END 성별
from emp;

--(자체 복습... 주민등록번호 뒷자리 1자리를 제외하고 모두 가려 출력하기)
select 
name 이름, RPAD(substr(rrn,1,8),length(rrn),'*') 주민등록번호, city 지역, dept 부서, pos 지위,
decode(mod(substr(rrn,8,1),2),1,'남','여') 성별
from emp;

select
name 이름, RPAD(substr(rrn,1,8),length(rrn),'*') 주민등록번호, city 지역, dept 부서, pos 지위,
CASE mod(substr(rrn,8,1),2)
WHEN 1 THEN '남'
else '여'
END 성별
from emp;

-- name, dept, hireDate 출력
   -- hireDate는 "2020-03-11 수요일" 형식으로 출력하고 컬럼명은 입사일로 변경
select name, dept, 
TO_CHAR(hireDate,'YYYY-MM-DD DAY') 입사일 
from emp;

-- name, city, sal, bonus, pay, tax, 실수령액 출력
   -- 단, pay=sal+bonus, tax=pay*2%, 실수령액=pay-tax
   -- 세금과 실수령액은 소수점 첫째자리에서 반올림하며 실수령액이 2000000만원 이상인 자료만 출력
   -- sal, bonus, pay, tax, 실수령액은 원화기호와 세자리마다 컴마를 출력

--with with and double select
select name, city, 
TO_CHAR(sal,'L999,999,999') sal,
TO_CHAR(bonus,'L999,999,999') bonus,
TO_CHAR(pay,'L999,999,999') pay,
TO_CHAR(round(pay-tax,1),'L999,999,999') 실수령액 from (
    WITH tb as (
        select name, city, 
        sal,
        bonus,
        sal+nvl(bonus,0) pay from emp
    )
    select tb.*, round(pay*0.02,1) tax from tb
) tbb;

-- with with
WITH tb as (
    select name, city, sal, bonus, 
    sal+nvl(bonus,0) pay, 
    round((sal+nvl(bonus,0))*0.02,1) tax
    from emp
) 
select 
name, city,
TO_CHAR(sal, 'L999,999,999') sal ,
TO_CHAR(bonus,'L999,999,999') bonus,
TO_CHAR(pay,'L999,999,999') pay,
TO_CHAR(round(pay-tax,1),'L999,999,999') 실수령액 from tb;

--without with
select name, city, 
    TO_CHAR(sal, 'L999,999,999') sal,
    TO_CHAR(bonus,'L999,999,999') bonus, 
    TO_CHAR(sal+nvl(bonus,0),'L999,999,999') pay, 
    TO_CHAR(round((sal+nvl(bonus,0))*0.02,1),'L999,999,999') tax,
    TO_CHAR(round(sal+nvl(bonus,0)-round((sal+nvl(bonus,0))*0.02,1),1),'L999,999,999') 실수령액
from emp;

-- 70년대생(rrn 이용) 중 city가 서울인 사람만 출력
   -- name, rrn, dept, city 출력

--날짜함수 활용 전
select name, rrn, dept, city from emp
where substr(rrn,1,1)=7;

-- name, birth, city 출력
   -- 단 birth는 rrn을 이용하며 "2000년 10월 10일" 형식으로 출력

select name, 
TO_CHAR(TO_DATE(substr(rrn,1,6),'RRMMDD'),'YYYY"년" MM"월" DD"일"') birth, 
city 
from emp;

--근속년수가 10년이상 사람 출력
   -- name, 생년월일, 나이, 입사일, 근속년수 출력
   -- 생년월일과 나이는 rrn을 이용하고 근속년수는 hireDate 이용하여 계산
   -- 생년월일은 "2000-10-10" 형식으로 출력

select name,
TO_CHAR(TO_DATE(substr(rrn,1,6),'RRMMDD'),'YYYY-MM-DD') 생년월일,
TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(substr(rrn,1,6),'RRMMDD'))/12)||'세' 나이, 
TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12)||'년' 근속년수
from emp
where TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12)>=10;


-- dept 및 pos를 중복을 배제하여 출력

select dept, pos from emp; --중복 배제 전
select distinct dept, pos from emp order by dept; -- 중복 배제 키워드 또는 UNIQUE 예약어도 가능

-- LIKE를 이용하여 이씨가 아닌 자료만 출력
  -- name, ciry 컬럼 출력

select name, city from emp
where name not like '이%';

-- INSTR를 이용하여 이씨가 아닌 자료만 출력
  -- name, ciry 컬럼 출력

select name, city from emp
where INSTR(name,'이')<>1;

-- name, dept, pos 출력
   -- 부서별 오름차순으로 출력하고 부서가 같으면 직위는 다음순서로 출력
   -- 부장, 과장, 대리, 사원

select name, dept, pos from emp
order by dept, 
CASE pos
WHEN '부장' THEN 0
WHEN '과장' THEN 1
WHEN '대리' THEN 2
--WHEN '사원' THEN 3
ELSE 3
END;

select name, dept, pos from emp
order by dept,
DECODE(pos,'부장',0,'과장',1,'대리',2,3);

-- (문제 수정) 개발부 => 총무부
-- name, dept 컬럼을 출력하며, dept가 총무부인 사원을 먼저 출력

select name, dept from emp
order by 
CASE dept
WHEN '총무부' THEN 0
else 1
END;

select name, dept from emp
order by DECODE(dept,'총무부',0,1);

-- name, rrn, dept, sal 컬럼 출력
   -- 단, 남자를 먼저 출력하고 여자를 출력하며 성별이 같으면 sal 오름차순으로 출력

select name, rrn, dept, sal from emp
order by mod(substr(rrn,8,1),2) desc, sal asc;

-- name, dept, sal, bonus, pay, tax, 실수령액 출력
   -- 단, pay=sal+bonus,tax 실수령액=pay-tax
   -- tax는 pay가 300만원이상이면 pay의 3%, pay가 250만원이상이면 pay의 2%, 그렇지 않으면 0
   -- tax는 일의자리에서 절삭

select TBB.*, pay-tax 실수령액 from (
WITH TB as (
    select name, dept, sal, bonus,
    sal+nvl(bonus,0) pay
    from emp
)
select tb.*, 
CASE
WHEN pay>=3000000 THEN trunc(pay*0.03,-1)
WHEN pay>=2500000 THEN trunc(pay*0.02,-1)
ELSE 0
END tax
from TB) TBB;

-- city가 서울인 사람 중 근무 개월 수가 60개월 이상인 사람만 출력
    -- name, hireDate 출력

select name, hireDate, TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate))||'개월' "근무 개월 수" from emp
where MONTHS_BETWEEN(SYSDATE,hireDate)>=60
order by hireDate desc; --확인용 정렬 옵션

-- tel이 NULL인 자료만 출력
   -- name, city, tel 컬럼 출력

select name, city, tel from emp 
where tel is null;

-- tel이 NULL인 경우 '000-0000-0000' 으로 출력
   -- name, city, tel 컬럼 출력

select name, city, nvl(tel,'000-0000-0000') 처리결과 from emp
order by tel asc nulls first;
--참고: NVL로 NULL값이 처리되어도 nulls first가 먹힌다

-- tel이 NULL이 아닌 자료만 출력
   -- name, city, tel 컬럼 출력

select name, city, tel from emp
where tel is not null;

-- name, city, tel 컬럼 출력
   -- 단, tel이 null인 자료를 먼저 출력

select name, city, tel from emp
order by tel nulls first;

-- name, hireDate 출력
    -- 단, 입사일자가 월요일인 사람만 출력

select name, hireDate, TO_CHAR(hireDate,'DAY') 입사요일 from emp
where TO_CHAR(hireDate,'D')=2; --작성 답안

select name, TO_CHAR(hireDate, 'YYYY-MM-DD DAY') from emp
where TO_CHAR(hireDate,'DAY')='월요일'; -- 제시 답안

-- name, hireDate 출력
    -- 단, 입사일자의 일자가 1일~5일인 사람만 출력

--TO_CHAR 사용
select name, hireDate from emp
where TO_CHAR(hireDate,'DD') >= 1 and TO_CHAR(hireDate,'DD') <=5;

--extract 사용

select name, hireDate from emp
where EXTRACT(DAY from hireDate) BETWEEN 1 AND 5;

select name, hireDate from emp
where EXTRACT(DAY from hireDate) >= 1 and EXTRACT(DAY from hireDate) <=5 ;


-- 현재시간에서 '2020-03-12 09:00:00' 까지의 차이를 분으로 환산하여 출력
-- 현재 시간이 비교대상(3/12)보다 늦다는 가정 하에 작성
-- 날짜에서 날짜를 빼면 일수를 반환한다. 단위가 일수라는 것에 유념하고 작성한다.
--날짜를 담은 문자형은 날짜로 자동변환되지 않는다.
--select '2020-03-12 09:00:00' - SYSDATE from dual; --오류
--select TO_DATE('2020-03-12 09:00:00') - SYSDATE from dual; --오류

--시각이 3월 12일 09시 이전 기준 쿼리
select trunc((TO_DATE('2020-03-12 09:00:00','YYYY-MM-DD HH:MI:SS')-SYSDATE)*24*60)||'분' as "시간이 남았습니다" from dual;
--시각이 3월 12일 09시 이후 기준 쿼리
select trunc((SYSDATE-TO_DATE('2020-03-12 09:00:00','YYYY-MM-DD HH:MI:SS')) *24*60)||'분' as "시간이 경과된 지" from dual;

-- 다음달 시작날자 출력(다음달 1일 0시 0분 0초)
  -- 출력 예 : 2020/04/01 00:00:00
select TO_CHAR(LAST_DAY(TRUNC(SYSDATE,'DAY'))+1,'YYYY/MM/DD HH24:MI:SS') "다음달 시작 날짜" from dual;
select TO_CHAR(LAST_DAY(TRUNC(SYSDATE,'DAY'))+INTERVAL '1' DAY,'YYYY/MM/DD HH24:MI:SS') "다음달 시작 날짜" from dual;

select TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE,1),'MM'), 'YYYY/MM/DD HH24:MI:SS') --선생님 답안
from dual;

---■■■■■ 추가된 문제

-- 다음쿼리에서 name은 첫글자와 마지막 글자를 제외한 나머지 글자는 *로 치환하여 출력하도록 쿼리를 수정한다.
  -- "김호" 처럼 이름이 두자인 경우는 "김*호" 처럼 출력하고 나머지는 해당 글자만큼 *로 치환한다.
  -- "김호호김"은 "김**김"처럼 출력한다.
WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name,
substr(name,1,1)||
--DECODE(length(name),2,'*',LPAD('*',length(substr(name,2,length(name)-1))-1,'*'))
--NVL로 하면 이렇게 쉬운 것을!
nvl(LPAD('*',length(substr(name,2,length(name)-1))-1,'*'),'*')
||substr(name,length(name)) 개인정보보호
,tel
FROM tbs;

--힌트
select 
substr('김김',1,1) || 
nvl(LPAD('*', length('김김')-2,'*'),'*')||
substr('김김',length('김김'))
from dual;

--마스킹 편법
select
-- LPAD 원리
-- 1단계. 총 4자리에 A를 입력 => 잔여 3자리
-- 2단계. 남은 3자리에 *을 입력 => LPAD이므로 A 뒤에 *** 입력
---결과: A***
-- 응용: A 대신 *을 입력하면? 원하는 자릿수만큼의 * 입력하기 끝...
LPAD('A',4,'*')
from dual;


-- 다음쿼리에서 tel의 국번을 자리수 만큼 *로 치환하여 출력하도록 쿼리를 수정한다.
   -- 예를 들어 "010-1111-1111"는 "010-****-1111"로 출력한다.
WITH tbs AS (
   SELECT '김호' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '나대한민국' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '스프링' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT '홍길동' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '미미' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel, 
substr(tel,1,INSTR(tel,'-'))||
LPAD('*',length(substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-'))),'*')||
substr(tel,INSTR(tel,'-',1,2),length(tel)) "가린 전화번호",
substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')) "검산",
INSTR(tel,'-') "하이픈 처음 등장 위치",
INSTR(tel,'-',1,2) "하이픈 두 번 등장 위치"
FROM tbs;

--INSTR(tel,'-')): 전화번호에서 하이픈(-)이 처음 등장하는 곳의 위치
--INSTR(tel,'-'))-1: 전화번호에서 하이픈(-)이 처음 등장하기 전까지의 위치

--INSTR(tel,'-',1,2): 전화번호에서 하이픈(-)이 두 번째로 등장하는 곳의 위치
--INSTR(tel,'-',1,2)-1: 전화번호에서 하이픈(-)이 두 번째로 등장하기 전까지의 위치

-- 중간 국번 구하는 원리
-- A - B라고 정했을 때,
--INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')
--두 번째 하이픈(-)의 등장 전의 위치에서 첫 번째 하이픈(-)의 등장한 위치를 뺀다.
--010-1234-4125의 경우 
--A=8
--B=4

--substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')) "검산" 해설
--substr(전화번호, 전화번호에서 하이픈이 처음 등장하는 위치+1, 
-- 전화번호에서 두 번째로 하이픈이 등장하는 위치 - 1 - 처음 등장하는 위치)
--substr(tel, A, B) 일때
--010-1234-4125의 경우에
--substr(tel, 5, 8-4)가 된다.
--02-235-4125의 경우에
--substr(tel, 4, 6-3)가 된다.

-- name, rrn 출력 : emp 테이블
  -- 단, rrn은 성별 다음부터는 *로 출력. 예를 들어 "010101-1111111" 은 "010101-1******"
  -- SUBSTR(), LPAD() 함수를 이용한다.
select name, rrn, RPAD(substr(rrn,1,8),14,'*') 개인정보보호 from emp;
select name, rrn, substr(rrn,1,8)||LPAD('*',6,'*') 개인정보보호 from emp; -- 문자열을 결합

-- REPLACE 예제
-- 전화번호 구분자(-) 없이 출력하기
 select REPLACE(tel,'-') from emp;