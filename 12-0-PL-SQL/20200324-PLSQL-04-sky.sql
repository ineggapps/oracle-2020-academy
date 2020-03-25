■ PL/SQL
 ※ 예외처리
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
                  DBMS_OUTPUT.PUT_LINE('존재하지 않는 데이터');
              WHEN  TOO_MANY_ROWS THEN
                  DBMS_OUTPUT.PUT_LINE('두개 이상 존재');
              WHEN  OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('기타 에러');
      END;
      /   

      ---------------------------------------------------------------
      -- 사용자 정의 예외 만들기
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
                  DBMS_OUTPUT.PUT_LINE('급여가 3000000원 이상입니다.');
              WHEN  OTHERS THEN
                  DBMS_OUTPUT.PUT_LINE('기타 에러');
      END;
      /   