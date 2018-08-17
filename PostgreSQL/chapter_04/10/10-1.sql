DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           varchar(255)
  , order_id     integer
  , user_id      varchar(255)
  , item_id      varchar(255)
  , price        integer
  , category     varchar(255)
  , sub_category varchar(255)
);

INSERT INTO purchase_detail_log
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
;

WITH
sub_category_amount AS (
  -- 소 카테고리
  SELECT
    category AS micro_category
    , sub_category
    , SUM(price) as amount
  FROM
    purchase_detail_log
  GROUP BY
    category, sub_category -- group by에 대항목 소항목 둘다 지정하며 소항목 소계
)
, category_amount AS (
  -- 대 카테고리
  SELECT
    category
    , 'all' as sub_category -- 대항목 소계 합을 위해 'all' 생성
    , SUM(price) AS amount
  FROM
    purchase_detail_log
  GROUP BY
    category
)
, total_amount AS (
  -- 전체
  SELECT
    'all' AS category
    , 'all' AS sub_category
    , SUM(price) AS amount
  FROM
    purchase_detail_log -- group by할 필요가 없다. 전체에 대한 합이므로.
)
          -- UNION ALL을 했기에 가장 선두의 select 컬럼명을 따른다. (category)
          SELECT category, sub_category, amount FROM sub_category_amount
UNION ALL SELECT category, sub_category, amount FROM category_amount
UNION ALL SELECT category, sub_category, amount FROM total_amount
;

-- ROLLUP
SELECT
  COALESCE(category, 'all') as category
  , COALESCE(sub_category, 'all') AS sub_category
  , SUM(price) AS amount
FROM
  purchase_detail_log
GROUP BY
  ROLLUP(category, sub_category)
  -- in Hive: category, sub_category WITH ROLLUP
;


-- 비율을 구간화시켜 등급화
WITH
monthly_sales AS(
  SELECT
    category
    , SUM(price) AS amount
  FROM
    purchase_detail_log
  -- 대상 1개월 제한
  WHERE
    dt BETWEEN '2015-12-01' AND '2015-12-31'
  GROUP BY
    category
)
, sales_composition_ratio AS (
  SELECT
    category
    , amount -- 위의 monthly_sales에서 생성됨.앞서 만든 이유는 가공을 위해.
    -- 카테고리별 전체매출 대비 비율
    , 100 * amount / SUM(amount) OVER() AS composition_ratio
    -- 누계_카테고리별 전체매출 대비 비율
    , 100 * SUM(amount) OVER(ORDER BY amount DESC)
    / SUM(amount) OVER() AS cumulative_ratio
  FROM
    monthly_sales
)
  SELECT
    *
  , CASE
      WHEN cumulative_ratio BETWEEN 0 AND 70 THEN 'A'
      WHEN cumulative_ratio BETWEEN 70 AND 90 THEN 'B'
      WHEN cumulative_ratio BETWEEN 90 AND 100 THEN 'C'
    END AS abc_rank
  FROM
    sales_composition_ratio
  ORDER BY
    amount DESC
  ;
