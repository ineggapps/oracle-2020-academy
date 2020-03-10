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
select substr('seoul korea',7,3) from dual; --kor
select substr('seoul korea',-5, 3) from dual; --kor
select substr('seoul korea',7) from dual; -- korea

--QUIZ1.
--생년월일이 78~82년생만 출력: name, sal, rrn
--단, sal 내림차순
select name, sal, rrn
from emp
where substr(rrn,1,2)>=78 and substr(rrn,1,2)<=82
order by sal desc;

select name, sal, rrn from emp
where substr(rrn,1,2) between 78 and 82
order by sal desc;

--QUIZ2.
--city가 서울, 경기, 인천인 사람 중 남자만 출력
--name, city, rrn
select name, city, rrn from emp
where city in ('서울','경기','인천') and mod(substr(rrn,8,1),2)=1;
--ORACLE에서는 자동 형변환을 지원한다.

--자체QUIZ2-1.
--(페이징 복습)
--city가 서울, 경기, 인천인 사람을 city로 오름차순 정렬하고
--그중 rownum이 6~10인 사람만 출력
select * from (
    select rownum rnum, tb.* from (
        select name, city, rrn
        from emp where city in('서울','경기','인천') 
        order by city
    ) tb where rownum<=10
) where rnum>=6;

--LENGTH
select length('korea seoul') from dual; -- 11

--★INSTR
--string에서 substring을 검색하여 문자열의 위치를 반환, 없으면 0을 반환한다.
--LIKE보다 성능이 좋다.
select INSTR('korea seoul','e') from dual;--4 (최초 발견된 지점인 4 반환)
select INSTR('korea seoul','abc') from dual;--0 (없으니까 0 반환)
select INSTR('korea seoul','e',7) from dual;--8 (7번째 문자부터 검색)
select INSTR('korea seoul','e',1,2) from dual;--8 (1번째 문자부터 검색, 2번째 나타난 위치인 8 반환)

--성이 김씨인 사람만 검색하는 방법 (이름의 첫 글자는 성씨가 온다는 점 INSTR(함수내용...)=1)
select name, pos from emp where INSTR(name,'김',1)=1; -- INSTR을 이용한 방법
select name, pos from emp where name LIKE '김%'; -- LIKE를 이용한 방법

-- 이름(성 포함)에 이가 있는 모든 사람 출력
select name, pos from emp where INSTR(name,'이')>0; -- INSTR을 이용한 방법
select name, pos from emp where name like '%이%'; --LIKE를 이용한 방법

-- tel에서 서비스 번호(010, 011 ...)만 추출하기
select name, tel from emp;
select name, tel, substr(tel,1,INSTR(tel,'-')-1) as "서비스번호" from emp order by tel nulls last;

--자체복습 tel로 오름정렬하고 rownum이 6~10인 결괏값만 출력하기
select * from (
    select rownum rs, tb.* from (
        select name, tel
        from emp
        order by tel
    ) tb where rownum <=10
) where rs>=6;

--tel에서 서비스번호, 국번, 번호로 분리하기
--(물론 서비스번호, 국번, 번호를 분리하는 것은 자바에서 하는 것이 더 효율적이다.)
--현실에서는 오라클에서 최대한 연산을 시키지 않는 것이 좋다.
--사실 이런 연산은 JAVA에서 split을 사용하면 편리한데 oracle에서는 split과 유사한 방법이 없다.
--INSTR의 사용법만 익혀 두자.
select name, tel, 
substr(tel,1,instr(tel,'-')-1) as "서비스번호", 
substr(tel,instr(tel,'-')+1,instr(tel,'-',instr(tel,'-'))) as "국번(ME)-나중에 맞는지 분석해 보자", 
substr(tel,instr(tel,'-')+1,instr(tel,'-',1,2)-instr(tel,'-')-1) as "국번(답)", 
substr(tel,instr(tel,'-',1,2)+1) as "전화번호"
from emp;
--게시판 검색할 때 INSTR함수를 이용하여 검색을 한다.

--LENGTH (문자열의 길이)
select LENGTH('korea'), LENGTH('대한민국') from dual; --5,4: 한글도 길이는 글자당 1로 계산되네!
select LENGTHB('korea'), LENGTHB('대한민국') from dual; --5,12 (B: byte)
--byte수는 11g 이상에서 한글은 3byte로 계산한다. (UTF-8)

--REPLACE(char, search_string [, replacement_string]) 치환하기
select REPLACE('seoul korea','seoul','busan') from dual;
select REPLACE('seoul korea I seoul U', 'seoul','busan') from dual; -- 같은 글자 seoul을 일괄적으로 치환하는구나!
select REPLACE('555123456789012345678901234567890555','5') from dual; --5 제거하기

--전화번호에 하이픈 제거하기
select name, tel, REPLACE(tel,'-') as "하이픈제거" from emp;

--부서의 '부'자를 일괄적으로 '팀'으로 바꾼다
select name, dept, REPLACE(dept, '부','팀') as "문제 발생할 수 있음" from emp;
--부서의 끝 글자 마지막 부를 팀으로 변경하는 방법
--select name, dept, substr(dept,1,2)||'팀' as "이렇게 하는 것도 아니야" from emp; -- 부서명이 2글자가 아니면 어떡할 건데?
select name, dept, substr(dept,1,length(dept)-1)||'팀' as "조직개편" from emp; --함수를 이용하여 마지막 글자만 뗀다.

--CONCAT(char1, char2) 문자열 결합
--concatenate (con·cat·e·nate) 미국식 [k?nk?t?n?it]  영국식 [k?n-]  
--1. 사슬같이 잇다; 연쇄시키다; <사건 등을> 결부시키다, 연관시키다
--2. 연쇄된, 이어진, 연결된
select CONCAT('서울', '한국') from dual;
select '서울'||'한국' from dual;

--LPAD, RPAD 남는 공간 채우기
select LPAD('korea', 12, '*') from dual; --12 공간 중 7개의 공간이 남았으므로 *을 7개 왼쪽에 채운다
select RPAD('korea', 12, '*') from dual;-- 12 공간 중 7개의 공간이 남았으므로 *을 7개 오른쪽에 채운다.
select LPAD('korea', 3, '*') from dual;-- korea는 5자인데 공간은 3이면 korea 중 3글자 kor만 출력된다.
select RPAD('korea', 3, '*') from dual;-- korea는 5자인데 공간은 3이면 korea 중 3글자 kor만 출력된다.
select LPAD('*',0,'*') from dual; --null 0글자는 oracle에서 null로 취급한다.
select RPAD('*',0,'*') from dual; --null 0글자는 oracle에서 null로 취급한다.
--한글을 입력한 경우
select LPAD('대한',6,'*') from dual; -- **대한 LPAD에서는 한글을 2byte로 간주한다.
select RPAD('대한',6,'*') from dual; -- 대한** RPAD도 마찬가지로 한글은 2byte로 간주한다.

--
-- name, rrn(성별 다음부터는 *로 출력)
select name,  RPAD(substr(rrn,1,8),length(rrn),'*') as "가려진 주민등록번호" from emp; -- length(rrn)==14
select name, substr(rrn,1,8)||'******' from emp; --이렇게 해도 된다.

-- name, sal, 그래프(sal 100만원당 *하나)
select name, sal, LPAD('*',TRUNC(sal/1000000),'*') "그래프", TRUNC(sal/1000000)||'개' as "검산" from emp;

-- LTRIM, RTRIM, TRIM
--공백제거
select '*'||LTRIM('          우리나라         ')||'*' from dual; -- 좌측 공백 제거
select '*'||RTRIM('          우리나라         ')||'*' from dual; --우측 공백 제거
select '*'||TRIM('          우리나라         ')||'*' from dual; --좌우 공백 제거
select '*'||LTRIM('          -----우리나라-----         ', ' -')||'*' from dual; --끝에 있는 -와 ' '(공백) 모두 제거됨

-- A[AB]BCCAA에서 AB를 찾아 지움=> [AB]CCAA에서 AB를 찾아 지움 => CCAA
select LTRIM('AABBCCAAB','AB') from dual; --왼쪽에서 A나 B를 제거한다.
select LTRIM('AABBCCAAB','BA') from dual; --왼쪽에서 A나 B를 제거한다.

select name, RTRIM(dept, '부') from emp; -- 마지막 글자 중 '부'를 잘라낼 수 있음.
select name, dept, substr(dept,1,length(dept)-1)||'팀' as "조직개편" from emp;
select name, dept, RTRIM(dept,'부')||'팀' as "조직개편" from emp; --함수식이 보다 간소해졌다.
-- 제약사항: 부서명이 ~~~부일 때 ~~~~부부로 끝나면 '부'글자가 모두 지워진다. (주의)

--TRIM에서는 한 글자 소거만 가능하며 문법에 약간 차이가 있음.
select TRIM('A' from 'AABBCCAA') from dual;
--  BBCC: 소거할 문자는 한 글자만 가능하다 ('A')
--중간에 있는 공백을 제거하기 위해서는 REPLACE 함수를 이용하여 없애면 된다.

--TRANSLATE(expr, from_string, to_string) 문자열 교체 (치환)
select TRANSLATE('ABABCCC','C','D') from dual; --ABABDDD
--TRANSLATE:Returns the string provided as a first argument
-- after some characters specified in the second argument
-- are translated into a destination set of characters.
select REPLACE('ABABCCC','C','D') from dual; --ABABDDD
--REPLACE: Replaces all occurrences of a specified string value with another string value.

--2KWF45T에서 0123456789는 0123456789로, 나머지(A~Z)는 null로
select TRANSLATE(
'2KWF45T',
'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
'0123456789') from dual;--245
--각각 1개씩 대응하여 본다.

--2KWF45T
select TRANSLATE(
'2KWF45T',
'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') from dual;--9XXX99X
--의역: 숫자는 모두 9로 바꾸고 영문자는 모두 X로 바꾸라는 의미

-- REPLACE VS TRANSLATE
-- https://database.guide/sql-server-replace-vs-translate-what-are-the-differences/
SELECT 
    REPLACE('123', '321', '456') AS Replace, --123
    TRANSLATE('123', '321', '456') AS Translate from dual; --654

--WITH (반복적인 쿼리를 만들 때 사용하는 절)
--ESCAPE를 사용하지 않고 일반 문자 % 조회하는 방법 (LIKE를 사용하지 않음)
            WITH tb AS (
                SELECT '김김김' name, '우리_나라' content  FROM dual
                UNION ALL
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '안드로이드%모바일' content  FROM dual
            ) 
            SELECT * FROM  tb
--			WHERE content LIKE '%#%%' ESCAPE '#';
            WHERE INSTR(content,'%')>0;
            

-- 단일행 날짜 함수
-- EX: 은행 이율 계산 등
-- 반드시 숙지하여야 할 2가지 개념
-- ★★★★★ DATE (연월일시분초) but 밀리초는 저장할 수 없음
-- ★★★★★ TIMESTAMP 타임스탬프는 밀리초까지 저장이 가능하다.

--날짜 연산 매우 쉽다! IN ORACLE
-- 날짜 + 숫자: 숫자 만큼의 날 수를 날짜에 더한 날짜 반환
-- 날짜 - 숫자: 숫자 만큼의 날 수를 날짜에 뺀 날짜 반환
-- 날짜 + 숫자/24: 숫자 만큼의 시간을 날짜에 더한다.
-- 날짜1 - 날짜2: 날짜1에서 날짜2를 뺀 두 날짜 사이의 일 수를 반환한다.

--오늘 날짜 조회하기
select SYSDATE from dual; --SqlDeveloper, SQLPlus에서는 연월일만 나오지만 JAVA에서는 시분초까지 나온다.

--날짜를 문자로 바꾸기
select TO_CHAR(SYSDATE,'YYYY-MM-DD') from dual; --형식에 맞게 날짜를 변환
select TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') from dual; -- 시분초까지 나타내기

--문자를 날짜로 변환하기
select TO_DATE('2000-10-10', 'YYYY-MM-DD') from dual;

-- 2020년 2월 25일에 OO이가 여자친구를 만났다. 100일 후는 몇 월 며칠인가?
-- ※날짜를 연산할 때는 반드시 날짜형으로 변환(TO_DATE 이용)하여 연산을 수행한다.
select TO_DATE('2020-02-25','YYYY-MM-DD')+100 from dual; --20/06/04

-- 1989년 2월 25일이 생일인 OO이의 살아온 날 수를 구하면?
select TRUNC(SYSDATE-TO_DATE('1989-02-25','YYYY-MM-DD')) ||'일' "며칠을 살았나?" from dual;

--INTERVAL Literals를 이용하여 날짜 가감하기
select SYSDATE+(INTERVAL '1' YEAR) from dual;
select SYSDATE+(INTERVAL '1' MONTH) from dual;
select SYSDATE+(INTERVAL '1' DAY) from dual;
select SYSDATE+(INTERVAL '1' HOUR) from dual;

 