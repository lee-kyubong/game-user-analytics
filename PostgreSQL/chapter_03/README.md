## 072918
### 하나의 값 조작하기
5. 1. 코드값을 레이블로 변경하기 (5-1)
    - CASE문이 중요.
5. 2. URL에서 요소 추출하기 (5-2)
    - 유저가 어떤 경로를 통해 우리 서비스에 접근했나 분석 필요
    - 이럴 때 정규표현식 사용
    - *substring(referrer from 'https?://([^/]*)') AS referrer_host* #R의 substr, paste0 등등..
    - 미들웨어에 따라 작성법이 다를 것 (HIVE, SparkSQL: parse_url)
5. 3. 문자열을 배열로 분해하기 (5-2)
    - url 값을 /를 통해 좀더 세부적으로 분해 가능
    - 규봉: A/B test 중 B안의 버튼1, 버튼2...
    - Postgres: *split_part* / HIVE, SparkSQL: *split(parse_url()*, 인덱스가 0부터 시작
5. 4. 날짜와 타임스탬프 다루기 (5-2)
    - *CURRENT_DATE, CURRENT_TIMESTAMP* (HIVE, SparkSQL은 () 추가)
    - 임의로 지정한 날짜와 시각으로 '날짜 자료형'과 '타임스탬프 자료형' 만들 때는 CAST
    - **규봉: (SELECT CAST('2018-07-03 13:21:33' AS timestamp) AS stamp) AS t  여기서 왜 임의의 AS로 한번 더 묶을까?**
    - 가장 기초 *substring: substring(stamp, 1, 4)* # text 형태의 stamp col에서 첫번째 문자열부터 네번째 문자열까지 추출
    - *EXTRACT*는 자료형이 date일 때 YEAR, MONTH 등 함수 바로 적용 가능
5. 5. 결측치를 디폴트 값으로 대치 (5-5)
    - null과 문자열 결합 -> null, null과 숫자 연산 -> null
    - *COALESCE* fn으로 null value를 0으로 imputation

### 여러개의 값에 대한 조작
- 단순하게 숫자 비교 이외에도 '개인별' or '비율' 등의 지표를 사용하면 다양한 관점 구사 가능
6. 1. 문자열 연결 (6-1)
    - *CONCAT*: 문자열 간 연결
6. 2. 여러개의 값 비교하기
    - *CASE* 구문으로 전분기와의 증감 형태가 어떤지 알 수 있다.
    - 규봉: CASE 구문 내 WHEN들과 ELSE 간 콤마 없음
    - *SIGN* fn은 부호 (+1, 0, -1)
    - MIN / MAX의 역할을 least / greatest
    - **규봉: R이나 Python처럼 최대인 행 혹은 분기를 불러오려면?**
    - [**규봉: 열별로 특정 칼럼들의 조합으로 비율 혹은 평균 만들기**](https://stackoverflow.com/questions/7367750/average-of-multiple-columns)
    - >SELECT <br/>
            year<br/>
            , AVG(q1 + q2 + q3) AS average<br/>
        FROM<br/>
            quarterly_sales<br/>
        ;<br/>
    동작 안하는 전형적인 모습!
    - 
