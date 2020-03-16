--데이터 사전
--DB자원을 효율적으로 관리하기 위해 다양한 정보를 저장하는 시스템 테이블 (값을 수정, 삭제할 수 없음)
--오라클은 데이터 사전을 지속적으로 갱신하여 데이터베이스 구조, 감사, 사용자 권한, 데이터 등의 변경사항을 반영한다. 

--Synonym 동의어
--데이터 사전에는 Synonym 가진 테이블/뷰가 있다. (ex: USER_TABLES의 Synonym은 TABS이다.)

SELECT * FROM USER_TABLES;
SELECT * FROM TABS;

--그러나 TAB은 결과가 조금 차이가 있다.
SELECT * FROM TAB;


SELECT * FROM USER_TABLESPACES;
SELECT * FROM USER_USERS;

■ 데이터 딕셔너리와 제약조건
 ※ 데이터 딕셔너리(Data Dictionary)
   ο 주요 데이터 사전
     -- 모든 데이터 사전 테이블 정보 확인
        SELECT * FROM DICTIONARY;
        SELECT COUNT(*) FROM DICTIONARY; --1055개

     -- 현재 사용자의 모든 객체 정보
        SELECT * FROM USER_OBJECTS; --TABLE과 INDEX가 같이 보인다.

     -- 테이블 정보 확인
        SELECT * FROM TAB;
        SELECT * FROM TABS;

     -- 테이블의 컬럼 정보 확인(테이블명은 대문자로)
        SELECT * FROM COLS; -- ==USER_TAB_COLUMNS
        SELECT * FROM USER_TAB_COLUMNS;
        SELECT * FROM COL;
        
        SELECT * FROM col WHERE tname='EMP';
        SELECT * FROM COLS WHERE table_name='EMP';
        DESC emp;

     -- 제약조건 확인
        -- 어떤 컬럼에 제약조건이 부여되었는지 확인은 불가(테이블명은 대문자로)
        -- constraint_type → P:기본키, C:NOT NULL 등, U:UNIQUE, R:참조키 등
    
        SELECT * FROM USER_CONSTRAINTS;

     -- 현재 사용자가 가지고 있는 컬럼에 부여된 제약조건 정보 확인
        -- 어떤 컬럼에 제약조건이 부여되었는지 확인 가능
        -- 제약 조건의 종류는 확인 불가능

        SELECT * FROM user_cons_columns; --제약조건의 구체적인 사항은 모르나 지정된 테이블의 컬럼명은 추출 가능
    
     -- ★★★★★ 여기서부터는 코드를 암기하지 말고 붙여넣기하고 사용한다.
     -- 제약조건 및 컬럼 확인
        SELECT u1.table_name, column_name, constraint_type, u1.constraint_name 
        FROM user_constraints u1
        JOIN user_cons_columns u2
        ON u1.constraint_name = u2.constraint_name
        WHERE u1.table_name = UPPER('테이블명'); --R:Reference key, P:Primary key, U:Unique key

     -- 부와 자 관계의 모든 테이블 출력
        SELECT fk.owner, fk.constraint_name,
                    pk.table_name parent_table, fk.table_name child_table
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_type = 'R'
        ORDER BY fk.table_name;

     -- 『테이블명』을 참조하는 모든 테이블 목록 출력(자식 테이블 목록 출력)
        SELECT fk.owner, fk.constraint_name , fk.table_name 
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name 
                   AND fk.constraint_type = 'R'
                   AND pk.table_name = UPPER('테이블명')
        ORDER BY fk.table_name;
 
     -- 『테이블명』이 참조하고 있는 모든 테이블 목록 출력(부모 테이블 목록 출력)
        SELECT table_name FROM user_constraints
        WHERE constraint_name IN (
              SELECT r_constraint_name 
              FROM user_constraints
              WHERE table_name = UPPER('테이블명') AND constraint_type = 'R'
          );

     -- 『테이블명』의 부모 테이블 목록 및 부모 컬럼 목록 출력
        --  부모 2개 이상으로 기본키를 만든 경우 여러번 출력 됨
        SELECT fk.constraint_name, fk.table_name child_table, fc.column_name child_column,
                    pk.table_name parent_table, pc.column_name parent_column
        FROM all_constraints fk, all_constraints pk, all_cons_columns fc, all_cons_columns pc
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_name = fc.constraint_name
                   AND pk.constraint_name = pc.constraint_name
                   AND fk.constraint_type = 'R'
                   AND pk.constraint_type = 'P'
                   AND fk.table_name = UPPER('테이블명');