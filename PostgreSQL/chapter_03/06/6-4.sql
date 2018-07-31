DROP TABLE IF EXISTS location_1d;
CREATE TABLE location_1d (
    x1 integer
  , x2 integer
);

INSERT INTO location_1d
VALUES
    ( 5 , 10)
  , (10 ,  5)
  , (-2 ,  4)
  , ( 3 ,  3)
  , ( 0 ,  1)
;

DROP TABLE IF EXISTS location_2d;
CREATE TABLE location_2d (
    x1 integer
  , y1 integer
  , x2 integer
  , y2 integer
);

INSERT INTO location_2d
VALUES
    (0, 0, 2, 2)
  , (3, 5, 1, 2)
  , (5, 3, 2, 1)
;


-- 절대값, RMS 계산하기
SELECT
  abs(x1 - x2) AS abs_value
  , sqrt(power(x1 - x2, 2)) AS rms
FROM
  location_1d
;

-- 2차원의 유클리드 거리 계산
SELECT
  sqrt(power(x1 - x2, 2) + power(y1 - y2, 2)) AS dist
FROM
  location_2d
;
