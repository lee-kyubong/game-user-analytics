## chapter_4_매출을 파악하기 위한 데이터 추출
### 시계열 기반 데이터 집계
9. 1. 날짜별 매출 집계 (9-1)
    - 날짜로 grouping 후 금액 컬럼을 원하는 집계함수 사용
9. 2. 이동평균 구하기 (9-1)
    - 판매량의 변화 추이를 알 수 있는 '이동평균'
    - 기준일과 기준일 이전 6일간의 평균을 **OVER()** fn 통해 구하기
    - **CASE WHEN - THEN - END
9. 3. 당월 매출 누계 (9-2)
    - 윈도 함수
    - 반복해서 나오는 구문을 **WITH** 구문으로 외부로 빼고 명명해 반복 사용
    - **OVER()** fn 내 PARTITION이 될 수 있는 자격 숙지 <br/>
    : OVER 구문과 함께 SELECT 구문서 생성된 칼럼은 PARTITION BY에 이용될 수 없다.
    - month 칼럼만을 SELECT 내 사용했지만, with 구문에서 행 하나하나 dt, y, m, d 만들어 놓았기에 year 정보도 구분 가능
9. 4. Z 차트 (9-2)
    - 월차매출 / 매출누계 / 이동년계(해당 월의 매출에 과거 11개월의 매출 합)
### 다면적 축을 사용해 데이터 집약하기
10. 1. 카테고리별 매출과 소계 계산하기 (10-1)
    - WITH 구문의 활용(with 구문으로 대항목, 소항목, 전체에 대한 소계 구하는 구문 각각 생성 후 UNION ALL)
    - 컬럼 구조가 같은 세 개의 SELECT 쿼리 UNION ALL 시엔 첫번째 SELECT 문의 컬럼명으로 완성됨
    - **ROLLUP**으로 **UNION ALL**과 같은 결과물 산출 가능<br/>
        COALESCE(category, 'all') as category, ROLLUP(category, sub_category)
10. 2.  판매량을 구간별로 나눠 제품 분류하기 (10-1)
    - 매출이 높은 순서로 데이터 정렬 후 '제품 판매가' / '누계 판매액' / '총 판매액' 구축 후 '누계 판매액 / 총 판매액'으로 비율 산출<br/>
    비율 구간을 A, B, C로 등급화 해 제품 분류
    - 9.3의 내용과 동일하게, SELECT 구문서 as로 명명되며 생성된 칼럼은, 같은 SELECT 구문 내 파생컬럼 생성에 사용될 수 없다.
10. 3. 팬 차트로 상품의 매출 증가율 확인하기 (10-2)
    - 팬 차트: 어떤 기준 시점을 100%로 두고, 이후의 숫자 변동을 확인할 수 있게 해주는 그래프. 매출 추이 파악 용이
    - select substring(dt, 1, 4) as year, SUM(val) from daily_kpi group by year; 가능.<br/>
    즉, SELECT 구문 내 생성한 컬럼으로 group by 가능
10. 4. 히스토그램 기반 데이터 만들기 (10-2)
    - Postgres: **width_bucket(price, min_price, max_price, bucket_num)**
    
    

 
