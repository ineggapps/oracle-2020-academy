select * from emp;
--부서명 검색 (중복 포함)
select dept from emp;
select all dept from emp; --앞에 all이라는 키워드를 생략하여도 동일하게 작동한다.
-- where절에 사용한 ALL과는 다른 의미이다. (where절의 ALL은 AND개념)

--부서명 검색 (중복 제거) DISTINCT, UNIQUE
select distinct dept from emp; -- 중복된 값이 있으면 1번만 출력한다.
select unique dept from emp; -- 키워드가 2종류이지만 결괏값은 같다.
select distinct empNo, name from emp; --이럴 때는 의미가 없지. empNo가 어차피 다 다를 테니까
select distinct city from emp;

-- 복습

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

-- ORDER BY절 (정렬)
-- 별도로 정렬을 지정하지 않으면 기본적으로 기본키의 오름차순으로 적용된다.
-- SQL문장의 제일 마지막에 기입한다. 
-- ASC:기본, 오름차순 / DESC: 내림차순
-- 정렬 예시
select name, city, sal+bonus pay from emp where pay>=300000; --오류 (pay는 emp테이블의 컬럼이 아니다)
-- 이유 (실행과정)
--1. from절을 먼저 실행한다. 
--2. where절을 그 다음 실행한다. (pay라는 컬럼을 찾으려고 시도할 것임 but 존재하지 않음) => 오류 발생
--3. select절을 실행하고
--4. order by절을 실행한다. 따라서 별명으로 지정한 pay을 활용할 수 있다.
select name, city, sal+bonus pay from emp order by sal+bonus;
select name, city, sal+bonus pay from emp order by pay desc; --별명으로도 정렬이 가능하다

--정렬 기준을 복수 개로 지정하고 항목당 오름차순/내림차순을 개별로 지정할 수 있다. 
select name, city, sal, bonus, sal+bonus pay from emp order by pay desc, sal;
select name, city, sal, bonus, sal+bonus pay from emp order by pay desc, sal desc;

select name, city, dept, pos, sal, bonus from emp order by city;
select name, city, dept, pos, sal, bonus from emp order by city, dept;
select name, city, dept, pos, sal, bonus from emp order by city, sal desc;

--여자만 sal 내림차순 출력
select name, rrn, city, dept, pos, sal, bonus
from emp
where mod(substr(rrn,8,1),2)=0
order by sal desc;

--남자=>여자 순서대로 SAL 내림차순으로 출력
select name, rrn, city, dept, pos, sal, bonus
from emp
order by mod(substr(rrn,8,1),2) desc, sal desc;

--dept 오름차순 정렬하고 dept가 같으면 남자를 먼저 출력:
select name, rrn, city, dept, pos, sal, bonus
from emp
order by dept, mod(substr(rrn,8,1),2) desc;

--※ ORDER BY를 남발하면 DBMS에 과부하가 걸린다.
--따라서 실무에서는 데이터를 추출하여 JAVA에서 정렬하는 방식을 이용하기도 함.

--영업부만 최우선으로 목록으로 출력하는 방법. (나머지 부서는 정렬이 되지 않음)
--영업부가 아닌 부서들은 조건에 걸리지 않으므로 null이 출력된다.
select name, rrn, city, dept, pos, sal, bonus
from emp 
order by CASE when dept='영업부' then 0 end; --영업부가 아니면 null

select name, rrn, city, dept, pos, sal, bonus
from emp
order by decode(dept,'영업부',0); --영업부가 아니면 null

--영업부 이외의 부서들이 null이 되는지를 증명해 보자!
select dept, case when dept='영업부' then 0 end as CASE from emp;
select dept, decode(dept,'영업부',0) from emp;

--직급(POS) 종류 조회 (중복 제거)
select distinct pos from emp;
-- 부장, 과장, 대리, 사원 순으로 출력하는 방법 (DECODE 이용)
-- CASE로 이용하여도 좋으나 코드가 복잡해진다.
select name, pos 
from emp
--order by decode(pos,'부장',0,'과장',1,'대리',2,'사원',3);
order by decode(pos,'부장',0,'과장',1,'대리',2,3);

--전화번호가 null인 데이터를 먼저 출력
select name, tel
from emp
order by tel NULLS FIRST;

--전화번호가 null인 데이터를 나중에 출력
select name, tel
from emp
order by tel NULLS LAST;

-- 전체 조회
select * from emp;

--실행할 때마다 다른 순서로 출력하는 방법
select * from emp 
order by DBMS_RANDOM.VALUE;
select DBMS_RANDOM.VALUE from dual; --난수를 생성하는 것을 확인할 수 있다.

--실행할 때마다 데이터 5개를 무작위로 추출하는 방법
select * from (
    select * from emp
    order by DBMS_RANDOM.VALUE
) where rownum<=5; -- ROWNUM은 출력 순서이다. ORDER BY가 있는 절에 사용할 수 없음.
-- ROWNUM: 쿼리의 결과로 나오는 각각의 행들에 대한 순서 값을 나타내는 의사 컬럼.

--select empno, name, rrn from emp order by 1; --숫자로도 지정이 가능하나 권장하지 않는 방식
--쿼리문에서 select의 항목을 나열할 대 순서를 바뀌면 다시 order by절에서도 숫자를 다시 지정해줘야 하니까.

--집합 연산자 (교집합, 합집합, 차집합)
--UNION (합집합)
--UNION ALL 
--MINUS (차집합)
--INTERSECT (교집합)

--개발부인 항목과 도시가 인천인 항목 조회
--UNION: 첫 번째 SELECT문의 결과와 두 번째 SELECT문의 결과가 겹친다고 하더라도 
--같은 항목은 한 번만 출력하게 된다.
select name, city, dept from emp where dept='개발부'
UNION
select name, city, dept from emp where city='인천';

-- 컬럼이 달라도 각 순서별 타입이 동일하면 가능하다
-- 현재 두 개의 select문의 3번째 항목은 sal과 bonus는 다른 항목이지만 
-- 타입이 동일하므로 활용이 가능하다.
select name, city, dept,sal from emp where dept='개발부'
UNION
select name, city, dept,bonus from emp where city='인천';

--★★★★★UNION ALL: 첫 번째 SELECT문의 결과와 두 번째 SELECT문의 결과를 모두 출력
--(중복적인 데이터가 출력되면 두 번 출력하게 된다)
--많이 쓰는 항목이니까 기억할 수 있도록 한다.
select name, city, dept from emp where dept='개발부'
UNION ALL
select name, city, dept from emp where city='인천'
order by city;

--MINUS: 부서가 개발부인 결과에서 city가 인천인 항목을 모두 제거한다.
select name, city, dept from emp where dept='개발부'
MINUS
select name, city, dept from emp where city='인천';

--MINUS: city가 인천인 항목에서 부서가 개발부인 결과를 모두 제거한다.
select name, city, dept from emp where city='인천'
MINUS
select name, city, dept from emp where dept='개발부';

--INTERSECT: 부서가 개발부인 항목과 도시가 인천인 항목의 결과가 겹치는 경우만
--결론은 부서가 개발부이면서 도시가 인천인 항목을 조회
select name, city, dept from emp where dept='개발부'
INTERSECT
select name, city, dept from emp where city='인천';

--pseudo 컬럼
--pseudo 미국식 [s?:dou]  영국식 [sj?:-]  
--1. 허위의, 가짜의; 모조의
--2. 꾸며 보이는 사람, 사칭자
-- pseudo 컬럼의 항목은 활용할 수 있으나 삽입, 수정, 삭제는 불가능하다.
--ROWID: 각각 튜플에 관한 고유의 ID값
select empno, name from emp;
select rowid, empno, name from emp;
--ROWID에서 AAB가 포함된 단어가 있는지 조회하는 구문
select rowid, empno, name from emp where rowid like '%AAB%';

-- ★★★★★ ROWNUM
--쿼리에서 반환된 각 행에 대해 ROWNUM은 테이블 또는 조인된 행 집합에서 행을 선택하는 순서를 나타내는 숫자를 반환해 준다.
--응???
select rownum, empno, name, city, sal from emp;

select rownum, name, city, sal from emp
where rownum<=10;

--양의 정수보다 큰 ROWNUM 값에 대한 테스트는 항상 거짓이다.
select rownum, name, city, sal from emp
where rownum > 1; -- 하나도 안 나온다.
--분명 적다는 됐는데...
--구문 실행 순서를 따져봐야 한다.
--1. from
--2. where절 데이터를 가져올 때마다 rownum의 숫자를 붙인다.
--rownum이 1인 튜플이 등장했을 때 조건을 비교한다 1(rownum) >1 => 거짓을 반환한다.
--따라서 거짓을 반환하므로 결괏값이 반환되지 않는다.
select rownum, name, city, sal from emp
where rownum = 10; -- 하나도 안 나온다.
--rownum이 1인 튜플이 등장했을 때 조건을 비교하면 1 = 10 => 거짓을 반환한다.
select rownum, name, city, sal from emp
where rownum = 1; -- 하나도 안 나온다.
--rownum이 1인 튜플이 등장했을 떄 조건을 비교하면 1 = 1 => 참이므로 한 개의 항목을 반환한다.
--★따라서 rownum은 적다, 적거나 같다는 가능하지만 (크다, 같다) 사용 시 주의한다. (단, 1=1은 참)
--★oracle에서는 11g버전 이하에서는 rownum을 이용하지 않고서는 페이징이 불가능하다.

--23번 김인수 먼저 등장
select rownum, name, city, hireDate, sal
from emp
order by sal desc;

--김인수는 일반 쿼리로 조회했어도 23번째에 있다
select rownum, empno, name from emp;

--rownum은 순차적으로 1,2,3,4,5 ~ ... 붙일 목적인데 정렬을 해버리면 rownum이 순차적으로 나열되지 않는다.
--select 실행 순서로 따지자면 rownum매기는 것이 먼저고 순서 정렬이 나중이니까... 당연하겠지!
--그러므로 order by절이 있는 경우 의도한 결과가 아닐 수 있으므로 rownum을 사용하지 않는다
select rownum, name, city, hireDate, sal
from emp
where rownum<= 10
order by sal desc;

-- ■■■■■
-- order by 절이 있는 경우에는 반드시 subquery를 사용하여 rownum을 사용하면 의도한 순서(1,2,3...)대로 나온다
-- 괄호 안에 싸인 select문에 rownum을 사용하면 의도하지 않은 순서가 나타남을 알 수 있다.
-- order by 이전에 이미 select문이 먼저 실행되므로 rownum의 카운트가 매겨지잖아.
select ROWNUM as "의도한 rownum", tb.* from (
    select ROWNUM as "의도하지 않은 순서", name, city, hireDate, sal
    from emp
    order by sal desc
) tb where rownum<=10;
--tb는 subquery에 대한(테이블 결괏값) 별명을 의미한다.

--게시판 페이징과 유사한 처리
--서브쿼리의 결괏값이 6~10번인 것들만 출력하도록 하고자 한다.
select rownum, tb.* from (
select  name, city, hireDate, sal
    from emp
    order by sal desc
) tb where rownum >=6 and rownum <=10;
--rownum >=6 에서 거짓이 반환되므로 하나도 출력되지 않는다.

--rownum이 6~10번 (김종서, 지재환, 문길수, 이기자, 이상헌) 
select  name, city, hireDate, sal
    from emp
    order by sal desc;

select * from (
    select ROWNUM rnum, name, city, hireDate, sal
    from emp
    order by sal desc
) where rnum >=6 and rnum <=10;
--결과는 나왔으나 의도하지 않은 결괏값이 나왔다.
--ORDER BY와 ROWNUM은 같은 쿼리에 있으면 안 된다.

--sal 내림차순 정렬하여 6번째부터 10번째를 출력
--11g 버전에서 게시판 페이징 처리에 사용하는 쿼리문

--SELECT 실행순서 복습
--1. FROM
--2. WHERE
--)))))))))) GROUP BY, HAVING
--3. SELECT
--4. ORDER BY
--★★★★★★★★★★★★★★★★★★ 암기해야 할 쿼리문
select * from(
    select rownum rnum, tb.* from ( -- tb라는 별칭을 이용하지 않으려면 name, city, sal을 기재하면 된다.
        select name, city, sal
        from emp
        order by sal desc
    ) tb where rownum <=10 --일단 1~10개의 데이터까지는 추출한다.
    --실행 순서에 의해 여기서는 rownum의 별칭을 사용하면 안 된다. (복습)
) where rnum>=6; -- 범위를 지정하여 필요 없는 부분인 1~5번째는 잘라낸다.

-- ▶ ROWNUM사용 시 주의사항
-- 1.절대로 order by절이 있으면 rownum을 사용하면 의도하지 않은 숫자이므로 사용해서는 안 된다.
-- 2.where절에서  rownum보다 크다로 (rownum > 1) 비교하지 않는다.

--Oracle은 페이징처리를 공식적으로 지원하지 않아서(11g) 성능이 다소 떨어진다.