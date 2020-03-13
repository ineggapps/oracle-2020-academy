--��3��
--SQL ������ �Լ�(�׷� �Լ�)

--1. �׷� �Լ��� ����
--COUNT
--SUM
--AVG
--MAX
--MIN
--STDDEV
--VARIANCE
--ROLLUP: �ԷµǴ� �������� �Ұ� ���� �ڵ����� ����Ͽ� ���
--CUBE: �ԷµǴ� �������� �Ұ� �� ��ü �Ѱ踦 �ڵ����� ����Ͽ� ���
--GROUPINGSET: �� ���� ������ ���� ���� �Լ����� �׷����� �����ϱ� 
--LISTAGG
--PIVOT
--LAG
--LEAD
--RANK

--1.1 COUNT
select count(*), count(comm) from emp;

--1.2 SUM
select SUM(comm) from emp;

--1.3 AVG
select AVG(sal) from emp;

--1.4 MAX, MIN
select max(sal), min(sal) from emp;

--1.5 STDEV, VARIANCE
select round(STDDEV(sal)), round(VARIANCE(sal)) from emp;

--2. GROUP BY ���� ����� Ư�� �������� �������� �׷�ȭ
SELECT deptno, round(AVG(NVL(sal,0))) ��� from emp
GROUP BY deptno;

--���� ��� �� ���ǻ���
--(1). SELECT���� ���� �׷� �Լ� �̿��� �÷��̳� ǥ������ �ݵ�� GROUP BY���� ���Ǿ�� �Ѵ�. 
--��, GROUP BY���� ��޵� �÷����̶�� �ؼ� �� SELECT���� ��޵Ǿ�� �ϴ� ���� �ƴ�.

--(2) GROUP BY ������ �ݵ�� �÷����� ���Ǿ�� �ϸ�, �÷� Alias�� ����� �� ����.
--������ FROM => WHERE => GROUP BY => HAVING => SELECT => ORDER BY ������ ������ �����ϱ� ����!

--3. HAVING���� ����� �׷����� �������� �˻��ϱ�
--emp���̺��� ��� �޿��� 2000 �̻��� �μ��� �μ� ��ȣ�� ��� �޿�?
select deptno, round(AVG(nvl(sal,0))) from emp
GROUP BY deptno HAVING AVG(nvl(sal,0)) >=2000;

--4. �ݵ�� �˾ƾ� �ϴ� �پ��� �м� �Լ�
--ROLL UP

--(1)�μ��� ������ ��� �޿� �� �������
--(2)�μ��� ��� �޿��� ��� ��,
--(3)��ü ����� ��� �޿��� ��� ���� ���ϼ���.

select deptno, job, round(AVG(sal)), count(*) from emp
group by ROLLUP(deptno, job);

--4.1 ROLLUP(deptno, job)
--(1) DEPTNO�� JOB�� ������ ����
--(2) DEPTNO�� ������ ����
--(3) ��ü ������ ����

--ROLLUP�� ���������....
select deptno, job, round(avg(sal)) avg_sal, count(*) cnt_emp from emp group by deptno, job -- (1) DEPTNO�� JOB�� ������ ����
UNION ALL
select deptno, NULL job, round(avg(sal)) avg_sal, count(*) cnt_emp from emp group by deptno -- (2) DEPTNO�� ������ ����
UNION ALL
select NULL deptno, NULL, round(avg(sal)), count(*) cnt_emp from emp --��ü ������ ����
order by deptno, job;

--
create table professor2
as select deptno, position ,pay
from professor;

INSERT INTO professor2 values(101, 'instructor',100);
insert into professor2 values(101,'a full professor',100);
insert into professor2 values(101,'assistant professor',100);
commit;

select * from professor2 order by deptno, position;

SELECT deptno, position, SUM(pay) from professor2
group by deptno, ROLLUP(position);

--4.2 CUBE�Լ� �Ұ�� ��ü �հ���� ���
-- (1) �μ��� ��� �޿��� ��� ��
-- (2) ���޺� ��� �޿��� ��� ��
-- (3) �μ��� ���޺� ��� �޿��� ��� ��
-- (4) ��ü ��� �� �޿��� ��� ��

select deptno, job, round(AVG(sal)), count(*)
from emp
GROUP BY CUBE(deptno, job)
order by deptno, job;

--CUBE(�μ�, ����)
--�μ����� ���޺� ������ ����
--�μ��� ������ ����
--���޺� ������ ����
--�� ������ ����

--CUBE�� ���������...
select deptno, NULL job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by deptno  --(1)�μ��� ��� �޿��� ��� ��
UNION ALL
select NULL deptno, job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by job --(2) ���޺� ��� �޿��� ��� ��
UNION ALL
select deptno, job, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp group by deptno, job --(3) �μ��� ���޺� ��� �޿��� ��� ��
UNION ALL
select NULL, NULL, round(AVG(sal)) avg_sal, count(*) cnt_emp from emp -- (4) ��ü ��� �޿��� ��� ��
order by deptno, job;

--4.3 GROUPING SETS() �Լ�
--�׷��� ������ ���� ���� ��� �����ϰ� ���ȴ�.
--ex) �л� ���̺��� �г⺰�� �л����� �ο����� �հ�� �а����� �ο����� �հ踦 ���� ���
--�������� UNION�������� (1) �г⺰ �л����� �ο���, (2) �а��� �ο��� �հ踦 ���ߴ�.

select grade, null, count(*) from student group by grade --�г⺰ �л��� ��
UNION ALL
select null, deptno1, count(*) from student group by deptno1; -- �а��� �л��� ��

--��ó�� ���Ѵ� ������
--�����ϰ� ���´�.
select grade, deptno1, count(*) from student group by GROUPING SETS(grade, deptno1);
--�г⺰��, �а����� ���ε��� �հ踦 ���� ��쿡 ����Ѵٰ� ����ϸ� �ǰڴ�!

-- ���ǻ���: group by grade, deptno1�� �г� �߿����� �а����� �׷����ϴ� ���� �ǹ��Ѵ�.
select grade, deptno1, count(*) from student group by grade, deptno1;


--�ϴ� ��� �������� ����!