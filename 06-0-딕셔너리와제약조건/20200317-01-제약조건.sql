--    3) �⺻Ű ���� ���� ����
--       -------------------------------------------------------
    desc test5;
    
    SELECT * FROM user_constraints WHERE table_name='TEST5';
    
    --����) �߰��� ���� ����
    ALTER TABLE ���̺�� ADD CONSTRAINTS �����̸� PRIMARY KEY (�÷�, [, �÷�]);--�������� �̸� ����
    ALTER TABLE ���̺�� ADD PRIMARY KEY (�÷�, [, �÷�]);--�������� �̸� ������
    
    --�������� ������ ���� ����
    --#1) �⺻Ű�� ���� �� ����
    ALTER TABLE ���̺�� DROP PRIMARY KEY;
    --#2) ��� ���������� ���� �� ���
    ALTER TABLE ���̺�� DROP CONSTRAINTS ���������̸�;
    
    
    ALTER TABLE test5 DROP PRIMARY KEY;
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEST5';

    --�׽�Ʈ�� ���̺� ���� ����
    DROP TABLE test1 PURGE;
    DROP TABLE test2 PURGE;
    DROP TABLE test3 PURGE;
    DROP TABLE test4 PURGE;
    DROP TABLE test5 PURGE;
    SELECT * FROM TAB;
--
--
--   �� UNIQUE ���� ����
--      �ߺ� ������ ������� ����. - Ʃ���� ���ϼ��� �����Ѵ�.
--      �÷� NULL�� ����ϴ� ��� NULL���� ���� �� ����. (NOT NULL�̶�� �������� ���� ���)
--      �ϳ��� ���̺� �� �� �̻��� UNIQUE KEY�� ������ �� ����.

--    1) ���̺� ������ ���ÿ� UNIQUE ���� ���� ����
--      (1) �÷� ���� ����� UNIQUE ���� ����
--        -------------------------------------------------------
        CREATE TABLE ���̺��(
            �÷��� Ÿ��[(ũ��)] [CONSTRAINT �����̸�] UNIQUE,
            ...
        );        
--
--
--      (2) ���̺� ���� ����� UNIQUE ���� ���� ����
--        -------------------------------------------------------
        CREATE TABLE ���̺��(
            �÷��� Ÿ��[(ũ��)],
            [CONSTRAINT �����̸�] UNIQUE (�÷���, [, �÷���])
        );
        
        CREATE TABLE test1(
            id VARCHAR2(50),
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(30) NOT NULL,
            rrn VARCHAR2(30) NOT NULL,
            CONSTRAINT PK_TEST1_ID PRIMARY KEY(id),
            CONSTRAINT UQ_TEST1_RRN UNIQUE (rrn)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST1'; --�÷��� ��ȸ���� ��ȸ ����
        
--
--    2) �����ϴ� ���̺� UNIQUE ���� ���� ����
--     -------------------------------------------------------
        ALTER TABLE ���̺�� ADD [CONSTRAINT �������Ǹ�] UNIQUE(�÷���, [,�÷��� ...]);
--
--
--    3) UNIQUE ���� ���� ����
--      -------------------------------------------------------
        --#1) ����
        ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;
        --#2) �������� ����
        ALTER TABLE ���̺�� DROP UNIQUE(�÷���, [,�÷���]); --�����ߴ� ��� �÷� ����ؾ� ������
--
--
--
--   �� NOT NULL ���� ����
--      NULL: ���� ���� ���ų� �ǹ̾��� ���� ��Ÿ���� ��� 
--      ����Ŭ������ ''�� NULL�� ���������� ' '(����)�� NULL�� �ƴϴ�.
--     1) ���̺� ������ NOT NULL ���� ���� ����
--       -------------------------------------------------------
        CREATE TABLE ���̺��(
            �÷Ÿ� Ÿ��[(ũ��)] ... NOT NULL, ...
        ); --�������� Ȯ�� �� CONSTRAINT_TYPE�� C(check)�� Ȯ�εȴ�.
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
--
--
--     2) �����ϴ� ���̺� NOT NULL ���� ���� ����
--      ��, NULL���� �̹� �����ϴ� �÷��� ��� NOT NULL ������������ ������ �� ����.
--       -------------------------------------------------------
        --#1)
        ALTER TABLE ���̺�� MODIFY �÷��� NOT NULL;
        --#2)
        ALTER TABLE ���̺�� MODIFY (�÷��� Ÿ��[(ũ��)] NOT NULL); --Ÿ�Ա��� ����
        --#3) üũ Ÿ���� ���� 
        ALTER TABLE ���̺�� ADD [CONSTRAINT �������Ǹ�] CHECK (�÷� IS NOT NULL);
        
        CREATE TABLE TEST2(
            id VARCHAR2(50) PRIMARY KEY,
            pwd VARCHAR2(100),
            name VARCHAR2(30)
        );
        ALTER TABLE test2 MODIFY name NOT NULL;
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST2';
        
--
--
--     3) NOT NULL ���� ���� ����
--       -------------------------------------------------------
        --#1) NULL�� �������� ������ �����ϱ�
        ALTER TABLE ���̺�� MODIFY �÷��� NULL;
        --#2) �������Ǹ��� �̿��Ͽ� �����
        ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;
        
        ALTER TABLE test2 MODIFY name NULL;
        ALTER TABLE test2 DROP CONSTRAINT �������Ǹ�;
        ALTER TABLE test2 DROP CONSTRAINT SYS_C007655; -- �������� �̸����� �����ϴ� ����
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST2';
--
--
--   �� DEFAULT
--     1) ���̺� ������ DEFAULT ����
--     -------------------------------------------------------
        CREATE TABLE test3(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(100) NOT NULL,
            subject VARCHAR2(500) NOT NULL,
            content VARCHAR2(4000) NOT NULL,
            created DATE DEFAULT SYSDATE,
            hitcount NUMBER DEFAULT 0 
        );
        --�������� Ȯ��
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST3';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST3';
        --���ǻ���: DEFAULT�� ��������� �ƴϴ�
        --DEFAULT Ȯ�� (COL�δ� Ȯ���� �Ұ����ϴ�)
        --DATA_DEFAULT �÷��� ���� �⺻���� ������ DEFAULT���� �ִٴ� ���� Ȯ���� �� �ִ�.
        SELECT * FROM COLS WHERE table_name='TEST3';
        SELECT column_name, data_default FROM COLS WHERE table_name='TEST3';
--
--     2) DEFAULT Ȯ��
         SELECT column_name, data_type, data_precision, data_length, nullable, data_default 
         FROM user_tab_columns WHERE table_name='���̺��';
    
        --������ �߰�
        INSERT INTO test3(id, name, subject, content, created, hitCount) VALUES('1','a','a','a','2000-10-10',1);
        INSERT INTO test3(id, name, subject, content ) VALUES('2','b','b','b'); --��¥�� ��ȸ�� �⺻���� �ԷµǾ���
        INSERT INTO test3(id, name, subject, content, created, hitCount) VALUES('3','c','c','c',DEFAULT,2); --��¥�� �⺻������ �Էµ�
        INSERT INTO test3(id, name, subject, content, created) VALUES('4','d','d','d',SYSDATE); --���� �̷���??
        COMMIT;
        SELECT * FROM test3;

--     3) DEFAULT ����
--       -------------------------------------------------------
        ALTER TABLE test3 MODIFY hitcount DEFAULT NULL;
        SELECT column_name, data_default FROM cols WHERE table_name='TEST3';
        
        INSERT INTO test3(id, name, subject, content) VALUES('5','b','b','b');
        COMMIT;
        SELECT * FROM test3;
        
--
--   �� CHECK ���� ���� --CHECK ���������� ���ڰ� C�̴�. (CONSTRAINT_TYPE)
--    1) ���̺� ������ ���ÿ� CHECK ���� ���� ����
--      (1) �÷� ���� ����� CHECK ���� ����
--       -------------------------------------------------------
        CREATE TABLE ���̺��(
            �÷��� Ÿ��[(ũ��)] [CONSTRAINT �������Ǹ�] CHECK(����), ...
        );
--
--      (2) ���̺� ���� ����� CHECK ���� ����
--       -------------------------------------------------------   
        CREATE TABLE ���̺��(
            �÷��� Ÿ��[(ũ��)], ....
            [CONSTRAINT �����̸�] CHECK(����)
        );
        --SEARCH_CONDITION�÷��� üũ ���������� ����.
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
        
        CREATE TABLE test4(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(50) NOT NULL,
            gender CHAR(1) CHECK(gender IN ('M','m','F','f')),
            score NUMBER(3) DEFAULT 0,
            CONSTRAINT CH_TEST4_SCORE CHECK(score BETWEEN 0 AND 100)
        );
        INSERT INTO test4(id, name, gender, score) VALUES('1','a','M',100);
        COMMIT;
        INSERT INTO test4(id, name, gender, score) VALUES('2','b','M',120);--ORA-02290: üũ ��������(SKY.CH_TEST4_SCORE)�� ����Ǿ����ϴ�.
        --CHECK���� ���� 
        SELECT * FROM TEST4;
        TRUNCATE TABLE test4;

        
--
--    2) �����ϴ� ���̺� CHECK ���� ���� ����
--     -------------------------------------------------------
        --����1) test4���̺� ������ ���� 2���� �÷��� �߰�
        --sdate DATE NULL ���
        --edate DATE NULL ���
        --CHECK �������� �߰��ϱ�: sdate <= edate
        ALTER TABLE test4 ADD (
            sdate DATE,
            edate DATE,
            CONSTRAINT CH_TEST4_DATES CHECK (sdate<=edate) --�� �߰� ����� ���ÿ� �������� ����
        );
        --Ȥ�� 2���� ����
        ALTER TABLE test4 ADD(--���� �߰� 
            sdate DATE,
            edate DATE
        );
        ALTER TABLE test4 ADD CONSTRAINT CH_TEST4_DATES CHECK(sdate<=edate); --�������� ����
        
        --�������� �����
        ALTER TABLE test4 DROP CONSTRAINT CH_TEST4_DATES;
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
--        INSERT INTO test4(id,name,gender,score,sdate,edate) VALUES('1','��','m',100,SYSDATE-2,SYSDATE);
--        INSERT INTO test4(id,name,gender,score,sdate,edate) VALUES('1','��','m',100,SYSDATE,SYSDATE); --ORA-00001: ���Ἲ �������ǿ� ����
--        SELECT * FROM TEST4;
        UPDATE test4 SET sdate='2000-10-10', edate='2000-09-09' WHERE id='1';--CHECK����
        UPDATE test4 SET sdate='2000-10-10', edate='2000-10-11' WHERE id='1';--���� ����
        COMMIT;
        SELECT * FROM test4;
        
        --sdate�� edate�� NOT NULL ���������� �߰��ϱ�
        ALTER TABLE test4 MODIFY sdate NOT NULL;
        ALTER TABLE test4 ADD CHECK (sdate IS NOT NULL);
        ALTER TABLE test4 MODIFY edate NOT NULL;
        ALTER TABLE test4 ADD CHECK (edate IS NOT NULL);
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
        
--
--
--    3) CHECK ���� ���� ����
--     -------------------------------------------------------
        ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;
        --TEST4�� gender�� check�������� �����ϱ� (SYS_C007661);
        ALTER TABLE test4 DROP CONSTRAINT SYS_C007661;
--
--   �� ���� Ű(�ܷ� Ű, FOREIGN KEY) �Ǵ� REFERENCE KEY
--      ���̺� ���� �ϰ����� �����ϱ� ���� ���������� �����ϴ� ��.
--      ��. �θ� ���̺��� PRIMARY KEY�� UNIQUE�� �ܷ�Ű�� ����� �� ����.
--      ��. �θ� ���̺��� �÷��� �ڽ� ���̺��� �÷��� ���� �ڷ����� ��ġ�ؾ� �Ѵ�.
--      ��. �θ� ���̺� ���� ������ �ڽ� ���̺� �Է��� �� ����.
--  
--     1) ���̺� ������ ���ÿ� FOREIGN KEY ���� ���� ����
--       (1) �÷� ���� ����� FOREIGN KEY ���� ����
--           ����Ű�� ������ ��� ������ ������ �÷� ���� ������δ� ������� �ʴ´�.
--        -------------------------------------------------------        
        CREATE TABLE ���̺��(
            �÷��� Ÿ��[(ũ��)] [CONSTRAINT �������Ǹ�] 
            REFERENCES �θ����̺��(�θ����̺����÷���) [ON DELETE | CASCADE | SET NULL], ...
        );
        
        --test1: �θ� ���̺�
        CREATE TABLE test1(
            code VARCHAR2(30) PRIMARY KEY,
            subject VARCHAR2(50) NOT NULL
        );
        
        --exam1: �ڽ����̺� -> �θ��� PRIMARY, UNIQUE�� ������ �����ϴ�
        CREATE TABLE exam1(
            id VARCHAR2(30) PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            code VARCHAR2(30),
            CONSTRAINT fk_exam1_code 
            FOREIGN KEY(code) REFERENCES test1(code)
        );
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1'; --R(REFERENCE KEY)
        INSERT INTO exam1(id, name, code) VALUES('1','a','x100');
        --ORA-02291: ���Ἲ �������� (SKY.FK_EXAM1_CODE)�� ����Ǿ����ϴ�. �θ�Ű�� �����ϴ�.
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1'; --R(REFERENCE KEY)
        INSERT INTO exam1(id, name, code) VALUES('1','a',null);
        --����Ű�� NULL�� ����ϹǷ� �θ� ��� �߰��� �� ����
        COMMIT;
        SELECT * FROM exam1;
        
        --test1 �θ� �� ����
        INSERT INTO test1(code, subject) VALUES('x100','a');
        INSERT INTO test1(code, subject) VALUES('x101','b');
        INSERT INTO test1(code, subject) VALUES('x102','c');
        
        INSERT INTO exam1(id, name, code) VALUES('2','2','x100');
        INSERT INTO exam1(id, name, code) VALUES('3','2','x102');
        INSERT INTO exam1(id, name, code) VALUES('4','2','x100');
        
        UPDATE exam1 SET code='x100' WHERE id='4';
        
        UPDATE test1 SET code='x200' WHERE code='x100';--ORA-02292: ���Ἲ �������� ����
        --�̹� test1�� code�÷��� �����ϴ� �ڽĵ��� �ֱ� ������ ���� ���Ƿ� ������ �� ����.
        UPDATE test1 SET code='x201' WHERE code='x101';
        --�����ϰ� �ִ� �ڽ� ���� �����ϱ� ������ �� ����.
        SELECT * FROM test1; --x201�� �����Ǿ� ������ Ȯ���� �� �ִ�.
        SELECT * FROM test1;
        
        DELETE FROM test1 WHERE code='x100';--ORA-02292: ���Ἲ �������� ����
        --�̹� test1�� code�÷��� �����ϴ� �ڽĵ��� �ֱ� ������ ���������� ���Ƿ� ������ ���� ����.
        DELETE FROM test1 WHERE code='x201';--���������� ������. (�����ϴ� �ڽ� ���� ����)
        COMMIT;
        
        DROP TABLE test1 PURGE;--����: ORA-02449: �ܷ� Ű�� ���� �����Ǵ� ����/�⺻ Ű�� ���̺� �ֽ��ϴ�.
        --�̹� �ڽ� ���̺��� �����ϰ� �����Ƿ� ������ �� ����.
        DROP TABLE test1 CASCADE CONSTRAINTS PURGE; --�θ��ڽİ��谡 ������
        --���� ����: �ڽ� ���̺��� ����Ű�� �����ȴ�.(����)
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1';
        DROP TABLE exam1 PURGE;
        
--
--       (2) ���̺� ���� ����� FOREIGN KEY ���� ����
--        -------------------------------------------------------
        --�θ����̺�: �����ϴ� �÷��� �����Ǵ� �÷����� �޶� Ÿ�԰��� ũ�Ⱑ ������ �����ϴ�.
        CREATE TABLE test2(
            num NUMBER PRIMARY KEY,
            subject VARCHAR2(50) NOT NULL
        );
        
        --�ڽ����̺�
        CREATE TABLE exam2(
            id VARCHAR2(30) PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            snum NUMBER NOT NULL,
            FOREIGN KEY(snum) REFERENCES test2(num)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2'; 
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM2'; --R ���������� ������ Ȯ���� �� �ִ�.
        
        --���� ���� ������ �ڽ� ���̺��� ���� ����� �θ� ���̺��� �����Ѵ�.
        DROP TABLE exam2 PURGE;
        DROP TABLE test2 PURGE;
        
        -------------------------------
        -- �����̼� ������ ����
        
        CREATE TABLE mem1(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(50) NOT NULL,
            pwd VARCHAR2(100) NOT NULL
        );
        
        --1:1 ����(�ĺ� ����: �⺻Ű�̸鼭 ����Ű)
        
        CREATE TABLE mem2(
            id  VARCHAR2(50),
            birth DATE,
            tel VARCHAR2(50),
            CONSTRAINT pk_mem2_id PRIMARY KEY(id), --�ܷ�Ű���� �⺻Ű�� ���������Ƿ� 1:1������ �ȴ�.
            CONSTRAINT fk_mem2_id FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        --1:N ����(��ĺ�����)
        CREATE TABLE guest(--����
            num NUMBER PRIMARY KEY,
            content VARCHAR2(4000) NOT NULL,
            id VARCHAR2(50) NOT NULL, --mem1 ���̺� ��ϵ� id�� ������ �����ϵ��� ����
            created DATE DEFAULT SYSDATE,
            CONSTRAINT fk_guest_id FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        
        CREATE TABLE guestLike(--���ƿ� ���̺�
            --�ϳ��� �Խù����� �ϳ��� id�� ���ƿ並 ���� �� �ִٴ� ������ �ɸ�.
            num NUMBER,
            id VARCHAR2(50),
            PRIMARY KEY(num, id), --�⺻Ű�� ������ �� ���� �� ���� �� ������ �÷��� ������ �߿��ϴ�.
            FOREIGN KEY(num) REFERENCES guest(num),
            FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        -- ����
            --  mem1: guestLike => 1:N (�ĺ�)
            --  guest: guestLike => 1:N (�ĺ�)
         select * from user_constraints where table_name='GUESTLIKE';
        
        SELECT * FROM TAB;
        DROP TABLE GUESTLIKE PURGE;
        DROP TABLE GUEST PURGE;
        DROP TABLE MEM2 PURGE;
        DROP TABLE MEM1 PURGE;
        
        --������ ���̺��� �� �� �̻� ����: ��)���� ��
        CREATE TABLE mem1(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(50) NOT NULL,
            pwd VARCHAR2(100) NOT NULL
        );
        
        CREATE TABLE note(
            num NUMBER PRIMARY KEY,
            sendId VARCHAR2(50) NOT NULL,
            receiveId VARCHAR2(50) NOT NULL,
            content VARCHAR2(4000) NOT NULL,
--            PRIMARY KEY(num),
            FOREIGN KEY(sendId) REFERENCES mem1(id),
            FOREIGN KEY(receiveId) REFERENCES mem1(id)
            --������ ���̺��� �÷��� �� �� �̻� �����Ͽ��� (�̷��� �Ͽ��� �������)
        );
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='NOTE';
        DROP TABLE note PURGE;
        DROP TABLE mem1 PURGE;
        
        --�ڱ� �ڽ� ���̺��� �÷��� ����: ��з�/�ߺз� ...
        CREATE TABLE test1(
            num NUMBER PRIMARY KEY,
            subject VARCHAR2(1000) NOT NULL,
            snum NUMBER,
            FOREIGN KEY(snum) REFERENCES test1(num)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
        drop table test1 purge;
        
        -- ON DELETE CASCADE
        CREATE TABLE test1(
            syear NUMBER(4),
            hak VARCHAR2(30),
            name VARCHAR2(30),
            PRIMARY KEY(syear, hak)
        );
        
        CREATE TABLE exam1(
            num NUMBER PRIMARY KEY,
            syear NUMBER(4) NOT NULL,
            hak VARCHAR2(30) NOT NULL,
            score NUMBER(3) NOT NULL,
            FOREIGN KEY(syear, hak) REFERENCES test1(syear, hak) ON DELETE CASCADE --��, �ſ� ������ �ɼ��̴�.
        );
        
        INSERT INTO test1(syear,hak,name) VALUES(2020,'1','a');
        INSERT INTO test1(syear,hak,name) VALUES(2020,'2','b');
        INSERT INTO test1(syear,hak,name) VALUES(2020,'3','c');
        
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);
        INSERT INTO exam1(num,syear,hak,score) VALUES(2,2020,'1',80);
        INSERT INTO exam1(num,syear,hak,score) VALUES(3,2020,'2',60);
        
        DELETE FROM test1 WHERE syear=2020 and hak='1'; --�����ϴ�
        --���̺� ���� �� �ڽ� ���̺��� ON DELETE �̺�Ʈ�� �߻��� ��� CASCADE�� �����Ͽ��� ������
        --�θ� �������� �ڽĵ� �������� �Ǿ���.
        COMMIT;
        
        SELECT * FROM TEST1 T, EXAM1 E WHERE T.SYEAR=E.SYEAR AND T.HAK = E.HAK;
        
--     2) �����ϴ� ���̺� FOREIGN KEY ���� ���� ����
--       -------------------------------------------------------
        ALTER TABLE ���̺�� ADD 
            [CONSTRAINT �������Ǹ�]
            FOREIGN KEY(�÷���[, �÷�]) REFERENCES �θ����̺�(�θ��÷���[, �÷�])
            [ON DELETE CASCADE | SET NULL];
--
--
--     3) FOREIGN KEY ���� ���� ����
--      -------------------------------------------------------
        ALTER TABLE ���̺�� DROP CONSTRAINT �������Ǹ�;
--
--
--
--   �� ���� ���� Ȱ��ȭ �� ��Ȱ��ȭ
--  �ϰ������� ����� �����͸� �Է��� ��� ���������� ������ �����ϰ� �ɸ���.
--  ���� �̷��� ��� ���� ������ ��Ȱ��ȭ�ϰ� �ٽ� Ȱ��ȭ�ϴ� ����� �����Ѵ�.
--  ��, �Էµ� �����Ͱ� �������ǿ� �������� ���� ��쿡�� ���������� Ȱ��ȭ���� ������ �����Ѵ�.
--  ����, ���������� �̸��� �˾ƾ߸� Ȱ��ȭ/��Ȱ��ȭ�� �����ϴ�
--
--     1) �����ϴ� ���̺��� ���� ���� �� Ȱ��ȭ
--     -------------------------------------------------------

        --���������� ���� �ʾ��� ���
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);
        --ORA-02291: �θ� ���� ���� �߰��� �Ұ����ϴ�. (SYS_C007719 �������Ǹ�)
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1';
        
        --����Ű ��Ȱ��ȭ
        ALTER TABLE exam1 DISABLE CONSTRAINT SYS_C007719 CASCADE;
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);--����Ű�� ��Ȱ��ȭ �ϴϱ� �����Ͱ� ���ԵǾ���.
        ROLLBACK;
    
--
--     2) ���̺��� ���� ���� Ȱ��ȭ
--     -------------------------------------------------------
        --����Ű Ȱ��ȭ�ϱ�
        ALTER TABLE exam1 ENABLE VALIDATE CONSTRAINT SYS_C007719; --�ڽ��̶� CASCADE������ �޸� ������� �ʴ´�.
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);--ORA-02291������ �ٽ� �߻�
        
