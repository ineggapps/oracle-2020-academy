CREATE TABLE roomReservation
(
     reservationNum  NUMBER PRIMARY KEY
     ,roomNum        NUMBER  NOT NULL
     ,checkIn        VARCHAR2(8) NOT NULL
     ,checkOut        VARCHAR2(8) NOT NULL
);

CREATE SEQUENCE roomReservation_seq;

INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 1, '20200722', '20200725');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 2, '20200721', '20200724');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 3, '20200727', '20200801');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 1, '20200727', '20200730');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 5, '20200726', '20200729');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 8, '20200724', '20200726');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 9, '20200723', '20200726');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 8, '20200727', '20200728');
INSERT INTO roomReservation(reservationNum, roomNum, checkIn, checkOut) VALUES
       (roomReservation_seq.NEXTVAL, 10, '20200729', '20200730');

COMMIT;

SELECT reservationNum, roomNum, checkIn, checkOut FROM roomReservation
ORDER BY checkIn ASC;

--�� ��� 1,2,3,5,8,9,10
SELECT distinct roomNum from roomReservation
order by roomNum;


--���� ������ ���
SELECT * FROM roomreservation;

--������ �Ұ����� ����� ���� 4�����̴�.
SELECT * FROM roomreservation
WHERE(
    TO_DATE(checkIn) >= TO_DATE('20200724') AND
    TO_DATE(checkout) < TO_DATE('20200729') --CHECKOUT �� �� üũ���� �� �� �����Ƿ� ������ ���Խ��Ѽ� �� ��( <=�� �ƴ϶� <)
) 
OR ( 
    TO_DATE(checkIn) <= TO_DATE('20200724') AND --7�� 24���� �����Ͽ� �� �����̰�
    TO_DATE(checkout) >= TO_DATE('20200724') --7�� 24���� �����Ͽ� �� ������ ���
)
OR (    
    TO_DATE(checkout) > TO_DATE('20200724') AND --üũ�ƿ��� 7�� 24��~29�� ����
    TO_DATE(checkout) < TO_DATE('20200729') 
)
OR ( 
    TO_DATE(checkIn) >= TO_DATE('20200724') AND
    TO_DATE(checkIn) < TO_DATE('20200729') --üũ���� 7�� 24��~29�� ����
)
ORDER BY checkIn asc;
---

-- 20200724 ~ 20200729 ���� �� ���� ��� ���. 0729�� checkOut �Ǹ� 0729�� checkIn ����
--�ڡ�
WITH tb as (
    SELECT 
        TO_DATE('20200724') üũ��, 
        TO_DATE('20200729') üũ�ƿ� 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --����1. ���� üũ���ϴ� ��¥�� ���� üũ���ϴ� ��¥�� ������ �Ұ���
                    üũ�� = TO_DATE(checkin) OR
                    --����2. ���� üũ���ϴ� ��¥�� ���� üũ�ƿ� �ϴ� ��¥���� �����̸� �Ұ���
                    üũ�� < TO_DATE(checkout) 
                THEN '�Ұ�'
                ELSE '����'
            END ����,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) �����ϼ�,
            TO_DATE(checkout) - (üũ�ƿ�) "���� üũ�ƿ���- ���� üũ�ƿ���",
            (üũ��)  - TO_DATE(checkout) "���� üũ���� �� ���� üũ�ƿ� �ϴ� ��¥���� ����", --���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������
            (üũ�ƿ�) - TO_DATE(checkin) "���� üũ�ƿ� �� �� ���� üũ�� �ϴ� ��¥���� ����"--���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������.
FROM roomreservation, tb
WHERE --üũ�ƿ��� üũ�� ��¥�� ���� üũ���ϰ� �ƿ��ϴ� ��¥ ���ֿ� ��ġ���� ���͸�
         (üũ��)  - TO_DATE(checkout) <= 0 AND
         (üũ�ƿ�) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;
--��
-- 20200727 ~ 20200728 ���� �� ��. (5, 1, 3, 8)
--�ڡ�
WITH tb as (
    SELECT 
        TO_DATE('20200727') üũ��, 
        TO_DATE('20200728') üũ�ƿ� 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --����1. ���� üũ���ϴ� ��¥�� ���� üũ���ϴ� ��¥�� ������ �Ұ���
                    üũ�� = TO_DATE(checkin) OR
                    --����2. ���� üũ���ϴ� ��¥�� ���� üũ�ƿ� �ϴ� ��¥���� �����̸� �Ұ���
                    üũ�� < TO_DATE(checkout) 
                THEN '�Ұ�'
                ELSE '����'
            END ����,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) �����ϼ�,
            TO_DATE(checkout) - (üũ�ƿ�) "���� üũ�ƿ���- ���� üũ�ƿ���",
            (üũ��)  - TO_DATE(checkout) "���� üũ���� �� ���� üũ�ƿ� �ϴ� ��¥���� ����", --���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������
            (üũ�ƿ�) - TO_DATE(checkin) "���� üũ�ƿ� �� �� ���� üũ�� �ϴ� ��¥���� ����"--���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������.
FROM roomreservation, tb
WHERE --üũ�ƿ��� üũ�� ��¥�� ���� üũ���ϰ� �ƿ��ϴ� ��¥ ���ֿ� ��ġ���� ���͸�
         (üũ��)  - TO_DATE(checkout) <= 0 AND
         (üũ�ƿ�) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;
--��
-- 20200730 ~ 20200801 ���� �� ��. (roomnum: 1,3)
--20200727~20200730(3) ���̿� �־ �����Ͱ� �������;� ��.
--�׷��ٸ�... 20200730

--�ڡ�
WITH tb as (
    SELECT 
        TO_DATE('20200730') üũ��, 
        TO_DATE('20200801') üũ�ƿ� 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --����1. ���� üũ���ϴ� ��¥�� ���� üũ���ϴ� ��¥�� ������ �Ұ���
                    üũ�� = TO_DATE(checkin) OR
                    --����2. ���� üũ���ϴ� ��¥�� ���� üũ�ƿ� �ϴ� ��¥���� �����̸� �Ұ���
                    üũ�� < TO_DATE(checkout) 
                THEN '�Ұ�'
                ELSE '����'
            END ����,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) �����ϼ�,
            TO_DATE(checkout) - (üũ�ƿ�) "���� üũ�ƿ���- ���� üũ�ƿ���",
            (üũ��)  - TO_DATE(checkout) "���� üũ���� �� ���� üũ�ƿ� �ϴ� ��¥���� ����", --���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������
            (üũ�ƿ�) - TO_DATE(checkin) "���� üũ�ƿ� �� �� ���� üũ�� �ϴ� ��¥���� ����"--���� üũ�ƿ� �ϴ� ��¥�� ��ġ�� �� ������.
FROM roomreservation, tb
WHERE --üũ�ƿ��� üũ�� ��¥�� ���� üũ���ϰ� �ƿ��ϴ� ��¥ ���ֿ� ��ġ���� ���͸�
         (üũ��)  - TO_DATE(checkout) <= 0 AND
         (üũ�ƿ�) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;