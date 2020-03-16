--�� ������ ��ųʸ��� (���Ἲ) ��������
-- �� ���� ����(constraint) 
--  �����ͺ��̽��� �ϰ����� �����ϰ��� �ϰ��� �����ͺ��̽��� ���¸� �����ϴ� ��Ģ���� ������ �Ǵ� ��������� ����
-- ex: ������ 0������ 100���������� ������ ��ȿ�ϴ�.
-- ��, �����͸� �ϰ������� �Է��ϰų� �̰���Ű�� ��� ���������� �ɷ� ������ ���������� �ϳ��� �˻縦 �� �ϹǷ� ���ϰ� �ɸ���.
-- ��ó�� �����͸� �̰��� ���� ���������� ���ٰ� �����͸� �̰���Ű�� �ٽ� ���������� �Ҵ�.
-- �׷��� �������ǿ� ���� �ʴ� �����Ͱ� �Էµ� ��쿡�� ���������� ������ �ʴ´�.
--    �� �⺻ Ű(PRIMARY KEY)
--    1) ���̺� ������ ���ÿ� �⺻ Ű ����
--      �������� �̸��� ����Ŭ�� �����Ѵ�.
--      (1) �÷� ���� ����� PRIMARY KEY ����(inline constraint)
--        -------------------------------------------------------
        CREATE TABLE test1(
               id VARCHAR2(50) PRIMARY KEY,
               pwd VARCHAR2(100) NOT NULL,
               name VARCHAR2(30) NOT NULL
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST1';
        --�������ǿ� �̸� �ο�
        CREATE TABLE test2(-- ��������_���̺��_�÷���
            id VARCHAR2(50) CONSTRAINT pk_test2_id PRIMARY KEY, --Ű�� ���� Primary Key�� ���� PK�� �ش�.
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST2';        
--
--
--      (2) ���̺� ���� ����� PRIMARY KEY ����(out of line constraint)
--        -------------------------------------------------------
--      ���������� �̸��� �ο����� ����
        CREATE TABLE test3(-- ��������_���̺��_�÷���
            id VARCHAR2(50), --Ű�� ���� Primary Key�� ���� PK�� �ش�.
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL,
            PRIMARY KEY(id)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST3';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST3';        
--      �������ǿ� �̸��� �ο���
--      �� ���� �÷����� �⺻Ű ����(���̺� �����θ� �����ϴ�)
        CREATE TABLE test4(
            id VARCHAR2(50),
            code VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL,
            CONSTRAINT pk_test4_id PRIMARY KEY(id, code)
            --���̺� ������ �⺻Ű�� �� 1���� �����Ѵ�.
            --��, �⺻Ű�� ������ �� �� �� �̻��� �÷����ε� ������ �� �ִ�.
            --�׷��� ���̺� ���������� �� �� �̻��� �÷��� ���ÿ� ������ �� �ִ�.
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST4';
        
        --INSERT�� �ڷ� �Է� �׽�Ʈ
        INSERT INTO test4(id,code,name) VALUES('1','1','a');
        INSERT INTO test4(id,code,name) VALUES('1','2','a');
        INSERT INTO test4(id,code,name) VALUES('1','2','a');--���� ORA-00001: ���Ἲ ���� ����(SKY.PK_TEST4_ID)�� ����˴ϴ�.
        INSERT INTO test4(id,code,name) VALUES('','5','a');--���� ORA-01400: NULL�� SKY.TEST4.ID �ȿ� ������ �� �����ϴ�.
        --�⺻Ű�� ������ �÷��� �� ���� �÷����� �����Ǿ������� NULL���� �Է��� �� ����.
        UPDATE test4 SET CODE = '3' WHERE id='1' and code='2';--������Ʈ ����:�ߺ��� ���� ���� NULL���� �ƴϹǷ� ������ �����ϴ�.
        --�ٸ�, �⺻Ű ���� ������ ���(NULL ����, �ߺ� ��)���� ������ �Ұ����ϴ�.
        UPDATE test4 SET CODE = '1' WHERE id='1' and code='3';--ORA-00001 ���Ἲ �������� ����(�ߺ��� ���� ����)
                
        SELECT * FROM test4;
        COMMIT;
        
--
--    2) �����ϴ� ���̺� �⺻ Ű ����
--       -------------------------------------------------------
        CREATE TABLE test5(
            id VARCHAR2(50),
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(30)  NOT NULL
        );
        
        INSERT INTO test5(id, pwd, name) VALUES('1', '1', 'a');
        INSERT INTO test5(id, pwd, name) VALUES('1', '2', 'b');
        SELECT * FROM test5;
        
        ALTER TABLE test5 ADD CONSTRAINT pk_test5_id PRIMARY KEY (id);
        --ORA-02437: SKY.PK_TEST5_ID�� ������ �� �����ϴ�. - �߸��� �⺻ Ű�Դϴ�.
        --�ֳ��ϸ� id�÷��� �����Ͱ� 1�� ���� ��ġ�� �����̴�.
        
        UPDATE test5 SET id='2' WHERE id='1' and pwd='2';
        --�ߺ��� ���� ������ PRIMARY KEY�ε� �����ϰ� ������ �����ϴ�.
        SELECT * FROM test5;
        COMMIT;
        ALTER TABLE test5 ADD CONSTRAINT pk_test5_id PRIMARY KEY (id);
        
        --�⺻Ű�� ���������� �߰��Ǿ����� Ȯ���� �� �ִ� (PK_TEST5_ID)
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST5';

--    3) �⺻Ű ���� ���� ����
--       -------------------------------------------------------
        
--
--
--   �� UNIQUE ���� ����
--    1) ���̺� ������ ���ÿ� UNIQUE ���� ���� ����
--      (1) �÷� ���� ����� UNIQUE ���� ����
--        -------------------------------------------------------
--        --
--
--
--      (2) ���̺� ���� ����� UNIQUE ���� ���� ����
--        -------------------------------------------------------
--        --
--
--
--    2) �����ϴ� ���̺� UNIQUE ���� ���� ����
--     -------------------------------------------------------
--     --
--
--
--    3) UNIQUE ���� ���� ����
--      -------------------------------------------------------
--     --
--
--
--
--   �� NOT NULL ���� ����
--     1) ���̺� ������ NOT NULL ���� ���� ����
--       -------------------------------------------------------
--       --
--
--
--     2) �����ϴ� ���̺� NOT NULL ���� ���� ����
--       -------------------------------------------------------
--       --
--
--
--     3) NOT NULL ���� ���� ����
--       -------------------------------------------------------
--       --
--
--
--   �� DEFAULT
--     1) ���̺� ������ DEFAULT ����
--     -------------------------------------------------------
--     --
--
--
--     2) DEFAULT Ȯ��
--         SELECT column_name, data_type, data_precision, data_length, nullable, data_default 
--         FROM user_tab_columns WHERE table_name='���̺��';
--
--     3) DEFAULT ����
--       -------------------------------------------------------
--       --
--
--
--
--   �� CHECK ���� ����
--    1) ���̺� ������ ���ÿ� CHECK ���� ���� ����
--      (1) �÷� ���� ����� CHECK ���� ����
--       -------------------------------------------------------
--       --
--
--
--      (2) ���̺� ���� ����� CHECK ���� ����
--       -------------------------------------------------------
--       --
--
--
--    2) �����ϴ� ���̺� CHECK ���� ���� ����
--     -------------------------------------------------------
--     --
--
--
--    3) CHECK ���� ���� ����
--     -------------------------------------------------------
--     --
--
--
--
--   �� ���� Ű(�ܷ� Ű, FOREIGN KEY)
--     1) ���̺� ������ ���ÿ� FOREIGN KEY ���� ���� ����
--       (1) �÷� ���� ����� FOREIGN KEY ���� ����
--        -------------------------------------------------------
--        --
--
--
--       (2) ���̺� ���� ����� FOREIGN KEY ���� ����
--        -------------------------------------------------------
--        --
--
--
--     2) �����ϴ� ���̺� FOREIGN KEY ���� ���� ����
--       -------------------------------------------------------
--       --
--
--
--     3) FOREIGN KEY ���� ���� ����
--      -------------------------------------------------------
--       --
--
--
--
--   �� ���� ���� Ȱ��ȭ �� ��Ȱ��ȭ
--     1) �����ϴ� ���̺��� ���� ���� �� Ȱ��ȭ
--     -------------------------------------------------------
--     --
--
--
--     2) ���̺��� ���� ���� Ȱ��ȭ
--     -------------------------------------------------------
--     --
--
