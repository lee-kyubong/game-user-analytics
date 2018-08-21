select dt, SUM(purchase_amount),
ROW_NUMBER OVER(ORDER BY purchase_amount) AS amount
from purchase_log group by dt order by dt;


-- ROW_NUMBER을 with에 따로해서 합성

WITH
g_dt AS (
  SELECT
    dt
    , SUM(purchase_amount) AS amount
  FROM
    purchase_log
  GROUP BY
    dt
)
, rn_dt AS (
  SELECT
    *
    , ROW_NUMBER() OVER(ORDER BY amount DESC) AS ranking
  FROM
    g_dt
  ORDER BY
    ranking
)
SELECT
  *
  FROM
  rn_dt
;




-- 여기서 with 구문으로 일자그룹별 amount sum을 생성한 이유는
-- 이 with 구문을 통해 본 select 문에서
-- row_number와 cumulative sum 생성 가능
WITH
g_dt AS (
  SELECT
    dt
    , SUM(purchase_amount) AS amount
  FROM
    purchase_log
  GROUP BY
    dt
)
  SELECT
    *
    , ROW_NUMBER() OVER(ORDER BY amount DESC) AS ranking
    , SUM(amount) OVER(ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
  FROM
    g_dt
  ORDER BY
    ranking
;
