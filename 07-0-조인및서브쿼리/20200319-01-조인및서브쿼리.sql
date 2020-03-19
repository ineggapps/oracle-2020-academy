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

    UPDATE (
        SELECT a.new_addr1, a.new_addr2, b.n_addr1, b.n_addr2
        FROM tb_a a, tb_b b
        WHERE a.num = b.num
    )SET new_addr1 = n_addr1, new_addr2 = n_addr2;
    
    select * from tb_a;
    COMMIT;


�� subquery (in line view)
   �� WITH
     -------------------------------------------------------
     --oracle 9i���� ����...
     WITH tmp AS (
      SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
    )
    SELECT cNum, cName, SUM(amt)
    FROM tmp
    GROUP BY cNum, cName;


   �� ���� �� ���� ����
     -------------------------------------------------------
    
    --ERROR: �ᱣ ���� ���� ���� �޴� ��쿡�� �Ұ���
    SELECT empno, name, sal FROM emp
    WHERE sal < (SELECT sal FROM emp WHERE city='����');
    --���� ����� �������� ���ް��� ����� ���� ���� �� �ִ�. (ORA-01427: 2�� �̻��� ���� ���ϵ�)
    
    --�������� �ᱣ���� �޴� ��쿡�� �����ϴ�.
    SELECT empno, name, sal FROM emp
    WHERE sal< (SELECT AVG(sal) from emp);
    
    --ERROR: �����÷��̾�� �Ѵ� ORA-00913 ���� ���� �ʹ� �����ϴ�.
    SELECT empno, name, sal FROM emp
    WHERE sal < (SELECT AVG(sal), SUM(sal) from emp);   

   �� ���� �� ���� ����
      - IN
       -------------------------------------------------------
       
       --�Ǹŵ� ���� ��ȸ�ϱ�
       SELECT bcode, bname FROM book
       WHERE bcode IN (SELECT DISTINCT bcode FROM dsale);
       
        --�Ǹŵ��� ���� ���� ��ȸ
       SELECT bcode, bname FROM book
       WHERE bcode NOT IN (SELECT DISTINCT bcode FROM dsale);


      - ANY(SOME)  --OR�� ������ ����
       -------------------------------------------------------
       SELECT bcode, bname FROM book
       WHERE bcode = ANY (SELECT DISTINCT bcode FROM dsale);

       SELECT bcode, bname FROM book
       WHERE bcode = NOT ANY (SELECT DISTINCT bcode FROM dsale);

        SELECT empno, name, sal FROM emp
        WHERE sal > ANY(2000000, 2500000, 3000000); --����� sal�� 200�� ������ ū �����鸸 ���
        
      - ALL --AND�� ������ ����
       -------------------------------------------------------
       
       SELECT empno, name, sal FROM emp
       WHERE sal> ALL(2000000, 2500000, 3000000); --����� sal�� 300�� ������ ū �����鸸 ���

        ---������ �ִ񰪺��� ū ���
        SELECT empno, name, sal FROM emp
        WHERE sal > (SELECT MAX(sal) FROM emp WHERE city='��õ');

        SELECT empno, name, sal FROM emp
        WHERE sal > ALL (SELECT sal FROM emp WHERE city='��õ');

      - EXISTS --�ϳ��� ������ ��, �ƴϸ� ���� (�������� ����)
       -------------------------------------------------------
       --qty>=10 ������ �����ϴ� ���� ������ ��� ���
       SELECT bname FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty>=10); --����� ���� ��� 27��
       
       SELECT bname FROM book; --�� 27��
       
       --�ڿ� �ִ� ���� �����Ͱ� �� ���� ������ �� ������ ����
       SELECT bname FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty>=1000);


   �� ��ȣ ���� ���� ����(correlated subquery, ��� ���� ������)��
    --�������� ����. ���� �ɸ�.
    --------------------------------------------------------------------
    --�Ϻ� ������ ���ϴ� �Լ��� ����� �������� �ʴ� ���������� ������ ���� �����ϱ⵵ �Ͽ���.
    -------------------------------------------------------
     SELECT name, sal,
        (SELECT COUNT(e2.sal) +1 FROM emp e2
        WHERE e2.sal>e1.sal) ���� --������ 60�� ���� X 60�� = 3600��
    FROM emp e1;
    
    --����1)
    CREATE TABLE gtb(
        grade VARCHAR2(10) PRIMARY KEY,
        score NUMBER(3)
    );
    INSERT INTO gtb(grade, score) VALUES('A',90);
    INSERT INTO gtb(grade, score) VALUES('B',80);
    INSERT INTO gtb(grade, score) VALUES('C',70);
    INSERT INTO gtb(grade, score) VALUES('D',60);
    INSERT INTO gtb(grade, score) VALUES('E',0);
    COMMIT;
    
    CREATE TABLE stb(
        hak VARCHAR2(30) PRIMARY KEY,
        score NUMBER NOT NULL
    );
    INSERT INTO stb(hak, score) VALUES('1', 75);
    INSERT INTO stb(hak, score) VALUES('2', 90);
    INSERT INTO stb(hak, score) VALUES('3', 75);
    INSERT INTO stb(hak, score) VALUES('4', 80);
    INSERT INTO stb(hak, score) VALUES('5', 55);
    COMMIT;
    
    --hak, stb.score, grade
    SELECT hak, score, (SELECT MAX(score) FROM gtb WHERE score <= stb.score) gscore FROM stb;

    --1�ܰ�. ���� ������ �������(stb) => ������ �����븦 ã�´�(gtb)
    --2�ܰ�. ������ �����뿡 �˸��� ����� ã�´�. (JOIN �̿�)
     SELECT hak, s1.score, grade FROM (
        -- ��ȣ ���� ���� ����
        SELECT hak, score, 
            --�ش�Ǵ� ���������븦 gtb���̺��� �����´�.
            (SELECT MAX(score) FROM gtb WHERE score <= stb.score) gscore 
        FROM stb
     ) s1
     JOIN gtb s2 ON s1.gscore = s2.score;