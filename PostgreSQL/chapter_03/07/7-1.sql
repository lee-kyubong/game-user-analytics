DROP TABLE IF EXISTS review;
CREATE TABLE review (
    user_id    varchar(255)
  , product_id varchar(255)
  , score      numeric
);

INSERT INTO review
VALUES
    ('U001', 'A001', 4.0)
  , ('U001', 'A002', 5.0)
  , ('U001', 'A003', 5.0)
  , ('U002', 'A001', 3.0)
  , ('U002', 'A002', 3.0)
  , ('U002', 'A003', 4.0)
  , ('U003', 'A001', 5.0)
  , ('U003', 'A002', 4.0)
  , ('U003', 'A003', 4.0)
;

-- 통계량 산출
SELECT
  COUNT(*) AS total_count
  , COUNT(DISTINCT user_id) AS user_count
  , COUNT(DISTINCT product_id) AS product_count
  , SUM(score) AS sum
  , AVG(score) AS avg
  , MAX(score) AS max
  , MIN(score) AS min
FROM
  review
;

--그룹핑
SELECT
  user_id
  ,COUNT(*) AS total_count
  , COUNT(DISTINCT user_id) AS user_count
  , COUNT(DISTINCT product_id) AS product_count
  , SUM(score) AS sum
  , AVG(score) AS avg
  , MAX(score) AS max
  , MIN(score) AS min
FROM
  review
GROUP BY
  user_id
;

-- 윈도함수
SELECT
  user_id
  , product_id
  , score
  , AVG(score) AS avg
  , AVG(score) OVER() AS avg_score
  , AVG(score) OVER(PARTITION BY user_id) AS user_avg_score
FROM
  review
;
