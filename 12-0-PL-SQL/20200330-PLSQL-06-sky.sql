-- ※ 패키지(Package)
------------------------------------------------------------
-- 패키지 목록 확인
SELECT * FROM user_objects WHERE object_type = 'PACKAGE';
SELECT * FROM user_objects;
SELECT * FROM user_procedures;
-- 패키지는 서로 관련된 하나 이상의 프로시저나 function, type을 모아둔 집합.
-- 패키지 선언
CREATE OR REPLACE PACKAGE pEmp IS
    --패키지 선언 시에는 함수,프로시저의 내용은 담지 않고 선언만 한다.
    FUNCTION fnTax(p IN NUMBER) RETURN NUMBER;
    PROCEDURE empList(pName VARCHAR2);
    PROCEDURE empList;
END pEmp;
/

--몸체 구현 (프로시저, 함수들의 내용 작성)
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

EXEC pEmp.empList('김');
EXEC pEmp.empList();

--패키지 지우기
DROP PACKAGE pEmp; --선언부터 몸체까지 다 지워진다
DROP PACKAGE BODY pEmp; --몸체만 지우기