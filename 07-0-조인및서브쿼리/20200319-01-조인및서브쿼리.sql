ο UPDATE JOIN VIEW 이용하여 빠른 업데이트(서브쿼리 보다 훨씬 빠르다.)
      - 테이블을 조인하여 UPDATE
      - tb_a 테이블의 내용(new_addr1, new_addr2)을 tb_b에 존재하는 내용(n_addr1, n_addr2)으로 수정
      - 조인 조건의 컬럼이 UNIQUE 속성이어야 가능하며(관계가 1:1) 그렇지 않으면 ORA-01779 오류가 발생한다.

     -------------------------------------------------------
     -- 예제
        CREATE TABLE tb_a (
             num  NUMBER PRIMARY KEY
            ,addr1  VARCHAR2(255)
            ,addr2 VARCHAR2(255)
            ,new_addr1 VARCHAR2(255)
            ,new_addr2 VARCHAR2(255)
       );

      CREATE TABLE tb_b (
           num  NUMBER PRIMARY KEY
          ,n_addr1 VARCHAR2(255)
          ,n_addr2 VARCHAR2(255)
      );

      INSERT INTO tb_a VALUES(1,'서울1-1', '서울1-2','도로1-1', '도로1-2');
      INSERT INTO tb_a VALUES(2,'서울2-1', '서울2-2','도로2-1', '도로2-2');
      INSERT INTO tb_a VALUES(3,'서울3-1', '서울3-2','도로3-1', '도로3-2');
      INSERT INTO tb_a VALUES(4,'서울4-1', '서울4-2','도로4-1', '도로4-2');
      INSERT INTO tb_a VALUES(5,'서울5-1', '서울5-2','도로5-1', '도로5-2');

      INSERT INTO tb_b VALUES(1,'세종1-1', '세종1-2');
      INSERT INTO tb_b VALUES(3,'세종3-1', '세종3-2');
      INSERT INTO tb_b VALUES(5,'세종5-1', '세종5-2');
      COMMIT;

    UPDATE (
        SELECT a.new_addr1, a.new_addr2, b.n_addr1, b.n_addr2
        FROM tb_a a, tb_b b
        WHERE a.num = b.num
    )SET new_addr1 = n_addr1, new_addr2 = n_addr2;
    
    select * from tb_a;
    COMMIT;


※ subquery (in line view)
   ο WITH
     -------------------------------------------------------
     --oracle 9i부터 등장...
     WITH tmp AS (
      SELECT b.bCode, bName, bPrice, b.pNum, pName, sDate, s.cNum, cName, qty, bPrice*qty amt
        FROM book b
        JOIN pub p ON b.pNum = p.pNum 
        JOIN dsale d ON b.bCode = d.bCode
        JOIN sale s ON d.sNum = s.sNum 
        JOIN cus c ON s.cNum = c.cNum
    )
    SELECT cNum, cName, SUM(amt)
    FROM tmp
    GROUP BY cNum, cName;


   ο 단일 행 서브 쿼리
     -------------------------------------------------------
    
    --ERROR: 결괏 값이 여러 행을 받는 경우에는 불가능
    SELECT empno, name, sal FROM emp
    WHERE sal < (SELECT sal FROM emp WHERE city='서울');
    --서울 출신인 직원들의 월급값의 결과는 복수 개일 수 있다. (ORA-01427: 2개 이상의 행이 리턴됨)
    
    --단일행의 결괏값을 받는 경우에는 가능하다.
    SELECT empno, name, sal FROM emp
    WHERE sal< (SELECT AVG(sal) from emp);
    
    --ERROR: 단일컬럼이어야 한다 ORA-00913 값의 수가 너무 많습니다.
    SELECT empno, name, sal FROM emp
    WHERE sal < (SELECT AVG(sal), SUM(sal) from emp);   

   ο 다중 행 서브 쿼리
      - IN
       -------------------------------------------------------
       
       --판매된 도서 조회하기
       SELECT bcode, bname FROM book
       WHERE bcode IN (SELECT DISTINCT bcode FROM dsale);
       
        --판매되지 않은 도서 조회
       SELECT bcode, bname FROM book
       WHERE bcode NOT IN (SELECT DISTINCT bcode FROM dsale);


      - ANY(SOME)  --OR와 유사한 연산
       -------------------------------------------------------
       SELECT bcode, bname FROM book
       WHERE bcode = ANY (SELECT DISTINCT bcode FROM dsale);

       SELECT bcode, bname FROM book
       WHERE bcode = NOT ANY (SELECT DISTINCT bcode FROM dsale);

        SELECT empno, name, sal FROM emp
        WHERE sal > ANY(2000000, 2500000, 3000000); --결론은 sal이 200만 원보다 큰 직원들만 출력
        
      - ALL --AND와 유사한 연산
       -------------------------------------------------------
       
       SELECT empno, name, sal FROM emp
       WHERE sal> ALL(2000000, 2500000, 3000000); --결론은 sal이 300만 원보다 큰 직원들만 출력

        ---서울의 최댓값보다 큰 사람
        SELECT empno, name, sal FROM emp
        WHERE sal > (SELECT MAX(sal) FROM emp WHERE city='인천');

        SELECT empno, name, sal FROM emp
        WHERE sal > ALL (SELECT sal FROM emp WHERE city='인천');

      - EXISTS --하나라도 있으면 참, 아니면 거짓 (데이터의 유무)
       -------------------------------------------------------
       --qty>=10 조건을 만족하는 것이 있으면 모두 출력
       SELECT bname FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty>=10); --결론은 전부 출력 27건
       
       SELECT bname FROM book; --총 27권
       
       --뒤에 있는 것이 데이터가 한 개라도 있으면 참 없으면 거짓
       SELECT bname FROM book
       WHERE EXISTS (SELECT * FROM dsale WHERE qty>=1000);


   ο 상호 연관 서브 쿼리(correlated subquery, 상관 하위 부질의)★
    --권장하지 않음. 부하 걸림.
    --------------------------------------------------------------------
    --일부 순위를 구하는 함수나 기능을 지원하지 않는 버전에서는 다음과 같이 구현하기도 하였음.
    -------------------------------------------------------
     SELECT name, sal,
        (SELECT COUNT(e2.sal) +1 FROM emp e2
        WHERE e2.sal>e1.sal) 순위 --연산을 60번 수행 X 60번 = 3600번
    FROM emp e1;
    
    --문제1)
    CREATE TABLE gtb(
        grade VARCHAR2(10) PRIMARY KEY,
        score NUMBER(3)
    );
    INSERT INTO gtb(grade, score) VALUES('A',90);
    INSERT INTO gtb(grade, score) VALUES('B',80);
    INSERT INTO gtb(grade, score) VALUES('C',70);
    INSERT INTO gtb(grade, score) VALUES('D',60);
    INSERT INTO gtb(grade, score) VALUES('E',0);
    COMMIT;
    
    CREATE TABLE stb(
        hak VARCHAR2(30) PRIMARY KEY,
        score NUMBER NOT NULL
    );
    INSERT INTO stb(hak, score) VALUES('1', 75);
    INSERT INTO stb(hak, score) VALUES('2', 90);
    INSERT INTO stb(hak, score) VALUES('3', 75);
    INSERT INTO stb(hak, score) VALUES('4', 80);
    INSERT INTO stb(hak, score) VALUES('5', 55);
    COMMIT;
    
    --hak, stb.score, grade
    SELECT hak, score, (SELECT MAX(score) FROM gtb WHERE score <= stb.score) gscore FROM stb;

    --1단계. 실제 점수를 기반으로(stb) => 영역별 점수대를 찾는다(gtb)
    --2단계. 영역별 점수대에 알맞은 등급을 찾는다. (JOIN 이용)
     SELECT hak, s1.score, grade FROM (
        -- 상호 연관 서브 쿼리
        SELECT hak, score, 
            --해당되는 점수영역대를 gtb테이블에서 가져온다.
            (SELECT MAX(score) FROM gtb WHERE score <= stb.score) gscore 
        FROM stb
     ) s1
     JOIN gtb s2 ON s1.gscore = s2.score;