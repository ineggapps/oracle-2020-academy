--�� �� �� ������, �ó��
-- �� ��(VIEW)
--0. �� �ۼ� ������ �ο��ؾ� �Ѵ�. (������: sys, system ���������� ����)
--��� �����͸� ������ ���� ���� (MATERIALIZED VIEW������ �����͸� ������ ����)
--�� �ۼ�����
--GRANT �ο��� ���� TO �����;
GRANT CREATE VIEW TO sky;--������ �������� ����
--����� �������� ������ Ȯ���ϴ� ���
SELECT * FROM USER_SYS_PRIVS;
--SKY, CREATE VIEW, NO, NO, NO

--1. subquery���� ����Ǵ��� ����
--2. ���� ������ �ݵ�� �÷����� ������ �Ѵ�.
     ------------------------------------------------------
        --ORA-01031: ������ ������մϴ�
        --01031. 00000 -  "insufficient privileges"
        CREATE VIEW panmai 
        AS
            --�Ǹ� ��Ȳ: b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            FROM book b
            JOIN pub p  ON  b.pNum = p.pNum
            JOIN dsale d  ON b.bCode = d.bCode
            JOIN sale s  ON  d.sNum = s.sNum
            JOIN cus c  ON s.cNum = c.cNum;

        --�� Ȯ��
        SELECT * FROM TAB WHERE tabtype='VIEW';
        --��� ��������� tabtype�� VIEW�� ǥ�õȴ�.
        SELECT * FROM col WHERE tname='PANMAI';
        DESC panmai;
        --������ ���� SQL�� Ȯ��
        SELECT view_name, text FROM user_views;
        --���̺�ó�� �䵵 ������ ��ȸ�� �� �ִ�.
        SELECT * FROM panmai;
        
        ----------------------------------------
        --�� ����
        --OR REPLACE�� ������� ������...
        --ORA-00955: ������ ��ü�� �̸��� ����ϰ� �ֽ��ϴ�.
        --00955. 00000 -  "name is already used by an existing object"
        CREATE OR REPLACE VIEW panmai 
        AS
            SELECT b.bccode, bcsubject, 
            b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
            FROM book b
            JOIN bclass bc ON b.bccode = bc.bccode
            JOIN pub p  ON  b.pNum = p.pNum
            JOIN dsale d  ON b.bCode = d.bCode
            JOIN sale s  ON  d.sNum = s.sNum
            JOIN cus c  ON s.cNum = c.cNum;    
        SELECT * FROM panmai;
        
        ----------------------------------
        --����1) �� �����: ypanmai
        --����, bcode, bname, qty��, qty*bprice ��
        --���� �������� �����ϱ�
        
        CREATE OR REPLACE VIEW ypanmai
        AS
        SELECT TO_CHAR(sdate,'YYYY') ����, b.bcode ,bname, 
            sum(qty) ������, 
            TO_CHAR(sum(qty*bprice),'L999,999,999') �ݾ���
        FROM book b
        JOIN dsale d ON b.bcode = d.bcode
        JOIN sale s ON d.snum = s.snum
        GROUP BY TO_CHAR(sdate,'YYYY'), b.bcode, bname
        ORDER BY ���� DESC;
        
        SELECT view_name, text FROM USER_VIEWS;
        SELECT * FROM TAB WHERE tabtype='VIEW';
        SELECT * FROM ypanmai;
       
       --���� �͸� ����
       SELECT * FROM ypanmai WHERE ���� = EXTRACT(YEAR from SYSDATE);
    
        -- book : bCode, bName, bPrice, pNum
        -- pub : pNum, pName
        -- sale : sNum, sDate, cNum
        -- dsale : sNum, bCode, qty
        -- cus : cNum, cName
    ------------------------------------------------
    --  �並 �̿��� ������ �߰�, ����, ����
    select * from tab where tname like 'TEST%';
    DROP TABLE test1 cascade constraint purge;
    
    
    CREATE TABLE test1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        memo VARCHAR2(100)
    );
    
    CREATE TABLE test2(
        code NUMBER PRIMARY KEY,
        num NUMBER REFERENCES test1(num) ON DELETE CASCADE,
        score NUMBER(3)
    );
    
    INSERT INTO test1(num, name, memo) VALUES(1, 'a', NULL);
    INSERT INTO test1(num, name, memo) VALUES(2, 'b', NULL);
    INSERT INTO test1(num, name, memo) VALUES(3, 'c', 'java');
    
    INSERT INTO test2(code, num, score) VALUES(1, 1, 80);
    INSERT INTO test2(code, num, score) VALUES(2, 1, 70);
    INSERT INTO test2(code, num, score) VALUES(3, 1, 60);
    
    COMMIT;
    --�ڷᰡ �Է��� ���������� �Ǿ����� Ȯ��
    SELECT * FROM test1 JOIN test2 USING(num);
    --���� ��
    CREATE OR REPLACE VIEW testview1
    AS
        SELECT a.num, code, name, memo, score
        FROM test1 a, test2 b WHERE a.num = b.num;
        
    SELECT view_name, text FROM USER_VIEWS;
    SELECT * FROM testview1;
    
    CREATE OR REPLACE VIEW testview2
    AS
        SELECT num, name 
        FROM test1;
    
    --���� ��� INSERT, UPDATE, DELETE�� �� �� ����
    --ORA-01779:Ű ������ ���� �ƴ� ���̺�� ������ ���� ������ �� �����ϴ�.
    INSERT INTO testview1(num, name, memo) VALUES(4,'d','oracle');
    UPDATE testview1 SET memo='JSP';
    DELETE FROM testview1 WHERE code=2;--���? �Ǵµ�...
    
    --�ܼ� ���� ��쿡�� ���������� ���������� �ʴ´ٸ� INSERT, UPDATE, DELETE�� �����ϴ�. 
    INSERT INTO testview2(num, name) VALUES(4,'oracle');
    COMMIT;
    UPDATE testview2 SET name='java' WHERE num=4;
    select * from testview2;
    DELETE FROM testview2 WHERE num=1;
    COMMIT;
    
    SELECT * FROM TEST1;
    SELECT * FROM TEST2;
    
    --�� �� ���̺� ����
    DROP VIEW testview1;
    DROP VIEW testview2;
    DROP TABLE test2 PURGE;
    DROP TABLE test1 PURGE;
    
    --WITH CHECK OPTION
    CREATE TABLE emp1 AS
        SELECT empno, name, city, sal FROM emp WHERE dept='���ߺ�';
    SELECT * FROM emp1;
    
    --�� ����
    CREATE OR REPLACE VIEW empView
    AS
    SELECT empno, name, city, sal FROM emp1
    WHERE city='����';
    
    SELECT * FROM empview;
    UPDATE empview SET city='�λ�' WHERE empno = '1059';
    
    --�������� ���ϵ��� �� �ٽ� ����
    CREATE OR REPLACE VIEW empView
    AS
    SELECT empno, name, city, sal FROM emp1
    WHERE city='����' WITH CHECK OPTION CONSTRAINT wc_empView;
    
    SELECT * FROM empview;
    --WITH CHECK OPTION: �並 �̿��� ���� ���Ἲ �˻�
    --ORA-01402: ���� WITH CHECK OPTION�� ���ǿ� ���� �˴ϴ�
    UPDATE empview SET city='�λ�' WHERE empno = '1059';
    
-- �� ������(sequence)
     -------------------------------------------------------
     SELECT * FROM SEQ;
    
    --1���� �����ϴ� ������ �����
    CREATE SEQUENCE seq1;
    
    --���� �����ϴ� ������ ��� Ȯ���ϱ�
    SELECT * FROM seq;
    
    --������ ����ϱ�
    SELECT seq1.NEXTVAL, seq1.NEXTVAL, seq1.CURRVAL FROM dual;
    --SELECT���� �ȿ����� NEXTVAL�� �����翩 ����ϴ��� 1�� ȣ���� ������ �����Ѵ�.
    
    --������ �����ϱ�      
    DROP SEQUENCE seq1;
    
    CREATE TABLE t1(
        col1 NUMBER,
        col2 NUMBER,
        col3 NUMBER
    );
    CREATE SEQUENCE seq1;
    
    INSERT INTO t1 VALUES(seq1.NEXTVAL, seq1.NEXTVAL, seq1.CURRVAL);
    --CURRVAL�� �׻� �ŷ��� �� ����
    --CURRVAL�� ĳ�ó� ���� ó�� �켱������ ���� CURRVAL���� ��ġ���� ���� ���� ����.
    select * from t1;
    
    DROP TABLE t1 PURGE;
    DROP SEQUENCE seq1;
    
    SELECT * FROM SEQ;
    --������ ���� �� �����
    CREATE SEQUENCE seq0;--ĳ�� 20(�⺻��)
    
    --1���� 1�� ����
    CREATE SEQUENCE seq1
        START WITH 1
        INCREMENT BY 1 --������ �� �� ����. (START WITH�� ū ������ �����ϸ� ����� �����ϴ�)
        NOMAXVALUE --SEQUENCE�� ǥ���� �� �ִ� ���� ������ ������ (�⺻��) 9999999999999999999999999999
        NOCYCLE
        NOCACHE --NOCACHE�� 0;
    
    --100���� 1�� ����
    CREATE SEQUENCE seq2
        START WITH 100
        INCREMENT BY 1
        MINVALUE 1
        MAXVALUE 1000; --CACHE�� ������� ������ 20�� �⺻��
    --CACHE����ŭ �̸� SEQUENCE���� ����� �д�.
    --EX) 20���� CACHE�� ����� 2���� ����Ͽ��ٸ� 18���� ���Ҵ�.
    --������, ����Ŭ ���� �۵��� �����ų� �ϴ� ���� ������ �߻��ϸ�
    --�̸� ����� �� 18���� ���ڴ� ������� ���ϰ� �� ���� ������ ĳ���� �ٽ� �����Ѵ�,
    
    --3���� 999���� 3�� ����. cache 5��
    CREATE SEQUENCE seq3
        START WITH 3
        INCREMENT BY 3
        MINVALUE 3
        MAXVALUE 999
        CACHE 5;
        
        
    --
    CREATE SEQUENCE seq4
        START WITH 9
        INCREMENT BY 4
        MINVALUE 3
        MAXVALUE 12
        CYCLE --���ǻ���: CYCLE�� ������ ���� �ݵ�� CACHE���� �����ؾ߸� �Ѵ�.
        CACHE 2;
        
    SELECT * FROM seq;
    
    CREATE TABLE t1(
        col1 NUMBER,
        col2 NUMBER,
        col3 NUMBER,
        col4 NUMBER
    );
     
    INSERT INTO t1 VALUES(seq1.NEXTVAL, seq2.NEXTVAL, seq3.NEXTVAL, seq4.NEXTVAL);   
    SELECT * FROM t1;
    
    DROP TABLE t1 PURGE;
    DROP SEQUENCE seq0;
    DROP SEQUENCE seq1;
    DROP SEQUENCE seq2;
    DROP SEQUENCE seq3;
    DROP SEQUENCE seq4;
   
-- �� �ó��(synonym)
     -------------------------------------------------------
     
     --0�ܰ�) SKY�������� HR������� employees ���̺� ���� Ȯ���ϱ�
     SELECT * FROM hr.employees;
     --ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ� (������ ��� Ȯ���� �� ����)
     
     --1�ܰ�) HR����ڰ� SKY����ڿ��� employees ���̺� ��ȸ�� �� �ֵ��� ������ �ο�
     GRANT SELECT ON employees TO sky;
     
     --2�ܰ�) SKY�������� �ٽ� employees ���̺� ���� Ȯ�� �õ��ϱ�
     --SELECT * FROM employees; �ٸ�����ڸ�.���̺������ ����ؾ� �Ѵ�.
     SELECT * FROM hr.employees; --�� Ȯ�εǴ� ���� �� �� ����.
     
     --3�ܰ�) hr.�� �Է��ϱ� ���ŷο�Ƿ� synonym�� �ֵ��� �Ѵ� (HR�������� �ó�� ����) -BUT ���Ѻ���� ����
     CREATE SYNONYM employees FOR hr.employees;

    --��, ������ �������� ������ ������ SKY���� �ο��Ͽ��߸� �ó�� ������ �����ϴ�
     GRANT CREATE SYNONYM TO sky;
    
    --����) ������� �ó���� ����� ����
    SELECT * FROM employees;

     --�ó�� Ȯ��
     SELECT * FROM syn;
    
    --����
    DROP SYNONYM employees;
    
    --�̷��� �ڱ� �ڽ��� ���̺� �ó������ ���� �� �ְڱ�!
    CREATE SYNONYM e FOR emp;
    select * from e;

     --���� �ο��ϱ� (������ ��������)
     GRANT CREATE SYNONYM TO sky;
     
     
    --����: ����Ŭ������ �並 ���� ��������� �ʴ´�.