DROP TABLE IF EXISTS purchase_log_2;
CREATE TABLE purchase_log_2(
    dt              varchar(255)
  , order_id        integer
  , user_id         varchar(255)
  , purchase_amount integer
);

INSERT INTO purchase_log_2
VALUES
    ('2014-01-01',  1, 'rhwpvvitou', 13900)
  , ('2014-01-01',  2, 'hqnwoamzic', 10616)
  , ('2014-01-02',  3, 'tzlmqryunr', 21156)
  , ('2014-01-02',  4, 'wkmqqwbyai', 14893)
  , ('2014-01-03',  5, 'ciecbedwbq', 13054)
  , ('2014-01-03',  6, 'svgnbqsagx', 24384)
  , ('2014-01-03',  7, 'dfgqftdocu', 15591)
  , ('2014-01-04',  8, 'sbgqlzkvyn',  3025)
  , ('2014-01-04',  9, 'lbedmngbol', 24215)
  , ('2014-01-04', 10, 'itlvssbsgx',  2059)
  , ('2014-01-05', 11, 'jqcmmguhik',  4235)
  , ('2014-01-05', 12, 'jgotcrfeyn', 28013)
  , ('2014-01-05', 13, 'pgeojzoshx', 16008)
  , ('2014-01-06', 14, 'msjberhxnx',  1980)
  , ('2014-01-06', 15, 'tlhbolohte', 23494)
  , ('2014-01-06', 16, 'gbchhkcotf',  3966)
  , ('2014-01-07', 17, 'zfmbpvpzvu', 28159)
  , ('2014-01-07', 18, 'yauwzpaxtx',  8715)
  , ('2014-01-07', 19, 'uyqboqfgex', 10805)
  , ('2014-01-08', 20, 'hiqdkrzcpq',  3462)
  , ('2014-01-08', 21, 'zosbvlylpv', 13999)
  , ('2014-01-08', 22, 'bwfbchzgnl',  2299)
  , ('2014-01-09', 23, 'zzgauelgrt', 16475)
  , ('2014-01-09', 24, 'qrzfcwecge',  6469)
  , ('2014-01-10', 25, 'njbpsrvvcq', 16584)
  , ('2014-01-10', 26, 'cyxfgumkst', 11339)

  , ('2014-02-04', 10, 'itlvssbscx',  2059)
  , ('2014-02-05', 11, 'qcmmguhck',  4235)
  , ('2014-02-05', 12, 'jotcrfecn', 28013)
  , ('2014-02-05', 13, 'pgojzoscx', 16008)
  , ('2014-02-06', 14, 'mjberhxcx',  1980)
  , ('2014-02-06', 15, 'tlbolocte', 23494)
  , ('2014-02-06', 16, 'gbchkcotf',  3966)
  , ('2014-02-07', 17, 'zfmbvpzvu', 28159)
  , ('2014-02-07', 18, 'yauwzaxtx',  8715)
  , ('2014-02-07', 19, 'uyqboqgex', 10805)
  , ('2014-02-08', 20, 'hiqdkrzpq',  3462)
  , ('2014-02-08', 21, 'zosbvlycpv', 13999)
  , ('2014-02-08', 22, 'bwfbchzcnl',  2299)
  , ('2014-02-09', 23, 'zzgauelcrt', 16475)
  , ('2014-02-09', 24, 'qrzfcwecge',  6469)
  , ('2014-02-10', 25, 'njbpsrvccq', 16584)
  , ('2014-02-10', 26, 'cyxfgumcst', 11339)

  , ('2015-01-01',  27, 'hqnwoxmzic', 10616)
  , ('2015-01-02',  28, 'tzlmqcyunr', 21156)
  , ('2015-01-02',  29, 'wkmqqwbyai', 14893)
  , ('2015-01-03',  30, 'ciecbfewbq', 23054)
  , ('2015-01-03',  31, 'svgnbqeagx', 24384)
  , ('2015-01-03',  32, 'dfgqftnocu', 15591)
  , ('2015-01-04',  33, 'sbgqlzkdsvyn',  13025)
  , ('2015-01-04',  34, 'lbedmngboal', 24215)
  , ('2015-01-04', 35, 'itlvssbsgz',  12059)
  , ('2015-01-05', 36, 'jqcmmguhix',  14235)
  , ('2015-01-05', 37, 'jgotcrfeyc', 28013)
  , ('2015-01-05', 38, 'pgeojzoshc', 16008)
  , ('2015-01-06', 39, 'msjberhxnc',  11980)
  , ('2015-01-06', 40, 'tlhbolohtc', 23494)
  , ('2015-01-06', 41, 'gbchhkcotc',  13966)
  , ('2015-01-07', 42, 'zfmbpvpzvc', 28159)
  , ('2015-01-07', 43, 'yauwzpaxtc',  18715)
  , ('2015-01-07', 44, 'uyqboqfgec', 10805)
  , ('2015-01-08', 45, 'hiqdkrzcpc',  13462)
  , ('2015-01-08', 46, 'zosbvlylpc', 13999)
  , ('2015-01-08', 47, 'bwfbchzgnc',  12299)
  , ('2015-01-09', 48, 'zzgauelgrc', 16475)
  , ('2015-01-09', 49, 'qrzfcwecgc',  16469)
  , ('2015-01-10', 50, 'njbpsrvvcc', 16584)
  , ('2015-01-10', 51, 'cyxfgumksc', 11339)

  , ('2015-03-05', 37, 'jgotcrfeyc', 28013)
  , ('2015-03-05', 38, 'pgeojzoshc', 16008)
  , ('2015-03-06', 39, 'msjberhxnc',  11980)
  , ('2015-03-06', 40, 'tlhbolohtc', 23494)
  , ('2015-03-06', 41, 'gbchhkcotc',  13966)
  , ('2015-03-07', 42, 'zfmbpvpzvc', 28159)
  , ('2015-03-07', 43, 'yauwzpaxtc',  18715)
  , ('2015-03-07', 44, 'uyqboqfgec', 10805)
  , ('2015-03-08', 45, 'hiqdkrzcpc',  13462)
  , ('2015-03-08', 46, 'zosbvlylpc', 13999)
  , ('2015-03-08', 47, 'bwfbchzgnc',  12299)
  , ('2015-03-09', 48, 'zzgauelgrc', 16475)
  , ('2015-03-09', 49, 'qrzfcwecgc',  16469)
  , ('2015-03-10', 50, 'njbpsrvvcc', 16584)
  , ('2015-03-10', 51, 'cyxfgumksc', 11339)
;

-- 당월 누계매출 집계 쿼리
WITH
daily_purchase_2 AS (
  SELECT
    dt
    -- 연, 월, 일 각각 추출
    , substr(dt, 1, 4) AS year
    , substr(dt, 6, 2) AS month
    , substr(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
  FROM purchase_log_2
  GROUP BY dt
)
SELECT
  dt
  , CONCAT(year, '-', month) AS year_month -- WITH 구문에서 만든 컬럼 사용
  , purchase_amount -- WITH 구문에서 만든 컬럼 사용
  , SUM(purchase_amount)
    OVER(PARTITION BY month ORDER BY dt ROWS UNBOUNDED PRECEDING)
  AS agg_amount
FROM daily_purchase_2
ORDER BY dt
;


-- 월별 매출과 작대비 계산
WITH
daily_purchase_2 AS (
  SELECT
    dt
    -- 연, 월, 일 각각 추출
    , substr(dt, 1, 4) AS year
    , substr(dt, 6, 2) AS month
    , substr(dt, 9, 2) AS date
    , SUM(purchase_amount) AS purchase_amount
  FROM purchase_log_2
  GROUP BY dt
)
SELECT
  month
  , SUM(CASE year WHEN '2014' THEN purchase_amount END) AS amount_2014
  , SUM(CASE year WHEN '2015' THEN purchase_amount END) AS amount_2015
  , 100.0
    * SUM(CASE year WHEN '2015' THEN purchase_amount END)
    / SUM(CASE year WHEN '2014' THEN purchase_amount END)
    AS rate
  FROM
    daily_purchase_2
  GROUP BY month
  ORDER BY month
  ;
