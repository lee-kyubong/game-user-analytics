DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year integer
  , q1   integer
  , q2   integer
  , q3   integer
  , q4   integer
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;


SELECT
  q.year
  -- 1분기부터 4분기까지의 레이블 이름 출력
  , CASE
    WHEN p.idx = 1 THEN 'q1'
    WHEN p.idx = 2 THEN 'q2'
    WHEN p.idx = 3 THEN 'q3'
    WHEN p.idx = 4 THEN 'q4'
  END AS quarter
  -- 1분기부터 4분기까지의 매출 출력
  , CASE
    WHEN p.idx = 1 THEN q.q1
    WHEN p.idx = 2 THEN q.q2
    WHEN p.idx = 3 THEN q.q3
    WHEN p.idx = 4 THEN q.q4
  END AS sales
FROM
  quarterly_sales AS q
CROSS JOIN
  -- 행으로 전개하고 싶은 열으 수만큼 순번 테이블 만들기
  (       SELECT 1 AS idx
    UNION ALL SELECT 2 AS idx
    UNION ALL SELECT 3 AS idx
    UNION ALL SELECT 4 AS idx
  ) AS p
;

-- 임의의 길이를 가진 배열을 행으로 전개하기
DROP TABLE IF EXISTS purchase_log;
CREATE TABLE purchase_log(
    purchase_id integer
  , product_ids VARCHAR(20)
);

INSERT INTO purchase_log
VALUES
  (100001, 'A01, A02, A03')
  , (100002, 'D01, D02')
  , (100003, 'A01')
;
-- VALUES (10001, ARRAY['A01', 'A02', 'A03'])


SELECT purchase_id
    , product_id
FROM
  purchase_log
  CROSS JOIN unnest(string_to_array(product_ids, ', ')) AS product_id
;
