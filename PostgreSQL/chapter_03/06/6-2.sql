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
  *
FROM quarterly_sales
;


--분기별 매출 증감 판정
SELECT
  year
  , q1
  , q2
  , CASE
    WHEN q1 < q2 THEN '+'  -- 콤마 불필요
    WHEN q1 > q2 THEN '-'
    ELSE '='
  END AS judge_q1_q2
  , q2-q1 AS diff_q2_q1
  ,SIGN(q2 - q1) AS sign_q2_q1
FROM
  quarterly_sales
ORDER BY
  year
;

-- 연간 내 최대/최소 분기 매출 찾기
SELECT
  year
  , greatest(q1, q2, q3, q4) AS MAX_q
  , least(q1, q2, q3, q4) AS MIN_q
FROM
  quarterly_sales
ORDER BY
  year
;

-- 연간 평균을 분기 매출로 계산
SELECT
  year
  , AVG(q1 + q2 + q3) AS average
FROM
  quarterly_sales
;
