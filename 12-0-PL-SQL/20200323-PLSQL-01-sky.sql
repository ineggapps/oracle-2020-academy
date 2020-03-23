--�� PL/SQL
-- �� DBMS_OUTPUT.PUT_LINE�� SQL PLUS���� ������ ��ɾ�� Ȯ���� �� �ִ�.
--DBMS_OUTPUT:��� Ȯ��
SET SERVEROUTPUT ON
-- �� �⺻ ����
--   �� �⺻ ����
--     -------------------------------------------------------
--    %TYPE: ���̺��� �÷��� �ڷ����� ����
    DECLARE
        --���� ���� vname(emp.name�� Ÿ�԰� �����ϰ�), vpay (����)
        vname emp.name%TYPE; --varchar(30)
        vpay NUMBER;
    BEGIN
        SELECT name, sal+bonus INTO vname, vpay 
        FROM emp WHERE empNo='1001';
        --�ϳ��� �ุ ������ �� �����Ƿ� WHERE�������� 1���� �ุ ��ȯ�ǵ��� ���������� ������ ������ �߻��Ѵ�.
        --WHERE���ǿ� �������� �ʾ� �ƹ� �൵ ��ȯ���� �ʾƵ� ������ �߻��Ѵ�.
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vname);--����� �׽�Ʈ�� ����
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vpay);
    END;
    /
    
    --    %ROWTYPE: ���̺��� ���� �����ϴ� ���ڵ� ����
    DECLARE
        --���� ���� vname(emp.name�� Ÿ�԰� �����ϰ�) (����)
        vrec emp%ROWTYPE;
    BEGIN
--        SELECT name, sal INTO vrec.name, vrec.sal
--        FROM emp WHERE empNo='1002';
        SELECT * INTO vrec FROM EMP WHERE empno='1001';
        --�ϳ��� �ุ ������ �� �����Ƿ� WHERE�������� 1���� �ุ ��ȯ�ǵ��� ���������� ������ ������ �߻��Ѵ�.
        --WHERE���ǿ� �������� �ʾ� �ƹ� �൵ ��ȯ���� �ʾƵ� ������ �߻��Ѵ�.
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vrec.name);--����� �׽�Ʈ�� ����
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vrec.sal);
    END;
    /
    
    -- ����� ���� ���ڵ�
    DECLARE
        TYPE mytype IS RECORD -- JAVA�� ġ�� Ŭ����ó�� �ϳ��� �ڷ����� ����
        (
            name emp.name%TYPE,
            sal emp.sal%TYPE
        );
        vrec MYTYPE;
    BEGIN
        SELECT name, sal INTO vrec.name, vrec.sal
        FROM emp WHERE empNo='1001';
        --�ϳ��� �ุ ������ �� �����Ƿ� WHERE�������� 1���� �ุ ��ȯ�ǵ��� ���������� ������ ������ �߻��Ѵ�.
        --WHERE���ǿ� �������� �ʾ� �ƹ� �൵ ��ȯ���� �ʾƵ� ������ �߻��Ѵ�.
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vrec.name);--����� �׽�Ʈ�� ����
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vrec.sal);
    END;
    /
    
--   �� ���� ����
--     -------------------------------------------------------
--     -- IF
    DECLARE
        a NUMBER := 10; --���Կ����ڴ� =�� �ƴ϶� :=�� ����Ѵ�.
    BEGIN
        IF MOD(a, 6) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(a || '�� 2 �Ǵ� 3�� ���');
        --ELSE IF�� �ƴ϶� ELSIF�ӿ� �����Ѵ�
        ELSIF MOD(a,3) = 0 THEN
           DBMS_OUTPUT.PUT_LINE(a || '�� 3�� ���');
        ELSIF MOD(a,2) = 0 THEN
           DBMS_OUTPUT.PUT_LINE(a || '�� 2�� ���');
        ELSE
           DBMS_OUTPUT.PUT_LINE(a||'�� 2 �Ǵ� 3�� ����� �ƴ�');
        END IF;
    END;
    /
    
    --����1) EMPNO�� 1001�� ���ڵ�
    --�̸�(name), �޿�(sal+bonus), ���� ���
    --������ sal+bonus�� 300�� �̻� 3%, 200�� �̻� 2%, ������ 0
    --�Ҽ��� ù °�ڸ� �ݿø�

    DECLARE
        vrec emp%ROWTYPE;
        vpay NUMBER;
        vtax NUMBER;
    BEGIN
        SELECT * INTO vrec FROM emp WHERE empNo='1007';
        vpay := vrec.sal + nvl(vrec.bonus,0);
        IF vpay >= 3000000 THEN
            vtax := round(pay*0.03);
        ELSIF vpay >= 2000000 THEN
            vtax := round(pay*0.02);
        ELSE
            vtax := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vrec.name);
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vpay);
        DBMS_OUTPUT.PUT_LINE('����: ' || vtax);
    END;
    /
    
    --������ ���
    DECLARE
--        vname VARCHAR(30);
        vname emp.name%TYPE;
        vpay NUMBER;
        vtax NUMBER;
    BEGIN
        SELECT name, sal+bonus INTO vname, vpay
        FROM emp WHERE empNo='1001';
        IF vpay>=3000000 THEN
            vtax := ROUND(vpay * 0.03);
        ELSIF vpay >= 2000000 THEN
            vtax := ROUND(vpay * 0.02);
        ELSE 
            vtax := 0;
        END IF;
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vname);
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vpay || ', ����: ' || vtax);
    END;
    /
    
--     -------------------------------------------------------
--     -- CASE
-- ����� CASE WHEN THEN�� ������
--     -------------------------------------------------------
--     -- basic LOOP, EXIT, CONTINUE
--      ���ѷ���. EXIT�� ���� ������ ��� ��ȯ�Ѵ�.
    DECLARE
        n NUMBER := 0;
        s NUMBER := 0;
    BEGIN
        LOOP
            n := n+1;
            CONTINUE WHEN n=1;
            s := s + n;
            EXIT WHEN n=100;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('n= ' || n);
        DBMS_OUTPUT.PUT_LINE('���(100�� �� -1) : ' || s);
    END;
    /

--     -------------------------------------------------------
--     -- WHILE-LOOP
    DECLARE
        n NUMBER := 0;
        s NUMBER := 0;
    BEGIN
        WHILE n < 100 LOOP
            n := n+1;
            s := s + n;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('n= ' || n);
        DBMS_OUTPUT.PUT_LINE('���(100�� ��) : ' || s);
    END;
    /

--����2) 1~100 �� Ȧ���� ��
    DECLARE
        n NUMBER := 1;
        s NUMBER := 0;
    BEGIN
        WHILE n < 100 LOOP
            s := s + n;
            n := n + 2;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('n= ' || n);
        DBMS_OUTPUT.PUT_LINE('���(100�� ��) : ' || s);
    END;
    /
    
    --������ ����ϱ�
    DECLARE
        a NUMBER;
        b NUMBER;
    BEGIN
        a :=1;
        while a<9 LOOP
            a := a+1;
            DBMS_OUTPUT.PUT_LINE('**' || a || ' �� **');
            b := 0;
            WHILE b<9 LOOP
                b := b+1;
                DBMS_OUTPUT.PUT_LINE(a || '*' || b || '=' || (a*b));
            END LOOP;
                DBMS_OUTPUT.PUT_LINE('');
        END LOOP;
    END;
    /
--     -------------------------------------------------------
--     -- FOR-LOOP
--  ����: ���� ������ ������ ���� ����.
--  ����: ��1�� �����ۿ� �� �ȴ�.

DECLARE
    s NUMBER := 0;
BEGIN
    --for �ݺ� ������ �������� �ʴ´�. �ڵ� �����
    FOR n IN 1 .. 100 LOOP
        s := s + n;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('���: '|| s);
END;
/

DECLARE
--A~Z���� ���������� ���
BEGIN
    --for �ݺ� ������ �������� �ʴ´�. �ڵ� �����
    FOR n IN 65 .. 90 LOOP
        DBMS_OUTPUT.PUT(CHR(n)); --��� �� ���� �ѱ��� ����
        --PUT_LINE(), NEW_LINE()�� ������ ��µ�
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); --���� �ѱ�
END;
/    

DECLARE
--Z~A ������ ���
BEGIN
    --for �ݺ� ������ �������� �ʴ´�. �ڵ� �����
    FOR n IN REVERSE 65 .. 90 LOOP
        DBMS_OUTPUT.PUT(CHR(n)); --��� �� ���� �ѱ��� ����
        --PUT_LINE(), NEW_LINE()�� ������ ��µ�
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); --���� �ѱ�
END;
/    

--     -------------------------------------------------------
--     -- SQL Cursor FOR LOOP

    DECLARE
        vrec emp%ROWTYPE;
    BEGIN
        SELECT * INTO vrec FROM EMP;
        --���� �߻� ORA-01422: ���� ������ �䱸�� �ͺ��� ���� ���� ���� �����մϴ�
        DBMS_OUTPUT.PUT_LINE('�̸�: ' || vrec.name);--����� �׽�Ʈ�� ����
        DBMS_OUTPUT.PUT_LINE('�޿�: ' || vrec.sal);
    END;
    /

    --FOR������ SELECT���� ������ �� ���� ���Ѵ�
    DECLARE
    BEGIN
        FOR rec IN (SELECT empno, name, sal FROM emp) LOOP
        --���� �߻� ORA-01422: ���� ������ �䱸�� �ͺ��� ���� ���� ���� �����մϴ�
        DBMS_OUTPUT.PUT_LINE( rec.empno || ' ' || rec.name || ' ' || rec.sal);--����� �׽�Ʈ�� ����
        END LOOP;
    END;
    /