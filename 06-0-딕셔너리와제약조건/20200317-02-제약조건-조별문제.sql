�� ������ ��ųʸ��� ��������
   �� ���� ���� - ���� ����
     1) hr �����(��Ű��)�� ���� 7���� ���̺��� ������ �м��Ѵ�.
         - ���̺��, �÷���, �ڷ���, �⺻Ű, ����Ű���� �������� ��
         - 7���� ���̺�
           COUNTRIES
           DEPARTMENTS
           EMPLOYEES
           JOBS
           JOB_HISTORY
           LOCATIONS
           REGIONS


     2) hrEx ��� �̸����� ����ڸ� �߰��ϰ� hrEx ����ڿ� hr ������� ���̺�� ������ ����(�ڷ���, �������� ��)�� 7���� ���̺��� �ۼ��Ѵ�.
        - ���̺� �ϳ��� �ּ� 2�� �̻��� ������(���ڵ�)�� �߰��Ѵ�.
        

     3) �۾�����
         (1) hr ������ ���̺� �� ���������� Ȯ�� �Ѵ�.


         (2) SYS �Ǵ� SYSTEM �������� hrEx��� �̸����� ������ �߰��Ѵ�.
              -- SQLPLUS ���� �� sqlplus sys/"��й�ȣ" as sysdba Ȥ�� sys
              -- 12C/18C �̻��� �������� 11g�� ���� ������� ����� �߰��� ���� ���� ����
                ALTER SESSION SET "_ORACLE_SCRIPT" = true;

              -- hrEx ����� �߰�, �н������ java1234�� �����Ѵ�.
                CREATE USER hrEx IDENTIFIED BY "java1234";

              -- hrEx ����ڿ��� CONNECT �� RESOURCE ������ �ο�
                GRANT CONNECT, RESOURCE TO hrEx;

             -- hrEx ������� DEFAULT ���̺����̽��� USERS�� ����
                ALTER USER hrEx DEFAULT TABLESPACE USERS;

             -- hrEx ������� TEMPORARY ���̺����̽��� TEMP�� ����
                ALTER USER hrEx TEMPORARY TABLESPACE TEMP; 

             -- hrEx ������� USERS ���̺����̽��� �뷮�� UNLIMITED�� ����
                ALTER USER hrEx DEFAULT TABLESPACE USERS QUOTA UNLIMITED ON USERS;

         (3) hrEx �������� CONNECT �� ���̺��� �ۼ��Ѵ�.
             -- sqldeveloper ���� �߰� �� ���̺� �ۼ�
            conn hrEx/"java1234"
            show user;
            
            