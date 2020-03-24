--■ PL/SQL
-- ※ 커서(Cursor)
--     -------------------------------------------------------
--     -- 암시적 커서
    DECLARE
        vEmpNo emp.empNo%TYPE;
        vCount NUMBER;
    BEGIN
        vEmpNo := '8001';
        DELETE FROM emp WHERE empno=vEmpNo;
        vCount := SQL%ROWCOUNT;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(vCount || ' 레코드 삭제');
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
            RAISE_APPLICATION_ERROR(-20001, '레코드가 없습니다.');
        END IF;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE(vCount || ' 레코드 삭제');
    END;
    /
--     -------------------------------------------------------
--     -- 명시적 커서
    DECLARE 
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
    BEGIN
        SELECT name, sal INTO vname, vsal FROM emp; 
        --조건을 지정하지 않을 경우: ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
--        WHERE empno = '1001';
        DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
    END;
    /

    DECLARE 
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. 커서 선언
        CURSOR cur_emp IS SELECT name, sal FROM emp; --INTO는 들어가지 않음 기존 쿼리문처럼 선언
        --왜냐하면 특정 변수에 담는 것이 아닌 커서 자체에 담기 때문에 into키워드가 필요없기 때문이다.
    BEGIN
        --2. 커서 오픈
        OPEN cur_emp; --open: 선언한 쿼리문을 실행하는 것
        LOOP 
            --3. 커서 FETCH하기 (가져오다)
            --IN JAVA, 오라클에서 fetch 한 줄이 JAVA에서는 VO객체 하나라고 생각하면 된다.
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. 커서 CLOSE
        CLOSE cur_emp;
    END;
    /
    
    --파라미터가 있는 커서
    CREATE OR REPLACE PROCEDURE pEmpSelect(
        pName VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. 커서 선언
        CURSOR cur_emp(cname emp.name%TYPE) IS --커서에 파라미터를 사용한 경우 (파라미터이름 형식)
            SELECT name, sal FROM emp
            WHERE INSTR(name,cname)>0;
    BEGIN
        --2. 커서 오픈
        OPEN cur_emp(pName);
        --3. 커서 FETCH하기 (가져오다)
        --IN JAVA, 오라클에서 fetch 한 줄이 JAVA에서는 VO객체 하나라고 생각하면 된다.
        LOOP
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. 커서 CLOSE
        CLOSE cur_emp;
    END;
    /
    
    EXEC pEmpSelect('김');
    
     --파라미터가 없는 커서 (조건 검색)
    CREATE OR REPLACE PROCEDURE pEmpSelectWithoutCursorParameter(
        pName VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        --1. 커서 선언
        CURSOR cur_emp IS --커서에 파라미터를 사용한 경우 (파라미터이름 형식)
            SELECT name, sal FROM emp
            WHERE INSTR(name,pName)=1;
    BEGIN
        --2. 커서 오픈
        OPEN cur_emp;
        --3. 커서 FETCH하기 (가져오다)
        --IN JAVA, 오라클에서 fetch 한 줄이 JAVA에서는 VO객체 하나라고 생각하면 된다.
        LOOP
            FETCH cur_emp INTO vname, vsal;
            EXIT WHEN cur_emp%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname || ' : ' || vsal);
        END LOOP;
        --4. 커서 CLOSE
        CLOSE cur_emp;
    END;
    /
    
    EXEC pEmpSelectWithoutCursorParameter('이');

    -- 커서 FOR LOOP 자동 OPEN / 자동 CLOSE
    --OPEN과 CLOSE가 자동으로 작업되기 때문에 수동으로 선언 시에는 오류가 발생한다.
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

--■나중에 학습
      -------------------------------------------------------------
      -- WHERE CURRENT OF : FETCH문에 의해 가장 최근에 처리된 행을 참조
      DROP TABLE emp1 PURGE;
      CREATE TABLE  emp1  AS  SELECT * FROM  emp;
      SELECT * FROM EMP1;

      CREATE OR REPLACE  PROCEDURE pEmpUpdateSeoul
      IS
         vCnt   NUMBER;
         vName  emp1.name%TYPE;
         vSal   emp1.sal%TYPE;
         CURSOR  cur_emp  IS
             SELECT  name, sal  FROM  emp1  WHERE city='서울'  FOR  UPDATE; 
               -- FOR  UPDATE : 커서를 이용하여 UPDATE할 경우 반드시 필요
      BEGIN
          vCnt := 0;
    
          OPEN  cur_emp;
          LOOP--커서를 이용하여 쿼리 수정하기 (학습목표: CURRENT OF의 이해)
          --city가 서울인 직원들(cur_emp)에 한하여 봉급을 1.1배 인상
              FETCH  cur_emp INTO  vname, vsal;
              UPDATE emp1 SET sal = TRUNC(sal * 1.1)  WHERE CURRENT OF cur_emp;
              EXIT WHEN  cur_emp%NOTFOUND; -- 마지막 데이터를 처리할때 예외가 발생함
              vCnt := vCnt + 1;
              DBMS_OUTPUT.PUT_LINE(vCnt || ':' || vname || ':' || (vsal*1.1));
          END LOOP;
          -- 예외가 발생하여 실행 안하고 EXCEPTION 절 실행
          COMMIT;
          CLOSE cur_emp;
    
          EXCEPTION  WHEN  OTHERS THEN --JAVA의 CATCH블록이라고 생각하면 됨
              COMMIT;
              DBMS_OUTPUT.PUT_LINE('수정 완료 !!!');
      END;
      /

      EXEC pEmpUpdateSeoul;
      
      --위엣것은 예외로 넘어가는 반면 아래처럼 선언하면 오류 발생은 없는 듯?
      CREATE OR REPLACE  PROCEDURE pEmpUpdateSeoul
      IS
         vCnt   NUMBER;
         vName  emp1.name%TYPE;
         vSal   emp1.sal%TYPE;
         CURSOR  cur_emp  IS
             SELECT  name, sal  FROM  emp1  WHERE city='서울'  FOR  UPDATE; 
               -- FOR  UPDATE : 커서를 이용하여 UPDATE할 경우 반드시 필요
      BEGIN
          vCnt := 0;
    
          OPEN  cur_emp;
          LOOP--커서를 이용하여 쿼리 수정하기 (학습목표: CURRENT OF의 이해)
          --city가 서울인 직원들(cur_emp)에 한하여 봉급을 1.1배 인상
              FETCH  cur_emp INTO  vname, vsal;
              EXIT WHEN  cur_emp%NOTFOUND; -- 먼저 있는지 없는지 검사하면...
              UPDATE emp1 SET sal = TRUNC(sal * 1.1)  WHERE CURRENT OF cur_emp;
              vCnt := vCnt + 1;
              DBMS_OUTPUT.PUT_LINE(vCnt || ':' || vname || ':' || (vsal*1.1));
          END LOOP;
          -- 예외가 발생하여 실행 안하고 EXCEPTION 절 실행
          COMMIT;
          CLOSE cur_emp;
    
          EXCEPTION  WHEN  OTHERS THEN --JAVA의 CATCH블록이라고 생각하면 됨
              COMMIT;
              DBMS_OUTPUT.PUT_LINE('수정 완료 !!!');
      END;
      /

--   ο 커서 변수(cursor variable)
--     -------------------------------------------------------
--    데이터를 삽입할 때 2개 이상의 단위를 저장할 수도 있음
--■■■■■■■■■■■■■■■■■■■■■ 중요한 프로시저
    CREATE OR REPLACE PROCEDURE pEmpSelectList(
        pName IN VARCHAR2,
        pResult OUT SYS_REFCURSOR --■
    )
    IS
    BEGIN
        OPEN pResult FOR --■
            SELECT name, sal FROM emp
            WHERE INSTR(name,pName) > 0;
    END;
    /
    
    --SQL DEVELOPER에서는 OUT PARAMETER테스트를 위한 또 다른 프로시저가 필요하다.
    --콘솔확인용 프로시저 (위의 본 프로시저가 중요하므로 가볍게 환기하고 넘어가기)
    CREATE OR REPLACE PROCEDURE pEmpSelectResult(--콘솔 확인용
        pName IN VARCHAR2
    )
    IS
        vname emp.name%TYPE;
        vsal emp.sal%TYPE;
        vResult SYS_REFCURSOR;
    BEGIN
        pEmpSelectList(pName, vResult); 
        LOOP --vresult의 값을 가져올 때는 for문장이 아니라 LOOP를 사용해야 한다
        --vresult는 open이 되어있으면 안 되기 때문 (위의 본 프로시저에서 이미 open됨)
            FETCH vResult INTO vname, vsal;
            EXIT WHEN vResult%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE(vname||' : '||vsal);
        END LOOP;
            DBMS_OUTPUT.PUT_LINE('프로그램의 끝');
    END;
    /
    
    EXEC pEmpSelectResult('김');


-- ※ 동적쿼리(Dynamic SQL)
-- 단, CREATE TABLE과 CREATE SEQUENCE 권한이 있어야만 동적 쿼리를 실행할 수 있음.
--EXECUTE IMMEDIATE를 이용하여 테이블 작서 및 시퀀스 작성 권한 부여 방법 (SYS)
GRANT CREATE TABLE TO sky;
GRANT CREATE SEQUENCE TO sky;
--sky계정: 유저의 시스템 권한 확인하기
SELECT * FROM user_sys_privs; -- CREATE TABLE, CREATE SEQUENCE 항목 확인하기!
--     -------------------------------------------------------
--     -- EXECUTE IMMEDIATE
--  각 사용자별로 동적으로 게시판 테이블을 생성하기 위해서는 동적 쿼리가 필요하다
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
        
        --이미 존재하는 테이블 삭제
        FOR t IN (SELECT tname FROM tab WHERE tname=UPPER(pName)) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || pName || ' PURGE';
            DBMS_OUTPUT.PUT_LINE(pName || ' 테이블을 삭제하였습니다.');
            EXIT;
        END LOOP;
        --테이블 새로 만들기
        EXECUTE IMMEDIATE s;
        
        --이미 존재하는 시퀀스 삭제
        FOR i IN (SELECT sequence_name FROM seq WHERE sequence_name=UPPER(pName||'_seq')) LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pName || '_seq';
            DBMS_OUTPUT.PUT_LINE(pName || ' _seq 시퀀스를 삭제하였습니다.');
        END LOOP;
        --시퀀스 새로 만들기
        EXECUTE IMMEDIATE 'CREATE SEQUENCE ' || pName || '_seq NOCACHE';
        DBMS_OUTPUT.PUT_LINE(pName || ' 테이블 및 ' || pName || '_seq 시퀀스를 작성하였습니다.');
        
    END;
    /
    
    SELECT * FROM tab;
    SELECT * FROM seq;
    
    --EXEC 뒤에 주석 주면 안 된다.
    EXEC pBoardCreate('board');
    --(권한 지정이 되지 않은 경우) ORA-01031: 권한이 불충분합니다 insufficient privileges

--셀프 학습

    CREATE OR REPLACE PROCEDURE DELETE_TABLE_WITH_SEQUENCE(
        pName VARCHAR2
    )
    IS
    BEGIN
        FOR t IN (SELECT tname FROM tab WHERE tname=UPPER(pName)) LOOP
            EXECUTE IMMEDIATE 'DROP TABLE ' || pName || ' PURGE';
            DBMS_OUTPUT.PUT_LINE(pName || '테이블을 삭제하였습니다');
        END LOOP;
        
        FOR i IN (SELECT sequence_name FROM seq WHERE sequence_name=UPPER(pName||'_seq')) LOOP
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pName || '_seq';
            DBMS_OUTPUT.PUT_LINE(pName || '_seq 시퀀스도 삭제하였습니다.');
        END LOOP;
    END;
    /
    
    EXEC DELETE_TABLE_WITH_SEQUENCE('board');
    
    