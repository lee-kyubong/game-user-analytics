DROP TABLE IF EXISTS mst_categories; --카테고리 마스터 테이블
CREATE TABLE mst_categories (
    category_id integer
  , name        varchar(255)
);

INSERT INTO mst_categories
VALUES
    (1, 'dvd' )
  , (2, 'cd'  )
  , (3, 'book')
;

DROP TABLE IF EXISTS category_sales; -- 카테고리별 매출 테이블
CREATE TABLE category_sales (
    category_id integer
  , sales       integer
);

INSERT INTO category_sales
VALUES
    (1, 850000)
  , (2, 500000)
;

DROP TABLE IF EXISTS product_sale_ranking;-- 카테고리별 상품 매출 순위 테이블
CREATE TABLE product_sale_ranking (
    category_id integer
  , rank        integer
  , product_id  varchar(255)
  , sales       integer
);

INSERT INTO product_sale_ranking
VALUES
    (1, 1, 'D001', 50000)
  , (1, 2, 'D002', 20000)
  , (1, 3, 'D003', 10000)
  , (2, 1, 'C001', 30000)
  , (2, 2, 'C002', 20000)
  , (2, 3, 'C003', 10000)
;

-- 여러 개의 테이블을 가로로 정렬하기
SELECT
  m.category_id
  , m.name
  , s.sales
  , r.product_id AS top_sale_product
FROM
  mst_categories AS m
  LEFT JOIN
    category_sales AS s
    ON m.category_id = s.category_id
  LEFT JOIN
    product_sale_ranking AS r
    ON m.category_id = r.category_id
 ORDER BY sales DESC
 LIMIT 3
;

-- 상관 서브쿼리

SELECT
  m.category_id
  , m.name
  , (SELECT c.sales FROM category_sales as c
  WHERE m.category_id = c.category_id)
  , (SELECT r.rank FROM product_sale_ranking as r
  WHERE m.category_id = r.category_id)
FROM
  mst_categories AS m
;


-- 카테고리 마스터 테이블이 있는데,
-- 이 카테고리별 총 매출액이 얼마이고,
-- 판매 매출 순위가 1위인 상품의 세부 id와 그 가격은 얼마인가를 JOIN으로.
SELECT
  m.category_id
  , m.name
  , s.sales AS total_sales
  , r.rank
  , r.product_id
  , r.sales AS detail_sales
FROM
  mst_categories AS m
  LEFT JOIN
    category_sales AS s
    ON
      m.category_id = s.category_id
  LEFT JOIN
    product_sale_ranking AS r
    ON
      m.category_id = r.category_id
    AND r.rank = 1 -- AND를 사용하면 매출액 NULL인 book도 포함
    -- WHERE r.rank = 1 을 사용하면 book 제외
;
