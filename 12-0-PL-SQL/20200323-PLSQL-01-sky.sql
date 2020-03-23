--■ PL/SQL
-- ※ DBMS_OUTPUT.PUT_LINE은 SQL PLUS에서 다음의 명령어로 확인할 수 있다.
--DBMS_OUTPUT:결과 확인
SET SERVEROUTPUT ON
-- ※ 기본 문법
--   ο 기본 문법
--     -------------------------------------------------------
--    %TYPE: 테이블의 컬럼의 자료형을 참조
    DECLARE
        --변수 선언 vname(emp.name의 타입과 동일하게), vpay (숫자)
        vname emp.name%TYPE; --varchar(30)
        vpay NUMBER;
    BEGIN
        SELECT name, sal+bonus INTO vname, vpay 
        FROM emp WHERE empNo='1001';
        --하나의 행만 저장할 수 있으므로 WHERE조건으로 1개의 행만 반환되도록 지정해주지 않으면 오류가 발생한다.
        --WHERE조건에 부합하지 않아 아무 행도 반환되지 않아도 오류가 발생한다.
        DBMS_OUTPUT.PUT_LINE('이름: ' || vname);--디버깅 테스트용 구문
        DBMS_OUTPUT.PUT_LINE('급여: ' || vpay);
    END;
    /
    
    --    %ROWTYPE: 테이블의 행을 참조하는 레코드 선언
    DECLARE
        --변수 선언 vname(emp.name의 타입과 동일하게) (숫자)
        vrec emp%ROWTYPE;
    BEGIN
--        SELECT name, sal INTO vrec.name, vrec.sal
--        FROM emp WHERE empNo='1002';
        SELECT * INTO vrec FROM EMP WHERE empno='1001';
        --하나의 행만 저장할 수 있으므로 WHERE조건으로 1개의 행만 반환되도록 지정해주지 않으면 오류가 발생한다.
        --WHERE조건에 부합하지 않아 아무 행도 반환되지 않아도 오류가 발생한다.
        DBMS_OUTPUT.PUT_LINE('이름: ' || vrec.name);--디버깅 테스트용 구문
        DBMS_OUTPUT.PUT_LINE('급여: ' || vrec.sal);
    END;
    /
    
    -- 사용자 정의 레코드
    DECLARE
        TYPE mytype IS RECORD -- JAVA로 치면 클래스처럼 하나의 자료형을 만듦
        (
            name emp.name%TYPE,
            sal emp.sal%TYPE
        );
        vrec MYTYPE;
    BEGIN
        SELECT name, sal INTO vrec.name, vrec.sal
        FROM emp WHERE empNo='1001';
        --하나의 행만 저장할 수 있으므로 WHERE조건으로 1개의 행만 반환되도록 지정해주지 않으면 오류가 발생한다.
        --WHERE조건에 부합하지 않아 아무 행도 반환되지 않아도 오류가 발생한다.
        DBMS_OUTPUT.PUT_LINE('이름: ' || vrec.name);--디버깅 테스트용 구문
        DBMS_OUTPUT.PUT_LINE('급여: ' || vrec.sal);
    END;
    /
    
--   ο 제어 구조
--     -------------------------------------------------------
--     -- IF
    DECLARE
        a NUMBER := 10; --대입연산자는 =이 아니라 :=로 기술한다.
    BEGIN
        IF MOD(a, 6) = 0 THEN
            DBMS_OUTPUT.PUT_LINE(a || '은 2 또는 3의 배수');
        --ELSE IF가 아니라 ELSIF임에 유의한다
        ELSIF MOD(a,3) = 0 THEN
           DBMS_OUTPUT.PUT_LINE(a || '은 3의 배수');
        ELSIF MOD(a,2) = 0 THEN
           DBMS_OUTPUT.PUT_LINE(a || '은 2의 배수');
        ELSE
           DBMS_OUTPUT.PUT_LINE(a||'은 2 또는 3의 배수가 아님');
        END IF;
    END;
    /
    
    --문제1) EMPNO가 1001인 레코드
    --이름(name), 급여(sal+bonus), 세금 출력
    --세금은 sal+bonus가 300만 이상 3%, 200만 이상 2%, 나머지 0
    --소숫점 첫 째자리 반올림

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
        DBMS_OUTPUT.PUT_LINE('이름: ' || vrec.name);
        DBMS_OUTPUT.PUT_LINE('급여: ' || vpay);
        DBMS_OUTPUT.PUT_LINE('세금: ' || vtax);
    END;
    /
    
    --선생님 답안
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
        DBMS_OUTPUT.PUT_LINE('이름: ' || vname);
        DBMS_OUTPUT.PUT_LINE('급여: ' || vpay || ', 세금: ' || vtax);
    END;
    /
    
--     -------------------------------------------------------
--     -- CASE
-- 배웠던 CASE WHEN THEN과 유사함
--     -------------------------------------------------------
--     -- basic LOOP, EXIT, CONTINUE
--      무한루프. EXIT를 만날 때까지 계속 순환한다.
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
        DBMS_OUTPUT.PUT_LINE('결과(100의 합 -1) : ' || s);
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
        DBMS_OUTPUT.PUT_LINE('결과(100의 합) : ' || s);
    END;
    /

--문제2) 1~100 중 홀수의 합
    DECLARE
        n NUMBER := 1;
        s NUMBER := 0;
    BEGIN
        WHILE n < 100 LOOP
            s := s + n;
            n := n + 2;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('n= ' || n);
        DBMS_OUTPUT.PUT_LINE('결과(100의 합) : ' || s);
    END;
    /
    
    --구구단 출력하기
    DECLARE
        a NUMBER;
        b NUMBER;
    BEGIN
        a :=1;
        while a<9 LOOP
            a := a+1;
            DBMS_OUTPUT.PUT_LINE('**' || a || ' 단 **');
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
--  장점: 변수 선언이 별도로 하지 않음.
--  단점: ±1씩 증가밖에 안 된다.

DECLARE
    s NUMBER := 0;
BEGIN
    --for 반복 변수는 선언하지 않는다. 자동 선언됨
    FOR n IN 1 .. 100 LOOP
        s := s + n;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('결과: '|| s);
END;
/

DECLARE
--A~Z까지 순차적으로 출력
BEGIN
    --for 반복 변수는 선언하지 않는다. 자동 선언됨
    FOR n IN 65 .. 90 LOOP
        DBMS_OUTPUT.PUT(CHR(n)); --출력 후 라인 넘기지 않음
        --PUT_LINE(), NEW_LINE()을 만나야 출력됨
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); --라인 넘김
END;
/    

DECLARE
--Z~A 역으로 출력
BEGIN
    --for 반복 변수는 선언하지 않는다. 자동 선언됨
    FOR n IN REVERSE 65 .. 90 LOOP
        DBMS_OUTPUT.PUT(CHR(n)); --출력 후 라인 넘기지 않음
        --PUT_LINE(), NEW_LINE()을 만나야 출력됨
    END LOOP;
    DBMS_OUTPUT.NEW_LINE(); --라인 넘김
END;
/    

--     -------------------------------------------------------
--     -- SQL Cursor FOR LOOP

    DECLARE
        vrec emp%ROWTYPE;
    BEGIN
        SELECT * INTO vrec FROM EMP;
        --오류 발생 ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
        DBMS_OUTPUT.PUT_LINE('이름: ' || vrec.name);--디버깅 테스트용 구문
        DBMS_OUTPUT.PUT_LINE('급여: ' || vrec.sal);
    END;
    /

    --FOR문장은 SELECT문을 만났을 때 빛을 발한다
    DECLARE
    BEGIN
        FOR rec IN (SELECT empno, name, sal FROM emp) LOOP
        --오류 발생 ORA-01422: 실제 인출은 요구된 것보다 많은 수의 행을 추출합니다
        DBMS_OUTPUT.PUT_LINE( rec.empno || ' ' || rec.name || ' ' || rec.sal);--디버깅 테스트용 구문
        END LOOP;
    END;
    /