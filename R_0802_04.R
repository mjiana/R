# 라이브러리 
library(foreign)  # spss 불러오기
library(dplyr)  # 분석툴
library(ggplot2)  # 시각화툴
library(readxl)  # 엑셀툴
# 데이터 로드 
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
# 성별 숫자에서 영어로 바꾸기
welfare$sex <- ifelse(welfare$sex==1,"male","female")
# age 만들기 : (파일 생성년도 - 생일) +1
welfare$age <- (2015-welfare$birth)+1
# ageg 만들기 : 30 미만 young, 59 이하 middle, 나머지 old 그룹
welfare <- welfare %>% 
  mutate(ageg = ifelse(age<30, "young", ifelse(age<=59, "middle", "old")))


# ------------------------ # 직업별 월급차이
# ------------ # 확인
# 데이터형
class(welfare$code_job)  # "numeric"
# 빈도표 # 상세 직종코드는 Koweps_Codebook.xlsx 두번째 시트 참고
table(welfare$code_job)

# 엑셀에서 상세직종코드 불러오기 : 두번째 시트, 컬럼 있음 
list_job <- read_excel("Koweps_Codebook.xlsx", sheet=2, col_names=T)
head(list_job)
dim(list_job)  # 149행   2열 

# 직종코드가 코드화 되어있어서 파악이 어려우므로 직업명을 같이 사용한다.
welfare <- left_join(welfare, list_job, id="code_job")

head(welfare$job) # NA가 섞여있다.

jobs_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% summarise(mean_income=mean(income))

# ------------ # 시각화
ggplot(data=jobs_income, aes(x=job, y=mean_income)) + geom_col()


# ------------ # 결과
# x축이 무슨 데이터인지 알아보기 힘들다.
# 위 결과로부터 상위 10개만 출력 및 그래프 화 
jobs_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income)) %>% 
  arrange(desc(mean_income)) %>%  # desc 내림차순
  head(10)

# 그래프화 - 내림차순 정렬 
ggplot(data=jobs_income, 
       aes(x=reorder(job,-mean_income), y=mean_income)) + 
  geom_col()

# 이렇게 해도 x축의 컬럼명이 너무 길어서 피봇한다. 
# coord_flip() : 수직바 => 수평바
# 평균 수입이 높은 것 부터 출력 
ggplot(data=jobs_income, 
       aes(x=reorder(job,-mean_income), y=mean_income)) + 
  geom_col() + coord_flip()


# 가장 하위의 10개 출력 및 그래프화 
jobs_income <- welfare %>% 
  filter(!is.na(job) & !is.na(income)) %>% 
  group_by(job) %>% 
  summarise(mean_income=mean(income)) %>% 
  arrange(mean_income) %>%  # 올림차순
  tail(10)  # 하위 10개 

# 수입이 낮은 것부터 직종별로 색을 채워 출력 
# coord_flip() : 수직바 => 수평바
ggplot(data=jobs_income, 
       aes(x=reorder(job, mean_income), y=mean_income, fill=job)) + 
  geom_col() + coord_flip()


# ------------------------ # 성별 직업 빈도 : dplyr 빈도 n()
# 1. 남성 직업 빈도 상위 10개 추출
male_job <- welfare %>% 
  filter(sex=="male" & !is.na(job)) %>%
  group_by(job) %>% 
  summarise(n=n()) %>%
  arrange(desc(n)) %>%
  head(10)

male_job

# 시각화
ggplot(data=male_job, aes(x=job, y=n, fill=job)) + geom_col()

# 눕히고 정렬 
ggplot(data=male_job, aes(x=reorder(job, -n), y=n, fill=job)) + 
  geom_col() + coord_flip()

# 2. 여성 직업 빈도 상위 10개 추출
female_job <- welfare %>% 
  filter(sex=="female" & !is.na(job)) %>%
  group_by(job) %>% 
  summarise(n=n()) %>%
  arrange(desc(n)) %>%
  head(10)

# 시각화 : 색상구분(fill=job), 수평바(coord_flip()), 정렬(reorder(job, -n)) 
ggplot(data=female_job, aes(x=reorder(job, -n), y=n, fill=job)) + 
  geom_col() + coord_flip()


