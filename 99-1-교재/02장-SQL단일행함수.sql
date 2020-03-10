--��2�� �������Լ��� ���ϴ�.

--1. ���� �Լ�
--INITCAP
--LOWER
--UPPER
--LENGTH
--LENGTHB
--CONCAT
--SUBSTR
--SUBSTRB
--INSTR
--INSTRB
--LPAD
--RPAD
--LTRIM
--RTRIM
--REPLACE
--REGEXP_REPLACE
--REGEXP_SUBSTR
--REGEXP_LIKE
--REGEXP_COUNT

--1.1 INITCAP �Լ�
select ename, INITCAP(ename) "INITCAP" from emp where deptno=10;
select INITCAP('hello world') from dual; --Hello World

--1.2 LOWER �Լ� (�ҹ���ȭ)
select LOWER('HELLO WORLD') from dual;

--1.3 UPPER �Լ� (�빮��ȭ)
select UPPER('hello world') from dual;

--1.4 LENGTH, LENGTHB �Լ�
select LENGTH('�ȳ��ϼ���') from dual;--5
select LENGTHB('�ȳ��ϼ���') from dual;--15 (�ѱ��� ���ڴ� 3����Ʈ�� ����Ѵ�)

--1.5 CONCAT �Լ� (���ڿ� ��ġ��)
select CONCAT(ename, job) from emp;
select ename||job from emp;

--1.6 SUBSTR �Լ�
select SUBSTR('abcde',3,2), --cd: abcde �� 3��° ���ں��� 2��
SUBSTR('abcde',-3,2), --cd: abcde �� �ڿ��� 3��° ���ں��� 2��
SUBSTR('abcde',-3,4) --cde: abcde �� �ڿ��� 3��° ���ں��� 4�� (�׷��� ���ڴ� 4���ڰ� �ƴ϶� 3���ڿ��� �����Ƿ� cde�� ��ȯ)
from dual;

--1.7 SUBSTRB �Լ�
select '������' "NAME", SUBSTR('������',1,2) "SUBSTR", SUBSTRB('������',1,3) "SUBSTRB" from dual;
--SUBSTRB�� byte�������� �����ϹǷ� �ѱ��� 3byte�� 1�����̴�. (11g�������� 3bytes)

--1.8 INSTR �Լ�
select 'A-B-C-D', INSTR('A-B-C-D', '-',1,3) from dual; --1��°(A)���� -�� 3��° ���� ��ġ�� 6 ��ȯ
select 'A-B-C-D', INSTR('A-B-C-D', '-',-1,3) from dual; -- -1��°(D)���� -�� 3��° ���� ��ġ�� 2 ��ȯ
select 'A-B-C-D', INSTR('A-B-C-D', '-',-6,2) from dual; -- -6��°(A���� -)���� -�� 2��° ���� ��ġ�� ���� 0 ��ȯ

--����
--������ȣ, ���� ����ϱ�
 WITH tb AS (
                SELECT '02)6255-9875' tel FROM dual
                UNION ALL
                SELECT '02)312-9838' tel FROM dual
                UNION ALL
                SELECT '053)736-4981' tel FROM dual
                UNION ALL
                SELECT '02)6175-3945' tel FROM dual
                UNION ALL
                SELECT '02)312-2238' tel FROM dual
                UNION ALL
                SELECT '031)345-5677' tel FROM dual
) 
SELECT tel, 
SUBSTR(tel, 1, INSTR(tel,')')-1) as "������ȣ",
SUBSTR(tel, INSTR(tel,')')+1, INSTR(tel,'-')-INSTR(tel,')')-1) as "����"
FROM  tb;

--1.9 LPAD �Լ�
--�� 10�ڸ��� ǥ���ϵ� ������ ������ �ڸ��� *���ڿ��� ���
select empno, LPAD(empno, 10, '*' ), ename, job from emp; -- ******0000 ������ ��µ� (empno�� 4�ڸ�)

--1.10 RPAD �Լ�
select RPAD(ename, 10, '-') from emp;

-- deptno�� 10���� ������� �̸��� �� 9�ڸ��� ����ϵ�
--������ �� �ڸ����� �ش� �ڸ����� �ش�Ǵ� ����(6789)�� ���
-- CLARK6789
-- KING56789
-- MILLER789
--select ename||RPAD('56789',9-length(ename),'56789') "RPAD"  from emp where deptno=10;
select ename from emp where deptno=10;

--1.11 LTRIM �Լ�
select ename from emp where deptno = 10;
select LTRIM(ename, 'C') from emp WHERE deptno = 10;

--1.12 RTIM �Լ�
select ename, RTRIM(ename, 'R') "RTRIM" from emp where deptno=10;

--1.13 REPLACE �Լ�
select ename, REPLACE(ename, SUBSTR(ename,1,2),'**') "REPLACE"
from emp
where deptno=10;

--REPLACE����1
--�Ҽӵ� �������� �̸��� 2~3����° ���ڸ� '-'�� ����
select ename, replace(ename, substr(ename,2,2), '--') from emp where deptno=20;

--2.1 ROUND �Լ�
-- �ݿø�
select round(987.654,2), --987.65
round(987.654,0), --988
round(987.654,-1) --990
from dual;

--2.2 TRUNC �Լ�
-- ����

--2.3 MOD, CEIL, FLOOR �Լ�
--MOD: ������
--CEIL:�־��� ���� �� ���� ����� ū ���� ���ϱ�(����, ����� �� ����)
--FLOOR:�־��� ���� �� ���� ����� ���� ���� ���ϱ�(����,����� �� ����)

--2.4 POWER �Լ�
select power(2,3) from dual; -- 2�� 3����
select power(2,-3) from dual; -- 2�� -3����

--3. ��¥ ���� �Լ�
--SYSDATE: �ý����� ���� ��¥�� �ð�
--MONTHS_BETWEEN: �� ��¥ ������ ���� ��
--ADD_MONTHS: �־��� ��¥�� ������ ����
--NEXT_DAY: �־��� ��¥�� �������� ���ƿ��� ��¥ ���
--LAST-DAY:�־��� ��¥�� ���� ���� ������ ��¥ ���

