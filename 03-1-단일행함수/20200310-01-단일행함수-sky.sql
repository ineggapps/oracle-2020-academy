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
select substr('korea seoul',7,1) from dual; --s
select substr('korea seoul',7) from dual; -- seoul

--LENGTH
select length('korea seoul') from dual; -- 11
