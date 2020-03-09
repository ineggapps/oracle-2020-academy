--DQL(또는 DML) 중 SELECT문
--특정 컬럼만 출력? (선언한 컬럼의 순서대로 결괏값이 출력됨)
--DB에 정의된 컬럼의 순서는 이때 중요하지 않다.
select * from emp; -- 모든 컬럼 항목에 관한 데이터를 조회 
select empNo, name, sal from emp; 
select name, empNo, sal from emp;
--이하의 쿼리문에서는 오류가 발생한다.
--ORA-00904: "NO" 부적합한 식별자 오류가 발생한다.
--존재하지 않는 컬럼을 조회할 경우에 발생한다.
select no, name, sal from emp;  -- ORA-00904 오류 발생

--수식을 사용할 때
select empNo, name, sal+100000 from emp;
--||는 문자열 결합을 의미한다.
select name||'님', '기본급여: ' || sal from emp;

select 10+5 from emp; --레코드 수만큼 출력된다
select 10+5 from dual; --단순한 계산은 dual 테이블을 이용하여 계산한다.
select '결과: ' || (10+5) from dual; --연산자 우선순위도 고려하여 작성해야 하는 것에 주의한다.

--모든 컬럼을 출력한다.(emp 테이블: 모든 컬럼 출력)
select * from emp;
-- 모든 컬럼명을 출력하는 경우에도 * 대신에 모든 컬럼명을 기술한다.
-- 실제 코딩할 때는 테이블명세서를 이용하여 컬럼명을 기술하여 프로그래밍을 한다
-- *을 이용하면 컬럼명이 어떤 것이 존재하는지 알 수 없는 경우가 있다.
-- 또한 *을 이용하면 테이블을 만들 때 명시한 컬럼명의 순서대로 결괏값을 가져오므로 의도한 순서대로 컬럼명을 나열하여 가져오는 것이 바람직하다.

--컬럼명을 변경하여 출력(emp테이블: empNo, name, sal 컬럼)
select empNo, name, sal from emp;
--프로그램에서는 변경된 이름으로만 접근이 가능하다.
select empNo as "사번", name as "이름", sal as "기본급" from emp;
--as는 생략이 가능하다.
select empNo 사번, name 이름, sal 기본급 from emp;
select empNo, name ,sal, bonus, sal+bonus from emp;
select empNo, name ,sal, bonus, sal+bonus pay from emp;
select empNo, name ,sal, bonus, sal+bonus 급 여 from emp; -- alias는 따옴표로 감싸지 않으면 오류가 발생한다. (공백이 있으니까)
--별칭을 사용할 때만큼은 홑따옴표가 아닌 쌍따옴표를 이용하여 지정한다.
select empNo, name ,sal, bonus, sal+bonus "급 여" from emp;
--컬럼명을 바꾸는 이유는 프로그램에서 접근을 편리하게 하기 위함임. (수식을 사용한 경우 alias로 접근)
--수식을 사용한 경우 프로그램에서 접근할 때 이름을 지정하지 않으면 접근하기가 번거롭기 때문이다.

--ROWNUM: 쿼리의 결과로 나오는 각각의 행들에 대한 순서 값
select ROWNUM, empNo, name from emp;
--astrik(*)을 사용할 때는 다른 컬럼명과 혼합하여 사용할 수 없다
select ROWNUM, * from emp; -- ORA-00936 누락된 표현식
--emp에 있는 모든 것(*)이라고 명시해주었으므로 사용할 수 있는 구문이다
select ROWNUM, emp.* from emp; -- 값이 보인다.
--emp라는 테이블의 alias를 t라고 주었으므로 t.*로 바꾸어야 정상적으로 작동한다.
select ROWNUM, t.* from emp t;

-- SELECT문 구문 기술 순서
-- SELECT 컬럼명(표현식)
-- FROM 테이블
-- WHERE 조건
-- GROUP BY 컬럼명(표현식)
-- HAVING 집계함수 조건식
-- ORDER BY 컬럼명(표현식)

--SELECT 구문 실행 순서
--FROM 테이블명 - 내 계정에 해당하는 테이블이 있니? 먼저 검사한다
--WHERE 조건식  
--GROUP BY 컬럼명(표현식)
--HAVING 집계함수조건식
--SELECT 컬럼명(표현식)
--ORDER BY 컬럼명(표현식)

--------
--emp테이블에서 city가 서울인 자료 중 name, city컬럼을 출력
SELECT name, city  FROM emp WHERE city='서울';
--emp테이블에서 city가 서울이 아닌 자료 중 name, city 컬럼 출력
select name, city from emp where city<>'서울'; --ISO표준 표기법
select name, city from emp where city!='서울';
--emp테이블 중에서 sal+bonus가 2500000원 이상인 자료 중 name, sal, bonus 컬럼 출력
select name, sal, bonus from emp where sal+bonus>=2500000;
select name, sal, bonus, sal+bonus from emp where sal+bonus>=2500000; --검산용

--그룹비교 연산자
--OR을 사용할 때 컬럼명을 반드시 기술해주어야 한다. 다음과 같이 사용하면 오류가 발생한다.
select empNo, name, city from emp where city = '서울' or '경기' or '인천'; --오류 발생
--OR을 사용할 때 컬럼명을 바르게 기재한 예
select empNo, name, city from emp where city = '서울' or city = '경기' or city = '인천';
--any를 사용한 예제
select empNo, name, city from emp where city=ANY('서울','경기','인천');
--in을 사용한 예제
select empNo, name, city from emp where city in ('서울', '경기', '인천');
--emp테이블에서 sal가 2000000원 이상인 자료 중 empNo, name, sal 컬럼을 출력
select empNo, name, sal from emp where sal>=2000000;
--ANY는 OR개념과 유사하다
select empNo, name, sal from emp where sal >= ANY(2000000, 2500000, 3000000);
--emp테이블에서 sal가 3000000원 이상인 자료 중 empNo, name, sal 컬럼을 출력
select empNo, name, sal from emp where sal>=3000000;
--ALL은 AND개념과 유사하다
select empNo, name, sal from emp where sal >= ALL(2000000, 2500000, 3000000);

--논리연산자
--emp테이블: city가 서울이고 sal가 2000000원 이상인 자료 중 empNo, name, city, sal 컬럼 출력
select empNo, name, city, sal from emp where city='서울' and sal>=2000000;

--emp테이블에서 city가 서울, 경기, 인천인 자료 중 empNo, name, city, sal 컬럼을 출력
select empNo, name, city, sal from emp where city in ('서울','경기','인천');
select empNo, name, city, sal from emp where city=ANY('서울','경기','인천');
select empNo, name, city, sal from emp where city = '서울' or city = '경기' or city = '인천';

--emp테이블에서 sal에서 2000000~3000000을 제외한 자료 중 empNo, name, sal컬럼을 출력
--not의 연산은 경우에 따라 피해야 하는 경우가 있으므로 여러 가지 경우의 수를 고려하여 where조건문을 작성한다.
select empNo, name, city, sal from emp where not (sal>=2000000 and sal<=3000000);
select empNo, name, city, sal from emp where sal<2000000 or sal>3000000;

--BETWEEN조건식
--emp테이블: sal가 2000000~3000000사이인 자료 중 name, sal 출력
select name, sal from emp where sal >= 2000000 AND sal <= 3000000; --로도 표현할 수 있지만
select name, sal from emp where sal between 2000000 and 3000000; --BETWEEN으로 좀 더 편리하게 구문을 표현할 수 있음.
--BETWEEN은 함수이므로 데이터가 늘어나면 부하가 걸리므로 관계연산자와 논리연산자를 사용하는 것이 더 효율적이다.
--emp테이블 sal가 2000000~30000000을 제외한 자료 중  name, sal을 출력
select name, sal from emp where sal <2000000 or sal>3000000;
select name, sal from emp where sal not between 2000000 and 3000000;

--emp테이블에서 hireDate가 2000년도인 자료 중 name, sal 컬럼 출력
select name, hireDate from emp where hiredate between '2000-01-01' and '2000-12-31';
--(심화) 함수를 이용하여 연도만 추출할 수도 있다.
select name, hireDate from emp where EXTRACT(YEAR from hireDate) = 2000;

--★★★★★IN조건식
--emp테이블: city가 서울, 인천, 경기인 자료 중 name, city출력
select name, city from emp where city='서울' or city='인천' or city='경기'; --로도 사용할 수 있지만
select name, city from emp where city in ('서울','인천','경기'); --in을 사용하면 간편하게 조건식을 지정할 수 있다.
--emp테이블: city가 서울, 인천, 경기를 제외한 name, city 출력
select name, city from emp where city not in ('서울','인천','경기'); --in 앞에 not을 붙일 수 있음.
--emp테이블에: city와 pos가 서울이면서 부장이거나, 서울이면서 과장인 자료 중 name, city. pos 컬럼
select name, city, pos from emp where (city='서울' and pos='부장') or (city='서울' and pos='과장'); -- 로도 조건을 지정할 수 있지만
select name city, pos from emp where city='서울' and (pos='부장' or pos='과장'); --로도 지정이 가능하다
select name, city, pos from emp where city in ('서울') and pos in('부장', '과장'); --으로 간편하게 조건식을 지정할 수 있다.
select name, city, pos from emp where (city, pos) in (('서울','부장'), ('서울','과장')); --결괏값은 이것도 유사하다
--emp테이블에서 city와 pos가 서울이면서 부장인 자료 중 name, city, pos컬럼 출력 (subquery)
select name, city, pos from emp where city='서울' and pos='부장'; --일단, 이 방법으로 학습할 것
select name, city, pos from emp where (city, pos) in (select '서울', '부장' from dual); -- (심화) 아, 이런 것도 있구나!
select '서울', '부장' from dual;--(심화)

--LIKE 조건식
-- name이 '김'씨인 자료 중 empNo, name 컬럼 출력하기
select empNo, name from emp where name like '김%';
select name, tel from emp where tel like '%3%'; --%3% (%: 0개 문자 이상이니까 앞뒤 가리지 않고 3이라는 문자만 있으면... 이라는 뜻)
select name, tel from emp where tel like '%3%' or tel like '%5%'; --%3% or %5% (3이나 5라는 문자열이 포함되어 있기만 하면 됨)
select name, rrn from emp where rrn like '_0%'; -- 80,90,00,... 생년에서 일의자리가 0만 출력가능하도록

--성씨가 'ㄱ'인 모든 이름 출력(나씨는 출력 안 됨) 
select name, tel from emp where name between '가' and '나'; 
--select name, tel from emp where name between '가%' and '나%'; -- %는 like에서만 유효하므로 결괏값에 영향을 미치지 않는다.
select name, tel from emp where name >= '가' and name < '나';
select name, tel from emp where name > '가' and name < '나'; -- 이름이 없고 성만 '가'씨인 경우는 없으니까 '>'로만 지정해주어도 된다.


--WITH 반복적인 쿼리를 단순화(블록화)시킬 때 사용하는 구문.
WITH tb AS (
                SELECT '김김김' name, '우리_나라' content  FROM dual
                UNION ALL -- 두 행을 하나로 합치도록 하는 합집합 연산 (밑에 또 select query문이 왔으니까 밑의 결괏값이랑 합쳐줘야 한다)
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '안드로이드%모바일' content  FROM dual
            ) 
SELECT * FROM  tb;

-- content컬럼에서 %문자가 들어 있는 항목만 추출하기
--패턴 문자를 인식시키는 방법은 다른 방법도 존재하지만, 일단 이 방법부터 숙지하자.
WITH tb AS (
                SELECT '김김김' name, '우리_나라' content  FROM dual
                UNION ALL -- 두 행을 하나로 합치도록 하는 합집합 연산 (밑에 또 select query문이 왔으니까 밑의 결괏값이랑 합쳐줘야 한다)
                SELECT '나나나' name, '자바%스프링' content  FROM dual
                UNION ALL
                SELECT '다다다' name, '우리나라' content  FROM dual
                UNION ALL
                SELECT '라라라' name, '안드로이드%모바일' content  FROM dual
            ) 
SELECT * FROM  tb where content like '%#%%' ESCAPE '#'; -- 중간에 '%' 일반문자가 끼어있는지 검사
--select * from tb where content like '%a%%' escape 'a';
--ESCAPE문자는 패턴 문자(%, _)가 포함된 데이터를 추출하기 위해서 활용하는 것이다.
--ESCPAPE로 지정된 문자 뒤에 오는 패턴 문자를 일반 문자로 인식한다.
--ESCAPE문자는 # 이외에 영문도 가능하다. ESCAPE 뒤에 명시된 문자열 다음 문자열은 일반문자열로 인식하도록 하기 위함이다.
--%#%%에서 # 바로 뒤의 %은 일반 문자로 인식한다.

--NULL값인 튜플 조회하기
select null from dual; --더미테이블에서 조회하기
select '' from dual; --문자열의 길이가 0인 데이터 조회하기
select 10+null from dual; -- ★★★★★ null에는 어떠한 연산을 수행하여도 결괏값은 null이 나온다.
--JAVA에서는 문자열의 길이가 0인 문자가 존재하지만, oracle에서는 문자열의 길이가 0이면 null로 간주한다.
--따라서 반드시 데이터의 입력이 필요한 컬럼은 not null 설정으로 null값을 막아야 한다.
--emp테이블에서 tel이 null인 자료 중 name, tel 컬럼 출력
-- select name, tel from emp where tel = null; --잘못된 구문, 오류는 발생하지 않지만 결괏값이 나타나지 않는다.
select name, tel from emp where tel is null; -- null을 테스트할 수 있는 유일한 방법
--emp테이블에서 tel이 null이 아닌 자료 중 name, tel 컬럼 출력
select name, tel from emp where tel is not null;

--■■■■■ CASE 표현식(Expressions)와 DECODE 함수
--이 개념을 배우기 전에 함수 몇 개 선행학습이 필요하다.
select substr('seoul korea',7,3) from dual; --결괏값: kor, (오라클에서는 substr의 index는 1부터 시작한다) // JAVA와 다름에 유의
--substr('seoul korea',7,3) -- k부터 3개의 글자를 추출하기 (JAVA와는 사용에 차이가 있음)
select substr('seoul korea',7) from dual; --결괏값 korea (7번째 문자열부터 출력하기)
select '70'+'50' from dual; -- 문자열을 결합하는 JAVA와는 달리 숫자로 자동으로 변환하여 계산한 결괏값이 출력된다.
select 13/5 from dual; -- 13에서 5를 나눈 결괏값은 2.6 
select mod(13,5) from dual; -- 나머지연산이 없으므로 나머지를 구하는 함수를 호출한다.

--주민등록번호로 판별하여 90년생 이후에 출생한 자만 보이도록 출력
select name, rrn from emp where substr(rrn,1,2) >= 90; --오라클에서는 문자열은 숫자로 자동으로 변환해 준다. 단, 2000년도 이후 출생자는 보이지 않음.
--1991~1995년생 출생자만 조회
select name, rrn from emp where substr(rrn,1,2)>=90 and substr(rrn,1,2)<=95; 
-- 주민등록번호로 판별하여 남자만 조회하도록
select name, rrn from emp where substr(rrn,8,1) = 1 or substr(rrn,8,1) = 3;
select name, rrn from emp where substr(rrn,8,1) in (1,3,5,7,9);
-- 주민등록번호로 판별하여 여자만 조회하도록
select name, rrn from emp where substr(rrn,8,1) = 2 or substr(rrn,8,1)=4;
select name, rrn from emp where mod(substr(rrn,8,1),2)=0; --mod를 이럴 때도 활용할 수 있구나!

-- TIP: 주민등록번호 뒷자리 첫 글자 (M,W)
-- 1,2 (1900s)
-- 3,4 (2000s)
-- 5,6 (1900s 외국인)
-- 7,8 (2000s 외국인)
-- 9,0 (1800s)

--CASE표현식은 255개까지의 구문을 사용할 수 있다.
--형식1: 간단한 CASE 표현식
select name, rrn,
CASE substr(rrn,8,1)
when '1' then '남자' -- when 다음에 홑따옴표로 감싸지 않으면 오류가 발생한다. (일관성없는 데이터 유형 CHAR가 필요하다고 나옴)
-- CASE 다음에 오는 자료형과 WHEN 다음에 오는 자료형은 일치해야 한다.
when '2' then '여자'
end as "성별" -- LABEL은 쌍따옴표를 붙인다.
-- 주민번호가 1도 2도 아닌 경우에 결괏값은 null로 반환된다.
from emp;
--개선한 버전
select name, rrn,
CASE mod(substr(rrn,8,1),2) --mod의 결괏값은 NUMBER가 반환된다.
when 1 then '남자' -- 이번에는 홑따옴표를 감싸지 않았다. 왜냐하면 mod함수로 계산하여 반환되는 결괏값 유형은 NUMBER이기 때문이다.
-- CASE 다음에 오는 자료형과 WHEN 다음에 오는 자료형은 일치해야 한다.
when 0 then '여자'
end as gender -- LABEL은 쌍따옴표를 붙인다.
from emp;
-- 주민번호가 어떤 숫자가 오든 남자, 여자 둘 중 하나의 결괏값을 반환하게 되어 있다.

--형식2:  Simple Case Expression
select name, rrn,
CASE 
    when mod(substr(rrn,8,1),2)=1 then '남자'
    when mod(substr(rrn,8,1),2)=0 then '여자'
END AS gender
from emp;

--형식1은 JAVA의 switch문처럼 유사하게 사용되는 문법이고
--형식2는 when절 다음에 바로 if문처럼 수식을 비교하는 조건이 온다. (else if문과 유사)
--보통은 형식2를 많이 사용하므로 형식2의 모양을 기억해 두도록 한다.
-- 형식2의 예) 세금을 계산할 때 금액대 별로 세율 적용을 달리할 때 사용한다.

select name, sal+bonus pay,
CASE
    --크다로 비교했으므로 큰 수치부터 내려와야 한다.
    --작다로 비교하였다면 당연히 작은 수치부터 올라가야 올바른 조건문 수식이 된다.
    when sal+bonus>=2500000 THEN (sal+bonus)*0.03
    when sal+bonus>=2000000 THEN (sal+bonus)*0.02
    else 0 --when절의 조건에서 걸리지 않는 모든 경우의 수는 else로 기술한다.
END AS tax
--조건절에 걸려들지 않으면 null값이 반환된다는 것에 유념하여 쿼리문을 작성한다.
--단, else는 생략이 가능한 구문이다.
from emp;

---------------------------------------------------------------------
-- 준비물: only emp테이블
--Q1. 여자의 bonus에 10만원을 더하여 출력
--출력 컬럼: name, rrn, sal, bonus, bonus에 여자는 10만원을 더한 값, 남자는 그대로 출력

--CASE표현식 1번
select name, rrn, sal, bonus, 
CASE mod(substr(rrn,8,1),2)
    when 0 then bonus+100000
--    when 1 then bonus  --else 대신 사용하여도 되는 구문
    else bonus
END as "계산된 보너스"
from emp;
--CASE표현식 2번
select name, rrn, sal, bonus, 
CASE
    when mod(substr(rrn,8,1),2)=0 then bonus+100000
    else bonus
END as "계산된 보너스"
from emp;

--Q2. city가 서울이면서 '김'씨(name)만 출력
--출력 컬럼: name, city
select name, city 
from emp 
where city='서울' and name like '김%';
--또는
select name, city 
from emp 
where city='서울' and substr(name,1,1)='김';

--Q3. city가 경기이면서 sal이 200만원 이하인 여자만 출력
--출력 컬럼: name, city
select name, city, sal
from emp
where city='경기' and mod(substr(rrn,8,1),2)=0 and sal<=2000000;

--Q4. 생년월일이 80년대(80~89)인 사람만 출력
--출력 컬럼: name, rrn 
select name, rrn 
from emp
where substr(rrn,1,2) >= 80 and substr(rrn,1,2)<=89; --로도 작성할 수 있다.
--또는
select name, rrn
from emp
where substr(rrn,1,1) = '8';
--또는
select name, rrn
from emp
where rrn like '8%';

--Q4-1. 10월생만 출력
select name, rrn
from emp
where rrn like '__10%';
--또는
select name, rrn
from emp
where substr(rrn,3,2)=10;

--Q5. 남자이면서 짝수월에 태어난 사람만 출력
--출력 컬럼: name, rrn
select name, rrn
from emp
where mod(substr(rrn,8,1),2)=1 and mod(substr(rrn,3,2),2)=0;

--Q6. SAL이 300만 원 이상이면 상여금을 10만원,
--SAL이 250만 원 이상이면 상여금을 5만원,
--SAL이 200만 원 이상이면 상여금을 3만원,
--나머지는 상여금을 지급하지 않는다.
--출력 컬럼: name, sal, 상여금

select name, sal, 
CASE
    when SAL>=3000000 then 100000
    when SAL>=2500000 then 50000
    when SAL>=2000000 then 30000
    else 0
END AS "상여금"
from emp;

--DECODE함수
--DECODE가 할 수 있는 모든 일은 CASE가 할 수 있다.
--작성하기에는 편리하지만 case보다는 성능이 좋지 않다는 것을 유념한다.
--약간 느낌이 삼항연산자와 비슷하네.. 혹은 엑셀의 if함수 느낌

select name, rrn, DECODE(substr(rrn,8,1),1,'남자') --조건에 만족하면 '남성' 만족하지 않으면 null값을 반환한다.
from emp;

select name, rrn, DECODE(substr(rrn,8,1),1,'남자',2,'여자') -- 1이면 남자, 2이면 여자만 되고 나머지 0, 3~9값은 null
from emp; --그러나 현 데이터는 주민등록번호 뒷자리 1번째 숫자가 1,2밖에 없으므로 null값이 나오지 않는다.

select name, rrn, DECODE(substr(rrn,8,1),1,'남자',2,'여자',3,'남자',4,'여자') -- 1,3이면 남자, 2,4이면 여자만 되고 나머지 0, 3~9값은 null
from emp; -- DECODE에서는 부등호로 연산식을 작성할 수 없으므로 작성하기가 불편하다.

select name, rrn, DECODE(substr(rrn,8,1),1,'남자',2,'여자','기타') -- 뒷자리 1번째가 1이면 남자, 2이면 여자, 나머지는 기타로 출력된다
from emp; --물론 정석 코드가 아님.

select name, rrn, DECODE(mod(substr(rrn,8,1),2),1,'남자',0,'여자') -- 나머지가 1이면 남자, 0이면 여자를 반환한다.
from emp; --정석대로 하려면 뒷자리 1번째 숫자에 관한 모든 경우의 수를 고려하여 작성하여야 한다.

