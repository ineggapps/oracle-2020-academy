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
           
           DESC JOB_HISTORY;
           
           
-- �ڡڡڡڡ� ���⼭���ʹ� �ڵ带 �ϱ����� ���� �ٿ��ֱ��ϰ� ����Ѵ�.
desc employees;
    SELECT * FROM USER_CONSTRAINTS WHERE TABLE_NAME='JOB_HISTORY';

     -- �������� �� �÷� Ȯ��
        SELECT u1.table_name, column_name, constraint_type, u1.constraint_name 
        FROM user_constraints u1
        JOIN user_cons_columns u2
        ON u1.constraint_name = u2.constraint_name
        WHERE u1.table_name = UPPER('DEPARTMENTS'); --R:Reference key, P:Primary key, U:Unique key

     -- �ο� �� ������ ��� ���̺� ���
        SELECT fk.owner, fk.constraint_name,
                    pk.table_name parent_table, fk.table_name child_table
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name
                   AND fk.constraint_type = 'R'
        ORDER BY fk.table_name;

     -- �����̺���� �����ϴ� ��� ���̺� ��� ���(�ڽ� ���̺� ��� ���)
        SELECT fk.owner, fk.constraint_name , fk.table_name 
        FROM all_constraints fk, all_constraints pk 
        WHERE fk.r_constraint_name = pk.constraint_name 
                   AND fk.constraint_type = 'R'
                   AND pk.table_name = UPPER('EMPLOYEE')
        ORDER BY fk.table_name;
 
     -- �����̺���� �����ϰ� �ִ� ��� ���̺� ��� ���(�θ� ���̺� ��� ���)
        SELECT table_name FROM user_constraints
        WHERE constraint_name IN (
              SELECT r_constraint_name 
              FROM user_constraints
              WHERE table_name = UPPER('EMPLOYEES') AND constraint_type = 'R'
          );

     -- �����̺���� �θ� ���̺� ��� �� �θ� �÷� ��� ���
        --  �θ� 2�� �̻����� �⺻Ű�� ���� ��� ������ ��� ��
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