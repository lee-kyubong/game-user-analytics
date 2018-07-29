## 072918
1. 코드값을 레이블로 변경하기(5-1)
- CASE문이 중요.
2. URL에서 요소 추출하기(5-2)
- 유저가 어떤 경로를 통해 우리 서비스에 접근했나 분석 필요
- 이럴 때 정규표현식 사용(5-2)
- substring(referrer from 'https?://([^/]*)') AS referrer_host #R의 substr, paste0 등등..
- 미들웨어에 따라 작성법이 다를 것 (SparkSQL: parse_url)
3. 문자열을 배열로 분해하기
- url 값을 /를 통해 좀더 세부적으로 분해 가능
- 
