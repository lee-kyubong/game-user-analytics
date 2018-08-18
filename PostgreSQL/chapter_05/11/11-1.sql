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
  , ('989004ea', 'U001', 'review'  , 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 18:00:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-03 18:01:00')
  , ('989004ea', 'U001', 'add_cart', 'drama' , 'D001,D002', NULL, '2016-11-03 18:02:00')
  , ('989004ea', 'U001', 'purchase', 'drama' , 'D001,D002', 2000, '2016-11-03 18:10:00')
  , ('47db0370', 'U002', 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-03 19:00:00')
  , ('47db0370', 'U002', 'purchase', 'drama' , 'D001'     , 1000, '2016-11-03 20:00:00')
  , ('47db0370', 'U002', 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-03 20:30:00')
  , ('87b5725f', 'U001', 'add_cart', 'action', 'A004'     , NULL, '2016-11-04 12:00:00')
  , ('87b5725f', 'U001', 'add_cart', 'action', 'A005'     , NULL, '2016-11-04 12:00:00')
  , ('87b5725f', 'U001', 'add_cart', 'action', 'A006'     , NULL, '2016-11-04 12:00:00')
  , ('9afaf87c', 'U002', 'purchase', 'drama' , 'D002'     , 1000, '2016-11-04 13:00:00')
  , ('9afaf87c', 'U001', 'purchase', 'action', 'A005,A006', 1000, '2016-11-04 15:00:00')
  , ('47db0370', NULL, 'add_cart', 'drama' , 'D001'     , NULL, '2016-11-04 19:04:00')
  , ('47db0370', NULL, 'purchase', 'drama' , 'D001'     , 1000, '2016-11-05 20:03:00')
  , ('47db0370', NULL, 'add_cart', 'drama' , 'D002'     , NULL, '2016-11-06 20:32:00')
  , ('87b5725f', NULL, 'add_cart', 'action', 'A004'     , NULL, '2016-11-07 12:50:00')
  , ('87b5725f', NULL, 'add_cart', 'action', 'A005'     , NULL, '2016-11-08 12:40:00')
  , ('87b5725f', NULL, 'add_cart', 'action', 'A006'     , NULL, '2016-11-09 12:30:00')
  , ('9afaf87c', NULL, 'purchase', 'drama' , 'D002'     , 1000, '2016-11-14 13:20:00')
  , ('9afaf87c', NULL, 'purchase', 'action', 'A005,A006', 1000, '2016-11-24 15:10:00')
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
