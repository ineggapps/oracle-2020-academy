--■ 오라클 12C부터 변경된 사항
-- ※ 12C부터 추가된 새로운 기능
--    ◎ Top-N 기능
--      -----------------------------------------------
        SELECT * FROM emp;
        
        --처음부터 3개 (12c)
        SELECT * FROM emp
        FETCH FIRST 3 ROWS ONLY;
        
        --처음부터 3개 (legacy)
        SELECT * FROM emp
        WHERE ROWNUM <= 3;
        
        --급여 내림차순 정렬하여 처음부터 3개 (x)
        SELECT * FROM EMP 
        WHERE ROWNUM <=3
        ORDER BY sal DESC;--결과가 의도한 대로 출력되지 않았음.
        
        --11g 방식
        SELECT * FROM ( --기존 방식에서는 서브쿼리를 사용해야 올바른 결과가 출력된다.
            SELECT * FROM EMP
            ORDER BY sal DESC
        ) WHERE ROWNUM<=3;

        --12c방식
        SELECT * FROM EMP 
        ORDER BY sal DESC
        FETCH FIRST 3 ROWS ONLY;        
        
        --급여 내림차순 정렬해서 2개 건너뛴 후 3개 
        SELECT * FROM emp
        ORDER BY sal DESC
        OFFSET 2 ROWS FETCH FIRST 3 ROWS ONLY;

        --급여 상위 10%
        SELECT * FROM emp
        ORDER BY sal DESC
        FETCH FIRST 10 PERCENT ROWS ONLY;
        
        --★★★★★(암기) 11g 페이징 처리
        -- 페이지 단위가 10개라면
        -- sal 내림차순 정렬해서 21~30번까지 조회 (3페이지)
            SELECT * FROM (
            SELECT ROWNUM rnum, tb.* FROM (
                SELECT name, sal FROM emp
                -- WHERE 절
                ORDER BY sal DESC
            ) tb WHERE ROWNUM <= 30
         ) WHERE rnum >= 21; --안에 있는 SELECT절의 ROWNUM인 rnum을 이용해야 함.        
        --★★★★(암기) 12c 페이징 처리
        SELECT * FROM emp
        ORDER BY sal DESC
        OFFSET 20 ROWS FETCH FIRST 10 ROWS ONLY;

--    ◎ INVISIBLE column (단순히 보이지만 않음)
--      -----------------------------------------------
--      INVISIBLE 설정했던 컬럼을 다시 VISIBLE로 설정하면 컬럼의 맨 뒤쪽에 배치된다.
--      COLS로만 INVISIBLE컬럼이 보인다
--      USER_TAB_COLS에는 HIDDEN_COLUMN컬럼으로 INVISIBLE 컬럼 여부를 알 수 있다.
        
        CREATE TABLE test(
            num NUMBER PRIMARY KEY,
            name VARCHAR2(30) NOT NULL,
            tel VARCHAR2(30) INVISIBLE
        );
        desc TEST; --invisible 컬럼은 보이지 않음
        SELECT * FROM COLS WHERE TABLE_NAME='TEST'; --invisible 컬럼까지 보인다
        SELECT column_name, hidden_column FROM user_tab_cols WHERE TABLE_NAME='TEST'; --hidden_column컬럼을 참조하면 INVISIBLE 컬럼은 YES라는 항목을 확인할 수 있다.
        
        INSERT INTO test VALUES (1, 'a');
        INSERT INTO test VALUES (2, 'b','010');--ORA-00913: 값의 수가 너무 많습니다. (invisible 컬럼명은 직접 명시해주지 않으면 오류가 발생한다)
        INSERT INTO test(num, name, tel) VALUES(2,'b','010');
        
        SELECT * FROM test; --INVISIBLE 컬럼(tel)은 *로 명시하여도 보이지 않는다.
        SELECT num, name, tel FROM test; -- 컬럼을 명시적으로 지정하여야만 확인할 수 있다.
        
        -- INVISIBLE 컬럼을 VISIBLE 컬럼으로 변경하는 방법
        ALTER TABLE test MODIFY (tel VISIBLE);
        DESC test; --TEL컬럼이 이제는 보이는 것을 확인할 수 있다.
        
        DELETE FROM test;
        COMMIT;
        --tel 컬럼에 not null속성 주기
        ALTER TABLE test MODIFY (tel NOT NULL);
        ALTER TABLE test MODIFY (tel INVISIBLE);
        INSERT INTO test VALUES (1, 'a');--오류.  ORA-01400: NULL을 ("SKY"."TEST"."TEL") 안에 삽입할 수 없습니다
        --아무리 숨겨진 INVISIBLE컬럼이라고 하더라도 제약조건은 동작한다.
        DROP TABLE test PURGE;
        
--    ◎ IDENTITY column 자동으로 숫자가 증가되는 IDENTITY COLUMN;
--      자동증가 컬럼
--      내부적으로는 시퀀스를 사용하여 동작한다.
--      BUT 나중에 시퀀스의 현재 값, 다음 값을 가져오기가 번거롭다.
--      -----------------------------------------------
        CREATE TABLE test(
            num NUMBER GENERATED AS IDENTITY PRIMARY KEY, --IDENTITY column
--            num NUMBER GENERATED AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY, --IDENTITY column
        --START WITH 시작값 INCREMENT BY 증감값
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test VALUES('a'); --SQL 오류: ORA-00947: 값의 수가 충분하지 않습니다
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(subject) VALUES('b');        
        SELECT * FROM test;
        -- ※ 주의사항
        ROLLBACK;
        --시퀀스와 동일하게 롤백한다고 하여도 IDENTITY 컬럼의 값은 처음으로 돌아가지 않는다.
        --∵ 내부적으로 시퀀스로 구현했기 때문
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(subject) VALUES('b');        
        SELECT * FROM test;         
        
        INSERT INTO test(num, subject) VALUES(1, 'x');--ORA-32795: generated always ID 열에 삽입할 수 없습니다.        
        --기본이 ALWAYS 로 IDENTITY 컬럼은 INSERT, UPDATE 시 수정 불가
        
        SELECT * FROM seq;--ISEQ$$_74638
        SELECT * FROM user_objects;--ISEQ$$_74638
    
        SELECT ISEQ$$_74638.CURRVAL FROM dual; -- 시퀀스처럼 현재의 커서 값을 조회할 수 있다.
        --CURRVAL => 4번까지 진행되었으므로 4가 나온다.
        
        --하지만 시퀀스의 이름을 알아내기가 힘들기 때문에 잘 사용하지 않는다.
        --EX) 오라클을 재설치하거나 다른 DB에 테이블을 생성한 경우 이름이 바뀌기 때문.
        
        --IDENTITY 컬럼에 INSERT, UPDATE 시 수정 가능 하도록(잘 하지 않음)
        DROP TABLE test PURGE;
        
         CREATE TABLE test(
            num NUMBER GENERATED BY DEFAULT AS IDENTITY, --IDENTITY column
--            num NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1) PRIMARY KEY, --IDENTITY column
        --START WITH 시작값 INCREMENT BY 증감값
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test(subject) VALUES('a');
        SELECT * FROM test;
        INSERT INTO test(num, subject) VALUES(2, 'b');
        SELECT * FROM test;
        INSERT INTO test(subject) VALUES('c');--BY DEFAULT 설정에 의해 기본값인 2가 추가되어 값이 삽입된다.
        SELECT * FROM test; 
        SELECT * FROM SEQ;
        SELECT ISEQ$$_74641.currval from dual; 
        
        ALTER TABLE test MODIFY (num NUMBER GENERATED ALWAYS AS IDENTITY);
        INSERT INTO test(num, subject) VALUES(33, 'd');--SQL 오류: ORA-32795: generated always ID 열에 삽입할 수 없습니다.
        --EX) 게시판을 만들 때 IDENTITY COLUMN을 사용하기에 용이하다
        
        DROP TABLE test PURGE;

--    ◎ DEFAULT 값
--      -----------------------------------------------
        --12c부터는 CREATE, ALTER에서 DEFAULT 시퀀스의 NEXTVAL, CURRVAL사용  가능
        
        CREATE SEQUENCE t_seq;   
        CREATE TABLE test(
            num NUMBER DEFAULT t_seq.NEXTVAL,
            subject VARCHAR2(100) NOT NULL
        );
        INSERT INTO test(subject) VALUES('a');
        INSERT INTO test(num, subject) VALUES(NULL, 'b'); --num에 null값이 삽입된다
        INSERT INTO test(subject) VALUES('c');
        
        SELECT * FROM test;
        
        DROP SEQUENCE t_seq;
        DROP TABLE test PURGE;
        
        --NULL을 위한 DEFAULT 
        CREATE SEQUENCE t1_seq;
        CREATE SEQUENCE t2_seq;
        
        CREATE TABLE test(
            col1 NUMBER DEFAULT  t1_seq.NEXTVAL,
            col2 NUMBER DEFAULT ON NULL t2_seq.NEXTVAL, --NULL인 경우 NEXTVAL값을 삽입하라는 의미이다.
            memo VARCHAR2(100)
        );
        
        INSERT INTO test(memo) VALUES('a'); --1 1 a
        INSERT INTO test(col1, col2, memo) VALUES(999,999,'b');--999 999 b
        INSERT INTO test(col1, col2, memo) VALUES(NULL,NULL,'b');--NULL 2 b
        
        SELECT * FROM test;
        
        
        DROP SEQUENCE t1_seq;
        DROP SEQUENCE t2_seq;
        DROP TABLE test PURGE;