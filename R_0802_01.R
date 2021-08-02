# ------------------------------------- # 성별에 따른 월급차이 분석하기 
# ------------ # 0730_04 내용 가져오기
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

# ------------ # 1. 성별에 대한 이상치와 결측치 확인 및 처리
# 1) 데이터형 확인
class(welfare$sex)  # "numeric"
# 2) 빈도측정  => 이상치 없음
table(welfare$sex)  # 1: 7578  2: 9086 
# 3) 결측치 확인  => 결측치 없음
table(is.na(welfare$sex))  # FALSE 16664
# 무응답 9 결측치로 변경
welfare$sex <- ifelse(welfare$sex==9,NA,welfare$sex)
# 4) 1이면 male, 2면 female로 변경
welfare$sex <- ifelse(welfare$sex==1,"male","female")
# 5) 데이터 재확인
class(welfare$sex)  # "character"
table(welfare$sex)  # female 9086   male 7578
# 6) 그래프 확인
qplot(welfare$sex)


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


# ------------ # 3. 분석
# 성별에 따른 월급차이
sex_income <- welfare %>% filter(!is.na(income)) %>% 
  group_by(sex) %>% summarise(mean_income=mean(income))
# sex    mean_income
# <chr>        <dbl>
# 1 female        163.
# 2 male          312


# ------------ # 4. 시각화
ggplot(data=sex_income, aes(x=sex,y=mean_income)) + geom_col()

