--�� SQL �Լ�
-- �� �м� �Լ�(analytic functions) �� ������ �Լ�(window functions)
-- �Լ���() OVER()���� OVER(PARTITION�� ORDER BY)�� ����� �� ��������.
-- PARTITION�� �������� ������ ������ �����Ѵٴ� �ǹ��̰�
-- ORDER BY�� ������ ������ �����ϵ� ���� �������� �����ٴ� �ǹ��̴�.
--    �� ���� ���� �Լ�
--      1) RANK() OVER() �Լ�: WHERE������ ����� �� ����.
        --���� ���ǻ���: ������ ���� ������ ������ ���´�.
        --���� ����
        --100   1
        --100   1
        --90    3
        
        SELECT name, sal, RANK() OVER(ORDER BY sal desc) ���� from emp; -- sal �������� ����
        SELECT name, sal, RANK() OVER(ORDER BY sal) ���� from emp; --sal �������� ����
        
        SELECT name, sal, bonus, 
        RANK() OVER(ORDER BY sal desc, bonus desc) ���� from emp; -- sal, bonus �������� ����
        
        --�μ����� ����
        --�μ����� ������ �Ű�����. (�μ��� 1~n��)
        SELECT dept, name, sal, 
        RANK() OVER(PARTITION BY dept ORDER BY sal desc) ���� from emp;
        
        SELECT dept, name, sal, 
        RANK() OVER(ORDER BY sal DESC) ��ü,
        RANK() OVER(PARTITION BY dept ORDER BY sal desc) "�μ��� ����",
        RANK() OVER(PARTITION BY dept, pos ORDER BY sal desc) "�μ� �� ������ ����" from emp;
        
        --����1) �޿� ������ 1~10� ����ϱ�
        --1�ܰ�. �޿� ���� ����ϱ�
        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
        from emp;
	  
        --2�ܰ�. 1~10� ����ϱ�
        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
        from emp
        where ROWNUM <= 10; -- �����ڰ� �ִ� ��� �ǵ����� ���� ����� ���´�.
        
--        SELECT name, sal, RANK() OVER(ORDER BY sal DESC)
--        from emp
--        where RANK() OVER(ORDER BY sal DESC); -- WHERE���� RANK OVER�� �� ���µ� �����?
        
        SELECT * FROM (
            Select name, sal, RANK() OVER(ORDER BY sal DESC) ����
            from emp
        ) WHERE ���� <= 10; --��ø ���� ���.. �̷� �����ε� ����� �� �ֱ���!
        --��ø������ ��� �Ѵٴ� ���ٹ������� �¾Ҵµ� �̷��� ��� �Ѵٴ� �ͱ����� ������ ������.
        --��ø������ WHERE���� ���� ���ٹ��� ������
        --��ø������ FROM������ �� �� �ִٴ� ���� ����ϸ� ���� ��.
        
        --����2) �޿� ���� 10% ���: name, sal
        --1�ܰ�. �޿� ���
        select name, sal from emp;
        --2�ܰ�. �޿� ���� �� �ۼ�Ʈ���� ���
        set timing on;
        TIMING START;
        SELECT TB.*, round((����/(SELECT count(*) from emp))*100,2)||'%' "����(%)" FROM (
            select name, sal, RANK() OVER(ORDER BY sal DESC) ���� from emp
        ) TB WHERE ����/(SELECT count(*) from emp) <= 0.1; --�ۼ� ���
        TIMING STOP;

        set timing on;
        TIMING START;
        SELECT TB.*, round((����/(SELECT count(*) from emp))*100,2)||'%' "����(%)" FROM (
            select name, sal, RANK() OVER(ORDER BY sal DESC) ���� from emp
            ) TB WHERE ���� <= (SELECT COUNT(*) FROM emp) * 0.1; --������ ���
        --�������� ���� �ʾ����ϱ� �� ������ �����ڴ�!
        TIMING STOP;

        --�μ���(sal+bonus)�� ���� ���� �����?
        --1�ܰ�. �μ��� ���� ���
        SELECT name, dept, pos, sal, bonus,
		     RANK() OVER(PARTITION BY dept ORDER BY (sal+bonus) DESC) ����
        FROM emp;
        
        --2�ܰ�. �μ��� ������ 1���̸� ���� ���� ����̰ڳ�?
        SELECT dept, name, �Ǳ޿� FROM (
            SELECT 
                dept, name, sal+bonus �Ǳ޿�, 
                RANK() OVER(PARTITION BY dept ORDER BY sal+bonus DESC) ���� 
            from emp
        ) WHERE ����=1; --�ۼ� ���
        
        SELECT name, dept, pos, sal, bonus FROM (
	      SELECT name, dept, pos, sal, bonus,
		     RANK() OVER(PARTITION BY dept ORDER BY (sal+bonus) DESC) ����
		  FROM emp
         ) WHERE ����=1; --������ ���
        
        -- dept�� ���� �ο����� ���� ���� �μ��� �� �ο��� ���?
        -- 0�ܰ�. �� �μ��� �����ο��� ���ϱ�
         SELECT dept, COUNT(*) �����ο���
          FROM emp
          WHERE MOD(SUBSTR(rrn,8,1),2)=0
          GROUP BY dept;
                
        --1�ܰ�. �μ��� ���� �ο��� �� ���� ���
        SELECT dept, COUNT(*) �ο���,
	      RANK() OVER(ORDER BY COUNT(*) DESC) ����
	  FROM emp
	  WHERE MOD(SUBSTR(rrn,8,1),2)=0
	  GROUP BY dept;
      
        --2�ܰ�. ���� ���� �μ���� �ο����� ����ϱ�
        SELECT dept, �����ο��� FROM (
            SELECT dept, count(*) �����ο���,
            RANK() OVER(ORDER BY count(DECODE(mod(substr(rrn,8,1),2),0,999)) DESC) ����
            from emp group by dept
        ) WHERE ����=1; --�ۼ� ���
        
          SELECT dept, �ο��� FROM (
              SELECT dept, COUNT(*) �ο���,
                  RANK() OVER(ORDER BY COUNT(*) DESC) ����
              FROM emp
              WHERE MOD(SUBSTR(rrn,8,1),2)=0
              GROUP BY dept
          ) WHERE ����=1;-- ������ ���
          -- ������ ���ڸ� ���ϴµ� WHERE������ �̸� ���͸����ִ� ���� ����.            
                
--
--      2) DENSE_RANK() OVER() �Լ�
--      �����ڰ� ���Ծ ����� ���������� �Ű���
--      1��, 1��, 2��, 3�� ... (DESNSE_RANK)
--      1��, 1��, 3��, 4�� ... (RANK)
--      1��, 2��, 3��, 4�� ...(ROW_NUMBER)
        
        
--
--      3) ROW_NUMBER() OVER( ) �Լ�
        SELECT name, sal, 
        ROW_NUMBER() OVER(ORDER BY sal desc) ����
        from emp;

--
--     4) RANK() WITHIN GROUP() �Լ�
--      EX) SAL�� 300�����ε� �� ������?
        SELECT RANK(3000000) WITHIN GROUP(ORDER BY sal DESC) "�� ��?"
        from emp;
        
--  �� �����Լ��� �ƴ϶� �м��Լ��ӿ� �����Ѵ�.
--  COUNT() OVER() �� �Ϲ� �Լ��� �����Ͽ� ����� �� �ִٴ� �̾߱��̴�.
--    �� COUNT() OVER(), SUM() OVER(), AVG() OVER(), MAX() OVER(), MIN() OVER() �Լ�
--      1) COUNT() OVER() �Լ�
--        SELECT name, sal, COUNT(*) from emp;     --����...
          SELECT name, sal, (SELECT count(*) FROM emp) "�� �ο�" from emp; --SUBQUERY�� �̿��Ͽ� ����� ���� �־���.
         
         SELECT name, dept, sal, COUNT(*) OVER(ORDER BY empno) cnt  from emp; --���� ���ؼ������� �ο����� ���ɴٴ� �ǹ���
         --1 2 3 4 ������ ���...
         --EMPNO�� �����ȣ�̹Ƿ� �����ȣ�� ���� ���� �����ϱ� ������ ī�����ϴ� ��.
         
         SELECT name, dept, sal, COUNT(*) OVER(ORDER BY dept) cnt  from emp; 
         --1�ܰ�) DEPT�� �������� �����ϰ�
         --2�ܰ�) DEPT���� COUNT�� �����Ѵ�. (���� �μ��� �ο����� �����ϰ� ���� �μ� �ο����� �����ϸ鼭 ���)
         --���ǻ���: ORDER BY�� ����� ���
         -- �μ����� �ο����� �����ϴ� ���� ������ �����ȴٴ� �Ϳ� �����Ѵ�.
         --��, ���� �μ������� ��� ���� �ᱣ������ ����Ѵ�.
         --14, 14, 14, ..., 21, 21, ..., 37, 37, ...,  60.
         --SUM() OVER() �� �������� �Լ��鵵 ���������� �����׸�(ORDER BY ~)�� �������� �Ͽ� �������踦 �س�����.

        SELECT name, dept, sal,
        COUNT(*) OVER() cnt
        --���ǻ���: �������� �����Ƿ� ��ü �ο����� �ϰ������� ����� �ᱣ���� ��Ÿ����.
        from emp;

        SELECT name, dept, sal,
        COUNT(*) OVER(PARTITION BY dept) cnt
        --���ǻ���: PARTITION BY�� ����� ���
        -- ORDER BY ���� �׸񿡼� �������ѳ����� �Ͱ��� �ٸ��� 
        -- PARTITION BY�� dept���� ������ �� �ο����� ����Ѵ�. (���� �ƴ�)
        from emp;
        --���:
        
        SELECT name, dept, pos, sal,
        COUNT(*) OVER(PARTITION BY dept) cnt1,
        COUNT(*) OVER(PARTITION BY dept ORDER BY empno) cnt2
        --���ǻ���: PARTITION BY + ORDER BY �� ������ ���
        -- PARTITION BY: �μ����� �ο����� �����Ѵ�
        -- ORDER BY�� PARTITION BY���� ������ �׸� �ȿ����� �������Ѽ� ���� ���� ����Ѵ�.
        -- ORDER BY empno: �μ����� ����� �ϳ��� ī�����س�����. �μ��� �ٲ�� �ٽ� 1���� ī������ �����Ѵ�.
        from emp;

--      2) SUM() OVER() �Լ�
        
        SELECT name, dept, sal, SUM(sal) OVER() from emp; --�������� �� �޿��ݾ��� ���
        SELECT name, dept, sal, SUM(sal) OVER(ORDER BY empNo) from emp; --������� ���������� ������ �ݾ� ���
        --Ȱ�� ��) ��ſ�� ���� ��...
        SELECT name, dept, sal, SUM(sal) OVER(ORDER BY dept) from emp; -- �μ����� ���������� ������ �ݾ� ���
        --�μ��� ���� => �μ��� �ٲ�� ���� �μ����� �ݾ��� �������Ѽ� ��� �����

        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept) from emp; --�μ��� sal�� �հ� ��� (����X)
        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept ORDER BY empNo) from emp; 
        --�� �μ� �ȿ��� ������� ���������� ������ �ݾ� ���
--        SELECT name, dept, sal, pos, SUM(sal) OVER(PARTITION BY dept ORDER BY empNo) from emp; 
        SELECT name, dept, sal, SUM(sal) OVER(PARTITION BY dept ORDER BY sal) from emp;
        -- �� �μ� �ȿ��� ���޺��� ���������� ������ �ݾ� ���
        -- ��, ���� ������ ������ ���� ���޳��� ���� (135�� 2�� => ���� ���� ���� +270��) �̷� ������ �����Ͽ� ���

        --����1)
        -- �̸� �μ��� �μ� �޿�(sal) (�μ��ѱ޿��� ���� �����)
        SELECT name, dept, sal,  
        round((sal / SUM(sal) OVER(PARTITION BY dept))*100,2)||'%' "�μ� �� �޿��� ���� �����",
        SUM(sal) OVER(PARTITION BY dept) "�μ��� �� �޿�"
        from emp;r
        
        --����2)
        -- �μ���  ����  �ο���  �μ����������
        -- ���ߺ�   ����  5         50%
        -- ���ߺ�   ����  5         50%
        SELECT DISTINCT dept, 
        '����' ����, 
        count(DECODE(mod(substr(rrn,8,1),2),1,9999)) OVER(PARTITION BY dept) �ο���,
        round(count(DECODE(mod(substr(rrn,8,1),2),1,9999)) OVER(PARTITION BY dept) / count(*) OVER(PARTITION BY dept) * 100,2)||'%'����
        from emp
        UNION ALL
        SELECT DISTINCT dept, 
        '����' ����, 
        count(DECODE(mod(substr(rrn,8,1),2),0,9999)) OVER(PARTITION BY dept) �ο���,
        round(count(DECODE(mod(substr(rrn,8,1),2),0,9999)) OVER(PARTITION BY dept) / count(*) OVER(PARTITION BY dept) * 100,2)||'%'����
        from emp
        order by dept, ����; --�ۼ� ���
        
        --������ ���
        --1�ܰ�) �μ����� ����, ���� �����Ͽ� �ο��� ����
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����') ����, count(*) �ο��� 
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����');
        
        --2�ܰ�) �μ��� ���� �ο��� ǥ���ϱ�
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����') ����, count(*) �ο���,
            SUM(COUNT(*)) OVER(PARTITION BY dept) �μ��ο�
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����');
        
        --3�ܰ�) 
        SELECT dept,
            DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����') ����, 
            count(*) �ο���, 
            --count(*)�� �̹� group by���� �׷� �������� �������� ���� �� �ο��� �ǹ��Ѵ�.
            --GROUP BY���� �μ�, ������� ���������Ƿ� �μ� �� ������ ���Ͽ� ���� ���찪�� ���´�.
            --���� ���ߺ� ���ں� �ο�, ���ߺ� ���ں� �ο��� ī��Ʈ�Ǿ� ���´�.
            round(count(*)/SUM(COUNT(*)) OVER(PARTITION BY dept)*100)||'%' ����,
            SUM(COUNT(*)) OVER(PARTITION BY dept) �μ��ο�
            --�μ� �ο��� SUM() OVER()�Լ��� �̿��Ͽ� ���� �� �ִ�. 2���� ������ �����Ͽ� ������� ���� �� �ִ�.
        FROM EMP
        group by dept, DECODE(MOD(SUBSTR(RRN,8,1),2),0,'����','����'); --������ ���

--      3) AVG() OVER() �Լ�
        SELECT name, dept, sal, ROUND(AVG(sal) OVER()) from emp; -- ��ü ������ ������ ����� ���Ѵ�.
        SELECT name, dept, sal, sal-ROUND(AVG(sal) OVER()) ���� from emp; --��ü ���� ��տ��� �ڽ��� ����� ����.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(ORDER BY empno)) from emp;
        --�������� �ϳ��� �����Ͽ� SAL�� ��հ��� �ű��.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(ORDER BY dept)) from emp; 
        --�μ� ������ �� �μ��� �����Ͽ� SAL�� ��հ��� �ű��.
        SELECT name, dept, sal, ROUND(AVG(sal) OVER(PARTITION BY dept)) from emp; --�μ��� ��� ���ϱ�
                
--      4) MAX() OVER()�� MIN() OVER() �Լ�
        SELECT name, dept, sal, 
        MAX(sal) OVER() �ִ����, 
        MIN(sal) OVER() �ּҺ���
        from emp;
        
        SELECT name, dept, sal, 
        MAX(sal) OVER() - sal �ִ���ް�������, 
        sal - MIN(sal) OVER() �ּҺ��ް�������
        from emp;
        
        SELECT name, dept, sal, 
        MAX(sal) OVER(PARTITION BY dept) "�μ��� �ִ�",
        MIN(sal) OVER(PARTITION BY dept) "�μ��� �ּڰ�"
        from emp;
        
--    �� RATIO_TO_REPORT() OVER() �Լ� (11�������� ����)
-- ���� ��Ʈ�� �տ� ���� ���� ������ ���.
--      RATIO�� �̿����� �ʴ� ���
        SELECT dept, ROUND(COUNT(*)/(SELECT COUNT(*) FROM emp)*100)||'%' ���� 
        from emp 
        GROUP BY dept;
        
--      RATIO�� �̿��� ���
        SELECT dept, 
            ROUND(RATIO_TO_REPORT(COUNT(*)) OVER() * 100)||'%' ����
        FROM emp
        GROUP BY dept;

--    �� LISTAGG () WITHIN GROUP() �Լ�
--      �׷� �������� ������ �����Ѵ�.
        SELECT dept, LISTAGG(name, ',') WITHIN GROUP(ORDER BY empno) "�μ��� ���"
        from emp
        GROUP BY dept; -- �׷����� �Լ��̹Ƿ� GROUP BY�� �� �������� �Ѵ�.

--    �� LAG () OVER() �Լ���  LEAD() OVER()  �Լ�
        SELECT name, sal,
        LAG(sal, 1, 0) OVER(ORDER BY SAL DESC) lag,
        --LAG(���, �� ĭ �и� ���ΰ�, �ش� ��ġ�� �� ù �κ��̸� ������ �⺻��)
        LEAD(sal, 1, 0) OVER(ORDER BY SAL DESC) lead
        --LEAD(���, �� ĭ ���� ���� ������ ���ΰ�, �ش� ��ġ�� �� ���κ��̸� ������ �⺻��)
        from emp;

--    �� NTILE() OVER() �Լ�
        SELECT name, sal,
        NTILE(6) OVER(ORDER BY sal DESC) �׷� -- ��ü ������ N���� ORDER �������� �׷����� ������.
        from emp;
        
        SELECT v, NTILE(5) OVER(ORDER BY v) x from (
            SELECT LEVEL v from dual CONNECT BY LEVEL <= 17-- ���� �ش�Ǵ� ������ �ݺ���Ŵ
        );
        
        --17/5 = ��:3, ������:2
        --���������� �� �׷쿡 �ϳ��� ���������� �Ҵ��Ѵ�.
        
--    �� ������ ��(window clause)
--      - ����
--       { ROWS | RANGE }
--         { BETWEEN
--               { UNBOUNDED PRECEDING  | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } } 
--              AND
--              { UNBOUNDED FOLLOWING | CURRENT ROW | value_expr { PRECEDING | FOLLOWING } }
--         | { UNBOUNDED PRECEDING | CURRENT ROW | value_expr PRECEDING }
--        }

--
--    �� FIRST_VALUE() OVER
--      �����쿡�� ���ĵ� �� �߿��� ù ��° ���� ��ȯ�ϴ� �Լ�
        SELECT name, dept, sal,
        FIRST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC) from emp;
        --MAX() VALUE()�� ������ ȿ���� ����
        
        SELECT name, sal,
        FIRST_VALUE(sal) OVER(ORDER BY sal DESC) - sal ����
        from emp;
        
--
--    �� LAST_VALUE() OVER() �Լ�
--       - ��
--         -- LAST_VALUE �Լ��� ���������� �������� ������ ����Ʈ��
--            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW �� ����Ǿ�
--            �������� �����Ǿ� ���� �����Ƿ� ����ġ �ʴ� ����� ��� �ǹǷ� �ݵ�� ���������� �����ؾ� �Ѵ�.

        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER(PARTITION BY dept ORDER BY sal DESC) from emp;
        --MIN() VALUE()�� ������ ȿ���� ����.
        
        --���� �Ϳ��� ū ��
        SELECT name, dept, sal, LAST_VALUE(sal) OVER(ORDER BY sal) from emp ���������޿�;
        --���� �����ϸ鼭 ������������ ���ĵ� ������ �� ���� ������ ���� ��µȴ�. 
        
        --DB�� ��ϵ� ������ �� ��������
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER() from emp; --BUT �׻� �Ȱ��� ������ ������� ���� ����.
        --����Ŭ ������ ���� ���� �ٸ��� ��µ� �� �ִ�.
        --�����ϴ� ����� �������� �˰��� ���̰� ���� �� �ֱ� �����̴�.
        --���� ������ ���� �ް� ������ order by �������� ������ �����Ѵ�.
        
        --���ĵ� �� �� ���� ū ���� ��µȴ�
        -- �� ORDER BY�� ���� ������������ ���ĵǾ� ������ ���� ���� ū ���� �ȴ�.
        --���� ���ĵ� �� �� ���� ������ ���� �������� �ȴ�.
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER() from emp
        ORDER BY sal; 
        
        --OVER ���� ORDER BY�� ������ ���ĵ� ����� �������� ���� �������Ѱ��鼭 ������ ���� ���Ѵ�.
        --���� �ݾ��� �޶��� ������ ������ ���ĵ� ��� �� ������ ���� ��µȴ�. 
        SELECT name, dept, sal,
        LAST_VALUE(sal) OVER(ORDER BY sal) from emp
        ORDER BY sal; 
        
        --���� ������ ����� �Ȱ���.
        SELECT name, dept, sal,
        LAST_VALUE(sal) 
        OVER(ORDER BY sal 
        --UNBOUNDED PRECEDING: ù ��° �ο찡 ���� �������� ����
        --������ ù ��° �ο���� ���� �ο������ �����Ͽ� ��
        --���� ���� ��� �޶�������?
        RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW--�⺻ �ɼ��̶� �����Ͽ��� �ȴ�.
        ) ���
        from emp
        ORDER BY sal; 
   
        --���� ū ��
        SELECT name, dept, sal,
        LAST_VALUE(sal) 
        OVER(ORDER BY sal 
        --UNBOUNDED FOLLOWING: ���� ������ ������ �������� ����
        --������ ù ��° �ο���� �� ��° �ο�� �����Ͽ���. �׷��Ƿ� LAST_VALUE�� ���ؼ� ������ �ο��� ���� ��� ��������?
        RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) ���
        from emp
        ORDER BY sal; 
        
        
        
        
        