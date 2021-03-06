-- SQL PLUS 명령어 사용 복습

-- -----------------------------------------------------
-- sys 계정 connect 및 사용자 목록 확인
cmd>sqlplus  sys/"패스워드"  as  sysdba
또는
cmd>sqlplus  /  as  sysdba

-- -----------------------------------------------------
-- sky 계정으로 CONNECT
CONN sky/"java$!"

-- -----------------------------------------------------
-- 접속된 계정이 무엇인지 확인하기
show user;

-- -----------------------------------------------------
-- HR 계정으로 전환하기
CONN hr/"HR"

-- -----------------------------------------------------
-- 접속된 계정이 무엇인지 확인하기
show user;


-- -----------------------------------------------------
--  권한을 가진 관리자 중 sys보다 권한이 약한 부관리자 정도의 계정
-- -----------------------------------------------------

CONN system/"java$!" as sysdba
-- 샘플 자료 입력
@경로\이름.sql
 
---
--SQL> show user
--USER은 "SYS"입니다

-- -----------------------------------------------------
--  권한을 가진 관리자 중 sys보다 권한이 약한 부관리자 정도의 계정
-- -----------------------------------------------------
conn scott/"TIGER";
show user;



