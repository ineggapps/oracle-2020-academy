--�� PL/SQL
-- �� ���ν��� (Stored Procedure)
--  ���� ���Ǵ� ������ �帧�� �����ͺ��̽��� �����ϰ� ���߿� ȣ���Ͽ� ����Ѵ�.
--  ���������ϵǹǷ� ó�� �ӵ��� ������. �׳� �������� ����ϴ� �ͺ��� �ξ� ����. (������ ������ ���� �Ǿ���)
--  JAVA�� ġ�� void �޼����� �����ϸ� �ȴ�. (return �� ����)
--  ���ν����� Ʈ����� �۾��� �� �� ��������.
--  �ߺ� ����(�����ε�) �����ϴ�.
--     -------------------------------------------------------

    CREATE TABLE test ( 
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        score NUMBER(3) NOT NULL,
        grade VARCHAR2(10) NOT NULL
    );
    
    CREATE SEQUENCE test_seq;
    
    SELECT * FROM tab;
    SELECT * FROM seq;   

    --���ν��� ����� (������ ����)
    --���� �� ������ �־ ���ν��� ��ü�� �����ǹǷ� OR REPLACEŰ���带 �Է��Ͽ� �ٽ� ���ν����� �����Ѵ�
    CREATE PROCEDURE pInsertTest
    IS--���� �����
    
    BEGIN--�޼��� ���
        INSERT INTO test(num, name, score, grade) -- PL/SQL: ORA-00904: "NAM": �������� �ĺ���
        VALUES(test_seq.NEXTVAL, 'ȫ�浿', 80, '��');
        COMMIT;
    END;
    /
    
    SELECT * FROM user_procedures;
    SELECT * FROM user_dependencies; --test�� test_seq�� �����Ѵٴ� ���� Ȯ���� �� �ִ�.
    SELECT * FROM user_source; --���ν��� �ҽ��ڵ尡 ��µ��� �� �� ����.

    --���ν��� ����
    EXEC pInsertTest;
    
    select * from test;
    
    --���ν��� ���� (IN �Ķ����)
    CREATE OR REPLACE PROCEDURE pInsertTest(
        pName VARCHAR2, --�� ����: �Ķ���ʹ� ���� ũ�⸦ ������� �ʴ´�.
--         pName test.name%TYPE,--test���̺��� name�÷��� ũ�⸦ �����ϰ� ����
        pScore IN NUMBER -- IN�� ������ �� �ִ�.
    )
    IS--���� �����
        vgrade VARCHAR2(20);
    BEGIN--�޼��� ���
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '������ 0~100���� �����մϴ�');
            --����ó���� ����Ŭ���� �ϸ� JAVA���� try, catch������ ���� ���� �� �ִ�.
        END IF;
        IF pScore>=90 THEN vgrade := '��';
        ELSIF pSCore>=80 THEN vgrade := '��';  
        ELSIF pSCore>=70 THEN vgrade := '��';  
        ELSIF pSCore>=60 THEN vgrade := '��';  
        ELSE vgrade := '��';  
        END IF;
        
        INSERT INTO test(num, name, score, grade) -- PL/SQL: ORA-00904: "NAM": �������� �ĺ���
        VALUES(test_seq.NEXTVAL, pName, pScore, vGrade);
        COMMIT;
    END;
    /
    
    EXEC pInsertTest('������',88);
    EXEC pInsertTest('������',90);
    select * from test;

    --�����ϴ� ���ν���
    --RAISE_APPLICATION_ERROR(error_number, message)
    --����� ���� ���� �߻�. --error_number:-20999 ~ -20000
    CREATE OR REPLACE PROCEDURE pUpdateTest(
        pNum IN test.num%TYPE,
        pName IN test.name%TYPE, 
        pScore IN test.score%TYPE
    )
    IS--���� �����
        vgrade VARCHAR2(20);
    BEGIN--�޼��� ���
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '������ 0~100���� �����մϴ�');
        END IF;
        
        IF pScore>=90 THEN vgrade := '��';
        ELSIF pSCore>=80 THEN vgrade := '��';  
        ELSIF pSCore>=70 THEN vgrade := '��';  
        ELSIF pSCore>=60 THEN vgrade := '��';  
        ELSE vgrade := '��';  
        END IF;
        
        UPDATE test SET name=pName, score=pScore, grade=vGrade 
        WHERE num=pNum;
        COMMIT;
    END;
    /
    
    EXEC pUpdateTest(1,'vvv',99);
    EXEC pUpdateTest(2,'aaa',90);
    EXEC pUpdateTest(2,'aaa',190);--����� ���� ���� �� �޽����� ��� (���� �߻�)
    select * from test;
    
    --���� ���ν���: pDeleteTest
    CREATE PROCEDURE pDeleteTest(
        pNum IN test.num%TYPE
    )
    IS
    BEGIN
        DELETE FROM test
        WHERE num=pNum;
    END;
    /
    
    EXEC pDeleteTest(22);
    
    
    -- �ϳ��� ���ڵ带 ����ϴ� ���ν��� �ۼ��ϱ�
    CREATE OR REPLACE PROCEDURE pSelectOneTest(
        pNum IN NUMBER
    )
    IS
        rec test%ROWTYPE;
    BEGIN
        SELECT * INTO rec FROM test WHERE num = pNum;
        DBMS_OUTPUT.PUT_LINE(rec.num || ' : ' || rec.name || ' : ' || rec.score || ' : ' || rec.grade);
    END;
    /
    
    EXEC pSelectOneTest(2);
    EXEC pSelectOneTest(1);-- ORA-01403: �����͸� ã�� �� �����ϴ�. (select�� �Ͽ����� �ᱣ���� ���� ���)
    
    select * from test;
    
    --���̺� ��ü ���ڵ带 �������� ���
    CREATE OR REPLACE PROCEDURE pSelectListTest --�Ķ���Ͱ� ������ ��ȣ�� ���� �ʴ±���!
    IS
    BEGIN
        FOR rec IN (SELECT num, name, score, grade FROM test) LOOP 
        --FOR IN �ȿ� SELECT������ INTO�� ���� ����
            DBMS_OUTPUT.PUT_LINE(rec.num || ' : ' || rec.name || ' : ' || rec.score || ' : ' || rec.grade);
        END LOOP;
    END;
    /
    EXEC pSelectListTest;
    
    ------------------------------------
    --����
    ------------------------------------
    --1) 3���� ���̺� �ۼ�
    --���̺��: EX1
    -- num NUMBER PRIMARY KEY,
    -- name VARCHAR2(30) NOT NULL,
    
    CREATE TABLE ex1(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL
    );
    
    --���̺��: EX2
    -- num NUMBER �⺻Ű, ex1 ���̺� num�� ����Ű
    -- birth DATE NOT NULL
    
    CREATE TABLE ex2(
        num NUMBER PRIMARY KEY REFERENCES ex1(num),
        birth DATE NOT NULL
    );
    
    -- ���̺��: EX3
    -- num NUMBER �⺻Ű, ex1 ���̺� num�� ����Ű
    -- score NUMBER(3) NOT NULL
    -- grade NUMBER(2,1) NOT NULL
    
    CREATE TABLE ex3(
        num NUMBER PRIMARY KEY REFERENCES ex1(num),
        score NUMBER(3) NOT NULL,
        grade NUMBER(2,1) NOT NULL
    );
    
    --2) ������ �ۼ� ex_seq
    --�ʱ�: 1, ����: 1, ĳ��: X 
    CREATE SEQUENCE ex_seq
        START WITH 1
        INCREMENT BY 1
        nocycle
        NOCACHE;
    
    --ex1, ex2, ex3 ���̺� �����͸� �߰��ϴ� ���ν���: pInsertEx
    --num�� ������ �̿�
    --score >=90: 4.0
    --score >=80: 3.0,
    --score >=70: 2.0,
    --score >=60: 1.0,
    --������ 0
    
    CREATE OR REPLACE PROCEDURE pInsertEx(
        pName ex1.name%TYPE, --���ν����� ũ�⸦ ������ �� ���� VARCHAR2 �������θ� ���ǰ� �����ϴ�.
        pBirth ex2.birth%TYPE, -- Ȥ�� DATE
        pScore ex3.score%TYPE 
    )
    IS
        vNum   ex1.num%TYPE;
        vGrade ex3.grade%TYPE;
    BEGIN
        IF pScore < 0 OR pScore > 100 THEN 
            RAISE_APPLICATION_ERROR(-20001, '������ 0~100�� ���̿��� �մϴ�.');
        END IF;
        
        IF pScore >= 90 THEN vGrade := 4.0;
        ELSIF pScore >= 80 THEN vGrade := 3.0;
        ELSIF pScore >= 70 THEN vGrade := 2.0;
        ELSIF pScore >= 60 THEN vGrade := 1.0;
        ELSE vGrade := 0.0;
        END IF;
        
        vNum := ex_seq.NEXTVAL;
        INSERT INTO ex1(num, name) VALUES(vNum, pName);
        INSERT INTO ex2(num, birth) VALUES(ex_seq.CURRVAL, TO_DATE(pBirth));--ex1�ǰ��� �����ϴ� ex2�� �ڽ��̴�
        INSERT INTO ex3(num, score, grade) VALUES(vNum, pScore, vGrade);
        --���ν����� Ư���� �ϳ��� �۾��� �����ϸ� ��� �۾��� �ѹ�Ǵ� ���� �����Ѵ�.
        --�̷��� �ڹٷ� �ڵ��� �� ���ν����� ����ϸ� ���ٴ� ��!
        COMMIT;
        --���ν����� DML�� ����� ��� COMMIT�� �Է��ؾ� DB�� �ݿ��ȴ�.
    END;
    /
    
    --score�� 0~100�� �ƴϰų� �� ���� ���̺� �� �ϳ��� ���̺� �����Ͱ� �߰����� ������
    --��� ���̺� �����Ͱ� �߰����� �ʾƾ� �Ѵ�.
    --ex1: ��ȣ, �̸� / ex2: ��ȣ(�ܷ�Ű) , ���� / ex3) ��ȣ(�ܷ�Ű) ����, ����
    --���� ��)
    EXEC pInsertEx('ȫ�浿', '2000-10-10', 95);
    EXEC pInsertEx('�ڱ浿', '2001-10-10', 77);
    EXEC pInsertEx('���浿', '2000-10-10', 64);
    EXEC pInsertEx('���浿', '2000-10-10', 82);
    
--    drop table ex1 purge;
--    drop table ex2 purge;
--    drop table ex3 purge;
--    drop sequence ex_seq;
    
    SELECT * FROM ex1
    JOIN ex2 USING(num)
    JOIN ex3 USING(num);
    
-- �� �Լ�(����������Լ��� ����� return)
-- function�� �ݵ�� return�� �־�� �Ѵ�.
--     -------------------------------------------------------
    SELECT * FROM user_procedures WHERE OBJECT_TYPE='FUNCTION'; --�Լ� ���� Ȯ��
    SELECT * FROM USER_SOURCE;
    
    UPDATE emp SET rrn='000707-4574812' WHERE empNo='1014';
    UPDATE emp SET rrn='010210-3111111' WHERE empNo='1021';
    
    CREATE OR REPLACE FUNCTION fnGender(
        rrn VARCHAR2 --ũ�� ��� �� ��
    )
    RETURN VARCHAR2 --��ȯ���� ũ�⸦ ������� �ʴ´�.
    IS
        s VARCHAR2(6) := '����';
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ �ڸ����� ������(-)�� �����Ͽ� 14�ڸ��Դϴ�. ');
            --JAVA�� ġ�ڸ� THROW ERROR�� �� �Ͱ� ����.
        END IF;
        
        IF MOD(SUBSTR(rrn,8,1),2)=1 THEN 
            s := '����';
        END IF;
        
        RETURN s;
    END;
    /
    
    CREATE OR REPLACE FUNCTION fnBirth(
        rrn VARCHAR2 --ũ�� ��� �� ��
    )
    RETURN DATE
    IS
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ �ڸ����� ������(-)�� �����Ͽ� 14�ڸ��Դϴ�. ');
            --JAVA�� ġ�ڸ� THROW ERROR�� �� �Ͱ� ����.
        END IF;        
        RETURN TO_DATE(substr(rrn,1,6),'RRMMDD');
    END;
    /
    
    CREATE OR REPLACE FUNCTION fnAge(
        rrn VARCHAR2 --ũ�� ��� �� ��
    )
    RETURN NUMBER
    IS
        a NUMBER;
        b DATE;
    BEGIN
        IF LENGTH(rrn) != 14 THEN
            RAISE_APPLICATION_ERROR(-20001, '�ֹι�ȣ �ڸ����� ������(-)�� �����Ͽ� 14�ڸ��Դϴ�. ');
            --JAVA�� ġ�ڸ� THROW ERROR�� �� �Ͱ� ����.
        END IF;    
        
        b := TO_DATE(substr(rrn,1,6), 'RRMMDD');
        a := TRUNC(MONTHS_BETWEEN(SYSDATE,b)/12);                
        
        RETURN a;
    END;
    /
    
    
    SELECT name, 
    rrn, fnGender(rrn) ����, 
    TO_CHAR(fnBirth(rrn),'YYYY"��"MM"��"DD"��"') ����,
    fnAge(rrn)||'��' ����
    from emp;
    
--
--     -------------------------------------------------------
--     -- ����
--     -- score1 ���̺� �ۼ�
--          hak     ����(20)  �⺻Ű
--          name   ����(30)  NOT  NULL
--          kor      ����(3)     NOT  NULL
--          eng      ����(3)    NOT  NULL
--          mat      ����(3)    NOT  NULL

    CREATE TABLE score1(
        hak VARCHAR2(20) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL
    );
    
--      -- score2 ���̺� �ۼ�
--          hak     ����(20)  �⺻Ű, score1 ���̺��� ����Ű
--          kor      ����(2,1)     NOT  NULL
--          eng      ����(2,1)    NOT  NULL
--          mat      ����(2,1)    NOT  NULL

    CREATE TABLE score2(
        hak VARCHAR2(20) PRIMARY KEY REFERENCES score1(hak),
        kor NUMBER(2,1) NOT NULL,
        eng NUMBER(2,1) NOT NULL,
        mat NUMBER(2,1) NOT NULL
    );
    
--     -- ������ ���ϴ� �Լ� �ۼ�
--         -- �Լ��� : fnGrade(s)
--             95~100:4.5    90~94:4.0
--             85~89:3.5     80~84:3.0
--             75~79:2.5     70~74:2.0
--             65~69:1.5     60~64:1.0
--             60�̸� 0

    CREATE OR REPLACE FUNCTION fnGrade(
     pScore NUMBER
    )
    RETURN VARCHAR2
    IS 
        vGrade NUMBER;
    BEGIN
        IF pScore < 0 OR pScore > 100 THEN
            RAISE_APPLICATION_ERROR(-20001, '������ ������ 0~100�� �����Դϴ�.');
        END IF;
        
        IF pScore>=95 THEN vGrade := 4.5;
        ELSIF pScore >= 90 THEN vGrade :=4.0;
        ELSIF pScore >= 85 THEN vGrade :=3.5;
        ELSIF pScore >= 80 THEN vGrade :=3.0;
        ELSIF pScore >= 75 THEN vGrade :=2.5;
        ELSIF pScore >= 70 THEN vGrade :=2.0;
        ELSIF pScore >= 65 THEN vGrade :=1.5;
        ELSIF pScore >= 60 THEN vGrade :=1.0;
        ELSE vGrade := 0;
        END IF;
        
        RETURN vGrade;
    END;
    /
        
--      -- score1 ���̺�� score2 ���̺� �����͸� �߰��ϴ� ���ν��� �����
--         ���ν����� : pScoreInsert
--         ���࿹ : EXEC pScoreInsert('1111', '������', 80, 60, 75);

        CREATE OR REPLACE PROCEDURE pScoreInsert(
            pHak score1.hak%TYPE,
            pName score1.name%TYPE,
            pKor score1.kor%TYPE,
            pEng score1.eng%TYPE,
            pMat score1.mat%TYPE
        )
        IS
        BEGIN
            INSERT INTO score1(hak, name, kor, eng, mat) VALUES(pHak, pName, pKor, pEng, pMat);
            INSERT INTO score2(hak, kor, eng, mat) VALUES(pHak, fnGrade(pKor), fnGrade(pEng), fnGrade(pMat));            
            COMMIT;
        END;
        /
--         score1 ���̺� => '1111', '������', 80, 60, 75  ���� �߰�
--         score2 ���̺� => '1111',            3.0, 1.0, 2.5 ���� �߰�(��, ��, �� ������ �������� ���Ǿ� �߰�)
        EXEC pScoreInsert('1111','������',80,60,74);
        
        select * from score1
        JOIN score2 USING(hak);
--         ��, ����, ����, ���� ������ 0~100 ���̰� �ƴϸ� ���� �߻��ϰ� ����
-- 
--     -- score1 ���̺�� score2 ���̺� �����͸� �����ϴ� ���ν��� �����
--         ���ν����� : pScoreUpdate

        CREATE OR REPLACE PROCEDURE pScoreUpdate(
            pHak score1.hak%TYPE,
            pName score1.name%TYPE,
            pKor score1.kor%TYPE,
            pEng score1.eng%TYPE,
            pMat score1.mat%TYPE
        )
        IS
        BEGIN
            UPDATE score1 SET
                name = pName,
                kor = pKor,
                eng = pEng,
                mat = pMat
            WHERE hak = pHak;
            
            UPDATE score2 SET
                kor = fnGrade(pKor),
                eng = fnGrade(pEng),
                mat  = fnGrade(pMat)
            WHERE hak = pHak;
            COMMIT;
        END;
        /
        EXEC pScoreUpdate('1111','������',90,60,75);
        
        select * from score1
        JOIN score2 USING(hak);

--         ���࿹ : EXEC pScoreUpdate('1111', '������', 90, 60, 75);
--   
--         score1 ���̺� => �й��� '1111' �� �ڷḦ  '������', 90, 60, 75  ���� ���� ����
--         score2 ���̺� => �й��� '1111' �� �ڷḦ           4.0, 1.0, 2.5 ���� ���� ����(��, ��, �� ������ �������� ���Ǿ� ����)
--   
--         ��, ����, ����, ���� ������ 0~100 ���̰� �ƴϸ� ���� �߻��ϰ� ����
--   
--      -- score1 ���̺�� score2 ���̺� �����͸� �����ϴ� ���ν��� �����
--         ���ν����� : pScoreDelete
--         ���࿹ : EXEC pScoreDelete('1111');
--         score1 �� score2 ���̺� ���� ����
        
        CREATE OR REPLACE PROCEDURE pScoreDelete(
            pHak score1.hak%TYPE
        )
        IS
        BEGIN
            DELETE FROM score2 WHERE hak=pHak;
            DELETE FROM score1 WHERE hak=pHak;
            COMMIT;
        END;
        /

        EXEC pScoreDelete('1111');
        
        select * from score1
        JOIN score2 USING(hak);