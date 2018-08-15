# Blade & Soul (NCsoft)

## 2018 Big Centest @kookoowaa, @yeongrongbak, @boram_jng, @lee-kyubong

### 080218 @광교 w/ CP, YP, KL
- 라벨링 결과가 25,000씩 균등하게 이루어져 있다.
- 데이터 파일들이 커 (party 등 2GB 넘는 csv들) 사양 좋은 인프라 필요
- 도메인 파악 위해 게임 직접 플레이 필요. 최소 홈페이지 소개 완전 숙지. 
- 주차별로 접속 기록이 되어있어, 이를 어떤 방식으로 전개해나갈 것인지 고민 필요<br/>
    a. activity 개별 기록에 라벨링 병합 후 분석
    b. 주차별로 변수들의 합계량을 전개, 주별 접속 횟수는 카운팅
    
### 080518 @카카오톡 w/ CP, YP, KL
- 주차별 유져 규모를 살펴보았을 때, 8주차가 100,000, 역순으로 규모가 줄어듬
- 데이터 수집의 시작 point를 1주차로 지정 후 7주간 더 살펴본 것이 아니라,<br/>
시작 point를 8주차로 지정 후 이 전 7주 간의 기록을 모은 인위적인 형태
- 지난 회의 때 고민한 마스터 테이블 형태는 'activity의 모든 기록에 라벨링을 병합하는 형태'로 합의
- label, activity, party 데이터를 더 살펴보며 특징 파악 지속
- Python을 기반으로 협업 인프라 구축 완료

### 080618 @카카오톡 w/ CP, YP, KL, BJ
- BJ has joined a party (completed colab invitaion)

### 080818
- guild와 라벨 그룹별 분포 탐색

### 081218 @카카오톡 w/ CP, YP, KL, BJ
- guild와 라벨 그룹별 탐색 결과 공유
- trade와 라벨 그룹별 탐색 결과 공유 및 유의점 파악
- 10만 라벨 데이터를 기준으로 마스터 테이블 구축
- party 데이터 분석 후 회의 예정
-  activity 데이터에 대해 분담해 세부 요소 파악 예정
