-- injeok
CREATE TABLE injeok (
    hakbeon   VARCHAR2(15) NOT NULL
    ,name      VARCHAR2(20) NOT NULL
    ,birth        DATE NOT NULL
    ,tel           VARCHAR2(20)
    ,email       VARCHAR2(50)
    ,created    DATE  DEFAULT SYSDATE
    ,CONSTRAINT pk_injeok_hakbeon PRIMARY KEY(hakbeon)
    ,CONSTRAINT uq_injeok_email UNIQUE(email)
);

-- score
CREATE TABLE score (
    hak         NUMBER(1)  NOT NULL
    ,ban        NUMBER(2)   NOT NULL
    ,gubun    NUMBER(1)   NOT NULL
    ,hakbeon VARCHAR2(15) NOT NULL
    ,com       NUMBER(3) NOT NULL
    ,excel      NUMBER(3) NOT NULL
    ,word      NUMBER(3) NOT NULL
    ,created  DATE  NOT NULL
    ,CONSTRAINT pk_score_hak PRIMARY KEY(hak, ban, gubun, hakbeon)
);

-- �������� �߰�
ALTER TABLE score  ADD  CONSTRAINT ck_score_gubun CHECK( gubun 1 BETWEEN 4);
ALTER TABLE score  ADD  CONSTRAINT fk_score_hakbeon FOREIGN KEY(hakbeon)
               REFERENCES injeok(hakbeon);

-- 
SELECT hak, ban,
    DECODE(gubun, 1, '1�б��߰�', 2, '1�б�⸻', 3, '2�б��߰�', 4, '2�б�⸻') ����,
    name, com, excel, word, (com+excel+word) tot,
    ROUND((com+excel+word)/3, 1) ave ,
    RANK() OVER(PARTITION BY hak, ban, gubun ORDER BY (com+excel+word) DESC) �б޼���,
    RANK() OVER(PARTITION BY hak, gubun ORDER BY (com+excel+word) DESC) �г⼮��
FROM score
JOIN injeok ON sung.hakbeon = injeok.hakbeon;


--
SELECT hak, ban, 
   DECODE(gubun, 1, '1�б��߰�', 2, '1�б�⸻', 3, '2�б��߰�', 4, '2�б�⸻') ����,
   name, (com+excel+word) tot, (com+excel+word)/3 ave,
  CASE
     WHEN com>=40 AND excel>=40 AND word>=40 AND (com+excel+word)/3 >=60 THEN '�հ�'
     WHEN (com+excel+word)/3 < 60 THEN '���հ�'
     ELSE '����'
  END pan
FROM score
JOIN injeok ON score.hakbeon = injeok.hakbeon;
