DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
    user_id         varchar(255)
  , sex             varchar(255)
  , birth_date      varchar(255)
  , register_date   varchar(255)
  , register_device varchar(255)
  , withdraw_date   varchar(255)
);

INSERT INTO mst_users
VALUES
    ('U001', 'M', '1977-06-17', '2016-10-01', 'pc' , NULL        )
  , ('U002', 'F', '1953-06-12', '2016-10-01', 'sp' , '2016-10-10')
  , ('U003', 'M', '1965-01-06', '2016-10-01', 'pc' , NULL        )
  , ('U004', 'F', '1954-05-21', '2016-10-05', 'pc' , NULL        )
  , ('U005', 'M', '1987-11-23', '2016-10-05', 'sp' , NULL        )
  , ('U006', 'F', '1950-01-21', '2016-10-10', 'pc' , '2016-10-10')
  , ('U007', 'F', '1950-07-18', '2016-10-10', 'app', NULL        )
  , ('U008', 'F', '2006-12-09', '2016-10-10', 'sp' , NULL        )
  , ('U009', 'M', '2004-10-23', '2016-10-15', 'pc' , NULL        )
  , ('U010', 'F', '1987-03-18', '2016-10-16', 'pc' , NULL        )
;

DROP TABLE IF EXISTS action_log;
CREATE TABLE action_log(
    session  varchar(255)
  , user_id  varchar(255)
  , action   varchar(255)
  , category varchar(255)
  , products varchar(255)
  , amount   integer
  , stamp    varchar(255)
);

INSERT INTO action_log
VALUES
    ('989004ea', 'U001', 'purchase', 'drama' , 'D001,D002', 2000, '2016-11-03 18:10:00')
  , ('989004ea', 'U001', 'view'    , NULL    , NULL       , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'favorite', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'purchase'  , 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'purchase', 'drama' , 'D001'     , NULL, '2016-11-01 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-01 18:00:00')
  , ('989004ea', 'U005', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U006', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U007', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-01 18:01:00')
  , ('989004ea', 'U007', 'purchase', 'drama' , 'D001,D002', NULL, '2016-11-03 18:02:00')
  , ('989004ea', 'U007', 'purchase', 'drama' , 'D001,D002', 2000, '2016-11-07 18:10:00')
  , ('47db0370', 'U007', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-01 19:00:00')
  , ('47db0370', 'U002', 'purchase', 'drama' , 'D001'     , 1000, '2016-11-03 20:00:00')
  , ('47db0370', 'U002', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-03 20:30:00')
  , ('87b5725f', 'U007', 'add_cart', 'action', 'A004'     , NULL, '2016-11-04 12:00:00')
  , ('87b5725f', 'U007', 'purchase', 'action', 'A005'     , NULL, '2016-11-04 12:00:00')
  , ('87b5725f', 'U001', 'add_cart', 'action', 'A006'     , NULL, '2016-11-04 12:00:00')
  , ('9afaf87c', 'U002', 'purchase', 'drama' , 'D002'     , 1000, '2016-11-04 13:00:00')
  , ('9afaf87c', 'U001', 'purchase', 'action', 'A005,A006', 1000, '2016-11-04 15:00:00')
  , ('47db0370', 'U008', 'purchase', 'drama' , 'D001'     , NULL, '2016-11-04 19:04:00')
  , ('47db0370', 'U009', 'purchase', 'drama' , 'D001'     , 1000, '2016-11-05 20:03:00')
  , ('47db0370', 'U008', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-04 20:32:00')
  , ('87b5725f', 'U009', 'purchase', 'action', 'A004'     , NULL, '2016-11-03 12:50:00')
  , ('87b5725f', 'U009', 'add_cart', 'action', 'A005'     , NULL, '2016-11-02 12:40:00')
  , ('87b5725f', 'U000', 'purchase', 'action', 'A006'     , NULL, '2016-11-01 12:30:00')
  , ('9afaf87c', 'U000', 'purchase', 'drama' , 'D002'     , 1000, '2016-11-01 13:20:00')
  , ('9afaf87c', 'U000', 'purchase', 'action', 'A005,A006', 1000, '2016-11-01 15:10:00')
;


-- Action count and rate
WITH
  stats AS (
    SELECT COUNT(DISTINCT session) AS total_uu
    FROM action_log
  )
SELECT
  l.action
  , COUNT(DISTINCT l.session) AS action_uu
  , COUNT(1) AS action_count
  , s.total_uu
  , 100 * COUNT(DISTINCT l.session) / s.total_uu AS usage_rate
  , 1 * COUNT(1) / COUNT(DISTINCT l.session) AS count_per_user
FROM
    action_log AS l
  CROSS JOIN
    stats AS s
  GROUP BY
    l.action, s.total_uu
  ;


-- 로그인, 게스트 구분하기
WITH
action_log_w_status AS(
  SELECT
    session
    , user_id
    , action
    -- user_id가 NULL 또는 빈 문자가 아닌 경우 login으로 판정
    , CASE WHEN COALESCE(user_id, '') <> '' THEN 'login' ELSE 'guest' END
    AS login_status
  FROM
    action_log
)
SELECT *
FROM
 action_log_w_status
;


WITH
action_log_with_status AS (
  SELECT
    session
    , user_id
    , action
    -- user_id가 NULL 또는 빈 문자가 아닌 경우 login으로 판정
    , CASE WHEN COALESCE(user_id, '') <> '' THEN 'login' ELSE 'guest' END
    AS login_status
  FROM
    action_log
)
SELECT
  COALESCE(action, 'all') AS action
  , COALESCE(login_status, 'all') AS login_status
  , COUNT(DISTINCT session) AS action_uu
  , COUNT(1) AS action_c1, COUNT(*) AS action_c2
  FROM
    action_log_with_status
  GROUP BY
    ROLLUP(action, login_status)
  ;


  -- 사용자 생일로 연령 계산
  WITH
  mst_users_with_int_birth_date AS (
    SELECT
      *
    , 20180101 AS today
    -- 현재  birth_date col이 문자열이므로 정수 표현으로 변환
    , CAST(replace(substring(birth_date, 1, 10), '-', '') AS integer) AS int_birth_date
    FROM
      mst_users
  )
, mst_users_with_age AS (
  SELECT
    *
    , floor((today - int_birth_date) / 10000) AS age
  FROM
    mst_users_with_int_birth_date
)
  SELECT
  user_id, sex, birth_date, age
  FROM
    mst_users_with_age
;


-- 연령과 성별 구분기호 생성
WITH
mst_users_with_int_birth_date AS (
  SELECT
    *
  , 20180101 AS today
  -- 현재  birth_date col이 문자열이므로 정수 표현으로 변환
  , CAST(replace(substring(birth_date, 1, 10), '-', '') AS integer) AS int_birth_date
  FROM
    mst_users
)
, mst_users_with_age AS (
SELECT
  *
  , floor((today - int_birth_date) / 10000) AS age
FROM
  mst_users_with_int_birth_date
)
, mst_users_with_category AS (
  SELECT
    user_id
    , sex
    , age
    , CONCAT(
        CASE
          WHEN 20 <= age THEN sex
          ELSE ''
        END
      , CASE
          WHEN age BETWEEN 4 AND 12 THEN 'C'
          WHEN age BETWEEN 13 AND 19 THEN 'T'
          WHEN age BETWEEN 20 AND 34 THEN '1'
          WHEN age BETWEEN 35 AND 49 THEN '2'
          WHEN age >= 50 THEN '3'
        END
    ) AS category
  FROM
    mst_users_with_age
)
SELECT *
FROM
  mst_users_with_category
;


-- 11.3. 연령 구분별 특징 파악
WITH
mst_users_with_int_birth_date AS (
  SELECT
    *
  , 20180101 AS today
  -- 현재  birth_date col이 문자열이므로 정수 표현으로 변환
  , CAST(replace(substring(birth_date, 1, 10), '-', '') AS integer) AS int_birth_date
  FROM
    mst_users
)
, mst_users_with_age AS (
SELECT
  *
  , floor((today - int_birth_date) / 10000) AS age
FROM
  mst_users_with_int_birth_date
)
, mst_users_with_category AS (
  SELECT
    user_id
    , sex
    , age
    , CONCAT(
        CASE
          WHEN 20 <= age THEN sex
          ELSE ''
        END
      , CASE
          WHEN age BETWEEN 4 AND 12 THEN 'C'
          WHEN age BETWEEN 13 AND 19 THEN 'T'
          WHEN age BETWEEN 20 AND 34 THEN '1'
          WHEN age BETWEEN 35 AND 49 THEN '2'
          WHEN age >= 50 THEN '3'
        END
    ) AS category
  FROM
    mst_users_with_age
)
SELECT
  p.category AS product_category
  , u.category AS mst_users_with_category
  , COUNT(*) AS purchase_count_star
  , COUNT(1) AS purchase_count_1
FROM
  action_log AS p
  JOIN
    mst_users_with_category AS u
    ON p.user_id = u.user_id
WHERE
  action = 'purchase'
GROUP BY
  p.category, u.category
ORDER BY
  p.category, u.category
;

-- 11. 4. 사용자가 한 주간 몇 번 서비스를 사용했는가
WITH
action_log_with_dt AS (
  SELECT *
  , substring(stamp, 1, 10) AS dt
  FROM action_log
)
, action_day_count_per_user AS (
  SELECT
    user_id
    , COUNT(DISTINCT dt) AS action_day_count
  FROM
    action_log_with_dt
  WHERE
    dt BETWEEN '2016-11-01' AND '2016-11-07'
  GROUP BY
    user_id
)
SELECT
-- 위에서 각 유저들이 일주일동안 몇 번 사용했나를 집계했고,
-- 아래에서 1부터 7까지에 해당되는 유저들이 몇 명인지 집계
  action_day_count
  , COUNT(DISTINCT user_id) AS user_count
FROM
  action_day_count_per_user
GROUP BY
  action_day_count
ORDER BY
  action_day_count
;


-- Decile
WITH
user_purchase_amount AS (
  SELECT
    user_id
    , SUM(amount) AS purchase_amount
  FROM
    action_log
  WHERE
    action = 'purchase'
  GROUP BY
    user_id
)
, users_with_decile AS (
  SELECT
    user_id
    , purchase_amount
    , ntile(10) OVER(ORDER BY purchase_amount DESC) AS decile
  FROM
    user_purchase_amount
)
SELECT *
FROM users_with_decile
;


-- decile별로 그룹핑
WITH
user_purchase_amount AS (
  SELECT
    user_id
    , SUM(amount) AS purchase_amount
  FROM
    action_log
  WHERE
    action = 'purchase'
  GROUP BY
    user_id
)
, users_with_decile AS (
  SELECT
    user_id
    , purchase_amount
    , ntile(10) OVER(ORDER BY purchase_amount DESC) AS decile
  FROM
    user_purchase_amount
)
, decile_with_purchase_amount AS (
  SELECT
    decile
    , SUM(purchase_amount) AS sum_amount
    , AVG(purchase_amount) AS avg_amount
    , SUM(SUM(purchase_amount)) OVER(ORDER BY decile) AS cum_amount
    , SUM(SUM(purchase_amount)) OVER () AS total_amount
  FROM
    users_with_decile
    GROUP BY
      decile
)
SELECT *
  FROM decile_with_purchase_amount;
