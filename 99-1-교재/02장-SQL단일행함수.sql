--제2장 단일행함수를 배웁니다.

--1. 문자 함수
--INITCAP
--LOWER
--UPPER
--LENGTH
--LENGTHB
--CONCAT
--SUBSTR
--SUBSTRB
--INSTR
--INSTRB
--LPAD
--RPAD
--LTRIM
--RTRIM
--REPLACE
--REGEXP_REPLACE
--REGEXP_SUBSTR
--REGEXP_LIKE
--REGEXP_COUNT

--1.1 INITCAP 함수
select ename, INITCAP(ename) "INITCAP" from emp where deptno=10;
select INITCAP('hello world') from dual; --Hello World

--1.2 LOWER 함수 (소문자화)
select LOWER('HELLO WORLD') from dual;

--1.3 UPPER 함수 (대문자화)
select UPPER('hello world') from dual;

--1.4 LENGTH, LENGTHB 함수
select LENGTH('안녕하세요') from dual;--5
select LENGTHB('안녕하세요') from dual;--15 (한글은 글자당 3바이트로 계산한다)

--1.5 CONCAT 함수 (문자열 합치기)
select CONCAT(ename, job) from emp;
select ename||job from emp;

--1.6 SUBSTR 함수
select SUBSTR('abcde',3,2), --cd: abcde 중 3번째 글자부터 2개
SUBSTR('abcde',-3,2), --cd: abcde 중 뒤에서 3번째 글자부터 2개
SUBSTR('abcde',-3,4) --cde: abcde 중 뒤에서 3번째 글자부터 4개 (그러나 글자는 4글자가 아니라 3글자에서 끝나므로 cde를 반환)
from dual;

--1.7 SUBSTRB 함수
select '서진수' "NAME", SUBSTR('서진수',1,2) "SUBSTR", SUBSTRB('서진수',1,3) "SUBSTRB" from dual;
--SUBSTRB는 byte기준으로 연산하므로 한글은 3byte가 1글자이다. (11g버전부터 3bytes)

--1.8 INSTR 함수
select 'A-B-C-D', INSTR('A-B-C-D', '-',1,3) from dual; --1번째(A)부터 -가 3번째 나온 위치인 6 반환
select 'A-B-C-D', INSTR('A-B-C-D', '-',-1,3) from dual; -- -1번째(D)부터 -가 3번째 나온 위치인 2 반환
select 'A-B-C-D', INSTR('A-B-C-D', '-',-6,2) from dual; -- -6번째(A다음 -)부터 -가 2번째 나온 위치는 없음 0 반환

--퀴즈
--지역번호, 국번 출력하기
 WITH tb AS (
                SELECT '02)6255-9875' tel FROM dual
                UNION ALL
                SELECT '02)312-9838' tel FROM dual
                UNION ALL
                SELECT '053)736-4981' tel FROM dual
                UNION ALL
                SELECT '02)6175-3945' tel FROM dual
                UNION ALL
                SELECT '02)312-2238' tel FROM dual
                UNION ALL
                SELECT '031)345-5677' tel FROM dual
) 
SELECT tel, 
SUBSTR(tel, 1, INSTR(tel,')')-1) as "지역번호",
SUBSTR(tel, INSTR(tel,')')+1, INSTR(tel,'-')-INSTR(tel,')')-1) as "국번"
FROM  tb;

--1.9 LPAD 함수
--총 10자리로 표현하되 나머지 부족한 자리는 *문자열로 출력
select empno, LPAD(empno, 10, '*' ), ename, job from emp; -- ******0000 식으로 출력됨 (empno가 4자리)

--1.10 RPAD 함수
select RPAD(ename, 10, '-') from emp;

-- deptno가 10번인 사원들의 이름을 총 9자리로 출력하되
--오른쪽 빈 자리에는 해당 자릿수에 해당되는 숫자(6789)를 출력
-- CLARK6789
-- KING56789
-- MILLER789
--select ename||RPAD('56789',9-length(ename),'56789') "RPAD"  from emp where deptno=10;
select ename from emp where deptno=10;

--1.11 LTRIM 함수
select ename from emp where deptno = 10;
select LTRIM(ename, 'C') from emp WHERE deptno = 10;

--1.12 RTIM 함수
select ename, RTRIM(ename, 'R') "RTRIM" from emp where deptno=10;

--1.13 REPLACE 함수
select ename, REPLACE(ename, SUBSTR(ename,1,2),'**') "REPLACE"
from emp
where deptno=10;

--REPLACE퀴즈1
--소속된 직원들의 이름과 2~3ㅂㄴ째 글자만 '-'로 변경
select ename, replace(ename, substr(ename,2,2), '--') from emp where deptno=20;

--2.1 ROUND 함수
-- 반올림
select round(987.654,2), --987.65
round(987.654,0), --988
round(987.654,-1) --990
from dual;

--2.2 TRUNC 함수
-- 절삭

--2.3 MOD, CEIL, FLOOR 함수
--MOD: 나머지
--CEIL:주어진 숫자 중 가장 가까운 큰 정수 구하기(음수, 양수일 때 주의)
--FLOOR:주어진 숫자 중 가장 가까운 작은 정수 구하기(음수,양수일 때 주의)

--2.4 POWER 함수
select power(2,3) from dual; -- 2의 3제곱
select power(2,-3) from dual; -- 2의 -3제곱

--3. 날짜 관련 함수
--SYSDATE: 시스템의 현재 날짜와 시간
--MONTHS_BETWEEN: 두 날짜 사이의 개월 수
--ADD_MONTHS: 주어진 날짜에 개월을 더함
--NEXT_DAY: 주어진 날짜를 기준으로 돌아오는 날짜 출력
--LAST-DAY:주어진 날짜가 속한 달의 마지막 날짜 출력

