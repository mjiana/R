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
# age 만들기 : (파일 생성년도 - 생일) +1
welfare$age <- (2015-welfare$birth)+1
# ageg 만들기 : 30 미만 young, 59 이하 middle, 나머지 old 그룹
welfare <- welfare %>% 
  mutate(ageg = ifelse(age<30, "young", ifelse(age<=59, "middle", "old")))


# ------------------------ # 연령대별(ageg) 성별(sex) 월급(income)차이

# 데이터 생존 확인 
head(welfare$ageg)
table(welfare$ageg)
head(welfare$sex)
table(welfare$sex)
head(welfare$income)
table(welfare$income)

# 이상치와 결측치가 처리된 상태

# ------------ # 분석
welfare <- welfare %>% filter(!is.na(income)) %>% group_by(ageg, sex) %>%
  summarise(mean_income=mean(income))  # 총 6가지 종류의 그룹

# ------------ # 시각화 fill=sex 이중그룹일 때 색상으로 구별
# 
ggplot(data=welfare, aes(x=ageg, y=mean_income, fill=sex)) + 
  geom_col() + 
  scale_x_discrete(limit=c("young","middle","old"))

# 막대그래프 분리 : 원래는 바가 두개로 나뉘어야하지만 안되고 있다. 
ggplot(data=welfare, aes(x=ageg, y=mean_income, fill=sex)) + 
  geom_col(position = "dodge") + 
  scale_x_discrete(limit=c("young","middle","old"))


