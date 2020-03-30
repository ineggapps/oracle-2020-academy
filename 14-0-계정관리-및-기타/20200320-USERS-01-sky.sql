�� ����Ŭ ��������
 �� ��������
    �� ����
    ����Ŭ 12c �̻󿡼��� ����ڸ��� c##����ڸ� �����̴�.
    ����ڸ��� �ܼ��� c##�� ���̴� ���� �ƴ϶� ����ڸ� ��ü�� c##����ڸ��� �ȴ�.
    �̿� ���� ����� ���ϱ� ���� ����Ŭ 11g������� ����ϱ� ���ؼ���
    ALTER SESSION SET "_ORACLE_SCRIPT" = true; �� ������ �� ����ڸ� �߰�/�����Ѵ�.
    
    SELECT * FROM ALL_USERS;
    SELECT * FROM DBA_USERS;
    SELECT * FROM USER_USERS;
    
    �� ���� ���� �� ����
         ---------------------------------------------------------
         -- ��� ��
         -- ���� ���� ����
           CREATE USER ����ڸ�
               IDENTIFIED BY �н����� -- �н������ ���� ���� �Ұ���. Ư������ �Է� �� �ֵ���ǥ "" ��� �ʼ�
               [ DEFAULT TABLESPACE tablespace_name ] -- �����͸� �����ϴ� ����
               [ TEMPORARY TABLESPACE temp_tablespace_name ] -- �����ϰų� groupby�� �� ����ϴ� ��
               [ QUOTA  { size_clause | UNLIMITED } ON tablespace_name ] --12c���ĺ��� ������ �����ؾ� ��. 
               ;
    
         -- ���� ���� ����
           ALTER USER ����ڸ�
               IDENTIFIED BY �н����� --�н����常 ����� �ڽ��� �ٲ� �� ����. (�����ڵ� �翬�� ����)
               | DEFAULT TABLESPACE tablespace_name
               | TEMPORARY TABLESPACE temp_tablespace_name
               | QUOTA  { size_clause | UNLIMITED } ON tablespace_name
               | ACCOUNT { LOCK | UNLOCK };

         -- ���� ���� ����
           DROP USER ����ڸ� [CASCADE]; --��ü(���̺�, ������, �� ��)�� �ϳ��� ������ ������ �� ����
           --���� ��ü�� �ϳ��� �����ϴ� ��� CASCADE�ɼ��� ���̸� ������ ����ȴ�.


         ---------------------------------------------------------
         -- ���� ��ȸ  - ������ ���� : sys �Ǵ� system
           SELECT * FROM all_users;
           SELECT username, default_tablespace, temporary_tablespace FROM dba_users;
           SELECT object_name, object_type FROM dba_object  WHERE OWNER=������ڸ�; 


         ---------------------------------------------------------
         -- ���� ���� �� ������ : SYS �Ǵ� SYSTEM�� �����ϴ�.
         -- 11g ������� ������ ���� �� ������ �� ���̴�.
         ALTER SESSION SET "_ORACLE_SCRIPT" = true;
         
         --sky0 ���� �߰�: sys �Ǵ� system
         CREATE USER sky0 IDENTIFIED BY 12345;
         --ORA-01045: ����� SKY0�� CREATE SESSION ������ ���������� ����; �α׿��� �����Ǿ����ϴ�.
         --������ �߰��ߴٰ� �ϴ��� �ٷ� �α����� ������ ���� �ƴ϶�� �Ϳ� ��������.
         --������ �����ؾ� �Ѵ�.
         
         GRANT CREATE SESSION TO sky0; --����ڿ��� ������ �� �ִ� ������ �ο��Ѵ�.
        -- CREATE SESSION ���Ѹ� �ο��޾����Ƿ� ���̺��� ���� ���� ����.
        
        -- ���� �����ϱ�: sys �Ǵ� system�� �����ϴ�
        DROP USER sky0; --CASCADE�ɼ��� ������ �� ����
        
        -- ���� �ٽ� �߰��ϱ�
        CREATE USER sky0 IDENTIFIED BY 12345;
        --���� �����ϱ�
        GRANT CONNECT, RESOURCE TO sky0;
        --  ���� CONNECT: DB�� ������ �� �ִ� ������ ���� (role)        
        --  RESOURCE: ���̺� ����, ���ν��� ���� ���� ���� ����
        -- 11g������ RESOURCE �ѿ� QUOTA�� UNLIMITED �� ����(������ ����)������ 12c���ʹ� ��������.
        -- ���� 12c���ʹ� ���̺����̽� �뷮�� ���� ������ ���̺� ������ �Ұ����ϴ�.
        --���� �����ϱ� (���̺����̽�, �ӽ�������� �� �뷮 ����)
        ALTER USER sky0 DEFAULT TABLESPACE USERS;
        ALTER USER sky0 TEMPORARY TABLESPACE TEMP;
        ALTER USER sky0 QUOTA UNLIMITED ON USERS;
        --���� �̷��� �ɼ��� ����ڸ� ������ �� �Ѳ����� ������ �� ����.
        
        --�α��� �� ��й�ȣ�� 11ȸ Ʋ���� ������ ����. (10���� ��ȸ)
        --�ùٸ� ��й�ȣ�� �α����� �õ��Ͽ��� ������ ���� �α����� �� ����.
        --ORA-28000: ������ �����ϴ�. 
        
        --���� LOCK Ȯ��
        SELECT * FROM DBA_USERS; --ACCOUNT_STATUS�� LOCKED(TIMED) ���·� �ٲ� ���� Ȯ���� �� ����.
        
        --������ �������� ���� ��ױ�/�����ϱ�
        ALTER USER sky0 ACCOUNT LOCK; -- ���� ��� ����
        ALTER USER sky0 ACCOUNT UNLOCK; --���� ��� ����        
    
        DROP USER sky0;
        --���� ����
        
        CREATE USER sky0 IDENTIFIED BY 12345
            DEFAULT TABLESPACE USERS
            TEMPORARY TABLESPACE TEMP
            QUOTA UNLIMITED ON USERS;
        GRANT CONNECT, RESOURCE TO sky0;
        
        --���� ȸ��
        REVOKE CONNECT, RESOURCE FROM sky0;
        -- sky0 conn �Ұ�
                
 �� ����(Privilege)�� ��(ROLE)
    �� �ý��� ����(System Privilege)
         ---------------------------------------------------------
         -- ��� ��
         -- �ý��� ���� �ο� ����
            GRANT �ý���_����
                TO { ����ڸ� | PUBLIC }
                [WITH ADMIN OPTION];

         -- �ý��� ���� ȸ�� ����
             REVOKE �ý���_���� FROM { ����ڸ� | PUBLIC  };

         -- ��ü �ý��� ���� ��� Ȯ�� - ������ ���� : sys �Ǵ� system
            SELECT * FROM system_privilege_map;

         -- ��� ������ �ο��� ��� �ý��� ���� ��ȸ  - ������ ���� : sys �Ǵ� system
           SELECT * FROM dba_sys_privs WHERE grantee='SKY';

         -- ������� �ý��� ����(privilege) Ȯ��(�Ϲ� ���� ��忡��)
           SELECT * FROM user_sys_privs; 

         -- ������ SESSION ���� �Ҵ�� ���� ��ȸ
           SELECT * FROM session_privs;


         ---------------------------------------------------------
         -- 



    �� ������Ʈ ����(Object Privilege)
         ---------------------------------------------------------
         -- ��� ��
         -- ������ �ִ� ��ü ���� Ȯ��(��ü ������ ������, ��ü ���� �ο���, ��ü ���� �Ǻο���)
           SELECT * FROM user_tab_privs;

         -- �ٸ� ����ڷ� ���� ���� ��ü ���� Ȯ��
           SELECT * FROM user_tab_privs_recd;

         -- ����ڰ� �ο��� ��� ��ü ����
            SELECT * FROM user_tab_privs_made;


         ---------------------------------------------------------
         --SKY ���� �ο� �׽�Ʈ�ϱ� (�ٸ� ������ ���̺� ���� ����)
         
         SELECT * FROM hr.jobs; --ORA-00942: ���̺� �Ǵ� �䰡 �������� �ʽ��ϴ�
         --�ֳ��ϸ� ������ ���� ���� �����̴�.
         
         --HR�������� SKY���� ����, ��ȸ ���� �ֱ�
         GRANT INSERT, SELECT ON jobs TO sky;
         
         --HR�������� SKY���� �����ߴ� ������ ȸ���ϱ�
         REVOKE INSERT, SELECT ON jobs FROM sky;
            
    �� ��(ROLE)
         ---------------------------------------------------------
         -- ��� ��
         -- ROLE Ȯ��  - ������ ���� : sys �Ǵ� system
            SELECT * FROM dba_roles;

         -- ������ �ο��� ��(����) Ȯ��
            SELECT * FROM user_role_privs;

         -- �Ѿ��� �� Ȯ��
             SELECT * FROM role_role_privs WHERE role='��_�̸�';
             SELECT * FROM role_role_privs WHERE role='RESOURCE';

         -- ���� �ý��� ���� Ȯ��
            SELECT * FROM role_sys_privs WHERE role='��_�̸�';
            SELECT * FROM role_sys_privs WHERE role='RESOURCE';
            --11g�� ��쿡�� QUOTA�� �����ϴ� ���ѱ��� �����Ǿ� �ִٴ� ���� �����Ѵ�.