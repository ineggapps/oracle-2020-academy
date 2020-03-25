---------------------------------------------------------------
-- ��ǰ ���̺� �ۼ�
CREATE TABLE ��ǰ (
   ��ǰ�ڵ�    VARCHAR2(6) NOT NULL PRIMARY KEY
  ,��ǰ��      VARCHAR2(30)  NOT NULL
  ,������      VARCHAR2(30)  NOT NULL
  ,�Һ��ڰ���  NUMBER
  ,������    NUMBER DEFAULT 0
);

-- �԰� ���̺� �ۼ�
CREATE TABLE �԰� (
   �԰��ȣ   NUMBER PRIMARY KEY
  ,��ǰ�ڵ�   VARCHAR2(6) NOT NULL
                  CONSTRAINT fk_ibgo_no REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�԰�����   DATE
  ,�԰����   NUMBER
  ,�԰�ܰ�   NUMBER
);

-- �Ǹ� ���̺� �ۼ�
CREATE TABLE �Ǹ� (
   �ǸŹ�ȣ   NUMBER  PRIMARY KEY
  ,��ǰ�ڵ�   VARCHAR2(6) NOT NULL
        CONSTRAINT fk_pan_no REFERENCES ��ǰ(��ǰ�ڵ�)
  ,�Ǹ�����   DATE
  ,�Ǹż���   NUMBER
  ,�ǸŴܰ�   NUMBER
);

-- ��ǰ ���̺� �ڷ� �߰�
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('AAAAAA', '��ī', '���', 100000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('BBBBBB', '��ǻ��', '����', 1500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('CCCCCC', '�����', '���', 600000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
        ('DDDDDD', '�ڵ���', '�ٿ�', 500000);
INSERT INTO ��ǰ(��ǰ�ڵ�, ��ǰ��, ������, �Һ��ڰ���) VALUES
         ('EEEEEE', '������', '���', 200000);
COMMIT;
SELECT * FROM ��ǰ;


---------------------------------------------------------------
-- 3. Ʈ���� �ۼ�
 -- 1) �԰� ���̺� INSERT Ʈ���Ÿ� �ۼ� �Ѵ�.
   -- [�԰�] ���̺� �ڷᰡ �߰� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER insTrg_Ipgo
AFTER INSERT ON �԰�
FOR EACH ROW

BEGIN
     UPDATE ��ǰ SET ������ = ������ + :NEW.�԰���� 
           WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;
/

-- �԰� ���̺� ������ �Է�
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (1, 'AAAAAA', '2004-10-10', 5,   50000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (2, 'BBBBBB', '2004-10-10', 15, 700000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (3, 'AAAAAA', '2004-10-11', 15, 52000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (4, 'CCCCCC', '2004-10-14', 15,  250000);
INSERT INTO �԰� (�԰��ȣ, ��ǰ�ڵ�, �԰�����, �԰����, �԰�ܰ�)
              VALUES (5, 'BBBBBB', '2004-10-16', 25, 700000);
COMMIT;

SELECT * FROM ��ǰ;
SELECT * FROM �԰�;


 -- 2) �԰� ���̺� UPDATE Ʈ���Ÿ� �ۼ� �Ѵ�.
--  [�԰�] ���̺��� �ڷᰡ ���� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER upTrg_Ipgo
AFTER UPDATE ON �԰�
FOR EACH ROW
BEGIN
     UPDATE ��ǰ SET ������ = ������ - :OLD.�԰���� + :NEW.�԰����
            WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
END;
/

-- UPDATE �׽�Ʈ
UPDATE �԰� SET �԰���� = 30 WHERE �԰��ȣ = 5;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �԰�;


 -- 3) �԰� ���̺� DELETE Ʈ���Ÿ� �ۼ� �Ѵ�.
 -- [�԰�] ���̺��� �ڷᰡ �����Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER delTrg_Ipgo
AFTER DELETE ON �԰�
FOR EACH ROW
BEGIN
     UPDATE ��ǰ SET ������ = ������ - :OLD.�԰����
           WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;
/

-- DELETE �׽�Ʈ
DELETE FROM �԰� WHERE �԰��ȣ = 5;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �԰�;

  -- �԰� ���̺��� ��� ���� ���� �� ������ ��ǰ ���̺��� ��� ������ ���ų� ������ �� �� �����Ƿ� UPDATE �� DELETE Ʈ���Ÿ� BEFORE Ʈ���ŷ� �����Ͽ� ��ǰ ���̺��� ��� ������ ���� ���� �Ǵ� ������ �Ҽ� ������ �����Ѵ�.


 -- 4) �Ǹ� ���̺� INSERT Ʈ���Ÿ� �ۼ��Ѵ�.(BEFORE Ʈ���ŷ� �ۼ�)
 -- [�Ǹ�] ���̺� �ڷᰡ �߰� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER insTrg_Pan
BEFORE INSERT ON �Ǹ�
FOR EACH ROW

DECLARE
  j_qty NUMBER;

BEGIN

   SELECT ������ INTO j_qty FROM ��ǰ WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   IF :NEW.�Ǹż��� > j_qty THEN
      RAISE_APPLICATION_ERROR(-20007, '�Ǹ� ����');
   ELSE
      UPDATE ��ǰ SET ������ = ������ - :NEW.�Ǹż��� 
          WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   END IF;
END;
/

-- �Ǹ� ���̺� ������ �Է�
INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
         (1, 'AAAAAA', '2004-11-10', 5, 1000000);
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;

INSERT INTO �Ǹ� (�ǸŹ�ȣ, ��ǰ�ڵ�, �Ǹ�����, �Ǹż���, �ǸŴܰ�) VALUES
         (1, 'AAAAAA', '2004-11-10', 50, 1000000);
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;


 -- 5) �Ǹ� ���̺� UPDATE Ʈ���Ÿ� �ۼ��Ѵ�.(BEFORE Ʈ���ŷ� �ۼ�)
 -- [�Ǹ�] ���̺��� �ڷᰡ ���� �Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER upTrg_Pan
BEFORE UPDATE ON �Ǹ�
FOR EACH ROW

DECLARE
  j_qty NUMBER;

BEGIN

   SELECT ������ INTO j_qty FROM ��ǰ WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   IF :NEW.�Ǹż���  > (j_qty + :OLD.�Ǹż���) THEN
     raise_application_error(-20007, '�Ǹŷ��� ������� ���� �� �����ϴ�.');
   ELSE
        UPDATE ��ǰ SET ������ = ������ + :OLD.�Ǹż��� - :NEW.�Ǹż��� 
                WHERE ��ǰ�ڵ� = :NEW.��ǰ�ڵ�;
   END IF;
END;
/

-- UPDATE �׽�Ʈ
UPDATE �Ǹ� SET �Ǹż��� = 200 WHERE �ǸŹ�ȣ = 1;
UPDATE �Ǹ� SET �Ǹż��� = 10 WHERE �ǸŹ�ȣ = 1;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;


 -- 6) �Ǹ� ���̺� DELETE Ʈ���Ÿ� �ۼ� �Ѵ�.
 -- [�Ǹ�] ���̺� �ڷᰡ �����Ǵ� ��� [��ǰ] ���̺��� [������]�� ���� �ǵ��� Ʈ���Ÿ� �ۼ��Ѵ�.

CREATE OR REPLACE TRIGGER delTrg_Pan
AFTER DELETE ON �Ǹ�
FOR EACH ROW

BEGIN
     UPDATE ��ǰ SET ������ = ������ + :OLD.�Ǹż���
        WHERE ��ǰ�ڵ� = :OLD.��ǰ�ڵ�;
END;
/

-- DELETE �׽�Ʈ
DELETE �Ǹ� WHERE �ǸŹ�ȣ = 1;
COMMIT;
SELECT * FROM ��ǰ;
SELECT * FROM �Ǹ�;


---------------------------------------------------------------
--  ������ ���� ����� �̿��Ͽ� ���õ� Ʈ���Ŵ� �ϳ��� Ʈ���ŷ� �ۼ� �� �� �ִ�.
 -- IF INSERTING THEN 
 --    �߰��� �� 
 -- ELSIF UPDATING THEN
 --    ������ �� 
 -- ELSIF DELETING THEN
 --    ������ �� 
--   END IF;
