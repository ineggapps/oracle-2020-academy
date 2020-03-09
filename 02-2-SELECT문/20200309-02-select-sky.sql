--DQL(�Ǵ� DML) �� SELECT��
--Ư�� �÷��� ���? (������ �÷��� ������� �ᱣ���� ��µ�)
--DB�� ���ǵ� �÷��� ������ �̶� �߿����� �ʴ�.
select * from emp; -- ��� �÷� �׸� ���� �����͸� ��ȸ 
select empNo, name, sal from emp; 
select name, empNo, sal from emp;
--������ ������������ ������ �߻��Ѵ�.
--ORA-00904: "NO" �������� �ĺ��� ������ �߻��Ѵ�.
--�������� �ʴ� �÷��� ��ȸ�� ��쿡 �߻��Ѵ�.
select no, name, sal from emp;  -- ORA-00904 ���� �߻�

--������ ����� ��
select empNo, name, sal+100000 from emp;
--||�� ���ڿ� ������ �ǹ��Ѵ�.
select name||'��', '�⺻�޿�: ' || sal from emp;

select 10+5 from emp; --���ڵ� ����ŭ ��µȴ�
select 10+5 from dual; --�ܼ��� ����� dual ���̺��� �̿��Ͽ� ����Ѵ�.
select '���: ' || (10+5) from dual; --������ �켱������ ����Ͽ� �ۼ��ؾ� �ϴ� �Ϳ� �����Ѵ�.

--��� �÷��� ����Ѵ�.(emp ���̺�: ��� �÷� ���)
select * from emp;
-- ��� �÷����� ����ϴ� ��쿡�� * ��ſ� ��� �÷����� ����Ѵ�.
-- ���� �ڵ��� ���� ���̺������ �̿��Ͽ� �÷����� ����Ͽ� ���α׷����� �Ѵ�
-- *�� �̿��ϸ� �÷����� � ���� �����ϴ��� �� �� ���� ��찡 �ִ�.
-- ���� *�� �̿��ϸ� ���̺��� ���� �� ����� �÷����� ������� �ᱣ���� �������Ƿ� �ǵ��� ������� �÷����� �����Ͽ� �������� ���� �ٶ����ϴ�.

--�÷����� �����Ͽ� ���(emp���̺�: empNo, name, sal �÷�)
select empNo, name, sal from emp;
--���α׷������� ����� �̸����θ� ������ �����ϴ�.
select empNo as "���", name as "�̸�", sal as "�⺻��" from emp;
--as�� ������ �����ϴ�.
select empNo ���, name �̸�, sal �⺻�� from emp;
select empNo, name ,sal, bonus, sal+bonus from emp;
select empNo, name ,sal, bonus, sal+bonus pay from emp;
select empNo, name ,sal, bonus, sal+bonus �� �� from emp; -- alias�� ����ǥ�� ������ ������ ������ �߻��Ѵ�. (������ �����ϱ�)
--��Ī�� ����� ����ŭ�� Ȭ����ǥ�� �ƴ� �ֵ���ǥ�� �̿��Ͽ� �����Ѵ�.
select empNo, name ,sal, bonus, sal+bonus "�� ��" from emp;
--�÷����� �ٲٴ� ������ ���α׷����� ������ ���ϰ� �ϱ� ������. (������ ����� ��� alias�� ����)
--������ ����� ��� ���α׷����� ������ �� �̸��� �������� ������ �����ϱⰡ ���ŷӱ� �����̴�.

--ROWNUM: ������ ����� ������ ������ ��鿡 ���� ���� ��
select ROWNUM, empNo, name from emp;
--astrik(*)�� ����� ���� �ٸ� �÷���� ȥ���Ͽ� ����� �� ����
select ROWNUM, * from emp; -- ORA-00936 ������ ǥ����
--emp�� �ִ� ��� ��(*)�̶�� ������־����Ƿ� ����� �� �ִ� �����̴�
select ROWNUM, emp.* from emp; -- ���� ���δ�.
--emp��� ���̺��� alias�� t��� �־����Ƿ� t.*�� �ٲپ�� ���������� �۵��Ѵ�.
select ROWNUM, t.* from emp t;

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

--------
--emp���̺��� city�� ������ �ڷ� �� name, city�÷��� ���
SELECT name, city  FROM emp WHERE city='����';
--emp���̺��� city�� ������ �ƴ� �ڷ� �� name, city �÷� ���
select name, city from emp where city<>'����'; --ISOǥ�� ǥ���
select name, city from emp where city!='����';
--emp���̺� �߿��� sal+bonus�� 2500000�� �̻��� �ڷ� �� name, sal, bonus �÷� ���
select name, sal, bonus from emp where sal+bonus>=2500000;
select name, sal, bonus, sal+bonus from emp where sal+bonus>=2500000; --�˻��

--�׷�� ������
--OR�� ����� �� �÷����� �ݵ�� ������־�� �Ѵ�. ������ ���� ����ϸ� ������ �߻��Ѵ�.
select empNo, name, city from emp where city = '����' or '���' or '��õ'; --���� �߻�
--OR�� ����� �� �÷����� �ٸ��� ������ ��
select empNo, name, city from emp where city = '����' or city = '���' or city = '��õ';
--any�� ����� ����
select empNo, name, city from emp where city=ANY('����','���','��õ');
--in�� ����� ����
select empNo, name, city from emp where city in ('����', '���', '��õ');
--emp���̺��� sal�� 2000000�� �̻��� �ڷ� �� empNo, name, sal �÷��� ���
select empNo, name, sal from emp where sal>=2000000;
--ANY�� OR����� �����ϴ�
select empNo, name, sal from emp where sal >= ANY(2000000, 2500000, 3000000);
--emp���̺��� sal�� 3000000�� �̻��� �ڷ� �� empNo, name, sal �÷��� ���
select empNo, name, sal from emp where sal>=3000000;
--ALL�� AND����� �����ϴ�
select empNo, name, sal from emp where sal >= ALL(2000000, 2500000, 3000000);

--��������
--emp���̺�: city�� �����̰� sal�� 2000000�� �̻��� �ڷ� �� empNo, name, city, sal �÷� ���
select empNo, name, city, sal from emp where city='����' and sal>=2000000;

--emp���̺��� city�� ����, ���, ��õ�� �ڷ� �� empNo, name, city, sal �÷��� ���
select empNo, name, city, sal from emp where city in ('����','���','��õ');
select empNo, name, city, sal from emp where city=ANY('����','���','��õ');
select empNo, name, city, sal from emp where city = '����' or city = '���' or city = '��õ';

--emp���̺��� sal���� 2000000~3000000�� ������ �ڷ� �� empNo, name, sal�÷��� ���
--not�� ������ ��쿡 ���� ���ؾ� �ϴ� ��찡 �����Ƿ� ���� ���� ����� ���� ����Ͽ� where���ǹ��� �ۼ��Ѵ�.
select empNo, name, city, sal from emp where not (sal>=2000000 and sal<=3000000);
select empNo, name, city, sal from emp where sal<2000000 or sal>3000000;

--BETWEEN���ǽ�
--emp���̺�: sal�� 2000000~3000000������ �ڷ� �� name, sal ���
select name, sal from emp where sal >= 2000000 AND sal <= 3000000; --�ε� ǥ���� �� ������
select name, sal from emp where sal between 2000000 and 3000000; --BETWEEN���� �� �� ���ϰ� ������ ǥ���� �� ����.
--BETWEEN�� �Լ��̹Ƿ� �����Ͱ� �þ�� ���ϰ� �ɸ��Ƿ� ���迬���ڿ� �������ڸ� ����ϴ� ���� �� ȿ�����̴�.
--emp���̺� sal�� 2000000~30000000�� ������ �ڷ� ��  name, sal�� ���
select name, sal from emp where sal <2000000 or sal>3000000;
select name, sal from emp where sal not between 2000000 and 3000000;

--emp���̺��� hireDate�� 2000�⵵�� �ڷ� �� name, sal �÷� ���
select name, hireDate from emp where hiredate between '2000-01-01' and '2000-12-31';
--(��ȭ) �Լ��� �̿��Ͽ� ������ ������ ���� �ִ�.
select name, hireDate from emp where EXTRACT(YEAR from hireDate) = 2000;

--�ڡڡڡڡ�IN���ǽ�
--emp���̺�: city�� ����, ��õ, ����� �ڷ� �� name, city���
select name, city from emp where city='����' or city='��õ' or city='���'; --�ε� ����� �� ������
select name, city from emp where city in ('����','��õ','���'); --in�� ����ϸ� �����ϰ� ���ǽ��� ������ �� �ִ�.
--emp���̺�: city�� ����, ��õ, ��⸦ ������ name, city ���
select name, city from emp where city not in ('����','��õ','���'); --in �տ� not�� ���� �� ����.
--emp���̺�: city�� pos�� �����̸鼭 �����̰ų�, �����̸鼭 ������ �ڷ� �� name, city. pos �÷�
select name, city, pos from emp where (city='����' and pos='����') or (city='����' and pos='����'); -- �ε� ������ ������ �� ������
select name city, pos from emp where city='����' and (pos='����' or pos='����'); --�ε� ������ �����ϴ�
select name, city, pos from emp where city in ('����') and pos in('����', '����'); --���� �����ϰ� ���ǽ��� ������ �� �ִ�.
select name, city, pos from emp where (city, pos) in (('����','����'), ('����','����')); --�ᱣ���� �̰͵� �����ϴ�
--emp���̺��� city�� pos�� �����̸鼭 ������ �ڷ� �� name, city, pos�÷� ��� (subquery)
select name, city, pos from emp where city='����' and pos='����'; --�ϴ�, �� ������� �н��� ��
select name, city, pos from emp where (city, pos) in (select '����', '����' from dual); -- (��ȭ) ��, �̷� �͵� �ֱ���!
select '����', '����' from dual;--(��ȭ)


