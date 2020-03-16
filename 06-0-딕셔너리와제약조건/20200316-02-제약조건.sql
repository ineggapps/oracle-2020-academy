--■ 데이터 딕셔너리와 (무결성) 제약조건
-- ※ 제약 조건(constraint) 
--  데이터베이스의 일관성을 보장하고자 일관된 데이터베이스의 상태를 정의하는 규칙들을 묵시적 또는 명시적으로 정의
-- ex: 점수는 0점부터 100점까지만의 범위만 유효하다.
-- 단, 데이터를 일괄적으로 입력하거나 이관시키는 경우 제약조건이 걸려 있으면 제약조건을 하나씩 검사를 다 하므로 부하가 걸린다.
-- 이처럼 데이터를 이관할 때는 제약조건을 껐다가 데이터를 이관시키고 다시 제약조건을 켠다.
-- 그러나 제약조건에 맞지 않는 데이터가 입력된 경우에는 제약조건이 켜지지 않는다.
--    ο 기본 키(PRIMARY KEY)
--    1) 테이블 생성과 동시에 기본 키 설정
--      제약조건 이름은 오라클이 지정한다.
--      (1) 컬럼 레벨 방식의 PRIMARY KEY 설정(inline constraint)
--        -------------------------------------------------------
        CREATE TABLE test1(
               id VARCHAR2(50) PRIMARY KEY,
               pwd VARCHAR2(100) NOT NULL,
               name VARCHAR2(30) NOT NULL
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST1';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST1';
        --제약조건에 이름 부여
        CREATE TABLE test2(-- 제약유형_테이블명_컬럼명
            id VARCHAR2(50) CONSTRAINT pk_test2_id PRIMARY KEY, --키의 약자 Primary Key의 약자 PK을 준다.
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST2';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST2';        
--
--
--      (2) 테이블 레벨 방식의 PRIMARY KEY 설정(out of line constraint)
--        -------------------------------------------------------
--      제약조건의 이름을 부여하지 않음
        CREATE TABLE test3(-- 제약유형_테이블명_컬럼명
            id VARCHAR2(50), --키의 약자 Primary Key의 약자 PK을 준다.
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL,
            PRIMARY KEY(id)
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST3';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST3';        
--      제약조건에 이름을 부여함
--      두 개의 컬럼으로 기본키 지정(테이블 레벨로만 가능하다)
        CREATE TABLE test4(
            id VARCHAR2(50),
            code VARCHAR2(100) NOT NULL,
            name VARCHAR2(100) NOT NULL,
            CONSTRAINT pk_test4_id PRIMARY KEY(id, code)
            --테이블 내에서 기본키는 단 1개만 존재한다.
            --단, 기본키를 지정할 때 두 개 이상의 컬럼으로도 지정할 수 있다.
            --그런데 테이블 레벨에서만 두 개 이상의 컬럼을 동시에 지정할 수 있다.
        );
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST4';
        SELECT * FROM USER_CONS_COLUMNS WHERE table_name='TEST4';
        
        --INSERT로 자료 입력 테스트
        INSERT INTO test4(id,code,name) VALUES('1','1','a');
        INSERT INTO test4(id,code,name) VALUES('1','2','a');
        INSERT INTO test4(id,code,name) VALUES('1','2','a');--오류 ORA-00001: 무결성 제약 조건(SKY.PK_TEST4_ID)에 위배됩니다.
        INSERT INTO test4(id,code,name) VALUES('','5','a');--오류 ORA-01400: NULL을 SKY.TEST4.ID 안에 삽입할 수 없습니다.
        --기본키로 지정된 컬럼은 두 개의 컬럼으로 지정되었을지라도 NULL값을 입력할 수 없다.
        UPDATE test4 SET CODE = '3' WHERE id='1' and code='2';--업데이트 성공:중복된 값이 없고 NULL값이 아니므로 변경이 가능하다.
        --다만, 기본키 제약 위반한 경우(NULL 지정, 중복 값)에는 수정이 불가능하다.
        UPDATE test4 SET CODE = '1' WHERE id='1' and code='3';--ORA-00001 무결성 제약조건 위반(중복된 값이 있음)
                
        SELECT * FROM test4;
        COMMIT;
        
--
--    2) 존재하는 테이블에 기본 키 설정
--       -------------------------------------------------------
        CREATE TABLE test5(
            id VARCHAR2(50),
            pwd VARCHAR2(100) NOT NULL,
            name VARCHAR2(30)  NOT NULL
        );
        
        INSERT INTO test5(id, pwd, name) VALUES('1', '1', 'a');
        INSERT INTO test5(id, pwd, name) VALUES('1', '2', 'b');
        SELECT * FROM test5;
        
        ALTER TABLE test5 ADD CONSTRAINT pk_test5_id PRIMARY KEY (id);
        --ORA-02437: SKY.PK_TEST5_ID을 검증할 수 없습니다. - 잘못된 기본 키입니다.
        --왜냐하면 id컬럼에 데이터가 1인 값이 겹치기 때문이다.
        
        UPDATE test5 SET id='2' WHERE id='1' and pwd='2';
        --중복된 값이 없으면 PRIMARY KEY로도 무난하게 지정이 가능하다.
        SELECT * FROM test5;
        COMMIT;
        ALTER TABLE test5 ADD CONSTRAINT pk_test5_id PRIMARY KEY (id);
        
        --기본키가 정상적으로 추가되었는지 확인할 수 있다 (PK_TEST5_ID)
        SELECT * FROM USER_CONSTRAINTS WHERE table_name='TEST5';

--    3) 기본키 제약 조건 삭제
--       -------------------------------------------------------
        
--
--
--   ο UNIQUE 제약 조건
--    1) 테이블 생성과 동시에 UNIQUE 제약 조건 설정
--      (1) 컬럼 레벨 방식의 UNIQUE 제약 설정
--        -------------------------------------------------------
--        --
--
--
--      (2) 테이블 레벨 방식의 UNIQUE 제약 조건 설정
--        -------------------------------------------------------
--        --
--
--
--    2) 존재하는 테이블에 UNIQUE 제약 조건 설정
--     -------------------------------------------------------
--     --
--
--
--    3) UNIQUE 제약 조건 삭제
--      -------------------------------------------------------
--     --
--
--
--
--   ο NOT NULL 제약 조건
--     1) 테이블 생성시 NOT NULL 제약 조건 설정
--       -------------------------------------------------------
--       --
--
--
--     2) 존재하는 테이블에 NOT NULL 제약 조건 설정
--       -------------------------------------------------------
--       --
--
--
--     3) NOT NULL 제약 조건 삭제
--       -------------------------------------------------------
--       --
--
--
--   ο DEFAULT
--     1) 테이블 생성시 DEFAULT 설정
--     -------------------------------------------------------
--     --
--
--
--     2) DEFAULT 확인
--         SELECT column_name, data_type, data_precision, data_length, nullable, data_default 
--         FROM user_tab_columns WHERE table_name='테이블명';
--
--     3) DEFAULT 제거
--       -------------------------------------------------------
--       --
--
--
--
--   ο CHECK 제약 조건
--    1) 테이블 생성과 동시에 CHECK 제약 조건 설정
--      (1) 컬럼 레벨 방식의 CHECK 제약 설정
--       -------------------------------------------------------
--       --
--
--
--      (2) 테이블 레벨 방식의 CHECK 제약 설정
--       -------------------------------------------------------
--       --
--
--
--    2) 존재하는 테이블에 CHECK 제약 조건 설정
--     -------------------------------------------------------
--     --
--
--
--    3) CHECK 제약 조건 삭제
--     -------------------------------------------------------
--     --
--
--
--
--   ο 참조 키(외래 키, FOREIGN KEY)
--     1) 테이블 생성과 동시에 FOREIGN KEY 제약 조건 설정
--       (1) 컬럼 레벨 방식의 FOREIGN KEY 제약 설정
--        -------------------------------------------------------
--        --
--
--
--       (2) 테이블 레벨 방식의 FOREIGN KEY 제약 설정
--        -------------------------------------------------------
--        --
--
--
--     2) 존재하는 테이블에 FOREIGN KEY 제약 조건 설정
--       -------------------------------------------------------
--       --
--
--
--     3) FOREIGN KEY 제약 조건 삭제
--      -------------------------------------------------------
--       --
--
--
--
--   ο 제약 조건 활성화 및 비활성화
--     1) 존재하는 테이블의 제약 조건 비 활성화
--     -------------------------------------------------------
--     --
--
--
--     2) 테이블의 제약 조건 활성화
--     -------------------------------------------------------
--     --
--
