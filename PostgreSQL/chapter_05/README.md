## chapter_5_사용자를 파악하기 위한 데이터 추출
### 사용자 전체의 특징 및 경향 찾기
11. 1. 사용자 액션 집계 (11-1)
    - [**CROSS JOIN**](http://donggod.tistory.com/44): 모든 행과 열의 조합
    - COUNT(*) vs COUNT(1): 차이 없음
    - user_id가 NULL 또는 빈 문자가 아닌 경우 login으로 판정:<br/>
    CASE WHEN COALESCE(user_id, '') <> '' THEN 'login' ELSE 'guest' END <br/>
    마치 null if 처럼. '<>' = '!='
    - ROLLUP과 CUBE는 GROUP BY절에 사용되어 그룹별 소계 'all'을 도출해준다.
    

 
