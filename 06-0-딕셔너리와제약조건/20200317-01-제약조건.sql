--    3) 기본키 제약 조건 삭제
--       -------------------------------------------------------
    desc test5;
    
    SELECT * FROM user_constraints WHERE table_name='TEST5';
    
    --복습) 추가할 때의 문법
    ALTER TABLE 테이블명 ADD CONSTRAINTS 제약이름 PRIMARY KEY (컬럼, [, 컬럼]);--제약조건 이름 지정
    ALTER TABLE 테이블명 ADD PRIMARY KEY (컬럼, [, 컬럼]);--제약조건 이름 미지정
    
    --제약조건 삭제할 때의 문법
    --#1) 기본키를 지울 때 간편
    ALTER TABLE 테이블명 DROP PRIMARY KEY;
    --#2) 모든 제약조건을 지울 때 사용
    ALTER TABLE 테이블명 DROP CONSTRAINTS 제약조건이름;
    
    
    ALTER TABLE test5 DROP PRIMARY KEY;
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='TEST5';

    --테스트용 테이블 전부 삭제
    DROP TABLE test1 PURGE;
    DROP TABLE test2 PURGE;
    DROP TABLE test3 PURGE;
    DROP TABLE test4 PURGE;
    DROP TABLE test5 PURGE;
    SELECT * FROM TAB;
--
--
--   ο UNIQUE 제약 조건
--      중복 데이터 허용하지 않음. - 튜플의 유일성을 보장한다.
--      컬럼 NULL을 허용하는 경우 NULL값을 가질 수 있음. (NOT NULL이라고 지정하지 않은 경우)
--      하나의 테이블에 두 개 이상의 UNIQUE KEY를 지정할 수 있음.

--    1) 테이블 생성과 동시에 UNIQUE 제약 조건 설정
--      (1) 컬럼 레벨 방식의 UNIQUE 제약 설정
--        -------------------------------------------------------
        CREATE TABLE 테이블명(
            컬럼명 타입[(크기)] [CONSTRAINT 제약이름] UNIQUE,
            ...
        );        
--
--
--      (2) 테이블 레벨 방식의 UNIQUE 제약 조건 설정
--        -------------------------------------------------------
        CREATE TABLE 테이블명(
            컬럼명 타입[(크기)],
            [CONSTRAINT 제약이름] UNIQUE (컬럼명, [, 컬럼명])
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
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST1'; --컬럼명 조회까지 조회 가능
        
--
--    2) 존재하는 테이블에 UNIQUE 제약 조건 설정
--     -------------------------------------------------------
        ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] UNIQUE(컬럼명, [,컬럼명 ...]);
--
--
--    3) UNIQUE 제약 조건 삭제
--      -------------------------------------------------------
        --#1) 권장
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
        --#2) 권장하지 않음
        ALTER TABLE 테이블명 DROP UNIQUE(컬럼명, [,컬럼명]); --지정했던 모든 컬럼 명시해야 지워짐
--
--
--
--   ο NOT NULL 제약 조건
--      NULL: 실제 값이 없거나 의미없는 값을 나타내는 경우 
--      오라클에서는 ''은 NULL로 간주하지만 ' '(공백)은 NULL이 아니다.
--     1) 테이블 생성시 NOT NULL 제약 조건 설정
--       -------------------------------------------------------
        CREATE TABLE 테이블명(
            컬렴명 타입[(크기)] ... NOT NULL, ...
        ); --제약조건 확인 시 CONSTRAINT_TYPE이 C(check)로 확인된다.
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
--
--
--     2) 존재하는 테이블에 NOT NULL 제약 조건 설정
--      단, NULL값이 이미 존재하는 컬럼의 경우 NOT NULL 제약조건으로 설정할 수 없음.
--       -------------------------------------------------------
        --#1)
        ALTER TABLE 테이블명 MODIFY 컬럼명 NOT NULL;
        --#2)
        ALTER TABLE 테이블명 MODIFY (컬럼명 타입[(크기)] NOT NULL); --타입까지 변경
        --#3) 체크 타입을 선언 
        ALTER TABLE 테이블명 ADD [CONSTRAINT 제약조건명] CHECK (컬럼 IS NOT NULL);
        
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
--     3) NOT NULL 제약 조건 삭제
--       -------------------------------------------------------
        --#1) NULL로 제약조건 역으로 설정하기
        ALTER TABLE 테이블명 MODIFY 컬럼명 NULL;
        --#2) 제약조건명을 이용하여 지우기
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
        
        ALTER TABLE test2 MODIFY name NULL;
        ALTER TABLE test2 DROP CONSTRAINT 제약조건명;
        ALTER TABLE test2 DROP CONSTRAINT SYS_C007655; -- 제약조건 이름으로 삭제하는 예제
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST2';
--
--
--   ο DEFAULT
--     1) 테이블 생성시 DEFAULT 설정
--     -------------------------------------------------------
        CREATE TABLE test3(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(100) NOT NULL,
            subject VARCHAR2(500) NOT NULL,
            content VARCHAR2(4000) NOT NULL,
            created DATE DEFAULT SYSDATE,
            hitcount NUMBER DEFAULT 0 
        );
        --제약조건 확인
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST3';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST3';
        --주의사항: DEFAULT는 제약사항이 아니다
        --DEFAULT 확인 (COL로는 확인이 불가능하다)
        --DATA_DEFAULT 컬럼에 보면 기본으로 지정한 DEFAULT값이 있다는 것을 확인할 수 있다.
        SELECT * FROM COLS WHERE table_name='TEST3';
        SELECT column_name, data_default FROM COLS WHERE table_name='TEST3';
--
--     2) DEFAULT 확인
         SELECT column_name, data_type, data_precision, data_length, nullable, data_default 
         FROM user_tab_columns WHERE table_name='테이블명';
    
        --데이터 추가
        INSERT INTO test3(id, name, subject, content, created, hitCount) VALUES('1','a','a','a','2000-10-10',1);
        INSERT INTO test3(id, name, subject, content ) VALUES('2','b','b','b'); --날짜와 조회수 기본값이 입력되었음
        INSERT INTO test3(id, name, subject, content, created, hitCount) VALUES('3','c','c','c',DEFAULT,2); --날짜는 기본값으로 입력됨
        INSERT INTO test3(id, name, subject, content, created) VALUES('4','d','d','d',SYSDATE); --굳이 이렇게??
        COMMIT;
        SELECT * FROM test3;

--     3) DEFAULT 제거
--       -------------------------------------------------------
        ALTER TABLE test3 MODIFY hitcount DEFAULT NULL;
        SELECT column_name, data_default FROM cols WHERE table_name='TEST3';
        
        INSERT INTO test3(id, name, subject, content) VALUES('5','b','b','b');
        COMMIT;
        SELECT * FROM test3;
        
--
--   ο CHECK 제약 조건 --CHECK 제약조건은 약자가 C이다. (CONSTRAINT_TYPE)
--    1) 테이블 생성과 동시에 CHECK 제약 조건 설정
--      (1) 컬럼 레벨 방식의 CHECK 제약 설정
--       -------------------------------------------------------
        CREATE TABLE 테이블명(
            컬럼명 타입[(크기)] [CONSTRAINT 제약조건명] CHECK(조건), ...
        );
--
--      (2) 테이블 레벨 방식의 CHECK 제약 설정
--       -------------------------------------------------------   
        CREATE TABLE 테이블명(
            컬럼명 타입[(크기)], ....
            [CONSTRAINT 제약이름] CHECK(조건)
        );
        --SEARCH_CONDITION컬럼에 체크 제약조건이 보임.
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
        INSERT INTO test4(id, name, gender, score) VALUES('2','b','M',120);--ORA-02290: 체크 제약조건(SKY.CH_TEST4_SCORE)에 위배되었습니다.
        --CHECK제약 위반 
        SELECT * FROM TEST4;
        TRUNCATE TABLE test4;

        
--
--    2) 존재하는 테이블에 CHECK 제약 조건 설정
--     -------------------------------------------------------
        --예제1) test4테이블에 다음과 같이 2개의 컬럼을 추가
        --sdate DATE NULL 허용
        --edate DATE NULL 허용
        --CHECK 제약조건 추가하기: sdate <= edate
        ALTER TABLE test4 ADD (
            sdate DATE,
            edate DATE,
            CONSTRAINT CH_TEST4_DATES CHECK (sdate<=edate) --열 추가 선언과 동시에 제약조건 설정
        );
        --혹은 2개로 분할
        ALTER TABLE test4 ADD(--열만 추가 
            sdate DATE,
            edate DATE
        );
        ALTER TABLE test4 ADD CONSTRAINT CH_TEST4_DATES CHECK(sdate<=edate); --제약조건 설정
        
        --제약조건 지우기
        ALTER TABLE test4 DROP CONSTRAINT CH_TEST4_DATES;
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
--        INSERT INTO test4(id,name,gender,score,sdate,edate) VALUES('1','ㅇ','m',100,SYSDATE-2,SYSDATE);
--        INSERT INTO test4(id,name,gender,score,sdate,edate) VALUES('1','ㅇ','m',100,SYSDATE,SYSDATE); --ORA-00001: 무결성 제약조건에 위배
--        SELECT * FROM TEST4;
        UPDATE test4 SET sdate='2000-10-10', edate='2000-09-09' WHERE id='1';--CHECK위반
        UPDATE test4 SET sdate='2000-10-10', edate='2000-10-11' WHERE id='1';--수정 가능
        COMMIT;
        SELECT * FROM test4;
        
        --sdate와 edate에 NOT NULL 제약조건을 추가하기
        ALTER TABLE test4 MODIFY sdate NOT NULL;
        ALTER TABLE test4 ADD CHECK (sdate IS NOT NULL);
        ALTER TABLE test4 MODIFY edate NOT NULL;
        ALTER TABLE test4 ADD CHECK (edate IS NOT NULL);
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
        
--
--
--    3) CHECK 제약 조건 삭제
--     -------------------------------------------------------
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
        --TEST4의 gender의 check제약조건 삭제하기 (SYS_C007661);
        ALTER TABLE test4 DROP CONSTRAINT SYS_C007661;
--
--   ο 참조 키(외래 키, FOREIGN KEY) 또는 REFERENCE KEY
--      테이블 간의 일관성을 보장하기 위한 제약조건을 설정하는 것.
--      가. 부모 테이블의 PRIMARY KEY나 UNIQUE만 외래키로 사용할 수 있음.
--      나. 부모 테이블의 컬럼과 자식 테이블의 컬럼의 서로 자료형이 일치해야 한다.
--      다. 부모 테이블에 없는 내용은 자식 테이블에 입력할 수 없다.
--  
--     1) 테이블 생성과 동시에 FOREIGN KEY 제약 조건 설정
--       (1) 컬럼 레벨 방식의 FOREIGN KEY 제약 설정
--           참조키는 선언이 길기 때문에 보통은 컬럼 레벨 방식으로는 사용하지 않는다.
--        -------------------------------------------------------        
        CREATE TABLE 테이블명(
            컬럼명 타입[(크기)] [CONSTRAINT 제약조건명] 
            REFERENCES 부모테이블명(부모테이블의컬럼명) [ON DELETE | CASCADE | SET NULL], ...
        );
        
        --test1: 부모 테이블
        CREATE TABLE test1(
            code VARCHAR2(30) PRIMARY KEY,
            subject VARCHAR2(50) NOT NULL
        );
        
        --exam1: 자식테이블 -> 부모의 PRIMARY, UNIQUE만 참조가 가능하다
        CREATE TABLE exam1(
            id VARCHAR2(30) PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            code VARCHAR2(30),
            CONSTRAINT fk_exam1_code 
            FOREIGN KEY(code) REFERENCES test1(code)
        );
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1'; --R(REFERENCE KEY)
        INSERT INTO exam1(id, name, code) VALUES('1','a','x100');
        --ORA-02291: 무결성 제약조건 (SKY.FK_EXAM1_CODE)이 위배되었습니다. 부모키가 없습니다.
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1'; --R(REFERENCE KEY)
        INSERT INTO exam1(id, name, code) VALUES('1','a',null);
        --참조키가 NULL을 허용하므로 부모가 없어도 추가할 수 있음
        COMMIT;
        SELECT * FROM exam1;
        
        --test1 부모에 행 삽입
        INSERT INTO test1(code, subject) VALUES('x100','a');
        INSERT INTO test1(code, subject) VALUES('x101','b');
        INSERT INTO test1(code, subject) VALUES('x102','c');
        
        INSERT INTO exam1(id, name, code) VALUES('2','2','x100');
        INSERT INTO exam1(id, name, code) VALUES('3','2','x102');
        INSERT INTO exam1(id, name, code) VALUES('4','2','x100');
        
        UPDATE exam1 SET code='x100' WHERE id='4';
        
        UPDATE test1 SET code='x200' WHERE code='x100';--ORA-02292: 무결성 제약조건 위반
        --이미 test1의 code컬럼을 참조하는 자식들이 있기 때문에 값을 임의로 수정할 수 없다.
        UPDATE test1 SET code='x201' WHERE code='x101';
        --참조하고 있는 자식 값이 없으니까 수정할 수 있음.
        SELECT * FROM test1; --x201로 수정되어 있음을 확인할 수 있다.
        SELECT * FROM test1;
        
        DELETE FROM test1 WHERE code='x100';--ORA-02292: 무결성 제약조건 위반
        --이미 test1의 code컬럼을 참조하는 자식들이 있기 때문에 마찬가지로 임의로 삭제할 수도 없다.
        DELETE FROM test1 WHERE code='x201';--정상적으로 삭제됨. (참조하는 자식 행이 없음)
        COMMIT;
        
        DROP TABLE test1 PURGE;--오류: ORA-02449: 외래 키에 의해 참조되는 고유/기본 키가 테이블에 있습니다.
        --이미 자식 테이블에서 참조하고 있으므로 삭제할 수 없다.
        DROP TABLE test1 CASCADE CONSTRAINTS PURGE; --부모자식관계가 끊어짐
        --강제 삭제: 자식 테이블의 참조키가 삭제된다.(위험)
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1';
        DROP TABLE exam1 PURGE;
        
--
--       (2) 테이블 레벨 방식의 FOREIGN KEY 제약 설정
--        -------------------------------------------------------
        --부모테이블: 참조하는 컬럼과 참조되는 컬럼명은 달라도 타입과는 크기가 같으면 가능하다.
        CREATE TABLE test2(
            num NUMBER PRIMARY KEY,
            subject VARCHAR2(50) NOT NULL
        );
        
        --자식테이블
        CREATE TABLE exam2(
            id VARCHAR2(30) PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            snum NUMBER NOT NULL,
            FOREIGN KEY(snum) REFERENCES test2(num)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2'; 
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM2'; --R 제약조건이 있음을 확인할 수 있다.
        
        --제약 조건 때문에 자식 테이블을 먼저 지우고 부모 테이블을 삭제한다.
        DROP TABLE exam2 PURGE;
        DROP TABLE test2 PURGE;
        
        -------------------------------
        -- 릴레이션 관계의 종류
        
        CREATE TABLE mem1(
            id VARCHAR2(50) PRIMARY KEY,
            name VARCHAR2(50) NOT NULL,
            pwd VARCHAR2(100) NOT NULL
        );
        
        --1:1 관계(식별 관계: 기본키이면서 참조키)
        
        CREATE TABLE mem2(
            id  VARCHAR2(50),
            birth DATE,
            tel VARCHAR2(50),
            CONSTRAINT pk_mem2_id PRIMARY KEY(id), --외래키이자 기본키로 지정했으므로 1:1설정이 된다.
            CONSTRAINT fk_mem2_id FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        --1:N 관계(비식별관계)
        CREATE TABLE guest(--방명록
            num NUMBER PRIMARY KEY,
            content VARCHAR2(4000) NOT NULL,
            id VARCHAR2(50) NOT NULL, --mem1 테이블에 등록된 id만 기입이 가능하도록 설정
            created DATE DEFAULT SYSDATE,
            CONSTRAINT fk_guest_id FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        
        CREATE TABLE guestLike(--좋아요 테이블
            --하나의 게시물에는 하나의 id만 좋아요를 누를 수 있다는 제약이 걸림.
            num NUMBER,
            id VARCHAR2(50),
            PRIMARY KEY(num, id), --기본키를 지정할 때 복수 개 지정 시 지정한 컬럼의 순서도 중요하다.
            FOREIGN KEY(num) REFERENCES guest(num),
            FOREIGN KEY(id) REFERENCES mem1(id)
        );
        
        -- 관계
            --  mem1: guestLike => 1:N (식별)
            --  guest: guestLike => 1:N (식별)
         select * from user_constraints where table_name='GUESTLIKE';
        
        SELECT * FROM TAB;
        DROP TABLE GUESTLIKE PURGE;
        DROP TABLE GUEST PURGE;
        DROP TABLE MEM2 PURGE;
        DROP TABLE MEM1 PURGE;
        
        --동일한 테이블을 두 번 이상 참조: 예)쪽지 등
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
            --동일한 테이블의 컬럼을 두 번 이상 참조하였음 (이렇게 하여도 상관없음)
        );
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='NOTE';
        DROP TABLE note PURGE;
        DROP TABLE mem1 PURGE;
        
        --자기 자신 테이블의 컬럼을 참조: 대분류/중분류 ...
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
            FOREIGN KEY(syear, hak) REFERENCES test1(syear, hak) ON DELETE CASCADE --단, 매우 위험한 옵션이다.
        );
        
        INSERT INTO test1(syear,hak,name) VALUES(2020,'1','a');
        INSERT INTO test1(syear,hak,name) VALUES(2020,'2','b');
        INSERT INTO test1(syear,hak,name) VALUES(2020,'3','c');
        
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);
        INSERT INTO exam1(num,syear,hak,score) VALUES(2,2020,'1',80);
        INSERT INTO exam1(num,syear,hak,score) VALUES(3,2020,'2',60);
        
        DELETE FROM test1 WHERE syear=2020 and hak='1'; --가능하다
        --테이블 설계 시 자식 테이블에서 ON DELETE 이벤트가 발생한 경우 CASCADE를 설정하였기 때문에
        --부모가 지워지면 자식도 지워지게 되었다.
        COMMIT;
        
        SELECT * FROM TEST1 T, EXAM1 E WHERE T.SYEAR=E.SYEAR AND T.HAK = E.HAK;
        
--     2) 존재하는 테이블에 FOREIGN KEY 제약 조건 설정
--       -------------------------------------------------------
        ALTER TABLE 테이블명 ADD 
            [CONSTRAINT 제약조건명]
            FOREIGN KEY(컬럼명[, 컬럼]) REFERENCES 부모테이블(부모컬럼명[, 컬럼])
            [ON DELETE CASCADE | SET NULL];
--
--
--     3) FOREIGN KEY 제약 조건 삭제
--      -------------------------------------------------------
        ALTER TABLE 테이블명 DROP CONSTRAINT 제약조건명;
--
--
--
--   ο 제약 조건 활성화 및 비활성화
--  일괄적으로 방대한 데이터를 입력할 경우 제약조건이 있으면 과부하가 걸린다.
--  따라서 이러한 경우 제약 조건을 비활성화하고 다시 활성화하는 방법을 수행한다.
--  단, 입력된 데이터가 제약조건에 부합하지 않은 경우에는 제약조건이 활성화되지 않음에 유의한다.
--  또한, 제약조건의 이름을 알아야만 활성화/비활성화가 가능하다
--
--     1) 존재하는 테이블의 제약 조건 비 활성화
--     -------------------------------------------------------

        --제약조건을 끄지 않았을 경우
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);
        --ORA-02291: 부모 없는 것은 추가가 불가능하다. (SYS_C007719 제약조건명)
        
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='EXAM1';
        
        --참조키 비활성화
        ALTER TABLE exam1 DISABLE CONSTRAINT SYS_C007719 CASCADE;
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);--참조키를 비활성화 하니까 데이터가 삽입되었다.
        ROLLBACK;
    
--
--     2) 테이블의 제약 조건 활성화
--     -------------------------------------------------------
        --참조키 활성화하기
        ALTER TABLE exam1 ENABLE VALIDATE CONSTRAINT SYS_C007719; --자식이라서 CASCADE조건을 달면 실행되지 않는다.
        INSERT INTO exam1(num,syear,hak,score) VALUES(1,2020,'1',90);--ORA-02291오류가 다시 발생
        
