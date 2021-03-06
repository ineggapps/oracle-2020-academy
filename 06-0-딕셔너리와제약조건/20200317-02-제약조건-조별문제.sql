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


     2) hrEx 라는 이름으로 사용자를 추가하고 hrEx 사용자에 hr 사용자의 테이블과 동일한 구조(자료형, 제약조건 등)로 7개의 테이블을 작성한다.
        - 테이블 하나당 최소 2개 이상의 데이터(레코드)를 추가한다.
        

     3) 작업순서
         (1) hr 계정의 테이블 및 제약조건을 확인 한다.


         (2) SYS 또는 SYSTEM 계정에서 hrEx라는 이름으로 계정을 추가한다.
              -- SQLPLUS 접속 시 sqlplus sys/"비밀번호" as sysdba 혹은 sys
              -- 12C/18C 이상의 버전에서 11g와 같은 방식으로 사용자 추가를 위한 설정 변경
                ALTER SESSION SET "_ORACLE_SCRIPT" = true;

              -- hrEx 사용자 추가, 패스워드는 java1234로 설정한다.
                CREATE USER hrEx IDENTIFIED BY "java1234";

              -- hrEx 사용자에게 CONNECT 및 RESOURCE 권한을 부여
                GRANT CONNECT, RESOURCE TO hrEx;

             -- hrEx 사용자의 DEFAULT 테이블스페이스를 USERS로 변경
                ALTER USER hrEx DEFAULT TABLESPACE USERS;

             -- hrEx 사용자의 TEMPORARY 테이블스페이스를 TEMP로 변경
                ALTER USER hrEx TEMPORARY TABLESPACE TEMP; 

             -- hrEx 사용자의 USERS 테이블스페이스의 용량을 UNLIMITED로 변경
                ALTER USER hrEx DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

         (3) hrEx 계정으로 CONNECT 후 테이블을 작성한다.
             -- sqldeveloper 계정 추가 후 테이블 작성
            conn hrEx/"java1234"
            show user;
            
            