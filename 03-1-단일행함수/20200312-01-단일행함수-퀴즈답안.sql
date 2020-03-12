-- SKY �������� �ڽ��� ��� ���̺� ��� ���

SELECT * FROM TAB;
SELECT * FROM TABS;


-- emp ���̺��� ���� ���

DESC emp;
SELECT * FROM col WHERE tname='EMP';
SELECT * FROM cols WHERE table_name='EMP';


-- emp ���̺��� ��� �ڷ� ���
SELECT * FROM emp;


-- emp ���̺��� city�� ������ ����߿��� �达�� �̾��� ���
   -- name, city, sal �÷� ���
SELECT name, city, sal FROM emp  WHERE city='����' AND SUBSTR(name,1,1) IN ('��' , '��');
SELECT name, city, sal FROM emp  WHERE city='����' AND (SUBSTR(name,1,1)='��' OR SUBSTR(name,1,1)='��');
SELECT name, city, sal FROM emp  WHERE city='����' AND (INSTR(name,'��')=1 OR INSTR(name,'��')=1);


-- name, rrn, city, dept, pos, ���� �÷� ��� : emp ���̺�
   --  ��, �÷����� ��� �ѱ۷� ����ϸ�, ������ rrn�� �̿��Ͽ� ���
SELECT name �̸�, rrn �ֹι�ȣ, city ��ŵ�, dept �μ�, pos ����, DECODE(MOD(SUBSTR(rrn, 8, 1),2), 1, '����', '����') ���� FROM emp;


-- name, dept, hireDate ��� : emp ���̺�
   -- hireDate�� "2020-03-11 ������" �������� ����ϰ� �÷����� �Ի��Ϸ� ����
SELECT name, dept, TO_CHAR(hireDate, 'YYY-MM-DD DAY') �Ի��� FROM emp;


-- name, city, sal, bonus, pay, tax, �Ǽ��ɾ� ��� : emp ���̺�
   -- ��, pay=sal+bonus, tax=pay*2%, �Ǽ��ɾ�=pay-tax
   -- ���ݰ� �Ǽ��ɾ��� �Ҽ��� ù°�ڸ����� �ݿø��ϸ� �Ǽ��ɾ��� 200���� �̻��� �ڷḸ ���
   -- sal, bonus, pay, tax, �Ǽ��ɾ��� ��ȭ��ȣ�� ���ڸ����� �ĸ��� ���
SELECT name, city, TO_CHAR(sal, 'L999,999,999') �⺻��, TO_CHAR(bonus,'L999,999,999') ����, 
      TO_CHAR(sal+bonus, 'L999,999,999') �ѱ޿�, TO_CHAR(ROUND((sal+bonus)*0.02),'L999,999,999') ����, 
      TO_CHAR(ROUND((sal+bonus)-(sal+bonus)*0.02), 'L999,999,999') �Ǽ��ɾ�
FROM emp
WHERE (sal+bonus)-(sal+bonus)*0.02 >=2000000;


-- 70����(rrn �̿�) �� city�� ������ ����� ��� : emp ���̺�
   -- name, rrn, dept, city ���
SELECT name, rrn, dept, city FROM emp WHERE SUBSTR(rrn,1,1)='7' AND city='����';
SELECT name, rrn, dept, city FROM emp WHERE SUBSTR(rrn,1,2)>=70 AND SUBSTR(rrn,1,2)<=79 AND city='����';


-- name, birth, city ��� : emp ���̺�
   -- �� birth�� rrn�� �̿��ϸ�, "2000�� 10�� 10��" �������� ���
SELECT name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY"��" MM"��" DD"��"') birth, city FROM emp;


--�ټӳ���� 10���̻� ��� ��� : emp ���̺�
   -- name, �������, ����, �Ի���, �ټӳ�� ���
   -- ������ϰ� ���̴� rrn�� �̿��ϰ� �ټӳ���� hireDate �̿��Ͽ� ���
   -- ��������� "2000-10-10" �������� ���
SELECT  name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY-MM-DD') �������,
      TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6)))/12) ����, hireDate,
      TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 ) �ټӳ��
FROM emp
WHERE TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 )>=10;
	  
WITH tb as (
    SELECT  name, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)), 'YYYY-MM-DD') �������,
         TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6)))/12) ����, hireDate,
         TRUNC(MONTHS_BETWEEN(SYSDATE, hireDate)/12 ) �ټӳ��
  FROM emp
)
SELECT *
FROM tb WHERE �ټӳ��>=10;	  


-- dept �� pos�� �ߺ��� �����Ͽ� ��� : emp ���̺�
SELECT DISTINCT dept, pos FROM emp;


-- LIKE�� �̿��Ͽ� �̾��� �ƴ� �ڷḸ ��� : emp ���̺�
  -- name, ciry �÷� ���
SELECT name, city FROM emp WHERE name NOT LIKE '��%';


-- INSTR�� �̿��Ͽ� �̾��� �ƴ� �ڷḸ ��� : emp ���̺�
  -- name, ciry �÷� ���
SELECT name, city FROM emp WHERE INSTR(name, '��') !=1 ;


-- name, dept, pos ��� : emp ���̺�
   -- �μ��� ������������ ����ϰ� �μ��� ������ ������ ���������� ���
   -- ����, ����, �븮, ���
SELECT name, dept, pos
FROM emp
ORDER BY dept, DECODE(pos, '����', 0, '����', 1, '�븮', 2, 3);


-- name, dept �÷��� ����ϸ�, dept�� �ѹ����� ����� ���� ��� : emp ���̺�
SELECT name, dept FROM emp
ORDER BY CASE WHEN dept = '�ѹ���' THEN 0 END;
SELECT name, dept FROM emp
ORDER BY DECODE(dept, '�ѹ���', 0, 1);


-- name, rrn, dept, sal �÷� ��� : emp ���̺�
   -- ��, ���ڸ� ���� ����ϰ� ���ڸ� ����ϸ� ������ ������ sal ������������ ���
SELECT name, rrn, dept, sal
FROM emp
ORDER BY 
MOD(SUBSTR(rrn,8,1), 2) DESC, sal;


-- name, dept, sal, bonus, pay, tax, �Ǽ��ɾ� ��� : emp ���̺�
   -- ��, pay=sal+bonus,tax �Ǽ��ɾ�=pay-tax
   -- tax�� pay�� 300�����̻��̸� pay�� 3%, pay�� 250�����̻��̸� pay�� 2%, �׷��� ������ 0
   -- tax�� �����ڸ����� ����

WITH tb AS (
   SELECT name, city, sal, bonus,
       sal+bonus pay,
       CASE
            WHEN (sal+bonus) >= 3000000 THEN TRUNC((sal+bonus) * 0.03, -1)
            WHEN (sal+bonus) >= 2000000 THEN TRUNC((sal+bonus) * 0.02, -1)
            ELSE 0
       END AS tax
       FROM emp
)
SELECT name, city, sal, bonus, pay, tax, 
pay-tax �Ǽ��ɾ�
FROM tb;


-- city�� ������ ��� �� �ٹ� ���� ���� 60���� �̻��� ����� ��� : emp ���̺�
    -- name, hireDate ���
SELECT name, hireDate FROM emp
WHERE city='����' AND MONTHS_BETWEEN(SYSDATE, hireDate) >= 60;


-- tel�� NULL�� �ڷḸ ��� : emp ���̺�
   -- name, city, tel �÷� ���
SELECT name, city, tel FROM emp
WHERE tel IS NULL;


-- tel�� NULL�� ��� '000-0000-0000' ���� ��� : emp ���̺�
   -- name, city, tel �÷� ���
SELECT name, city, NVL(tel, '000-0000-0000') tel FROM emp;


-- tel�� NULL�� �ƴ� �ڷḸ ��� : emp ���̺�
   -- name, city, tel �÷� ���
SELECT name, city, tel FROM emp
WHERE tel IS NOT NULL;


-- name, city, tel �÷� ��� : emp ���̺�
   -- ��, tel�� null�� �ڷḦ ���� ���
SELECT name, city, tel FROM emp
ORDER BY tel NULLS FIRST;


-- name, hireDate ��� : emp ���̺�
    -- ��, �Ի����ڰ� �������� ����� ���
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DAY') = '������';
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'D') = 2;
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DY') = '��';


-- name, hireDate ��� : emp ���̺�
    -- ��, �Ի������� ���ڰ� 1��~5���� ����� ���
SELECT name, hireDate FROM emp WHERE TO_CHAR(hireDate, 'DD') >=1 AND TO_CHAR(hireDate, 'DD') <= 5;
select name, hireDate from emp where EXTRACT(DAY from hireDate) >= 1 AND EXTRACT(DAY from hireDate)<=5;

-- ����ð����� '2020-03-12 09:00:00' ������ ���̸� ������ ȯ���Ͽ� ��� : dual ���̺� �̿�
SELECT TO_DATE('2020-03-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE FROM dual;
SELECT ROUND((TO_DATE('2020-03-12 09:00:00', 'YYYY-MM-DD HH24:MI:SS') - SYSDATE) * 24 * 60) FROM dual;


-- ������ ���۳��� ���(������ 1�� 0�� 0�� 0��) : dual ���̺� �̿�
  -- ��� �� : 2020/04/01 00:00:00
SELECT TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE, + 1),'MM') ,'YYYY/MM/DD HH24:MI:SS') FROM DUAL; 


-- ���� �������� name�� ù���ڿ� ������ ���ڸ� ������ ������ ���ڴ� *�� ġȯ�Ͽ� ����ϵ��� ������ �����Ѵ�.
  -- "��ȣ" ó�� �̸��� ������ ���� "��*ȣ" ó�� ����ϰ� �������� �ش� ���ڸ�ŭ *�� ġȯ�Ѵ�.
  -- "��ȣȣ��"�� "��**��"ó�� ����Ѵ�.
WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '010-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel FROM tbs;

WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT SUBSTR(name, 1, 1) || NVL(LPAD('*', LENGTH(name)-2, '*'), '*') || SUBSTR(name, LENGTH(name), 1) AS name, tel FROM tbs;

  -- �̸� ����ŷ ��
  SELECT SUBSTR('���', 1, 1) || LPAD('*', LENGTH('���')-2, '*') || SUBSTR('���', LENGTH('���'), 1) FROM dual;
  SELECT SUBSTR('���', 1, 1) || NVL(LPAD('*', LENGTH('���')-2, '*'), '*') || SUBSTR('���', LENGTH('���'), 1) FROM dual;
  SELECT SUBSTR('�����', 1, 1) || LPAD('*', LENGTH('�����')-2, '*') || SUBSTR('�����', LENGTH('�����'), 1) FROM dual;

  SELECT SUBSTR(name, 1, 1) || NVL(LPAD('*', LENGTH(name)-2, '*'), '*') || SUBSTR(name, LENGTH(name), 1) FROM emp;


-- ������������ tel�� ������ �ڸ��� ��ŭ *�� ġȯ�Ͽ� ����ϵ��� ������ �����Ѵ�.
   -- ���� ��� "010-1111-1111"�� "010-****-1111"�� ����Ѵ�.
WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel FROM tbs;

WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT name, SUBSTR(tel, 1, INSTR(tel, '-')) || LPAD('*',INSTR(tel, '-', 1, 2)-INSTR(tel, '-')-1, '*') || SUBSTR(tel,INSTR(tel, '-', 1, 2)) tel FROM tbs;


-- name, rrn ��� : emp ���̺�
  -- ��, rrn�� ���� �������ʹ� *�� ���. ���� ��� "010101-1111111" �� "010101-1******"
  -- SUBSTR(), LPAD() �Լ��� �̿��Ѵ�.
SELECT name, SUBSTR(rrn, 1, 8) || LPAD('*', 6, '*') rrn FROM emp;


