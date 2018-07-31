DROP TABLE IF EXISTS advertising_stats;
CREATE TABLE advertising_stats (
    dt          varchar(255)
  , ad_id       varchar(255)
  , impressions integer
  , clicks      integer
);

INSERT INTO advertising_stats
VALUES
    ('2017-04-01', '001', 100000,  3000)
  , ('2017-04-01', '002', 120000,  1200)
  , ('2017-04-01', '003', 500000, 10000)
  , ('2017-04-02', '001',      0,     0)
  , ('2017-04-02', '002', 130000,  1400)
  , ('2017-04-02', '003', 620000, 15000)
;

-- 정수 자료형의 데이터로 나누기
SELECT
  dt
  , ad_id
  , clicks / impressions AS ctr
  , CAST(clicks AS double precision) /impressions AS ctr2
  , 100.0 * clicks / impressions AS ctr_as_percent
FROM
  advertising_stats
WHERE
  dt = '2017-04-01'
ORDER BY
  dt, ad_id
;

-- 0으로 나누는 것 피하기
SELECT
  dt
  , ad_id
  -- CASE식으로 분모가 0일 경우에 대비.
  , CASE
    WHEN impressions > 0 then 100 * clicks / impressions
  END AS ctr_as_percent_by_case
  , 100 * clicks / NULLIF(impressions, 0) AS ctr_as_percent_by_null
FROM
  advertising_stats
ORDER BY
  dt, ad_id
;
