DROP TABLE IF EXISTS mst_users_with_birthday;
CREATE TABLE mst_users_with_birthday (
    user_id        varchar(255)
  , register_stamp varchar(255)
  , birth_date     varchar(255)
);

INSERT INTO mst_users_with_birthday
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;

--날짜/시간 계산
SELECT
  user_id
  , register_stamp::timestamp AS register_stamp
  , register_stamp::timestamp + '1 hour'::interval AS plus_1_hour
  , register_stamp::timestamp - '30 minutes'::interval AS minus_30_min

  , register_stamp::date AS register_date
  , (register_stamp::date + '1 day'::interval)::date AS plus_1_day
  , (register_stamp::date - '1 mon'::interval)::date AS minus_1_month
FROM
  mst_users_with_birthday
;

--날짜 데이터들의 차이 계산하기

SELECT
  user_id
  , CURRENT_DATE AS today
  , register_stamp::date AS register_date
  , register_stamp::timestamp AS regi_timestamp
  --, today - register_date AS diff_days 비문
  , CURRENT_DATE - register_stamp::date AS diff_days
FROM
  mst_users_with_birthday
;

-- 사용자의 생년월일로 나이 계산하기
SELECT
  user_id
  , CURRENT_DATE AS today
  , register_stamp::date AS register_date
  , birth_date::date AS birth_date
  , EXTRACT(YEAR FROM age(birth_date::date)) AS current_age
  , EXTRACT(YEAR FROM age(register_stamp::date, birth_date::date)) AS register_age
FROM
  mst_users_with_birthday
;

-- 직접 계산법
SELECT
  floor((20180731 - 19900202) / 10000) AS age
;

-- 등록시점과 현재 나이를 문자열 변환을 통해 계산하는 쿼리
SELECT
  user_id
  , register_stamp::date AS register_date
  , substring(register_stamp, 1, 10) AS register_date2
  , birth_date
  , floor(
      (CAST(replace(substring(register_stamp, 1, 10), '-', '') AS integer)
        - CAST(replace(birth_date, '-', '') AS integer)
      ) / 10000
    ) AS register_age
  , floor(
      (CAST(replace(CAST(CURRENT_DATE as text), '-', '') AS integer)
        - CAST(replace(birth_date, '-', '') AS integer)
      ) / 10000
    ) AS current_age
FROM
  mst_users_with_birthday
;

-- IP주소 다루기
SELECT
  CAST('127.0.0.1' AS inet) < CAST('127.0.0.2' AS inet) AS lt
  , CAST('127.0.0.1' AS inet) > CAST('192.0.0.1' AS inet) AS gt
;

SELECT
  CAST('127.0.0.1' AS inet) << CAST('127.0.0.0/8' AS inet) AS is_contained
;

SELECT
  ip
  , CAST(split_part(ip, '.', 1) AS integer) AS ip_part_1
FROM
  (SELECT CAST('192.168.0.1' AS text) AS ip) AS t
  -- 여기서 왜 t로 묶는 것인가?
;
