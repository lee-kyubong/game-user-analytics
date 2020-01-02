-- 특정 열 내 null을 일괄적으로 변환: NVL(열 이름, 치환 값)
SELECT NVL(home_code, "") FROM l0_noname ORDERED by date;

-- 조건논리 함수 DECODE(열, 조건 값, 치환 값, False 값)
SELECT DECODE(성별, 'M', '남', '여) FROM table1;
