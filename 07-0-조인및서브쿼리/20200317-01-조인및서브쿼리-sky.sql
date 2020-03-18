select * from tab;

--실습에 필요한 테이블
--BCLASS: 분류 테이블(분류코드P, 분류명, 상위분류코드R)
--PUB: 출판사(출판사번호P, 출판사명, 전화번호)
--BOOK: 서적(서적코드P, 서적명, 가격, 분류코드R, 출판사번호R)
--AUTHOR: 저자(저자번호P, 서적코드R,저자명)
--CUS: 고객(고객번호P, 고객명, 전화번호)
--MEMBER:회원(고객번호P, 회원아이디U, 회원패스워드, 이메일) --고객이 반드시 회원은 아닐 수 있음.
--SALE: 판매 (판매번호P, 판매일자, 고객번호R)
--DSALE: 판매 상세(판매상세번호P, 판매번호R, 서적코드R, 판매수량) -- 말하자면 판매실적 정도?

■ 조인과 서브 쿼리
 ※ 조인(joins)
   ο INNER JOIN
       -- 실습 테이블
         -- 분류 테이블(분류코드, 분류명, 상위분류코드)
            SELECT bcCode, bcSubject, pcCode FROM bclass;

         -- 출판사 테이블(출판사번호, 출판사명, 전화번호)
            SELECT pNum, pName, pTel FROM pub;

         -- 책 테이블(서적코드, 서적명, 가격, 분류코드, 출판사번호)
            SELECT bCode, bName, bPrice, bcCode, pNum FROM book;

         -- 저자 테이블(저자번호, 서적코드, 저자명)
            SELECT aNum, bCode, aName FROM author;

         -- 고객 테이블(고객번호, 고객명, 전화번호)
            SELECT cNum, cName, cTel FROM cus;

         -- 회원 테이블(고객번호, 회원아이디, 회원패스워드, 이메일)
            SELECT cNum, userId, userPwd, userEmail FROM member;
    
         -- 판매 테이블(판매번호, 판매일자, 고객번호)
            SELECT sNum, sDate, cNum FROM sale;

         -- 판매 상세 테이블(판매상세번호, 판매번호, 서적코드, 판매수량)
            SELECT dNum, sNum, bCode, qty FROM dsale;

     1) EQUI JOIN
        -- 형식 1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명 = 테이블명2.컬럼명  [AND 조건]

        --
		SELECT * FROM emp;
		SELECT * FROM emp_score;
		
		SELECT empNo, name, com, excel, word
		FROM emp, emp_score
		WHERE emp.empNo = emp_score.empNo;
		  -- 에러 : 동일한 이름의 컬럼명이 두테이블에 존재하며, 모호성이 발생. ORA-00904
		  --SELECT에서 empNo가 어떤 테이블의 것을 참조하는지를 emp.empno처럼 명시해야 함.
          
		SELECT emp.empNo, name, com, excel, word
		FROM emp, emp_score
		WHERE emp.empNo = emp_score.empNo;
		  
		SELECT e.empNo, name, com, excel, word
		FROM emp e, emp_score s --테이블에 별칭을 지정
		WHERE e.empNo = s.empNo;

		SELECT e.empNo, name, com, excel, word
		FROM emp e 
		JOIN emp_score s ON e.empNo = s.empNo; --조인하는 테이블이 많을 경우 
		
        --예시1)
        -- 판매현황 : 책코드(bCode), 책이름(bName), 책가격(bPrice), 출판사번호(pNum),
                    출판사이름(pName), 판매일자(sDate), 판매고객번호(cNum),
                    판매고객이름(cName), 판매수량(qty), 금액(bPrice * qty)

        -------------------------------------------------------
        --참고
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
        --------------
        sale: sNum, sDate, cNum -- cNum 고객번호: 누가 사 갔는지 추적
        dsale: dNum, sNum, bCode, qty --sNum을 이용하여 sale과 dSale의 관계를 맺을 수 있다.
        --------------
        cus: cNum, cName, cTel
        ----쿼리
        --기본 5개 이상의 테이블을 조인한다. (실무에서 금융권은 30~40개의 테이블을 조인)
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty 금액
        FROM book b, pub p, sale s, dsale d, cus c
        WHERE     b.pNum=p.pNum 
                AND b.bCode=d.bCode
                AND d.sNum = s.sNum 
                AND s.cNum=c.cNum; --AND연산이 계속되면 복잡해진다.                      
                
        -- 형식 2
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
           FROM 테이블명1
           [ INNER ] JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명;

        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty 금액
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum;

        --판매 실적 중 올해 것만
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty 금액
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY');
        
        -- 형식 3: SELECT절에서 별명을 사용하지 않음
       SELECT 컬럼명, 컬럼명
       FROM 테이블명1
       JOIN 테이블명2 USING (컬럼명1)
       JOIN 테이블명3 USING (컬럼명2);
-------------------------------------------------

        --단, 컬럼명이 서로 같아야 한다. 그러므로 잘 사용하지 않음
        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty 금액
        FROM book b
        JOIN pub p USING(pNum) 
        JOIN dsale d USING(bCode)
        JOIN sale s USING (sNum)
        JOIN cus c USING (cNum);

-----------------------------------------------------
    --문제1) 판매된 책 코드(bCode), 책 이름(bName), 판매 권수의 합(qty 합)
    --정렬: 책 코드 오름차순 정렬
    -- 필요한 것들
    --book(bCode, bName)과 dsale(bCode, qty)
        SELECT b.bCode, bName , SUM(qty) 판매권수
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        ORDER BY bCode;
        
    --문제2) 판매된 책 코드(bCode), 책 이름(bName), 판매 금액의 합(qty 합)
    --정렬: 책 코드 오름차순 저렬
        SELECT b.bCode, bName , TO_CHAR(SUM(qty)* bPrice,'L999,999,999') 판매실적
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName, bPrice)
        ORDER BY bCode;
--        ORDER BY 판매실적 desc;        
        
    --검산
        select * from book where bCode='0014';--15000원
        select * from dsale where bCode='0014';--35권
    --총 525,000원
    
    --문제3) 판매된 책 이름과 책 코드만
    SELECT DISTINCT b.bCode, bName
    FROM book b
    JOIN dsale d ON b.bCode = d.bCode
    ORDER BY b.bCode;

    --문제4) 판매된 책 중 판매 권수의 합이 가장 큰 책 코드(bCode), 책 이름(bName), qty 판매권수의 합
    
        
        --#방법1. RANK() OVER() 함수를 이용하여 서브쿼리 사용하기
        --1단계 판매 권수에 대한 순위 구하기
        SELECT b.bCode, bName, sum(qty) 판매권수, RANK() OVER(ORDER BY SUM(qty) DESC) 순위
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        ORDER BY 순위;
        
        SELECT bcode, bname
        FROM (
            SELECT b.bCode, bName, sum(qty) 판매권수, RANK() OVER(ORDER BY SUM(qty) DESC) 순위
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            GROUP BY (b.bCode, bName)
            ORDER BY 순위
        ) WHERE 순위=1;
        
        --#방법2. RANK를 구하지 않고 풀이 (이걸 쓰고 싶었음. HAVING으로 쓰면 되겠구나!)
        SELECT b.bCode, bName
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        HAVING SUM(qty) = (
            SELECT MAX(SUM(qty)) --판매 권수의 합이 가장 큰 숫자
            FROM book b1
            JOIN dsale d1 ON b1.bCode = d1.bCode
            GROUP BY (b1.bCode, bName)
        );
        
        --작년 판매 실적
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty 금액
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')-1;
--        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE - INTERVAL '1' YEAR,'YYYY);
        
        --문제5) 연도별 판매 금액의 합: 연도, 판매 합(연도별 판매의 합)
        --연도 순으로 오름차순
        --필요한 정보: 이 3개의 테이블을 엮어주면 된다.
        -- book(bCode, bPrice)
        -- dsale(bCode, qty, sNum)
        -- sale(sdate, sNum)
        
        --0단계: 간단한 쿼리 작성
        --날짜별 책 판매 정보 
        SELECT b.bCode, bPrice, sDate, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum;
        
        --연도별 책 판매 정보 
        SELECT TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 금액
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY TO_CHAR(sdate,'YYYY')
        ORDER BY 연도;
        
        --1단계: 책코드별 판매 금액의 합
        SELECT b.bCode, SUM(qty*bPrice)
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY b.bCode, bPrice;

        --2단계: 연도별로 분류를 해야지..??
        SELECT 연도, TO_CHAR(SUM(판매금액),'L999,999,999') 판매금
        FROM (
            --연도별 책코드별 판매 금액의 합
            SELECT TO_CHAR(sdate,'YYYY') 연도, b.bCode, SUM(bprice*qty) 판매금액
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.sNum = s.sNum
            GROUP BY TO_CHAR(sdate,'YYYY'), b.bCode, bPrice
        )
        GROUP BY 연도
        ORDER BY 연도 DESC;
        
        --선생님 답안: 이건 연도별, 책별
        SELECT TO_CHAR(sDate, 'YYYY') 년도, SUM(bPrice*qty) 금액
		FROM book b
		JOIN dsale d ON b.bCode=d.bCode
		JOIN sale s ON d.sNum=s.sNum
		GROUP BY TO_CHAR(sDate, 'YYYY')
		ORDER BY 년도 desc;

        --문제6)
        --고객번호(cnum), 고객명(cname), 연도, 판매금액의 합: 
        --고객번호 오름차순, 연도 오름차순
        --필요한 정보
        --book(bcode, bprice)
        --cus(cnum, cname)
        --dsale(bcode, snum)
        --sale(snum, sdate)
        
        SELECT s.cnum 고객번호, cname 고객사명, TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 판매금액
        FROM book b
        --JOIN에도 순서가 있으므로 유의한다.
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
        JOIN cus c ON s.cnum = c.cnum
        GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
        ORDER BY 고객번호, 연도;		
        
        -------------------------------------------------------
		-- 문제7) 고객번호(cNum), 고객명(cName) : 작년 누적판매금액이 가장 많은 고객출력
        SELECT 고객번호, 고객명 FROM (
        --작년 고객별 누적판매금액
            SELECT s.cnum 고객번호, cname 고객명, TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 판매금액, RANK() OVER(ORDER BY sum(bprice*qty) DESC) 순위
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.snum = s.snum
            JOIN cus c ON s.cnum = c.cnum
            WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')-1
            GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
        ) WHERE 순위 = 1;
        
        -------------------------------------------------------
		-- 문제8) 고객번호(cNum), 고객명(cName), 회원 아이디(userId) : 회원중 올해 누적판매금액이 가장 많은 고객출력
        
        --#방법1. 서브쿼리로 회원아이디를 추출하는 방법
        SELECT result.*, (SELECT userid FROM member WHERE cnum=result.고객번호) "회원 아이디"
        FROM (
            SELECT 고객번호, 고객명 FROM (
            --작년 고객별 누적판매금액
                SELECT s.cnum 고객번호, cname 고객명, TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 판매금액, RANK() OVER(ORDER BY sum(bprice*qty) DESC) 순위
                FROM book b
                JOIN dsale d ON b.bcode = d.bcode
                JOIN sale s ON d.snum = s.snum
                JOIN cus c ON s.cnum = c.cnum
                WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
                GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
            ) WHERE 순위 = 1
        ) result;
        
        --#방법2. 서브쿼리 없이 JOIN만으로 해결하는 방법
        --단, 1위만 추출하기 위한 서브쿼리는 필요하다
        SELECT 고객번호, 고객명, "회원 아이디" FROM (
            --작년 고객별 누적판매금액
                SELECT s.cnum 고객번호, cname 고객명, userid "회원 아이디", TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 판매금액, RANK() OVER(ORDER BY sum(bprice*qty) DESC) 순위
                FROM book b
                JOIN dsale d ON b.bcode = d.bcode
                JOIN sale s ON d.snum = s.snum
                JOIN cus c ON s.cnum = c.cnum
                JOIN member m ON c.cnum = m.cnum
                WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
                GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY'), userid
        ) WHERE 순위 = 1;
        
        --#방법2-1. WITH구문으로 변환하여 사용해 보기
        WITH 결과 AS (
            SELECT s.cnum 고객번호, cname 고객명, userid "회원 아이디", TO_CHAR(sdate,'YYYY') 연도, sum(bprice*qty) 판매금액, RANK() OVER(ORDER BY sum(bprice*qty) DESC) 순위
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.snum = s.snum
            JOIN cus c ON s.cnum = c.cnum
            JOIN member m ON c.cnum = m.cnum
            WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
            GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY'), userid
        )
        SELECT 고객번호, 고객명, "회원 아이디" 
        FROM 결과 
        WHERE 순위=1;
        
        --#방법2-1. (복습) WITH구문
        
        -------------------------------------------------------
        -- 문제9) 책코드(bCode), 책이름(bName), 판매권수합 : 판매권수합이 80권이상인 책만 출력        
        SELECT b.bcode, bname, sum(qty) "판매권수 합"
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        GROUP BY b.bcode, bname
        HAVING sum(qty) >= 80;
        
    --참고
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
    --------------
        sale: sNum, sDate, cNum -- cNum 고객번호: 누가 사 갔는지 추적
        dsale: dNum, sNum, bCode, qty --sNum을 이용하여 sale과 dSale의 관계를 맺을 수 있다.
    --------------
        cus: cNum, cName, cTel
        member:cnum, userid, userPwd, userEmail
    
    

     2) NATURAL JOIN
        -- 형식
           SELECT 컬럼명, 컬럼명 ....
           FROM 테이블명1
           NATURAL JOIN  테이블명2;

        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty 금액
        FROM book
        NATURAL JOIN pub
        NATURAL JOIN dsale
        NATURAL JOIN sale 
        NATURAL JOIN cus;


     3) CROSS JOIN
     --상호 조인은 조인에 포함된 테이블의 카티션 곱(Cartisian Product)을 반환한다.
     --5개 X 5개 = 25개
     --학술적인 용도로 사용할 뿐이지 실무에서 쓰일 일은 없다.
     
     SELECT p.pnum, pname, bcode, bname
     from pub p
     CROSS JOIN book b;


     4) SELF JOIN
        -------------------------------------------------------
        select * from bclass;
        
        --좌측 컬럼은 대분류, 우측 컬럼은 소분류가 나오게 된다.
        SELECT b1.bcCode, b1.bcSubject, --b1.pcCode, 
                   b2.bcCode, b2.bcSubject, b2.pcCode
        FROM bclass b1
        JOIN bclass b2 ON b1.bcCode = b2.pcCode;
        
        select * from author;
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode=a2.bCode
        ORDER BY a1.bCode;
        
        
     5) NON-EQUI JOIN
        -- 형식
            SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
            FROM 테이블명1, 테이블명2..
            WHERE (non-equi-join 조건);

        --NON EQUI조인의 예시    
        --저자가 2명 이상인 "정보" 출력
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        ORDER BY a1.bCode;
        
        --저자가 2명 이상인 책의 내용만 출력
        SELECT bCode, bName
        FROM book b
        WHERE bCode IN (
            SELECT a1.bCode
            FROM author a1
            JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        );

        -------------------------------------------------------
        --


   ο OUTER JOIN
     1) LEFT OUTER JOIN
       -- 형식1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명=테이블명2.컬럼명(+);

       -- 형식2
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1
          LEFT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        --


     2) RIGHT OUTER JOIN
       -- 형식1
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
           FROM 테이블명1, 테이블명2
           WHERE 테이블명1.컬럼명(+)=테이블명2.컬럼명;

       -- 형식2
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1
          RIGHT OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        --


     3) FULL OUTER JOIN
       -- 형식
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1 FULL OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        --


   ο UPDATE JOIN VIEW 이용하여 빠른 업데이트(서브쿼리 보다 훨씬 빠르다.)
      - 테이블을 조인하여 UPDATE
      - tb_a 테이블의 내용(new_addr1, new_addr2)을 tb_b에 존재하는 내용(n_addr1, n_addr2)으로 수정
      - 조인 조건의 컬럼이 UNIQUE 속성이어야 가능하며(관계가 1:1) 그렇지 않으면 ORA-01779 오류가 발생한다.

     -------------------------------------------------------
     -- 예제
        CREATE TABLE tb_a (
             num  NUMBER PRIMARY KEY
            ,addr1  VARCHAR2(255)
            ,addr2 VARCHAR2(255)
            ,new_addr1 VARCHAR2(255)
            ,new_addr2 VARCHAR2(255)
       );

      CREATE TABLE tb_b (
           num  NUMBER PRIMARY KEY
          ,n_addr1 VARCHAR2(255)
          ,n_addr2 VARCHAR2(255)
      );

      INSERT INTO tb_a VALUES(1,'서울1-1', '서울1-2','도로1-1', '도로1-2');
      INSERT INTO tb_a VALUES(2,'서울2-1', '서울2-2','도로2-1', '도로2-2');
      INSERT INTO tb_a VALUES(3,'서울3-1', '서울3-2','도로3-1', '도로3-2');
      INSERT INTO tb_a VALUES(4,'서울4-1', '서울4-2','도로4-1', '도로4-2');
      INSERT INTO tb_a VALUES(5,'서울5-1', '서울5-2','도로5-1', '도로5-2');

      INSERT INTO tb_b VALUES(1,'세종1-1', '세종1-2');
      INSERT INTO tb_b VALUES(3,'세종3-1', '세종3-2');
      INSERT INTO tb_b VALUES(5,'세종5-1', '세종5-2');
      COMMIT;

     -------------------------------------------------------
     --


 ※ subquery
   ο WITH
     -------------------------------------------------------
     --


   ο 단일 행 서브 쿼리
     -------------------------------------------------------
     --


   ο 다중 행 서브 쿼리
      - IN
       -------------------------------------------------------
       --


      - ANY(SOME) 
       -------------------------------------------------------
       --


      - ALL
       -------------------------------------------------------
       --


      - EXISTS 
       -------------------------------------------------------
       --


   ο 상호 연관 서브 쿼리(correlated subquery, 상관 하위 부질의)
     -------------------------------------------------------
     --