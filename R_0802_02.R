# ------------------------------------- # 나이와 월급의 차이 분석
# 나이 : 시계열 데이터

# 라이브러리 
library(foreign)  # spss 불러오기
library(dplyr)  # 분석툴
library(ggplot2)  # 시각화툴
library(readxl)  # 엑셀툴

raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav", to.data.frame=T)
welfare <- raw_welfare  # 복사본 생성
welfare <- rename(welfare,
                  sex=h10_g3,  # 성별
                  birth=h10_g4,  # 생일
                  marriage=h10_g10,  # 결혼유무
                  religion=h10_g11,  # 종교유무
                  income=p1002_8aq1,  # 월급
                  code_job=h10_eco9,  # 직종코드
                  code_region=h10_reg7)  # 지역코드


# ------------ # 1. 나이에 대한 이상치와 결측치 확인 및 처리
# 1) 데이터형 확인
class(welfare$birth)  # "numeric"
# 2) 빈도측정  => 이상치 없음
table(welfare$birth)
boxplot(welfare$birth)
# 3) 결측치 확인  => 결측치 없음
table(is.na(welfare$birth))
# 정상범위(1900~2014), 9999무응답 결측치 변경 
welfare$birth <- ifelse(welfare$birth < 1900 | welfare$birth > 2014 | 
                          welfare$birth == 9999, NA, welfare$birth)
# 4) 데이터 재확인
table(is.na(welfare$birth))
# 5) 나이 컬럼 추가 : 파일 생성년도 - 생일컬럼
welfare$age <- (2015-welfare$birth)+1
table(welfare$age)
# 6) 빈도 그래프 확인
qplot(welfare$age)


# ------------ # 2.소득에 대한 이상치와 결측치 확인 및 처리
# 1) 소득의 데이터형 확인
class(welfare$income)  # "numeric"
# 2) 결측치 확인 => 소득 비공개가 훨씬 많다. ==> 나중에 필터링으로 제거
table(is.na(welfare$income))  # FALSE 4634 TRUE 12030 
# 3) 박스그래프로 이상치 확인
boxplot(welfare$income)
boxplot(welfare$income)$stats
table(welfare$income)
qplot(welfare$income) + xlim(0,1000)

# 현재 데이터에서는 0이거나 9999는 이상치다.
# 이상치는 결측치 NA로 변경해야한다.
welfare$income <- ifelse(welfare$income==c(0,9999),NA,welfare$income)
table(is.na(welfare$income))  # FALSE 4628  TRUE 12036 : NA 6개 증가


# ------------ # 3. 분석 : 나이와 월급의 관계
age_income <- welfare %>% filter(!is.na(income) & !is.na(age)) %>% 
  group_by(age) %>% summarise(mean_income=mean(income))


# ------------ # 4. 시각화 : 시계열 그래프
ggplot(data=age_income, aes(x=age,y=mean_income)) + geom_line()



# ------------------------------------- # 연령대별 ageg 월급차이
# 30 미만 young, 59 이하 middle, 나머지 old 그룹

# --- 1.
welfare <- welfare %>% 
  mutate(ageg = ifelse(age<30, "young", ifelse(age<=59, "middle", "old")))
# ageg 빈도 표 
table(welfare$ageg)
# middle    old  young 
# 6049   6281   4334 
qplot(welfare$ageg)  # 연령대별 빈도그래프
table(is.na(welfare$ageg))  # NA 없음 

# --- 2.
class(welfare$income) 
table(is.na(welfare$income))
qplot(welfare$income) + xlim(0,1000)
welfare$income <- ifelse(welfare$income==c(0,9999),NA,welfare$income)
table(is.na(welfare$income))  # FALSE 4628  TRUE 12036 : NA 6개 증가

# --- 3.
ageg_income <- welfare %>% filter(!is.na(income)) %>% 
  group_by(ageg) %>% summarise(mean_income=mean(income))

# --- 4. 시각화 : x축을 young, middle, old 순서로 정렬
ggplot(data=ageg_income, aes(x=ageg,y=mean_income)) + geom_col() + 
  scale_x_discrete(limit=c("young","middle","old"))
# scale_x_discrete를 사용하지않으면 알파벳 순으로 정렬된다.


# x축 순서 정리
# scale_x_discrete(limit=c("x컬럼값1","x컬럼값2","x컬럼값3"))
# y축 값에 따라서 x축 순서 지정 
# aes(x=reorder(x,-y값),y=y값) : -는 내림차순, 없으면 올림차순




