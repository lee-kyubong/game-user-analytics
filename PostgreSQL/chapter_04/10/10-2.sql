DROP TABLE IF EXISTS purchase_detail_log_2;
CREATE TABLE purchase_detail_log_2(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log_2
VALUES
    ('2015-12-01',   1, 'U001', 'D001', 2000, 'ladys_fashion', 'bag'        )
  , ('2015-12-08',  95, 'U002', 'D002', 3000, 'dvd'          , 'documentary')
  , ('2015-12-09', 168, 'U003', 'D003', 5000, 'game'         , 'accessories')
  , ('2015-12-11', 250, 'U004', 'D004', 8000, 'ladys_fashion', 'jacket'     )
  , ('2015-12-11', 325, 'U005', 'D005', 2000, 'mens_fashion' , 'jacket'     )
  , ('2015-12-12', 400, 'U006', 'D006', 4000, 'cd'           , 'classic'    )
  , ('2015-12-11', 475, 'U007', 'D007', 4000, 'book'         , 'business'   )
  , ('2015-12-10', 550, 'U008', 'D008', 6000, 'food'         , 'meats'      )
  , ('2015-12-10', 625, 'U009', 'D009', 6000, 'food'         , 'fish'       )
  , ('2015-12-11', 700, 'U010', 'D010', 2000, 'supplement'   , 'protain'    )
  , ('2015-12-08',  95, 'U002', 'D002', 3000, 'dvd'          , 'documentary')
  , ('2015-12-09', 168, 'U003', 'D003', 5000, 'game'         , 'accessories')
  , ('2015-01-11', 250, 'U004', 'D004', 8000, 'ladys_fashion', 'jacket'     )
  , ('2015-01-11', 325, 'U005', 'D005', 2000, 'mens_fashion' , 'jacket'     )
  , ('2015-01-12', 400, 'U006', 'D006', 4000, 'cd'           , 'classic'    )
  , ('2015-01-11', 475, 'U007', 'D007', 4000, 'book'         , 'business'   )
  , ('2015-01-10', 550, 'U008', 'D008', 6000, 'food'         , 'meats'      )
  , ('2015-01-10', 625, 'U009', 'D009', 6000, 'food'         , 'fish'       )
  , ('2015-01-11', 700, 'U010', 'D010', 2000, 'supplement'   , 'protain'    )
  , ('2015-01-08',  95, 'U002', 'D002', 3000, 'dvd'          , 'documentary')
  , ('2015-02-09', 168, 'U003', 'D003', 5000, 'game'         , 'accessories')
  , ('2015-02-11', 250, 'U004', 'D004', 8000, 'ladys_fashion', 'jacket'     )
  , ('2015-02-11', 325, 'U005', 'D005', 2090, 'mens_fashion' , 'jacket'     )
  , ('2015-02-12', 400, 'U006', 'D006', 4080, 'cd'           , 'classic'    )
  , ('2015-02-11', 475, 'U007', 'D007', 4070, 'book'         , 'business'   )
  , ('2015-02-10', 550, 'U008', 'D008', 6060, 'food'         , 'meats'      )
  , ('2015-03-10', 625, 'U009', 'D009', 6050, 'food'         , 'fish'       )
  , ('2015-03-11', 700, 'U010', 'D010', 2030, 'supplement'   , 'protain'    )
  , ('2015-03-08',  95, 'U002', 'D002', 3040, 'dvd'          , 'documentary')
  , ('2015-01-09', 168, 'U003', 'D003', 5050, 'game'         , 'accessories')
  , ('2015-02-11', 250, 'U004', 'D004', 8060, 'ladys_fashion', 'jacket'     )
  , ('2015-03-11', 325, 'U005', 'D005', 2010, 'mens_fashion' , 'jacket'     )
  , ('2015-01-12', 400, 'U006', 'D006', 4020, 'cd'           , 'classic'    )
  , ('2015-02-11', 475, 'U007', 'D007', 4030, 'book'         , 'business'   )
  , ('2015-03-10', 550, 'U008', 'D008', 6040, 'food'         , 'meats'      )
  , ('2015-01-22', 625, 'U009', 'D009', 6000, 'food'         , 'fish'       )
  , ('2015-01-21', 700, 'U010', 'D010', 2000, 'supplement'   , 'protain'    )

;


-- 팬 차트
WITH
daily_category_amount AS (
  SELECT
    dt
    , category
    , substring(dt, 1, 4) AS year
    , substring(dt, 6, 2) AS month
    , substring(dt, 9, 2) AS date
    , SUM(price) AS amount
  FROM purchase_detail_log_2
  GROUP BY dt, category
)
, monthly_category_amount AS (
  SELECT
    concat(year, '-', month) AS year_month
    , category
    , SUM(amount) AS amount --
  FROM
    daily_category_amount
  GROUP BY year, month, category
)
SELECT
  year_month
  , category
  , amount -- WITH 구문 내 monthly_category_amount에서 매월의 amount 계산
  , FIRST_VALUE(amount) -- 아래 year_month로 정렬했기에 1월이 FIRST_VALUE
      OVER(PARTITION BY category ORDER BY year_month, category ROWS UNBOUNDED PRECEDING)
    AS base_amount -- 1월의 값.
  , 100 * amount
    / FIRST_VALUE(amount)
        OVER(PARTITION BY category ORDER BY year_month, category ROWS UNBOUNDED PRECEDING)
      AS rate
FROM
  monthly_category_amount
ORDER BY
  year_month, category
;


-- 히스토그램 데이터
WITH
  stats AS(
    SELECT
      MAX(price) + 1AS max_price
      , MIN(price) AS min_price
      , MAX(price) + 1 - MIN(price) AS range_price
      , 10 AS bucket_num -- 계층수를 10으로 메뉴얼 입력
    FROM
      purchase_detail_log_2
  )
, purchase_log_with_bucket AS (
  SELECT
    price
    , min_price
    -- 정규화 금액: 대상 금액에서 최소 금액을 뺸 것
    , price - min_price AS diff
    -- 계층 범위: 금액 범위를 계층 수로 나눈 것
    , 1.0 * range_price / bucket_num AS bucket_range

    -- 계층 판정: FLOOR(정규화 금액 / 계층 범위)
    , FLOOR(
      1.0 * (price - min_price)
      / (1.0 * range_price / bucket_num)
      -- index가 1부터 시작하므로 +1
    ) + 1 AS bucket
    , width_bucket(price, min_price, max_price, bucket_num) -- Postgres
  FROM
    purchase_detail_log_2, stats
)
SELECT *
FROM purchase_log_with_bucket
ORDER BY price
;


-- 히스토그램 데이터
WITH
  stats AS(
    SELECT
      MAX(price) + 1AS max_price
      , MIN(price) AS min_price
      , MAX(price) + 1 - MIN(price) AS range_price
      , 10 AS bucket_num -- 계층수를 10으로 메뉴얼 입력
    FROM
      purchase_detail_log_2
  )
, purchase_log_with_bucket AS (
  SELECT
    price
    , min_price
    -- 정규화 금액: 대상 금액에서 최소 금액을 뺸 것
    , price - min_price AS diff
    -- 계층 범위: 금액 범위를 계층 수로 나눈 것
    , 1.0 * range_price / bucket_num AS bucket_range

    -- 계층 판정: FLOOR(정규화 금액 / 계층 범위)
    , FLOOR(
      1.0 * (price - min_price)
      / (1.0 * range_price / bucket_num)
      -- index가 1부터 시작하므로 +1
    ) + 1 AS bucket
    , width_bucket(price, min_price, max_price, bucket_num) -- Postgres
  FROM
    purchase_detail_log_2, stats
)
SELECT
  bucket
  -- 계층의 하한과 상한 계산
  , min_price + bucket_range * (bucket - 1) AS lower_limit
  , min_price + bucket_range * bucket AS upper_limit
  -- 도수 세기
  , COUNT(price) AS num_purchse
  -- 합계 금액 계산
  , SUM(price) AS total_amount
FROM
  purchase_log_with_bucket
GROUP BY
  bucket, min_price, bucket_range
ORDER BY bucket
;


-- 임의의 계층 너비로 히스토그램 작성
WITH
stats AS(
  SELECT
    50000 AS max_price
    , 0 AS min_price
    , 50000 AS range_price
    , 10 AS bucket_num
  FROM
    purchase_detail_log_2
)
, purchase_log_with_bucket AS (
  SELECT
    price
    , min_price
    -- 정규화 금액: 대상 금액에서 최소 금액을 뺸 것
    , price - min_price AS diff
    -- 계층 범위: 금액 범위를 계층 수로 나눈 것
    , 1.0 * range_price / bucket_num AS bucket_range

    -- 계층 판정: FLOOR(정규화 금액 / 계층 범위)
    , FLOOR(
      1.0 * (price - min_price)
      / (1.0 * range_price / bucket_num)
      -- index가 1부터 시작하므로 +1
    ) + 1 AS bucket
    , width_bucket(price, min_price, max_price, bucket_num) -- Postgres
  FROM
    purchase_detail_log_2, stats
)
SELECT
  bucket
  -- 계층의 하한과 상한 계산
  , min_price + bucket_range * (bucket - 1) AS lower_limit
  , min_price + bucket_range * bucket AS upper_limit
  -- 도수 세기
  , COUNT(price) AS num_purchse
  -- 합계 금액 계산
  , SUM(price) AS total_amount
FROM
  purchase_log_with_bucket
GROUP BY
  bucket, min_price, bucket_range
ORDER BY bucket
;
