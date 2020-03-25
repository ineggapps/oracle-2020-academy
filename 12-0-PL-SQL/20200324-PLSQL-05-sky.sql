--�� PL/SQL
--�ۼ��� Ʈ���� ����
SELECT * FROM user_triggers;
--Ʈ���� �����ϱ� ���� ������ sky���� �ο��ϱ� (dba������ ���������� �����ϴ�.)
GRANT CREATE TRIGGER TO sky;
--������� �ý��� ���� Ȯ��
SELECT * FROM user_sys_privs;
-- �� Ʈ���� (BEFORE, AFTER, INSTEAD OF)
--     -------------------------------------------------------
--     -- ���� Ʈ����: 
--      DML ����Ƚ��(EX: DELETE FROM EMP<- 60���� ���ڵ忡 ���� ����)�� ������� �� �� �� ����
    
    CREATE TABLE ex(
        num NUMBER PRIMARY KEY,
        name VARCHAR2(30) NOT NULL
    );
    
    CREATE TABLE ex_time(
        memo VARCHAR2(100),
        created DATE DEFAULT SYSDATE
    );
    
    --���� Ʈ���� �ۼ��ϱ�
    CREATE OR REPLACE TRIGGER tri_ex
    AFTER INSERT OR UPDATE OR DELETE ON ex
    BEGIN
        IF INSERTING THEN
            INSERT INTO ex_time(memo) VALUES('�߰�');
        ELSIF UPDATING THEN
            INSERT INTO ex_time(memo) VALUES('����');
        ELSIF DELETING THEN
            INSERT INTO ex_time(memo) VALUES('����');
        END IF;
        --Ʈ���� �ȿ��� INSERT, DELETE, UPDATE�� �ڵ����� COMMIT�ȴ�.
        --�׷��Ƿ� COMMIT; ���� ������� �ʴ´�.
    END;
    /
    
    SELECT * FROM user_triggers;
    SELECT * FROM user_source; --���ν��� �� Ʈ������ �ۼ� �ҽ��� �״�� ���δ�.
    
    INSERT INTO ex(num, name) VALUES(1, 'a');
    INSERT INTO ex(num, name) VALUES(2, 'b');
    COMMIT;
    UPDATE ex SET name='aa' WHERE num=1;
    COMMIT;
    
    SELECT * FROM ex;
    SELECT * FROM ex_time;
    
    DELETE FROM ex; --���� Ʈ���Ŵ� delete�Ǵ� ������ ������� �� ���� Ʈ���Ű� �߻��Ѵ�.
    
    --���� �ð��� ������ �۾��� ���� ���ϵ���
    --(TO_CHAR(SYSDATE, 'HH24') < 9 AND TO_CHAR(SYSDATE,'HH24') > 18) THEN
            RAISE_APPLICATION_ERROR(-20001,'������ �۾��� �� �� �����ϴ�.');
    CREATE OR REPLACE TRIGGER tri_ex2
    AFTER INSERT OR UPDATE OR DELETE ON ex
    BEGIN
        IF TO_CHAR(SYSDATE, 'D') IN (1,7) OR
        (TO_CHAR(SYSDATE, 'HH24') >= 15 AND TO_CHAR(SYSDATE,'HH24') <= 16) THEN
            --���� 3~4�� �뿪
            RAISE_APPLICATION_ERROR(-20001,'������ �۾��� �� �� �����ϴ�.');
        END IF;
    END;
    /
    INSERT INTO ex(num, name) VALUES(1, 'a'); --ORA-20001: ������ �۾��� �� �� �����ϴ�.
    
    
--     -------------------------------------------------------
--     -- �� Ʈ���� 
--      DML������ ������ ��� �ϳ��� DML ���� Ƚ��(��)��ŭ TRIGGER ȣ��
--      ���� ��� 10���� ���� �����Ǹ� Ʈ���ŵ� 10�� ����
--      

    DROP TABLE score2 PURGE;
    DROP TABLE score1 PURGE;
    
    CREATE TABLE score1(
        hak VARCHAR2(20) PRIMARY KEY,
        name VARCHAR2(30) NOT NULL,
        kor NUMBER(3) NOT NULL,
        eng NUMBER(3) NOT NULL,
        mat NUMBER(3) NOT NULL
    );
    
    CREATE TABLE score2(
        hak VARCHAR2(20) PRIMARY KEY,
        kor NUMBER(2,1) NOT NULL,
        eng NUMBER(2,1) NOT NULL,
        mat NUMBER(2,1) NOT NULL,
        FOREIGN KEY(hak) REFERENCES score1(hak)
    );

    CREATE OR REPLACE FUNCTION fnGrade(
        pScore NUMBER
    )
    RETURN NUMBER
    IS
        n NUMBER(2,1);
    BEGIN
        IF pScore>=95 THEN n := 4.5;
        ELSIF pScore>=90 THEN n := 4.5;
        ELSIF pScore>=85 THEN n := 4.0;
        ELSIF pScore>=80 THEN n := 3.5;
        ELSIF pScore>=75 THEN n := 3.0;
        ELSIF pScore>=70 THEN n := 2.5;
        ELSIF pScore>=65 THEN n := 2.0;
        ELSIF pScore>=60 THEN n := 1.5;
        ELSIF pScore>=55 THEN n := 1.0;
        ELSE n := 0.0;
        END IF;
        RETURN n;
    END;
    /
    SELECT fnGrade(90) from dual;
    
    --�� Ʈ���� ����� ���
    CREATE OR REPLACE TRIGGER tri_scoreInsert
    AFTER INSERT ON score1
    FOR EACH ROW -- �� Ʈ������ �� �����ϴ� ����
    DECLARE --���������
    BEGIN
        -- :NEW -> ������(score1���̺���) insert�� �� ����(�� Ʈ���Ÿ� ����� �� ����)
        INSERT INTO score2(hak, kor, eng, mat) 
        VALUES(:NEW.hak, fnGrade(:NEW.kor), fnGrade(:NEW.eng), fnGrade(:NEW.mat));
        --Ʈ���Ŵ� �ڵ� commit�� �ǹǷ� �����Ѵ�.
        --ROLLBACK�� ����� �� ����
    END;
    /
    
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('1', 'aaa',90,85,70);
    INSERT INTO score1(hak, name, kor, eng, mat) VALUES('2', 'bbb',85,60,77);
    COMMIT;
    
    SELECT * FROM score1
    JOIN score2 USING(hak);
    
    --���� Ʈ����
    CREATE OR REPLACE TRIGGER tri_scoreUpdate
    AFTER UPDATE ON score1
    FOR EACH ROW -- �� Ʈ������ �� �����ϴ� ����
    DECLARE --���������
    BEGIN
        -- :OLD -> update�ϱ� �� �� ���� (�� Ʈ���Ÿ� ����� �� ����)
        -- :NEW -> ������(score1���̺���) insert�� �� ����(�� Ʈ���Ÿ� ����� �� ����)
        UPDATE score2 SET 
            kor = fnGrade(:NEW.kor),
            eng = fnGrade(:NEW.eng),
            mat = fnGrade(:NEW.mat)
        WHERE hak = :OLD.hak;
    END;
    /
    
    UPDATE score1 SET kor=100 WHERE hak='2';
    SELECT * FROM score1
    JOIN score2 USING(hak);

    --���� Ʈ����
    CREATE OR REPLACE TRIGGER tri_scoreDelete
    --AFTER�� �����ϴ��� ����Ŭ�� �ڵ����� ���̺��� ���Ը� �ľ��Ͽ� ���� �۾��� ������ ��
    --�� score1���̺� �����ǰ� �����Ƿ� ���� ������ζ�� AFTER�� �����ϸ� ������!! ������ ���� �ʴ� ���� �´�.
    BEFORE DELETE ON score1
    FOR EACH ROW -- �� Ʈ������ �� �����ϴ� ����
    DECLARE --���������
    BEGIN
        -- :OLD -> delete�� �� ���� (�� Ʈ���Ÿ� ����� �� ����)
        DELETE FROM score2 WHERE hak = :OLD.hak;
    END;
    /
    
    DELETE FROM score1;
    COMMIT;
    SELECT * FROM score1
    JOIN score2 USING(hak);
    
    --����1)
    
    
    
-- �� ��Ű��(Package)
--     -------------------------------------------------------
-- EXEC DBMS_OUTPUT.PUT_LINE(�μ�);
-- EXEC ��Ű����.���ν�����(����);
EXEC DBMS_OUTPUT.PUT_LINE('TEST');

--��Ű�� ��� Ȯ��
SELECT * FROM user_objects WHERE object_type = 'PACKAGE';
SELECT * FROM user_objects WHERE object_type = 'PACKAGE_BODY';
SELECT * FROM user_procedures; --WHERE object_type='PACKAGE';

SELECT * FROM user_objects; --���̺�, �ε���, Ʈ����, �� ��... ��� ��ü�� ��ȸ�� �� ����.
