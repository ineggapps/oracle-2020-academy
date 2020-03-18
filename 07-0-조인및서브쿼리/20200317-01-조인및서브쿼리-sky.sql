select * from tab;

--�ǽ��� �ʿ��� ���̺�
--BCLASS: �з� ���̺�(�з��ڵ�P, �з���, �����з��ڵ�R)
--PUB: ���ǻ�(���ǻ��ȣP, ���ǻ��, ��ȭ��ȣ)
--BOOK: ����(�����ڵ�P, ������, ����, �з��ڵ�R, ���ǻ��ȣR)
--AUTHOR: ����(���ڹ�ȣP, �����ڵ�R,���ڸ�)
--CUS: ��(����ȣP, ����, ��ȭ��ȣ)
--MEMBER:ȸ��(����ȣP, ȸ�����̵�U, ȸ���н�����, �̸���) --���� �ݵ�� ȸ���� �ƴ� �� ����.
--SALE: �Ǹ� (�ǸŹ�ȣP, �Ǹ�����, ����ȣR)
--DSALE: �Ǹ� ��(�ǸŻ󼼹�ȣP, �ǸŹ�ȣR, �����ڵ�R, �Ǹż���) -- �����ڸ� �ǸŽ��� ����?

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
		  -- ���� : ������ �̸��� �÷����� �����̺� �����ϸ�, ��ȣ���� �߻�. ORA-00904
		  --SELECT���� empNo�� � ���̺��� ���� �����ϴ����� emp.empnoó�� ����ؾ� ��.
          
		SELECT emp.empNo, name, com, excel, word
		FROM emp, emp_score
		WHERE emp.empNo = emp_score.empNo;
		  
		SELECT e.empNo, name, com, excel, word
		FROM emp e, emp_score s --���̺� ��Ī�� ����
		WHERE e.empNo = s.empNo;

		SELECT e.empNo, name, com, excel, word
		FROM emp e 
		JOIN emp_score s ON e.empNo = s.empNo; --�����ϴ� ���̺��� ���� ��� 
		
        --����1)
        -- �Ǹ���Ȳ : å�ڵ�(bCode), å�̸�(bName), å����(bPrice), ���ǻ��ȣ(pNum),
                    ���ǻ��̸�(pName), �Ǹ�����(sDate), �ǸŰ���ȣ(cNum),
                    �ǸŰ��̸�(cName), �Ǹż���(qty), �ݾ�(bPrice * qty)

        -------------------------------------------------------
        --����
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
        --------------
        sale: sNum, sDate, cNum -- cNum ����ȣ: ���� �� ������ ����
        dsale: dNum, sNum, bCode, qty --sNum�� �̿��Ͽ� sale�� dSale�� ���踦 ���� �� �ִ�.
        --------------
        cus: cNum, cName, cTel
        ----����
        --�⺻ 5�� �̻��� ���̺��� �����Ѵ�. (�ǹ����� �������� 30~40���� ���̺��� ����)
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty �ݾ�
        FROM book b, pub p, sale s, dsale d, cus c
        WHERE     b.pNum=p.pNum 
                AND b.bCode=d.bCode
                AND d.sNum = s.sNum 
                AND s.cNum=c.cNum; --AND������ ��ӵǸ� ����������.                      
                
        -- ���� 2
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷��� ....
           FROM ���̺��1
           [ INNER ] JOIN ���̺��2 ON ���̺��1.�÷��� = ���̺��2.�÷���;

        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty �ݾ�
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum;

        --�Ǹ� ���� �� ���� �͸�
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty �ݾ�
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY');
        
        -- ���� 3: SELECT������ ������ ������� ����
       SELECT �÷���, �÷���
       FROM ���̺��1
       JOIN ���̺��2 USING (�÷���1)
       JOIN ���̺��3 USING (�÷���2);
-------------------------------------------------

        --��, �÷����� ���� ���ƾ� �Ѵ�. �׷��Ƿ� �� ������� ����
        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty �ݾ�
        FROM book b
        JOIN pub p USING(pNum) 
        JOIN dsale d USING(bCode)
        JOIN sale s USING (sNum)
        JOIN cus c USING (cNum);

-----------------------------------------------------
    --����1) �Ǹŵ� å �ڵ�(bCode), å �̸�(bName), �Ǹ� �Ǽ��� ��(qty ��)
    --����: å �ڵ� �������� ����
    -- �ʿ��� �͵�
    --book(bCode, bName)�� dsale(bCode, qty)
        SELECT b.bCode, bName , SUM(qty) �ǸűǼ�
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        ORDER BY bCode;
        
    --����2) �Ǹŵ� å �ڵ�(bCode), å �̸�(bName), �Ǹ� �ݾ��� ��(qty ��)
    --����: å �ڵ� �������� ����
        SELECT b.bCode, bName , TO_CHAR(SUM(qty)* bPrice,'L999,999,999') �ǸŽ���
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName, bPrice)
        ORDER BY bCode;
--        ORDER BY �ǸŽ��� desc;        
        
    --�˻�
        select * from book where bCode='0014';--15000��
        select * from dsale where bCode='0014';--35��
    --�� 525,000��
    
    --����3) �Ǹŵ� å �̸��� å �ڵ常
    SELECT DISTINCT b.bCode, bName
    FROM book b
    JOIN dsale d ON b.bCode = d.bCode
    ORDER BY b.bCode;

    --����4) �Ǹŵ� å �� �Ǹ� �Ǽ��� ���� ���� ū å �ڵ�(bCode), å �̸�(bName), qty �ǸűǼ��� ��
    
        
        --#���1. RANK() OVER() �Լ��� �̿��Ͽ� �������� ����ϱ�
        --1�ܰ� �Ǹ� �Ǽ��� ���� ���� ���ϱ�
        SELECT b.bCode, bName, sum(qty) �ǸűǼ�, RANK() OVER(ORDER BY SUM(qty) DESC) ����
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        ORDER BY ����;
        
        SELECT bcode, bname
        FROM (
            SELECT b.bCode, bName, sum(qty) �ǸűǼ�, RANK() OVER(ORDER BY SUM(qty) DESC) ����
            FROM book b
            JOIN dsale d ON b.bCode = d.bCode
            GROUP BY (b.bCode, bName)
            ORDER BY ����
        ) WHERE ����=1;
        
        --#���2. RANK�� ������ �ʰ� Ǯ�� (�̰� ���� �;���. HAVING���� ���� �ǰڱ���!)
        SELECT b.bCode, bName
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        GROUP BY (b.bCode, bName)
        HAVING SUM(qty) = (
            SELECT MAX(SUM(qty)) --�Ǹ� �Ǽ��� ���� ���� ū ����
            FROM book b1
            JOIN dsale d1 ON b1.bCode = d1.bCode
            GROUP BY (b1.bCode, bName)
        );
        
        --�۳� �Ǹ� ����
        SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty �ݾ�
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')-1;
--        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE - INTERVAL '1' YEAR,'YYYY);
        
        --����5) ������ �Ǹ� �ݾ��� ��: ����, �Ǹ� ��(������ �Ǹ��� ��)
        --���� ������ ��������
        --�ʿ��� ����: �� 3���� ���̺��� �����ָ� �ȴ�.
        -- book(bCode, bPrice)
        -- dsale(bCode, qty, sNum)
        -- sale(sdate, sNum)
        
        --0�ܰ�: ������ ���� �ۼ�
        --��¥�� å �Ǹ� ���� 
        SELECT b.bCode, bPrice, sDate, qty
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum;
        
        --������ å �Ǹ� ���� 
        SELECT TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �ݾ�
        FROM book b
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY TO_CHAR(sdate,'YYYY')
        ORDER BY ����;
        
        --1�ܰ�: å�ڵ庰 �Ǹ� �ݾ��� ��
        SELECT b.bCode, SUM(qty*bPrice)
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.sNum = s.sNum
        GROUP BY b.bCode, bPrice;

        --2�ܰ�: �������� �з��� �ؾ���..??
        SELECT ����, TO_CHAR(SUM(�Ǹűݾ�),'L999,999,999') �Ǹű�
        FROM (
            --������ å�ڵ庰 �Ǹ� �ݾ��� ��
            SELECT TO_CHAR(sdate,'YYYY') ����, b.bCode, SUM(bprice*qty) �Ǹűݾ�
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.sNum = s.sNum
            GROUP BY TO_CHAR(sdate,'YYYY'), b.bCode, bPrice
        )
        GROUP BY ����
        ORDER BY ���� DESC;
        
        --������ ���: �̰� ������, å��
        SELECT TO_CHAR(sDate, 'YYYY') �⵵, SUM(bPrice*qty) �ݾ�
		FROM book b
		JOIN dsale d ON b.bCode=d.bCode
		JOIN sale s ON d.sNum=s.sNum
		GROUP BY TO_CHAR(sDate, 'YYYY')
		ORDER BY �⵵ desc;

        --����6)
        --����ȣ(cnum), ����(cname), ����, �Ǹűݾ��� ��: 
        --����ȣ ��������, ���� ��������
        --�ʿ��� ����
        --book(bcode, bprice)
        --cus(cnum, cname)
        --dsale(bcode, snum)
        --sale(snum, sdate)
        
        SELECT s.cnum ����ȣ, cname �����, TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �Ǹűݾ�
        FROM book b
        --JOIN���� ������ �����Ƿ� �����Ѵ�.
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
        JOIN cus c ON s.cnum = c.cnum
        GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
        ORDER BY ����ȣ, ����;		
        
        -------------------------------------------------------
		-- ����7) ����ȣ(cNum), ����(cName) : �۳� �����Ǹűݾ��� ���� ���� �����
        SELECT ����ȣ, ���� FROM (
        --�۳� ���� �����Ǹűݾ�
            SELECT s.cnum ����ȣ, cname ����, TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �Ǹűݾ�, RANK() OVER(ORDER BY sum(bprice*qty) DESC) ����
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.snum = s.snum
            JOIN cus c ON s.cnum = c.cnum
            WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')-1
            GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
        ) WHERE ���� = 1;
        
        -------------------------------------------------------
		-- ����8) ����ȣ(cNum), ����(cName), ȸ�� ���̵�(userId) : ȸ���� ���� �����Ǹűݾ��� ���� ���� �����
        
        --#���1. ���������� ȸ�����̵� �����ϴ� ���
        SELECT result.*, (SELECT userid FROM member WHERE cnum=result.����ȣ) "ȸ�� ���̵�"
        FROM (
            SELECT ����ȣ, ���� FROM (
            --�۳� ���� �����Ǹűݾ�
                SELECT s.cnum ����ȣ, cname ����, TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �Ǹűݾ�, RANK() OVER(ORDER BY sum(bprice*qty) DESC) ����
                FROM book b
                JOIN dsale d ON b.bcode = d.bcode
                JOIN sale s ON d.snum = s.snum
                JOIN cus c ON s.cnum = c.cnum
                WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
                GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY')
            ) WHERE ���� = 1
        ) result;
        
        --#���2. �������� ���� JOIN������ �ذ��ϴ� ���
        --��, 1���� �����ϱ� ���� ���������� �ʿ��ϴ�
        SELECT ����ȣ, ����, "ȸ�� ���̵�" FROM (
            --�۳� ���� �����Ǹűݾ�
                SELECT s.cnum ����ȣ, cname ����, userid "ȸ�� ���̵�", TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �Ǹűݾ�, RANK() OVER(ORDER BY sum(bprice*qty) DESC) ����
                FROM book b
                JOIN dsale d ON b.bcode = d.bcode
                JOIN sale s ON d.snum = s.snum
                JOIN cus c ON s.cnum = c.cnum
                JOIN member m ON c.cnum = m.cnum
                WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
                GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY'), userid
        ) WHERE ���� = 1;
        
        --#���2-1. WITH�������� ��ȯ�Ͽ� ����� ����
        WITH ��� AS (
            SELECT s.cnum ����ȣ, cname ����, userid "ȸ�� ���̵�", TO_CHAR(sdate,'YYYY') ����, sum(bprice*qty) �Ǹűݾ�, RANK() OVER(ORDER BY sum(bprice*qty) DESC) ����
            FROM book b
            JOIN dsale d ON b.bcode = d.bcode
            JOIN sale s ON d.snum = s.snum
            JOIN cus c ON s.cnum = c.cnum
            JOIN member m ON c.cnum = m.cnum
            WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
            GROUP BY (s.cnum, cname), TO_CHAR(sdate,'YYYY'), userid
        )
        SELECT ����ȣ, ����, "ȸ�� ���̵�" 
        FROM ��� 
        WHERE ����=1;
        
        --#���2-1. (����) WITH����
        
        -------------------------------------------------------
        -- ����9) å�ڵ�(bCode), å�̸�(bName), �ǸűǼ��� : �ǸűǼ����� 80���̻��� å�� ���        
        SELECT b.bcode, bname, sum(qty) "�ǸűǼ� ��"
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        GROUP BY b.bcode, bname
        HAVING sum(qty) >= 80;  

     2) NATURAL JOIN
        -- ����
           SELECT �÷���, �÷��� ....
           FROM ���̺��1
           NATURAL JOIN  ���̺��2;

        SELECT bCode, bName, bPrice, pNum, pName, sDate, cNum, cName, qty, bPrice*qty �ݾ�
        FROM book
        NATURAL JOIN pub
        NATURAL JOIN dsale
        NATURAL JOIN sale 
        NATURAL JOIN cus;


     3) CROSS JOIN
     --��ȣ ������ ���ο� ���Ե� ���̺��� īƼ�� ��(Cartisian Product)�� ��ȯ�Ѵ�.
     --5�� X 5�� = 25��
     --�м����� �뵵�� ����� ������ �ǹ����� ���� ���� ����.
     
     SELECT p.pnum, pname, bcode, bname
     from pub p
     CROSS JOIN book b;


     4) SELF JOIN
        -------------------------------------------------------
        select * from bclass;
        
        --���� �÷��� ��з�, ���� �÷��� �Һз��� ������ �ȴ�.
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
        -- ����
            SELECT [���̺��1.]�÷���, [���̺��2.]�÷��� ....
            FROM ���̺��1, ���̺��2..
            WHERE (non-equi-join ����);

        --NON EQUI������ ����    
        --���ڰ� 2�� �̻��� "����" ���
        SELECT a1.bCode, a1.aName, a2.aName
        FROM author a1
        JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        ORDER BY a1.bCode;
        
        --���ڰ� 2�� �̻��� å�� ���븸 ���
        SELECT bCode, bName
        FROM book b
        WHERE bCode IN (
            SELECT a1.bCode
            FROM author a1
            JOIN author a2 ON a1.bCode=a2.bCode AND a1.aName > a2.aName
        );
        
        --EQUI JOIN
        SELECT s.snum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum = d.sNum;
        
        --NON-EQUI JOIN
        --'='�� �ƴ� �񱳿�����
        SELECT s.snum, bCode, cNum, sDate, qty
        FROM sale s
        JOIN dsale d ON s.sNum > 10;
        

        -------------------------------------------------------
        --


   �� OUTER JOIN
     1) LEFT OUTER JOIN
       -- ����1
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
           FROM ���̺��1, ���̺��2
           WHERE ���̺��1.�÷���=���̺��2.�÷���(+);

        --book(bcode, bname)
        --dsale(bcode ,snum, qty)
        
        --EQUI JOIN
        SELECT b.bcode, bname, qty
        FROM book b, dsale d
        WHERE b.bcode = d.bcode
        ORDER BY b.bcode;
        
        --LEFT OUTER JOIN
        SELECT b.bcode, bname, qty
        FROM book b, dsale d
        WHERE b.bcode = d.bcode(+) --�Ǹŵ��� ���� å�鵵 null�� �ٿ� ���
        ORDER BY b.bcode;
    
        
       -- ����2
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1
          LEFT OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;

        --LEFT OUTER JOIN
        SELECT b.bcode, bname, qty
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bcode = d.bcode
        ORDER BY b.bcode;
    
        --����1)
        --bcode, bname, snum, sdate, qty ���
        --��, bocde�� bname�� �� �ǵ� �ǸŰ� ���� ���� å�� ����Ѵ�.
        
        --LEFT�� RIGHT ���⼺�� ����ִ� JOIN���̹Ƿ� ���̺��� ������ �߿��ϴ�.
        --���ʿ��� �θ� ���̺�, �����ʿ��� �ڽ� ���̺��� �־�� �Ѵ�.
        --������ �ڹٲ� ��쿡�� �ᱣ���� �޶��� �� ������ �����Ѵ�.
        SELECT b.bcode, bname, d.snum, sdate, qty
        FROM book b
        LEFT OUTER JOIN dsale d ON b.bcode = d.bcode
        LEFT OUTER JOIN sale s ON d.snum = s.snum
        ORDER BY snum nulls first, b.bcode;
        
        --����2) �Ǹŵ� å�ڵ�, å�̸��� ���
        
        
        --JOIN����
        SELECT bcode, bname
        FROM book
        WHERE bcode IN (
            SELECT DISTINCT bcode FROM dsale
        )
        ORDER BY bcode;
        
        --�Ǹŵ� ���
        SELECT b.bcode, bname, d.bcode, d.snum
        FROM book b
        LEFT OUTER JOIN dsale d ON d.bcode = b.bcode
--        WHERE d.bCode IS NOT NULL
        WHERE dnum IS NOT NULL
        ORDER BY b.bcode;
        
        ---�� �ǵ� �Ǹŵ��� ���� ���
        SELECT b.bcode, bname, d.bcode, d.snum
        FROM book b
        LEFT OUTER JOIN dsale d ON d.bcode = b.bcode
        WHERE d.bCode IS NULL --�Ǹŵ��� ���� å�� ��ȸ�ϴ� ���
        ORDER BY b.bcode;
        
        --����3) ���� �Ǹŵ� å �ڵ�, å �̸�
    
        --JOIN ������� �ʰ�
        SELECT bcode, bname
        FROM book
        WHERE bcode IN (
            SELECT DISTINCT bcode
            FROM dsale d--, sale s
--            WHERE d.snum = s.snum
            JOIN sale s ON d.snum = s.snum
            WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
        )
        ORDER BY BCODE;
    
        --JOIN ���(�Ǹŵ� �Ŵϱ� ���̺��� �ٿ��� null���� ������)
        SELECT DISTINCT b.bcode, bname
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
        WHERE TO_CHAR(sdate,'YYYY')=TO_CHAR(SYSDATE,'YYYY')
        ORDER BY BCODE;
    
        --


     2) RIGHT OUTER JOIN
       -- ����1
           SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
           FROM ���̺��1, ���̺��2
           WHERE ���̺��1.�÷���(+)=���̺��2.�÷���;

        --EQUI JOIN
        SELECT b.bcode, bname, qty
        FROM book b, dsale d
        WHERE b.bcode = d.bcode
        ORDER BY b.bcode;
        
        --RIGHT OUTER JOIN
        SELECT b.bcode, bname, qty
        FROM dsale d, book b
        WHERE d.bcode(+) = b.bcode --�Ǹŵ��� ���� å�鵵 null�� �ٿ� ���
        ORDER BY b.bcode;

        --LEFT OUTER JOIN
        SELECT b.bcode, bname, qty
        FROM dsale d
        RIGHT OUTER JOIN book b ON d.bcode = b.bcode
        ORDER BY b.bcode;

       -- ����2
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1
          RIGHT OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;

     3) FULL OUTER JOIN
       -- ����
          SELECT [���̺��1.]�÷���, [���̺��2.]�÷���
          FROM ���̺��1 FULL OUTER JOIN ���̺��2 ON ���̺��1.�÷���=���̺��2.�÷���;


        --�Ǹ� ������ �������� ȸ�������� ��ȸ 
        --���� �������� ȸ���� �ƴ� ��� null�� ǥ�õȴ�.
        SELECT snum, sdate, s.cnum, m.cnum, userid
        FROM sale s
        LEFT OUTER JOIN member m ON s.cnum = m.cnum
        ORDER BY snum;
        
        
        --ȸ�� ����� �������� �Ǹ������� ��ȸ
        --���� ȸ�������� �Ǹ� �̷��� ���� ��� NULL�� ǥ�õȴ�
        SELECT snum, sdate, s.cnum, m.cnum, userid
        FROM sale s
        RIGHT OUTER JOIN member m ON s.cnum = m.cnum
        ORDER BY snum;
        
        --�Ǹ� ����� ȸ�� ����� �������� ���� ȸ�� ����, �Ǹ� ������ ��ȸ
        --���� ȸ�� ������ �Ǹ� ������ ���� ��� NULL�� ǥ�õȴ�.
        --FROM�� ������ JOIN�� ����� ������ ���� ����� �޶��� �� �ִ�.
        SELECT snum, sdate, s.cnum, m.cnum, cname, userid
        FROM sale s
        FULL OUTER JOIN member m ON s.cnum = m.cnum
        FULL OUTER JOIN cus c ON c.cnum = s.cnum
        ORDER BY cname nulls first, snum;
        
              
        --����1) ��ȸ�� �Ǹ� ��Ȳ
        --cnum, cname, bCode, bName, sDate, bPrice, qty
        --2, 5, 9, 12 ,14�� ��ȸ����!!!
--        SELECT userid, c.cnum, cname, d.bcode , bname, sdate, bprice, qty
--        FROM dsale d
--        JOIN book b ON d.bcode = b.bcode
--        JOIN sale s ON d.snum = s.snum
--        JOIN cus c ON s.cnum = c.cnum
--        LEFT OUTER JOIN member m ON c.cnum = m.cnum
--        AND m.cnum IS NULL
--        ORDER BY c.cnum;
        
        --����
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
    --------------
        sale: sNum, sDate, cNum -- cNum ����ȣ: ���� �� ������ ����
        dsale: dNum, sNum, bCode, qty --sNum�� �̿��Ͽ� sale�� dSale�� ���踦 ���� �� �ִ�.
    --------------
        cus: cNum, cName, cTel
        member:cnum, userid, userPwd, userEmail
        
        SELECT c.cnum, cname, d.bcode, bname, sdate, bprice, qty
        FROM cus c
        LEFT OUTER JOIN member m ON c.cnum = m.cnum
        JOIN sale s ON c.cnum = s.cnum
        JOIN dsale d ON s.snum = d.snum
        JOIN book b ON d.bcode = b.bcode
        WHERE m.cnum IS NULL -- �Ǵ� userid IS NULL
        ORDER BY c.cnum;
        
        
        select * from cus;
        
        --����2) ���� ���� �Ǹ� �ݾ�
        --cNum, cName, bPrice*qty ��
        --��, �� �� å�� �� �ǵ� �������� ���� ���� ���
        --TIP: JAVA������ null���� int���� 0������ ���� ���Ѵ�. ���� nvl�Լ��� �̿��Ͽ� null���� �ٸ� ������ ġȯ���־�� �Ѵ�.
        SELECT c.cnum, cname, TO_CHAR(nvl(sum(bprice*qty),0),'L999,999,999') ��
        --�Ǹ��̷��� ���� 11���� 15���� �Ǹ��̷��� �����ϱ� snum�� null�� �³� �˻�
        FROM dsale d
        JOIN book b ON d.bcode = b.bcode
        JOIN sale s ON d.snum = s.snum
        RIGHT OUTER JOIN cus c ON s.cnum = c.cnum
        GROUP BY c.cnum, cname
        ORDER BY c.cnum;
        
        --Ȯ�ο� SQL) ������ �� ���
        SELECT cnum from cus; --1~15��
        SELECT DISTINCT cnum --11, 15�� �����̷� ����
        FROM dsale d
        JOIN sale s ON d.snum = s.snum
        ORDER BY cnum;
        
        --����3) ���� ���� �Ǹ� �ݾ� �� ����
        --cNum, cName, bPrice*qty ��, ��ü�Ǹűݾ׿����Ѻ���
        --�Ǹűݾ��� ���� �� ���� ǥ������ �ʾƵ� ��.
        SELECT c.cnum, cname, NVL(sum(bprice*qty),0) ��, 
                    NVL(round(sum(bprice*qty)/
                        (SELECT sum(bprice*qty) price 
                        FROM dsale d
                        JOIN book b ON d.bcode = b.bcode)*100,1),0)||'%' �Ǹź���,
                    ROUND(RATIO_TO_REPORT(SUM(bPrice * qty)) OVER() * 100, 1) || '%' �Ǹź���2 --��
        FROM cus c
        JOIN sale s ON c.cnum = s.cnum
        JOIN dsale d ON s.snum = d.snum
        JOIN book b ON d.bcode = b.bcode 
        GROUP BY c.cnum, cname
        ORDER BY c.cnum;

        --����4) ������ �� ���� �Ǹ� �ݾ��� ���� ���� ������
        --(�Ǹų⵵), cNum, cName, bPrice*qty ��
        --������ ��������
        --�������� 1�� ���̸��� ����ϸ� ��
        
        SELECT ����, ����ȣ, ����, TO_CHAR(��,'L999,999,999') �ǸŽ��� FROM (
            SELECT TO_CHAR(sdate,'YYYY') ����, c.cnum ����ȣ, cname ����, 
                       NVL(sum(bprice*qty),0) ��, RANK() OVER(PARTITION BY TO_CHAR(sdate,'YYYY') ORDER BY sum(bprice*qty) DESC) ����
            FROM cus c
            JOIN sale s ON c.cnum = s.cnum --������ �Ǹ� ������ ���� ����� �������� ����� �ƴϹǷ� null���� ������ �ʿ䰡 ����. ���� OUTER JOIN�� �ƴ� INNER JOIN�� ����Ѵ�.
            JOIN dsale d ON s.snum = d.snum
            JOIN book b ON d.bcode = b.bcode 
            GROUP BY TO_CHAR(sdate,'YYYY'), c.cnum, cname
--            ORDER BY ����, c.cnum
        ) 
        WHERE ����=1
        ORDER BY ����; --�ǸŽ����� ������ ������ NULL�� ���´�.
        
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