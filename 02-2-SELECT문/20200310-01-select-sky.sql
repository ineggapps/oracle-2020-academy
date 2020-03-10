select * from emp;
--�μ��� �˻� (�ߺ� ����)
select dept from emp;
select all dept from emp; --�տ� all�̶�� Ű���带 �����Ͽ��� �����ϰ� �۵��Ѵ�.
-- where���� ����� ALL���� �ٸ� �ǹ��̴�. (where���� ALL�� AND����)

--�μ��� �˻� (�ߺ� ����) DISTINCT, UNIQUE
select distinct dept from emp; -- �ߺ��� ���� ������ 1���� ����Ѵ�.
select unique dept from emp; -- Ű���尡 2���������� �ᱣ���� ����.
select distinct empNo, name from emp; --�̷� ���� �ǹ̰� ����. empNo�� ������ �� �ٸ� �״ϱ�
select distinct city from emp;

-- ����

-- SELECT�� ���� ��� ����
-- SELECT �÷���(ǥ����)
-- FROM ���̺�
-- WHERE ����
-- GROUP BY �÷���(ǥ����)
-- HAVING �����Լ� ���ǽ�
-- ORDER BY �÷���(ǥ����)

--SELECT ���� ���� ����
--FROM ���̺�� - �� ������ �ش��ϴ� ���̺��� �ִ�? ���� �˻��Ѵ�
--WHERE ���ǽ�  
--GROUP BY �÷���(ǥ����)
--HAVING �����Լ����ǽ�
--SELECT �÷���(ǥ����)
--ORDER BY �÷���(ǥ����)

-- ORDER BY�� (����)
-- ������ ������ �������� ������ �⺻������ �⺻Ű�� ������������ ����ȴ�.
-- SQL������ ���� �������� �����Ѵ�. 
-- ASC:�⺻, �������� / DESC: ��������
-- ���� ����
select name, city, sal+bonus pay from emp where pay>=300000; --���� (pay�� emp���̺��� �÷��� �ƴϴ�)
-- ���� (�������)
--1. from���� ���� �����Ѵ�. 
--2. where���� �� ���� �����Ѵ�. (pay��� �÷��� ã������ �õ��� ���� but �������� ����) => ���� �߻�
--3. select���� �����ϰ�
--4. order by���� �����Ѵ�. ���� �������� ������ pay�� Ȱ���� �� �ִ�.
select name, city, sal+bonus pay from emp order by sal+bonus;
select name, city, sal+bonus pay from emp order by pay desc; --�������ε� ������ �����ϴ�

--���� ������ ���� ���� �����ϰ� �׸�� ��������/���������� ������ ������ �� �ִ�. 
select name, city, sal, bonus, sal+bonus pay from emp order by pay desc, sal;
select name, city, sal, bonus, sal+bonus pay from emp order by pay desc, sal desc;

select name, city, dept, pos, sal, bonus from emp order by city;
select name, city, dept, pos, sal, bonus from emp order by city, dept;
select name, city, dept, pos, sal, bonus from emp order by city, sal desc;

--���ڸ� sal �������� ���
select name, rrn, city, dept, pos, sal, bonus
from emp
where mod(substr(rrn,8,1),2)=0
order by sal desc;

--����=>���� ������� SAL ������������ ���
select name, rrn, city, dept, pos, sal, bonus
from emp
order by mod(substr(rrn,8,1),2) desc, sal desc;

--dept �������� �����ϰ� dept�� ������ ���ڸ� ���� ���:
select name, rrn, city, dept, pos, sal, bonus
from emp
order by dept, mod(substr(rrn,8,1),2) desc;

--�� ORDER BY�� �����ϸ� DBMS�� �����ϰ� �ɸ���.
--���� �ǹ������� �����͸� �����Ͽ� JAVA���� �����ϴ� ����� �̿��ϱ⵵ ��.

--�����θ� �ֿ켱���� ������� ����ϴ� ���. (������ �μ��� ������ ���� ����)
--�����ΰ� �ƴ� �μ����� ���ǿ� �ɸ��� �����Ƿ� null�� ��µȴ�.
select name, rrn, city, dept, pos, sal, bonus
from emp 
order by CASE when dept='������' then 0 end; --�����ΰ� �ƴϸ� null

select name, rrn, city, dept, pos, sal, bonus
from emp
order by decode(dept,'������',0); --�����ΰ� �ƴϸ� null

--������ �̿��� �μ����� null�� �Ǵ����� ������ ����!
select dept, case when dept='������' then 0 end as CASE from emp;
select dept, decode(dept,'������',0) from emp;

--����(POS) ���� ��ȸ (�ߺ� ����)
select distinct pos from emp;
-- ����, ����, �븮, ��� ������ ����ϴ� ��� (DECODE �̿�)
-- CASE�� �̿��Ͽ��� ������ �ڵ尡 ����������.
select name, pos 
from emp
--order by decode(pos,'����',0,'����',1,'�븮',2,'���',3);
order by decode(pos,'����',0,'����',1,'�븮',2,3);

--��ȭ��ȣ�� null�� �����͸� ���� ���
select name, tel
from emp
order by tel NULLS FIRST;

--��ȭ��ȣ�� null�� �����͸� ���߿� ���
select name, tel
from emp
order by tel NULLS LAST;

-- ��ü ��ȸ
select * from emp;

--������ ������ �ٸ� ������ ����ϴ� ���
select * from emp 
order by DBMS_RANDOM.VALUE;
select DBMS_RANDOM.VALUE from dual; --������ �����ϴ� ���� Ȯ���� �� �ִ�.

--������ ������ ������ 5���� �������� �����ϴ� ���
select * from (
    select * from emp
    order by DBMS_RANDOM.VALUE
) where rownum<=5; -- ROWNUM�� ��� �����̴�. ORDER BY�� �ִ� ���� ����� �� ����.
-- ROWNUM: ������ ����� ������ ������ ��鿡 ���� ���� ���� ��Ÿ���� �ǻ� �÷�.

--select empno, name, rrn from emp order by 1; --���ڷε� ������ �����ϳ� �������� �ʴ� ���
--���������� select�� �׸��� ������ �� ������ �ٲ�� �ٽ� order by�������� ���ڸ� �ٽ� ��������� �ϴϱ�.

--���� ������ (������, ������, ������)
--UNION (������)
--UNION ALL 
--MINUS (������)
--INTERSECT (������)

--���ߺ��� �׸�� ���ð� ��õ�� �׸� ��ȸ
--UNION: ù ��° SELECT���� ����� �� ��° SELECT���� ����� ��ģ�ٰ� �ϴ��� 
--���� �׸��� �� ���� ����ϰ� �ȴ�.
select name, city, dept from emp where dept='���ߺ�'
UNION
select name, city, dept from emp where city='��õ';

-- �÷��� �޶� �� ������ Ÿ���� �����ϸ� �����ϴ�
-- ���� �� ���� select���� 3��° �׸��� sal�� bonus�� �ٸ� �׸������� 
-- Ÿ���� �����ϹǷ� Ȱ���� �����ϴ�.
select name, city, dept,sal from emp where dept='���ߺ�'
UNION
select name, city, dept,bonus from emp where city='��õ';

--�ڡڡڡڡ�UNION ALL: ù ��° SELECT���� ����� �� ��° SELECT���� ����� ��� ���
--(�ߺ����� �����Ͱ� ��µǸ� �� �� ����ϰ� �ȴ�)
--���� ���� �׸��̴ϱ� ����� �� �ֵ��� �Ѵ�.
select name, city, dept from emp where dept='���ߺ�'
UNION ALL
select name, city, dept from emp where city='��õ'
order by city;

--MINUS: �μ��� ���ߺ��� ������� city�� ��õ�� �׸��� ��� �����Ѵ�.
select name, city, dept from emp where dept='���ߺ�'
MINUS
select name, city, dept from emp where city='��õ';

--MINUS: city�� ��õ�� �׸񿡼� �μ��� ���ߺ��� ����� ��� �����Ѵ�.
select name, city, dept from emp where city='��õ'
MINUS
select name, city, dept from emp where dept='���ߺ�';

--INTERSECT: �μ��� ���ߺ��� �׸�� ���ð� ��õ�� �׸��� ����� ��ġ�� ��츸
--����� �μ��� ���ߺ��̸鼭 ���ð� ��õ�� �׸��� ��ȸ
select name, city, dept from emp where dept='���ߺ�'
INTERSECT
select name, city, dept from emp where city='��õ';

--pseudo �÷�
--pseudo �̱��� [s?:dou]  ������ [sj?:-]  
--1. ������, ��¥��; ������
--2. �ٸ� ���̴� ���, ��Ī��
-- pseudo �÷��� �׸��� Ȱ���� �� ������ ����, ����, ������ �Ұ����ϴ�.
--ROWID: ���� Ʃ�ÿ� ���� ������ ID��
select empno, name from emp;
select rowid, empno, name from emp;
--ROWID���� AAB�� ���Ե� �ܾ �ִ��� ��ȸ�ϴ� ����
select rowid, empno, name from emp where rowid like '%AAB%';

-- �ڡڡڡڡ� ROWNUM
--�������� ��ȯ�� �� �࿡ ���� ROWNUM�� ���̺� �Ǵ� ���ε� �� ���տ��� ���� �����ϴ� ������ ��Ÿ���� ���ڸ� ��ȯ�� �ش�.
--��???
select rownum, empno, name, city, sal from emp;

select rownum, name, city, sal from emp
where rownum<=10;

--���� �������� ū ROWNUM ���� ���� �׽�Ʈ�� �׻� �����̴�.
select rownum, name, city, sal from emp
where rownum > 1; -- �ϳ��� �� ���´�.
--�и� ���ٴ� �ƴµ�...
--���� ���� ������ �������� �Ѵ�.
--1. from
--2. where�� �����͸� ������ ������ rownum�� ���ڸ� ���δ�.
--rownum�� 1�� Ʃ���� �������� �� ������ ���Ѵ� 1(rownum) >1 => ������ ��ȯ�Ѵ�.
--���� ������ ��ȯ�ϹǷ� �ᱣ���� ��ȯ���� �ʴ´�.
select rownum, name, city, sal from emp
where rownum = 10; -- �ϳ��� �� ���´�.
--rownum�� 1�� Ʃ���� �������� �� ������ ���ϸ� 1 = 10 => ������ ��ȯ�Ѵ�.
select rownum, name, city, sal from emp
where rownum = 1; -- �ϳ��� �� ���´�.
--rownum�� 1�� Ʃ���� �������� �� ������ ���ϸ� 1 = 1 => ���̹Ƿ� �� ���� �׸��� ��ȯ�Ѵ�.
--�ڵ��� rownum�� ����, ���ų� ���ٴ� ���������� (ũ��, ����) ��� �� �����Ѵ�. (��, 1=1�� ��)
--��oracle������ 11g���� ���Ͽ����� rownum�� �̿����� �ʰ��� ����¡�� �Ұ����ϴ�.

--23�� ���μ� ���� ����
select rownum, name, city, hireDate, sal
from emp
order by sal desc;

--���μ��� �Ϲ� ������ ��ȸ�߾ 23��°�� �ִ�
select rownum, empno, name from emp;

--rownum�� ���������� 1,2,3,4,5 ~ ... ���� �����ε� ������ �ع����� rownum�� ���������� �������� �ʴ´�.
--select ���� ������ �����ڸ� rownum�ű�� ���� ������ ���� ������ �����̴ϱ�... �翬�ϰ���!
--�׷��Ƿ� order by���� �ִ� ��� �ǵ��� ����� �ƴ� �� �����Ƿ� rownum�� ������� �ʴ´�
select rownum, name, city, hireDate, sal
from emp
where rownum<= 10
order by sal desc;

-- ������
-- order by ���� �ִ� ��쿡�� �ݵ�� subquery�� ����Ͽ� rownum�� ����ϸ� �ǵ��� ����(1,2,3...)��� ���´�
-- ��ȣ �ȿ� ���� select���� rownum�� ����ϸ� �ǵ����� ���� ������ ��Ÿ���� �� �� �ִ�.
-- order by ������ �̹� select���� ���� ����ǹǷ� rownum�� ī��Ʈ�� �Ű����ݾ�.
select ROWNUM as "�ǵ��� rownum", tb.* from (
    select ROWNUM as "�ǵ����� ���� ����", name, city, hireDate, sal
    from emp
    order by sal desc
) tb where rownum<=10;
--tb�� subquery�� ����(���̺� �ᱣ��) ������ �ǹ��Ѵ�.

--�Խ��� ����¡�� ������ ó��
--���������� �ᱣ���� 6~10���� �͵鸸 ����ϵ��� �ϰ��� �Ѵ�.
select rownum, tb.* from (
select  name, city, hireDate, sal
    from emp
    order by sal desc
) tb where rownum >=6 and rownum <=10;
--rownum >=6 ���� ������ ��ȯ�ǹǷ� �ϳ��� ��µ��� �ʴ´�.

--rownum�� 6~10�� (������, ����ȯ, �����, �̱���, �̻���) 
select  name, city, hireDate, sal
    from emp
    order by sal desc;

select * from (
    select ROWNUM rnum, name, city, hireDate, sal
    from emp
    order by sal desc
) where rnum >=6 and rnum <=10;
--����� �������� �ǵ����� ���� �ᱣ���� ���Դ�.
--ORDER BY�� ROWNUM�� ���� ������ ������ �� �ȴ�.

--sal �������� �����Ͽ� 6��°���� 10��°�� ���
--11g �������� �Խ��� ����¡ ó���� ����ϴ� ������

--SELECT ������� ����
--1. FROM
--2. WHERE
--)))))))))) GROUP BY, HAVING
--3. SELECT
--4. ORDER BY
--�ڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡڡ� �ϱ��ؾ� �� ������
select * from(
    select rownum rnum, tb.* from ( -- tb��� ��Ī�� �̿����� �������� name, city, sal�� �����ϸ� �ȴ�.
        select name, city, sal
        from emp
        order by sal desc
    ) tb where rownum <=10 --�ϴ� 1~10���� �����ͱ����� �����Ѵ�.
    --���� ������ ���� ���⼭�� rownum�� ��Ī�� ����ϸ� �� �ȴ�. (����)
) where rnum>=6; -- ������ �����Ͽ� �ʿ� ���� �κ��� 1~5��°�� �߶󳽴�.

-- �� ROWNUM��� �� ���ǻ���
-- 1.����� order by���� ������ rownum�� ����ϸ� �ǵ����� ���� �����̹Ƿ� ����ؼ��� �� �ȴ�.
-- 2.where������  rownum���� ũ�ٷ� (rownum > 1) ������ �ʴ´�.

--Oracle�� ����¡ó���� ���������� �������� �ʾƼ�(11g) ������ �ټ� ��������.