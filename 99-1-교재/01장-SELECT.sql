--��1��
--SELECT ����� �̿��Ͽ� �����͸� ��ȸ�մϴ�.

--1. ��� �÷� ��ȸ�ϱ�
select * from emp;

--2. ���ϴ� �÷��� ��ȸ�ϱ�
select empno, ename from emp;

--3. SELECT ��ɿ� ǥ������ ����Ͽ� ����ϱ�
select ename, 'good morning~~!' "Good Morning" from emp;

--4. �÷��� ��Ī�� ����Ͽ� ����ϱ�
select empno, ename, job from emp;
select empno as "�����ȣ", ename as  "�����", job as "����" from emp;
select ename "�����" from emp;
select ename ����� from emp;

--5. DISTINCT�� �ߺ��� ���� �����ϰ� ����ϱ�
select deptno from emp;
select DISTINCT deptno from emp;

--DISTINCT ��� �� ���ǻ���
--DISTINCTŰ���带 �Է��ϸ� select ���� ��ȸ�ϰ��� �ϴ� ��� �÷��� ����ȴ�.
select deptno, ename from emp; --12���� ���
select DISTINCT deptno, ename from emp; --12���� ���

--6. ����(||)�����ڷ� �÷��� �ٿ��� ����ϱ�
--�Ǵ� �ռ� �����ڶ�� ��
select ename, job from emp;
select ename || job from emp;

--���Ῥ���ڸ� ����ϸ� ����Ŭ������ 1���� �÷����� �ν��Ѵٴ� ���� �������.
select ename||'''s job is ' || job "Name and Job" from emp;

--��������1
--student���̺��� ��� �л��� �̸��� ID, ü���� ����� ��. �÷����� ID AND WEIGHT
--(���̺��� ��� emp���̺�� ��ü�Ͽ���)
select ename||'''s ID: ' || empno || ', Salary is ' || sal as "ID AND SAL" from emp;

--��������2
--emp���̺��� ��ȸ�Ͽ� ��� ����� �̸��� ������ �Ʒ��� ���� ���
-- SMITH(CLERK), SMITH';CLERK'
select ename||'('||job||'), '||ename||''''||job||'''' as "NAME AND JOB" from emp;

--��������3
--emp���̺��� ��ȸ�Ͽ� ��� ����� �̸��� �޿��� �Ʒ��� ���� ���·� ���
--SMITH's sal is $800
select ename||'''s sal is $'||sal as "NAME AND SAL" from emp;

--7. ���ϴ� ���Ǹ� ��󳻱� (WHERE)
select empno, ename 
from emp 
where empno=7900;

--���ڿ� ��¥�� ��ȸ�ϰ� ���� ��쿡�� ���� ����ǥ�� ����Ѵ�.
select empno, ename, sal
from emp
where ename='SMITH';

-- ���� ��ȸ �ÿ��� ��������ǥ�� ��ҹ��ڸ� �����Ͽ��� �Ѵ�.
-- �����ͺ��̽����� SMITH��� �빮�ڷ� ���� �����͸� �����Ƿ� smith�� ��ȸ�� ��� ��Ÿ���� ���� ���̴�.
select empno, ename, sal
from emp
where ename='smith'; --��� ����

--��¥ ǥ�� ������ �ü���� ���� ������ ���� �ٸ���.
--������ ���н� �迭 ���̿� �����͸� �ű�� �۾��� �� ���� ������ �߻��� �� �����Ƿ� �����ؾ� �Ѵ�.
--��¥�� ��ȸ�� ���� ���������� ��������ǥ�� ����Ѵ�.
select ename, hiredate from emp
where ename='SMITH';

--��¥�� �̿��Ͽ� �˻��ϴ� ���
select empno, ename, sal, hiredate
from emp
where hiredate='80/12/17';
--��¥�� �����ڰ� ���Ե� ��� ��ҹ��ڸ� �������� �ʴ´�.

select empno, ename, sal, hiredate
from emp
where hiredate='80-12-17';

--8. SQL���� �⺻ ��� ������ ����ϱ�
select ename, sal from emp where deptno = 10;
select ename, sal, sal*10 from emp where deptno=10;
select ename, sal, sal*1.1 from emp where deptno=10;
--��������� ��� �� ������ �켱���� ������ ��.

--9. �پ��� ������ Ȱ���ϱ�
-- =
--  !=, <>
-- >
-- >=
-- <
-- <=
-- BETWEEN a AND b
-- IN(a,b,c)
-- LIKE
-- IS NULL / IS NOT NULL
-- A AND B
-- A OR B
-- NOT A 

select empno, ename, sal from emp
where sal >= 4000;

--���� 'W'���� ũ�ų� ���� ename�� ã�Ƽ� ����ϱ�
select empno, ename, sal from emp
where ename >='W';

select ename, hiredate from emp order by hiredate desc;
select ename, hiredate from emp
where hiredate >= '81/12/25'; --��¥�ε� ��ұ����� �����ϴ� (����/����)

--emp���̺��� sal�� 2000�� 3000 ������ ������� empno, ename, sal ���� ���
select empno, ename, sal from emp
where sal BETWEEN 2000 AND 3000;

--������ �������̸� BETWEEN�����ں��ٴ� �� �����ڸ� ����� ���� �����Ѵ�
select empno, ename, sal from emp 
where sal >= 2000 and sal <=3000;

select ename from emp order by ename;
--���� ���� ���ڷε� ������ �����Ͽ� ������ �� ����.
select ename from emp where ename BETWEEN 'JAMES' AND 'MARTIN'
order by ename;

--IN�����ڷ� ������ �����ϰ� �˻��ϱ�
---emp���̺��� 10�� �μ��� 20�� �μ��� �ٹ��ϴ� ������� ���� �˻�
select empno, ename, deptno from emp
where deptno in (10,20);

--LIKE�����ڷ� ����� �͵� ��� ã��
--������ 1�� ����
select empno, ename, sal from emp
where sal LIKE '1%';

--������� A�� ����
select empno, ename, sal from emp
where ename LIKE 'A%';

--������ �ü������........
--���ɿ� ���� ������ �ִ� ����
--select empno, ename, hiredate from emp
--where hiredate LIKE '%80';
--���� �ü���� �ƴϸ� ��Ƚ���� ������ ���� ���� ����.

--�Ի���� 12���� ��� ��� ���
select empno, ename, hiredate
from emp
where hiredate like '___12%'; -- _ 3��

--NULL�� ��ȸ�ϱ� (IS NULL / IS NOT NULL)
select empno, ename, comm from emp
where comm IS NULL;

