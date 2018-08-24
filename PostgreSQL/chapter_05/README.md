## chapter_5_사용자를 파악하기 위한 데이터 추출
### 사용자 전체의 특징 및 경향 찾기
11. 1. 사용자 액션 집계 (11-1)
    - [**CROSS JOIN**](http://donggod.tistory.com/44): 모든 행과 열의 조합
    - COUNT(*) vs COUNT(1): 차이 없음
    - user_id가 NULL 또는 빈 문자가 아닌 경우 login으로 판정:<br/>
    CASE WHEN COALESCE(user_id, '') <> '' THEN 'login' ELSE 'guest' END <br/>
    마치 null if 처럼. '<>' = '!='
    - ROLLUP과 CUBE는 GROUP BY절에 사용되어 그룹별 소계 'all'을 도출해준다.
11. 2. 연령별 구분 집계 (11-1)
    - **CAST(replace(substring(birth_date, 1, 10), '-', '') AS integer) AS int_birth_date**<br/>
    substring으로 추출한 date 내 '-' 기호를 replace로 제거 후, CAST fn을 통해 integer화
    -  **CONCAT(CASE WHEN 20 <= age THEN sex ELSE '' END <br/>
    , CASE WHEN age BETWEEN 4 AND 12 THEN 'C' END)** -- CONCAT으로 두 문자열 합치기
11. 3. 연령 구분별 특징 파악 (11-1)
    - 사용자의 연령대에 따라 구매하는 제품 카테고리가 다른지 파악
    - SELECT \- FROM \- JOIN \- ON \- WHERE \- GROUP BY \- ORDER BY
11. 4. 사용자의 방문빈도 집계하기 (11-1)
    - 한 주 동안 서비스를 x일 사용하는 유져들이 몇명인가 집계
    - WITH 구문 내 각 유져들이 해당 기간동안 몇번 접속했나 집계 후 <br/>
    본 SELECT문에서 1, 2, ... 7일 이용한 사용자 수를 집계 산출 COUNT(DISTINC user_id)
11. 6. Decile 분석으로 사용자 10단계 구분
    - ntile(10) OVER(ORDER BY ...)

 
