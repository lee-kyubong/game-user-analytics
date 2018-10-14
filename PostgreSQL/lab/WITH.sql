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


-- 고객의 가입일 당시 나이를 산출하고 나이 순위를 매겨보기
WITH
age AS (
  select
    user_id
    , (cast(substr(register_date, 1, 4) as int) - cast(substr(birth_date, 1, 4) as int)) as age
  from
    mst_users
)
 SELECT
  u.user_id
  , u.sex
  , u.register_device
  , a.age
  , ROW_NUMBER() OVER(ORDER BY age DESC) as r
FROM
  mst_users as u
  INNER JOIN
  age as a
  ON u.user_id = a.user_id
ORDER BY
  r ASC -- select 문서 생성한 컬럼 기준으로 정렬 가능하다.
;


select
  user_id,
  action,
  count(*)
from
  action_log
  group by
    user_id,
    action
  order by user_id
;


----------
select (select count(*) from sample51 where no = 1) as a, count(*) from sample51;




-- 이전 6일 기록과 함께 이동평균 구하기


SELECT
 dt
 , SUM(purchase_amount) AS total_amount
 , AVG(SUM(purchase_amount))
   OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
   AS seven_day_avg
 , CASE
   WHEN
     COUNT(*) OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) = 7
   THEN
     AVG(SUM(purchase_amount))
     OVER(ORDER BY dt ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
 END
 AS seven_day_avg_strict
FROM purchase_log
GROUP BY dt
ORDER BY dt
;


-- 앞서 생성한 WITH 구문 활용법
WITH
daily_purchase AS (
 SELECT
   dt
   -- 연, 월, 일 각각 추출
   , substr(dt, 1, 4) AS year
   , substr(dt, 6, 2) AS month
   , substr(dt, 9, 2) AS date
   , SUM(purchase_amount) AS purchase_amount
 FROM purchase_log
 GROUP BY dt
)
SELECT
 dt
 , CONCAT(year, '-', month) AS year_month -- WITH 구문에서 만든 컬럼 사용
 , purchase_amount -- WITH 구문에서 만든 컬럼 사용
 , SUM(purchase_amount)
   OVER(PARTITION BY month ORDER BY dt ROWS UNBOUNDED PRECEDING)
 AS agg_amount
FROM daily_purchase
ORDER BY dt
;

