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

--3.1 SYSDATE 현재 시스템의 시간
select SYSDATE from dual;

--3.2 MONTHS_BETWEEN 두 날짜 사이의 개월 수의 차이
--MONTHS_BETWEEN(A, B) 이면 A-B 연산을 수행한다. (소숫점까지 반환해 준다)
select MONTHS_BETWEEN('20/03/12', '20/07/20') from dual;

--3.3 ADD_MONTHS(날짜, 개월 수)
select ADD_MONTHS('20/03/12', 4) from dual;

--3.4 NEXT_DAY(기준날짜,요일)
--select SYSDATE, NEXT_DAY(sysdate,'MON') from dual;--리눅스 운영체제에서...
select SYSDATE, NEXT_DAY(sysdate,1) from dual; --모든 운영체제 모든 시스템
--주의사항
--오늘이 3/12 목요일인데 NEXT_DAY(SYSDATE,5)을 지정하면 다음 주 목요일을 반환해 준다.
select NEXT_DAY('20/03/12',5) from dual;

--3.5 LAST_DAY(날짜)
select SYSDATE, LAST_DAY(SYSDATE), LAST_DAY('20/03/12') from dual;

--3.6 ROUND(), TRUNC() 날짜에서 쓰이는 함수
select SYSDATE, ROUND(SYSDATE, 'DAY'), TRUNC(SYSDATE, 'DAY') from dual;

--4. 형변환 함수

--4.1 명시적 / 묵시적 형변환
select 2 + TO_NUMBER(2) from dual; --명시적
select '2' + 2 from dual; --묵시적 '2'가 숫자 2로 변환될 것이다.

--4.2 TO_CHAR (날짜에서 문자로)
--YYYY
--RRRR
--YY
--YEAR (영문 이름 전체 연도로 표시)
select TO_CHAR(SYSDATE, 'YEAR') from dual; --TWENTY TWENTY
-- MM 월을 숫자 2자리로
-- MON 영어 3글자
-- MONTH 월을 뜻하는 이름 전체 표시
select TO_CHAR(SYSDATE,'MM'), TO_CHAR(SYSDATE,'MON'), TO_CHAR(SYSDATE,'MONTH') from dual; -- 03, 3월, 3월
--DD 일을 숫자 2자리로
--DAY 요일에 해당하는 명칭
--DDTH 몇 번째 날인지 표시
select TO_CHAR(SYSDATE,'DDTH') from dual; -- 3월 12일 기준으로 12TH
--HH24 24시간 표기법
--HH 12시간 표기법
--MI 분
--SS 초

--QUIZ1.
--Student 테이블에서 birthday 컬럼을 사용하여 생일이 1월인 학생과birthday를 형식에 맞게 출력?
select studno, name, TO_CHAR(birthday,'YY/MM/DD') from student;

--QUIZ2.
--emp테이블의 hiredate컬럼을 사용하여 입사일이 1,2,3월인 사람들의 사번과 이름, 입사일 출력
select empno, ename, hiredate from emp 
where TO_CHAR(hiredate,'MM') in ('01','02','03');

--4.3 TO_CHAR 함수(숫자형에서 문자형으로 변환하기)
select empno, ename, sal, comm, TO_CHAR((sal*12)+comm,'999,999') salary from emp
where ename='ALLEN';

--4.4 TO_NUMBER 함수 (숫자 처럼 생긴 문자를 숫자로 바꾸기)
select TO_NUMBER('5') from dual;

--4.5 TO_DATE()
select TO_DATE('2014/05/31') from dual;

--5. 일반함수
--5.1 NVL(대상, 치환값)
--NULL값이 아니면 대상 값 그대로를 반환하고, NULL이면 치환값으로 지정한 것으로 대체하여 반환한다.
select ename, comm, NVL(comm,0), NVL(comm,100) from emp;

--5.2 NVL2(대상, null이아닌경우, null인 경우)
select empno, ename, sal, comm, NVL2(comm, sal+comm, sal*0) "NVL2" from emp;

--5.3 DECODE(조건,값,TRUE인경우,FALSE인경우)

SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering') "DNAME" from professor;
--101번이 아닌 교수들은 null값이 반환된다.

SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering', 'ETC') "DNAME" from professor;
--101번이 아닌 교수들은 ETC값이 반환된다

SELECT deptno, name, 
DECODE( deptno, 101, '컴공과', 102, '멀미과', 103, '소디과', '기타') from professor;
--101번 => 컴공과
--102번 => 멀미과
--103번 => 소디과
--다른 학과번호 => 기타

--DECODE QUIZ1.
--Student 테이블을 사용하여 제1전공(deptno1)이 101번인 학과 학생들의 이름과 주민번호, 성별을 출력하되
-- 성별은 주민번호 컬럼을 이용하여 7번째 숫자가 1일 경우 MAN 2일 경우에는 WOMAN을 출력
select name, jumin, DECODE(substr(jumin,7,1),1,'MAN',2,'WOMAN') gender from student;

--DECODE QUIZ2.
--Student 테이블에서 전공이(deptno1) 101번인 학생들의 이름, 연락처, 지역을 출력
--단 지역번호 02는 서울, 031은 경기도, 051은 부산, 052는 울산, 055는 경남으로 출력

select name, tel, 
DECODE(substr(tel,1,INSTR(tel,')')-1),
'02','서울',
'031','경기도',
'051','부산',
'052','울산',
'055','경남','기타') loc from student;

--5.4 CASE문
select name, tel,
CASE substr(tel,1,INSTR(tel,')')-1)
WHEN '02' THEN '서울'



WHEN '031' THEN '경기도'
WHEN '051' THEN '부산'
WHEN '052' THEN '울산'
WHEN '055' THEN '경남'
ELSE '기타' 
END loc from student;

--6. 정규식....( 아직 안 배움)