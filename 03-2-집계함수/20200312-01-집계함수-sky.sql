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
    --Sub Query
    --���������� select���� ����ϴ� ���� �ƴϴ�.
    --SELECT, FROM, WHERE�� ��� ���Ǵ� SUB QUERY�� �ܵ� ������ �����ϴ�.
    --SELECT ������ ����ϴ� ��� �ϳ��� �÷��� �� ���� ����� ����ϴ� ��쿡�� ����� �����ϴ�.
    --WHERE������ ���Ǵ� ��� �ϳ��� �÷��� �����ϸ�
    --      IN �������� ���� ���� ��µǾ ����������
    --      =,> ���� ���꿡���� �ϳ��� �ุ �����ϴ�.
    
    --�ִ� �޿���?
    select MAX(sal) from emp;
    --�ִ� �޿��� �޴� �����?
    select name, sal from emp
    where sal = (select max(sal) from emp);
    
--    where sal = (select max(sal),min(sal) from emp); -- ���������� �� ��, �� �÷��� �����ϴ�.
    
    
    --�޿��� ������� ���ϱ�    
    select name, 
    sal-(select round(avg(sal)) from emp) ������� 
    from emp
    order by ������� desc, name;
    
    select name, sal
    from emp
    where sal-(select round(avg(sal)) from emp)>=0
    order by sal desc;
    
    --[�μ� �ο���]�� [���� ���� �μ���� �ο���] ���
    --1. �μ��� �ο���
    select dept, count(dept) from emp group by dept;
    --2. ���� ���� �μ���� �ο���
    select dept, COUNT(*) from emp
    group by dept
    HAVING count(*) = (select max(count(*)) from emp group by dept);
    
    --�Ի�⵵�� �ο����� ���� ���� ���� �� �ο���
    
    --1. �Ի�⵵�� �ο���
    select TO_CHAR(hiredate,'YYYY') ����, count(*) �� from emp
    group by TO_CHAR(hiredate,'YYYY')
    order by �� desc;
    
    --2. �Ի�⵵ �� �ο����� ���� ����...
    select max(count(*)) from emp
    group by TO_CHAR(hiredate,'YYYY');
    
    select TO_CHAR(hiredate,'YYYY') ����, count(*) �� from emp
    group by TO_CHAR(hiredate,'YYYY')
    HAVING count(*) = (select max(count(*)) from emp group by TO_CHAR(hiredate,'YYYY'));
    
    --����1. name���� ������ �� �ڶ�� ���� �Ͽ� ������ �ο��� ���ϱ�
    --1�ܰ�. ��� ���� ��� ��� (�ߺ� ����)
    select distinct substr(name,1,1) from emp;
    --2�ܰ�. ������ �ο��� ���ϱ�
    select substr(name,1,1) ����, count(*) �ο��� from emp 
    group by substr(name,1,1)
    order by ����;
    
    --����2. sal+bonus�� ���� ū ����� �̸�, sal, bonus ���
    --1�ܰ�. sal+bonus�� ���� ū �ݾ� ���
    select max(sal+bonus) from emp;
    --2�ܰ�. ����
    select name, sal, bonus, sal+bonus from emp
    where sal+bonus = (select max(sal+bonus) from emp);
    
    --����3. ������ ������ ����� 2�� �̻��� ����� name, birth ��� (�ʰ���)
    --XXXXXXXXXXXXX ������ ������ ���Ҿ�� �ߴµ�...
    --1�ܰ�. ����� ������� ����ϱ�
    select substr(rrn,1,6) from emp;
    --2�ܰ�. ��������� ���� �ο��� �ִ��� �˻��ϱ� 840505 (2��) << �ϳ� ����
    select substr(rrn,1,6), count(*) from emp group by substr(rrn,1,6);
    --3�ܰ�. ��������� ������ ������� ����ϱ�
    select count(*) from emp group by substr(rrn,1,6) having count(*)>1;
    --4�ܰ�. ����
    select name, substr(rrn,1,6) ������� from emp
    where substr(rrn,1,6) in (select substr(rrn,1,6) from emp group by substr(rrn,1,6) having count(*)>1);
    
    --������ Ǯ��
    --1�ܰ�. ������ ���� ������� ��������� ����ϱ�
    select name, TO_DATE(SUBSTR(rrn,1,6)) birth from emp
    order by TO_CHAR(birth,'MMDD');
    --���ϸ�!! ���� ����� ���� ���� ȫ�泲=������,�� ������=������, �ǿ���=�̹̰� ���... ����
    --2. ��������� ���� �׸���� ������ ���� ��� 
    select substr(rrn,3,4) from emp 
    group by substr(rrn,3,4)
    having count(*) >1;
    --3. ����
    select name, TO_DATE(substr(rrn,1,6)) birth from emp
    where substr(rrn,3,4) in
    (
        select substr(rrn,3,4) from emp 
        group by substr(rrn,3,4)
        having count(*) >1
    )
    order by TO_CHAR(birth,'MMDD');

-- �� ROLLUP ���� CUBE ��
--    �� ROLLUP �� ��
--	   �Ұ� �� �Ѱ� ���
--	      ROLLUP(a, b)
--		    a�� b�� �Ұ� ==> group by a, b�� ���� ȿ��
--			a�� �Ұ� ==> a ī�װ� �ȿ� ��� ���� �ջ��� ������� (group by a�� ���� ȿ��)
--			��ü ===> �������� �� �� ��ü �ջ��� ����� ��µ�
--	        x, ROLLUP(a, b) : x�� ���� y(rollup(a,b))
--		    x�� ���� a�� ���� b�� ���� �Ұ�
--			x�� ���� a�� ���� �Ұ�
--			x�� ���� �Ұ�
--	        x, ROLLUP(a) => ROLLUP(a)�� a, ��ü �� 2���� ����� ���´�.
--		    x�� ���� a�� ���� �Ұ�
--			x�� ���� �Ұ�

       -- dept�� pos�� sal �Ұ�, dept���Ұ�, �������� �Ѱ� ���
        select dept, pos, sum(sal) from emp
        group by dept, pos --�μ���, �μ� �ȿ��� ������...
        order by dept;
        
        select dept, pos, sum(sal) from emp
        group by ROLLUP(dept, pos)
        order by dept;
        
        select pos, dept, sum(sal) from emp
        group by ROLLUP(pos, dept)
        order by pos;

       -- dept�� pos�� sal �Ұ�, dept�� �Ұ� ����ϸ� �������� �Ѱ�� ������� �ʴ´�.
        SELECT dept, pos, SUM(sal)
        FROM emp
		GROUP BY dept, ROLLUP(pos)
		ORDER BY dept;
        
        SELECT dept,  count(*)
        FROM emp
		GROUP BY dept;
        
        SELECT dept, count(*)
        FROM emp
		GROUP BY ROLLUP(dept);

--    �� CUBE �� ��
       -- dept�� pos�� sal �Ұ�, dept�� �Ұ�, pos�� �Ұ�, �������� �Ѱ� ���
        SELECT dept, pos, SUM(sal)
        FROM emp
		GROUP BY CUBE(dept, pos)
		ORDER BY dept, pos;
    
        SELECT city, dept, pos, SUM(sal)
        FROM emp
		GROUP BY CUBE(city, dept, pos)
		ORDER BY city, dept, pos;
    
        SELECT city, dept, pos, SUM(sal)
        FROM emp
		GROUP BY city, CUBE(dept, pos)
		ORDER BY city, dept, pos;
    
-- �� GROUPING �Լ��� GROUP_ID �Լ�
--    �� GROUPING �Լ�
        select dept, pos, GROUPING(dept), GROUPING(pos), sum(sal)
        from emp
        group by ROLLUP(dept, pos);
        
        select dept, pos, sum(sal)
        from emp
        group by ROLLUP(dept, pos)
        having GROUPING(pos)=1; 
    
        select dept, pos, GROUPING(dept), GROUPING(pos), sum(sal)
        from emp
        group by CUBE(dept, pos)
        order by dept, pos; 

        select empNo, name, sum(sal)
        from emp
        group by empNo, name;

        select dept, empNo, name, sum(sal)
        from emp
        group by ROLLUP(dept,(empNo, name)); -- (empNo, name)�� ROLLUP �ȿ� ��ȣ�� ������.
        -- ROLLUP�� ���� ��ȣ�� �ϳ��� ��ü�� �����ϰ� ROLLUP ������ �����Ѵ�.
        
--    �� GROUP_ID �Լ�

        -- ������ ���� ���� �����ϰ� �н�
        -- #1
        -- group by rollup(dept, empno)��
        -- group by dept, rollup(dept, empno)�� ���̸� ����
        -- #2 select dept, empno, name from emp group by rollup(dept,(empno,name));
        -- ���� SQL������ (empno, name)�� �ǹ̸� ����
        
        select dept, empno,  sum(sal) from emp group by rollup(dept, empno) --��ü �� ���� �ϳ��� �� ���Ѵ�.
        MINUS
        select dept, empno,  sum(sal) from emp group by dept, rollup(dept, empno)
        order by dept, empno;
        
        select dept, empno, name, GROUP_ID() ,sum(sal) from emp group by dept, rollup(dept, (empno, name))
        order by dept, empno;


        --Group by���� ������ Ƚ���� GROUP_ID �Լ��ι�ȯ���ִ� ���̴�.
        select dept, empNo, name, GROUP_ID(), sum(sal)
        from emp
        group by dept, ROLLUP(dept,(empNo, name))
        order by dept, empNo;

        --������ ����(1)�� Ȱ���Ͽ� �հ�� ����� ���ÿ� ���ؼ� ����� ���� �ִ�.
        select dept, empNo, GROUP_ID(), 
            decode(GROUP_ID(),0,NVL(name,'�հ�'),'���') name,
            decode(GROUP_ID(),0,sum(sal), ROUND(AVG(sal))) sal
        from emp
        group by dept, ROLLUP(dept,(empNo, name))
        order by dept, GROUP_ID(), empNo;

        SELECT dept, empNo, GROUP_ID(),
           DECODE(GROUP_ID(), 0, NVL(name, '�հ�'), '���') name,
           DECODE(GROUP_ID(), 0, SUM(sal), ROUND(AVG(sal))) sal
        FROM emp
        GROUP BY dept, ROLLUP(dept, (empNo, name))
        ORDER BY dept, GROUP_ID(), empNo;

-- �� GROUPING SETS (UNION ALL�� ����ϴ�)
    -- �ϳ��� ������ �� ����ϴ� ���� GROUPING SETS�̴�.
    
    --GROUPING SET ���� ��
    select dept, pos, null, round(AVG(sal)) ��� from emp GROUP BY dept, pos -- �μ��� ������ ���
    UNION ALL
    select null , pos, city, round(AVG(sal)) ��� from emp GROUP BY pos, city; -- ������ ���ú� ���
    
    --GROUPING SET ���� ��
    select dept, pos, city, round(AVG(sal)) ��� from emp 
    GROUP BY GROUPING SETS ((dept, pos), (pos,city));
    

