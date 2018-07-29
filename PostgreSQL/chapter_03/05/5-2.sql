DROP TABLE IF EXISTS access_log ;
CREATE TABLE access_log (
    stamp    varchar(255)
  , referrer text
  , url      text
);

INSERT INTO access_log
VALUES
    ('2016-08-26 12:02:00', 'http://www.other.com/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video/detail?id=001')
  , ('2016-08-26 12:02:01', 'http://www.other.net/path1/index.php?k1=v1&k2=v2#Ref1', 'http://www.example.com/video#ref'          )
  , ('2016-08-26 12:02:01', 'https://www.other.com/'                               , 'http://www.example.com/book/detail?id=002' )
;

SELECT
  *
FROM access_log
;

SELECT
  stamp
, substring(referrer from 'https?://([^/]*)') AS referrer_host
FROM access_log
;

-- 2. URL에서 요소 추출하기
SELECT
  stamp
  , url
  , substring(url from '//[^/]+([^?#]+)') AS path -- 기호 수식들 전종준 교수님 자료 찾기
  , substring(url from 'id=([^&]*)') AS id
FROM access_log
;

-- 3. 문자열을 배열로 분해하기
SELECT
  stamp
  , url
  , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 2) AS PATH1
  , split_part(substring(url from '//[^/]+([^?#]+)'), '/', 3) AS PATH2
FROM access_log
;

--4. 날짜와 타임 스탬프
-- 현재 날짜와 시각
SELECT
  CURRENT_DATE AS dt
  , CURRENT_TIMESTAMP AS stamp
;

-- 임의로 지정한 날짜와 데이터 추출
SELECT
  CAST('2018-07-01' AS date) AS dt
  ,CAST('2018-07-02 13:00:32' AS timestamp) AS stamp
;

-- 날짜/시각에서 특정필드 추출
SELECT
  stamp
  , EXTRACT(YEAR FROM stamp) AS year
  , EXTRACT(MONTH FROM stamp) AS month
  , EXTRACT(DAY FROM stamp) AS day
  , EXTRACT(HOUR FROM stamp) AS hour
FROM
  (SELECT CAST('2018-07-03 13:21:33' AS timestamp) AS stamp) AS t
;

SELECT
  stamp
  , substring(stamp, 1, 4) AS year
  , substring(stamp, 1, 7) AS y_m
FROM
  (SELECT CAST('2018-08-01 14:00:00' AS text) AS stamp) AS t
;

-- 결손 값을 디폴트 값으로 대치
