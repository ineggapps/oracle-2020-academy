-- sal+bonus �� ����, ���, �ִ�, �ּҰ� ��� : emp ���̺�
    -- ����  ���  �ִ�  �ּ�
SELECT SUM(sal+bonus), ROUND(AVG(sal+bonus)), MAX(sal+bonus), MIN(sal+bonus)
FROM emp;


-- ��ŵ�(city)�� ���ڿ� ���� �ο��� ��� : emp ���̺�
    -- city   ����   �ο���
SELECT city, DECODE(MOD(SUBSTR(rrn,8,1),2),0,'����', '����') ����, COUNT(*) FROM emp
GROUP BY city, DECODE(MOD(SUBSTR(rrn,8,1),2),0,'����', '����')
ORDER BY city;


-- ��ŵ�(city)�� ���ڿ� ���� �ο��� ��� : emp ���̺�
    -- city   �����ο���  �����ο���
SELECT city,
    COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),1, 1)) ����,
    COUNT(DECODE(MOD(SUBSTR(rrn,8,1),2),0, 1)) ����
FROM emp
GROUP BY city
ORDER BY city;


-- �μ�(dept)�� ���� �ο����� 7�� �̻��� �μ���� �ο��� ��� : emp ���̺�
    -- dept  �ο���
SELECT dept, COUNT(*) �ο���
FROM emp
WHERE MOD(SUBSTR(rrn, 8, 1), 2) = 1
GROUP BY dept
HAVING COUNT(*) >= 7;


-- �μ�(dept)�� �ο����� �μ��� ������ �����λ���� �ο��� ��� : emp ���̺�
    -- dept  �ο��� M01  M02  M03 .... M12
SELECT dept, COUNT(*) �ο���,
    COUNT(DECODE(SUBSTR(rrn,3,2),1,1)) M01,
    COUNT(DECODE(SUBSTR(rrn,3,2),2,1)) M02,
    COUNT(DECODE(SUBSTR(rrn,3,2),3,1)) M03,
    COUNT(DECODE(SUBSTR(rrn,3,2),4,1)) M04,
    COUNT(DECODE(SUBSTR(rrn,3,2),5,1)) M05,
    COUNT(DECODE(SUBSTR(rrn,3,2),6,1)) M06,
    COUNT(DECODE(SUBSTR(rrn,3,2),7,1)) M07,
    COUNT(DECODE(SUBSTR(rrn,3,2),8,1)) M08,
    COUNT(DECODE(SUBSTR(rrn,3,2),9,1)) M09,
    COUNT(DECODE(SUBSTR(rrn,3,2),10,1)) M10,
    COUNT(DECODE(SUBSTR(rrn,3,2),11,1)) M11,
    COUNT(DECODE(SUBSTR(rrn,3,2),12,1)) M12
FROM emp
GROUP BY dept;


-- sal�� ���� ���� �޴� ����� name, sal ��� : emp ���̺�
    -- name   sal
SELECT name, sal FROM emp
WHERE sal = (SELECT MAX(sal) FROM emp);


-- ��ŵ�(city)�� ���� �ο����� ���� ���� ��ŵ� �� ���� �ο����� ��� : emp ���̺�
    -- city   �ο���
SELECT city, COUNT(*)  �ο���
FROM emp
WHERE MOD(SUBSTR(rrn, 8, 1), 2)=0
GROUP BY city;

SELECT city, COUNT(*)  �ο���
FROM emp
WHERE MOD(SUBSTR(rrn, 8, 1), 2)=0
GROUP BY city
HAVING COUNT(*) = (SELECT MAX(COUNT(*)) FROM emp WHERE MOD(SUBSTR(rrn, 8, 1), 2)=0 GROUP BY city );


-- �μ�(dept)�� �ο��� �� �μ��� �ο����� ��ü �ο����� �� %���� ��� : emp
    -- dept  �ο���  �����
SELECT dept, COUNT(*) �ο���, ROUND(COUNT(*)/(SELECT COUNT(*) FROM emp)*100) �����
FROM emp
GROUP BY dept;


-- �μ�(dept) ����(pos)�� �ο����� ����ϸ�, ���������� ������ ��ü �ο��� ��� : emp ���̺�
   -- ROLLUP�� ����ϸ�, �μ��� �������� ����
   -- ��� ��
dept       pos    �ο���
���ߺ�    ����    2
���ߺ�    ���    9
���ߺ�    ����    1
���ߺ�    �븮    2
��ȹ��    ���    2
     :
           ���    32
           ����    7
           ����    8
           �븮    13

SELECT dept, pos, COUNT(*) �ο���
FROM emp
GROUP BY pos, ROLLUP(dept)
ORDER BY dept;


-- �μ�(dept) ����(pos)�� �ο����� ��� : emp ���̺�
    -- ��� ��
dept       ����  ����  �븮  ���
�ѹ���    1       2      0      4
���ߺ�    1       2      2      9
            :

SELECT dept,
          COUNT(DECODE(pos, '����', 1)) ����,
          COUNT(DECODE(pos, '����', 1)) ����,
          COUNT(DECODE(pos, '�븮', 1)) �븮,
          COUNT(DECODE(pos, '���', 1)) ���
FROM emp
GROUP BY dept;


-- �μ�(dept) ����(pos)�� �ο����� ����ϰ� �������� ������ �ο��� ��� : emp ���̺�
    -- ��� ��
dept       ����  ����  �븮  ���
���ߺ�    1       2      2      9
��ȹ��    2       0      3      2
            :
            7        8     13     32

SELECT dept,
       COUNT(DECODE(pos, '����', 1)) ����,
       COUNT(DECODE(pos, '����', 1)) ����,
       COUNT(DECODE(pos, '�븮', 1)) �븮,
       COUNT(DECODE(pos, '���', 1)) ���
FROM emp GROUP BY dept
UNION ALL
SELECT null,
       COUNT(DECODE(pos, '����', 1)) ����,
       COUNT(DECODE(pos, '����', 1)) ����,
       COUNT(DECODE(pos, '�븮', 1)) �븮,
       COUNT(DECODE(pos, '���', 1)) ���
FROM emp
ORDER BY dept;

SELECT dept, SUM(����) ����, SUM(����) ����, SUM(�븮) �븮, SUM(���) ���  FROM (
    SELECT dept,
          COUNT(DECODE(pos, '����', 1)) ����,
          COUNT(DECODE(pos, '����', 1)) ����,
          COUNT(DECODE(pos, '�븮', 1)) �븮,
          COUNT(DECODE(pos, '���', 1)) ���
    FROM emp
    GROUP BY dept
) GROUP BY ROLLUP((dept, ����, ����, �븮, ���))
ORDER BY dept;

SELECT dept,
   COUNT(DECODE(pos, '����', 1)) ����,
   COUNT(DECODE(pos, '����', 1)) ����,
   COUNT(DECODE(pos, '�븮', 1)) �븮,
   COUNT(DECODE(pos, '���', 1)) ���
FROM emp
GROUP BY ROLLUP(dept, pos) HAVING GROUPING(pos)=1;