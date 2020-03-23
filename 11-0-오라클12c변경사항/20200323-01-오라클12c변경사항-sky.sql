--�� ����Ŭ 12C���� ����� ����
-- �� 12C���� �߰��� ���ο� ���
--    �� Top-N ���
--      -----------------------------------------------
        SELECT * FROM emp;
        
        --ó������ 3�� (12c)
        SELECT * FROM emp
        FETCH FIRST 3 ROWS ONLY;
        
        --ó������ 3�� (legacy)
        SELECT * FROM emp
        WHERE ROWNUM <= 3;
        
        --�޿� �������� �����Ͽ� ó������ 3�� (x)
        SELECT * FROM EMP 
        WHERE ROWNUM <=3
        ORDER BY sal DESC;--����� �ǵ��� ��� ��µ��� �ʾ���.
        
        --11g ���
        SELECT * FROM ( --���� ��Ŀ����� ���������� ����ؾ� �ùٸ� ����� ��µȴ�.
            SELECT * FROM EMP
            ORDER BY sal DESC
        ) WHERE ROWNUM<=3;

        --12c���
        SELECT * FROM EMP 
        ORDER BY sal DESC
        FETCH FIRST 3 ROWS ONLY;        
        
        --�޿� �������� �����ؼ� 2�� �ǳʶ� �� 3�� 
        SELECT * FROM emp
        ORDER BY sal DESC
        OFFSET 2 ROWS FETCH FIRST 3 ROWS ONLY;

        --�޿� ���� 10%
        SELECT * FROM emp
        ORDER BY sal DESC
        FETCH FIRST 10 PERCENT ROWS ONLY;
        
        --�ڡڡڡڡ�(�ϱ�) 11g ����¡ ó��
        -- ������ ������ 10�����
        -- sal �������� �����ؼ� 21~30������ ��ȸ (3������)
            SELECT * FROM (
            SELECT ROWNUM rnum, tb.* FROM (
                SELECT name, sal FROM emp
                -- WHERE ��
                ORDER BY sal DESC
            ) tb WHERE ROWNUM <= 30
         ) WHERE rnum >= 21; --�ȿ� �ִ� SELECT���� ROWNUM�� rnum�� �̿��ؾ� ��.        
        --�ڡڡڡ�(�ϱ�) 12c ����¡ ó��
        SELECT * FROM emp
        ORDER BY sal DESC
        OFFSET 20 ROWS FETCH FIRST 10 ROWS ONLY;

--    �� INVISIBLE column (�ܼ��� �������� ����)
--      -----------------------------------------------
--      INVISIBLE �����ߴ� �÷��� �ٽ� VISIBLE�� �����ϸ� �÷��� �� ���ʿ� ��ġ�ȴ�.
--      COLS�θ� INVISIBLE�÷��� ���δ�
--      USER_TAB_COLS���� HIDDEN_COLUMN�÷����� INVISIBLE �÷� ���θ� �� �� �ִ�.
        
        CREATE TABLE test(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            tel VARCHAR2(30) INVISIBLE
        );
        desc TEST; --invisible �÷��� ������ ����
        SELECT * FROM COLS WHERE TABLE_NAME='TEST'; --invisible �÷����� ���δ�
        SELECT column_name, hidden_column FROM user_tab_cols WHERE TABLE_NAME='TEST'; --hidden_column�÷��� �����ϸ� INVISIBLE �÷��� YES��� �׸��� Ȯ���� �� �ִ�.
        
        INSERT INTO test VALUES (1, 'a');
        INSERT INTO test VALUES (2, 'b','010');--ORA-00913: ���� ���� �ʹ� �����ϴ�. (invisible �÷����� ���� ��������� ������ ������ �߻��Ѵ�)
        INSERT INTO test(num, name, tel) VALUES(2,'b','010');
        
        SELECT * FROM test; --INVISIBLE �÷�(tel)�� *�� ����Ͽ��� ������ �ʴ´�.
        SELECT num, name, tel FROM test; -- �÷��� ��������� �����Ͽ��߸� Ȯ���� �� �ִ�.
        
        -- INVISIBLE �÷��� VISIBLE �÷����� �����ϴ� ���
        ALTER TABLE test MODIFY (tel VISIBLE);
        DESC test; --TEL�÷��� ������ ���̴� ���� Ȯ���� �� �ִ�.
        
        DELETE FROM test;
        COMMIT;
        --tel �÷��� not null�Ӽ� �ֱ�
        ALTER TABLE test MODIFY (tel NOT NULL);
        ALTER TABLE test MODIFY (tel INVISIBLE);
        INSERT INTO test VALUES (1, 'a');--����.  ORA-01400: NULL�� ("SKY"."TEST"."TEL") �ȿ� ������ �� �����ϴ�
        --�ƹ��� ������ INVISIBLE�÷��̶�� �ϴ��� ���������� �����Ѵ�.
        DROP TABLE test PURGE;
        
--    �� IDENTITY column �ڵ����� ���ڰ� �����Ǵ� IDENTITY COLUMN;
--      �ڵ����� �÷�
--      ���������δ� �������� ����Ͽ� �����Ѵ�.
--      BUT ���߿� �������� ���� ��, ���� ���� �������Ⱑ ���ŷӴ�.
--      -----------------------------------------------
        CREATE TABLE test(
            num NUMBER GENERATED AS IDENTITY PRIMARY KEY, --IDENTITY column
--            num NUMBER GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY, --IDENTITY column
        --START WITH ���۰� INCREMENT BY ������
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test VALUES('a'); --SQL ����: ORA-00947: ���� ���� ������� �ʽ��ϴ�
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(subject) VALUES('b');        
        SELECT * FROM test;
        -- �� ���ǻ���
        ROLLBACK;
        --�������� �����ϰ� �ѹ��Ѵٰ� �Ͽ��� IDENTITY �÷��� ���� ó������ ���ư��� �ʴ´�.
        --�� ���������� �������� �����߱� ����
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(subject) VALUES('b');        
        SELECT * FROM test;         
        
        INSERT INTO test(num, subject) VALUES(1, 'x');--ORA-32795: generated always ID ���� ������ �� �����ϴ�.        
        --�⺻�� ALWAYS �� IDENTITY �÷��� INSERT, UPDATE �� ���� �Ұ�
        
        SELECT * FROM seq;--ISEQ$$_74638
        SELECT * FROM user_objects;--ISEQ$$_74638
    
        SELECT ISEQ$$_74638.CURRVAL FROM dual; -- ������ó�� ������ Ŀ�� ���� ��ȸ�� �� �ִ�.
        --CURRVAL => 4������ ����Ǿ����Ƿ� 4�� ���´�.
        
        --������ �������� �̸��� �˾Ƴ��Ⱑ ����� ������ �� ������� �ʴ´�.
        --EX) ����Ŭ�� �缳ġ�ϰų� �ٸ� DB�� ���̺��� ������ ��� �̸��� �ٲ�� ����.
        
        --IDENTITY �÷��� INSERT, UPDATE �� ���� ���� �ϵ���(�� ���� ����)
        DROP TABLE test PURGE;
        
         CREATE TABLE test(
            num NUMBER GENERATED BY DEFAULT AS IDENTITY, --IDENTITY column
--            num NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY, --IDENTITY column
        --START WITH ���۰� INCREMENT BY ������
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test(subject) VALUES('a');
        SELECT * FROM test;
        INSERT INTO test(num, subject) VALUES(2, 'b');
        SELECT * FROM test;
        INSERT INTO test(subject) VALUES('c');--BY DEFAULT ������ ���� �⺻���� 2�� �߰��Ǿ� ���� ���Եȴ�.
        SELECT * FROM test; 
        SELECT * FROM SEQ;
        SELECT ISEQ$$_74641.currval from dual; 
        
        ALTER TABLE test MODIFY (num NUMBER GENERATED ALWAYS AS IDENTITY);
        INSERT INTO test(num, subject) VALUES(33, 'd');--SQL ����: ORA-32795: generated always ID ���� ������ �� �����ϴ�.
        --EX) �Խ����� ���� �� IDENTITY COLUMN�� ����ϱ⿡ �����ϴ�
        
        DROP TABLE test PURGE;

--    �� DEFAULT ��
--      -----------------------------------------------
        --12c���ʹ� CREATE, ALTER���� DEFAULT �������� NEXTVAL, CURRVAL���  ����
        
        CREATE SEQUENCE t_seq;   
        CREATE TABLE test(
            num NUMBER DEFAULT t_seq.NEXTVAL,
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(num, subject) VALUES(NULL, 'b'); --num�� null���� ���Եȴ�
        INSERT INTO test(subject) VALUES('c');
        
        SELECT * FROM test;
        
        DROP SEQUENCE t_seq;
        DROP TABLE test PURGE;
        
        --NULL�� ���� DEFAULT 
        CREATE SEQUENCE t1_seq;
        CREATE SEQUENCE t2_seq;
        
        CREATE TABLE test(
            col1 NUMBER DEFAULT  t1_seq.NEXTVAL,
            col2 NUMBER DEFAULT ON NULL t2_seq.NEXTVAL, --NULL�� ��� NEXTVAL���� �����϶�� �ǹ��̴�.
            memo VARCHAR2(100)
        );
        
        INSERT INTO test(memo) VALUES('a'); --1 1 a
        INSERT INTO test(col1, col2, memo) VALUES(999,999,'b');--999 999 b
        INSERT INTO test(col1, col2, memo) VALUES(NULL,NULL,'b');--NULL 2 b
        
        SELECT * FROM test;
        
        
        DROP SEQUENCE t1_seq;
        DROP SEQUENCE t2_seq;
        DROP TABLE test PURGE;