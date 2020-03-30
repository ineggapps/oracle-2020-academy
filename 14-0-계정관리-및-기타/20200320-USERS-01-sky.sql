■ 오라클 계정관리
 ※ 계정관리
    ◎ 개요
    오라클 12c 이상에서는 사용자명이 c##사용자명 형식이다.
    사용자명은 단순히 c##을 붙이는 것이 아니라 사용자명 자체가 c##사용자명이 된다.
    이와 같은 방식을 피하기 위해 오라클 11g방식으로 사용하기 위해서는
    ALTER SESSION SET "_ORACLE_SCRIPT" = true; 로 변경한 후 사용자를 추가/삭제한다.
    
    SELECT * FROM ALL_USERS;
    SELECT * FROM DBA_USERS;
    SELECT * FROM USER_USERS;
    
    ◎ 계정 생성 및 관리
         ---------------------------------------------------------
         -- 사용 예
         -- 계정 생성 형식
           CREATE USER 사용자명
               IDENTIFIED BY 패스워드 -- 패스워드는 절대 생략 불가능. 특수문자 입력 시 쌍따옴표 "" 사용 필수
               [ DEFAULT TABLESPACE tablespace_name ] -- 데이터를 저장하는 공간
               [ TEMPORARY TABLESPACE temp_tablespace_name ] -- 정렬하거나 groupby할 때 사용하는 곳
               [ QUOTA  { size_clause | UNLIMITED } ON tablespace_name ] --12c이후부터 무조건 지정해야 함. 
               ;
    
         -- 계정 수정 형식
           ALTER USER 사용자명
               IDENTIFIED BY 패스워드 --패스워드만 사용자 자신이 바꿀 수 있음. (관리자도 당연히 가능)
               | DEFAULT TABLESPACE tablespace_name
               | TEMPORARY TABLESPACE temp_tablespace_name
               | QUOTA  { size_clause | UNLIMITED } ON tablespace_name
               | ACCOUNT { LOCK | UNLOCK };

         -- 계정 삭제 형식
           DROP USER 사용자명 [CASCADE]; --객체(테이블, 시퀀스, 뷰 등)가 하나라도 있으면 삭제할 수 없음
           --따라서 객체가 하나라도 존재하는 경우 CASCADE옵션을 붙이면 삭제가 진행된다.


         ---------------------------------------------------------
         -- 계정 조회  - 관리자 계정 : sys 또는 system
           SELECT * FROM all_users;
           SELECT username, default_tablespace, temporary_tablespace FROM dba_users;
           SELECT object_name, object_type FROM dba_object  WHERE OWNER=’사용자명’; 


         ---------------------------------------------------------
         -- 계정 생성 및 변경은 : SYS 또는 SYSTEM만 가능하다.
         -- 11g 방식으로 계정을 생성 및 삭제를 할 것이다.
         ALTER SESSION SET "_ORACLE_SCRIPT" = true;
         
         --sky0 계정 추가: sys 또는 system
         CREATE USER sky0 IDENTIFIED BY 12345;
         --ORA-01045: 사용자 SKY0는 CREATE SESSION 권한을 가지고있지 않음; 로그온이 거절되었습니다.
         --계정을 추가했다고 하더라도 바로 로그인이 가능한 것은 아니라는 것에 유념하자.
         --권한을 지정해야 한다.
         
         GRANT CREATE SESSION TO sky0; --사용자에게 접속할 수 있는 권한을 부여한다.
        -- CREATE SESSION 권한만 부여받았으므로 테이블을 만들 수는 없다.
        
        -- 계정 삭제하기: sys 또는 system만 가능하다
        DROP USER sky0; --CASCADE옵션을 지정할 수 있음
        
        -- 계정 다시 추가하기
        CREATE USER sky0 IDENTIFIED BY 12345;
        --권한 지정하기
        GRANT CONNECT, RESOURCE TO sky0;
        --  참고 CONNECT: DB에 접속할 수 있는 권한의 묶음 (role)        
        --  RESOURCE: 테이블 생성, 프로시저 생성 등의 권한 지정
        -- 11g에서는 RESOURCE 롤에 QUOTA가 UNLIMITED 로 지정(숨겨져 있음)되지만 12c부터는 없어졌음.
        -- 따라서 12c부터는 테이블스페이스 용량을 주지 않으면 테이블 생성이 불가능하다.
        --계정 수정하기 (테이블스페이스, 임시저장공간 및 용량 설정)
        ALTER USER sky0 DEFAULT TABLESPACE USERS;
        ALTER USER sky0 TEMPORARY TABLESPACE TEMP;
        ALTER USER sky0 QUOTA UNLIMITED ON USERS;
        --물론 이러한 옵션은 사용자를 생성할 때 한꺼번에 지정할 수 있음.
        
        --로그인 시 비밀번호를 11회 틀리면 계정이 잠긴다. (10번의 기회)
        --올바른 비밀번호로 로그인을 시도하여도 계정이 잠기면 로그인할 수 없다.
        --ORA-28000: 계정이 잠겼습니다. 
        
        --계정 LOCK 확인
        SELECT * FROM DBA_USERS; --ACCOUNT_STATUS에 LOCKED(TIMED) 상태로 바뀐 것을 확인할 수 있음.
        
        --관리자 계정에서 계정 잠그기/해제하기
        ALTER USER sky0 ACCOUNT LOCK; -- 계정 잠금 설정
        ALTER USER sky0 ACCOUNT UNLOCK; --계정 잠금 해제        
    
        DROP USER sky0;
        --계정 생성
        
        CREATE USER sky0 IDENTIFIED BY 12345
            DEFAULT TABLESPACE USERS
            TEMPORARY TABLESPACE TEMP
            QUOTA UNLIMITED ON USERS;
        GRANT CONNECT, RESOURCE TO sky0;
        
        --권한 회수
        REVOKE CONNECT, RESOURCE FROM sky0;
        -- sky0 conn 불가
                
 ※ 권한(Privilege)과 롤(ROLE)
    ◎ 시스템 권한(System Privilege)
         ---------------------------------------------------------
         -- 사용 예
         -- 시스템 권한 부여 형식
            GRANT 시스템_권한
                TO { 사용자명 | PUBLIC }
                [WITH ADMIN OPTION];

         -- 시스템 권한 회수 형식
             REVOKE 시스템_권한 FROM { 사용자명 | PUBLIC  };

         -- 전체 시스템 권한 목록 확인 - 관리자 계정 : sys 또는 system
            SELECT * FROM system_privilege_map;

         -- 모든 유저에 부여된 모든 시스템 권한 조회  - 관리자 계정 : sys 또는 system
           SELECT * FROM dba_sys_privs WHERE grantee='SKY';

         -- 사용자의 시스템 권한(privilege) 확인(일반 유저 모드에서)
           SELECT * FROM user_sys_privs; 

         -- 접속한 SESSION 에게 할당된 권한 조회
           SELECT * FROM session_privs;


         ---------------------------------------------------------
         -- 



    ◎ 오브젝트 권한(Object Privilege)
         ---------------------------------------------------------
         -- 사용 예
         -- 가지고 있는 객체 권한 확인(객체 권한의 소유자, 객체 권한 부여자, 객체 권한 피부여자)
           SELECT * FROM user_tab_privs;

         -- 다른 사용자로 부터 받은 객체 권한 확인
           SELECT * FROM user_tab_privs_recd;

         -- 사용자가 부여한 모든 객체 권한
            SELECT * FROM user_tab_privs_made;


         ---------------------------------------------------------
         --SKY 권한 부여 테스트하기 (다른 계정의 테이블 접근 권한)
         
         SELECT * FROM hr.jobs; --ORA-00942: 테이블 또는 뷰가 존재하지 않습니다
         --왜냐하면 권한이 아직 없기 때문이다.
         
         --HR계정에서 SKY에게 삽입, 조회 권한 주기
         GRANT INSERT, SELECT ON jobs TO sky;
         
         --HR계정에서 SKY에게 지정했던 권한을 회수하기
         REVOKE INSERT, SELECT ON jobs FROM sky;
            
    ◎ 롤(ROLE)
         ---------------------------------------------------------
         -- 사용 예
         -- ROLE 확인  - 관리자 계정 : sys 또는 system
            SELECT * FROM dba_roles;

         -- 유저에 부여된 롤(역할) 확인
            SELECT * FROM user_role_privs;

         -- 롤안의 롤 확인
             SELECT * FROM role_role_privs WHERE role='롤_이름';
             SELECT * FROM role_role_privs WHERE role='RESOURCE';

         -- 롤의 시스템 권한 확인
            SELECT * FROM role_sys_privs WHERE role='롤_이름';
            SELECT * FROM role_sys_privs WHERE role='RESOURCE';
            --11g의 경우에는 QUOTA를 지정하는 권한까지 지정되어 있다는 것을 참조한다.