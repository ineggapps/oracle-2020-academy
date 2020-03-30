--■ 인덱스(index)
-- ※ 인덱스
--인덱스 확인하기

--사용자가 소유한 인덱스에 대한 정보 확인하기
SELECT * FROM user_indexes;
SELECT index_name, index_type, table_owner, table_name FROM user_indexes;

--인덱스 컬럼에 대한 정보 확인
SELECT index_name, table_name, column_name FROM user_ind_columns;

--인덱스 삭제하기
DROP INDEX index_name;

---------------------------------------------------
       -- 형식
         -- UNIQUE 옵션은 사용자가 직접 unique한 인덱스를 생성하고 할 때 사용한다. 디폴트는 non-unique 인덱스로 생성한다.
         -- 현재 중복적이 값이 없고, 향후 중복적인 값이 존재할 가능성이 있는 경우 UNIQUE 인덱스를 생성하지 않는다.

         -- B-Tree 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명, ...);

             -- 단일 인덱스(Single Index) : 하나의 컬럼을 사용하여 인덱스를 만드는 것
                 CREATE INDEX 인덱스명 ON 테이블명(컬럼명);

             -- 결합 인덱스(Composite Index) : 두개 이상의 컬럼을 사용하여 인덱스를 만드는 것
                CREATE INDEX 인덱스명 ON 테이블명(컬럼명, 컬럼명, ...);

             -- 고유 인덱스(Unique INdex) : 유일한 값을 갖는 컬럼에 대해서만 인덱스를 설정
                 CREATE UNIQUE INDEX 인덱스명 ON 테이블명(컬럼명, ...);

         -- Bitmap 인덱스(Express는 지원하지 않음)
             CREATE BITMAP INDEX 인덱스명 ON 테이블명(컬럼명, ...);

         -- 함수기반 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(함수식(컬럼명) | 산술식);

         -- 역방향 인덱스
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명1,컬럼명2, ...) REVERSE;

         -- 내림차순 인덱스 (Ex: 게시판 새글, 은행 거래내역)
             CREATE INDEX 인덱스명 ON 테이블명(컬럼명1,컬럼명2, ... DESC);

       ---------------------------------------------------
       -- 예제
       
       --WITHOUT INDEX
    SELECT * FROM emp;
    SELECT * FROM emp WHERE name='심심해'; --0.001초
    
    -- WITH B-TREE INDEX
    CREATE INDEX idx_emp_name ON emp(name);
    SELECT * FROM emp WHERE name='심심해'; --0.002, 0.001, 0초
    
    SELECT * FROM user_indexes WHERE table_name='EMP';
    
    -- DROP INDEX
    DROP INDEX idx_emp_name;    
    
    --결합 인덱스
    --AND연산만 가능하다. OR연산의 경우 인덱스를 만들지 않음.
    --AND는 잘라내는 것이므로 순서가 중요하다.
    --앞쪽에 더 많이 자를 수 있는 조건을 지정한다. (이름과 출신으로 걸러야 하면 이름 먼저 거른다. 동명이인이 더 적을 확률이 크니까.)
    CREATE INDEX idx_emp_comp ON emp(name, city);

    SELECT name, city FROM emp WHERE name='심심해' and city='전북'; 
    DROP idx_emp_comp; 
    
    --함수기반 인덱스
    CREATE INDEX idx_emp_fun ON emp(MOD(SUBSTR(rrn,8,1),2));
    SELECT * FROM emp WHERE MOD(SUBSTR(rrn,8,1),2)=1;
    DROP INDEX idx_emp_fun;
    
    
    ◎ 인덱스 관리
       ---------------------------------------------------
       -- 예제
        
    CREATE INDEX idx_emp_name ON emp(name);
    --인덱스를 재생성
    ALTER INDEX idx_emp_name REBUILD;

    --모니터링 시작
    ALTER INDEX idx_emp_name MONITORING USAGE;
    --인덱스 사용 유무 확인
    SELECT * FROM v$object_usage;
    --  used: NO
    --검색
    SELECT name, sal FROM emp WHERE name='심심해';
    
    SELECT * FROM v$object_usage;
    -- used:YES
    
    --모니터링 종료
    ALTER INDEX idx_emp_name NOMONITORING USAGE;
    
    CREATE TABLE test(
        num NUMBER
    );
    
    BEGIN
        FOR n IN 1 .. 10000 LOOP
            INSERT INTO test VALUES(n);
        END LOOP;
        COMMIT;
    END;
    /
    
    SELECT * FROM test;
    SELECT COUNT(*) FROM test;
    -- 인덱스 생성
    CREATE INDEX idx_test_num ON test(num);
    
    --인덱스 분석
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT * FROM index_stats;
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0
    
    --삭제
    DELETE FROM test WHERE num <= 4000;
    COMMIT;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0 (이전 상태 분석)
    
    --다시 분석
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 약 40%의 데이터가 손실되었다는 의미 (39.96034739420965147095146227328255485611)
    
    --인덱스 갱신
    ALTER INDEX idx_test_num REBUILD;

    --다시 분석  
    ANALYZE INDEX idx_test_num VALIDATE STRUCTURE;
    
    SELECT (del_lf_rows_len / lf_rows_len) * 100
    FROM index_stats
    WHERE name = 'IDX_TEST_NUM'; -- 0
    

    