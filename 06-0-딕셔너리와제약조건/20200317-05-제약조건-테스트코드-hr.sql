■ 데이터 딕셔너리와 제약조건
   ο 제약 조건 - 종합 문제
     1) hr 사용자(스키마)의 다음 7개의 테이블의 구조를 분석한다.
         - 테이블명, 컬럼명, 자료형, 기본키, 참조키등의 제약조건 등
         - 7개의 테이블
           COUNTRIES
           DEPARTMENTS
           EMPLOYEES
           JOBS
           JOB_HISTORY
           LOCATIONS
           REGIONS
           
           DESC JOB_HISTORY;
           
           
-- ★★★★★ 여기서부터는 코드를 암기하지 말고 붙여넣기하고 사용한다.
desc employees;
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='JOB_HISTORY';

     -- 제약조건 및 컬럼 확인
        SELECT u1.table_name, column_name, constraint_type, u1.constraint_name 
        FROM user_constraints u1
        JOIN user_cons_columns u2
        ON u1.constraint_name = u2.constraint_name
        WHERE u1.table_name = UPPER('DEPARTMENTS'); --R:Reference key, P:Primary key, U:Unique key

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
                   AND pk.table_name = UPPER('EMPLOYEE')
        ORDER BY fk.table_name;
 
     -- 『테이블명』이 참조하고 있는 모든 테이블 목록 출력(부모 테이블 목록 출력)
        SELECT table_name FROM user_constraints
        WHERE constraint_name IN (
              SELECT r_constraint_name 
              FROM user_constraints
              WHERE table_name = UPPER('EMPLOYEES') AND constraint_type = 'R'
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
                   AND fk.table_name = UPPER('JOB_HISTORY');
        
        
        
        
    SELECT * FROM JOBS;
    SELECT * FROM JOB_HISTORY;
    
    DESC REGIONS;
    
    DESC DEPARTMENTS;
    SELECT * FROM DEPARTMENTS;
    SELECT * FROM JOB_HISTORY;
    SELECT * FROM EMPLOYEES;
    DESC EMPLOYEES;
    
    SELECT * FROM JOB_HISTORY WHERE DEPARTMENT_ID IN (90, 240, 250);
    
    SELECT * FROM EMPLOYEES;
    
    SELECT * FROM DEPARTMENTS;
    
    INSERT INTO EMPLOYEES(EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID)
    VALUES(200,'Jennifer', 'Whalen', 'JWHALEN', '515.123.4444', '87/09/17', 'AD_ASST',4400,101,10);
    
    
    SELECT * FROM JOBS;
    
    SELECT * FROM JOB_HISTORY;