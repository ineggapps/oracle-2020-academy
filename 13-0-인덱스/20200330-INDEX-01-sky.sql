--�� �ε���(index)
-- �� �ε���
--�ε��� Ȯ���ϱ�

--����ڰ� ������ �ε����� ���� ���� Ȯ���ϱ�
SELECT * FROM user_indexes;
SELECT index_name, index_type, table_owner, table_name FROM user_indexes;

--�ε��� �÷��� ���� ���� Ȯ��
SELECT index_name, table_name, column_name FROM user_ind_columns;

--�ε��� �����ϱ�
DROP INDEX index_name;

---------------------------------------------------
       -- ����
         -- UNIQUE �ɼ��� ����ڰ� ���� unique�� �ε����� �����ϰ� �� �� ����Ѵ�. ����Ʈ�� non-unique �ε����� �����Ѵ�.
         -- ���� �ߺ����� ���� ����, ���� �ߺ����� ���� ������ ���ɼ��� �ִ� ��� UNIQUE �ε����� �������� �ʴ´�.

         -- B-Tree �ε���
             CREATE INDEX �ε����� ON ���̺��(�÷���, ...);

             -- ���� �ε���(Single Index) : �ϳ��� �÷��� ����Ͽ� �ε����� ����� ��
                 CREATE INDEX �ε����� ON ���̺��(�÷���);

             -- ���� �ε���(Composite Index) : �ΰ� �̻��� �÷��� ����Ͽ� �ε����� ����� ��
                CREATE INDEX �ε����� ON ���̺��(�÷���, �÷���, ...);

             -- ���� �ε���(Unique INdex) : ������ ���� ���� �÷��� ���ؼ��� �ε����� ����
                 CREATE UNIQUE INDEX �ε����� ON ���̺��(�÷���, ...);

         -- Bitmap �ε���(Express�� �������� ����)
             CREATE BITMAP INDEX �ε����� ON ���̺��(�÷���, ...);

         -- �Լ���� �ε���
             CREATE INDEX �ε����� ON ���̺��(�Լ���(�÷���) | �����);

         -- ������ �ε���
             CREATE INDEX �ε����� ON ���̺��(�÷���1,�÷���2, ...) REVERSE;

         -- �������� �ε��� (Ex: �Խ��� ����, ���� �ŷ�����)
             CREATE INDEX �ε����� ON ���̺��(�÷���1,�÷���2, ... DESC);

       ---------------------------------------------------
       -- ����
       
       --WITHOUT INDEX
    SELECT * FROM emp;
    SELECT * FROM emp WHERE name='�ɽ���'; --0.001��
    
    -- WITH B-TREE INDEX
    CREATE INDEX idx_emp_name ON emp(name);
    SELECT * FROM emp WHERE name='�ɽ���'; --0.002, 0.001, 0��
    
    SELECT * FROM user_indexes WHERE table_name='EMP';
    
    -- DROP INDEX
    DROP INDEX idx_emp_name;    
    
    --���� �ε���
    --AND���길 �����ϴ�. OR������ ��� �ε����� ������ ����.
    --AND�� �߶󳻴� ���̹Ƿ� ������ �߿��ϴ�.
    --���ʿ� �� ���� �ڸ� �� �ִ� ������ �����Ѵ�. (�̸��� ������� �ɷ��� �ϸ� �̸� ���� �Ÿ���. ���������� �� ���� Ȯ���� ũ�ϱ�.)
    CREATE INDEX idx_emp_comp ON emp(name, city);

    SELECT name, city FROM emp WHERE name='�ɽ���' and city='����'; 
    DROP idx_emp_comp; 
    
    --�Լ���� �ε���
    CREATE INDEX idx_emp_fun ON emp(MOD(SUBSTR(rrn,8,1),2));
    SELECT * FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=1;
    DROP INDEX idx_emp_fun;
    
    
    �� �ε��� ����
       ---------------------------------------------------
       -- ����
        
    CREATE INDEX idx_emp_name ON emp(name);
    --�ε����� �����
    ALTER INDEX idx_emp_name REBUILD;

    --����͸� ����
    ALTER INDEX idx_emp_name MONITORING USAGE;
    --�ε��� ��� ���� Ȯ��
    SELECT * FROM v$object_usage;
    --  used: NO
    --�˻�
    SELECT name, sal FROM emp WHERE name='�ɽ���';
    
    SELECT * FROM v$object_usage;
    -- used:YES
    
    --����͸� ����
    ALTER INDEX idx_emp_name NOMONITORING USAGE;
    
    CREATE TABLE test(
        num NUMBER
    );
    
    BEGIN
        FOR n IN 1 .. 10000 LOOP
            INSERT INTO test VALUES(n);
        END LOOP;
        COMMIT;
    END;
    /
    
    SELECT * FROM test;
    SELECT COUNT(*) FROM test;
    -- �ε��� ����
    CREATE INDEX idx_test_num ON test(num);
    
    --�ε��� �м�
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT * FROM index_stats;
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0
    
    --����
    DELETE FROM test WHERE num <= 4000;
    COMMIT;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0 (���� ���� �м�)
    
    --�ٽ� �м�
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- �� 40%�� �����Ͱ� �սǵǾ��ٴ� �ǹ� (39.96034739420965147095146227328255485611)
    
    --�ε��� ����
    ALTER INDEX idx_test_num REBUILD;

    --�ٽ� �м�  
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0
    

    