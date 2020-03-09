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

--LIKE ���ǽ�
-- name�� '��'���� �ڷ� �� empNo, name �÷� ����ϱ�
select empNo, name from emp where name like '��%';
select name, tel from emp where tel like '%3%'; --%3% (%: 0�� ���� �̻��̴ϱ� �յ� ������ �ʰ� 3�̶�� ���ڸ� ������... �̶�� ��)
select name, tel from emp where tel like '%3%' or tel like '%5%'; --%3% or %5% (3�̳� 5��� ���ڿ��� ���ԵǾ� �ֱ⸸ �ϸ� ��)
select name, rrn from emp where rrn like '_0%'; -- 80,90,00,... ���⿡�� �����ڸ��� 0�� ��°����ϵ���

--������ '��'�� ��� �̸� ���(������ ��� �� ��) 
select name, tel from emp where name between '��' and '��'; 
--select name, tel from emp where name between '��%' and '��%'; -- %�� like������ ��ȿ�ϹǷ� �ᱣ���� ������ ��ġ�� �ʴ´�.
select name, tel from emp where name >= '��' and name < '��';
select name, tel from emp where name > '��' and name < '��'; -- �̸��� ���� ���� '��'���� ���� �����ϱ� '>'�θ� �������־ �ȴ�.


--WITH �ݺ����� ������ �ܼ�ȭ(���ȭ)��ų �� ����ϴ� ����.
WITH tb AS (
                SELECT '����' name, '�츮_����' content  FROM dual
                UNION ALL -- �� ���� �ϳ��� ��ġ���� �ϴ� ������ ���� (�ؿ� �� select query���� �����ϱ� ���� �ᱣ���̶� ������� �Ѵ�)
                SELECT '������' name, '�ڹ�%������' content  FROM dual
                UNION ALL
                SELECT '�ٴٴ�' name, '�츮����' content  FROM dual
                UNION ALL
                SELECT '����' name, '�ȵ���̵�%�����' content  FROM dual
            ) 
SELECT * FROM  tb;

-- content�÷����� %���ڰ� ��� �ִ� �׸� �����ϱ�
--���� ���ڸ� �νĽ�Ű�� ����� �ٸ� ����� ����������, �ϴ� �� ������� ��������.
WITH tb AS (
                SELECT '����' name, '�츮_����' content  FROM dual
                UNION ALL -- �� ���� �ϳ��� ��ġ���� �ϴ� ������ ���� (�ؿ� �� select query���� �����ϱ� ���� �ᱣ���̶� ������� �Ѵ�)
                SELECT '������' name, '�ڹ�%������' content  FROM dual
                UNION ALL
                SELECT '�ٴٴ�' name, '�츮����' content  FROM dual
                UNION ALL
                SELECT '����' name, '�ȵ���̵�%�����' content  FROM dual
            ) 
SELECT * FROM  tb where content like '%#%%' ESCAPE '#'; -- �߰��� '%' �Ϲݹ��ڰ� �����ִ��� �˻�
--select * from tb where content like '%a%%' escape 'a';
--ESCAPE���ڴ� ���� ����(%, _)�� ���Ե� �����͸� �����ϱ� ���ؼ� Ȱ���ϴ� ���̴�.
--ESCPAPE�� ������ ���� �ڿ� ���� ���� ���ڸ� �Ϲ� ���ڷ� �ν��Ѵ�.
--ESCAPE���ڴ� # �̿ܿ� ������ �����ϴ�. ESCAPE �ڿ� ��õ� ���ڿ� ���� ���ڿ��� �Ϲݹ��ڿ��� �ν��ϵ��� �ϱ� �����̴�.
--%#%%���� # �ٷ� ���� %�� �Ϲ� ���ڷ� �ν��Ѵ�.

--NULL���� Ʃ�� ��ȸ�ϱ�
select null from dual; --�������̺��� ��ȸ�ϱ�
select '' from dual; --���ڿ��� ���̰� 0�� ������ ��ȸ�ϱ�
select 10+null from dual; -- �ڡڡڡڡ� null���� ��� ������ �����Ͽ��� �ᱣ���� null�� ���´�.
--JAVA������ ���ڿ��� ���̰� 0�� ���ڰ� ����������, oracle������ ���ڿ��� ���̰� 0�̸� null�� �����Ѵ�.
--���� �ݵ�� �������� �Է��� �ʿ��� �÷��� not null �������� null���� ���ƾ� �Ѵ�.
--emp���̺��� tel�� null�� �ڷ� �� name, tel �÷� ���
-- select name, tel from emp where tel = null; --�߸��� ����, ������ �߻����� ������ �ᱣ���� ��Ÿ���� �ʴ´�.
select name, tel from emp where tel is null; -- null�� �׽�Ʈ�� �� �ִ� ������ ���
--emp���̺��� tel�� null�� �ƴ� �ڷ� �� name, tel �÷� ���
select name, tel from emp where tel is not null;

--������ CASE ǥ����(Expressions)�� DECODE �Լ�
--�� ������ ���� ���� �Լ� �� �� �����н��� �ʿ��ϴ�.
select substr('seoul korea',7,3) from dual; --�ᱣ��: kor, (����Ŭ������ substr�� index�� 1���� �����Ѵ�) // JAVA�� �ٸ��� ����
--substr('seoul korea',7,3) -- k���� 3���� ���ڸ� �����ϱ� (JAVA�ʹ� ��뿡 ���̰� ����)
select substr('seoul korea',7) from dual; --�ᱣ�� korea (7��° ���ڿ����� ����ϱ�)
select '70'+'50' from dual; -- ���ڿ��� �����ϴ� JAVA�ʹ� �޸� ���ڷ� �ڵ����� ��ȯ�Ͽ� ����� �ᱣ���� ��µȴ�.
select 13/5 from dual; -- 13���� 5�� ���� �ᱣ���� 2.6 
select mod(13,5) from dual; -- ������������ �����Ƿ� �������� ���ϴ� �Լ��� ȣ���Ѵ�.

--�ֹε�Ϲ�ȣ�� �Ǻ��Ͽ� 90��� ���Ŀ� ����� �ڸ� ���̵��� ���
select name, rrn from emp where substr(rrn,1,2) >= 90; --����Ŭ������ ���ڿ��� ���ڷ� �ڵ����� ��ȯ�� �ش�. ��, 2000�⵵ ���� ����ڴ� ������ ����.
--1991~1995��� ����ڸ� ��ȸ
select name, rrn from emp where substr(rrn,1,2)>=90 and substr(rrn,1,2)<=95; 
-- �ֹε�Ϲ�ȣ�� �Ǻ��Ͽ� ���ڸ� ��ȸ�ϵ���
select name, rrn from emp where substr(rrn,8,1) = 1 or substr(rrn,8,1) = 3;
select name, rrn from emp where substr(rrn,8,1) in (1,3,5,7,9);
-- �ֹε�Ϲ�ȣ�� �Ǻ��Ͽ� ���ڸ� ��ȸ�ϵ���
select name, rrn from emp where substr(rrn,8,1) = 2 or substr(rrn,8,1)=4;
select name, rrn from emp where mod(substr(rrn,8,1),2)=0; --mod�� �̷� ���� Ȱ���� �� �ֱ���!

-- TIP: �ֹε�Ϲ�ȣ ���ڸ� ù ���� (M,W)
-- 1,2 (1900s)
-- 3,4 (2000s)
-- 5,6 (1900s �ܱ���)
-- 7,8 (2000s �ܱ���)
-- 9,0 (1800s)

--CASEǥ������ 255�������� ������ ����� �� �ִ�.
--����1: ������ CASE ǥ����
select name, rrn,
CASE substr(rrn,8,1)
when '1' then '����' -- when ������ Ȭ����ǥ�� ������ ������ ������ �߻��Ѵ�. (�ϰ������� ������ ���� CHAR�� �ʿ��ϴٰ� ����)
-- CASE ������ ���� �ڷ����� WHEN ������ ���� �ڷ����� ��ġ�ؾ� �Ѵ�.
when '2' then '����'
end as "����" -- LABEL�� �ֵ���ǥ�� ���δ�.
-- �ֹι�ȣ�� 1�� 2�� �ƴ� ��쿡 �ᱣ���� null�� ��ȯ�ȴ�.
from emp;
--������ ����
select name, rrn,
CASE mod(substr(rrn,8,1),2) --mod�� �ᱣ���� NUMBER�� ��ȯ�ȴ�.
when 1 then '����' -- �̹����� Ȭ����ǥ�� ������ �ʾҴ�. �ֳ��ϸ� mod�Լ��� ����Ͽ� ��ȯ�Ǵ� �ᱣ�� ������ NUMBER�̱� �����̴�.
-- CASE ������ ���� �ڷ����� WHEN ������ ���� �ڷ����� ��ġ�ؾ� �Ѵ�.
when 0 then '����'
end as gender -- LABEL�� �ֵ���ǥ�� ���δ�.
from emp;
-- �ֹι�ȣ�� � ���ڰ� ���� ����, ���� �� �� �ϳ��� �ᱣ���� ��ȯ�ϰ� �Ǿ� �ִ�.

--����2:  Simple Case Expression
select name, rrn,
CASE 
    when mod(substr(rrn,8,1),2)=1 then '����'
    when mod(substr(rrn,8,1),2)=0 then '����'
END AS gender
from emp;

--����1�� JAVA�� switch��ó�� �����ϰ� ���Ǵ� �����̰�
--����2�� when�� ������ �ٷ� if��ó�� ������ ���ϴ� ������ �´�. (else if���� ����)
--������ ����2�� ���� ����ϹǷ� ����2�� ����� ����� �ε��� �Ѵ�.
-- ����2�� ��) ������ ����� �� �ݾ״� ���� ���� ������ �޸��� �� ����Ѵ�.

select name, sal+bonus pay,
CASE
    --ũ�ٷ� �������Ƿ� ū ��ġ���� �����;� �Ѵ�.
    --�۴ٷ� ���Ͽ��ٸ� �翬�� ���� ��ġ���� �ö󰡾� �ùٸ� ���ǹ� ������ �ȴ�.
    when sal+bonus>=2500000 THEN (sal+bonus)*0.03
    when sal+bonus>=2000000 THEN (sal+bonus)*0.02
    else 0 --when���� ���ǿ��� �ɸ��� �ʴ� ��� ����� ���� else�� ����Ѵ�.
END AS tax
--�������� �ɷ����� ������ null���� ��ȯ�ȴٴ� �Ϳ� �����Ͽ� �������� �ۼ��Ѵ�.
--��, else�� ������ ������ �����̴�.
from emp;

---------------------------------------------------------------------
-- �غ�: only emp���̺�
--Q1. ������ bonus�� 10������ ���Ͽ� ���
--��� �÷�: name, rrn, sal, bonus, bonus�� ���ڴ� 10������ ���� ��, ���ڴ� �״�� ���

--CASEǥ���� 1��
select name, rrn, sal, bonus, 
CASE mod(substr(rrn,8,1),2)
    when 0 then bonus+100000
--    when 1 then bonus  --else ��� ����Ͽ��� �Ǵ� ����
    else bonus
END as "���� ���ʽ�"
from emp;
--CASEǥ���� 2��
select name, rrn, sal, bonus, 
CASE
    when mod(substr(rrn,8,1),2)=0 then bonus+100000
    else bonus
END as "���� ���ʽ�"
from emp;

--Q2. city�� �����̸鼭 '��'��(name)�� ���
--��� �÷�: name, city
select name, city 
from emp 
where city='����' and name like '��%';
--�Ǵ�
select name, city 
from emp 
where city='����' and substr(name,1,1)='��';

--Q3. city�� ����̸鼭 sal�� 200���� ������ ���ڸ� ���
--��� �÷�: name, city
select name, city, sal
from emp
where city='���' and mod(substr(rrn,8,1),2)=0 and sal<=2000000;

--Q4. ��������� 80���(80~89)�� ����� ���
--��� �÷�: name, rrn 
select name, rrn 
from emp
where substr(rrn,1,2) >= 80 and substr(rrn,1,2)<=89; --�ε� �ۼ��� �� �ִ�.
--�Ǵ�
select name, rrn
from emp
where substr(rrn,1,1) = '8';
--�Ǵ�
select name, rrn
from emp
where rrn like '8%';

--Q4-1. 10������ ���
select name, rrn
from emp
where rrn like '__10%';
--�Ǵ�
select name, rrn
from emp
where substr(rrn,3,2)=10;

--Q5. �����̸鼭 ¦������ �¾ ����� ���
--��� �÷�: name, rrn
select name, rrn
from emp
where mod(substr(rrn,8,1),2)=1 and mod(substr(rrn,3,2),2)=0;

--Q6. SAL�� 300�� �� �̻��̸� �󿩱��� 10����,
--SAL�� 250�� �� �̻��̸� �󿩱��� 5����,
--SAL�� 200�� �� �̻��̸� �󿩱��� 3����,
--�������� �󿩱��� �������� �ʴ´�.
--��� �÷�: name, sal, �󿩱�

select name, sal, 
CASE
    when SAL>=3000000 then 100000
    when SAL>=2500000 then 50000
    when SAL>=2000000 then 30000
    else 0
END AS "�󿩱�"
from emp;

--DECODE�Լ�
--DECODE�� �� �� �ִ� ��� ���� CASE�� �� �� �ִ�.
--�ۼ��ϱ⿡�� �������� case���ٴ� ������ ���� �ʴٴ� ���� �����Ѵ�.
--�ణ ������ ���׿����ڿ� ����ϳ�.. Ȥ�� ������ if�Լ� ����

select name, rrn, DECODE(substr(rrn,8,1),1,'����') --���ǿ� �����ϸ� '����' �������� ������ null���� ��ȯ�Ѵ�.
from emp;

select name, rrn, DECODE(substr(rrn,8,1),1,'����',2,'����') -- 1�̸� ����, 2�̸� ���ڸ� �ǰ� ������ 0, 3~9���� null
from emp; --�׷��� �� �����ʹ� �ֹε�Ϲ�ȣ ���ڸ� 1��° ���ڰ� 1,2�ۿ� �����Ƿ� null���� ������ �ʴ´�.

select name, rrn, DECODE(substr(rrn,8,1),1,'����',2,'����',3,'����',4,'����') -- 1,3�̸� ����, 2,4�̸� ���ڸ� �ǰ� ������ 0, 3~9���� null
from emp; -- DECODE������ �ε�ȣ�� ������� �ۼ��� �� �����Ƿ� �ۼ��ϱⰡ �����ϴ�.

select name, rrn, DECODE(substr(rrn,8,1),1,'����',2,'����','��Ÿ') -- ���ڸ� 1��°�� 1�̸� ����, 2�̸� ����, �������� ��Ÿ�� ��µȴ�
from emp; --���� ���� �ڵ尡 �ƴ�.

select name, rrn, DECODE(mod(substr(rrn,8,1),2),1,'����',0,'����') -- �������� 1�̸� ����, 0�̸� ���ڸ� ��ȯ�Ѵ�.
from emp; --������� �Ϸ��� ���ڸ� 1��° ���ڿ� ���� ��� ����� ���� ����Ͽ� �ۼ��Ͽ��� �Ѵ�.

