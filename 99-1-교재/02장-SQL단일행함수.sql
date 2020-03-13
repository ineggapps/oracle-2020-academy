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

--3.1 SYSDATE ���� �ý����� �ð�
select SYSDATE from dual;

--3.2 MONTHS_BETWEEN �� ��¥ ������ ���� ���� ����
--MONTHS_BETWEEN(A, B) �̸� A-B ������ �����Ѵ�. (�Ҽ������� ��ȯ�� �ش�)
select MONTHS_BETWEEN('20/03/12', '20/07/20') from dual;

--3.3 ADD_MONTHS(��¥, ���� ��)
select ADD_MONTHS('20/03/12', 4) from dual;

--3.4 NEXT_DAY(���س�¥,����)
--select SYSDATE, NEXT_DAY(sysdate,'MON') from dual;--������ �ü������...
select SYSDATE, NEXT_DAY(sysdate,1) from dual; --��� �ü�� ��� �ý���
--���ǻ���
--������ 3/12 ������ε� NEXT_DAY(SYSDATE,5)�� �����ϸ� ���� �� ������� ��ȯ�� �ش�.
select NEXT_DAY('20/03/12',5) from dual;

--3.5 LAST_DAY(��¥)
select SYSDATE, LAST_DAY(SYSDATE), LAST_DAY('20/03/12') from dual;

--3.6 ROUND(), TRUNC() ��¥���� ���̴� �Լ�
select SYSDATE, ROUND(SYSDATE, 'DAY'), TRUNC(SYSDATE, 'DAY') from dual;

--4. ����ȯ �Լ�

--4.1 ����� / ������ ����ȯ
select 2 + TO_NUMBER(2) from dual; --�����
select '2' + 2 from dual; --������ '2'�� ���� 2�� ��ȯ�� ���̴�.

--4.2 TO_CHAR (��¥���� ���ڷ�)
--YYYY
--RRRR
--YY
--YEAR (���� �̸� ��ü ������ ǥ��)
select TO_CHAR(SYSDATE, 'YEAR') from dual; --TWENTY TWENTY
-- MM ���� ���� 2�ڸ���
-- MON ���� 3����
-- MONTH ���� ���ϴ� �̸� ��ü ǥ��
select TO_CHAR(SYSDATE,'MM'), TO_CHAR(SYSDATE,'MON'), TO_CHAR(SYSDATE,'MONTH') from dual; -- 03, 3��, 3��
--DD ���� ���� 2�ڸ���
--DAY ���Ͽ� �ش��ϴ� ��Ī
--DDTH �� ��° ������ ǥ��
select TO_CHAR(SYSDATE,'DDTH') from dual; -- 3�� 12�� �������� 12TH
--HH24 24�ð� ǥ���
--HH 12�ð� ǥ���
--MI ��
--SS ��

--QUIZ1.
--Student ���̺��� birthday �÷��� ����Ͽ� ������ 1���� �л���birthday�� ���Ŀ� �°� ���?
select studno, name, TO_CHAR(birthday,'YY/MM/DD') from student;

--QUIZ2.
--emp���̺��� hiredate�÷��� ����Ͽ� �Ի����� 1,2,3���� ������� ����� �̸�, �Ի��� ���
select empno, ename, hiredate from emp 
where TO_CHAR(hiredate,'MM') in ('01','02','03');

--4.3 TO_CHAR �Լ�(���������� ���������� ��ȯ�ϱ�)
select empno, ename, sal, comm, TO_CHAR((sal*12)+comm,'999,999') salary from emp
where ename='ALLEN';

--4.4 TO_NUMBER �Լ� (���� ó�� ���� ���ڸ� ���ڷ� �ٲٱ�)
select TO_NUMBER('5') from dual;

--4.5 TO_DATE()
select TO_DATE('2014/05/31') from dual;

--5. �Ϲ��Լ�
--5.1 NVL(���, ġȯ��)
--NULL���� �ƴϸ� ��� �� �״�θ� ��ȯ�ϰ�, NULL�̸� ġȯ������ ������ ������ ��ü�Ͽ� ��ȯ�Ѵ�.
select ename, comm, NVL(comm,0), NVL(comm,100) from emp;

--5.2 NVL2(���, null�̾ƴѰ��, null�� ���)
select empno, ename, sal, comm, NVL2(comm, sal+comm, sal*0) "NVL2" from emp;

--5.3 DECODE(����,��,TRUE�ΰ��,FALSE�ΰ��)

SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering') "DNAME" from professor;
--101���� �ƴ� �������� null���� ��ȯ�ȴ�.

SELECT deptno, name, DECODE(deptno, 101, 'Computer Engineering', 'ETC') "DNAME" from professor;
--101���� �ƴ� �������� ETC���� ��ȯ�ȴ�

SELECT deptno, name, 
DECODE( deptno, 101, '�İ���', 102, '�ֹ̰�', 103, '�ҵ��', '��Ÿ') from professor;
--101�� => �İ���
--102�� => �ֹ̰�
--103�� => �ҵ��
--�ٸ� �а���ȣ => ��Ÿ

--DECODE QUIZ1.
--Student ���̺��� ����Ͽ� ��1����(deptno1)�� 101���� �а� �л����� �̸��� �ֹι�ȣ, ������ ����ϵ�
-- ������ �ֹι�ȣ �÷��� �̿��Ͽ� 7��° ���ڰ� 1�� ��� MAN 2�� ��쿡�� WOMAN�� ���
select name, jumin, DECODE(substr(jumin,7,1),1,'MAN',2,'WOMAN') gender from student;

--DECODE QUIZ2.
--Student ���̺��� ������(deptno1) 101���� �л����� �̸�, ����ó, ������ ���
--�� ������ȣ 02�� ����, 031�� ��⵵, 051�� �λ�, 052�� ���, 055�� �泲���� ���

select name, tel, 
DECODE(substr(tel,1,INSTR(tel,')')-1),
'02','����',
'031','��⵵',
'051','�λ�',
'052','���',
'055','�泲','��Ÿ') loc from student;

--5.4 CASE��
select name, tel,
CASE substr(tel,1,INSTR(tel,')')-1)
WHEN '02' THEN '����'



WHEN '031' THEN '��⵵'
WHEN '051' THEN '�λ�'
WHEN '052' THEN '���'
WHEN '055' THEN '�泲'
ELSE '��Ÿ' 
END loc from student;

--6. ���Խ�....( ���� �� ���)