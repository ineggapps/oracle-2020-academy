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

--방 목록 1,2,3,5,8,9,10
SELECT distinct roomNum from roomReservation
order by roomNum;


--■■■ 선생님 답안
SELECT * FROM roomreservation;

--예약이 불가능한 경우의 수는 4가지이다.
SELECT * FROM roomreservation
WHERE(
    TO_DATE(checkIn) >= TO_DATE('20200724') AND
    TO_DATE(checkout) < TO_DATE('20200729') --CHECKOUT 한 날 체크인을 할 수 있으므로 범위에 포함시켜선 안 됨( <=가 아니라 <)
) 
OR ( 
    TO_DATE(checkIn) <= TO_DATE('20200724') AND --7월 24일을 포함하여 그 이전이고
    TO_DATE(checkout) >= TO_DATE('20200724') --7월 24일을 포함하여 그 이후인 경우
)
OR (    
    TO_DATE(checkout) > TO_DATE('20200724') AND --체크아웃이 7월 24일~29일 사이
    TO_DATE(checkout) < TO_DATE('20200729') 
)
OR ( 
    TO_DATE(checkIn) >= TO_DATE('20200724') AND
    TO_DATE(checkIn) < TO_DATE('20200729') --체크인이 7월 24일~29일 사이
)
ORDER BY checkIn asc;
---

-- 20200724 ~ 20200729 예약 된 룸을 모두 출력. 0729에 checkOut 되면 0729에 checkIn 가능
--★★
WITH tb as (
    SELECT 
        TO_DATE('20200724') 체크인, 
        TO_DATE('20200729') 체크아웃 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --조건1. 내가 체크인하는 날짜와 남이 체크인하는 날짜가 같으면 불가능
                    체크인 = TO_DATE(checkin) OR
                    --조건2. 내가 체크인하는 날짜가 남이 체크아웃 하는 날짜보다 이전이면 불가능
                    체크인 < TO_DATE(checkout) 
                THEN '불가'
                ELSE '가능'
            END 예약,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) 숙박일수,
            TO_DATE(checkout) - (체크아웃) "남의 체크아웃일- 나의 체크아웃일",
            (체크인)  - TO_DATE(checkout) "내가 체크인할 때 남이 체크아웃 하는 날짜와의 차이", --남이 체크아웃 하는 날짜와 겹치는 건 괜찮다
            (체크아웃) - TO_DATE(checkin) "내가 체크아웃 할 때 남이 체크인 하는 날짜와의 차이"--내가 체크아웃 하는 날짜와 겹치는 건 괜찮다.
FROM roomreservation, tb
WHERE --체크아웃과 체크인 날짜가 내가 체크인하고 아웃하는 날짜 범주에 걸치는지 필터링
         (체크인)  - TO_DATE(checkout) <= 0 AND
         (체크아웃) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;
--★
-- 20200727 ~ 20200728 예약 된 룸. (5, 1, 3, 8)
--★★
WITH tb as (
    SELECT 
        TO_DATE('20200727') 체크인, 
        TO_DATE('20200728') 체크아웃 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --조건1. 내가 체크인하는 날짜와 남이 체크인하는 날짜가 같으면 불가능
                    체크인 = TO_DATE(checkin) OR
                    --조건2. 내가 체크인하는 날짜가 남이 체크아웃 하는 날짜보다 이전이면 불가능
                    체크인 < TO_DATE(checkout) 
                THEN '불가'
                ELSE '가능'
            END 예약,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) 숙박일수,
            TO_DATE(checkout) - (체크아웃) "남의 체크아웃일- 나의 체크아웃일",
            (체크인)  - TO_DATE(checkout) "내가 체크인할 때 남이 체크아웃 하는 날짜와의 차이", --남이 체크아웃 하는 날짜와 겹치는 건 괜찮다
            (체크아웃) - TO_DATE(checkin) "내가 체크아웃 할 때 남이 체크인 하는 날짜와의 차이"--내가 체크아웃 하는 날짜와 겹치는 건 괜찮다.
FROM roomreservation, tb
WHERE --체크아웃과 체크인 날짜가 내가 체크인하고 아웃하는 날짜 범주에 걸치는지 필터링
         (체크인)  - TO_DATE(checkout) <= 0 AND
         (체크아웃) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;
--★
-- 20200730 ~ 20200801 예약 된 룸. (roomnum: 1,3)
--20200727~20200730(3) 사이에 있어도 데이터가 뽑혀나와야 함.
--그렇다면... 20200730

--★★
WITH tb as (
    SELECT 
        TO_DATE('20200730') 체크인, 
        TO_DATE('20200801') 체크아웃 
    FROM dual
)
SELECT reservationnum, roomnum, checkin, checkout, 
            CASE
                WHEN 
                    --조건1. 내가 체크인하는 날짜와 남이 체크인하는 날짜가 같으면 불가능
                    체크인 = TO_DATE(checkin) OR
                    --조건2. 내가 체크인하는 날짜가 남이 체크아웃 하는 날짜보다 이전이면 불가능
                    체크인 < TO_DATE(checkout) 
                THEN '불가'
                ELSE '가능'
            END 예약,
            (TO_DATE(checkout) - TO_DATE(checkin)+1) 숙박일수,
            TO_DATE(checkout) - (체크아웃) "남의 체크아웃일- 나의 체크아웃일",
            (체크인)  - TO_DATE(checkout) "내가 체크인할 때 남이 체크아웃 하는 날짜와의 차이", --남이 체크아웃 하는 날짜와 겹치는 건 괜찮다
            (체크아웃) - TO_DATE(checkin) "내가 체크아웃 할 때 남이 체크인 하는 날짜와의 차이"--내가 체크아웃 하는 날짜와 겹치는 건 괜찮다.
FROM roomreservation, tb
WHERE --체크아웃과 체크인 날짜가 내가 체크인하고 아웃하는 날짜 범주에 걸치는지 필터링
         (체크인)  - TO_DATE(checkout) <= 0 AND
         (체크아웃) - TO_DATE(checkin)  >= 0
ORDER BY checkin, roomnum;