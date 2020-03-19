--■ 고급 쿼리
-- ※ 계층형 질의(Hierarchical Query)
--   ο 계층적 쿼리
     -------------------------------------------------------
    SELECT * FROM soft;

    --CONNECT BY: 계층적 질의에서만 사용이 가능하다.
        --CONNECT BY PRIOR: 각 행이 어떻게 연결될지 오라클에게 알려주는 역할
        --PRIOR는 이전 행과 다른 행을 연결하는 연산자
        --LEVEL: 검색된 결과에 대하여 계층별로 레벨 번호 출력
            --루트 1, 하위로 갈수록 1씩 증가된다.
        --상위에서 하위로 출력하기
        --■■■■■■■■■■암기■■■■■■■■■■■
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
        --START WITH num=1: 출력 시작 위치(행)
        --PRIOR num = parent: 계층적 관계 지정 (현재 행과 이전 행을 이어준다고 생각)
            --나(num)을 부모(parent)로 사용하는 행(부하 직원 검색)
            --parent 컬럼: 상위 정보를 가진 컬럼
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
        
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY parent = PRIOR num; --PRIOR키워드를 뒤쪽에 쓸 수도 있음.
        --parent컬럼이 따르는 것(참조하는 것)은 num이다. num이 parent보다 앞선다(PRIOR). 
        
        --최상위 하나만 출력
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY PRIOR parent = num;
        
        --하위에서 상위로 출력 (전자결재에서 기안자가 공문서를 검토해 주는 직속상관을 찾아야 하는 경우)
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=15
        CONNECT BY PRIOR parent = num;
        
        --PRIOR를 뒤에 선언
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=15
        CONNECT BY num =PRIOR parent;
        
        -- 잘못된 정렬 (계층 구조가 깨졌다, 같은 레벨끼리 정렬이 필요하다)
        SELECT num, subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
--        ORDER BY subject;--계층 구조가 파괴되므로 CONNECT절과 함께 ORDER를 사용할 수 없음

        --정렬 (같은 레벨끼리 정렬)
        SELECT num, subject, LEVEL, parent
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1
        CONNECT BY PRIOR num = parent
--        ORDER BY subject;--계층 구조가 파괴되므로 CONNECT절과 함께 ORDER를 사용할 수 없음
        ORDER SIBLINGS BY subject; --같은 parent의 노드끼리 정렬이 되어 있는 것을 확인할 수 있다.
        
        --데이터베이스 소속 자식 출력
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=3
        CONNECT BY PRIOR num = parent;
        
        -- WHERE절은 마지막에 평가되며 num이 3인 것만 출력되지 않는다.
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        WHERE num !=3 
        START WITH num=1 --START WITH와 CONNECT절이 WHERE절보다 먼저 실행된다.
        CONNECT BY PRIOR num = parent;

        -- DB와 DB 하위도 출력하지 않음
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1 --START WITH와 CONNECT절이 WHERE절보다 먼저 실행된다.
        CONNECT BY PRIOR num = parent AND num != 3; --3번(데이터베이스) 항목에 소속된 요소들 모두 제외

        -- 1개의 행이 나온다. (dual테이블의 행이 1개이기 때문이다.)
        SELECT rownum FROM dual WHERE rownum <=20; 
        
        --20개의 행이 나온다. CONNECT BY에서만 LEVEL 사용이 가능하다.
        --CONNECT BY는 parent 요소를 계속 찾아 들어간다.
        SELECT LEVEL v FROM dual 
        CONNECT BY LEVEL<=20;

        SELECT TO_DATE('2020-03-19')+LEVEL-1 FROM dual 
        CONNECT BY LEVEL<=7;

        --
        SELECT num, subject, LEVEL, parent, CONNECT_BY_ROOT subject FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        --CONNECT_BY_ROOT: 최상위 노드의 값 반환
        START WITH num=1 --START WITH와 CONNECT절이 WHERE절보다 먼저 실행된다.
        CONNECT BY PRIOR num = parent;
        
        --데이터베이스부터 시작하므로 connect_by_root는 데이터베이스를 반환
        SELECT num, subject, LEVEL, parent, CONNECT_BY_ROOT subject FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        --CONNECT_BY_ROOT: 최상위 노드의 값 반환
        START WITH num=3 --START WITH와 CONNECT절이 WHERE절보다 먼저 실행된다.
        CONNECT BY PRIOR num = parent;

        --루트에서 자신까지 연결하여 보여준다
        SELECT num, subject, LEVEL, parent, 
        SYS_CONNECT_BY_PATH(subject,' > '), subject --소프트웨어 > 프로그래밍 > 자바 따위로 전개 
        FROM soft -- LEVEL은 CONNECT BY절과 반드시 함께 쓰인다.
        START WITH num=1 --START WITH와 CONNECT절이 WHERE절보다 먼저 실행된다.
        CONNECT BY PRIOR num = parent;
    
        --
        SELECT ROWNUM rnum, name FROM emp WHERE city='서울';
        
        SELECT SYS_CONNECT_BY_PATH(name,',') name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='서울'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;
        
        SELECT MAX(SYS_CONNECT_BY_PATH(name,',')) name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='서울'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;
        
        --서울 사람들을 다 합쳤을 때
        --EX) 복수 개의 행을 하나로 합쳐서 결괏값을 추출하고 싶을 때 사용한다.
        --굳이 JAVA단에서 처리하고 싶지 않을 때 쿼리문으로도 얼마든지 행을 합칠 수 있다.
        SELECT SUBSTR(MAX(SYS_CONNECT_BY_PATH(name,',')),2) name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='서울'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;

-- ※ PIVOT과 UNPIVOT
--   ο PIVOT 절 (행=>열의 형태로 바꾸어 보여주는 것)
     -------------------------------------------------------
     -- 예제
      WITH temp_table AS (
         SELECT 1 cnt, 1000 price FROM DUAL UNION ALL
         SELECT 2 cnt, 1050 price FROM DUAL UNION ALL
         SELECT 3 cnt, 2100 price FROM DUAL UNION ALL
         SELECT 1 cnt, 5500 price FROM DUAL UNION ALL
         SELECT 2 cnt, 7000 price FROM DUAL UNION ALL
         SELECT 3 cnt, 7000 price FROM DUAL
     )
     SELECT cnt, SUM(price) price
     FROM temp_table
     GROUP BY cnt;
     
     --PIVOT
    --pivot 미국·영국 [?p?v?t]  영국식  중요
    --1. (회전하는 물체의 균형을 잡아 주는) 중심점
    --2. (가장 중요한) 중심
    --3. (축을 중심으로) 회전하다; 회전시키다
     WITH temp_table AS (
         SELECT 1 cnt, 1000 price FROM DUAL UNION ALL
         SELECT 2 cnt, 1050 price FROM DUAL UNION ALL
         SELECT 3 cnt, 2100 price FROM DUAL UNION ALL
         SELECT 1 cnt, 5500 price FROM DUAL UNION ALL
         SELECT 2 cnt, 7000 price FROM DUAL UNION ALL
         SELECT 3 cnt, 7000 price FROM DUAL
     )
     SELECT * FROM (
        SELECT cnt, price from temp_table
     ) PIVOT (
        SUM(price) FOR cnt IN(1,2,3)
     );
     
    SELECT dept, city, COUNT(*) 
    FROM emp
    GROUP BY dept, city
    ORDER BY dept;
    
    SELECT * FROM (
        SELECT dept, city
        FROM emp
--        ORDER BY dept
    ) PIVOT (
        COUNT(*) FOR dept IN (
            '개발부' AS "개발부",
            '기획부' AS "기획부",
            '영업부' AS "영업부",
            '인사부' AS "인사부",
            '자재부' AS "자재부",
            '총무부' AS "총무부",
            '홍보부' AS "홍보부"
        )
    );
    
    SELECT * FROM (
        SELECT dept, city, pos
        FROM emp
        ORDER BY city, pos
    ) PIVOT (
        COUNT(*) FOR dept IN (
            '개발부' AS "개발부",
            '기획부' AS "기획부",
            '영업부' AS "영업부",
            '인사부' AS "인사부",
            '자재부' AS "자재부",
            '총무부' AS "총무부",
            '홍보부' AS "홍보부"
        )
    );    
    
    --월별 입사 인원수 구하기
    SELECT TO_CHAR(hiredate,'MM') 월별, COUNT(*) 인원수
    FROM emp
    GROUP BY TO_CHAR(hiredate,'MM')
    ORDER BY 월별;
    
    SELECT * FROM (
        SELECT TO_CHAR(hiredate,'MM') 월별
        FROM emp
    ) PIVOT (
        COUNT(월별) 
        FOR 월별 IN (
            '01' AS "1월",
            '02' AS "2월",
            '03' AS "3월",
            '04' AS "4월",
            '05' AS "5월",
            '06' AS "6월",
            '07' AS "7월",
            '08' AS "8월",
            '09' AS "9월",
            '10' AS "10월",
            '11' AS "11월",
            '12' AS "12월"
        )
    );
    
    --부서별 직위의 급여(sal) 합 구하기
    --POS, 개발부, 홍보부 ...
    --직원   X       X
    
    SELECT dept, pos, sum(sal) 
    FROM emp
    GROUP BY dept, pos;
    
    SELECT * FROM (
        SELECT dept, pos, sal
        FROM emp
    ) PIVOT(
        sum(sal) FOR dept IN (
            '개발부' AS "개발부",
            '기획부' AS "기획부",
            '영업부' AS "영업부",
            '인사부' AS "인사부",
            '자재부' AS "자재부",
            '총무부' AS "총무부",
            '홍보부' AS "홍보부"
        )
    );
    
    --연도별 월별 판매현황(bPrice *qty 합)
    --연도 1월.. ~ 12월
    
    SELECT TO_CHAR(sdate, 'YYYY') 연도, TO_CHAR(sdate, 'MM') 월, sum(bPrice * qty) 판매금액
    FROM book b
    JOIN dsale d ON b.bcode = d.bcode
    JOIN sale s ON d.snum = s.snum
    GROUP BY TO_CHAR(sdate, 'YYYY'), TO_CHAR(sdate, 'MM');
    
    SELECT * FROM (
        SELECT TO_CHAR(sdate, 'YYYY') 연도, TO_CHAR(sdate, 'MM') 월, --bprice, qty, 
        bprice*qty amt
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
    ) PIVOT(
--        sum(bprice * qty) FOR 월 IN(
        sum(amt) FOR 월 IN(
        '01' AS "1월",
        '02' AS "2월",
        '03' AS "3월",
        '04' AS "4월",
        '05' AS "5월",
        '06' AS "6월",
        '07' AS "7월",
        '08' AS "8월",
        '09' AS "9월",
        '10' AS "10월",
        '11' AS "11월",
        '12' AS "12월"
        )
    ) ORDER BY 연도 DESC;

    --NULL값 제거
    SELECT 연도,    
     NVL("1월",0) "1월",
     NVL("2월",0) "2월",
     NVL("3월",0) "3월",
     NVL("4월",0) "4월",
     NVL("5월",0) "5월",
     NVL("6월",0) "6월",
     NVL("7월",0) "7월",
     NVL("8월",0) "8월",
     NVL("9월",0) "9월",
     NVL("10월",0) "10월",
     NVL("11월",0) "11월",
     NVL("12월",0) "12월"
    FROM (
        SELECT TO_CHAR(sdate, 'YYYY') 연도, TO_CHAR(sdate, 'MM') 월, --bprice, qty, 
        bprice*qty amt
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
    ) PIVOT(
--        sum(bprice * qty) FOR 월 IN(
        sum(amt) FOR 월 IN(
        '01' AS "1월",
        '02' AS "2월",
        '03' AS "3월",
        '04' AS "4월",
        '05' AS "5월",
        '06' AS "6월",
        '07' AS "7월",
        '08' AS "8월",
        '09' AS "9월",
        '10' AS "10월",
        '11' AS "11월",
        '12' AS "12월"
        )
    ) ORDER BY 연도 DESC;
    
     --참고
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
    --------------
        sale: sNum, sDate, cNum -- cNum 고객번호: 누가 사 갔는지 추적
        dsale: dNum, sNum, bCode, qty --sNum을 이용하여 sale과 dSale의 관계를 맺을 수 있다.
    --------------
        cus: cNum, cName, cTel
        member:cnum, userid, userPwd, userEmail
    
    --입사일을 가지고 요일별 입사인원수 몇 명인지?    
    SELECT TO_CHAR(hiredate,'d') 요일, count(*) from emp
    group by TO_CHAR(hiredate,'d')
    order by 요일;
    
    SELECT * FROM (
        SELECT TO_CHAR(hiredate,'d') 요일 from emp    
    ) PIVOT (
        COUNT(*) FOR 요일 IN(
            1 "일요일",
            2 "월요일",
            3 "화요일",
            4 "수요일",
            5 "목요일",
            6 "금요일",
            7 "토요일"
        )
    );    
    
--   ο UNPIVOT 절 (피벗의 반대 개념으로 행과 열을 바꾸는 것)
--  자주 사용하지는 않으므로 참고만 할 것
     -------------------------------------------------------
     CREATE TABLE t_city AS
     SELECT * FROM (
        SELECT city, dept FROM emp
     ) PIVOT (
        COUNT(dept)
        FOR dept IN (
            '개발부' AS "개발부",
            '기획부' AS "기획부",
            '영업부' AS "영업부",
            '인사부' AS "인사부",
            '자재부' AS "자재부",
            '총무부' AS "총무부",
            '홍보부' AS "홍보부"
        )
     );
    SELECT * FROM T_CITY;
    DESC T_CITY;
    
    SELECT * FROM t_city
    UNPIVOT(
        인원수
        FOR buseo IN (개발부, 기획부, 영업부, 인사부, 자재부, 총무부, 홍보부)
    );
    DROP TABLE t_city PURGE;
    