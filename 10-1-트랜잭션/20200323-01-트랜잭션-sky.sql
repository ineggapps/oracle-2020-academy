--�� Ʈ�����
-- �� Ʈ�����(Transaction)
--   �� COMMIT �� ROLLBACK
    CREATE TABLE emp1 AS SELECT empno, name, city FROM emp;
    INSERT INTO emp1 VALUES('9999','aaa','����');
    SELECT * FROM emp1;
    SAVEPOINT a;
    
    UPDATE emp1 SET city='bbb';
    SELECT * FROM emp1;
    ROLLBACK TO a;--SAVEPOINT a�� ������ ���Ŀ� �۾��� ���������� ROLLBACK�ȴ�    

    COMMIT;--COMMIT�� ������ �ѹ���� �ʴ´�.
        
--   �� Ʈ����� ���� ����
--     1) SET TRANSACTION
    
    ---SQL PLUS������
    SHOW AUTOCOMMIT; -- autocommit off: DML�� �ڵ����� COMMIT���� �ʴ´�.
    SET AUTOCOMMIT ON;
    SHOW AUTOCOMMIT; -- autocommit IMMEDIATE
    ---
    SELECT * FROM EMP1; -- �ٸ� �ܼ� â���� Ȯ���� ���Ƶ� �ڵ����� AUTO COMMIT�� ���� �� �� �ִ�.
    ---
    SET AUTOCOMMIT OFF;
    ---

    --DEVELOPER (CONNECTION#1)
    INSERT INTO emp1 VALUES('5555','b','b');
    --SQLPLUS (CONNECTION#2)
    SELECT * FROM emp1; --���� �߰��� ���� ������ ����
    --DEVELOPER #1
    COMMIT; 
    --SQLPLUS #2 Ŀ�� ���� �ٽ� ���̺� ��ȸ �õ�
    SELECT * FROM emp1; --���� �߰��� ���� ������ ����
    --DEVELOPER #1
    SET TRANSACTION  READ ONLY;--SELECT�� �����ϵ��� ���� Ʈ����� �����ϱ�
    DELETE FROM EMP1;--ORA-01456: READ ONLY Ʈ������� ����/����/������Ʈ �۾��� ������ �� �����ϴ�.
    ROLLBACK;
    SET TRANSACTION READ WRITE;--������ Ʈ������� �б⾲�Ⱑ �����ϵ��� ����
    
--     2) LOCK TABLE
    
    --DEVELOPER Ŀ�ؼ�#1
    SELECT * FROM emp1;
    UPDATE emp1 SET city='aaa' WHERE empno='1001';
    SET TIME ON;
    
    --SQLPLUS Ŀ�ؼ�#2
    SELECT * FROM emp1 FOR UPDATE WAIT 5;  --ORA-30006: ���ҽ� ��� ��. WAIT �ð� �ʰ��� ȹ���� ����� (5�� �� ����)
    
    --#1
    ROLLBACK;
    LOCK TABLE emp1 IN EXCLUSIVE MODE;--��� ���̺� �ٸ� Ŀ�ؼǵ��� DML ��ɾ� ����ϴ� ���� ������� ����
    --���� Ʈ������� ����ϰ� �ִ� �����Ϳ� ���� �ٸ� Ʈ������� �˻��̳� ������ ���´�.
    --DML �� COMMIT �Ǵ� ROLLBACK�� �ؾ� DML�� �����ϴ�.
    DELETE FROM emp1;
    
    --#2
    UPDATE emp1 SET city='aaa' WHERE empno='1001';
    
    --#1
    ROLLBACK;
    
--      -------------------------------------------------------
--      -- COMMIT�� ���� �ʴ� ���� Ȯ��
--      -- ������(sys �Ǵ� system) �������� Ȯ��
        SELECT s.inst_id inst, s.sid||','||s.serial# sid, s.username,
                    s.program, s.status, s.machine, s.service_name,
                    '_SYSSMU'||t.xidusn||'$' rollname, --r.name rollname, 
                    t.used_ublk, 
                   ROUND(t.used_ublk * 8192 / 1024 / 1024, 2) used_bytes,
                   s.prev_sql_id, s.sql_id
        FROM gv$session s,
                  --v$rollname r,
                  gv$transaction t
        WHERE s.saddr = t.ses_addr
        ORDER BY used_ublk, machine;
        
    --
    DROP TABLE emp1 PURGE;