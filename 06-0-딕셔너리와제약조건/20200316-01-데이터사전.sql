--������ ����
--DB�ڿ��� ȿ�������� �����ϱ� ���� �پ��� ������ �����ϴ� �ý��� ���̺� (���� ����, ������ �� ����)
--����Ŭ�� ������ ������ ���������� �����Ͽ� �����ͺ��̽� ����, ����, ����� ����, ������ ���� ��������� �ݿ��Ѵ�. 

--Synonym ���Ǿ�
--������ �������� Synonym ���� ���̺�/�䰡 �ִ�. (ex: USER_TABLES�� Synonym�� TABS�̴�.)

SELECT * FROM USER_TABLES;
SELECT * FROM TABS;

--�׷��� TAB�� ����� ���� ���̰� �ִ�.
SELECT * FROM TAB;


SELECT * FROM USER_TABLESPACES;
SELECT * FROM USER_USERS;

�� ������ ��ųʸ��� ��������
 �� ������ ��ųʸ�(Data Dictionary)
   �� �ֿ� ������ ����
     -- ��� ������ ���� ���̺� ���� Ȯ��
        SELECT * FROM DICTIONARY;
        SELECT COUNT(*) FROM DICTIONARY; --1055��

     -- ���� ������� ��� ��ü ����
        SELECT * FROM USER_OBJECTS; --TABLE�� INDEX�� ���� ���δ�.

     -- ���̺� ���� Ȯ��
        SELECT * FROM TAB;
        SELECT * FROM TABS;

     -- ���̺��� �÷� ���� Ȯ��(���̺���� �빮�ڷ�)
        SELECT * FROM COLS; -- ==USER_TAB_COLUMNS
        SELECT * FROM USER_TAB_COLUMNS;
        SELECT * FROM COL;
        
        SELECT * FROM col WHERE tname='EMP';
        SELECT * FROM COLS WHERE table_name='EMP';
        DESC emp;

     -- �������� Ȯ��
        -- � �÷��� ���������� �ο��Ǿ����� Ȯ���� �Ұ�(���̺���� �빮�ڷ�)
        -- constraint_type �� P:�⺻Ű, C:NOT NULL ��, U:UNIQUE, R:����Ű ��
    
        SELECT * FROM USER_CONSTRAINTS;

     -- ���� ����ڰ� ������ �ִ� �÷��� �ο��� �������� ���� Ȯ��
        -- � �÷��� ���������� �ο��Ǿ����� Ȯ�� ����
        -- ���� ������ ������ Ȯ�� �Ұ���

        SELECT * FROM user_cons_columns; --���������� ��ü���� ������ �𸣳� ������ ���̺��� �÷����� ���� ����
    
     -- �ڡڡڡڡ� ���⼭���ʹ� �ڵ带 �ϱ����� ���� �ٿ��ֱ��ϰ� ����Ѵ�.
     -- �������� �� �÷� Ȯ��
        SELECT u1.table_name, column_name, constraint_type, u1.constraint_name 
        FROM user_constraints u1
        JOIN user_cons_columns u2
        ON u1.constraint_name = u2.constraint_name
        WHERE u1.table_name = UPPER('���̺��'); --R:Reference key, P:Primary key, U:Unique key

     -- �ο� �� ������ ��� ���̺� ���
        SELECT fk.owner, fk.constraint_name,
                    pk.table_name parent_table, fk.table_name child_table
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_type = 'R'
        ORDER BY fk.table_name;

     -- �����̺���� �����ϴ� ��� ���̺� ��� ���(�ڽ� ���̺� ��� ���)
        SELECT fk.owner, fk.constraint_name , fk.table_name 
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name 
                   AND fk.constraint_type = 'R'
                   AND pk.table_name = UPPER('���̺��')
        ORDER BY fk.table_name;
 
     -- �����̺���� �����ϰ� �ִ� ��� ���̺� ��� ���(�θ� ���̺� ��� ���)
        SELECT table_name FROM user_constraints
        WHERE constraint_name IN (
              SELECT r_constraint_name 
              FROM user_constraints
              WHERE table_name = UPPER('���̺��') AND constraint_type = 'R'
          );

     -- �����̺���� �θ� ���̺� ��� �� �θ� �÷� ��� ���
        --  �θ� 2�� �̻����� �⺻Ű�� ���� ��� ������ ��� ��
        SELECT fk.constraint_name, fk.table_name child_table, fc.column_name child_column,
                    pk.table_name parent_table, pc.column_name parent_column
        FROM all_constraints fk, all_constraints pk, all_cons_columns fc, all_cons_columns pc
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_name = fc.constraint_name
                   AND pk.constraint_name = pc.constraint_name
                   AND fk.constraint_type = 'R'
                   AND pk.constraint_type = 'P'
                   AND fk.table_name = UPPER('���̺��');