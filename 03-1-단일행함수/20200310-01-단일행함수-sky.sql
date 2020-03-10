--������ �Լ�

--���� �Լ� ����
--ABS (����) 
select abs(20), abs(-20) from dual;
--�ᱣ��: 20, 20

--SIGN (��ȣ, ����� 1 ������ -1)
select SIGN(20), SIGN(-20) from dual;
--�ᱣ�� 1, -1

--���������ϴ� ������ �� �� �����ϴ�
--MOD(n2, n1)
--REMAINDER(n2, n1)
select mod(13,5) from dual;
-- 3

--CEIL 
--(ũ�ų� ���� ���� ���� ���� ��ȯ)
select CEIL(20.5), CEIL(-20.5) from dual;
-- 21, -20

--��FLOOR
--�۰ų� ���� ���� ū ����
--�Ҽ��� ������ �� ���� ����ϴ� �Լ��̴�.
select FLOOR(20.5), FLOOR(-20.5) from dual;
-- 20, -21

--ROUND(�Ҽ��� �������� ���� �ڸ��� �ݿø�)
--ROUND(n [, integer])
select round(15.693,1) from dual;
--15.7 (�Ҽ��� �ڸ����� 1�ڸ��̹Ƿ� �Ҽ��� ��° �ڸ����� �ݿø��Ѵ�)
select round(15.693) from dual;
select round(15.693,0) from dual; -- 10^0-1= �Ҽ��� ù ° �ڸ�
--16 (�Ҽ��� ù° �ڸ����� �ݿø��Ͽ� ������ ����� �ش�)
select round(15.693,-1) from dual;
--20 (�����ڸ����� �ݿø�) 10^-(-1)-1 => 10^0 = �����ڸ�
select round(14.693,-1) from dual;
-- 10

--�� TRUNC �Ҽ��� ���� ����
--�׳� ���, ���� �����ϰ� �Ҽ����� �߶����
select TRUNC(33.99999), TRUNC(-33.999999) from dual;
--33, -33
select TRUNC(15.79), TRUNC(15.79,1), TRUNC(15.79,-1) from dual;
--15, 15.7, 10

--�� QUIZ
-- emp���̺��� 
-- name, sal, 5������ ����, 1������ ����, ��Ÿ�ݾ� ����Ͽ� ����ϱ�
select 
name, sal, 
trunc(sal/50000) as "5������ ����", 
trunc(mod(sal,50000)/10000) as "1������ ����",
mod(sal,10000) as "��Ÿ�ݾ�",
(trunc(sal/50000)*50000 + trunc(mod(sal,50000)/10000)*10000 + mod(sal,10000) ) as "�˻�"
from emp;

--��Ÿ ���� �Լ�
-- SIN(N), COS(N), TAN(N), EXP(N), POWER(N2,N1), SQRT(N), LOG(N2,N1), LN(N)


--���� �Լ�
--LOWER
select LOWER('KOREA 2020') from dual;
--korea 2020

--UPPER
select UPPER('korea 2020') from dual;
--KOREA 2020

--INITCAP
select INITCAP('korea seoul 2020') from dual;
--Korea Seoul 2020

--CHR
select chr(65) || chr(66) from dual;
--AB

--ASCII
select ASCII('KOREA 2020') from dual;
--75 (K���� ���) ù ���ڿ� ���� ���� ���´�

--ASCIISTR
select ASCIISTR('KOREA 2020') from dual;
--KOREA 2020
select ASCIISTR('�ѱ� 2020') from dual;
--\D55C\AD6D 2020 (�ѱ��� �����ڵ�� ��µȴ�)

--��SUBSTR
select substr('seoul korea',7,3) from dual; --kor
select substr('seoul korea',-5, 3) from dual; --kor
select substr('seoul korea',7) from dual; -- korea

--QUIZ1.
--��������� 78~82����� ���: name, sal, rrn
--��, sal ��������
select name, sal, rrn
from emp
where substr(rrn,1,2)>=78 and substr(rrn,1,2)<=82
order by sal desc;

select name, sal, rrn from emp
where substr(rrn,1,2) between 78 and 82
order by sal desc;

--QUIZ2.
--city�� ����, ���, ��õ�� ��� �� ���ڸ� ���
--name, city, rrn
select name, city, rrn from emp
where city in ('����','���','��õ') and mod(substr(rrn,8,1),2)=1;
--ORACLE������ �ڵ� ����ȯ�� �����Ѵ�.

--��üQUIZ2-1.
--(����¡ ����)
--city�� ����, ���, ��õ�� ����� city�� �������� �����ϰ�
--���� rownum�� 6~10�� ����� ���
select * from (
    select rownum rnum, tb.* from (
        select name, city, rrn
        from emp where city in('����','���','��õ') 
        order by city
    ) tb where rownum<=10
) where rnum>=6;

--LENGTH
select length('korea seoul') from dual; -- 11

--��INSTR
--string���� substring�� �˻��Ͽ� ���ڿ��� ��ġ�� ��ȯ, ������ 0�� ��ȯ�Ѵ�.
--LIKE���� ������ ����.
select INSTR('korea seoul','e') from dual;--4 (���� �߰ߵ� ������ 4 ��ȯ)
select INSTR('korea seoul','abc') from dual;--0 (�����ϱ� 0 ��ȯ)
select INSTR('korea seoul','e',7) from dual;--8 (7��° ���ں��� �˻�)
select INSTR('korea seoul','e',1,2) from dual;--8 (1��° ���ں��� �˻�, 2��° ��Ÿ�� ��ġ�� 8 ��ȯ)

--���� �达�� ����� �˻��ϴ� ��� (�̸��� ù ���ڴ� ������ �´ٴ� �� INSTR(�Լ�����...)=1)
select name, pos from emp where INSTR(name,'��',1)=1; -- INSTR�� �̿��� ���
select name, pos from emp where name LIKE '��%'; -- LIKE�� �̿��� ���

-- �̸�(�� ����)�� �̰� �ִ� ��� ��� ���
select name, pos from emp where INSTR(name,'��')>0; -- INSTR�� �̿��� ���
select name, pos from emp where name like '%��%'; --LIKE�� �̿��� ���

-- tel���� ���� ��ȣ(010, 011 ...)�� �����ϱ�
select name, tel from emp;
select name, tel, substr(tel,1,INSTR(tel,'-')-1) as "���񽺹�ȣ" from emp order by tel nulls last;

--��ü���� tel�� ���������ϰ� rownum�� 6~10�� �ᱣ���� ����ϱ�
select * from (
    select rownum rs, tb.* from (
        select name, tel
        from emp
        order by tel
    ) tb where rownum <=10
) where rs>=6;

--tel���� ���񽺹�ȣ, ����, ��ȣ�� �и��ϱ�
--(���� ���񽺹�ȣ, ����, ��ȣ�� �и��ϴ� ���� �ڹٿ��� �ϴ� ���� �� ȿ�����̴�.)
--���ǿ����� ����Ŭ���� �ִ��� ������ ��Ű�� �ʴ� ���� ����.
--��� �̷� ������ JAVA���� split�� ����ϸ� ���ѵ� oracle������ split�� ������ ����� ����.
--INSTR�� ������ ���� ����.
select name, tel, 
substr(tel,1,instr(tel,'-')-1) as "���񽺹�ȣ", 
substr(tel,instr(tel,'-')+1,instr(tel,'-',instr(tel,'-'))) as "����(ME)-���߿� �´��� �м��� ����", 
substr(tel,instr(tel,'-')+1,instr(tel,'-',1,2)-instr(tel,'-')-1) as "����(��)", 
substr(tel,instr(tel,'-',1,2)+1) as "��ȭ��ȣ"
from emp;
--�Խ��� �˻��� �� INSTR�Լ��� �̿��Ͽ� �˻��� �Ѵ�.

--LENGTH (���ڿ��� ����)
select LENGTH('korea'), LENGTH('���ѹα�') from dual; --5,4: �ѱ۵� ���̴� ���ڴ� 1�� ���ǳ�!
select LENGTHB('korea'), LENGTHB('���ѹα�') from dual; --5,12 (B: byte)
--byte���� 11g �̻󿡼� �ѱ��� 3byte�� ����Ѵ�. (UTF-8)

--REPLACE(char, search_string [, replacement_string]) ġȯ�ϱ�
select REPLACE('seoul korea','seoul','busan') from dual;
select REPLACE('seoul korea I seoul U', 'seoul','busan') from dual; -- ���� ���� seoul�� �ϰ������� ġȯ�ϴ±���!
select REPLACE('555123456789012345678901234567890555','5') from dual; --5 �����ϱ�

--��ȭ��ȣ�� ������ �����ϱ�
select name, tel, REPLACE(tel,'-') as "����������" from emp;

--�μ��� '��'�ڸ� �ϰ������� '��'���� �ٲ۴�
select name, dept, REPLACE(dept, '��','��') as "���� �߻��� �� ����" from emp;
--�μ��� �� ���� ������ �θ� ������ �����ϴ� ���
--select name, dept, substr(dept,1,2)||'��' as "�̷��� �ϴ� �͵� �ƴϾ�" from emp; -- �μ����� 2���ڰ� �ƴϸ� ��� �ǵ�?
select name, dept, substr(dept,1,length(dept)-1)||'��' as "��������" from emp; --�Լ��� �̿��Ͽ� ������ ���ڸ� ����.

--CONCAT(char1, char2) ���ڿ� ����
--concatenate (con��cat��e��nate) �̱��� [k?nk?t?n?it]  ������ [k?n-]  
--1. �罽���� �մ�; �����Ű��; <��� ����> ��ν�Ű��, ������Ű��
--2. �����, �̾���, �����
select CONCAT('����', '�ѱ�') from dual;
select '����'||'�ѱ�' from dual;

--LPAD, RPAD ���� ���� ä���
select LPAD('korea', 12, '*') from dual; --12 ���� �� 7���� ������ �������Ƿ� *�� 7�� ���ʿ� ä���
select RPAD('korea', 12, '*') from dual;-- 12 ���� �� 7���� ������ �������Ƿ� *�� 7�� �����ʿ� ä���.
select LPAD('korea', 3, '*') from dual;-- korea�� 5���ε� ������ 3�̸� korea �� 3���� kor�� ��µȴ�.
select RPAD('korea', 3, '*') from dual;-- korea�� 5���ε� ������ 3�̸� korea �� 3���� kor�� ��µȴ�.
select LPAD('*',0,'*') from dual; --null 0���ڴ� oracle���� null�� ����Ѵ�.
select RPAD('*',0,'*') from dual; --null 0���ڴ� oracle���� null�� ����Ѵ�.
--�ѱ��� �Է��� ���
select LPAD('����',6,'*') from dual; -- **���� LPAD������ �ѱ��� 2byte�� �����Ѵ�.
select RPAD('����',6,'*') from dual; -- ����** RPAD�� ���������� �ѱ��� 2byte�� �����Ѵ�.

--
-- name, rrn(���� �������ʹ� *�� ���)
select name,  RPAD(substr(rrn,1,8),length(rrn),'*') as "������ �ֹε�Ϲ�ȣ" from emp; -- length(rrn)==14
select name, substr(rrn,1,8)||'******' from emp; --�̷��� �ص� �ȴ�.

-- name, sal, �׷���(sal 100������ *�ϳ�)
select name, sal, LPAD('*',TRUNC(sal/1000000),'*') "�׷���", TRUNC(sal/1000000)||'��' as "�˻�" from emp;

-- LTRIM, RTRIM, TRIM
--��������
select '*'||LTRIM('          �츮����         ')||'*' from dual; -- ���� ���� ����
select '*'||RTRIM('          �츮����         ')||'*' from dual; --���� ���� ����
select '*'||TRIM('          �츮����         ')||'*' from dual; --�¿� ���� ����
select '*'||LTRIM('          -----�츮����-----         ', ' -')||'*' from dual; --���� �ִ� -�� ' '(����) ��� ���ŵ�

-- A[AB]BCCAA���� AB�� ã�� ����=> [AB]CCAA���� AB�� ã�� ���� => CCAA
select LTRIM('AABBCCAAB','AB') from dual; --���ʿ��� A�� B�� �����Ѵ�.
select LTRIM('AABBCCAAB','BA') from dual; --���ʿ��� A�� B�� �����Ѵ�.

select name, RTRIM(dept, '��') from emp; -- ������ ���� �� '��'�� �߶� �� ����.
select name, dept, substr(dept,1,length(dept)-1)||'��' as "��������" from emp;
select name, dept, RTRIM(dept,'��')||'��' as "��������" from emp; --�Լ����� ���� ����������.
-- �������: �μ����� ~~~���� �� ~~~~�κη� ������ '��'���ڰ� ��� ��������. (����)

--TRIM������ �� ���� �ҰŸ� �����ϸ� ������ �ణ ���̰� ����.
select TRIM('A' from 'AABBCCAA') from dual;
--  BBCC: �Ұ��� ���ڴ� �� ���ڸ� �����ϴ� ('A')
--�߰��� �ִ� ������ �����ϱ� ���ؼ��� REPLACE �Լ��� �̿��Ͽ� ���ָ� �ȴ�.

--TRANSLATE(expr, from_string, to_string) ���ڿ� ��ü (ġȯ)
select TRANSLATE('ABABCCC','C','D') from dual; --ABABDDD
--TRANSLATE:Returns the string provided as a first argument
-- after some characters specified in the second argument
-- are translated into a destination set of characters.
select REPLACE('ABABCCC','C','D') from dual; --ABABDDD
--REPLACE: Replaces all occurrences of a specified string value with another string value.

--2KWF45T���� 0123456789�� 0123456789��, ������(A~Z)�� null��
select TRANSLATE(
'2KWF45T',
'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
'0123456789') from dual;--245
--���� 1���� �����Ͽ� ����.

--2KWF45T
select TRANSLATE(
'2KWF45T',
'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ',
'9999999999XXXXXXXXXXXXXXXXXXXXXXXXXX') from dual;--9XXX99X
--�ǿ�: ���ڴ� ��� 9�� �ٲٰ� �����ڴ� ��� X�� �ٲٶ�� �ǹ�

-- REPLACE VS TRANSLATE
-- https://database.guide/sql-server-replace-vs-translate-what-are-the-differences/
SELECT 
    REPLACE('123', '321', '456') AS Replace, --123
    TRANSLATE('123', '321', '456') AS Translate from dual; --654

--WITH (�ݺ����� ������ ���� �� ����ϴ� ��)
--ESCAPE�� ������� �ʰ� �Ϲ� ���� % ��ȸ�ϴ� ��� (LIKE�� ������� ����)
            WITH tb AS (
                SELECT '����' name, '�츮_����' content  FROM dual
                UNION ALL
                SELECT '������' name, '�ڹ�%������' content  FROM dual
                UNION ALL
                SELECT '�ٴٴ�' name, '�츮����' content  FROM dual
                UNION ALL
                SELECT '����' name, '�ȵ���̵�%�����' content  FROM dual
            ) 
            SELECT * FROM  tb
--			WHERE content LIKE '%#%%' ESCAPE '#';
            WHERE INSTR(content,'%')>0;
            

-- ������ ��¥ �Լ�
-- EX: ���� ���� ��� ��
-- �ݵ�� �����Ͽ��� �� 2���� ����
-- �ڡڡڡڡ� DATE (�����Ͻú���) but �и��ʴ� ������ �� ����
-- �ڡڡڡڡ� TIMESTAMP Ÿ�ӽ������� �и��ʱ��� ������ �����ϴ�.

--��¥ ���� �ſ� ����! IN ORACLE
-- ��¥ + ����: ���� ��ŭ�� �� ���� ��¥�� ���� ��¥ ��ȯ
-- ��¥ - ����: ���� ��ŭ�� �� ���� ��¥�� �� ��¥ ��ȯ
-- ��¥ + ����/24: ���� ��ŭ�� �ð��� ��¥�� ���Ѵ�.
-- ��¥1 - ��¥2: ��¥1���� ��¥2�� �� �� ��¥ ������ �� ���� ��ȯ�Ѵ�.

--���� ��¥ ��ȸ�ϱ�
select SYSDATE from dual; --SqlDeveloper, SQLPlus������ �����ϸ� �������� JAVA������ �ú��ʱ��� ���´�.

--��¥�� ���ڷ� �ٲٱ�
select TO_CHAR(SYSDATE,'YYYY-MM-DD') from dual; --���Ŀ� �°� ��¥�� ��ȯ
select TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') from dual; -- �ú��ʱ��� ��Ÿ����

--���ڸ� ��¥�� ��ȯ�ϱ�
select TO_DATE('2000-10-10', 'YYYY-MM-DD') from dual;

-- 2020�� 2�� 25�Ͽ� OO�̰� ����ģ���� ������. 100�� �Ĵ� �� �� ��ĥ�ΰ�?
-- �س�¥�� ������ ���� �ݵ�� ��¥������ ��ȯ(TO_DATE �̿�)�Ͽ� ������ �����Ѵ�.
select TO_DATE('2020-02-25','YYYY-MM-DD')+100 from dual; --20/06/04

-- 1989�� 2�� 25���� ������ OO���� ��ƿ� �� ���� ���ϸ�?
select TRUNC(SYSDATE-TO_DATE('1989-02-25','YYYY-MM-DD')) ||'��' "��ĥ�� ��ҳ�?" from dual;

--INTERVAL Literals�� �̿��Ͽ� ��¥ �����ϱ�
select SYSDATE+(INTERVAL '1' YEAR) from dual;
select SYSDATE+(INTERVAL '1' MONTH) from dual;
select SYSDATE+(INTERVAL '1' DAY) from dual;
select SYSDATE+(INTERVAL '1' HOUR) from dual;

 