-- 특정 열 내 null을 일괄적으로 변환: NVL(열 이름, 치환 값)
SELECT NVL(home_code, "") FROM l0_noname ORDERED by date;

-- 조건논리 함수 DECODE(열, 조건 값, 치환 값, False 값)
SELECT DECODE(성별, 'M', '남', '여) FROM table1;

Partition by

sub query / nested query: 서브쿼리 결과를 메인 쿼리의 조건으로 사용 (메인쿼리 + 연산자 + 서브쿼리)

- 단일행 서브쿼리 ( 결과값이 하나)
- 다중행 서브쿼리 (인원 테이블에서 부서별로 가장 낮은 급여가 얼마인지 찾고, 찾아낸 급여를 가진 직원 찾기: IN ( ))
- FROM 절 서브쿼리 inline view (가상테이블 , 뷰)
