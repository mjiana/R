# ------------------------ # 기존 작업 불러오기 
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
# 외부파일에서 직종코드를 불러와서 직업명 병합하기 
list_job <- read_excel("Koweps_Codebook.xlsx", sheet=2, col_names=T)
welfare <- left_join(welfare, list_job, id="code_job")
# 종교 유무
welfare$religion <- ifelse(welfare$religion==1, "yes", "no")
# 결혼 유무 
welfare$group_marriage <- ifelse(welfare$marriage==1, "marriage",
                                 ifelse(welfare$marriage==3,"divorce", NA))

# ------------------------ # 종교 유무에 대한 이혼률
# ------------ # 종교
# 종교 유무 확인
class(welfare$religion)  # "numeric"

# 컬럼 빈도수 : 원칙적으로 1과 2만 있어야하는데 9가 존재한다면 이상치이다.
table(welfare$religion)

# 이상치 9 => 결측치 NA 변경 후 체크 
# 이상치가 있다면 NA처리를 해야하지만, NA가 없으므로 불필요 
welfare$religion <- ifelse(welfare$religion==9, NA, welfare$religion)
table(is.na(welfare$religion))  # NA 없음 

# 종교가 있으면 yes, 없으면 no로 변경
welfare$religion <- ifelse(welfare$religion==1, "yes", "no")
table(welfare$religion)


# ------------ # 결혼
# 결혼유무 검토
class(welfare$marriage)  # "numeric"
table(welfare$marriage)  # 0~6까지 7가지 종류 
table(is.na(welfare$marriage))  # NA 없음 

# 이상치 9 => 결측치로 변환
welfare$marriage <- ifelse(welfare$marriage==9, NA, welfare$marriage)
table(is.na(welfare$marriage))  # 9가 없었으므로 추가된 NA 없음 

# 결혼은 1 marriage, 3은 divorce로 나머지는 NA로 처리하는 group_marriage 추가
welfare$group_marriage <- ifelse(welfare$marriage==1, "marriage",
                           ifelse(welfare$marriage==3,"divorce", NA))
table(welfare$group_marriage)  # divorce 712 marriage 8431
table(is.na(welfare$group_marriage))  # FALSE 9143 TRUE 7521

qplot(welfare$group_marriage)

# ------------ # 종교 유무에 대한 이혼률
# 이혼률 : (이혼/(이혼+결혼))*100

welfare %>% 
  filter(!is.na(group_marriage)) %>%
  group_by(religion, group_marriage) %>%  # 4가지 종류 
  summarise(n=n())  # 카운팅
# religion group_marriage     n
# <chr>    <chr>          <int>
#   1 no       divorce          384
# 2 no       marriage        4218
# 3 yes      divorce          328
# 4 yes      marriage        4213

# welfare의 내용 중 group_marriage의 NA값을 제거하고 
# religion와 group_marriage로 그룹화 한다.
# 그룹별 행의 개수를 세고 그 값을 합산하여 total_group에 저장하고,
# 이혼률을 계산하여 divorce_rate에 저장한다.
welfare %>% 
  filter(!is.na(group_marriage)) %>% # NA값 제거 
  group_by(religion, group_marriage) %>%  # 4종류 
  summarise(n=n()) %>%  # 그룹별 행의 개수 카운팅
  mutate(total_group=sum(n)) %>%  # 종교 유무에 따른 결혼+이혼 합산(2종류)
  mutate(divorce_rate=(n/total_group)*100)  # 이혼률
# religion group_marriage     n total_group divorce_rate
#  <chr>    <chr>          <int>       <int>        <dbl>
# 1 no       divorce          384        4602         8.34
# 2 no       marriage        4218        4602        91.7 
# 3 yes      divorce          328        4541         7.22
# 4 yes      marriage        4213        4541        92.8 


# 한줄요약 : 둘 중 아무거나 가능하다.
# 1) 검토, 결측, 이상=>결측, 컬럼 추가, 결측제거, 분석, 시각화
# 2) 검토, 결측, 이상=>결측, 분석(컬럼 추가, 결측제거), 시각화 
