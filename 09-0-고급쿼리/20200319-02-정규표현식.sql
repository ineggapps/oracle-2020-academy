--�� ��� ����
-- reg���̺� ����
SELECT * FROM reg;
-- �� ���Խ�(Regular Expression) - �ֿ� �Լ�
--    1) REGEXP_LIKE(source_char, pattern [, match_parameter ] )
--          ������ ���Ե� ���ڿ��� ��ȯ�Ѵ�. like�� ������
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[�ѹ�]'); --'��'�̳� '��'��([�ѹ�])�� �����ϴ�(^) ���ڿ�
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'����$'); --�������� ������(����$) ���ڿ�
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$'); --com���� ������(com$) �ҹ��ڸ�
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$','i'); --com���� ������(com$)���ڿ��ε� ��ҹ��� ���
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim*'); --kim�� �����ϴ�(���� �����ϸ�)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim3?3'); --kim3 ���� �ƹ� ���� 1�� �׸��� �������ڴ� 3��
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[0-3]{2}'); -- kim ���� 0~3 �� �ƹ� ���ڳ� ���� 2���� �̻� �ݺ� 
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[2-3]{3,4}'); --kim ���� 2~3 �� �ƹ� ���ڳ� �ּ� 3���̻� �ִ� 4������ �ݺ�
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[^1]'); --kim ���� 1�̶�� ���ڰ� ���� �� �ȴ�. (���ȣ �� ^�� ����Ʈ�� ���� ������ ���� ���ڿ� ��ġ�Ѵٴ� ���� �ǹ�)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[^1]$'); --1�� ������ ������
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[��-�R]{1,10}$'); --�ѱ۷� �����ؼ� �ѱ۷� ��(1~10���ݺ�)
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[��-�R]{2,}$'); --�ѱ۷� �����ؼ� �ѱ۷� ��(�ּ� 2�� �ݺ�)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[0-9]'); --���ڰ� ���Ե� ���� ��ȯ
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[[:digit:]]'); --���ڰ� ���Ե� ���� ��ȯ
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'.*[[:digit:]].*'); --���ڰ� ���Ե� ���� ��ȯ
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'.[[:lower:]]'); --�̸��� �ҹ����� �͸� ��ȯ
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'[a-z|A-Z]'); --�ҹ���,�빮�� ��� ��ȯ(but �̸��� �빮�ڰ� ����)

--            SELECT * FROM reg WHERE REGEXP_LIKE(email,'((?!1).*)@'); --�ҹ���,�빮�� ��� ��ȯ(but �̸��� �빮�ڰ� ����)

--    2) REGEXP_REPLACE(source_char, pattern [, replace_string [, position [, occurrence[, match_parameter ] ] ] ])
--        SELECT REGEXP_REPLACE('����','����','�ٲ� ��') FROM dual;

        --����
        SELECT REGEXP_REPLACE('kim gil dong','(.*) (.*) (.*)','\2 \3 \1') FROM dual; --gil dong kim
        --���� ������ ������ ���� �ٲٱ�
        
        SELECT email FROM reg;
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\1') FROM reg; --@�������� idǥ�� 
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\2') FROM reg; --@�������� ������ ǥ��
        SELECT email, REGEXP_REPLACE(email, 'arirang', '�Ƹ���') FROM reg;
        SELECT REGEXP_REPLACE('2345dlkfjaslfd@#$@#3423#$@#�ڡ�$','[[:digit:]|[:punct:]]','') FROM dual;
        SELECT name, rrn, REGEXP_REPLACE(rrn,'[0-9|\-]','*',9) from emp;--�ֹε�Ϲ�ȣ ���ڸ� 2��°���� ������
        
--    3) REGEXP_INSTR (source_char, pattern [, position [, occurrence [, return_option [, match_parameter ] ] ] ] )
        --�������� ��ġ�� �˾Ƴ��� �Լ�
        SELECT email,REGEXP_INSTR(email, '[0-9]') FROM reg;

--    4) REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_parameter ] ] ] )
    --���Խ� ������ �˻��Ͽ� �κ� ���ڿ��� �����Ѵ�.
        SELECT REGEXP_SUBSTR('abcd > efg', '[^>]+',1,1)  /* '[^>]+' �� > �ձ����� �����Ѵٴ� �� ( +�� ���ָ� �� ���ھ� ���) */
        FROM DUAL; /* DUAL�� ����Ŭ������ Table�� ���Ƿ� ���� �����ϴ� */
    --��ó: https://hyunit.tistory.com/40 [���γ�Ʈ]
    
--    5) REGEXP_COUNT (source_char, pattern [, position [, match_param]])
        SELECT email, REGEXP_COUNT(email, 'a') FROM reg; --a�� ���Ե� ���ڿ��� ������ ��ȯ


