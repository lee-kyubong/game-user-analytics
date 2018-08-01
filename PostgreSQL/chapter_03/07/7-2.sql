DROP TABLE IF EXISTS popular_products;
CREATE TABLE popular_products (
    product_id varchar(255)
  , category   varchar(255)
  , score      numeric
);

INSERT INTO popular_products
VALUES
    ('A001', 'action', 94)
  , ('A002', 'action', 81)
  , ('A003', 'action', 78)
  , ('A004', 'action', 64)
  , ('D001', 'drama' , 90)
  , ('D002', 'drama' , 82)
  , ('D003', 'drama' , 78)
  , ('D004', 'drama' , 58)
;


-- OERDER BY 구문으로 순서 정의하기
SELECT
  product_id
  , score
  , ROW_NUMBER() OVER(ORDER BY score DESC) AS row
  , DENSE_RANK() OVER(ORDER BY score DESC) AS dense_rank
  , LAG(product_id, 2) OVER(ORDER BY score DESC) AS lag_2
  , LEAD(product_id, 1) OVER(ORDER BY score DESC) AS lead_1
FROM
  popular_products
ORDER BY
  row
;


SELECT
  product_id
  , score
  -- 점수 순위 unique하게
  , ROW_NUMBER() OVER(ORDER BY score DESC) AS row_num
  -- 순위 상위부터의 누계 점수
  , SUM(score) OVER() AS total_sum
  , SUM(score)
      OVER(ORDER BY score DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    AS cum_score
  -- 바로 앞 뒤 행과의 평균
  , AVG(score)
      OVER(ORDER BY score DESC
        ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING)
    AS local_avg
  -- 순위가 가장 높은 상품 ID 추출 FIRST_VALUE
  , FIRST_VALUE(product_id)
    OVER(ORDER BY score DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM
  popular_products
ORDER BY
  row_num
;

-- 윈도 프레임 지정 및 array_agg
SELECT
  product_id
  , ROW_NUMBER() OVER(ORDER BY score DESC) AS row_num
  , array_agg(product_id)
    OVER(ORDER BY score DESC
      ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS local_agg
  , array_agg(product_id)
    OVER(ORDER BY score DESC
      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS total_agg
FROM
  popular_products
WHERE
  category = 'action'
;

-- PARTITION BY와 ORDER BY 조합하기
SELECT
  category
  , product_id
  , score
  , ROW_NUMBER()
    OVER(PARTITION BY category ORDER BY score DESC) AS rank
FROM
  popular_products
WHERE
  rank < 4
;

-- 각 카테고리 상위 n개 추출
SELECT *
FROM
  (SELECT
    category
    , product_id
    , score
    , ROW_NUMBER()
      OVER(PARTITION BY category ORDER BY score DESC) AS rank
      FROM
        popular_products) AS p_p_with_rank
WHERE
  rank < 4
;
