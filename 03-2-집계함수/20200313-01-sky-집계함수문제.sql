-- sal+bonus �� ����, ���, �ִ�, �ּҰ� ��� : emp ���̺�
    -- ����  ���  �ִ�  �ּ�

select sum(sal+bonus), avg(sal+bonus), max(sal+bonus), min(sal+bonus) from emp;

-- ��ŵ�(city)�� ���ڿ� ���� �ο��� ��� : emp ���̺�
    -- city   ����   �ο���

select city, '����' ����, count(DECODE(mod(substr(rrn,8,1),2),1,9999)) �ο��� from emp group by city
UNION ALL
select city, '����' ����, count(DECODE(mod(substr(rrn,8,1),2),0,9999)) �ο��� from emp group by city
order by city, ����;

-- ��ŵ�(city)�� ���ڿ� ���� �ο��� ��� : emp ���̺�
    -- city   �����ο���  �����ο���

select city,
count(DECODE(mod(substr(rrn,8,1),2),1,9999)) �����ο���,
count(DECODE(mod(substr(rrn,8,1),2),0,9999)) �����ο���
from emp group by city
order by city;

-- �μ�(dept)�� ���� �ο����� 7�� �̻��� �μ���� �ο��� ��� : emp ���̺�
    -- dept  �ο���

select dept, count(*) �ο���,
count(DECODE(mod(substr(rrn,8,1),2),1,9999)) "�����ο���(�˻�)"  from emp
group by dept
having count(DECODE(mod(substr(rrn,8,1),2),1,9999))>=7;


-- �μ�(dept)�� �ο����� �μ��� ������ ������ ����� �ο��� ��� : emp ���̺�
    -- dept  �ο��� M01  M02  M03 .... M12

select dept, count(*) �ο���,
TO_CHAR(substr(rrn,3,2),'MM')
from emp
group by dept;


-- sal�� ���� ���� �޴� ����� name, sal ��� : emp ���̺�
    -- name   sal

select name, sal from emp
where sal = (select max(sal) from emp);

-- ��
-- ��ŵ�(city)�� ���� �ο����� ���� ���� ��ŵ� �� ���� �ο����� ��� : emp ���̺�
    -- city   �ο���

--1�ܰ�) ���ú� ���� �ο��� ���ϱ�
        select city, 
        count(DECODE(mod(substr(rrn,8,1),2),0,999)) �����ο���
        from emp
        group by city;
        
-- 2�ܰ�) ���� �ο����� ���� ���� �� ���ϱ�
    WITH tb as ( 
        select city, 
        count(DECODE(mod(substr(rrn,8,1),2),0,999)) �����ο���
        from emp
        group by city
    )
    select city, �����ο��� from tb 
    where �����ο��� = (select max(�����ο���) from tb);

-- �μ�(dept)�� �ο��� �� �μ��� �ο����� ��ü �ο����� �� %���� ��� : emp
    -- dept  �ο���  �����

    SELECT dept, round(count(dept) / (SELECT count(*) from emp)*100)||'%' "�μ��� �ο���"
    FROM emp
    group by dept;


-- �μ�(dept) ����(pos)�� �ο����� ����ϸ�, ���������� ������ ��ü �ο��� ��� : emp ���̺�
   -- ROLLUP�� ����ϸ�, �μ��� �������� ����
   -- ��� ��
--dept       pos    �ο���
--���ߺ�    ����    2
--���ߺ�    ���    9
--���ߺ�    ����    1
--���ߺ�    �븮    2
--��ȹ��    ���    2
--     :
--           ���    32
--           ����    7
--           ����    8
--           �븮    13

    select dept, pos, count(*) �ο��� from emp
    group by pos, rollup(dept, pos);


-- �μ�(dept) ����(pos)�� �ο����� ��� : emp ���̺�
    -- ��� ��
--dept       ����  ����  �븮  ���
--�ѹ���    1       2      0      4
--���ߺ�    1       2      2      9
--            :

-- 1�ܰ�) �μ�, ������ �ο��� ���� ����ϱ�
select dept, pos, count(pos) from emp
group by dept, pos
order by dept, pos;

--2�ܰ�) �μ� ������ �ο����� ���Ŀ� �°� ����ϱ�
SELECT 
dept �μ�,  
count(DECODE(pos,'����',999)) ����,
count(DECODE(pos,'����',999)) ����, 
count(DECODE(pos,'�븮',999)) �븮, 
count(DECODE(pos,'���',999)) ��� 
from emp
group by dept;

-- �μ�(dept) ����(pos)�� �ο����� ����ϰ� �������� ������ �ο��� ��� : emp ���̺�
    -- ��� ��
--dept       ����  ����  �븮  ���
--���ߺ�    1       2      2      9
--��ȹ��    2       0      3      2
--            :
--            7        8     13     32

SELECT 
dept �μ�,  
count(DECODE(pos,'����',999)) ����,
count(DECODE(pos,'����',999)) ����, 
count(DECODE(pos,'�븮',999)) �븮, 
count(DECODE(pos,'���',999)) ���
from emp
group by rollup(dept)
order by �μ�;
