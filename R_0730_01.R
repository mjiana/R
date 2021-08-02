# ------------------------------------- # 데이터 정제하기
# 데이터 정제 : 분석이 용이한 데이터로 바꾼다
# 데이터 전처리라고도 한다.

# 결측치 : 데이터가 없는 경우 해결방법
# 이상치 : 존재해서는 안되는 값이 있는 경우 해결방법

rm(df)  # 기존 df 객체 삭제

# DB / program : null, R : NA | None
df <- data.frame(gender=c("M","F",NA,"M","F"),
                 score=c(5,4,3,4,NA))
mean(df$score)  # NA 때문에 연산 불가
sum(df$score)  # NA 때문에 연산 불가


# ------------------------------------- # is.na()
# NA 확인 함수

library(dplyr)

df %>% filter(is.na(score))  # score에 NA가 있는 행 반환

no_na_df <- df %>% filter(!is.na(score)) # score에 NA가 없는 행 반환
mean(no_na_df$score)  # 4

df %>% filter(!is.na(score) & !is.na(gender))  # 모든 컬럼에 NA가 없는 행 반환

na.omit(df)  # 모든 컬럼에 NA가 없는 행 반환


# ------------------------------------- # 집계함수 내부의 NA처리 속성
# na.rm = T

mean(df$score, na.rm = T)  # 4
sum(df$score, na.rm = T)  # 16

# ------------------------------------- # 인위적으로 NA 추가하기
exam <- read.csv("csv_exam.csv")
exam[c(3,8,15),"math"] <- NA  # 수학컬럼의 3, 8, 15행에 NA대입
exam

exam %>% summarise(mean_math=mean(math))  # NA

# ------------------------------------- # NA 제거 방법
exam %>% summarise(mean_math=mean(math, na.rm = T))  # 55.23529

exam %>% summarise(mean_math=mean(math, na.rm = T),
                   median_math=median(math, na.rm = T),
                   sum_math=sum(math, na.rm = T))

# ------------------------------------- # NA 치환 방법

# NA 빈도 측정 : 매우 중요, 기억하기 
table(is.na(exam$math))  # true == NA  # 3

# NA를 0으로 치환
exam$math <- ifelse(is.na(exam$math),0,exam$math)
table(is.na(exam$math))  # true == NA  # 0

exam  # NA가 모두 0으로 치환되어 사라졌다.

mean(exam$math)  # 46.95
sum(exam$math)  # 939


# ------------------------------------- # 이상치 처리하기
# 이상치 --> 결측치 --> 제거 / 치환 후 사용

board <- data.frame(gender=c(1,2,3,1,2),
                    score=c(5,6,7,4,7))
board

# gender 컬럼 이상치 3은 결측치로
board$gender <- ifelse(board$gender==3, NA, board$gender)
board


# score가 6보다 크면 NA 할당
board$score <- ifelse(board$score>6, NA, board$score)
board


# 전처리 및 분석
board %>% 
  filter(!is.na(gender) & !is.na(score)) %>%
  group_by(gender) %>% 
  summarise(mean_score=mean(score))





