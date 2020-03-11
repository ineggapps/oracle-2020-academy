
-- ���� - 1��
--ex) ���θ����� ������ ���� ��Ȳ�� ��ȸ�� �� (������ where�� ����) 
select SYSDATE-1 from dual;

-- ���� - 1�ð�
select SYSDATE - (1/24) from dual;
select TO_CHAR(SYSDATE - (1/24),'YYYY-MM-DD HH24:MI:SS') from dual;

-- ���� - 10��
select TO_CHAR(SYSDATE - (1/24/60*10),'YYYY-MM-DD HH24:MI:SS') from dual;

-- ���ݿ����� (INTERVAL) 

-- ������ ������ �������� �ʴ´�.
--select SYSDATE + 365 from dual; -- ������ ���� 1���� 366���̴�. ���� �ܼ��� 365���� ���Ѵٰ� �ؼ� �ذ���� ����.

-- ����κ��� 3�� �Ĵ�?
select SYSDATE + (INTERVAL '3' YEAR) from dual;

-- ����κ��� 1���� �Ĵ�?
select SYSDATE + (INTERVAL '1' MONTH) from dual;

-- ����κ��� 2�ð� 10�� �Ĵ�?
select TO_CHAR(SYSDATE + (INTERVAL '02:10' HOUR TO MINUTE),'YYYY-MM-DD HH24:MI:SS') from dual;

-- ��¥�Լ�
-- SYSDATE = CURRENT_DATE
select SYSDATE ,CURRENT_DATE from dual;
select SYSTIMESTAMP from dual; --�и��ʱ��� ���ϴ� ���

--EXTRACT ��¥ �ð� �Ǵ� ���� ǥ���Ŀ��� ������ ��¥ �ð� �ʵ��� ���� �����Ͽ� ��ȯ
-- �ɼ�
-- YEAR | MONTH | DAY | HOUR | MINUTE | SEOND |
-- TIMEZONE_HOUR | TIMEZONE_MINUTE | TIMEZONE_REGION | TIMEZONE_ABBR
select EXTRACT(YEAR from sysdate) from dual;
select EXTRACT(MONTH from sysdate) from dual;

-- name, �Ի�⵵ ��� ���
select name, hireDate, EXTRACT(YEAR from hireDate)||'��' "�Ի�⵵" from emp;

--MONTHS_BETWEEN(date1, date2) �� ��¥ ������ ���� ��
--�ú��ʱ��� �����Ͽ� ����ϹǷ� �Ҽ����� ���´�.
select MONTHS_BETWEEN(SYSDATE, TO_DATE('1994-05-13')) from dual;
--�� ���� ���ϱ�
select TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE('1994-05-13'))/12)||'��' "��(ػ) ����" from dual;

--name, hireDate, �ٹ����
select name, hireDate, TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(hireDate))/12)||'�� �ٹ�' "�ٹ����" from emp;
--
--�ֹε�Ϲ�ȣ�� ������ ���� ���ϱ�
--STEP 1. ������� ���ϱ�
select name, rrn, TO_DATE(SUBSTR(rrn,1,6),'RRMMDD') birth from emp; --RR: 
-- https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:9536366100346454084
-- The RR datetime format element is similar to the YY datetime format element, 
-- but it provides additional flexibility for storing date values in other centuries.
-- The RR datetime format element lets you store 20th century dates in the 21st century
-- by specifying only the last two digits of the year

--STEP 2. �� ���� ���ϱ�
select name, rrn, TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'))/12)||'��' ���� from emp; --RR: 

-- ADD_MONTHS(date, integer) --date�� integer������ ���Ѵ�.
select ADD_MONTHS(SYSDATE,4) from dual;

--QUIZ 1.
--emp ���̺��� ȸ���� ������ �� 60���̴�.
--���� ���̰� 60�� �ʰ��ϸ� "�����ʰ�"
--���̰� 60�̸� "��������"
--�׷��� ������ "������� ���� ����� ����Ѵ�.
--name, rrn, �������, (��) ����, ���� �Ⱓ

-- �� CASE���� ����� �� ��� �ڷ����� �����ؾ� �Ѵ�.
-- �����ʰ�, �������⵵ �������̹Ƿ� else���� ���������� �������־�� �Ѵ�

select name, rrn, 
TO_DATE(SUBSTR(rrn,1,6),'RRMMDD') �������,  
TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'))/12)||'��' ����,
CASE 
WHEN 60-TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'))/12)<0 THEN '�����ʰ�'
WHEN 60-TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'))/12)=0 THEN '��������'
ELSE 60-TRUNC(MONTHS_BETWEEN(SYSDATE,TO_DATE(SUBSTR(rrn,1,6),'RRMMDD'))/12)||'�� ����'
END as "���� �����Ⱓ?"
from emp;

--WITH�� �̿��Ͽ� �ݺ��Ǵ� ���� ���̱�
WITH tb AS (
	   SELECT name, rrn,
	   TO_DATE(SUBSTR(rrn,1,6), 'RRMMDD') birth, 
       TRUNC(MONTHS_BETWEEN(SYSDATE, TO_DATE(SUBSTR(rrn,1,6), 'RRMMDD'))/12) ����
	   FROM emp
)
SELECT name, rrn, birth,
	   CASE 
	       WHEN ���� > 60 THEN '�ʰ�'
	       WHEN ���� = 60 THEN '����'
		   -- ELSE 60-���� || '�� ����'
           ELSE TO_CHAR(60-����, '99') --99�� ���� �ڸ����� �ǹ�
	   END �Ⱓ
FROM tb;

--ADD_MONTHS(date, integer) ��¥ date�� integer������ ���Ѵ�.

-- ���� + 1���� ��
select ADD_MONTHS(SYSDATE,1) from dual;

-- 2020�� 3�� 30��, 3�� 31�Ͽ� 6������ ���ϸ�? 
-- 3�� 31�� + 6������ 9�� 31���� �ƴ϶� 9�� 30�Ϸ� ��µȴ�.
-- 1������ ������ �� �޺� ������ ���缭 ����� �ش�.
select ADD_MONTHS(TO_DATE('20200330'),6), --20. 09. 30.
ADD_MONTHS(TO_DATE('20200331'),6), --20. 09. 30.
ADD_MONTHS(TO_DATE('20200330'),-1) --20. 02. 29.
from dual;

select TO_CHAR(ADD_MONTHS(SYSDATE,1),'YYYYMM') from dual; -- ���� ��
select TO_CHAR(ADD_MONTHS(SYSDATE,-1),'YYYYMM') from dual; -- ���� ��

--LAST_DAY(date)������  ��¥
select LAST_DAY(SYSDATE) from dual; -- ���� ���� ������ ��ȯ�Ѵ�.
select LAST_DAY(SYSDATE)-SYSDATE from dual; -- ���� ���� ��ĥ ���Ҵ���?
select LAST_DAY(TO_DATE('20200201')) from dual; -- 2020�� 2���� ������ ��ȯ�Ѵ�..

--ROUND(date[, fmt])
--fmt�� ������ ������ ��¥�� �ݿø��Ͽ� ��ȯ�Ѵ�.
--fmt���� YEAR, MONTH, DAY, DD, HH, HH24, MI ���� ����.
-- 7�� 1�Ϻ��� �ݿø��Ѵ�
select ROUND(TO_DATE('2007-07-10'), 'YEAR') from dual; -- 08/01/01 ������ 7������ �ݿø��Ѵ�
select ROUND(TO_DATE('2007-06-01'), 'YEAR') from dual; -- 07/01/01 ������ 7������ �ݿø��Ѵ�
select ROUND(TO_DATE('2007-07-15'), 'MONTH') from dual; --07/07/01 ���� 16�Ϻ��� �ݿø��Ѵ�
select ROUND(TO_DATE('2020-02-16'), 'MONTH') from dual; --20/03/01 ���� 16�Ϻ��� �ݿø��Ѵ�
select ROUND(TO_DATE('2020-03-12'), 'DAY') from dual; -- 20/03/15 �ָ� �������� ����� ��¥���� �ݿø��Ѵ� (������ �Ͽ���)

--TRUNC(date [, fmt]) �ݳ���
select TRUNC(TO_DATE('2007-07-10'), 'YEAR') from dual; -- 07/01/01
select TRUNC(TO_DATE('2007-06-01'), 'YEAR') from dual; -- 07/01/01
select TRUNC(TO_DATE('2007-07-15'), 'MONTH') from dual; --07/07/01
select TRUNC(TO_DATE('2020-02-16'), 'MONTH') from dual; --20/02/01
select TRUNC(TO_DATE('2020-03-12'), 'DAY') from dual; -- 20/03/08 ������ �Ͽ��� ��¥�̴�.

--NEXT_DAY(date, char) ���ƿ��� ~~��
-- �ѱ۷� ���ϸ��� ������ ���� ������ �ѱ� �ü�������� �����ϹǷ� �ǵ����̸� ���ڸ� �����Ͽ� ����ϵ��� �Ѵ�.
-- 1: �Ͽ��� ~ 7: �����
--"DATE��¥ ����"�� CHAR�� �̸��� ������ ù ��° ������ ��¥�� ��ȯ�Ѵ�.
select NEXT_DAY(SYSDATE, 1) from dual; -- 1: ���� ��¥ �������� ���ƿ��� �Ͽ���
select NEXT_DAY(SYSDATE, 6) from dual; -- 1: ���� ��¥ �������� ���ƿ��� �ݿ���
select NEXT_DAY(SYSDATE, '�ݿ���') from dual; -- 1: ���� ��¥ �������� ���ƿ��� �ݿ���

--�ְ�����ǥ �ۼ��� ���� ������ �ۼ�
--����, �̹��� �Ͽ���(���ƿ���X), �̹��� �����
select SYSDATE,
    CASE
        WHEN TO_CHAR(SYSDATE, 'D')=1 THEN SYSDATE
        ELSE NEXT_DAY(SYSDATE, 1)-7
    END "�� ����",
    CASE
        WHEN TO_CHAR(SYSDATE, 'D')=7 THEN SYSDATE
        ELSE NEXT_DAY(SYSDATE,7)
    END "�� ������" 
from dual;

-- ������ ��ȯ�Լ� (Conversion Functions)
-- ��ȯ �Լ��� Ư�� ������ Ÿ���� �پ��� �������� ����ϰ� ���� ��쿡 ���Ǵ� �Լ��̴�.
-- 1. ����� ������ ���� ��ȯ
-- ��ȯ �Լ�(TO_DATE, TO_CHAR ��)�� �̿��Ͽ� ������ ������ ��ȯ�ϵ��� ����� ���
-- 2. �Ͻ��� ������ ���� ��ȯ
-- ����Ŭ���� �ڵ����� ���� ��ȯ
-- VARCHAR2, CHAR �� NUMBER
-- VARCHAR2, CHAR �� DATE 
-- NUMBER �� VARCHAR2 
-- DATE �� VARCHAR2
-- EX)
select 30+'30' from dual; -- 60: �캯�� '30'�� ����30���� �ٲپ� ���� ������ �����Ѵ�. VARCHAR2 �� NUMBER
--select 30+'1,000' from dual; -- error: ���ڿ����� �߰��� ���� ���� �ٸ� ����(,)�� ���յǸ� ������ �߻��Ѵ�
select 30 || '��'from dual; -- 30�� �ڵ����� ���ڿ��� �ٲ��. NUMBER �� VARCHAR2

--�ü�� ������ ������ ���� �ڵ����� ����Ŭ�� ���ԵǴ� ����
--��ȭ ��ȣ, ��¥ ���� ��� ���� Ȯ��
select parameter, value from NLS_SESSION_PARAMETERS; 
--���� ���� ����
alter session set NLS_LANGUAGE = 'KOREAN';
-- ��ȭ��ȣ ���� (\)
alter session set NLS_CURRENCY='\';
--��¥ ��� ���� ����
alter session set NLS_DATE_LANGUAGE='KOREAN';
--��¥ ��� ���� ���� (default: RR/MM/DD)
alter session NLS_DATE_FORMAT='YYYY-MM-DD';

--��ȯ �Լ� ���� �� (Format Model)
--������ �� ���� �����ϴ� �Ͱ� �����ϳ�!
select 
TO_CHAR(12345,'99,999'), -- 12,345
TO_CHAR(12345,'9,9999'), --1,2345
TO_CHAR(12345,'9,999'), -- ##### ���� �����Ͱ� ������ �ڸ����� �ʰ��ϸ� #���� ��µȴ�
TO_CHAR(12345,'0,999,999') -- 0,012,345 ���� �����ͺ��� ������ ������ 0���� ä���.
from dual;

select 
TO_CHAR(12.67,'99'), -- 13 ���� �����ͺ��� �ڸ����� �����ϸ� (�Ҽ����� ���� ����) �ݿø��� �ᱣ���� ��Ÿ����.
TO_CHAR(12.67,'99.9'), --12.7  ���� �����ͺ��� �ڸ����� �����ϸ� (�Ҽ����� ���� ����) �ݿø��� �ᱣ���� ��Ÿ����.
TO_CHAR(0.03,'99.9'), -- .0
TO_CHAR(0.03,'90.9'), -- 0.0
from dual;

select
TO_CHAR(36,'90.9'), --36.0
TO_CHAR(36,'90.0'), --36.0
TO_CHAR(0,'99') -- 0
from dual;

select -1234 from dual; -- -1234

select TO_CHAR(1234,'9999MI') from dual; -- 1234: ����� �״�� ���
select TO_CHAR(-1234,'9999MI') from dual; -- 1234-: ��ȣ�� �������� ����.
select TO_CHAR(1234,'9999PR') from dual; --1234: ����� �״�� ���
select TO_CHAR(-1234,'9999PR') from dual; --<1234>: ������ <> ���μ� ���� ���
select TO_CHAR(1234.345,'9.999EEEE') from dual; --1.234E+03 ������ ǥ��
select TO_CHAR(1234,'9999V9999') from dual; --12340000
select TO_CHAR(12345,'L999,999') from dual; --\12,345: ��ȭ ��ȣ�� ����Ŭ ������ ���� �ٸ�. �ڸ��� �ʰ��ϸ� #######... ���
select TO_CHAR(12345,'999,999')||'��' from dual; --\12,345: �ڸ��� �ʰ��ϸ� #######... ���

select name, sal from emp;
select name, TO_CHAR(sal, 'L9,999,999') SALARY from emp;

--update emp set rrn='000707-457812' where empNO='1014';
--update emp set rrn='010210-311111' where empNo='1021';
--select rrn from emp where substr(rrn,1,1) = 0;
--commit;

-- Date Format
-- YY�� �ý��� ���� ������ �����Ͽ� ǥ���Ѵ�.
-- ����: 2020�⵵ ���ؿ����� �ᱣ����.
select TO_DATE('001010','YYMMDD') from dual; -- 00/10/10
select TO_CHAR(TO_DATE('001010','YYMMDD'),'YYYY-MM-DD') from dual; --2000-10-10
select TO_CHAR(TO_DATE('901010','YYMMDD'),'YYYY-MM-DD') from dual; --2090-10-10
-- RR�� ���� ����� ���� ���⸦ ���� ǥ���� �� ����Ѵ�.
-- ���� ������ 0~49���̿� ������?
-- -- ǥ�� ������ 0~49�̸� ���� ���� ����
-- -- ǥ�� ������ 50~99�̸� ���� ���� ����
-- ���� ������ 50~99 ���̿� ������?
-- -- ǥ�� ������ 0~49�̸� ���� ���� ����
-- -- ǥ�� ������ 50~99�̸� ���� ���⸦ ����
select TO_DATE('001010','RRMMDD') from dual; -- 00/10/10
select TO_CHAR(TO_DATE('001010','RRMMDD'),'YYYY-MM-DD') from dual; --2000-10-10
select TO_CHAR(TO_DATE('901010','RRMMDD'),'YYYY-MM-DD') from dual; --1990-10-10
-- ���ǻ���: �ǵ����� �ʰ� 1945�� �ƴ϶� 2045�� ��Ÿ�� �� ����.
select TO_CHAR(TO_DATE('451010','RRMMDD'),'YYYY-MM-DD') from dual; --2045-10-10

select name, hireDate from emp;
select name, TO_CHAR(hireDate,'YYYY-MM-DD') hireDate from emp;

select SYSDATE from dual;
--���ϱ��� ��� ���(DAY/DY/D)
select TO_CHAR(SYSDATE, 'YYYY-MM-DD DAY DY D HH24:MI:SS') from dual; -- DAY DY D ������ �� 4
select TO_CHAR(SYSDATE, 'YYYY"��"MM"��"DD"��"') from dual; -- LABEL ���ڴ� ""�� �����ش�.
select TO_CHAR(SYSDATE, 'DD "of" MONTH') from dual; --11 of 3��

--2000�⿡ �Ի��� ���
select name, hireDate from emp where TO_CHAR(hireDate,'YYYY')=2000;

--TO_NUMBER(expr [DEFAULT return_value ON CONVERSION ERROR] [, fmt [, 'nlsparam'] ])

select '23'+12, TO_NUMBER('23')+12 from dual; -- 35 35
select '23,123'+12 from dual; --���� �߻� (, ������)
select TO_NUMBER('23,123','99,999')+12 from dual; --23135
select REPLACE('23,123',',')+12 from dual; --23135: ���� TO_NUMBER������ REPLACE�� ���� ȿ�� 

--TO_DATE(char [ DEFAULT return_value ON CONVERSION ERROR] [, fmt[, 'nlsparam'] ] )

select TO_DATE('01-7��-20','DD-MON-RR') from dual; --��¥ ������ ���Ƿ� �����ϴ� ��쿡 ����Ѵ�.
select TO_DATE('2020-10-10') from dual; --20/10/10 ��¥ �������� ����� ��ȯ�Ǿ���. (������ ������ �ѱ��� �±� ������ ����)
select TO_DATE('10-10-2020') from dual; --����
select TO_DATE('10-10-2020','MM-DD-YYYY') from dual; --20/10/10 ������ ��¥ ���Ŀ� �°� ����� ��ȯ�Ǿ���.

select TO_DATE('980808') from dual;
select TO_CHAR(TO_DATE('980808'),'YYYY-MM-DD') from dual; --1998/08/08
select TO_DATE('980808','RRMMDD') from dual;
select TO_CHAR(TO_DATE('980808','RRMMDD'),'YYYY-MM-DD') from dual; --1998/08/08

--�ֹε�Ϲ�ȣ ���ڸ��� �̿��Ͽ� ��¥ �������� ��ȯ�ϴ� ���
select name, rrn, TO_DATE(SUBSTR(rrn,1,6)) birth from emp;
select name, rrn, TO_DATE(SUBSTR(rrn,1,6),'RRMMDD') birth from emp;
-- �� �̷��� ���� ȯ�� �ÿ��� �ݵ�� �����ؼ� ������ �����ؾ� �Ѵ�.
-- RR: ��, ���� ������ 2020���� ��� 48���� 2048������ �ν��Ѵ�.
-- YY: YY�� ��� ���� ������ 2020���� ��쿡�� 90���� 2090������ �ν��Ѵ�.
select name, rrn, TO_CHAR(TO_DATE(SUBSTR(rrn,1,6)),'YYYY-MM-DD') birth from emp;

--���� �����ϱ�
select TO_CHAR(SYSDATE, 'MON DD DAY') from dual;--3�� 11 ������
--����� ���� �������� ���� �����ϱ�
select TO_CHAR(SYSDATE, 'MON DD DAY', -- MAR 1 WEDNESDAY
'NLS_DATE_LANGUAGE = American')
from dual;

--TO_TIMESTAMP
select TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.FF4') from dual;--�и��ʱ��� ���� FF4 �и���
select TO_TIMESTAMP(TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS')) from dual; --���� �ð��� Ÿ�ӽ������� ��ȯ


--�� ����Ŭ�� ��¥�Լ��� �ſ� ����������
--�ٸ� �Լ����� ��ȯ �۾��� ���� ���ϰ� ���ϹǷ� 
--�ǵ����̸� ������� �ʴ� ���� ����.
--���� ���Ǹ� ���� ����� �� ���� ������ ���������� �� ��.


