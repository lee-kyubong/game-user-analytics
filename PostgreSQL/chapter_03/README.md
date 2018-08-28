## chapter_3_데이터 가공을 위한 SQL
### 하나의 값 조작하기
5. 1. 코드값을 레이블로 변경하기 (5-1)
    - CASE문이 중요.
5. 2. URL에서 요소 추출하기 (5-2)
    - 유저가 어떤 경로를 통해 우리 서비스에 접근했나 분석 필요
    - 이럴 때 정규표현식 사용
    - *substring(referrer from 'https?://([^/]*)') AS referrer_host* #R의 substr, paste0 등등..
    - 미들웨어에 따라 작성법이 다를 것 (HIVE, SparkSQL: parse_url)
5. 3. 문자열을 배열로 분해하기 (5-2)
    - url 값을 /를 통해 좀더 세부적으로 분해 가능
    - 규봉: A/B test 중 B안의 버튼1, 버튼2...
    - Postgres: *split_part* / HIVE, SparkSQL: *split(parse_url()*, 인덱스가 0부터 시작
5. 4. 날짜와 타임스탬프 다루기 (5-2)
    - *CURRENT_DATE, CURRENT_TIMESTAMP* (HIVE, SparkSQL은 () 추가)
    - 임의로 지정한 날짜와 시각으로 '날짜 자료형'과 '타임스탬프 자료형' 만들 때는 CAST
    - [**규봉: (SELECT CAST('2018-07-03 13:21:33' AS timestamp) AS stamp) AS t  여기서 왜 임의의 AS로 한번 더 묶을까?**](https://stackoverflow.com/questions/14767209/subquery-in-from-must-have-an-alias)"<br/> syntax 특성이다. 붙여라.
    - 가장 기초 *substring: substring(stamp, 1, 4)* # text 형태의 stamp col에서 첫번째 문자열부터 네번째 문자열까지 추출
    - *EXTRACT*는 자료형이 date일 때 YEAR, MONTH 등 함수 바로 적용 가능
5. 5. 결측치를 디폴트 값으로 대치 (5-5)
    - null과 문자열 결합 -> null, null과 숫자 연산 -> null
    - *COALESCE* fn으로 null value를 0으로 imputation

### 여러개의 값에 대한 조작
- 단순하게 숫자 비교 이외에도 '개인별' or '비율' 등의 지표를 사용하면 다양한 관점 구사 가능
6. 1. 문자열 연결 (6-1)
    - *CONCAT*: 문자열 간 연결
6. 2. 여러개의 값 비교하기
    - *CASE* 구문으로 전분기와의 증감 형태가 어떤지 알 수 있다.
    - 규봉: CASE 구문 내 WHEN들과 ELSE 간 콤마 없음
    - *SIGN* fn은 부호 (+1, 0, -1)
    - MIN / MAX의 역할을 least / greatest
    - **규봉: R이나 Python처럼 최대인 행 혹은 분기를 불러오려면?**
    - [**규봉: 열별로 특정 칼럼들의 조합으로 비율 혹은 평균 만들기**](https://stackoverflow.com/questions/7367750/average-of-multiple-columns)
    >SELECT <br/>
            year<br/>
            , AVG(q1 + q2 + q3) AS average<br/>
        FROM<br/>
            quarterly_sales<br/>
            ; --\#동작 안하는 전형적인 모습!
6. 3. 2개의 값 비율 개산하기 (6-3)
    - CTR(Click Through Rate): '클릭 / 노출 수' 비율
    - HIVE, SparkSQL: 정수로 나눌 때 자동적으로 실수 변환
    - PostgreSQL: *CAST( - AS double precision)* 변환 필요
    - 클릭 수 혹은 노출 수가 0인 경우에 대비해, 0으로 나누는 것을 피할 필요가 있다.<br/>
    *CASE* 이용해 ERROR:  division by zero 대비 or *NULLIF(노출수, 0)* 이용
6. 4. 두 값의 거리 계산하기 (6-4))
    - 절대값, 제곱평균 제곱근(RMS) 계산 시, *abs, power( -, 2), sqrt* 활용
    - 유클리드 거리 계산도 같은 활용함수를 갖는다. *sqrt(power(x1 - x2, 2) + power(y1 - y2, 2))*
6. 5. 날짜 / 시간 계산하기 (6-5)
    - 유져의 나이 계산, 가입 기간, 연령대 분포 파악 등: 두 날짜 데이터의 차이, 시간 데이터 기준 n 시간 후 산출
    - ex) *register_stamp::timestamp - '30 minutes'::interval AS minus_30_min<br/>
    (register_stamp::date - '1 mon'::interval)::date AS minus_1_month*
    - ::timestamp는 초 단위까지의 시각 / ::date는 년-월-일까지
    - 가입일과 오늘 날짜의 차이 계산으로 이용일수 계산
    - > SELECT<br/>
    user_id<br/>
    , CURRENT_DATE AS today<br/>
    , register_stamp::date AS register_date<br/>
    , register_stamp::timestamp AS regi_timestamp<br/>
    , today - register_date AS diff_days<br/>
    FROM<br/>
    mst_users_with_birthday<br/>
    ; --\#동작 안하는 전형적인 모습! SELECT 절에서 생성한 것을 또 다른 SELECT 절 생성에 이용할 수 없다.
    - PostgreSQL에는 날짜 계산 전용함수 *age*가 있다. interval 자료형의 날짜 단위를 return.
    - 직접 계산 시 *SELECT floor((20180731 - 19900202) / 10000) AS age;
    - >Hive, SparkSQL의 경우 날짜/시각을 계산하기 위한 기본 함수가 제공되지 않으므로<br/>
    unixtime으로 변환 후 초 단위로 계산을 한 뒤 다시 타임스탬프로 변환한다.<br/>
    ex) CAST(register_stamp AS timestamp) AS timestamp) AS register_stamp<br/>
    , from_unixtime(unix_timestamp(register_stamp) + (60 * 60)) AS plus_1_hour <br/>
    -- 문자열을 날짜로 변환할 때는 to_date 함수 활용(규봉: as.date() in R) <br/>
    , to_date(register_stamp) AS register_date <br/>
    -- 일과 월을 계산할 때는 date_add or add_months fn 활용 <br/>
    , add_months(to_date(register_stamp), -1) AS minus_1_month <br/>
    -- 날짜 간 차이 계산은 date_diff()<br/>
    - CAST( - AS text(or integer...) / substring( - , 1, 10) / replace( - , '-', '') <br/>
    HIVE, SparkSQL: replace를 regexp_replace, text를 string으로.
6. 6. IP 주소 다루기
    - PostgreSQL에는 IP 주소를 다루기 위한 'inet' 자료형 구현<br/>
    address/y 형식의 네트워크 범위에 IP 주소가 포함되는지 << or >>로 판정 가능
    - 혹은 IP주소를 *CAST*를 통해 text로 변환 후, *split_part*를 통해 원하는 부분을 골라낸다.
    - HIVE, SparkSQL: CAST(split(ip, '\\,')[0] AS int
    - *lpad*는 조건에 따라 빈 공간을 0으로 채우는 fn (ex_ lpad(split_part(ip, '.', 4), 3, '0'))
    
### 하나의 테이블에 대한 조작
- 수많은 수집 데이터를 집약하고 가공하는 방법
- **윈도 함수란?**: 테이블 내부에 '윈도'라고 부르는 범위를 정의하고, 해당 범위 내부에 포함된 값을 특정 레코드에서 자유롭게 사용 가능케 하는 fn
7. 1. 그룹의 특징 찾기 (7-1)
    - *COUNT(DISTINCT user_id)* 활용 시 중복제거
    - 그룹핑*GROUP BY*. 규봉: column에 그룹핑 대상을 추가해주면 보기 편하다.
    - 윈도우 함수를 통해 집약함수 결과와 원래 값을 쉽게 비교할 수 있다.<br/>
    (한명의 유져들로 구성된 row마다. 즉, AVG(score) 단독일 때 필요한 aggregation 불필요)<br/>
    *OVER()*: 전체 / *OVER(PARTITION BY user_id)*
7. 2. 그룹 내부의 순서 (7-2)
    - 상품 평점 뿐만 아니라, 특정 국가 내 지출액 or 접속시간이 가장 긴 유져들을 내림차순 정렬할 때 활용 가능<br/>
    *(ROW_NUMBER() OVER(ORDER BY score DESC) AS row*<br/>
    - *DENSE_RANK*는 *ROW_NUMBER*와 다르게 동일 값에 대해 중복 등수를 부여<br/>
    > ERROR:  window function row_number requires an OVER clause
    - *LAG*나 *LEAD*는 현재 행을 기준으로 앞 또는 뒤의 n순위 값을 추출하는 fn<br/>
    *(LAG(product_id, 2) OVER(ORDER BY score DESC) AS lag_2)*
    - *FIRST_VALUE(), LAST_VALUE()*: *OVER(ORDER BY -)*로 정의된 목록 중 첫번째 혹은 마지막 해당 value 도출
    - 윈도 함수의 프레임 지정 구문: *FIRST_VALUE(product_id)<br/>
    OVER(ORDER BY score DESC<br/>
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)*<br/>
    - 범위 내부의 대상을 집약하는 *array_agg*(HIVE, SparkSQL: *collect_list*)
    - 각 카테고리 상위 n개 추출: SQL 사양으로 인해 윈도 함수를 where 구문 안에 작성할 수 없으므로, <br/>
    SELECT 구문에서 윈도 함수를 사용한 결과를 서브쿼리로 만들고 외부에서 where 구문 적용해야.
    > SELECT<br/>
        category<br/>
        , product_id<br/>
        , score<br/>
        , ROW_NUMBER()<br/>
            OVER(PARTITION BY category ORDER BY score DESC) AS rank<br/>
    FROM<br/>
        popular_products<br/>
    WHERE<br/>
        rank < 4<br/>
    ; -- ERROR:  column "rank" does not exist<br/><br/>
    >SELECT *<br/>
        FROM<br/>
            (SELECT<br/>
                category<br/>
                , product_id<br/>
                , score<br/>
                , ROW_NUMBER()<br/>
                    OVER(PARTITION BY category ORDER BY score DESC) AS rank<br/>
    FROM<br/>
        popular_products) AS p_p_with_rank<br/>
    WHERE<br/>
        rank < 4<br/>
    ; -- 외부 쿼리에서 순위 활용해 압축하기<br/>
7. 3. 세로 기반 데이터를 가로 기반으로 변환하기
    - *CASE WHEN sth_1 = 'sth_2' THEN sth3 END*
    - > 항상 주의해야할 **AGGREGATION!!**<br/>
    SELECT<br/>
        dt<br/>
        , MAX(CASE WHEN indicator = 'impressions' THEN val END) AS imp<br/>
        , MAX(CASE WHEN indicator = 'sessions' THEN val END) AS sess<br/>
        , MAX(CASE WHEN indicator = 'users' THEN val END) AS users<br/>
    FROM<br/>
        daily_kpi <br/>
    ; -- ERROR:  column "daily_kpi.dt" must appear in the GROUP BY clause or be used in an aggregate function
    - 행을 열로 바꿀 때, 열의 종류와 수가 가변적이라면?(ex_한 고객이 한 구매당 하나의 상품이 아닌 여러 개의 상품 구매 가능)<br/>
    *string_agg(product_id, ',') AS product_id*
7. 4. 가로 기반 데이터를 세로 기반으로 변환하기 (7-4)
    - 칼럼으로 표현된 가로기반 데이터는 데이터의 수가 고정되어 있는 특징. 행으로 전개할 데이터 수가 고정되었다면, <br/>
    그러한 데이터 수와 같은 수의 '일련번호'를 가진 피벗 테이블 생성 후 CROSS JOIN하면 된다.<br/>
    *ex) SELECT 1 AS idx UNION ALL SELECT 2 AS idx*
    
### 여러 개의 테이블 조작하기
- select * from mst_categories AS m JOIN category_sales AS c on m.category_id = c.category_id;<br/>
select * from mst_categories AS m LEFT(or RIGHT) JOIN category_sales AS c on m.category_id = c.category_id;<br/>
- select * from mst_categories NATURAL JOIN category_sales;<br/>
select * from mst_categories LEFT(or RIGHT) NATURAL JOIN category_sales;
- select * from mst_categories JOIN category_sales USING (category_id); -- [조인 컬럼은 괄호로 묶어 사용](http://keep-cool.tistory.com/41) <br/>
select * from mst_categories LEFT(or RIGHT) JOIN category_sales USING (category_id);
8. 1. 여러 개의 테이블을 세로로 결합하기 (8-1)
    - *UNION ALL*: 비슷한 구조를 가진 복수의 테이블을 세로로 결합<br/>
    >    SELECT 'app1' AS app_name, user_id, name, email, NULL AS phone FROM app1_mst_users<br/>
    UNION ALL<br/>
          SELECT 'app2' AS app_name, user_id, name, NULL, phone FROM app2_mst_users;
8. 2. 여러 개의 테이블을 가로로 정렬하기 (8-2)
    -  **규봉:WHERE r.rank = 1 VS AND r.rank = 1 -- 판매실적이 없는 3번을 미포함, 포함 why?**
    - ORDER BY sales DESC LIMIT 1 활용하려면 상관 서브쿼리로.
    - (SELECT r.product_id FROM product_sale_ranking as r<br/>
    WHERE m.category_id = r.category_id<br/>
    ORDER BY sales DESC LIMIT 1)처럼, SELECT절이나 어디에도 사용되지 않는 'sales' 컬럼으로 정렬 가능
8. 3. 조건 플래그를 0과 1로 표현하기 (8-3)
    - *LEFT JOIN* 후 id로 *GROUP BY*를 활용하면, 사용자 마스터의 레코드 수를 그대로 유지한 채<br/>
    구매 로그 기록(한 id가 복수의 행 가질 수 있음)을 결합할 수 있다.
    - 조건 플래그 0, 1 변환
    - *SIGN(COUNT(p.user_id)) AS purchased_log*: 0이라면 '0', 1 이상이면 '1'
    - *CASE WHEN m.card_number IS NOT NULL THEN 1 ELSE 0 END AS using_card*
    - *COUNT(p.user_id) AS purchase_count*
    - **규봉: 기준이 되는 master table의 칼럼들을 *GROUP BY*로 지정해야 한다!<br/>
    *GROUP BY  m.user_id, m.card_number***
8. 4. 계산한 테이블에 이름 붙여 재사용하기 (8-4)
- >select <br/>
    category_name<br/>
    , product_id<br/>
    , sales<br/>
    , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS row<br/>
    FROM<br/>
    product_sales; -- 이런 방식으로 '카테고리'별로 판매액 순으로 정렬은 가능하나, *where row = 1*은 바로 적용 불가!<br/>
    -- SQL 사양으로 인해 윈도 함수를 where 구문에 작성할 수 없으므로, <br/>
    -- SELECT 구문에서 윈도 함수를 사용한 결과를 **\'서브 쿼리\'**로 만들고 **\'외부\'**에서 where  구문 적용해야!<br/>
    SELECT<br/>
        *<br/>
    FROM<br/>
        (select<br/>
            category_name<br/>
            , product_id<br/>
            , sales<br/>
            , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS row<br/>
        FROM<br/>
            product_sales) AS test<br/> -- 서브쿼리에 alias 지정 필요. SYNTAX이므로 암기해야!
            where row = 1;<br/>
        -- 104, 97p. 한 테이블 그룹 내부의 순서를 적용하려면 '윈도' 함수 반드시 필요
        
- 서브쿼리의 중첩은 가독성을 저하시킴. Common Table Expression을 이용해 해결
- CTE는 일시적인 테이블을 만들어 여러번 재사용 가능. 매우 많이 사용되는 테이블은 아예 물리 테이블화 권장
- 사용자에 따라 테이블 생성 권한이 없기에 *WITH* 구문 통한 유사 테이블을 일시적으로 생성
- >  WITH <br/>
mst_devices AS (<br/>
SELECT 1 AS device_id, 'PC' AS device_name<br/>
UNION ALL SELECT 2 AS device_id, 'PHONE' AS device_name<br/>
UNION ALL SELECT 3 AS device_id, 'app' AS device_name<br/>
)<br/>
SELECT<br/>
u.user_id<br/>
, d.device_name<br/>
FROM<br/>
mst_users AS u<br/>
LEFT JOIN<br/>
mst_devices AS d<br/>
ON u.register_device = d.device_id<br/>
; -- 이런식으로 기존에 존재하지 않던 mst_devices 테이블을 임시로 생성 후, 기존의 mst_users와 병합
- 순번 생성<br/>
a. Postgres: *generate_series(1, 5)*
b. HIVE, SparkSQL: *explode(split(repear('x', 5-1), 'x'))*
