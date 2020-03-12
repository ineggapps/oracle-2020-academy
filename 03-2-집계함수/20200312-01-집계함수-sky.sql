--�� SQL �Լ�
-- GROUP BY�� ���ϰ� ���� �ɸ��� �����̹Ƿ� Ư���� ��Ȳ���� DB�����ڸ� ���

-- �� ���� �Լ�(Aggregate Function)�� GROUP BY ��
--    �� ���� �Լ�(Aggregate Function) ����
--- COUNT( * )
    select count(*) from emp; --��� �� �� ���ϱ� (*�� ��� null�� ī��Ʈ�Ѵ�)
--- COUNT( DISTINCT | ALL ] expr )
    select count(empno) from emp; -- (NULL�� count���� ���ܵ�)
    --�� empNo������ �⺻Ű�� NULL�� ������� �ʾ����Ƿ� ���� ��ü �� ���� ���� �ᱣ���� ��ȯ�ȴ�.
    select count(tel) from emp; -- (NULL�� count���� ���ܵ�)
    select count(nvl(tel,0)) from emp; -- 60���� ���ڵ� ��� ������
    
-- ��, Group by ���� ��޵��� ���� �÷��� �����Լ��� �Բ� ���� �� ����.
    select dept, COUNT(dept) from emp; -- ���� ����
    select dept, COUNT(dept) from emp group by dept; --group by�� ��޵� dept�� select������ ��� ����
    
   select sal from emp;
   select sal from emp where 1=2; -- 0
   select count(sal) from emp where 1=2; -- 0
   select avg(sal) from emp where 1=2; -- null
   select NVL(avg(sal),0) from emp where 1=2;
   
   select count(dept) from emp; -- 60
   select count(distinct dept) from emp; -- 7 (�μ��� ���� �ߺ� �����ϰ�)
    
   select count(dept) from emp where dept='���ߺ�'; --���ߺ� �Ҽ� ����� ��
   select count(*) from emp where mod(substr(rrn,8,1),2)=1; --���� ����� ��
   
   --��ü, ����, ���� ��� �� ���ϱ�
   select rrn, 
   decode(mod(substr(rrn,8,1),2),1,'Ʈ��') ����,
   decode(mod(substr(rrn,8,1),2),0,999999) ����
   from emp;
   
   select count(*) ��ü,
   COUNT(decode(mod(substr(rrn,8,1),2),1,1)) ����, -- ���ǿ� �������� ������ null�� ��ȯ��
   COUNT(decode(mod(substr(rrn,8,1),2),0,1)) ���� -- ���ǿ� �������� ������ null�� ��ȯ��
   from emp;
   
   --QUIZ1. ���� ��� ���� �ο� �� ���ϱ�
    select count(*) man from emp
    where city='����' and mod(substr(rrn,8,1),2)=1;
    
   -- QUIZ2. ������ ���� ���
   -- ���� �ǹ��̶�� ����Ŭ�� ������ �̿��Ͽ� ������ ���� ����� ���̴�
   -- �ϴ��� ��� ������ UNION ALL�� �̿��Ͽ� �ᱣ���� �ǵ��� ��� ����Ѵ�.
   -- ��ü 60
   -- ���� 31
   -- ���� 29
    select '��ü' ����, count(*) �ο� from emp
    UNION ALL
    select '����' ����, count(*) �ο� from emp where mod(substr(rrn,8,1),2)=1
    UNION ALL
    select '����' ����, count(*) �ο� from emp where mod(substr(rrn,8,1),2)=0;
    --��) ����Ŭ ����̸� X Ʃ�� ����ŭ ���
    select '����Ŭ', name from emp;
    
--- MAX([ DISTINCT | ALL ] expr
--- MIN([ DISTINCT | ALL ] expr)
    select max(sal), min(sal) from emp;
--- AVG([ DISTINCT | ALL ] expr)
--- SUM([ DISTINCT | ALL ] expr)
    select AVG(sal), SUM(sal) from emp;
    
    --QUIZ 3. ���ߺ� ��� �޿�(sal+bonus�� ���)
    select round(AVG(nvl(sal+bonus,0)),1) from emp where dept='���ߺ�';
    --������ ���� ���
    --����    �ִ�  �ּ�  ���
    --��ü    xxx   xxxx   xxxx
    --����    xxx   xxxx   xxxxx
    --����    xxx   xxxx  xxxxx
    
    select '��ü' ����, MAX(sal) �ִ�, MIN(sal) �ּ�, round(AVG(sal)) ��� from emp
    UNION ALL
    select '����' ����, MAX(sal) �ִ�, MIN(sal), round(AVG(sal)) ��� from emp
    where mod(substr(rrn,8,1),2)=1
    UNION ALL
    select '����' ����, MAX(sal) �ִ�, MIN(sal) �ּ�, round(AVG(sal)) ��� from emp
    where mod(substr(rrn,8,1),2)=0;
    
    --QUIZ 4. 
    --���� �Ի� �ο��� ���ϱ�
    -- ��ü   1��  2��  ... 12��
    -- xx     xxx   xxxx      xxx
    
    select count(*) ��ü, 
    count(decode(EXTRACT(MONTH from hireDate),1,1)) "1��",
    count(decode(EXTRACT(MONTH from hireDate),2,1)) "2��",
    count(decode(EXTRACT(MONTH from hireDate),3,1)) "3��",
    count(decode(EXTRACT(MONTH from hireDate),4,1)) "4��",
    count(decode(EXTRACT(MONTH from hireDate),5,1)) "5��",
    count(decode(EXTRACT(MONTH from hireDate),6,1)) "6��",
    count(decode(EXTRACT(MONTH from hireDate),7,1)) "7��",
    count(decode(EXTRACT(MONTH from hireDate),8,1)) "8��",
    count(decode(EXTRACT(MONTH from hireDate),9,1)) "9��",
    count(decode(EXTRACT(MONTH from hireDate),10,1)) "10��",
    count(decode(EXTRACT(MONTH from hireDate),11,1)) "11��",
    count(decode(TO_CHAR(hireDate,'MM'),'12',1)) "12��"
    from emp;
    
--- VARIANCE([ DISTINCT | ALL ] expr)
--- STDDEV([ DISTINCT | ALL ] expr)
    select VARIANCE(sal), STDDEV(bonus) from emp;
    
-- �� GROUP BY ���� HAVING ��
--    �� GROUP BY �� ��� ��
      -- dept�� pos�� �޿� ����			
    select SUM(sal) from emp; --���̺� �� ��� �޿��� �� ��
--    select dept SUM(sal) from emp; -- (����) group by�� ������� ���� �÷��� �����Լ��� ���� �� �� ����
    select SUM(sal) from emp GROUP BY dept;
    select dept, SUM(sal) from emp GROUP BY dept; --�μ��� �޿� ��
    select dept, SUM(sal) from emp GROUP BY dept order by dept;
    
-- SELECT�� ���� ���� ����(����)
-- 1. FROM
-- 2. WHERE
-- 3. GROUP BY
-- 4. HAVING
-- 5. SELECT
-- 6. ORDER BY

--    �� HAVING �� ��� ��
    select dept, COUNT(*) from emp
    GROUP BY dept;

    select dept, SUM(sal) from emp
    GROUP BY dept
    HAVING count(*) >= 10; -- GROUP BY ����� ����
    
    -- �μ� ������ �ο���
    -- ���ߺ�(����, ����, �븮, ���)
    -- ��ȹ��(�븮, ����, �븮, ���)
    select dept, pos, count(*) from emp
    group by dept, pos
    order by dept;
    -- ����(���ߺ�, ��ȹ��, ������ ...)
    -- ����(���ߺ�, ��ȹ��, ������ ...)
    select pos, dept, count(*) from emp
    group by pos, dept
    order by dept;
    
    --�μ��� ���� �ο����� ���. ���ڰ� ���� �μ��� ������� ����
    select dept, count(*) �ο��� -- where������ ������ ���������ϱ� ���� ���͸�(mod~~) �ʿ����
    from emp 
    where mod(substr(rrn,8,1),2)=0 -- ����� �����̹Ƿ� where������ �ɷ��ش�.
    group by dept;

     -- �μ��� �����ο��� ���. ���ڰ� ���� �μ��� 0���� ���    
    -- HINT: �μ� �ѹ���, ���ߺ�, ������, �����, ��ȹ��, ȫ����, �λ��(���� ����)
    select dept, 
    count(DECODE(mod(substr(rrn,8,1),2),0,9999)) "���� �ο���" from emp
    group by dept;
    
    select dept, 
    count(DECODE(mod(substr(rrn,8,1),2),0,9999)) "���� �ο���",
    count(DECODE(mod(substr(rrn,8,1),2),1,9999)) "���� �ο���"
    from emp
    group by dept;
    
    --�μ��� ���� ���� ���
    --���ߺ� ��  xxx  xxx
    --���ߺ� ��  xxx xxx
    -- ....
    
    select dept �μ���,
    decode(mod(substr(rrn,8,1),2),1,'��','��') ����,
    sum(sal) ����,
    round(avg(sal)) ���
    from emp
    group by dept, decode(mod(substr(rrn,8,1),2),1,'��','��')
    order by dept;
    
    --�μ��� ���� �ο����� 5���̻��� �μ��� ���
    select dept, count(*) �ο��� -- where������ ������ ���������ϱ� ���� ���͸�(mod~~) �ʿ����
    from emp 
    where mod(substr(rrn,8,1),2)=0 -- ����� �����̹Ƿ� where������ �ɷ��ش�.
    group by dept
    HAVING count(*)>=5; --having������ �����Լ� ����� �����ϴ�
    
    --������ ���� ���
    --�μ��� ��ü�ο��� �����ο��� �����ο���
    select dept �μ���, 
    count(*) "��ü �ο���",
    count(decode(mod(substr(rrn,8,1),2),1,1)) "���� �ο���",
    count(decode(mod(substr(rrn,8,1),2),0,1)) "���� �ο���"
    from emp
    group by dept;

    --city�� ���� ��� �� �μ��� ���ߺ��� �ο���
    select count(*) �ο���
    from emp
    where city='����' and dept='���ߺ�';
    
    --�μ� ������ �ο���
    -- �μ��� �������� �����ϰ� �μ��� ������ �ο��� ��������
    -- �μ��� ������ �ο���
    select dept �μ���, pos ������, count(*) �ο��� from emp
    group by dept, pos
--    order by dept, count(*) desc; --orderby������ count(*)�Լ��� ����� �� �ִ�.
    order by dept, �ο��� desc;
    
    --�Ի�⵵�� �ο���
    --���� �ο���
    select EXTRACT(YEAR from hiredate) ����, count(*) �ο��� from emp
    group by EXTRACT(YEAR from hiredate)
--    GROUP BY TO_CHAR(hiredate, 'YYYY')
    order by ����;

    select TO_CHAR(hiredate, 'YYYY') ����, count(*) �ο��� from emp
    GROUP BY TO_CHAR(hiredate, 'YYYY')
    order by ����;
    
    --���� �Ի����� �������� �ο��� ����
    select TO_CHAR(hiredate, 'MM') ����, count(*) �ο��� from emp
    GROUP BY TO_CHAR(hiredate, 'MM')
    order by ����;
    
    --CITY�� ���� ��� �� �μ��� ���ڿ� ���� �ο� ��
    --�μ��� �������� ����
    --�μ��� ���� �ο���
    select dept �μ���, decode(mod(substr(rrn,8,1),2),1,'����','����') ����, count(*) �ο���
    from emp
    where city='����'
    group by dept, DECODE(mod(substr(rrn,8,1),2),1,'����','����')
    order by dept;
 
    --�μ��� ���ڿ� ���� ���� ���
    --�μ��� ���ں��� ���ں���
    --���ߺ�   51%      49%
    --����: ������ �� �λ�δ� ���ڸ� ����
    select dept �μ���,
    round((count(DECODE(mod(substr(rrn,8,1),2),1,1))/count(*))*100)||'%' ���ں���,
    round((count(DECODE(mod(substr(rrn,8,1),2),0,1))/count(*))*100)||'%'  ���ں��� from emp
    group by dept;
    
    -- 83~87����� �ο���
    select count(*) "83~87����� �ο���" from emp
    where substr(rrn,1,2)>=83 and substr(rrn,1,2)<=87;
    
    ------------------------------------------------------
    --�� ���� ���� �̿� �ʿ�
    -- SELECT�� SELECT���� �� �� �ְ� WHERE������ �� �� �ִ�.
    --�ִ� �޿��� �޴� �����?
    select name, sal from emp
    where sal = (select max(sal) from emp);
    --�ּ� �޿��� �޴� �����?
    select name, sal from emp
    where sal = (select min(sal) from emp);
    
-- �� ROLLUP ���� CUBE ��
--    �� ROLLUP �� ��
       -- dept�� pos�� sal �Ұ�, dept���Ұ�, �������� �Ѱ� ���


       -- dept�� pos�� sal �Ұ�, dept�� �Ұ� ����ϸ� �������� �Ѱ�� ������� �ʴ´�.


--    �� CUBE �� ��
       -- dept�� pos�� sal �Ұ�, dept�� �Ұ�, pos�� �Ұ�, �������� �Ѱ� ���



-- �� GROUPING �Լ��� GROUP_ID �Լ�
--    �� GROUPING �Լ�


--    �� GROUP_ID �Լ�


-- �� GROUPING SETS

