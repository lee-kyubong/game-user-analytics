DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id varchar(255)
  , amount      integer
  , coupon      integer
);

INSERT INTO purchase_log_with_coupon
VALUES
    ('10001', 3280, NULL)
  , ('10002', 4650,  500)
  , ('10003', 3870, NULL)
;


-- COALESCE 함수로 null값 0으로 대체
SELECT
  purchase_id
  , amount
  , coupon
  , amount - coupon AS discounted_1
  , amount - COALESCE(coupon, 0) AS discounted_2
FROM
  purchase_log_with_coupon
;
