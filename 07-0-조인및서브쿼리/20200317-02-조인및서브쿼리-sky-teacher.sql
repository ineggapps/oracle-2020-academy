�� ���ΰ� ���� ����
 �� ����(joins)
   �� INNER JOIN
       -- �ǽ� ���̺�
         -- �з� ���̺�(�з��ڵ�, �з���, �����з��ڵ�)
            SELECT bcCode, bcSubject, pcCode FROM bclass;

         -- ���ǻ� ���̺�(���ǻ��ȣ, ���ǻ��, ��ȭ��ȣ)
            SELECT pNum, pName, pTel FROM pub;

         -- å ���̺�(�����ڵ�, ������, ����, �з��ڵ�, ���ǻ��ȣ)
            SELECT bCode, bName, bPrice, bcCode, pNum FROM book;

         -- ���� ���̺�(���ڹ�ȣ, �����ڵ�, ���ڸ�)
            SELECT aNum, bCode, aName FROM author;

         -- �� ���̺�(����ȣ, ����, ��ȭ��ȣ)
            SELECT cNum, cName, cTel FROM cus;

         -- ȸ�� ���̺�(����ȣ, ȸ�����̵�, ȸ���н�����, �̸���)
            SELECT cNum, userId, userPwd, userEmail FROM member;
    
         -- �Ǹ� ���̺�(�ǸŹ�ȣ, �Ǹ�����, ����ȣ)
            SELECT sNum, sDate, cNum FROM sale;

         -- �Ǹ� �� ���̺�(�ǸŻ󼼹�ȣ, �ǸŹ�ȣ, �����ڵ�, �Ǹż���)
            SELECT dNum, sNum, bCode, qty FROM dsale;

     1) EQUI JOIN
        -- ���� 1
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷��� ....
           FROM ���̺��1, ���̺��2
           WHERE ���̺��1.�÷��� = ���̺��2.�÷���  [AND ����]

        --
        SELECT * FROM emp;
        SELECT * FROM emp_score;
        
        SELECT empNo, name, com, excel, word
        FROM emp, emp_score
        WHERE emp.empNo = emp_score.empNo;
          -- ���� : ������ �̸��� �÷����� �����̺� �����ϸ�, ��ȣ���� �߻�. ORA-
          
        SELECT emp.empNo, name, com, excel, word
        FROM emp, emp_score
        WHERE emp.empNo = emp_score.empNo;
          
        SELECT e.empNo, name, com, excel, word
        FROM emp e, emp_score s
        WHERE e.empNo = s.empNo;

        SELECT e.empNo, name, com, excel, word
        FROM emp e 
        JOIN emp_score s ON e.empNo = s.empNo;
        

        -- �Ǹ���Ȳ : å�ڵ�(bCode), å�̸�(bName), å����(bPrice), ���ǻ��ȣ(pNum),
                    ���ǻ��̸�(pName), �Ǹ�����(sDate), �ǸŰ���ȣ(cNum),
                    �ǸŰ��̸�(cName), �Ǹż���(qty), �ݾ�(bPrice * qty)

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
        
        -- ���� 2
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷��� ....
           FROM ���̺��1
           [ INNER ] JOIN ���̺��2 ON ���̺��1.�÷��� = ���̺��2.�÷���

        -------------------------------------------------------
        --
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p  ON  b.pNmu = p.pNum
        JOIN dsale d  ON b.bCode = d.bCode
        JOIN sale s  ON  d.sNum = s.sNum
        JOIN cus c  ON s.cNum = c.cNum;

        -- ���� 3
           SELECT �÷���, �÷���
           FROM ���̺��1
           JOIN ���̺��2 USING (�÷���1)
           JOIN ���̺��3 USING (�÷���2);

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
        -- �Ǹŵ� å�ڵ�(bCode), å�̸�(bName), �ǸűǼ�����(qty ��)
        -- å�ڵ� ��������
        -- book(bCode, bName), dsale(bCode, qty)
        SELECT b.bCode, bName, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty) �Ǽ���
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        ORDER BY b.bCode;
        
        
        -------------------------------------------------------
        -- �Ǹŵ� å�ڵ�(bCode), å�̸�(bName), �ǸűǼ�����(qty ��), �Ǹűݾ���(qty*bPrice ��)
        -- å�ڵ� ��������
        -- book(bCode, bName, bPrice), dsale(bCode, qty)
        SELECT b.bCode, bName, bPrice, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty) �Ǽ���, SUM(qty*bPrice) �ݾ���
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        ORDER BY b.bCode;
        
        -- �Ǹŵ� å�ڵ�(bCode), å�̸�(bName) : �ߺ�����
        SELECT DISTINCT b.bCode, bName
        FROM book b
        JOIN dsale d ON d.bCode=d.bCode;

        -- �Ǹŵ� å�� �ǸűǼ����� ���� ū å�ڵ�(bCode), å�̸�(qty)
        -- book(bCode, bName), dsale(bCode, qty)
        SELECT b.bCode, bName, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode;
        
        SELECT b.bCode, bName, SUM(qty)
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName;
        
        SELECT b.bCode, bName, SUM(qty),
            RANK() OVER(ORDER BY SUM(qty) DESC) ����
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName;
        
        -- ��� 1
        SELECT bCode, bName FROM (
            SELECT b.bCode, bName, SUM(qty),
                RANK() OVER(ORDER BY SUM(qty) DESC) ����
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            GROUP BY b.bCode, bName
        ) WHERE ����=1;

        -- ��� 2
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
        -- �����Ǹ���Ȳ
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum,
               cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p  ON  b.pNmu = p.pNum
        JOIN dsale d  ON b.bCode = d.bCode
        JOIN sale s  ON  d.sNum = s.sNum
        JOIN cus c  ON s.cNum = c.cNum
        WHERE TO_CHAR(SYSDATE, 'YYYY') = TO_CHAR(sDate, 'YYYY');

        -- �۳��Ǹ���Ȳ
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
        -- �⵵�� �Ǹűݾ��� �� : �⵵, �Ǹ���(�⵵�� �Ǹ���)
        -- �⵵ ��������
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate)
        
        SELECT b.bCode, bPrice, sDate, qty
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum;
        
        SELECT TO_CHAR(sDate, 'YYYY') �⵵, SUM(bPrice*qty) �ݾ�
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        GROUP BY TO_CHAR(sDate, 'YYYY')
        ORDER BY �⵵;
        
        -------------------------------------------------------
        -- ����ȣ(cNum), ����(cName), �⵵, �Ǹűݾ��� : ����ȣ��������, �⵵ ��������
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName)
        
        SELECT s.cNum, cName, sDate, bPrice*qty
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum;
        
        SELECT s.cNum, cName, TO_CHAR(sDate, 'YYYY') �⵵, SUM(bPrice*qty) �ݾ���
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum, �⵵;
        
        -------------------------------------------------------
        -- ����ȣ(cNum), ����(cName) : �۳� �����Ǹűݾ��� ���� ���� �����
        -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, sDate, cNum), cus(cNum, cName)

        SELECT s.cNum, cName, SUM(bPrice*qty) �ݾ���
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum;

        SELECT s.cNum, cName, SUM(bPrice*qty) �ݾ���,
           RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) ����
        FROM book b
        JOIN dsale d ON b.bCode=d.bCode
        JOIN sale s ON d.sNum=s.sNum
        JOIN cus c ON s.cNum=c.cNum
        WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
        GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ORDER BY s.cNum;
        
        SELECT cNum, cName FROM (
           SELECT s.cNum, cName, 
               RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) ����
           FROM book b
           JOIN dsale d ON b.bCode=d.bCode
           JOIN sale s ON d.sNum=s.sNum
           JOIN cus c ON s.cNum=c.cNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')-1
           GROUP BY cNum, cName, TO_CHAR(sDate, 'YYYY')
        ) WHERE ����=1;
        
        -------------------------------------------------------
        -- ����ȣ(cNum), ����(cName), ȸ�� ���̵�(userId) : ȸ���� ���� �����Ǹűݾ��� ���� ���� �����

        SELECT cNum, cName, userId FROM (
           SELECT s.cNum, cName, userId,
               RANK() OVER(ORDER BY SUM(bPrice*qty) DESC) ����
           FROM book b
           JOIN dsale d ON b.bCode=d.bCode
           JOIN sale s ON d.sNum=s.sNum
           JOIN cus c ON s.cNum=c.cNum
           JOIN member m ON c.cNum=m.cNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
           GROUP BY cNum, cName, userId, TO_CHAR(sDate, 'YYYY')
        ) WHERE ����=1;
        
        -------------------------------------------------------
        -- å�ڵ�(bCode), å�̸�(bName), �ǸűǼ��� : �ǸűǼ����� 80���̻��� å�� ���
        
        SELECT b.bCode, bName, SUM(qty)
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY b.bCode, bName
        HAVING SUM(qty) >= 80;


     2) NATURAL JOIN
        -- ����
           SELECT �÷���, �÷��� ....
           FROM ���̺��1
           NATURAL JOIN  ���̺��2

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
        -- ����
            SELECT [���̺��1.]�÷���, [���̺��2.]�÷��� ....
            FROM ���̺��1, ���̺��2..
            WHERE (non-equi-join ����)

        -------------------------------------------------------
        -- EQUI JOIN
        SELECT s.sNum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum = d.sNum
        
        -- NON-EQUI JOIN
        SELECT s.sNum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum > 10;


   �� OUTER JOIN
     1) LEFT OUTER JOIN
       -- ����1
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
           FROM ���̺��1, ���̺��2
           WHERE ���̺��1.�÷���=���̺��2.�÷���(+);

       -- ����2
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1
          LEFT OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;

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
        
        -- bCode, bName, sNum, sDate, qty ���
          -- ��, bCode�� bName�� �ѱǵ� �ǸŰ� ���� ���� å�� ���
        SELECT b.bCode, bName, d.sNum, sDate, qty
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        LEFT OUTER JOIN sale s ON d.sNum = s.sNum;

        ---------------------------------        
        -- �Ǹŵ� å�ڵ�, å�̸�
        SELECT bCode, bName
        FROM book
        WHERE bCode IN ( SELECT DISTINCT bCode FROM dsale );
        
        SELECT b.bCode, bName
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        -- WHERE dNum IS NOT NULL;
        WHERE d.bCode IS NOT NULL;
        
        -- �ѱǵ� �Ǹŵ��� ���� ����
        SELECT b.bCode, bName
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bCode = d.bCode
        WHERE d.bCode IS NULL;
        
        ---------------------------------        
        -- ���� �Ǹŵ� å�ڵ�, å�̸�
        SELECT bCode, bName
        FROM book
        WHERE bCode IN (
           SELECT DISTINCT bCode
           FROM dsale d
           JOIN sale s ON d.sNum = s.sNum
           WHERE TO_CHAR(sDate, 'YYYY') = TO_CHAR(SYSDATE, 'YYYY')
        );


     2) RIGHT OUTER JOIN
       -- ����1
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
           FROM ���̺��1, ���̺��2
           WHERE ���̺��1.�÷���(+)=���̺��2.�÷���;

       -- ����2
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1
          RIGHT OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;

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
       -- ����
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1 FULL OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;

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

        -- cus�� �������� JOIN �ؼ� cName�� NULL�� ��µǴ� ���� ����
        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM sale s
        FULL OUTER JOIN member m ON s.cNum = m.cNum
        FULL OUTER JOIN cus c ON c.cNum = s.cNum;

        -- cName�� NULL�� ��� ���� ����
        SELECT sNum, sDate, s.cNum, m.cNum, cName, userId
        FROM cus c
        FULL OUTER JOIN member m ON c.cNum = m.cNum
        FULL OUTER JOIN sale s ON c.cNum = s.cNum;

        ------------------------------------------------------
        -- ����
        -- ��ȸ�� �Ǹ� ��Ȳ : cNum, cName, bCode, bName, sDate, bPrice, qty
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

        -- ���� �����Ǹ� �ݾ�(����ȣ:cNum, ����:cName, �Ǹű޾���) ���.
          -- ��, ���� å�� �ѱǵ� �������� ���� ���� ���
          -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
          
          SELECT c.cNum, cName, NVL(SUM(bPrice * qty), 0) ��
          FROM cus c
          LEFT OUTER JOIN sale s ON c.cNum = s.cNum
          LEFT OUTER JOIN dsale d ON s.sNum = d.sNum
          LEFT OUTER JOIN book b ON d.bCode = b.bCode
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;
     
          SELECT c.cNum, cName, NVL(SUM(bPrice * qty), 0) ��
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          RIGHT OUTER JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;
      
        -- ���� �����Ǹ� �ݾ� �� ����(����ȣ:cNum, ����:cName, �Ǹű޾���, ����) ���.
          -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum), cus(cNum, cName)
          
          SELECT c.cNum, cName, SUM(bPrice * qty) ��
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

          SELECT c.cNum, cName, SUM(bPrice * qty) ��, 
             ROUND(SUM(bPrice * qty) / 
                  ( SELECT SUM(qty*bPrice) FROM dsale d, book b WHERE d.bCode=b.bCode ) *100, 1)  || '%' ����
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

          SELECT c.cNum, cName, SUM(bPrice * qty) ��,
             ROUND(RATIO_TO_REPORT(SUM(bPrice * qty)) OVER() * 100, 1) || '%' ����
          FROM book b
          JOIN dsale d ON b.bCode =d.bCode
          JOIN sale s ON d.sNum = s.sNum
          JOIN cus c ON s.cNum = c.cNum
          GROUP BY c.cNum, cName
          ORDER BY c.cNum;

        -- �⵵�� �� ���� �Ǹűݾ��� ���� ���� �� ���
           -- �Ǹų⵵, cNum, cName, bPrice*qty ��
           -- �⵵ ������������   
           -- book(bCode, bPrice), dsale(sNum, bCode, qty), sale(sNum, cNum, sDate), cus(cNum, cName)
           
            SELECT TO_CHAR(sDate, 'YYYY') �⵵, s.cNum, cName, SUM(bPrice * qty) �ݾ�
            FROM  book b
            JOIN  dsale d ON  b.bCode = d.bCode
            JOIN  sale s  ON  d.sNum = s.sNum
            JOIN  cus c   ON  s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ORDER BY �⵵;

            SELECT TO_CHAR(sDate, 'YYYY') �⵵, s.cNum, cName, SUM(bPrice * qty) �ݾ�,
                 RANK() OVER(PARTITION BY TO_CHAR(sDate, 'YYYY') ORDER BY SUM(bPrice * qty) DESC) ����
            FROM  book b
            JOIN  dsale d ON  b.bCode = d.bCode
            JOIN  sale s  ON  d.sNum = s.sNum
            JOIN  cus c   ON  s.cNum = c.cNum
            GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ORDER BY �⵵;

            SELECT �⵵, cNum, cName, �ݾ� FROM (
                SELECT TO_CHAR(sDate, 'YYYY') �⵵, s.cNum, cName, SUM(bPrice * qty) �ݾ�,
                     RANK() OVER(PARTITION BY TO_CHAR(sDate, 'YYYY') ORDER BY SUM(bPrice * qty) DESC) ����
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum
                JOIN  cus c   ON  s.cNum = c.cNum
                GROUP BY TO_CHAR(sDate, 'YYYY'), s.cNum, cName
            ) WHERE  ����=1
            ORDER BY �⵵;

        -- �⵵�� ���� ������ �Ǹ� ������ �� ���ϱ� : �⵵��������, å�ڵ� ��������
            -- �⵵ å�ڵ� å�̸� 1�� 2�� 3�� ... 12��
                SELECT TO_CHAR(sDate, 'YYYY') �⵵, b.bCode, bName, qty
                FROM  book b
                JOIN  dsale d ON  b.bCode = d.bCode
                JOIN  sale s  ON  d.sNum = s.sNum;

                SELECT TO_CHAR(sDate, 'YYYY') �⵵, b.bCode, bName, 
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
                ORDER BY �⵵, bCode;

            -- �⵵�� �Ұ�
                SELECT TO_CHAR(sDate, 'YYYY') �⵵, b.bCode, bName, 
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
                ORDER BY �⵵, bCode;

            -- �⵵�� �Ұ�, �Ѱ�
                SELECT TO_CHAR(sDate, 'YYYY') �⵵, b.bCode, bName, 
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
                ORDER BY �⵵, bCode;


   �� UPDATE JOIN VIEW �̿��Ͽ� ���� ������Ʈ(�������� ���� �ξ� ������.)
      - ���̺��� �����Ͽ� UPDATE
      - tb_a ���̺��� ����(new_addr1, new_addr2)�� tb_b�� �����ϴ� ����(n_addr1, n_addr2)���� ����
      - ���� ������ �÷��� UNIQUE �Ӽ��̾�� �����ϸ�(���谡 1:1) �׷��� ������ ORA-01779 ������ �߻��Ѵ�.

     -------------------------------------------------------
     -- ����
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

      INSERT INTO tb_a VALUES(1,'����1-1', '����1-2','����1-1', '����1-2');
      INSERT INTO tb_a VALUES(2,'����2-1', '����2-2','����2-1', '����2-2');
      INSERT INTO tb_a VALUES(3,'����3-1', '����3-2','����3-1', '����3-2');
      INSERT INTO tb_a VALUES(4,'����4-1', '����4-2','����4-1', '����4-2');
      INSERT INTO tb_a VALUES(5,'����5-1', '����5-2','����5-1', '����5-2');

      INSERT INTO tb_b VALUES(1,'����1-1', '����1-2');
      INSERT INTO tb_b VALUES(3,'����3-1', '����3-2');
      INSERT INTO tb_b VALUES(5,'����5-1', '����5-2');
      COMMIT;

     -------------------------------------------------------
     --


 �� subquery
   �� WITH
     -------------------------------------------------------
     --


   �� ���� �� ���� ����
     -------------------------------------------------------
     --


   �� ���� �� ���� ����
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


   �� ��ȣ ���� ���� ����(correlated subquery, ��� ���� ������)
     -------------------------------------------------------
     --

