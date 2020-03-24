--�� PL/SQL
-- �� Ŀ��(Cursor)
--     -------------------------------------------------------
--     -- �Ͻ��� Ŀ��
    DECLARE
        vEmpNo emp.empNo%TYPE;
        vCount NUMBER;
    BEGIN
        vEmpNo := '8001';
        DELETE FROM emp WHERE empno=vEmpNo;
        vCount := SQL%ROWCOUNT;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(vCount || ' ���ڵ� ����');
    END;
    /
    
    DECLARE
        vEmpNo emp.empNo%TYPE;
        vCount NUMBER;
    BEGIN
        vEmpNo := '8001';
        DELETE FROM emp WHERE empno=vEmpNo;
        vCount := SQL%ROWCOUNT;
        
        IF SQL%NOTFOUND THEN
            RAISE_APPLICATION_ERROR(-20001, '���ڵ尡 �����ϴ�.');
        END IF;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(vCount || ' ���ڵ� ����');
    END;
    /
--     -------------------------------------------------------
--     -- ����� Ŀ��
    DECLARE 
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
    BEGIN
        SELECT name, sal INTO vname, vsal FROM emp; 
        --������ �������� ���� ���: ORA-01422: ���� ������ �䱸�� �ͺ��� ���� ���� ���� �����մϴ�
--        WHERE empno = '1001';
        DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
    END;
    /

    DECLARE 
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. Ŀ�� ����
        CURSOR cur_emp IS SELECT name, sal FROM emp; --INTO�� ���� ���� ���� ������ó�� ����
        --�ֳ��ϸ� Ư�� ������ ��� ���� �ƴ� Ŀ�� ��ü�� ��� ������ intoŰ���尡 �ʿ���� �����̴�.
    BEGIN
        --2. Ŀ�� ����
        OPEN cur_emp; --open: ������ �������� �����ϴ� ��
        LOOP 
            --3. Ŀ�� FETCH�ϱ� (��������)
            --IN JAVA, ����Ŭ���� fetch �� ���� JAVA������ VO��ü �ϳ���� �����ϸ� �ȴ�.
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. Ŀ�� CLOSE
        CLOSE cur_emp;
    END;
    /
    
    --�Ķ���Ͱ� �ִ� Ŀ��
    CREATE OR REPLACE PROCEDURE pEmpSelect(
        pName VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. Ŀ�� ����
        CURSOR cur_emp(cname emp.name%TYPE) IS --Ŀ���� �Ķ���͸� ����� ��� (�Ķ�����̸� ����)
            SELECT name, sal FROM emp
            WHERE INSTR(name,cname)>0;
    BEGIN
        --2. Ŀ�� ����
        OPEN cur_emp(pName);
        --3. Ŀ�� FETCH�ϱ� (��������)
        --IN JAVA, ����Ŭ���� fetch �� ���� JAVA������ VO��ü �ϳ���� �����ϸ� �ȴ�.
        LOOP
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. Ŀ�� CLOSE
        CLOSE cur_emp;
    END;
    /
    
    EXEC pEmpSelect('��');
    
     --�Ķ���Ͱ� ���� Ŀ�� (���� �˻�)
    CREATE OR REPLACE PROCEDURE pEmpSelectWithoutCursorParameter(
        pName VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. Ŀ�� ����
        CURSOR cur_emp IS --Ŀ���� �Ķ���͸� ����� ��� (�Ķ�����̸� ����)
            SELECT name, sal FROM emp
            WHERE INSTR(name,pName)=1;
    BEGIN
        --2. Ŀ�� ����
        OPEN cur_emp;
        --3. Ŀ�� FETCH�ϱ� (��������)
        --IN JAVA, ����Ŭ���� fetch �� ���� JAVA������ VO��ü �ϳ���� �����ϸ� �ȴ�.
        LOOP
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. Ŀ�� CLOSE
        CLOSE cur_emp;
    END;
    /
    
    EXEC pEmpSelectWithoutCursorParameter('��');

    -- Ŀ�� FOR LOOP �ڵ� OPEN / �ڵ� CLOSE
    --OPEN�� CLOSE�� �ڵ����� �۾��Ǳ� ������ �������� ���� �ÿ��� ������ �߻��Ѵ�.
    CREATE OR REPLACE PROCEDURE pEmpSelect
    IS
        CURSOR cur_emp IS
            SELECT name, sal FROM emp;
    BEGIN
        FOR  rec IN cur_emp LOOP
              DBMS_OUTPUT.PUT_LINE(rec.name || ' : ' || rec.sal);
          END LOOP;
    END;
    /
    
    EXEC pEmpSelect;

--�ᳪ�߿� �н�
      -------------------------------------------------------------
      -- WHERE CURRENT OF : FETCH���� ���� ���� �ֱٿ� ó���� ���� ����
      DROP TABLE emp1 PURGE;
      CREATE TABLE  emp1  AS  SELECT * FROM  emp;
      SELECT * FROM EMP1;

      CREATE OR REPLACE  PROCEDURE pEmpUpdateSeoul
      IS
         vCnt   NUMBER;
         vName  emp1.name%TYPE;
         vSal   emp1.sal%TYPE;
         CURSOR  cur_emp  IS
             SELECT  name, sal  FROM  emp1  WHERE city='����'  FOR  UPDATE; 
               -- FOR  UPDATE : Ŀ���� �̿��Ͽ� UPDATE�� ��� �ݵ�� �ʿ�
      BEGIN
          vCnt := 0;
    
          OPEN  cur_emp;
          LOOP--Ŀ���� �̿��Ͽ� ���� �����ϱ� (�н���ǥ: CURRENT OF�� ����)
          --city�� ������ ������(cur_emp)�� ���Ͽ� ������ 1.1�� �λ�
              FETCH  cur_emp INTO  vname, vsal;
              UPDATE emp1 SET sal = TRUNC(sal * 1.1)  WHERE CURRENT OF cur_emp;
              EXIT WHEN  cur_emp%NOTFOUND; -- ������ �����͸� ó���Ҷ� ���ܰ� �߻���
              vCnt := vCnt + 1;
              DBMS_OUTPUT.PUT_LINE(vCnt || ':' || vname || ':' || (vsal*1.1));
          END LOOP;
          -- ���ܰ� �߻��Ͽ� ���� ���ϰ� EXCEPTION �� ����
          COMMIT;
          CLOSE cur_emp;
    
          EXCEPTION  WHEN  OTHERS THEN --JAVA�� CATCH����̶�� �����ϸ� ��
              COMMIT;
              DBMS_OUTPUT.PUT_LINE('���� �Ϸ� !!!');
      END;
      /

      EXEC pEmpUpdateSeoul;
      
      --�������� ���ܷ� �Ѿ�� �ݸ� �Ʒ�ó�� �����ϸ� ���� �߻��� ���� ��?
      CREATE OR REPLACE  PROCEDURE pEmpUpdateSeoul
      IS
         vCnt   NUMBER;
         vName  emp1.name%TYPE;
         vSal   emp1.sal%TYPE;
         CURSOR  cur_emp  IS
             SELECT  name, sal  FROM  emp1  WHERE city='����'  FOR  UPDATE; 
               -- FOR  UPDATE : Ŀ���� �̿��Ͽ� UPDATE�� ��� �ݵ�� �ʿ�
      BEGIN
          vCnt := 0;
    
          OPEN  cur_emp;
          LOOP--Ŀ���� �̿��Ͽ� ���� �����ϱ� (�н���ǥ: CURRENT OF�� ����)
          --city�� ������ ������(cur_emp)�� ���Ͽ� ������ 1.1�� �λ�
              FETCH  cur_emp INTO  vname, vsal;
              EXIT WHEN  cur_emp%NOTFOUND; -- ���� �ִ��� ������ �˻��ϸ�...
              UPDATE emp1 SET sal = TRUNC(sal * 1.1)  WHERE CURRENT OF cur_emp;
              vCnt := vCnt + 1;
              DBMS_OUTPUT.PUT_LINE(vCnt || ':' || vname || ':' || (vsal*1.1));
          END LOOP;
          -- ���ܰ� �߻��Ͽ� ���� ���ϰ� EXCEPTION �� ����
          COMMIT;
          CLOSE cur_emp;
    
          EXCEPTION  WHEN  OTHERS THEN --JAVA�� CATCH����̶�� �����ϸ� ��
              COMMIT;
              DBMS_OUTPUT.PUT_LINE('���� �Ϸ� !!!');
      END;
      /

--   �� Ŀ�� ����(cursor variable)
--     -------------------------------------------------------
--    �����͸� ������ �� 2�� �̻��� ������ ������ ���� ����
--���������������������� �߿��� ���ν���
    CREATE OR REPLACE PROCEDURE pEmpSelectList(
        pName IN VARCHAR2,
        pResult OUT SYS_REFCURSOR --��
    )
    IS
    BEGIN
        OPEN pResult FOR --��
            SELECT name, sal FROM emp
            WHERE INSTR(name,pName) > 0;
    END;
    /
    
    --SQL DEVELOPER������ OUT PARAMETER�׽�Ʈ�� ���� �� �ٸ� ���ν����� �ʿ��ϴ�.
    --�ܼ�Ȯ�ο� ���ν��� (���� �� ���ν����� �߿��ϹǷ� ������ ȯ���ϰ� �Ѿ��)
    CREATE OR REPLACE PROCEDURE pEmpSelectResult(--�ܼ� Ȯ�ο�
        pName IN VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        vResult SYS_REFCURSOR;
    BEGIN
        pEmpSelectList(pName, vResult); 
        LOOP --vresult�� ���� ������ ���� for������ �ƴ϶� LOOP�� ����ؾ� �Ѵ�
        --vresult�� open�� �Ǿ������� �� �Ǳ� ���� (���� �� ���ν������� �̹� open��)
            FETCH vResult INTO vname, vsal;
            EXIT WHEN vResult%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname||' : '||vsal);
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('���α׷��� ��');
    END;
    /
    
    EXEC pEmpSelectResult('��');


-- �� ��������(Dynamic SQL)
-- ��, CREATE TABLE�� CREATE SEQUENCE ������ �־�߸� ���� ������ ������ �� ����.
--EXECUTE IMMEDIATE�� �̿��Ͽ� ���̺� �ۼ� �� ������ �ۼ� ���� �ο� ��� (SYS)
GRANT CREATE TABLE TO sky;
GRANT CREATE SEQUENCE TO sky;
--sky����: ������ �ý��� ���� Ȯ���ϱ�
SELECT * FROM user_sys_privs; -- CREATE TABLE, CREATE SEQUENCE �׸� Ȯ���ϱ�!
--     -------------------------------------------------------
--     -- EXECUTE IMMEDIATE
--  �� ����ں��� �������� �Խ��� ���̺��� �����ϱ� ���ؼ��� ���� ������ �ʿ��ϴ�
    CREATE OR REPLACE PROCEDURE pBoardCreate(
        pName   VARCHAR2
    )
    IS
        s VARCHAR2(1000);
    BEGIN
        s := 'CREATE TABLE ' || pName;
        s := s || '(num NUMBER PRIMARY KEY, ';
        s := s || 'name VARCHAR2(30) NOT NULL, ';
        s := s || 'subject VARCHAR2(20) NOT NULL, ';
        s := s || 'content VARCHAR2(4000) NOT NULL, ';
        s := s || 'hitcount NUMBER DEFAULT 0, ';
        s := s || 'created DATE DEFAULT SYSDATE )';
        DBMS_OUTPUT.PUT_LINE(s);
        
        --�̹� �����ϴ� ���̺� ����
        FOR t IN (SELECT tname FROM tab WHERE tname=UPPER(pName)) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || pName || ' PURGE';
            DBMS_OUTPUT.PUT_LINE(pName || ' ���̺��� �����Ͽ����ϴ�.');
            EXIT;
        END LOOP;
        --���̺� ���� �����
        EXECUTE IMMEDIATE s;
        
        --�̹� �����ϴ� ������ ����
        FOR i IN (SELECT sequence_name FROM seq WHERE sequence_name=UPPER(pName||'_seq')) LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pName || '_seq';
            DBMS_OUTPUT.PUT_LINE(pName || ' _seq �������� �����Ͽ����ϴ�.');
        END LOOP;
        --������ ���� �����
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || pName || '_seq NOCACHE';
        DBMS_OUTPUT.PUT_LINE(pName || ' ���̺� �� ' || pName || '_seq �������� �ۼ��Ͽ����ϴ�.');
        
    END;
    /
    
    SELECT * FROM tab;
    SELECT * FROM seq;
    
    --EXEC �ڿ� �ּ� �ָ� �� �ȴ�.
    EXEC pBoardCreate('board');
    --(���� ������ ���� ���� ���) ORA-01031: ������ ������մϴ� insufficient privileges

--���� �н�

    CREATE OR REPLACE PROCEDURE DELETE_TABLE_WITH_SEQUENCE(
        pName VARCHAR2
    )
    IS
    BEGIN
        FOR t IN (SELECT tname FROM tab WHERE tname=UPPER(pName)) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || pName || ' PURGE';
            DBMS_OUTPUT.PUT_LINE(pName || '���̺��� �����Ͽ����ϴ�');
        END LOOP;
        
        FOR i IN (SELECT sequence_name FROM seq WHERE sequence_name=UPPER(pName||'_seq')) LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pName || '_seq';
            DBMS_OUTPUT.PUT_LINE(pName || '_seq �������� �����Ͽ����ϴ�.');
        END LOOP;
    END;
    /
    
    EXEC DELETE_TABLE_WITH_SEQUENCE('board');
    
    