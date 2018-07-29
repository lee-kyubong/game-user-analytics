-- 규봉: 경로지정 후 \i를 통해 test.sql initializing


DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
    user_id         varchar(255)
  , register_date   varchar(255)
  , register_device integer
);

INSERT INTO mst_users
VALUES
    ('U001', '2016-08-26', 1)
  , ('U002', '2016-08-26', 2)
  , ('U003', '2016-08-27', 3)
;

SELECT
  user_id
  , CASE -- CASE 식 중요
    WHEN register_device = 1 THEN 'desktop' -- 끝에 콤마 없이
    WHEN register_device = 2 THEN 'smartphone'
    WHEN register_device = 3 THEN 'application'
    -- 디폴트값 지정 위해선 ELSE
  END AS device_name
FROM mst_users
;
