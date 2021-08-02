# ===================================== #
# 변수
# 입력값에 따라서 데이터 형이 결정되는 동적 데이터형 사용

a <- 1
a
b <- 2
c <- 3
a+b+c  # 6


# 1부터 5까지의 일련번호 만들기
var1 <- c(1,2,3,4,5)
var1  # 1 2 3 4 5

var2 <- c(1:5)
var2  # 1 2 3 4 5

var3 <- seq(1,5)
var3  # 1 2 3 4 5


# 1에서 10까지 2씩 증가
var4 <- seq(1,10, by=2)
var4  # 1 3 5 7 9


# ===================================== #
# 문자열 취급
str1 <- "a"
str1
class(str1)  # "character"

str2 <- "text"
str2
class(str2)  # "character"

str3 <- "Hello R"
str3
class(str3)  # "character"

str4 <- c("a","b","c")
str4

str5 <- c("Hello","is","my","world")
str5  # "Hello" "is"    "my"    "world"
length(str5)  # 4

# ===================================== #
# 함수

x <- c(1,2,3,4,5,6,7)
mean(x)  # 평균값 4
max(x)  # 최대 7
min(x)  # 최소 1

# 콤바인(c()) 요소를 하나의 문자열로 합치기
s = c("a","b","c","d","e")
paste(s, collapse = ",")  # "a,b,c,d,e"
paste(s, collapse = " ")  # "a b c d e"
paste(s, collapse = ":")  # "a:b:c:d:e"
paste(s, collapse = "")  # "abcde"

# ===================================== #
# 초간단 그래프
# install.packages("ggplot2")  # 이미 설치 되어있다
# 로드
library(ggplot2)
x <- c("a","a","c","c","a","b","d")  # 순서 상관없음
x
# 빈도 그래프 만들기 : 사용빈도 매우 높음
# 해당 요소가 몇번 나오는가
qplot(x)

# ===================================== #
# 무조건 그려보는 그래프
# 바 그래프는 빈도를 나타낼 때 많이 사용한다.
# ggplot2 내부 mpg 내장데이터

# hwy : 고속도로 연비
qplot(data=mpg, x=hwy)
# cty : 도시 연비
qplot(data=mpg, x=cty)
# 라인은 시계열 데이터 표현에 많이 사용된다.
# drv : 전륜,후륜,4륜 
qplot(data=mpg, x=drv, y=hwy, geom="line")

# 박스플롯 boxplot
# 통계에 많이 사용된다. : 중요
# 데이터 정제 시 이상치 등등 제거할때 참조 가능
qplot(data=mpg, x=drv, y=hwy, geom="boxplot")

# drv별로 색상 표현하기, color colour 둘다 가능
qplot(data=mpg, x=drv, y=hwy, geom="boxplot", color=drv)

