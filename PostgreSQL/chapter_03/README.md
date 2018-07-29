## 072918
1. 코드값을 레이블로 변경하기(5-1)
    - CASE문이 중요.
2. URL에서 요소 추출하기(5-2)
    - 유저가 어떤 경로를 통해 우리 서비스에 접근했나 분석 필요
    - 이럴 때 정규표현식 사용(5-2)
    - substring(referrer from 'https?://([^/]*)') AS referrer_host #R의 substr, paste0 등등..
    - 미들웨어에 따라 작성법이 다를 것 (HIVE, SparkSQL: parse_url)
3. 문자열을 배열로 분해하기
    - url 값을 /를 통해 좀더 세부적으로 분해 가능
    - 규봉: A/B test 중 B안의 버튼1, 버튼2...
    - Postgres: split_part / HIVE, SparkSQL: split(parse_url(), 인덱스가 0부터 시작
4. 날짜와 타임스탬프 다루기
    - CURRENT_DATE, CURRENT_TIMESTAMP (HIVE, SparkSQL은 () 추가)
    - 임의로 지정한 날짜와 시각으로 '날짜 자료형'과 '타임스탬프 자료형' 만들 때는 CAST
    - 규봉: (SELECT CAST('2018-07-03 13:21:33' AS timestamp) AS stamp) AS t  여기서 왜 임의의 AS로 한번 더 묶을까?
    
