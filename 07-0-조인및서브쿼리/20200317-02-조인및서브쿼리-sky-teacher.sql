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
          -- 에러 : 동일한 이름의 컬럼명이 두테이블에 존재하며, 모호성이 발생. ORA-
          
        SELECT emp.empNo, name, com, excel, word
        FROM emp, emp_score
        WHERE emp.empNo = emp_score.empNo;
          
        SELECT e.empNo, name, com, excel, word
        FROM emp e, emp_score s
        WHERE e.empNo = s.empNo;

        SELECT e.empNo, name, com, excel, word
        FROM emp e 
        JOIN emp_score s ON e.empNo = s.empNo;
        

        -- 판매현황 : 책코드(bCode), 책이름(bName), 책가격(bPrice), 출판사번호(pNum),
                    출판사이름(pName), 판매일자(sDate), 판매고객번호(cNum),
                    판매고객이름(cName), 판매수량(qty), 금액(bPrice * qty)

        -------------------------------------------------------
        --
        book : bCode, bName, bPrice, pNum
        pub : pNum, pName
        sale : sNum, sDate, cNum
        dsale : sNum, bCode, qty
        cus : cNum, cName
        
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b, pub p, sale s, dsale d, cus c
        WHERE b.pNmu = p.pNum AND b.bCode = d.bCode
              AND d.sNum = s.sNum AND s.cNum = c.cNum;        
        
        -- 형식 2
           SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
           FROM 테이블명1
           [ INNER ] JOIN 테이블명2 ON 테이블명1.컬럼명 = 테이블명2.컬럼명

        -------------------------------------------------------
        --
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p  ON  b.pNmu = p.pNum
        JOIN dsale d  ON b.bCode = d.bCode
        JOIN sale s  ON  d.sNum = s.sNum
        JOIN cus c  ON s.cNum = c.cNum;

        -- 형식 3
           SELECT 컬럼명, 컬럼명
           FROM 테이블명1
           JOIN 테이블명2 USING (컬럼명1)
           JOIN 테이블명3 USING (컬럼명2);

        -------------------------------------------------------
        --
        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum,
               cName, qty, bPrice*qty amt
        FROM book
        JOIN pub   USING(pNum)
        JOIN dsale   USING(bCode)
        JOIN sale   USING(sNum)
        JOIN cus   USING(cNum);
        
        -------------------------------------------------------
        -- 판매된 책코드(bCode), 책이름(bName), 판매권수의합(qty 합)
        -- 책코드 오름차순
        -- book(bCode, bName), dsale(bCode, qty)
        SELECT b.bCode, bName, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty) 권수합
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        ORDER BY b.bCode;
        
        
        -------------------------------------------------------
        -- 판매된 책코드(bCode), 책이름(bName), 판매권수의합(qty 합), 판매금액합(qty*bPrice 합)
        -- 책코드 오름차순
        -- book(bCode, bName, bPrice), dsale(bCode, qty)
        SELECT b.bCode, bName, bPrice, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty) 권수합, SUM(qty*bPrice) 금액합
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        ORDER BY b.bCode;
        
        -- 판매된 책코드(bCode), 책이름(bName) : 중복배제
        SELECT DISTINCT b.bCode, bName
        FROM book b
        JOIN dsale d ON d.bCode=d.bCode;

        -- 판매된 책중 판매권수합이 가장 큰 책코드(bCode), 책이름(qty)
        -- book(bCode, bName), dsale(bCode, qty)
        SELECT b.bCode, bName, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty)
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName;
        
        SELECT b.bCode, bName, SUM(qty),
            RANK() OVER(ORDER BY SUM(qty) DESC) 순위
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName;
        
        -- 방법 1
        SELECT bCode, bName FROM (
            SELECT b.bCode, bName, SUM(qty),
                RANK() OVER(ORDER BY SUM(qty) DESC) 순위
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            GROUP BY b.bCode, bName
        ) WHERE 순위=1;

        -- 방법 2
        SELECT b.bCode, bName
        FROM book b
        JOIN JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        HAVING SUM(qty) = (
           SELECT MAX(SUM(qty))
           FROM book b1
           JOIN dsale d1  ON b1.bCode = d1.bCode
           GROUP BY b1.bCode, bName
        );
        
        -------------------------------------------------------
        -- 올해판매현황
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p  ON  b.pNmu = p.pNum
        JOIN dsale d  ON b.bCode = d.bCode
        JOIN sale s  ON  d.sNum = s.sNum
        JOIN cus c  ON s.cNum = c.cNum
        WHERE TO_CHAR(SYSDATE, 'YYYY') = TO_CHAR(sDate, 'YYYY');

        -- 작년판매현황
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p  ON  b.pNmu = p.pNum
        JOIN dsale d  ON b.bCode = d.bCode
        JOIN sale s  ON  d.sNum = s.sNum
        JOIN cus c  ON s.cNum = c.cNum
        -- WHERE TO_CHAR(SYSDATE, 'YYYY')-1 = TO_CHAR(sDate, 'YYYY');
        WHERE TO_CHAR(SYSDATE-(INTERVAL '1' YEAR), 'YYYY') = TO_CHAR(sDate, 'YYYY');
        
        -------------------------------------------------------
        -- 년도별 판매금액의 합 : 년도, 판매합(년도별 판매합)
        -- 년도 오름차순
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate)
        
        SELECT b.bCode, bPrice, sDate, qty
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum;
        
        SELECT TO_CHAR(sDate, 'YYYY') 년도, SUM(bPrice*qty) 금액
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        GROUP BY TO_CHAR(sDate, 'YYYY')
        ORDER BY 년도;
        
        -------------------------------------------------------
        -- 고객번호(cNum), 고객명(cName), 년도, 판매금액합 : 고객번호오름차순, 년도 오름차순
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName)
        
        SELECT s.cNum, cName, sDate, bPrice*qty
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum;
        
        SELECT s.cNum, cName, TO_CHAR(sDate, 'YYYY') 년도, SUM(bPrice*qty) 금액합
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum, 년도;
        
        -------------------------------------------------------
        -- 고객번호(cNum), 고객명(cName) : 작년 누적판매금액이 가장 많은 고객출력
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName)

        SELECT s.cNum, cName, SUM(bPrice*qty) 금액합
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum;

        SELECT s.cNum, cName, SUM(bPrice*qty) 금액합,
           RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) 순위
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum;
        
        SELECT cNum, cName FROM (
           SELECT s.cNum, cName, 
               RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) 순위
           FROM book b
           JOIN dsale d ON b.bCode=d.bCode
           JOIN sale s ON d.sNum=s.sNum
           JOIN cus c ON s.cNum=c.cNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
           GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ) WHERE 순위=1;
        
        -------------------------------------------------------
        -- 고객번호(cNum), 고객명(cName), 회원 아이디(userId) : 회원중 올해 누적판매금액이 가장 많은 고객출력

        SELECT cNum, cName, userId FROM (
           SELECT s.cNum, cName, userId,
               RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) 순위
           FROM book b
           JOIN dsale d ON b.bCode=d.bCode
           JOIN sale s ON d.sNum=s.sNum
           JOIN cus c ON s.cNum=c.cNum
           JOIN member m ON c.cNum=m.cNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
           GROUP BY cNum, cName, userId, TO_CHAR(sDate, 'YYYY')
        ) WHERE 순위=1;
        
        -------------------------------------------------------
        -- 책코드(bCode), 책이름(bName), 판매권수합 : 판매권수합이 80권이상인 책만 출력
        
        SELECT b.bCode, bName, SUM(qty)
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        HAVING SUM(qty) >= 80;


     2) NATURAL JOIN
        -- 형식
           SELECT 컬럼명, 컬럼명 ....
           FROM 테이블명1
           NATURAL JOIN  테이블명2

        -------------------------------------------------------
        --
        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum,
               cName, qty, bPrice*qty amt
        FROM book
        NATURAL JOIN pub
        NATURAL JOIN dsale
        NATURAL JOIN sale
        NATURAL JOIN cus;


     3) CROSS JOIN
        -------------------------------------------------------
        --
        SELECT p.pNum, pName, bCode, bName
        FROM pub p
        CROSS JOIN book b;


     4) SELF JOIN
        -------------------------------------------------------
        --
        SELECT b1.bcCode, b1.bcSubject, b1.pcCode, 
               b2.bcCode, b2.bcSubject, b2.pcCode
        FROM bclass b1
        JOIN bclass b2 ON b1.bcCode = b2.pcCode;        
        
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode=a2.bCode
        ORDER BY a1.bCode;
              
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        ORDER BY a1.bCode;
        
        SELECT bCode, bName
        FROM book
        WHERE bCode IN (
            SELECT a1.bCode
            FROM author a1
            JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        );


     5) NON-EQUI JOIN
        -- 형식
            SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명 ....
            FROM 테이블명1, 테이블명2..
            WHERE (non-equi-join 조건)

        -------------------------------------------------------
        -- EQUI JOIN
        SELECT s.sNum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum = d.sNum
        
        -- NON-EQUI JOIN
        SELECT s.sNum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum > 10;


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
        -- book(bCode, bName), dsale(bCode, sNum, qty)
        -- EQUI JOIN
        SELECT b.bCode, bName, sNum, qty
        FROM book b, dsale d
        WHERE b.bCode = d.bCode;
        
        -- LEFT OUTER JOIN
        SELECT b.bCode, bName, sNum, qty
        FROM book b, dsale d
        WHERE b.bCode = d.bCode(+);
        
        SELECT b.bCode, bName, sNum, qty
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode;
        
        -- bCode, bName, sNum, sDate, qty 출력
          -- 단, bCode와 bName은 한권도 판매가 되지 않은 책도 출력
        SELECT b.bCode, bName, d.sNum, sDate, qty
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        LEFT OUTER JOIN sale s ON d.sNum = s.sNum;

        ---------------------------------        
        -- 판매된 책코드, 책이름
        SELECT bCode, bName
        FROM book
        WHERE bCode IN ( SELECT DISTINCT bCode FROM dsale );
        
        SELECT b.bCode, bName
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        -- WHERE dNum IS NOT NULL;
        WHERE d.bCode IS NOT NULL;
        
        -- 한권도 판매되지 않은 서적
        SELECT b.bCode, bName
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        WHERE d.bCode IS NULL;
        
        ---------------------------------        
        -- 올해 판매된 책코드, 책이름
        SELECT bCode, bName
        FROM book
        WHERE bCode IN (
           SELECT DISTINCT bCode
           FROM dsale d
           JOIN sale s ON d.sNum = s.sNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
        );


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
        -- book(bCode, bName), dsale(bCode, sNum, qty)
        -- EQUI JOIN
        SELECT b.bCode, bName, sNum, qty
        FROM book b, dsale d
        WHERE b.bCode = d.bCode;
        
        -- RIGHT OUTER JOIN
        SELECT b.bCode, bName, sNum, qty
        FROM dsale d, book b
        WHERE d.bCode(+) = b.bCode;
        
        SELECT b.bCode, bName, sNum, qty
        FROM dsale d
        RIGHT OUTER JOIN book b ON d.bCode = b.bCode;


     3) FULL OUTER JOIN
       -- 형식
          SELECT [테이블명1.]컬럼명, [테이블명2.]컬럼명
          FROM 테이블명1 FULL OUTER JOIN 테이블명2 ON 테이블명1.컬럼명=테이블명2.컬럼명;

        -------------------------------------------------------
        -- 
        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        LEFT OUTER JOIN member m ON s.cNum = m.cNum;
        
        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        RIGHT OUTER JOIN member m ON s.cNum = m.cNum;

        SELECT sNum, sDate, s.cNum, m.cNum, userId
        FROM sale s
        FULL OUTER JOIN member m ON s.cNum = m.cNum;

        -- cus를 마지막에 JOIN 해서 cName이 NULL로 출력되는 것이 있음
        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM sale s
        FULL OUTER JOIN member m ON s.cNum = m.cNum
        FULL OUTER JOIN cus c ON c.cNum = s.cNum;

        -- cName이 NULL이 출력 되지 않음
        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM cus c
        FULL OUTER JOIN member m ON c.cNum = m.cNum
        FULL OUTER JOIN sale s ON c.cNum = s.cNum;

        ------------------------------------------------------
        -- 예제
        -- 비회원 판매 현황 : cNum, cName, bCode, bName, sDate, bPrice, qty
           -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName), member(cNum, userId)
           
            SELECT s.cNum, cName, userId, b.bCode, bName, sDate, bPrice, qty
            FROM  book b
            JOIN  dsale d  ON  b.bCode = d.bCode
            JOIN  sale s   ON  d.sNum = s.sNum
            JOIN  cus c    ON  s.cNum = c.cNum
            LEFT OUTER JOIN  member m  ON  c.cNum = m.cNum;
            
            SELECT s.cNum, cName, b.bCode, bName, sDate, bPrice, qty
            FROM  book b
            JOIN  dsale d  ON  b.bCode = d.bCode
            JOIN  sale s   ON  d.sNum = s.sNum
            JOIN  cus c    ON  s.cNum = c.cNum
            LEFT OUTER JOIN  member m   ON  c.cNum = m.cNum
            WHERE userId IS NULL;

        -- 고객별 누적판매 금액(고객번호:cNum, 고객명:cName, 판매급액합) 출력.
          -- 단, 고객중 책을 한권도 구매하지 않은 고객도 출력
          -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
          
          SELECT c.cNum, cName, NVL(SUM(bPrice * qty), 0) 합
          FROM cus c
          LEFT OUTER JOIN sale s ON c.cNum = s.cNum
          LEFT OUTER JOIN dsale d ON s.sNum = d.sNum
          LEFT OUTER JOIN book b ON d.bCode = b.bCode
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;
     
          SELECT c.cNum, cName, NVL(SUM(bPrice * qty), 0) 합
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          RIGHT OUTER JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;
      
        -- 고객별 누적판매 금액 및 비율(고객번호:cNum, 고객명:cName, 판매급액합, 비율) 출력.
          -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
          
          SELECT c.cNum, cName, SUM(bPrice * qty) 합
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

          SELECT c.cNum, cName, SUM(bPrice * qty) 합, 
             ROUND(SUM(bPrice * qty) / 
                  ( SELECT SUM(qty*bPrice) FROM dsale d, book b WHERE d.bCode=b.bCode ) *100, 1)  || '%' 비율
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

          SELECT c.cNum, cName, SUM(bPrice * qty) 합,
             ROUND(RATIO_TO_REPORT(SUM(bPrice * qty)) OVER() * 100, 1) || '%' 비율
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

        -- 년도별 고객 누적 판매금액이 가장 많은 값 출력
           -- 판매년도, cNum, cName, bPrice*qty 합
           -- 년도 오름차순으로   
           -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum, sDate), cus(cNum, cName)
           
            SELECT TO_CHAR(sDate, 'YYYY') 년도, s.cNum, cName, SUM(bPrice * qty) 금액
            FROM  book b
            JOIN  dsale d ON  b.bCode = d.bCode
            JOIN  sale s  ON  d.sNum = s.sNum
            JOIN  cus c   ON  s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ORDER BY 년도;

            SELECT TO_CHAR(sDate, 'YYYY') 년도, s.cNum, cName, SUM(bPrice * qty) 금액,
                 RANK() OVER(PARTITION BY TO_CHAR(sDate, 'YYYY') ORDER BY SUM(bPrice * qty) DESC) 순위
            FROM  book b
            JOIN  dsale d ON  b.bCode = d.bCode
            JOIN  sale s  ON  d.sNum = s.sNum
            JOIN  cus c   ON  s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ORDER BY 년도;

            SELECT 년도, cNum, cName, 금액 FROM (
                SELECT TO_CHAR(sDate, 'YYYY') 년도, s.cNum, cName, SUM(bPrice * qty) 금액,
                     RANK() OVER(PARTITION BY TO_CHAR(sDate, 'YYYY') ORDER BY SUM(bPrice * qty) DESC) 순위
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum
                JOIN  cus c   ON  s.cNum = c.cNum
                GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ) WHERE  순위=1
            ORDER BY 년도;

        -- 년도의 월별 서적의 판매 수량의 합 구하기 : 년도오름차순, 책코드 오름차순
            -- 년도 책코드 책이름 1월 2월 3월 ... 12월
                SELECT TO_CHAR(sDate, 'YYYY') 년도, b.bCode, bName, qty
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum;

                SELECT TO_CHAR(sDate, 'YYYY') 년도, b.bCode, bName, 
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '01', qty)),0) M01,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '02', qty)),0) M02,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '03', qty)),0) M03,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '04', qty)),0) M04,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '05', qty)),0) M05,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '06', qty)),0) M06,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '07', qty)),0) M07,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '08', qty)),0) M08,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '09', qty)),0) M09,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '10', qty)),0) M10,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '11', qty)),0) M11,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '12', qty)),0) M12
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum
                GROUP BY TO_CHAR(sDate, 'YYYY'), b.bCode, bName
                ORDER BY 년도, bCode;

            -- 년도별 소계
                SELECT TO_CHAR(sDate, 'YYYY') 년도, b.bCode, bName, 
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '01', qty)),0) M01,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '02', qty)),0) M02,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '03', qty)),0) M03,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '04', qty)),0) M04,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '05', qty)),0) M05,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '06', qty)),0) M06,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '07', qty)),0) M07,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '08', qty)),0) M08,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '09', qty)),0) M09,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '10', qty)),0) M10,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '11', qty)),0) M11,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '12', qty)),0) M12
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum
                GROUP BY TO_CHAR(sDate, 'YYYY'), ROLLUP((b.bCode, bName))
                ORDER BY 년도, bCode;

            -- 년도별 소계, 총계
                SELECT TO_CHAR(sDate, 'YYYY') 년도, b.bCode, bName, 
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '01', qty)),0) M01,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '02', qty)),0) M02,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '03', qty)),0) M03,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '04', qty)),0) M04,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '05', qty)),0) M05,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '06', qty)),0) M06,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '07', qty)),0) M07,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '08', qty)),0) M08,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '09', qty)),0) M09,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '10', qty)),0) M10,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '11', qty)),0) M11,
                   NVL(SUM(DECODE(TO_CHAR(sDate, 'MM'), '12', qty)),0) M12
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum
                GROUP BY ROLLUP(TO_CHAR(sDate, 'YYYY'), (b.bCode, bName))
                ORDER BY 년도, bCode;


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

