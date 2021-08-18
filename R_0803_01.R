# ------------------------ # 데이터 전처리 
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
# 성별 값을 숫자에서 영어로 바꾸기
welfare$sex <- ifelse(welfare$sex==1,"male", 
                      ifelse(welfare$sex==2,"female",
                             ifelse(welfare$sex==9, NA, welfare$sex)))
# age 만들기 : (파일 생성년도 - 생일) +1 
welfare$age <- (2015-welfare$birth)+1
# ageg 만들기 : 30 미만 young, 59 이하 middle, 나머지 old 그룹
welfare <- welfare %>% 
  mutate(ageg = ifelse(age<30, "young", ifelse(age<=59, "middle", "old")))
# 외부파일에서 직종코드를 불러와서 직업명 병합하기 
list_job <- read_excel("Koweps_Codebook.xlsx", sheet=2, col_names=T)
welfare <- left_join(welfare, list_job, id="code_job")
# 종교 유무
welfare$religion <- ifelse(welfare$religion==1, "yes", 
                           ifelse(welfare$religion==2, "no", 
                                  ifelse(welfare$religion==9, NA, welfare$religion)))
# 결혼/이혼 유무 
welfare$group_marriage <- ifelse(welfare$marriage==1, "marriage",
                                 ifelse(welfare$marriage==3,"divorce", NA))


# ------------------------ # 연령대별 이혼률
# ------------ # 연령대 확인
table(ageg)
table(is.na(ageg))

# ------------ # 결혼/이혼 유무
# 이혼률 공식 = (이혼/ (결혼+이혼)) *100
table(welfare$marriage)  # 원본 데이터
table(welfare$group_marriage)
table(is.na(welfare$group_marriage))  
# FALSE 9143  TRUE 7521 
# 1과 3을 제외하고 모두 NA처리를 했기에 NA값이 많음 => 필터링

# ------------ # 분석 
#연령대 3그룹 이혼률 2그룹 : 총 6그룹
ageg_divorce <- welfare %>% 
  filter(!is.na(group_marriage)) %>%  # ageg는 NA가 없어서 제외 
  group_by(ageg, group_marriage) %>%  # 그룹화 6종류
  summarise(n=n()) %>% # 행 개수 카운트
  mutate(total=sum(n)) %>%   # 연령대별 총합
  mutate(d_rate=(n/total)*100) %>% # 이혼률 구하기
  filter(group_marriage=="divorce")  # 이혼만 선택 
  
ageg_divorce

# ------------ # 시각화
ggplot(data=ageg_divorce, 
       aes(x=ageg, y=d_rate, fill=ageg)) + 
  geom_col() +
  scale_x_discrete(limit=c("young","middle","old"))


# ------------------------ # 연령대, 종교유무, 이혼률 비율표 만들기 
# 단, 연령대에서 young 제외 
# 결혼상태는 group_marriage 사용 

# ------------ #
table(welfare$ageg)
table(welfare$religion)
table(welfare$group_marriage)

arm <- welfare %>% 
  filter(!is.na(group_marriage)) %>%
  group_by(ageg, religion, group_marriage) %>%
  summarise(n=n()) %>%
  mutate(total=sum(n)) %>%
  mutate(drate=(n/total)*100) %>%
  filter(ageg!="young" & group_marriage=="divorce")

ggplot(data=arm, aes(x=ageg, y=drate, fill=religion)) + 
  geom_col(position="dodge")

