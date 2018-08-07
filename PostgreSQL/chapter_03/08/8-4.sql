DROP TABLE IF EXISTS product_sales;
CREATE TABLE product_sales (
    category_name varchar(255)
  , product_id    varchar(255)
  , sales         integer
);

INSERT INTO product_sales
VALUES
    ('dvd' , 'D001', 50000)
  , ('dvd' , 'D002', 20000)
  , ('dvd' , 'D003', 10000)
  , ('cd'  , 'C001', 30000)
  , ('cd'  , 'C002', 20000)
  , ('cd'  , 'C003', 10000)
  , ('book', 'B001', 20000)
  , ('book', 'B002', 15000)
  , ('book', 'B003', 10000)
  , ('book', 'B004',  5000)
;

WITH
  product_sale_ranking AS (
    SELECT
      category_name
      , product_id
      , sales
      , ROW_NUMBER() OVER(PARTITION BY category_name ORDER BY sales DESC) AS rank
    FROM
      product_sales
  )
  SELECT *
  FROM product_sale_ranking
  ;

  -- 유사테이블 생성
  WITH
  mst_devices AS (
              SELECT 1 AS device_id, 'PC' AS device_name
    UNION ALL SELECT 2 AS device_id, 'PHONE' AS device_name
    UNION ALL SELECT 3 AS device_id, 'app' AS device_name
  )
  SELECT *
  FROM mst_devices
  ;


  WITH
  mst_devices AS (
              SELECT 1 AS device_id, 'PC' AS device_name
    UNION ALL SELECT 2 AS device_id, 'PHONE' AS device_name
    UNION ALL SELECT 3 AS device_id, 'app' AS device_name
  )
  SELECT
    u.user_id
    , d.device_name
  FROM
    mst_users AS u
    LEFT JOIN
      mst_devices AS d
      ON u.register_device = d.device_id
  ;
