--¡á °í±Ş Äõ¸®
-- regÅ×ÀÌºí ÂüÁ¶
SELECT * FROM reg;
-- ¡Ø Á¤±Ô½Ä(Regular Expression) - ÁÖ¿ä ÇÔ¼ö
--    1) REGEXP_LIKE(source_char, pattern [, match_parameter ] )
--          ÆĞÅÏÀÌ Æ÷ÇÔµÈ ¹®ÀÚ¿­À» ¹İÈ¯ÇÑ´Ù. like¿Í À¯»çÇÔ
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[ÇÑ¹é]'); --'ÇÑ'ÀÌ³ª '¹é'ÀÚ([ÇÑ¹é])·Î ½ÃÀÛÇÏ´Â(^) ¹®ÀÚ¿­
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'°­»ê$'); --°­»êÀ¸·Î ³¡³ª´Â(°­»ê$) ¹®ÀÚ¿­
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$'); --comÀ¸·Î ³¡³ª´Â(com$) ¼Ò¹®ÀÚ¸¸
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'com$','i'); --comÀ¸·Î ³¡³ª´Â(com$)¹®ÀÚ¿­ÀÎµ¥ ´ë¼Ò¹®ÀÚ ¸ğµÎ
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim*'); --kimÀ» Æ÷ÇÔÇÏ´Â(±×Áß Á¸ÀçÇÏ¸é)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim3?3'); --kim3 ´ÙÀ½ ¾Æ¹« ±ÛÀÚ 1ÀÚ ±×¸®°í ´ÙÀ½±ÛÀÚ´Â 3¸¸
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[0-3]{2}'); -- kim ´ÙÀ½ 0~3 Áß ¾Æ¹« ¼ıÀÚ³ª ¿¬¼Ó 2±ÛÀÚ ÀÌ»ó ¹İº¹ 
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[2-3]{3,4}'); --kim ´ÙÀ½ 2~3 Áß ¾Æ¹« ¼ıÀÚ³ª ÃÖ¼Ò 3¹øÀÌ»ó ÃÖ´ë 4¹øÀÌÇÏ ¹İº¹
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'kim[^1]'); --kim ´ÙÀ½ 1ÀÌ¶ó´Â ±ÛÀÚ°¡ ¿À¸é ¾È µÈ´Ù. (´ë°ıÈ£ ¾È ^´Â ¸®½ºÆ®¿¡ ¾ø´Â ÀÓÀÇÀÇ ´ÜÀÏ ¹®ÀÚ¿Í ÀÏÄ¡ÇÑ´Ù´Â °ÍÀ» ÀÇ¹Ì)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[^1]$'); --1·Î ³¡³ªÁö ¾ÊÀ¸¸é
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[°¡-ÆR]{1,10}$'); --ÇÑ±Û·Î ½ÃÀÛÇØ¼­ ÇÑ±Û·Î ³¡(1~10¹ø¹İº¹)
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'^[°¡-ÆR]{2,}$'); --ÇÑ±Û·Î ½ÃÀÛÇØ¼­ ÇÑ±Û·Î ³¡(ÃÖ¼Ò 2¹ø ¹İº¹)
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[0-9]'); --¼ıÀÚ°¡ Æ÷ÇÔµÈ ¹®ÀÚ ¹İÈ¯
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'[[:digit:]]'); --¼ıÀÚ°¡ Æ÷ÇÔµÈ ¹®ÀÚ ¹İÈ¯
            SELECT * FROM reg WHERE REGEXP_LIKE(email,'.*[[:digit:]].*'); --¼ıÀÚ°¡ Æ÷ÇÔµÈ ¹®ÀÚ ¹İÈ¯
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'.[[:lower:]]'); --ÀÌ¸§ÀÌ ¼Ò¹®ÀÚÀÎ °Í¸¸ ¹İÈ¯
            SELECT * FROM reg WHERE REGEXP_LIKE(name,'[a-z|A-Z]'); --¼Ò¹®ÀÚ,´ë¹®ÀÚ ¸ğµÎ ¹İÈ¯(but ÀÌ¸§¿¡ ´ë¹®ÀÚ°¡ ¾ø´Ù)

--            SELECT * FROM reg WHERE REGEXP_LIKE(email,'((?!1).*)@'); --¼Ò¹®ÀÚ,´ë¹®ÀÚ ¸ğµÎ ¹İÈ¯(but ÀÌ¸§¿¡ ´ë¹®ÀÚ°¡ ¾ø´Ù)

--    2) REGEXP_REPLACE(source_char, pattern [, replace_string [, position [, occurrence[, match_parameter ] ] ] ])
--        SELECT REGEXP_REPLACE('³»¿ë','ÆĞÅÏ','¹Ù²Ü °ª') FROM dual;

        --º¯°æ
        SELECT REGEXP_REPLACE('kim gil dong','(.*) (.*) (.*)','\2 \3 \1') FROM dual; --gil dong kim
        --¶ç¾î¾²±â ´ÜÀ§·Î ±ÛÀÚÀÇ °ªÀ» ¹Ù²Ù±â
        
        SELECT email FROM reg;
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\1') FROM reg; --@±âÁØÀ¸·Î idÇ¥½Ã 
        SELECT email, REGEXP_REPLACE(email, '(.*)@(.*)', '\2') FROM reg; --@±âÁØÀ¸·Î µµ¸ŞÀÎ Ç¥½Ã
        SELECT email, REGEXP_REPLACE(email, 'arirang', '¾Æ¸®¶û') FROM reg;
        SELECT REGEXP_REPLACE('2345dlkfjaslfd@#$@#3423#$@#¡Ú¡É$','[[:digit:]|[:punct:]]','') FROM dual;
        SELECT name, rrn, REGEXP_REPLACE(rrn,'[0-9|\-]','*',9) from emp;--ÁÖ¹Îµî·Ï¹øÈ£ µŞÀÚ¸® 2¹øÂ°ºÎÅÍ °¡¸®±â
        
--    3) REGEXP_INSTR (source_char, pattern [, position [, occurrence [, return_option [, match_parameter ] ] ] ] )
        --ÆĞÅÏÀ¸·Î À§Ä¡¸¦ ¾Ë¾Æ³»´Â ÇÔ¼ö
        SELECT email,REGEXP_INSTR(email, '[0-9]') FROM reg;

--    4) REGEXP_SUBSTR(source_char, pattern [, position [, occurrence [, match_parameter ] ] ] )
    --Á¤±Ô½Ä ÆĞÅÏÀ» °Ë»çÇÏ¿© ºÎºĞ ¹®ÀÚ¿­À» ÃßÃâÇÑ´Ù.
        SELECT REGEXP_SUBSTR('abcd > efg', '[^>]+',1,1)  /* '[^>]+' ´Â > ¾Õ±îÁö¸¸ ÃßÃâÇÑ´Ù´Â ¶æ ( +¸¦ ¾ø¾Ö¸é ÇÑ ±ÛÀÚ¾¿ Ãâ·Â) */
        FROM DUAL; /* DUALÀº ¿À¶óÅ¬³»¿¡¼­ TableÀ» ÀÓÀÇ·Î »ı¼º °¡´ÉÇÏ´Ù */
    --ÃâÃ³: https://hyunit.tistory.com/40 [°øºÎ³ëÆ®]
    
--    5) REGEXP_COUNT (source_char, pattern [, position [, match_param]])
        SELECT email, REGEXP_COUNT(email, 'a') FROM reg; --a°¡ Æ÷ÇÔµÈ ¹®ÀÚ¿­ÀÇ °³¼ö¸¦ ¹İÈ¯


