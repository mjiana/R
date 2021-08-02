#-----------------------------------------------------
# 수집 --> 정제 --> 저장(파일) --> 데이터셋 -->  
# 전처리 --> 분석 데이터만 추출 --> 분석 --> 시각화 --> 보고서

1+1
2+2

# 할당 연산자 
a <- 123
a

# 크기가 있으면  : scalar 
# 방향을 갖으면  : vector 
# 두방향 갖으면  : matrix ===> data.frame 
# 세방향 갖으면  : tensor 

# R 버젼 확인할때 , charset 정보,OS정보,기본 패키지 
sessionInfo()

# lib 설치 위치 
.libPaths()
# 유저가 설치한것 
#[1] "C:/Users/soldesk/Documents/R/win-library/4.1"
# 프로그램 설치시 설치된것 
#[2] "C:/Program Files/R/R-4.1.0/library" 

# 패키지 목록 
search()

# 특정 패키지 정보 알아보기 
library(help="datasets")

# 패키지 설치하기 
install.packages(c("rpart","survival"))
# 패키지 제거하기 
remove.packages(c("rpart","survival"))

# 패키지 로드하기 : 사용빈도 매우 높음 
library("ggplot2")

# 내장 데이타 셋 확인 
data("mtcars")
head(mtcars)

# c( )   : 벡터 데이터를 만들어 줌 : 활용도가 매우 높음 
x <- c(0,2:4)
x
# [1] 0 2 3 4
class(x)
# [1] "numeric"

x2 <- c(1,2,3,4,5)
x2

# [1] 1 2 3 4 5

# as.변환함수(소스)  : 형변환 할때 사용함 
xx <- as.logical(x)
xx
# [1] FALSE  TRUE  TRUE  TRUE
class(xx)
# [1] "logical"
xxx <- as.numeric(xx)
xxx
# [1] 0 1 1 1

a <- c(1,2,3,4,5)
length(a)    #    3 요소의 갯수 
# 5 

a/2    # a가 벡터형이므로 각각의 요소를 2로 나누어 반환한다. 
# [1] 0.5 1.0 1.5 2.0 2.5 

# 벡터의 길이와 연산 
c(1,2,3,4,5) + c(5,4,3,2,1)
# [1] 6 6 6 6 6   같은 위치의 요소끼리 더함 
c(1,2,3,4,5) * 2 
# [1]  2  4  6  8 10   각각의 요소에 2를 곱한다. 

# 요소의길이가 다르고 비율이 배수인경우 
c(1,2,3,4,5,6) + c(1,2)
# [1] 2 4 4 6 6 8
c(1,2,3,4,5,6) * c(1,2,3)
# [1]  1  4  9  4 10 18

# 요소의길이가 다르고 비율이 배수가 아닌경우 
c(1,2,3,4,5,6,7) * c(1,2,3) 
# [1]  1  4  9  4 10 18  7
#Warning message:
#  In c(1, 2, 3, 4, 5, 6, 7) * c(1, 2, 3) :
#  longer object length is not a multiple of shorter object length

# 여러줄 주석
# 블럭 잡고 ctrl+shift+c