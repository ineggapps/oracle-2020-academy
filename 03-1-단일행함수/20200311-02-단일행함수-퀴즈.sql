--�������: �ֹε�Ϲ�ȣ ���� �� ���ǻ� ������ RR�� �̿��ϱ�. (���� ���� �ÿ��� ��� ����� ���� ����Ͽ� �ۼ��ؾ� �Ѵ�)

-- SKY �������� �ڽ��� ��� ���̺� ��� ���
select * from tab;
select * from tabs;

-- emp ���̺��� ���� ���
desc emp;
select * from COL where tname='EMP';
select * from COLS where table_name ='EMP';

-- emp ���̺��� ��� �ڷ� ���
select * from emp;

-- emp ���̺��� city�� ������ ����߿��� �达�� �̾��� ���
   -- name, city, sal �÷� ���
select name, city, sal
from emp
where city='����' and (substr(name,1,1)='��' or INSTR(name,'��')=1); -- �ۼ� ���
--where city='����' and substr(name,1,1) in ('��','��'); -- ���� ���

-- name, rrn, city, dept, pos, ���� �÷� ���.
   --  ��, �÷����� ��� �ѱ۷� ����ϸ�, ������ rrn�� �̿��Ͽ� ���
select 
name �̸�, rrn �ֹε�Ϲ�ȣ, city ����, dept �μ�, pos ����,
decode(mod(substr(rrn,8,1),2),1,'��','��') ����
from emp;

select
name �̸�, rrn �ֹε�Ϲ�ȣ, city ����, dept �μ�, pos ����,
CASE mod(substr(rrn,8,1),2)
WHEN 1 THEN '��'
else '��'
END ����
from emp;

--(��ü ����... �ֹε�Ϲ�ȣ ���ڸ� 1�ڸ��� �����ϰ� ��� ���� ����ϱ�)
select 
name �̸�, RPAD(substr(rrn,1,8),length(rrn),'*') �ֹε�Ϲ�ȣ, city ����, dept �μ�, pos ����,
decode(mod(substr(rrn,8,1),2),1,'��','��') ����
from emp;

select
name �̸�, RPAD(substr(rrn,1,8),length(rrn),'*') �ֹε�Ϲ�ȣ, city ����, dept �μ�, pos ����,
CASE mod(substr(rrn,8,1),2)
WHEN 1 THEN '��'
else '��'
END ����
from emp;

-- name, dept, hireDate ���
   -- hireDate�� "2020-03-11 ������" �������� ����ϰ� �÷����� �Ի��Ϸ� ����
select name, dept, 
TO_CHAR(hireDate,'YYYY-MM-DD DAY') �Ի��� 
from emp;

-- name, city, sal, bonus, pay, tax, �Ǽ��ɾ� ���
   -- ��, pay=sal+bonus, tax=pay*2%, �Ǽ��ɾ�=pay-tax
   -- ���ݰ� �Ǽ��ɾ��� �Ҽ��� ù°�ڸ����� �ݿø��ϸ� �Ǽ��ɾ��� 2000000���� �̻��� �ڷḸ ���
   -- sal, bonus, pay, tax, �Ǽ��ɾ��� ��ȭ��ȣ�� ���ڸ����� �ĸ��� ���

--with with and double select
select name, city, 
TO_CHAR(sal,'L999,999,999') sal,
TO_CHAR(bonus,'L999,999,999') bonus,
TO_CHAR(pay,'L999,999,999') pay,
TO_CHAR(round(pay-tax,1),'L999,999,999') �Ǽ��ɾ� from (
    WITH tb as (
        select name, city, 
        sal,
        bonus,
        sal+nvl(bonus,0) pay from emp
    )
    select tb.*, round(pay*0.02,1) tax from tb
) tbb;

-- with with
WITH tb as (
    select name, city, sal, bonus, 
    sal+nvl(bonus,0) pay, 
    round((sal+nvl(bonus,0))*0.02,1) tax
    from emp
) 
select 
name, city,
TO_CHAR(sal, 'L999,999,999') sal ,
TO_CHAR(bonus,'L999,999,999') bonus,
TO_CHAR(pay,'L999,999,999') pay,
TO_CHAR(round(pay-tax,1),'L999,999,999') �Ǽ��ɾ� from tb;

--without with
select name, city, 
    TO_CHAR(sal, 'L999,999,999') sal,
    TO_CHAR(bonus,'L999,999,999') bonus, 
    TO_CHAR(sal+nvl(bonus,0),'L999,999,999') pay, 
    TO_CHAR(round((sal+nvl(bonus,0))*0.02,1),'L999,999,999') tax,
    TO_CHAR(round(sal+nvl(bonus,0)-round((sal+nvl(bonus,0))*0.02,1),1),'L999,999,999') �Ǽ��ɾ�
from emp;

-- 70����(rrn �̿�) �� city�� ������ ����� ���
   -- name, rrn, dept, city ���

--��¥�Լ� Ȱ�� ��
select name, rrn, dept, city from emp
where substr(rrn,1,1)=7;

-- name, birth, city ���
   -- �� birth�� rrn�� �̿��ϸ� "2000�� 10�� 10��" �������� ���

select name, 
TO_CHAR(TO_DATE(substr(rrn,1,6),'RRMMDD'),'YYYY"��" MM"��" DD"��"') birth, 
city 
from emp;

--�ټӳ���� 10���̻� ��� ���
   -- name, �������, ����, �Ի���, �ټӳ�� ���
   -- ������ϰ� ���̴� rrn�� �̿��ϰ� �ټӳ���� hireDate �̿��Ͽ� ���
   -- ��������� "2000-10-10" �������� ���

select name,
TO_CHAR(TO_DATE(substr(rrn,1,6),'RRMMDD'),'YYYY-MM-DD') �������,
TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(substr(rrn,1,6),'RRMMDD'))/12)||'��' ����, 
TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12)||'��' �ټӳ��
from emp
where TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate)/12)>=10;


-- dept �� pos�� �ߺ��� �����Ͽ� ���

select dept, pos from emp; --�ߺ� ���� ��
select distinct dept, pos from emp order by dept; -- �ߺ� ���� Ű���� �Ǵ� UNIQUE ���� ����

-- LIKE�� �̿��Ͽ� �̾��� �ƴ� �ڷḸ ���
  -- name, ciry �÷� ���

select name, city from emp
where name not like '��%';

-- INSTR�� �̿��Ͽ� �̾��� �ƴ� �ڷḸ ���
  -- name, ciry �÷� ���

select name, city from emp
where INSTR(name,'��')<>1;

-- name, dept, pos ���
   -- �μ��� ������������ ����ϰ� �μ��� ������ ������ ���������� ���
   -- ����, ����, �븮, ���

select name, dept, pos from emp
order by dept, 
CASE pos
WHEN '����' THEN 0
WHEN '����' THEN 1
WHEN '�븮' THEN 2
--WHEN '���' THEN 3
ELSE 3
END;

select name, dept, pos from emp
order by dept,
DECODE(pos,'����',0,'����',1,'�븮',2,3);

-- (���� ����) ���ߺ� => �ѹ���
-- name, dept �÷��� ����ϸ�, dept�� �ѹ����� ����� ���� ���

select name, dept from emp
order by 
CASE dept
WHEN '�ѹ���' THEN 0
else 1
END;

select name, dept from emp
order by DECODE(dept,'�ѹ���',0,1);

-- name, rrn, dept, sal �÷� ���
   -- ��, ���ڸ� ���� ����ϰ� ���ڸ� ����ϸ� ������ ������ sal ������������ ���

select name, rrn, dept, sal from emp
order by mod(substr(rrn,8,1),2) desc, sal asc;

-- name, dept, sal, bonus, pay, tax, �Ǽ��ɾ� ���
   -- ��, pay=sal+bonus,tax �Ǽ��ɾ�=pay-tax
   -- tax�� pay�� 300�����̻��̸� pay�� 3%, pay�� 250�����̻��̸� pay�� 2%, �׷��� ������ 0
   -- tax�� �����ڸ����� ����

select TBB.*, pay-tax �Ǽ��ɾ� from (
WITH TB as (
    select name, dept, sal, bonus,
    sal+nvl(bonus,0) pay
    from emp
)
select tb.*, 
CASE
WHEN pay>=3000000 THEN trunc(pay*0.03,-1)
WHEN pay>=2500000 THEN trunc(pay*0.02,-1)
ELSE 0
END tax
from TB) TBB;

-- city�� ������ ��� �� �ٹ� ���� ���� 60���� �̻��� ����� ���
    -- name, hireDate ���

select name, hireDate, TRUNC(MONTHS_BETWEEN(SYSDATE,hireDate))||'����' "�ٹ� ���� ��" from emp
where MONTHS_BETWEEN(SYSDATE,hireDate)>=60
order by hireDate desc; --Ȯ�ο� ���� �ɼ�

-- tel�� NULL�� �ڷḸ ���
   -- name, city, tel �÷� ���

select name, city, tel from emp 
where tel is null;

-- tel�� NULL�� ��� '000-0000-0000' ���� ���
   -- name, city, tel �÷� ���

select name, city, nvl(tel,'000-0000-0000') ó����� from emp
order by tel asc nulls first;
--����: NVL�� NULL���� ó���Ǿ nulls first�� ������

-- tel�� NULL�� �ƴ� �ڷḸ ���
   -- name, city, tel �÷� ���

select name, city, tel from emp
where tel is not null;

-- name, city, tel �÷� ���
   -- ��, tel�� null�� �ڷḦ ���� ���

select name, city, tel from emp
order by tel nulls first;

-- name, hireDate ���
    -- ��, �Ի����ڰ� �������� ����� ���

select name, hireDate, TO_CHAR(hireDate,'DAY') �Ի���� from emp
where TO_CHAR(hireDate,'D')=2; --�ۼ� ���

select name, TO_CHAR(hireDate, 'YYYY-MM-DD DAY') from emp
where TO_CHAR(hireDate,'DAY')='������'; -- ���� ���

-- name, hireDate ���
    -- ��, �Ի������� ���ڰ� 1��~5���� ����� ���

--TO_CHAR ���
select name, hireDate from emp
where TO_CHAR(hireDate,'DD') >= 1 and TO_CHAR(hireDate,'DD') <=5;

--extract ���

select name, hireDate from emp
where EXTRACT(DAY from hireDate) BETWEEN 1 AND 5;

select name, hireDate from emp
where EXTRACT(DAY from hireDate) >= 1 and EXTRACT(DAY from hireDate) <=5 ;


-- ����ð����� '2020-03-12 09:00:00' ������ ���̸� ������ ȯ���Ͽ� ���
-- ���� �ð��� �񱳴��(3/12)���� �ʴٴ� ���� �Ͽ� �ۼ�
-- ��¥���� ��¥�� ���� �ϼ��� ��ȯ�Ѵ�. ������ �ϼ���� �Ϳ� �����ϰ� �ۼ��Ѵ�.
--��¥�� ���� �������� ��¥�� �ڵ���ȯ���� �ʴ´�.
--select '2020-03-12 09:00:00' - SYSDATE from dual; --����
--select TO_DATE('2020-03-12 09:00:00') - SYSDATE from dual; --����

--�ð��� 3�� 12�� 09�� ���� ���� ����
select trunc((TO_DATE('2020-03-12 09:00:00','YYYY-MM-DD HH:MI:SS')-SYSDATE)*24*60)||'��' as "�ð��� ���ҽ��ϴ�" from dual;
--�ð��� 3�� 12�� 09�� ���� ���� ����
select trunc((SYSDATE-TO_DATE('2020-03-12 09:00:00','YYYY-MM-DD HH:MI:SS')) *24*60)||'��' as "�ð��� ����� ��" from dual;

-- ������ ���۳��� ���(������ 1�� 0�� 0�� 0��)
  -- ��� �� : 2020/04/01 00:00:00
select TO_CHAR(LAST_DAY(TRUNC(SYSDATE,'DAY'))+1,'YYYY/MM/DD HH24:MI:SS') "������ ���� ��¥" from dual;
select TO_CHAR(LAST_DAY(TRUNC(SYSDATE,'DAY'))+INTERVAL '1' DAY,'YYYY/MM/DD HH24:MI:SS') "������ ���� ��¥" from dual;

select TO_CHAR(TRUNC(ADD_MONTHS(SYSDATE,1),'MM'), 'YYYY/MM/DD HH24:MI:SS') --������ ���
from dual;

---������ �߰��� ����

-- ������������ name�� ù���ڿ� ������ ���ڸ� ������ ������ ���ڴ� *�� ġȯ�Ͽ� ����ϵ��� ������ �����Ѵ�.
  -- "��ȣ" ó�� �̸��� ������ ���� "��*ȣ" ó�� ����ϰ� �������� �ش� ���ڸ�ŭ *�� ġȯ�Ѵ�.
  -- "��ȣȣ��"�� "��**��"ó�� ����Ѵ�.
WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT name,
substr(name,1,1)||
--DECODE(length(name),2,'*',LPAD('*',length(substr(name,2,length(name)-1))-1,'*'))
--NVL�� �ϸ� �̷��� ���� ����!
nvl(LPAD('*',length(substr(name,2,length(name)-1))-1,'*'),'*')
||substr(name,length(name)) ����������ȣ
,tel
FROM tbs;

--��Ʈ
select 
substr('���',1,1) || 
nvl(LPAD('*', length('���')-2,'*'),'*')||
substr('���',length('���'))
from dual;

--����ŷ ���
select
-- LPAD ����
-- 1�ܰ�. �� 4�ڸ��� A�� �Է� => �ܿ� 3�ڸ�
-- 2�ܰ�. ���� 3�ڸ��� *�� �Է� => LPAD�̹Ƿ� A �ڿ� *** �Է�
---���: A***
-- ����: A ��� *�� �Է��ϸ�? ���ϴ� �ڸ�����ŭ�� * �Է��ϱ� ��...
LPAD('A',4,'*')
from dual;


-- ������������ tel�� ������ �ڸ��� ��ŭ *�� ġȯ�Ͽ� ����ϵ��� ������ �����Ѵ�.
   -- ���� ��� "010-1111-1111"�� "010-****-1111"�� ����Ѵ�.
WITH tbs AS (
   SELECT '��ȣ' name, '010-1234-4125' tel FROM dual UNION ALL
   SELECT '�����ѹα�' name, '010-1234-6524' tel FROM dual UNION ALL
   SELECT '������' name, '011-485-8574' tel FROM dual UNION ALL
   SELECT 'ȫ�浿' name, '02-235-4125' tel FROM dual UNION ALL
   SELECT '�̹�' name, '031-4582-4125' tel FROM dual
)
SELECT name, tel, 
substr(tel,1,INSTR(tel,'-'))||
LPAD('*',length(substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-'))),'*')||
substr(tel,INSTR(tel,'-',1,2),length(tel)) "���� ��ȭ��ȣ",
substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')) "�˻�",
INSTR(tel,'-') "������ ó�� ���� ��ġ",
INSTR(tel,'-',1,2) "������ �� �� ���� ��ġ"
FROM tbs;

--INSTR(tel,'-')): ��ȭ��ȣ���� ������(-)�� ó�� �����ϴ� ���� ��ġ
--INSTR(tel,'-'))-1: ��ȭ��ȣ���� ������(-)�� ó�� �����ϱ� �������� ��ġ

--INSTR(tel,'-',1,2): ��ȭ��ȣ���� ������(-)�� �� ��°�� �����ϴ� ���� ��ġ
--INSTR(tel,'-',1,2)-1: ��ȭ��ȣ���� ������(-)�� �� ��°�� �����ϱ� �������� ��ġ

-- �߰� ���� ���ϴ� ����
-- A - B��� ������ ��,
--INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')
--�� ��° ������(-)�� ���� ���� ��ġ���� ù ��° ������(-)�� ������ ��ġ�� ����.
--010-1234-4125�� ��� 
--A=8
--B=4

--substr(tel,INSTR(tel,'-')+1,INSTR(tel,'-',1,2)-1 - INSTR(tel,'-')) "�˻�" �ؼ�
--substr(��ȭ��ȣ, ��ȭ��ȣ���� �������� ó�� �����ϴ� ��ġ+1, 
-- ��ȭ��ȣ���� �� ��°�� �������� �����ϴ� ��ġ - 1 - ó�� �����ϴ� ��ġ)
--substr(tel, A, B) �϶�
--010-1234-4125�� ��쿡
--substr(tel, 5, 8-4)�� �ȴ�.
--02-235-4125�� ��쿡
--substr(tel, 4, 6-3)�� �ȴ�.

-- name, rrn ��� : emp ���̺�
  -- ��, rrn�� ���� �������ʹ� *�� ���. ���� ��� "010101-1111111" �� "010101-1******"
  -- SUBSTR(), LPAD() �Լ��� �̿��Ѵ�.
select name, rrn, RPAD(substr(rrn,1,8),14,'*') ����������ȣ from emp;
select name, rrn, substr(rrn,1,8)||LPAD('*',6,'*') ����������ȣ from emp; -- ���ڿ��� ����

-- REPLACE ����
-- ��ȭ��ȣ ������(-) ���� ����ϱ�
 select REPLACE(tel,'-') from emp;