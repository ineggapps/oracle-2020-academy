--����

--���̺� �����
--������ ���̺� ����� ����
--CREATE TABLE ���̺��(
--    �÷��� Ÿ��[(ũ��)] [��������],
--    �÷��� Ÿ��[(ũ��)] [��������],
--    �÷��� Ÿ��[(ũ��)] [��������], ...
--);

--�߿��� Ÿ��
--VARCHAR2: �ؽ�Ʈ ����(1~4000bytes) --12c�̻󿡼��� 4000bytes �̻� ���� ����� ����.
--DATE
--NUMBER: ��ȿ�ڸ� �� 38�ڸ�
--CLOB: ��뷮 �ؽ�Ʈ ������ Ÿ�� (but, �ӵ��� �������Ƿ� �ʿ��� ������ Ÿ���� ����)
--BLOB: ��뷮 2�� ������ ����

--���̺� �÷� �߰��ϱ�
--ALTER TABLE ���̺�� ��ADD��(
--    �÷��� Ÿ��[(ũ��)] [��������],
--    �÷��� Ÿ��[(ũ��)] [��������],
--    �÷��� Ÿ��[(ũ��)] [��������], ...
--)

--���̺� �÷� �����ϱ�
--�����ǻ��� 
--�̹� �����Ͱ� �����ϸ� �÷��� ������ ������ �� ����.
--�����Ͱ� �����ϸ� ũ�⸦ ���� �� ����
--ALTER TABLE ���̺�� ��MODIFY��(
--  �÷��� Ÿ��[(ũ��)] [��������],
--)

--���� �÷� (VIRTUAL)
--�����͸� ������ ������ �ʰ� ������ ������ ����.
--GENERATED ALWAYS AS ���� VIRTUAL

--   �� ALTER TABLE ~ RENAME COLUMN
--   �÷��� �̸��� �����Ѵ�
--  ---------------------------------------------------------------
    ALTER TABLE ���̺�� RENAME COLUMN �����ϰ��� �ϴ� �÷��� TO ���ο� �̸�
    DESC emp2;
    --EMP2�� NUM => EMPNO��� �÷������� �����ϴ� ���
    ALTER TABLE emp2 RENAME COLUMN num TO empno;
    DESC emp2;
    
--
--   �� ALTER TABLE ~ DROP COLUMN
--  ���ʿ��� �÷��� �����Ѵ�
--     ---------------------------------------------------------------
--    ALTER TABLE ���̺�� DROP COLUMN �÷���
    DESC test;
    --test ���̺��� desc �÷��� �����ϱ�
    ALTER TABLE test DROP COLUMN dept;
    DESC test;
    
    --emp2���̺��� name�÷��� �����ϱ�
    SELECT * FROM emp2;
    ALTER TABLE emp2 DROP COLUMN name;
    --�÷��� ����� �����Ͱ� �̹� �����ϴ� ��� ���� �����ȴ�(�翬����).
    SELECT * FROM emp2;

--   �� ALTER TABLE ~ SET UNUSED
--   �����Ͱ� �����ϴ� �÷��� �����ϸ� �ð��� ���� �ҿ�ǹǷ� �÷��� �������� �ʰ�
--   �÷� ����� �������� ���� (�� �����Ͱ� ���� �����ϸ� �����ϴ� ������ �ð��� ���� �ɸ���)
--   �� �����ʹ� �������� ������ ���� ������ �� ����.
--1 Answer. You cannot reuse a unused column.
--  The only possible action on the column is to remove it from the table.
--  But you can add a new column with the same name, even without removing the unused column
-- https://stackoverflow.com/questions/13657497/how-to-reuse-the-unused-columns-again-in-oracle-db
-------------------------------------------------------------------------
    desc emp1;
    --emp1 ���̺��� pay �÷��� ����
    ALTER TABLE emp1 SET UNUSED (pay);
    desc emp1;
    select * from emp1;
--
--
--   �� ALTER TABLE ~ SET UNUSED�� ���� �������� ������ �÷��� ���� Ȯ��
--  �ٸ� ���̺��� ������ �÷��� ������ Ȯ���� �����ϰ� ������ �÷��� ���� ������ ���� Ȯ���� �Ұ����ϴ�.
---------------------------------------------------------------
   SELECT * FROM USER_UNUSED_COL_TABS;
--   TABLE_NAME, COUNT
--   EMP1, 1

--   �� ALTER TABLE ~ DROP UNUSED COLUMNS
--   UNUSED_COLUMN�� ���� �������� ������ �÷��� ������ �����ϴ� ���
--     ---------------------------------------------------------------
    ALTER TABLE emp1 DROP UNUSED COLUMNS;
    --������ �� Ȯ�� ���
    SELECT * FROM USER_UNUSED_COL_TABS;
--
--   ��  ���̺� ����
--    �� �� ����� ���������� ����� �۾��� �����ϱ� ������ ������ �Ұ����ϴٰ� ���!
--    ������ ����� ���뵵 �����.
-----------------------------------------------------------------
    DROP TABLE ���̺��; --���������� �̵�(���� ����)
    DROP TABLE ���̺�� PURGE; -- �ٷ� ������ (������ �Ұ����ϴ�)
--  ���̺� ���� �� ���̺��� ���� ��� ����
--  ���̺��� ������ ��� �⺻�����δ� �����뿡 ����.
--  ��ɾ �����Ѵٰ� �ؼ� ������ ���������� �ʴ´�. �������ǿ� ���� ������ ������ ���� ����.
--  ������ �����ϴ� �ɼ��� ���߿�...
    DESC demo;
    SELECT * FROM demo;
    DESC test;
    SELECT * FROM test;
    
    DROP TABLE demo; --����������
    DROP TABLE test; --����������
    SELECT * FROM TAB; -- ������ ���̺��� BIN$~ �� �̸��� ��ȯ�Ǿ��� ���̴�. 
    
    DROP TABLE emp4 PURGE; --�������� ��ġ�� �ʰ� �ٷ� ����
    SELECT * FROM tab; --���� �����Ǿ����Ƿ� ������ �� ����.
    
--  �����ڷ� �� ����� �߰� (�⺻ ������ sys, system���� �����ϴ�)
--  ����Ŭ�� ��ġ�Ǹ� 1���� �����ͺ��̽��� �����Ͽ� �������� ����
--  �����ͺ��̽��� ���� �� �ִ� ������ �����ϰ� sys�� �����ϴ�.
--  (�� DB 1���� ���μ��� 1���� �þ��)
--  Mysql�� ��쿡�� ���� ���� �����ͺ��̽��� ����ں��� ���� ���� ����
--  1. ����� ���� ����
    CREATE USER sky IDENTIFIED BY "��ȣ"; --12c�������ʹ� �̷��� ������ �� ����.
-- 18c���� 11g��� ����� �߰� ����(12c�̻��� �⺻������ c##����ڸ� �������� ����ڰ� �߰��ȴ�.
-- 11gó�� ����� ���ؼ��� ALTER SESSION SET "_ORACLE_SCRIPT" = true; �� �����ϸ� �����ϴ�.
-- �ɼ��� ������ ������...
--  2. ����ڿ��� ���� �ο�
    GRANT CONNECT, RESOURCE TO sky; --����ڿ��� ������ �� �ִ� ������ �ο��Ѵ�.
--  CONNECT: DB�� ������ �� �ִ� ����
--  RESOURCE: ���̺� �����̽�(�������� ������ �� �ִ� DB�� ����)�� ���ٰ����ϴ��� ����
    ALTER USER sky DEFAULT TABLESPACE USERS;
--  3. ����ڰ� ����� ���̺����̽� ����
--  �⺻������ TABLESPACE�� ����� ������ �ָ� �ý��� �����ڰ� ����ϴ� �������� �����ȴ�.
--  �̷��� ��� �� ������ �ջ�Ǹ� �ý��� �������� ������ ��ġ�Ƿ� �ٸ� �������� �Ҵ��Ѵ�.   
    ALTER USER sky TEMPORARY TABLESPACE TEMP; 
--  TEMPORARY�� GROUP BY ���� ������ �����ϴ� �ӽ����� ������ �ǹ���.
--  4. ����ڰ� ����� ���̺����̽� (12c�̻����) �뷮�� �����ؾ� ����� �����ϴ�.
--  SKY���� ���������� ������ ����� �� �ֵ��� ������ �Ҵ��Ͽ� ��.
    ALTER USER sky DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;
--
--   �� RENAME
--   ��ü��(���̺��)�� �ٲ� �� ���
-----------------------------------------------------------------
--   RENAME ���̸� TO ���̸�;
    RENAME emp2 TO demo;
    SELECT * FROM tab;
--
--   �� ������(RECYCLEBIN) ���� Ȯ��
--    - ������ ��ü(objects)Ȯ��
--     ---------------------------------------------------------------
    SELECT * FROM TAB; -- ������ ���̺� 2���� Ȯ�εȴ�.
    SELECT * FROM RECYCLEBIN; --���̺�, �ε��� �� ������ ������ Ȯ���� �� �ִ�.
    --���̺��� ���� �ε����� ������ �������� ���δ�.
    --TIP: �⺻Ű�� �־�� �ε����� �����ȴ�.
    DROP TABLE demo;
    SELECT * FROM RECYCLEBIN;

--   �� FLASHBACK TABLE
--  ������ ���̺� �����ϱ�
----------------------------------------------------------------- 
    FLASHBACK TABLE ���� �� �̸� TO BEFORE DROP [RENAME TO �ٲ��̸������̺��];    
    FLASHBACK TABLE ��ü �̸�(OBJECT_NAME BIN$���� �����ϴ� �͵�...)TO BEFORE DROP;    
    
    FLASHBACK TABLE test TO BEFORE DROP;
    SELECT * FROM TAB;
    --��, ������ ���̺� �� ���̺���� ��ġ�� ��쿡�� ���� �ϳ��� ��Ƴ���
    FLASHBACK TABLE demo TO BEFORE DROP;
    SELECT * FROM TAB;
    SELECT * FROM DEMO;
    --������ ���̺� ���� ���̺���� ��ġ�� ��쿡�� ���ϴ� ���̺� �ϳ��� �츱 �� �ִ�.
    --��, BIN$~�� Ư�����ڰ� �����Ƿ� �ֵ���ǥ�� ���ξ� �Ѵ�.
    FLASHBACK TABLE "BIN$dw6FEJa8S/WHNh6tOX26DA==$0" TO BEFORE DROP;
    SELECT * FROM TAB;
    SELECT * FROM demo;
    
    --�ٸ�, ������ ������ �Ȱ��� �̸��� ���̺��� ������ �̸����δ� ������ �� ����.
    FLASHBACK TABLE demo TO BEFORE DROP;--ORA-38312: ���� �̸��� ���� ��ü�� ���� ����
    --���� �̸��� �����Ͽ� ������ �� �ִ�.
    FLASHBACK TABLE demo TO BEFORE DROP RENAME TO emp2;
    SELECT * FROM tab;
    
--   �� ������ ����
    PURGE RECYCLEBIN; ������ ��ü ����
    PURGE TABLE Ư�� ���̺��
--     ---------------------------------------------------------------
    DROP TABLE test;
    DROP TABLE demo;
    DROP TABLE emp2;
    SELECT * FROM RECYCLEBIN;
--    �����뿡�� DEMO ���̺� ����
    PURGE TABLE demo;
    SELECT * FROM RECYCLEBIN;
--  ������ ��� ����
    PURGE RECYCLEBIN;
    SELECT * FROM RECYCLEBIN;

--   �� TRUNCATE
--   ���̺��� ������ �������� �Ȱ� �����͸� �����Ѵ�.
--  �ڵ����� COMMIT�ǹǷ� ������ �� ������ ����
--  WHERE���� ����.
--------------------------------------------------
    TRUNCATE TABLE ���̺��;
    
    SELECT * FROM emp1;
    TRUNCATE TABLE emp1;
    SELECT * FROM emp1;
    DESC emp1;
    DROP TABLE emp1 PURGE;
    