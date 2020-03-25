�� PL/SQL
 �� ����ó��
      -------------------------------------------------------------
      -- 
      DECLARE
         vName  VARCHAR2(30);
         vSal   NUMBER;
      BEGIN
           SELECT  name, sal  INTO  vName, vSal  FROM emp  WHERE  empNo = '1001';
--           SELECT  name, sal  INTO  vName, vSal  FROM emp  WHERE  empNo = '8001';
--          SELECT  name, sal  INTO  vName, vSal  FROM emp;
    
          DBMS_OUTPUT.PUT_LINE(vName || ':' || vSal);
    
          EXCEPTION
              WHEN  NO_DATA_FOUND THEN
                  DBMS_OUTPUT.PUT_LINE('�������� �ʴ� ������');
              WHEN  TOO_MANY_ROWS THEN
                  DBMS_OUTPUT.PUT_LINE('�ΰ� �̻� ����');
              WHEN  OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('��Ÿ ����');
      END;
      /   

      ---------------------------------------------------------------
      -- ����� ���� ���� �����
      DECLARE
         vName  VARCHAR2(30);
         vSal   NUMBER;
   
         emp_sal_check EXCEPTION;
      BEGIN
          SELECT  name, sal  INTO  vName, vSal  FROM emp  WHERE  empNo = '1001';
          IF vSal >= 3000000 THEN
             RAISE  emp_sal_check;
          END IF;
    
          DBMS_OUTPUT.PUT_LINE(vName || ':' || vSal);
    
          EXCEPTION
              WHEN  emp_sal_check THEN
                  DBMS_OUTPUT.PUT_LINE('�޿��� 3000000�� �̻��Դϴ�.');
              WHEN  OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('��Ÿ ����');
      END;
      /   