# ------------------------------------- # 전문 분석 도전

# 프로젝트 데이터 필요
# Koweps_hpc10_2015_beta1.sav : 한국복지재단 패널데이터
# 2016년 6914가구, 16664명에 대한 정보를 담고 있다.

# spss 자료를 읽기 위해 foreign 패키지 설치여부 확인

# 분석 시 필요한 라이브러리 
library(foreign)  # spss 불러오기
library(dplyr)  # 분석툴
library(ggplot2)  # 시각화툴
library(readxl)  # 엑셀툴

raw_welfare <- read.spss(file="Koweps_hpc10_2015_beta1.sav",
                         to.data.frame=T)

welfare <- raw_welfare  # 복사본 생성

# 데이터 기본검사
dim(welfare)  # 16664개   957컬럼
str(welfare)  # 컬럼 대부분이 num데이터형이고, 컬럼명은 약어로 되어 있다.
summary(welfare)


# 분석이 가능하도록 컬럼명 변경
welfare <- rename(welfare,
                  sex=h10_g3,  # 성별
                  birth=h10_g4,  # 생일
                  marriage=h10_g10,  # 결혼유무
                  religion=h10_g11,  # 종교유무
                  income=p1002_8aq1,  # 월급
                  code_job=h10_eco9,  # 직종코드
                  code_region=h10_reg7)  # 지역코드

welfare %>% 
  select(sex,birth,marriage,religion,income,code_job,code_regoin) %>% 
  head(10)


