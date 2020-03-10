--단일행 함수

--숫자 함수 종류
--ABS (절댓값) 
select abs(20), abs(-20) from dual;
--결괏값: 20, 20

--SIGN (부호, 양수면 1 음수면 -1)
select SIGN(20), SIGN(-20) from dual;
--결괏값 1, -1

--나머지구하는 연산은 둘 다 동일하다
--MOD(n2, n1)
--REMAINDER(n2, n1)
select mod(13,5) from dual;
-- 3

--CEIL 
--(크거나 같은 가장 작은 정수 반환)
select CEIL(20.5), CEIL(-20.5) from dual;
-- 21, -20

--★FLOOR
--작거나 같은 가장 큰 정수
--소숫점 제거할 때 많이 사용하는 함수이다.
select FLOOR(20.5), FLOOR(-20.5) from dual;
-- 20, -21

--ROUND(소숫점 오른쪽의 정수 자리로 반올림)
--ROUND(n [, integer])
select round(15.693,1) from dual;
--15.7 (소숫점 자릿수는 1자리이므로 소숫점 둘째 자리에서 반올림한다)
select round(15.693) from dual;
select round(15.693,0) from dual; -- 10^0-1= 소숫점 첫 째 자리
--16 (소숫점 첫째 자리에서 반올림하여 정수로 만들어 준다)
select round(15.693,-1) from dual;
--20 (일의자리에서 반올림) 10^-(-1)-1 => 10^0 = 일의자리
select round(14.693,-1) from dual;
-- 10

--★ TRUNC 소숫점 이하 절삭
--그냥 양수, 음수 제외하고 소숫점만 잘라버림
select TRUNC(33.99999), TRUNC(-33.999999) from dual;
--33, -33
select TRUNC(15.79), TRUNC(15.79,1), TRUNC(15.79,-1) from dual;
--15, 15.7, 10

--■ QUIZ
-- emp테이블에서 
-- name, sal, 5만원권 개수, 1만원권 개수, 기타금액 계산하여 출력하기
select 
name, sal, 
trunc(sal/50000) as "5만원권 개수", 
trunc(mod(sal,50000)/10000) as "1만원권 개수",
mod(sal,10000) as "기타금액",
(trunc(sal/50000)*50000 + trunc(mod(sal,50000)/10000)*10000 + mod(sal,10000) ) as "검산"
from emp;

--기타 숫자 함수
-- SIN(N), COS(N), TAN(N), EXP(N), POWER(N2,N1), SQRT(N), LOG(N2,N1), LN(N)


--문자 함수
--LOWER
select LOWER('KOREA 2020') from dual;
--korea 2020

--UPPER
select UPPER('korea 2020') from dual;
--KOREA 2020

--INITCAP
select INITCAP('korea seoul 2020') from dual;
--Korea Seoul 2020

--CHR
select chr(65) || chr(66) from dual;
--AB

--ASCII
select ASCII('KOREA 2020') from dual;
--75 (K값만 출력) 첫 글자에 대한 값만 나온다

--ASCIISTR
select ASCIISTR('KOREA 2020') from dual;
--KOREA 2020
select ASCIISTR('한국 2020') from dual;
--\D55C\AD6D 2020 (한글은 유니코드로 출력된다)

--★SUBSTR
select substr('korea seoul',7,1) from dual; --s
select substr('korea seoul',7) from dual; -- seoul

--LENGTH
select length('korea seoul') from dual; -- 11
