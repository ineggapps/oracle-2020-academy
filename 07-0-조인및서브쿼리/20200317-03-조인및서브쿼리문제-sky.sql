
--테이블 작성하기
CREATE TABLE injeok(
    hakbeon VARCHAR2(15) PRIMARY KEY NOT NULL,
    name VARCHAR2(20) NOT NULL,
    birth DATE NOT NULL,
    tel VARCHAR2(20),
    email VARCHAR2(50) UNIQUE,
    created DATE DEFAULT SYSDATE NOT NULL
);


CREATE TABLE score(
    hak NUMBER(1) NOT NULL,
    ban NUMBER(2) NOT NULL,
    gubun NUMBER(1) NOT NULL,
    hakbeon VARCHAR2(15) NOT NULL,
    com NUMBER(3) NOT NULL,
    excel NUMBER(3) NOT NULL,
    word NUMBER(3) NOT NULL,
    created DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT PK_SCORE PRIMARY KEY(hak,ban,gubun,hakbeon),
    CHECK(gubun >= 1 and gubun <=4),
    CONSTRAINT FK_SCORE_HAKBEON FOREIGN KEY(hakbeon) REFERENCES injeok(hakbeon)
);

INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1000', '김자바', '2000-05-07', '010-3926-4292', 'wnasves@daum.net');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1001', '스프링', '2000-10-17', '010-3424-1234', 'kfpf@naver.com');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1002', '오라클', '2000-07-01', '010-4435-4545', 'nases@daum.net');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1003', '이순신', '2000-10-02', '010-3423-1123', 'plo43@naver.com');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1004', '너자바', '2001-01-02', '010-7567-1114', '34pkof@daum.net');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1005', '감자바', '2000-12-23', '010-3542-9570', 'klmb3@google.com');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1006', '이하늘', '2001-01-20', '010-8756-0504', 'kkfo@daum.net');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1007', '강산애', '2000-03-14', '010-4556-3460', 'jofe03@naver.com');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1008', '이상해', '2000-03-15', '010-4445-4903', 'skjof@daum.net');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1009', '심심해', '2000-03-16', '010-6543-3445', 'fjoe23@naver.com');
INSERT INTO INJEOK (HAKBEON, NAME, BIRTH, TEL, EMAIL)
VALUES('1010', '사랑해', '2000-04-24', '010-5043-4328', 'eoirf@daum.net');


INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 1, 1, '1000', 100, 90, 97, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 1, 2, '1000', 90, 94, 97, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 1, 1, '1001', 90, 5, 45, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 1, 2, '1001', 85, 45, 67, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 2, 1, '1002', 66, 76, 34, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 2, 2, '1002', 70, 76, 55, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 2, 1, '1003', 10, 90, 95, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(1, 2, 2, '1003', 30, 70, 95, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 1, 1, '1004', 90, 94, 97, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 1, 2, '1004', 55, 100, 100, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 2, 1, '1005', 100, 50, 66, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 2, 2, '1005', 80, 70, 66, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 2, 1, '1006', 80, 55, 87, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(2, 2, 2, '1006', 99, 65, 97, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 1, 1, '1007', 90, 91, 87, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 1, 2, '1007', 90, 91, 67, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 1, '1008', 40, 54, 65, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 2, '1008', 70, 74, 75, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 1, '1009', 56, 54, 77, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 2, '1009', 66, 64, 77, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 1, '1010', 77, 76, 88, SYSDATE);
INSERT INTO SCORE (HAK, BAN, GUBUN, HAKBEON, COM, EXCEL, WORD, CREATED)
VALUES(3, 2, 2, '1010', 87, 96, 88, SYSDATE);

COMMIT;

---확인
SELECT * FROM injeok; -- 11명
SELECT * FROM score; -- 22건 등록

--■문제) score테이블과 injeok 테이블을 조인하여 다음의 컬럼을 출력한다.
--1단계: tot, ave, 학급석차, 학년석차를 제외한 출력
SELECT hak, ban, gubun, name, com, excel, word
FROM injeok i
JOIN score s ON i.hakbeon = s.hakbeon;
--2단계: tot, ave 출력
SELECT hak, ban, gubun, name, com, excel, word, 
        com+excel+word tot, round((com+excel+word)/3,1) ave
FROM injeok i
JOIN score s ON i.hakbeon = s.hakbeon;
--3단계: 학급석차, 학년석차까지 출력
SELECT hak, ban, gubun, name, 
        com, excel, word, 
        com+excel+word tot, round((com+excel+word)/3,1) ave,
        RANK() OVER(PARTITION BY ban ORDER BY (com+excel+word) DESC) 학급석차,
        RANK() OVER(PARTITION BY hak ORDER BY (com+excel+word) DESC) 학년석차
FROM injeok i
JOIN score s ON i.hakbeon = s.hakbeon
ORDER BY hak, ban, gubun, 학급석차, 학년석차;

--■문제) score 테이블과 injeok 테이브과 조인하여 다음의 컬럼을 출력한다.
--출력할 컬럼: 학년, 반, 구분, 이름, 총점, 평균, 판정
SELECT TB.*,
    CASE 
        WHEN (com>=40 and excel>=40 and word>=40) and 평균>=60 THEN '합격'
        WHEN (com<40 or excel<40 or word<40) THEN '과락'
        ELSE '불합격'
    END 판정
FROM (
    SELECT hak, ban, gubun, name, 
    com, excel, word,
    com+excel+word 총점,
    round((com+excel+word)/3,1) 평균
    FROM injeok i
    JOIN score s ON i.hakbeon = s.hakbeon
) TB;