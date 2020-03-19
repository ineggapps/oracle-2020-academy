--�� ��� ����
-- �� ������ ����(Hierarchical Query)
--   �� ������ ����
     -------------------------------------------------------
    SELECT * FROM soft;

    --CONNECT BY: ������ ���ǿ����� ����� �����ϴ�.
        --CONNECT BY PRIOR: �� ���� ��� ������� ����Ŭ���� �˷��ִ� ����
        --PRIOR�� ���� ��� �ٸ� ���� �����ϴ� ������
        --LEVEL: �˻��� ����� ���Ͽ� �������� ���� ��ȣ ���
            --��Ʈ 1, ������ ������ 1�� �����ȴ�.
        --�������� ������ ����ϱ�
        --�����������ϱ������������
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
        --START WITH num=1: ��� ���� ��ġ(��)
        --PRIOR num = parent: ������ ���� ���� (���� ��� ���� ���� �̾��شٰ� ����)
            --��(num)�� �θ�(parent)�� ����ϴ� ��(���� ���� �˻�)
            --parent �÷�: ���� ������ ���� �÷�
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
        
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY parent = PRIOR num; --PRIORŰ���带 ���ʿ� �� ���� ����.
        --parent�÷��� ������ ��(�����ϴ� ��)�� num�̴�. num�� parent���� �ռ���(PRIOR). 
        
        --�ֻ��� �ϳ��� ���
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY PRIOR parent = num;
        
        --�������� ������ ��� (���ڰ��翡�� ����ڰ� �������� ������ �ִ� ���ӻ���� ã�ƾ� �ϴ� ���)
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=15
        CONNECT BY PRIOR parent = num;
        
        --PRIOR�� �ڿ� ����
        SELECT num, LPAD('-',(LEVEL-1)*4)||subject subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=15
        CONNECT BY num =PRIOR parent;
        
        -- �߸��� ���� (���� ������ ������, ���� �������� ������ �ʿ��ϴ�)
        SELECT num, subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY PRIOR num = parent;
--        ORDER BY subject;--���� ������ �ı��ǹǷ� CONNECT���� �Բ� ORDER�� ����� �� ����

        --���� (���� �������� ����)
        SELECT num, subject, LEVEL, parent
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1
        CONNECT BY PRIOR num = parent
--        ORDER BY subject;--���� ������ �ı��ǹǷ� CONNECT���� �Բ� ORDER�� ����� �� ����
        ORDER SIBLINGS BY subject; --���� parent�� ��峢�� ������ �Ǿ� �ִ� ���� Ȯ���� �� �ִ�.
        
        --�����ͺ��̽� �Ҽ� �ڽ� ���
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=3
        CONNECT BY PRIOR num = parent;
        
        -- WHERE���� �������� �򰡵Ǹ� num�� 3�� �͸� ��µ��� �ʴ´�.
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        WHERE num !=3 
        START WITH num=1 --START WITH�� CONNECT���� WHERE������ ���� ����ȴ�.
        CONNECT BY PRIOR num = parent;

        -- DB�� DB ������ ������� ����
        SELECT num, subject, LEVEL, parent FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1 --START WITH�� CONNECT���� WHERE������ ���� ����ȴ�.
        CONNECT BY PRIOR num = parent AND num != 3; --3��(�����ͺ��̽�) �׸� �Ҽӵ� ��ҵ� ��� ����

        -- 1���� ���� ���´�. (dual���̺��� ���� 1���̱� �����̴�.)
        SELECT rownum FROM dual WHERE rownum <=20; 
        
        --20���� ���� ���´�. CONNECT BY������ LEVEL ����� �����ϴ�.
        --CONNECT BY�� parent ��Ҹ� ��� ã�� ����.
        SELECT LEVEL v FROM dual 
        CONNECT BY LEVEL<=20;

        SELECT TO_DATE('2020-03-19')+LEVEL-1 FROM dual 
        CONNECT BY LEVEL<=7;

        --
        SELECT num, subject, LEVEL, parent, CONNECT_BY_ROOT subject FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        --CONNECT_BY_ROOT: �ֻ��� ����� �� ��ȯ
        START WITH num=1 --START WITH�� CONNECT���� WHERE������ ���� ����ȴ�.
        CONNECT BY PRIOR num = parent;
        
        --�����ͺ��̽����� �����ϹǷ� connect_by_root�� �����ͺ��̽��� ��ȯ
        SELECT num, subject, LEVEL, parent, CONNECT_BY_ROOT subject FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        --CONNECT_BY_ROOT: �ֻ��� ����� �� ��ȯ
        START WITH num=3 --START WITH�� CONNECT���� WHERE������ ���� ����ȴ�.
        CONNECT BY PRIOR num = parent;

        --��Ʈ���� �ڽű��� �����Ͽ� �����ش�
        SELECT num, subject, LEVEL, parent, 
        SYS_CONNECT_BY_PATH(subject,' > '), subject --����Ʈ���� > ���α׷��� > �ڹ� ������ ���� 
        FROM soft -- LEVEL�� CONNECT BY���� �ݵ�� �Բ� ���δ�.
        START WITH num=1 --START WITH�� CONNECT���� WHERE������ ���� ����ȴ�.
        CONNECT BY PRIOR num = parent;
    
        --
        SELECT ROWNUM rnum, name FROM emp WHERE city='����';
        
        SELECT SYS_CONNECT_BY_PATH(name,',') name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='����'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;
        
        SELECT MAX(SYS_CONNECT_BY_PATH(name,',')) name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='����'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;
        
        --���� ������� �� ������ ��
        --EX) ���� ���� ���� �ϳ��� ���ļ� �ᱣ���� �����ϰ� ���� �� ����Ѵ�.
        --���� JAVA�ܿ��� ó���ϰ� ���� ���� �� ���������ε� �󸶵��� ���� ��ĥ �� �ִ�.
        SELECT SUBSTR(MAX(SYS_CONNECT_BY_PATH(name,',')),2) name FROM (
            SELECT ROWNUM rnum, name FROM emp WHERE city='����'
        ) START WITH rnum=1
        CONNECT BY PRIOR rnum=rnum-1;

-- �� PIVOT�� UNPIVOT
--   �� PIVOT �� (��=>���� ���·� �ٲپ� �����ִ� ��)
     -------------------------------------------------------
     -- ����
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
    --pivot �̱������� [?p?v?t]  ������  �߿�
    --1. (ȸ���ϴ� ��ü�� ������ ��� �ִ�) �߽���
    --2. (���� �߿���) �߽�
    --3. (���� �߽�����) ȸ���ϴ�; ȸ����Ű��
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
            '���ߺ�' AS "���ߺ�",
            '��ȹ��' AS "��ȹ��",
            '������' AS "������",
            '�λ��' AS "�λ��",
            '�����' AS "�����",
            '�ѹ���' AS "�ѹ���",
            'ȫ����' AS "ȫ����"
        )
    );
    
    SELECT * FROM (
        SELECT dept, city, pos
        FROM emp
        ORDER BY city, pos
    ) PIVOT (
        COUNT(*) FOR dept IN (
            '���ߺ�' AS "���ߺ�",
            '��ȹ��' AS "��ȹ��",
            '������' AS "������",
            '�λ��' AS "�λ��",
            '�����' AS "�����",
            '�ѹ���' AS "�ѹ���",
            'ȫ����' AS "ȫ����"
        )
    );    
    
    --���� �Ի� �ο��� ���ϱ�
    SELECT TO_CHAR(hiredate,'MM') ����, COUNT(*) �ο���
    FROM emp
    GROUP BY TO_CHAR(hiredate,'MM')
    ORDER BY ����;
    
    SELECT * FROM (
        SELECT TO_CHAR(hiredate,'MM') ����
        FROM emp
    ) PIVOT (
        COUNT(����) 
        FOR ���� IN (
            '01' AS "1��",
            '02' AS "2��",
            '03' AS "3��",
            '04' AS "4��",
            '05' AS "5��",
            '06' AS "6��",
            '07' AS "7��",
            '08' AS "8��",
            '09' AS "9��",
            '10' AS "10��",
            '11' AS "11��",
            '12' AS "12��"
        )
    );
    
    --�μ��� ������ �޿�(sal) �� ���ϱ�
    --POS, ���ߺ�, ȫ���� ...
    --����   X       X
    
    SELECT dept, pos, sum(sal) 
    FROM emp
    GROUP BY dept, pos;
    
    SELECT * FROM (
        SELECT dept, pos, sal
        FROM emp
    ) PIVOT(
        sum(sal) FOR dept IN (
            '���ߺ�' AS "���ߺ�",
            '��ȹ��' AS "��ȹ��",
            '������' AS "������",
            '�λ��' AS "�λ��",
            '�����' AS "�����",
            '�ѹ���' AS "�ѹ���",
            'ȫ����' AS "ȫ����"
        )
    );
    
    --������ ���� �Ǹ���Ȳ(bPrice *qty ��)
    --���� 1��.. ~ 12��
    
    SELECT TO_CHAR(sdate, 'YYYY') ����, TO_CHAR(sdate, 'MM') ��, sum(bPrice * qty) �Ǹűݾ�
    FROM book b
    JOIN dsale d ON b.bcode = d.bcode
    JOIN sale s ON d.snum = s.snum
    GROUP BY TO_CHAR(sdate, 'YYYY'), TO_CHAR(sdate, 'MM');
    
    SELECT * FROM (
        SELECT TO_CHAR(sdate, 'YYYY') ����, TO_CHAR(sdate, 'MM') ��, --bprice, qty, 
        bprice*qty amt
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
    ) PIVOT(
--        sum(bprice * qty) FOR �� IN(
        sum(amt) FOR �� IN(
        '01' AS "1��",
        '02' AS "2��",
        '03' AS "3��",
        '04' AS "4��",
        '05' AS "5��",
        '06' AS "6��",
        '07' AS "7��",
        '08' AS "8��",
        '09' AS "9��",
        '10' AS "10��",
        '11' AS "11��",
        '12' AS "12��"
        )
    ) ORDER BY ���� DESC;

    --NULL�� ����
    SELECT ����,    
     NVL("1��",0) "1��",
     NVL("2��",0) "2��",
     NVL("3��",0) "3��",
     NVL("4��",0) "4��",
     NVL("5��",0) "5��",
     NVL("6��",0) "6��",
     NVL("7��",0) "7��",
     NVL("8��",0) "8��",
     NVL("9��",0) "9��",
     NVL("10��",0) "10��",
     NVL("11��",0) "11��",
     NVL("12��",0) "12��"
    FROM (
        SELECT TO_CHAR(sdate, 'YYYY') ����, TO_CHAR(sdate, 'MM') ��, --bprice, qty, 
        bprice*qty amt
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
    ) PIVOT(
--        sum(bprice * qty) FOR �� IN(
        sum(amt) FOR �� IN(
        '01' AS "1��",
        '02' AS "2��",
        '03' AS "3��",
        '04' AS "4��",
        '05' AS "5��",
        '06' AS "6��",
        '07' AS "7��",
        '08' AS "8��",
        '09' AS "9��",
        '10' AS "10��",
        '11' AS "11��",
        '12' AS "12��"
        )
    ) ORDER BY ���� DESC;
    
     --����
        book: bCode, bName, bPrice, pNum
        pub: pNum, pName
    --------------
        sale: sNum, sDate, cNum -- cNum ����ȣ: ���� �� ������ ����
        dsale: dNum, sNum, bCode, qty --sNum�� �̿��Ͽ� sale�� dSale�� ���踦 ���� �� �ִ�.
    --------------
        cus: cNum, cName, cTel
        member:cnum, userid, userPwd, userEmail
    
    --�Ի����� ������ ���Ϻ� �Ի��ο��� �� ������?    
    SELECT TO_CHAR(hiredate,'d') ����, count(*) from emp
    group by TO_CHAR(hiredate,'d')
    order by ����;
    
    SELECT * FROM (
        SELECT TO_CHAR(hiredate,'d') ���� from emp    
    ) PIVOT (
        COUNT(*) FOR ���� IN(
            1 "�Ͽ���",
            2 "������",
            3 "ȭ����",
            4 "������",
            5 "�����",
            6 "�ݿ���",
            7 "�����"
        )
    );    
    
--   �� UNPIVOT �� (�ǹ��� �ݴ� �������� ��� ���� �ٲٴ� ��)
--  ���� ��������� �����Ƿ� ���� �� ��
     -------------------------------------------------------
     CREATE TABLE t_city AS
     SELECT * FROM (
        SELECT city, dept FROM emp
     ) PIVOT (
        COUNT(dept)
        FOR dept IN (
            '���ߺ�' AS "���ߺ�",
            '��ȹ��' AS "��ȹ��",
            '������' AS "������",
            '�λ��' AS "�λ��",
            '�����' AS "�����",
            '�ѹ���' AS "�ѹ���",
            'ȫ����' AS "ȫ����"
        )
     );
    SELECT * FROM T_CITY;
    DESC T_CITY;
    
    SELECT * FROM t_city
    UNPIVOT(
        �ο���
        FOR buseo IN (���ߺ�, ��ȹ��, ������, �λ��, �����, �ѹ���, ȫ����)
    );
    DROP TABLE t_city PURGE;
    