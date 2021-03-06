--■ 고급 쿼리
-- reg테이블 참조
SELECT * FROM reg;
-- ※ 정규식(Regular Expression) - 주요 함수
--    1) REGEXP_LIKE(source_char, pattern [, match_parameter ] )
--          패턴이 포함된 문자열을 반환한다. like와 유사함
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[한백]'); --'한'이나 '백'자([한백])로 시작하는(^) 문자열
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'강산$'); --강산으로 끝나는(강산$) 문자열
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$'); --com으로 끝나는(com$) 소문자만
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$','i'); --com으로 끝나는(com$)문자열인데 대소문자 모두
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim*'); --kim을 포함하는(그중 존재하면)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim3?3'); --kim3 다음 아무 글자 1자 그리고 다음글자는 3만
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[0-3]{2}'); -- kim 다음 0~3 중 아무 숫자나 연속 2글자 이상 반복 
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[2-3]{3,4}'); --kim 다음 2~3 중 아무 숫자나 최소 3번이상 최대 4번이하 반복
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[^1]'); --kim 다음 1이라는 글자가 오면 안 된다. (대괄호 안 ^는 리스트에 없는 임의의 단일 문자와 일치한다는 것을 의미)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[^1]$'); --1로 끝나지 않으면
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[가-힣]{1,10}$'); --한글로 시작해서 한글로 끝(1~10번반복)
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[가-힣]{2,}$'); --한글로 시작해서 한글로 끝(최소 2번 반복)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[0-9]'); --숫자가 포함된 문자 반환
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[[:digit:]]'); --숫자가 포함된 문자 반환
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'.*[[:digit:]].*'); --숫자가 포함된 문자 반환
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'.[[:lower:]]'); --이름이 소문자인 것만 반환
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'[a-z|A-Z]'); --소문자,대문자 모두 반환(but 이름에 대문자가 없다)

--            SELECT * FROM reg WHERE REGEXP_LIKE(email,'((?!1).*)@'); --소문자,대문자 모두 반환(but 이름에 대문자가 없다)

--    2) REGEXP_REPLACE(source_char, pattern [, replace_string [, position [, occurrence[, match_parameter ] ] ] ])
--        SELECT REGEXP_REPLACE('내용','패턴','바꿀 값') FROM dual;

        --변경
        SELECT REGEXP_REPLACE('kim gil dong','(.*) (.*) (.*)','\2 \3 \1') FROM dual; --gil dong kim
        --띄어쓰기 단위로 글자의 값을 바꾸기
        
        SELECT email FROM reg;
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\1') FROM reg; --@기준으로 id표시 
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\2') FROM reg; --@기준으로 도메인 표시
        SELECT email, REGEXP_REPLACE(email, 'arirang', '아리랑') FROM reg;
        SELECT REGEXP_REPLACE('2345dlkfjaslfd@#$@#3423#$@#★℃$','[[:digit:]|[:punct:]]','') FROM dual;
        SELECT name, rrn, REGEXP_REPLACE(rrn,'[0-9|\-]','*',9) from emp;--주민등록번호 뒷자리 2번째부터 가리기
        
--    3) REGEXP_INSTR (source_char, pattern [, position [, occurrence [, return_option [, match_parameter ] ] ] ] )
        --패턴으로 위치를 알아내는 함수
        SELECT email,REGEXP_INSTR(email, '[0-9]') FROM reg;

--    4) REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_parameter ] ] ] )
    --정규식 패턴을 검사하여 부분 문자열을 추출한다.
        SELECT REGEXP_SUBSTR('abcd > efg', '[^>]+',1,1)  /* '[^>]+' 는 > 앞까지만 추출한다는 뜻 ( +를 없애면 한 글자씩 출력) */
        FROM DUAL; /* DUAL은 오라클내에서 Table을 임의로 생성 가능하다 */
    --출처: https://hyunit.tistory.com/40 [공부노트]
    
--    5) REGEXP_COUNT (source_char, pattern [, position [, match_param]])
        SELECT email, REGEXP_COUNT(email, 'a') FROM reg; --a가 포함된 문자열의 개수를 반환


