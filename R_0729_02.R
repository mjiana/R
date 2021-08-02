# 기본적인 데이터 분석 : 기초 검사
exam <- read.csv("csv_exam.csv")

# 앞 뒤 내용 읽기
head(exam)  # 앞에서 6행
head(exam, 10)  # 앞에서 10행
tail(exam)  # 뒤에서 6행
tail(exam, 10)  # 뒤에서 10행

# 뷰 창에서 보기
View(exam)

# 행렬분석 : 암기, 자주 사용
dim(exam)  # 20 5 : 20행 5열

# 전체 컬럼의 데이터형 분석
str(exam)

# 간이 통계 출력
summary(exam)

# 데이터 프레임으로 읽고 데이터 기초 검사
mpg <- as.data.frame(ggplot2::mpg)

head(mpg)
tail(mpg)
View(mpg)
dim(mpg)
str(mpg)
summary(mpg)



#---------------------------------------#
# 기본적인 데이터 프레임 다루기

# 데이터 프레임 설정
df_raw <- data.frame(var1=c(1,2,1), var2=c(2,3,2))
df_raw

# 복사본 생성
df_new <- df_raw
df_new

# 변수명(컬럼명) 변경하기
df_new <- rename(df_new, v2=var2)  # var2를 v2로 변경
df_new

# 파생변수(컬럼추가) 만들기
df <- df_raw
df
# 합계 변수 추가
df$var_sum <- df$var1+df$var2
df
# 평균 변수 추가
df$var_mean <- df$var_sum/2
df


# mpg데이터에서 도시연비와 고속도로 연비의 평균연비 컬럼을 추가하고,
# 상위 6행의 결과와 기본통계(summary)를 출력
head(mpg)
mpg$total <- (mpg$cty+mpg$hwy)/2
head(mpg)
head(mpg$total)
summary(mpg$total)

#---------------------------------------#
# 빈도그래프 
hist(mpg$total)  # 히스토그래프, 기본
library(ggplot2)
qplot(mpg$total)


# 평균연비로부터 20 이상이면 pass 아니면 fail 출력하는 변수 test
# 결과 확인 후 빈도그래프 그리기
# ifelse(조건, 참실행, 거짓실행)
mpg$test <- ifelse(mpg$total >= 20, "pass", "fail")
hist(mpg$test)   # 오류
# Error in hist.default(mpg$test) : 'x'은 반드시 수치형이어야 합니다
qplot(mpg$test)  # 성공

# 빈도표
table(mpg$test)
# fail pass 
# 106  128


# total에서 30 이상이면 A등급, 20 이상이면 B등급, 아니면 C등급으로 
# 표시하는 변수 grade를 추가하고 빈도표와 빈도그래프 그리기
mpg$grade <- ifelse(mpg$total >= 30, "A", 
                    ifelse(mpg$total >= 20, "B", "C"))
table(mpg$grade)
# A   B   C 
# 10 118 106
qplot(mpg$grade)


# 4단계로 나누기기
# 30이상 A, 25이상 B,20이상 C, 아니면 D로 분류하는
# 변수 grade2를 추가하고, 빈도표와 빈도 그래프 그리기
mpg$grade2 <- ifelse(mpg$total >= 30, "A", 
                     ifelse(mpg$total >= 25, "B", 
                            ifelse(mpg$total >= 20, "C", "D")))
table(mpg$grade2)
# A   B   C   D 
# 10  33  85 106 
qplot(mpg$grade2)
