-- �� ��Ű��(Package)
------------------------------------------------------------
-- ��Ű�� ��� Ȯ��
SELECT * FROM user_objects WHERE object_type = 'PACKAGE';
SELECT * FROM user_objects;
SELECT * FROM user_procedures;
-- ��Ű���� ���� ���õ� �ϳ� �̻��� ���ν����� function, type�� ��Ƶ� ����.
-- ��Ű�� ����
CREATE OR REPLACE PACKAGE pEmp IS
    --��Ű�� ���� �ÿ��� �Լ�,���ν����� ������ ���� �ʰ� ���� �Ѵ�.
    FUNCTION fnTax(p IN NUMBER) RETURN NUMBER;
    PROCEDURE empList(pName VARCHAR2);
    PROCEDURE empList;
END pEmp;
/

--��ü ���� (���ν���, �Լ����� ���� �ۼ�)
CREATE OR REPLACE PACKAGE BODY pEmp IS
    FUNCTION fnTax(p IN NUMBER) 
    RETURN NUMBER
    IS
        t NUMBER := 0;
    BEGIN
        IF p >= 3000000 THEN t := TRUNC(p * 0.03, -1);
        ELSIF p >= 2000000 THEN t := TRUNC(p * 0.02, -1);
        ELSE t:=0;
        END IF;
        RETURN t;
    END;
    
    PROCEDURE empList(pName VARCHAR2)
    IS
        vName VARCHAR2(30);
        vSal NUMBER;
        CURSOR cur_emp IS 
            SELECT name, sal FROM emp WHERE INSTR(name, pName)=1;
    BEGIN
        OPEN cur_emp;
        LOOP   
            FETCH cur_emp INTO vName, vSal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vName || ' ' || vSal);
        END LOOP;
        CLOSE cur_emp;
    END;
    
    PROCEDURE empList
    IS
    BEGIN
        FOR rec IN(SELECT name, sal+bonus pay, fnTax(sal+bonus) tax FROM emp) LOOP
            DBMS_OUTPUT.PUT_LINE(rec.name || ' / ' || rec.pay || ' / ' || rec.tax );
        END LOOP;
    END;
END pEmp;
/

EXEC pEmp.empList('��');
EXEC pEmp.empList();

--��Ű�� �����
DROP PACKAGE pEmp; --������� ��ü���� �� ��������
DROP PACKAGE BODY pEmp; --��ü�� �����