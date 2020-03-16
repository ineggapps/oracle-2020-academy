--������ ���Ǿ��
--����� �ڵ����� COMMIT�ǹǷ� ROLLBACK�� �� �� ����. (������ �ǵ��� �� ����)
--������ ����
-- EX) TABS  ���̺� ���
-- EX) COLS ���̺��� �÷� ���

--CREATE TABLE, VIEW, INDEX ���� ����
--ALTER ������ ���̺� ���� ��ü�� ����
--DROP ���̺�, ��ü ���� ����
--RENAME ������ ��ü�� �̸� ����
--TRUNCATE ���̺��� ��� ������ ����
--truncate: d. (��ǻ��) �����ϴ�, ��� ������ �������� - ���ƻ���

--������ Ÿ��

--���̺��� �÷� ���� ���
SELECT * FROM USER_TAB_COLUMNS;
SELECT * FROM COLS;
SELECT * FROM COL;
--desc emp;
--SELECT DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, CHAR_USED FROM USER_TAB_COLUMNS
--WHERE TABLE_NAME='���̺��';

--CHAR�� �� ������� �ʴ� EU
--�ִ� 2000byte (�ѱ� 600�� ��), �ּڰ� 1byte
--1) CHAR(4) �� �� ����(A) ���� �� "A"�� �ƴ϶� "A   "�� ����ȴ�. 
--   SELECT ... FROM ���̺� WHERE �÷���='A' ���� �� �ᱣ���� �ǵ��� ��� ������ �ʴ´�.
--2) �޸� ȿ���� CHAR(4)���� �ε��ϸ� "A   "�� �ε��Ͽ� �޸� ȿ������ ��������.
--�ٸ� ������ ��(�ֹε�Ϲ�ȣ ��)�� ������ ���� ����ϱ⵵ �Ѵ�.

--VARCHAR2(N) �� �˰� �־�� �Ѵ�. (Mysql������ VARCHAR��)
--�ִ� 4000byte (�ѱ� 1300�� ��), �ּڰ� 1byte
--"A"��� ���ڸ� ������ �� ũ�⸦ 1byte�� �����Ͽ� �����Ѵ�.
--���� SELECT ... FROM ���̺� WHERE �÷���='A'�� �񱳰� �����ϴ�.
--"A"��� ���ڰ� �߰��� ���¿��� 5�� "AAAAA" ������ �õ��ϸ� ������ �߻��Ѵ�.
--�ֳ��ϸ� "A"��� ���ڰ� �Էµ� �� �̹� ũ��� 1byte�� �����Ͽ� �ԷµǾ��� �����̴�.

--����VARCHAR�� ����� ����Ŭ���� ���� ���� ���� ������� �ʴ´١���
--ũ�Ⱑ 4byte�� ������ "A"�� �����ϸ� ������ �������� null������ ä������.
--����Ŭ������ ����� �������� �ʴ´�.
--�ñ��� ������ �� ��.
--MYSQL�� VARCHAR���� �ٸ� �����̴ϱ� ������ ��.

--���ڴ� NUMBER (�ִ� ���� 38�ڱ��� �Է� ����)
--
--NUMBER(��������): ������ 38��
--NUMBER(������ ��ü P�ڸ�(�Ҽ��� ����), �Ҽ���S�ڸ�(-84~+127)) ���е��� ǥ���� �� �ִ� �ɼ�
--��, �Ҽ����� ���� �ʴ´�. ���ڰ� ��ġ�� ������ �߻��Ѵ�.
--NUMBER(2,3)�� ��� �Ҽ��� 0.001~0.099������ �����ϴ� (0.01�� ���� ��ġ�Ƿ� ������ �Ұ����ϴ�)
--NUMBER(3,-1)�� ��� 1���ڸ��� ������ �� ���ٴ� �̾߱��̴�.
--NUMBER(10,3)���� 1234567.6789�� �ڸ����� ��ġ���� �Ҽ������� �ݿø�ó���� �ȴ�.
--NUMBER(10,3)���� 12345678.678 �Է� �ÿ��� ������ �߻��Ѵ�.

--�� ������ ���� ���(Data Definition Language)
-- �� ������ ���� ���(DDL) �� ������ Ÿ��
--
--   �� ������ Ÿ�� - ����
--      - ������ Ÿ�� ���� Ȯ��
--         SELECT DATA_TYPE, DATA_LENGTH, CHAR_LENGTH, CHAR_USED
--         FROM USER_TAB_COLUMNS
--         WHERE TABLE_NAME ='���̺��';
--
-- �� ���̺� ���� �� ���� ����
--   �� ���̺� ���� 
--    CREATE TABLE ���̺��(
--        �÷��� ������Ÿ��(ũ��) [��������] [NOT NULL],
--        �÷��� ������Ÿ��(ũ��) [��������] [NOT NULL], ...
--    );
--     ---------------------------------------------------------------
--  ���̺��: test=> �ٸ� ��ü��� �ߺ��� �� ����. ������ �������� �빮�ڷ� ����ȴ�.
--    �÷���, �÷� Ÿ��, ũ��(��), ���� ����, NULL����
--      num       ����      10      �⺻Ű         X
--      name     ����       30                       X
--      birth      ��¥      (����)    
--      city       ����      30
    
        CREATE TABLE test(
            num NUMBER(10) primary key,
            name VARCHAR2(30) not null,
            birth DATE,
            city  VARCHAR2(30)
        );
        select * from tab; --���̺��� ���� ����
        select * from tab where tname='TEST'; --Ư�� ���̺� �˻�
        select * from tab where tname=UPPER('test');
   
        select * from COL where tname='TEST';
        select * from COLS where TABLE_NAME='TEST'; -- ���̺� ���� Ȯ��: �� �����Ǿ����� Ȯ���� �� ����.
        desc TEST; --���� �⺻ ��ɾ�� �ƴϴ�. JAVA���� �� ��ɾ ���� ���̺� ����� Ȯ���� �� ����.
        --SQLPLUS, SQL DEVELOPER �� �������ִ� �������� ������ ��ɾ��̴�. �� ���� �����Ѵ�.
        
--
--   �� ���̺� ���� - ���� �÷�(virtual column)
--      GENERATED ALWAYS AS ~ VIRTUAL
--      ��ũ�� ������� �ʴ� �÷����� ���� �����̳� �Լ� ���� ����Ѵ�
--      SYSDTE �� ������ ����� ���� �� ����.
--      ���� �߰��ϰų� ������ �� ����.
--     ---------------------------------------------------------------
    CREATE TABLE demo(
        id VARCHAR2(30) PRIMARY KEY,
        name VARCHAR(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL,
        --11g �̻󿡼��� ������ ������ �� �ִ�. 
        --���� �����ϴ� ���� �ƴ϶� ������ �����ϴ� ���� ���� �÷��̶�� �Ѵ�.
        tot NUMBER(3) GENERATED ALWAYS AS (kor+eng+mat) VIRTUAL,
        ave NUMBER(4,1) GENERATED ALWAYS AS ((kor+eng+mat)/3) VIRTUAL
    );
    SELECT * FROM tab;
    SELECT * FROM col WHERE tname='DEMO';
    DESC demo;
    SELECT * FROM demo;

--   �� ���̺� ���� - subquery�� �̿��� ���̺� ���� 
--     ---------------------------------------------------------------
--     ���� ���� �÷��� ������ ������� �ϴ� �ű� ���̺� �÷��� ������ ��ġ�ؾ� �Ѵ�.
--     �����͵� ����: NOT NULL�� ������ "��������"�� ������� ����.
--      �Ʒ����� emp1�� ���̺��� emp���̺��� ������ ���������
--    NOT NULL�� ������ �⺻Ű ���� ���������� ������� �ʴ´�.
        CREATE TABLE emp1 AS 
        SELECT empno, name, sal, bonus, sal+bonus pay from emp;
        --����: �÷��� ��Ģ ���� (sal+bonus)�� �÷������� ������ �� ����
        --���� ��Ī�� �����Ͽ� �ذ��Ͽ��� �Ѵ�.
        SELECT * FROM COL WHERE TNAME='EMP1';
        SELECT * FROM tab;
        DESC EMP;
        SELECT * FROM EMP1;
        --�������� Ȯ��
        SELECT * FROM USER_CONSTRAINTS; --�� ���̺��� ���������� Ȯ���� �� �ִ�.
        --�÷� �� CONSTRAINT_TYPE���� P���� PRIMARY KEY(�⺻Ű)�� �ǹ��Ѵ�.
        --�÷� �� CONSTRAINT_TYPE���� U���� UNIQUE KEY�� �ǹ��Ѵ�.  
        --�÷� �� CONSTRAINT_TYPE���� C�� NOT NULL ���� ���������� �ǹ��Ѵ�. 
        --�ٷ� NOT NUL�� �����ϰ� �̷��� �������ǵ��� ���簡 �� �ȴٴ� ���̴�.
        
        -- �÷����� �����Ͽ� �����ϴ� ���̺��� �̿��ؼ� ���̺��� �����
        -- ���̺��� ������ �����Ѵ�.
        -- ���� ���̺��� �÷������ �ٸ��� �÷����� ���� ����� �� �ִ�.
        CREATE TABLE emp2(num, name, birth) as 
        SELECT empno, name, to_date(substr(rrn,1,6))
        from emp;
        
        SELECT * FROM tab;
        DESC emp2;
        SELECT * FROM emp2; --�����Ͱ� �� ���ԵǾ����� Ȯ���ϱ�
        
        --���̺��� ������ �״�� �������� �ȿ� �� �����ʹ� �����Ͽ� �������� ���� ��
        SELECT * FROM emp;
        SELECT * FROM emp WHERE 1=2;

        CREATE TABLE emp3 AS SELECT * FROM emp WHERE 1=2;
        --NOT NULL�� ������ ���� ������ ������� �ʾҴ�.
        
        SELECT * FROM emp3; --�����Ͱ� ���ԵǾ� ���� ���� ���� Ȯ���� �� �ִ�.
        DESC emp3;
        
--   �� ALTER TABLE ~ ADD 
--      ���̺��� ������ ��ġ��! - �÷��� ���� ����!
--     ---------------------------------------------------------------
        DESC test;
        ALTER TABLE test ADD(
            dept VARCHAR2(30),
            sal NUMBER(3) NOT NULL
        );
        
        DESC emp2;
        SELECT * FROM emp2;
        ALTER TABLE emp2 ADD(city VARCHAR2(30)); --�����.  (���� Ʃ�õ��� city ���� NULL�� ������)
        ALTER TABLE emp2 ADD(
            dept VARCHAR2(30) NOT NULL
            --����: emp2���̺� ���� �����Ͱ� �̹� �����ϹǷ� NOT NULL ���������� �Ұ����ϴ�.
        );
        
        -- ����1) emp ���̺��� �̿��Ͽ� emp4 ���̺� �ۼ�
        -- 1-1)    emp �ڷ� �� dept�� ���ߺ��� empNo, name, rrn, dept ����
                    CREATE TABLE emp4 AS 
                    SELECT empNo, name, rrn, dept FROM emp where dept='���ߺ�';
                    SELECT * FROM emp4;
        -- 1-2)    emp4���̺� birth ���� �÷� �߰�
                    ALTER TABLE emp4 ADD(
                    --GENERATED ALWAYS AS ���� VIRTUAL
--                        birth date GENERATED ALWAYS AS (to_date(substr(rrn,1,6),'RRMMDD')) VIRTUAL --�ۼ� ���
                          birth date GENERATED ALWAYS AS (substr(rrn,1,6)) VIRTUAL --������ ���
                        -- ��¥ �������� ��ȯ�� �� �ִ� ���ڿ��̶�� �ڵ����� ��ȯ�� ������ �ش�.
                        --���� �÷������� 'RRMMDD' ���� �Ұ���
                    );
        --          rrn�� �̿��Ͽ� ���ϸ� �����Ͽ� ���� (DATE������)
                DESC emp4;
                SELECT * FROM emp4;
-- ������ TIP : PURGE RECYCLEBIN;
--purge �̱��� [p?��rd?]  ������ [p?��d?]  �߿�
--1. (�������� �����, ���� �������� �������) �����ϴ�
--2. (���� ����������) ���Ƴ���
--3. (�������� �����, ���� �������� �������) ����

--   �� ALTER TABLE ~ MODIFY
--      ���̺��� ������ ��ġ��! - �÷��� �Ӽ��� ������ ����!
--     ---------------------------------------------------------------
--      �÷� ������ Ÿ���̳� �� ���� �����Ѵ�.
--      ��, �̹� �����Ͱ� �����ϴ� �����ͺ��� ���� ���� ������ �� ����.
--      �̹� �����Ͱ� �����ϴ� ��� Ÿ���� ���氡���� ��츸 ������ �� �ִ�.
--     EX) ��� ���ڴ� ���ڷ� �ٲ� �� ���� NUMBER => VARCHAR2
--          �׷��� VARCHAR2 => NUMBER�δ� �׻� ������ ���� �ƴϴ�.
    
    ALTER TABLE test MODIFY(sal NUMBER(10)); --������ ũ�� 3���� 10���� ����Ǿ���.
    DESC test;
    
    select * from emp2;
    ALTER TABLE emp2 MODIFY(
        name VARCHAR2(8)--���� (�Ϻ� ���� ������ 8���� ũ�Ⱑ ũ�Ƿ� �� ���̸� ���� �� ����.
    );