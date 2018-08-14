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
    category, sub_category
)
, category_amount AS (
  -- 대 카테고리
  SELECT
    category
    , 'all' as sub_category
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
    purchase_detail_log
)
          -- UNION ALL을 했기에 가장 선두의 select 컬럼명을 따른다. (micro_category)
          SELECT micro_category, sub_category, amount FROM sub_category_amount
UNION ALL SELECT category, sub_category, amount FROM category_amount
UNION ALL SELECT category, sub_category, amount FROM total_amount
;
