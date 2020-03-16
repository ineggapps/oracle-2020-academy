--DML (Data Manupulation Language)

--INSERT
--UPDATE
--DELETE
--MERGE
--SELECT

--Ʈ�����
--"�� ���� ��� ����Ǿ�� �ϴ� �Ϸ��� ������ ����"
--�����ͺ��̽��� ���¸� ��ȯ��Ű�� �ϳ��� ���� ����� �����ϱ� ���� �۾��� ����
--ex) ��ȭ ���� �� ���� ���� �� �ð��� ���� �� �ο��� �� �¼� ���� �� ���� �� Ƽ�� �߱�
--  �۾� ������ �Ϸ��ϴ� ���� COMMIT, ����ϴ� ���� ROLLBACK�̶�� �Ѵ�.
-- + ���� ���� �� ���� (�̴� ��ȭ�� �����ϱ� ���� �ʼ����� ������ �ƴϸ� ������ �����̴�)
--�̷��� �۾� ����(Ʈ�����)�� ��ǻ�� ������ ������ �Ǿ�� �� ���̴�.

--����Ŭ������ INSERT, UPDATE, DELETE�� ������ �ڿ� �ڵ����� Ʈ������� �Ϸ�� ���°� �ƴϴ�.
--COMMIT: Ʈ������� �Ϸ��Ͽ� DB�� �ݿ�
-- INSERT �� ���� ���Ŀ� COMMIT�� �ٷ� ���� ������ LOCK�� ��� �ɷ� ���� �� ����.
--ROLLBACK: Ʈ������� ��ҵǹǷ� DB�� �ݿ����� ����
--��, DDL�� ��쿡�� �ڵ� COMMIT�ȴ�.

--�� ������ ���۾��(DML)
-- �� INSERT
--   �� ���� �� �Է�: 1���� ���̺� 1���� ���� �߰���
-------------------------------------------------------
    --�⺻ ����
    INSERT INTO ���̺��(�÷���1, �÷���2, ...) VALUES (��1, ��2, ...);
    --��� �÷��� ���� �߰��ϴ� ���
    --��, ���̺��� �����ߴ� ����� �÷� ������� �Է��ؾ� �Ѵٴ� �Ϳ� �����Ѵ�.
    INSERT INTO ���̺��(��1, ��2, ...);
    COMMIT �Ǵ� ROLLBACK�� �̿��Ͽ� ������ Ȯ���ϰų� ����Ͽ� DB�� �ݿ��Ͽ��� �Ѵ�.
    --��, JAVA �� �ܺο��� �����͸� �߰��ϸ� �ڵ����� COMMIT ������ ������ �ش�.    
    --
    select * from tab;
    
    CREATE TABLE test1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        birth DATE NOT NULL,
        memo VARCHAR2(1000)
    );
    DESC test1;
    --��� �÷��� ���� �߰��ϴ� ��� �÷��� ���� �����ϴ�.
    --��, ���̺� �ۼ� �� �÷� �ۼ� ������� �Է��ؾ� ��.    
    INSERT INTO test1 VALUES(1,'����','2000-10-10','�׽�Ʈ�Դϴ�.'); --��¥�� �ڵ���ȯ�Ǿ� DATE�������� ����ȴ�
    SELECT * FROM test1; 
    
    INSERT INTO test1 VALUES(2,'������','2000-10-10'); --����: �÷� ������ ���� ��ġ���� �ʴ´�. (�÷��� 4���ε�, ���� 3���� �ԷµǾ���)
    --ORA-00947:���� ���� ������� �ʽ��ϴ�.
    
    INSERT INTO test1 VALUES('������',2,'2000-10-10','�׽�Ʈ'); --����: ���̺� �÷��� �ڷ����� ���� ����ġ�ϴ�.
    --ORA-01722:��ġ�� �������մϴ�.
    
    INSERT INTO test1 VALUES(2,'������','2000-10-10',''); --���ڿ��� ���̰� 0�̸� NULL�� ����Ѵٴ� �� ���� ����
    SELECT * FROM test1;

    --�÷��� ���: �÷��� ������ ���� �ٸ� ���    
    INSERT INTO test1(num, name, birth) VALUES(3,'������','2000-10-10'); -- ������� ���� MEMO�׸񿡴� NULL������ ���Եȴ�.
    INSERT INTO test1(num, name, birth, memo) VALUES(3,'����','2000-10-10','�׽�Ʈ'); --����: ORA-00001: ���Ἲ ���� ����(�⺻Ű)�� ���ݵ�
    SELECT * FROM test1;

    --���� ORACLE DB ������ �ü���� ������ ���İ� ��ġ�ؾ� �Ѵ�.
    --���� 10/10/90�� �ѱ� �ü�������� 10�� 10�� 90���̹Ƿ� ������ �Ұ����ϴ�.
    INSERT INTO test1(num, name, birth, memo) VALUES(4,'����','10/10/90','�׽�Ʈ');--ORA001847: ���� ��¥�� 1���� ���� ���̾�� �մϴ�.
    --���� TO_DATE() ���İ� �����Ͽ� ����ϴ� ��쿡�� ������ ���Ŀ� ���� ��¥�� �˸°� �Է��� �� �ִ�.
    INSERT INTO test1(num, name, birth, memo) 
    VALUES(4,'����',TO_DATE('10/10/90','MM/DD/RR'),'�׽�Ʈ');--ORA001847: ���� ��¥�� 1���� ���� ���̾�� �մϴ�.
    SELECT * FROM test1;
    
    INSERT INTO test1(num, name, memo) VALUES(5,'������','�׽�Ʈ');
    --NOT NULL ������ �����Ͽ���. (BIRTH�� NOT NULL�� ����Ǿ� ����)
    --����: ORA-01400: NULL�� (SKY, TEST1, BIRTH) �ȿ� ������ �� �����ϴ�.
    
    INSERT INTO test1(num, name, birth) VALUES(5,'�������Ӹӳ��밡����','2000-10-10');
    --name�� ���̺� ���� ��� ������ �÷����� Ÿ�� ũ�⺸�� ũ�� �ԷµǾ���.
    --ORA-12899: SKY.TEST1.NAME���� ���� ���� �ʹ� ŭ(����:33, �ִ�:30)
    
    --�� TABLE�� �����͸� ������ ���� INTO ���̺��(�÷���1, �÷���2, ..) ó�� ����� �ڿ� VALUES�� �����ؾ� �Ѵ�.
    COMMIT; -- COMMIT������ ���� ������ �ٸ� ���ǿ����� �����Ͱ� �߰��Ǿ� ���� ������ Ȯ���� �� �ִ�.

    INSERT INTO test1(num, name, birth) VALUES(5,'������',SYSDATE);
    --�ý��� ��¥ �߰�
    SELECT * FROM test1;
    ROLLBACK; -- DB�� ���� ���
    SELECT * FROM test1;
    
    --test1���̺� �÷� �߰��ϱ�
    ALTER TABLE test1 ADD (
        created TIMESTAMP --�̹� �����Ͱ� �����ϹǷ� NOT NULL�� ���� �� ����
    );
    DESC test1;
    SELECT * FROM test1;--�̹� �߰��� �����Ϳ��� CREATED COLUMNS���� NULL������ ����.
    
    -- ����1) ������ �߰�
    --num:5�� name:������ birth:2000-10-10 created: 20101010
--    INSERT INTO test1(num,name, birth, created) VALUES(5,'������','20001010','20101010101010200'); --ORA-01830 ��¥ ������ ������ ���ʿ��� �����Ͱ� ���ԵǾ� �ֽ��ϴ�. (Ÿ�ӽ����� ���Ŀ� ���� ����)  
    INSERT INTO test1(num, name, birth, created) VALUES(5,'������','2000-10-10',TO_TIMESTAMP('20101010101010200','YYYYMMDDHHMISSFF3'));--FF3 �и��ʸ� 3�ڸ��� ǥ���ߴٴ� �ǹ���
    COMMIT;
    SELECT * FROM test1;
    SELECT num, name, TO_CHAR(created,'YYYY-MM-DD HH:MI:SS.FF3') created from test1;
    
    -- ����2) test2���̺� �ۼ��ϱ�
    -- test2 ���̺� �ۼ�
--		  hak   ����(30)  PRIMARY KEY
--		  name  ����(30)  NOT NULL
--		  kor   ����(3)   NOT NULL
--		  eng   ����(3)   NOT NULL
--		  mat   ����(3)   NOT NULL
--		  tot   ����(3)   �����÷�  kor+eng+mat
--		  ave   ����(4,1) �����÷�  (kor+eng+mat)/3
    CREATE TABLE test2(
        hak VARCHAR2(30) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL,
        tot NUMBER(3) GENERATED ALWAYS AS (kor+eng+mat) VIRTUAL ,
        ave NUMBER(4,1) GENERATED ALWAYS AS ((kor+eng+mat)/3) VIRTUAL
    );
    DESC test2;
    -- test2 ���̺� ������ �߰��ϱ�
    --hak:'1111', name:'������', kor:90, eng:80, mat:90
    INSERT INTO test2(hak, name, kor, eng, mat) VALUES('1111','������',90,80,90);
--    INSERT INTO test2 VALUES('1111','������',90,80,90,260,86.7); --���� ORA-54013: insert �۾��� ���� ������ ������ �ʽ��ϴ�.
    COMMIT; -- COMMIT�� �ٷ� �������� ������ �ٸ� ������ ������ �� ������ ������(MANIPULATION) �����Ͱ� �ݿ����� �ʴ´�.
    SELECT * FROM test2;

--   �� subquery
--  ���ÿ� 1�� ���̺� 2�� �̻��� ���� �߰��� �� ����.
--     -------------------------------------------------------
    --���� ���̺��� �̿��Ͽ� ���ο� ���̺��� �ۼ��ϰ� ���� ���̺��� ������ ���� ����
    CREATE TABLE ���̺�� AS SELECT * FROM �����Ͱ� �ִ� ���̺�� [WHERE ����];
    --�����ϴ� ���̺� ���� ����
    INSERT INTO ���̺��[(�÷���, �÷���)] subquery;
    --���̺��� ������ �����Ͽ� �����
    CREATE TABLE emp1 AS
        SELECT empno, name, dept, pos from emp WHERE 1=0;
    --��, �������� NOT NULL�� �����ϰ�� ������� �ʴ´�.
    SELECT * FROM emp1;
    DESC emp1;
    
    --emp���̺��� ���ߺ��� ���븸 �����Ͽ� emp1���̺� �����ϱ�.
    INSERT INTO emp1
        SELECT empno, name, dept, pos FROM emp
        WHERE dept='���ߺ�';
    SELECT * FROM emp1;
    COMMIT; --������ ������ �ùٸ��� �Ǿ����� COMMIT,
    --ROLLBACK; -- ������ ������ �߸��Ǿ��ٸ� ROLLBACK�� �����ϰ� �ٽ� �ùٸ� ������ �����Ͽ� COMMIT;    
--
--
--   �� unconditional INSERT ALL (������ ���� INSERT ALL)
--  2�� �̻��� ���̺� 2�� �̻��� ���� �߰��� �� �ִ�.
-------------------------------------------------------  
     CREATE TABLE emp3 AS
	   SELECT empNo, name, dept, pos FROM emp WHERE 1=0;
	 CREATE TABLE emp4 AS
	   SELECT empNo,sal, bonus FROM emp WHERE 1=0;
	 
     SELECT * FROM TABS;
     
	 INSERT ALL 
     INTO  emp3 VALUES(empNo, name, dept, pos)  --��ġ�ϸ� emp3[(�÷���)] <- �� ������ �� �ִ�.
     INTO  emp4 (empNo,sal, bonus) VALUES(empNo,sal, bonus) --emp4(emp4�� �÷���) values(emp�� �÷���)
     SELECT * FROM emp; --source
     COMMIT;
     SELECT * FROM emp3;
     SELECT * FROM emp4;
    
    -- �� �� ���� ���̺� ���ο� �� �ϳ��� �߰��ϴ� ���
    -- �˾Ƶθ� ���߿� �����ϰ� ����� �� �ִ�.
    -- ��) ȸ������ �� �ű� ȸ�� �ϳ��� ������ ���� ���� ���̺� �����Ͽ� ������ �� ����
    INSERT ALL
    INTO emp3(empno, name, dept, pos) VALUES('9999', '�ӸӸ�', '���ߺ�', '���')
    INTO emp4(empno, sal, bonus) VALUES ('9999', 1000000, 50000)
    SELECT * FROM dual;
    
    SELECT * FROM emp3; --�Է� Ȯ��
    SELECT * FROM emp4; --�Է� Ȯ��
    COMMIT;

--   �� conditional INSERT {ALL | FIRST} ������ �ִ� INSERT ALL
    --FIRST�� ó�� �͸� �ִ´�.
--      ------------------------------------------------------S
    CREATE TABLE emp5 AS
        SELECT empno, name, rrn, dept, pos FROM emp WHERE 1=0;
    CREATE TABLE emp6 AS
        SELECT empno, name, rrn, dept, pos FROM emp WHERE 1=0;
    
    --rrn�÷��� �̿��Ͽ� ���ڿ� ���� ����� �и��Ͽ� ����
    INSERT ALL
        WHEN mod(substr(rrn,8,1),2)=1 THEN 
            INTO emp5 VALUES(empno, name, rrn, dept, pos)
        WHEN mod(substr(rrn,8,1),2)=0 THEN
            INTO emp6 VALUES(empno, name, rrn, dept, pos)
        SELECT * FROM emp;
        
    SELECT * FROM emp5; --���ڻ��
    SELECT * FROM emp6; --���ڻ��
    COMMIT;
    
    DROP TABLE emp1 PURGE;
    DROP TABLE emp2 PURGE;
    DROP TABLE emp3 PURGE;
    DROP TABLE emp4 PURGE;
    DROP TABLE emp5 PURGE;
    DROP TABLE emp6 PURGE;
    
    SELECT * FROM tab;


-- �� UPDATE
--   �� UPDATE 
--  ���� ���ڵ� ����
--     -------------------------------------------------------
    UPDATE ���̺�� SET �÷���1=��1, �÷���2=��2 WHERE ����;
    --CAUTION: WHERE���� ������ ��� �����ȴ�.
    --COMMIT �Ǵ� ROLLBACK�� �ʿ��� �����̴�.
    -- �ڹ� �� �ܺο��� ������ ��� �⺻������ COMMIT�ȴ�.
    
    SELECT * FROM EMP;
    UPDATE emp SET name='������'; 
    --�� ������ ��� ���ڵ尡 �����Ǹ�, �ǹ����� ���� SQL�� ������� �ʴ´�. ������ �ݵ�� ���!!!
    SELECT * FROM EMP;
    ROLLBACK;
    
    --���ο� ���� ������ ���� (emp_score ���̺�)
    DESC emp_score;
    SELECT * FROM emp_score;
    
    --emp_score: empno=1002�� ���ڵ��� com=90, excel=95�� ����
    UPDATE emp_score SET com=90, excel=95 WHERE empno=1002;
    SELECT * FROM emp_score WHERE empno=1002; --������ ���� Ȯ���� �� �ִ�.
    COMMIT; --DB�� �ݿ�
    
--  ����1) emp_score: empno, com, excel, word, tot, ave, grade
--  tot: com+excel+word
--  ave: (com+excel+word)/3 (��, �Ҽ����� 2° �ڸ����� �ݿø�)
--  grade: ��� ���� ������ 40�� �̻��̰� ����� 60�� �̻��̸� �հ�
--  ����� 60�� �̻��̰� �� �����̶� 40�� �̸��̸� ����
--  ����� 60�� �̸��̸� ����
-- SELECT������ ��ȸ�� �� �� �ֵ��� �ۼ��ϱ�.
    SELECT 
        empno, com, excel, word, 
        (com+excel+word) tot, 
        round((com+excel+word)/3,2) ave,
        CASE 
            WHEN (com+excel+word)/3 >= 60 AND (com>=40 AND excel >=40 AND word >=40) THEN '�հ�'
            WHEN com<40 OR excel <40 OR word <40 THEN '����'
--            WHEN (com+excel+word)/3 <60 THEN '���հ�'
            ELSE '���հ�'
        END grade
    from emp_score;


--
--
-- �� DELETE
--   �� DELETE
--     -------------------------------------------------------
--     --
--
--
-- �� MERGE
--   �� MERGE
--     -------------------------------------------------------
--     --
--
