# plotly 패키지를 이용한 인터랙티브 그래프 만들기

library(plotly)
library(ggplot2)

# 배기량, 고속도로연비, 드라이브 변수간의 관계
# 그래프가 출력되지만 반응이 없다.
pt <- ggplot(data=mpg, aes(x=displ, y=hwy, col=drv)) + geom_point()


# 인터랙티브 그래프 
ggplotly(pt)


# diamonds
head(diamonds)

pt2 <- ggplot(data=diamonds, aes(x=cut, fill=clarity)) + 
  geom_bar(position="dodge")

ggplotly(pt2)


# dygraphs 패키지를 이용한 인터랙티브 시계열 그래프
install.packages("dygraphs")
library(dygraphs)

# economics 데이터 로드
economics <- ggplot2::economics

# 검토
head(economics)  # 1967-07-01 부터
tail(economics)  # 2015-04-01 까지
dim(economics)  # 574행 6열
str(economics)
# $ date    : Date[1:574], format: "1967-07-01" ...
# $ pce     : num [1:574] 507 510 516 512 517 ...
# $ pop     : num [1:574] 198712 198911 199113 199311 199498 ...
# $ psavert : num [1:574] 12.6 12.6 11.9 12.9 12.8 11.8 11.7 12.3 11.7 12.3 ...
# $ uempmed : num [1:574] 4.5 4.7 4.6 4.9 4.7 4.8 5.1 4.5 4.1 4.6 ...
# $ unemploy: num

# xts : 시계열 데이터를 처리하는 패키지
library(xts)
eco <- xts(economics$unemploy, order.by = economics$date)
head(eco)

# 그래프
dygraph(eco)

# 날짜 범위 선택기능이 하단에 표시 된다
dygraph(eco) %>% dyRangeSelector()


# 시간에 따른 저축률psavert의 변화를 그래프로 표시
eco_p <- xts(economics$psavert, order.by = economics$date)
dygraph(eco_p) %>% dyRangeSelector()

# 시간에 따른 실업자 수 unemply/1000의 변화 그래프 표시
# 저축률과 함께 표시하기에 값 차이가 너무 크기 때문에 /1000을 한다.
eco_u <- xts(economics$unemploy/1000, order.by = economics$date)
dygraph(eco_u) %>% dyRangeSelector()


# 시간에 따른 저축률과 실업자 수의 변화를 모두 그래프로 표시
eco2 <- cbind(eco_p, eco_u)  # 데이터 결합
colnames(eco2) <- c("psavert","unemploy")  # 컬럼명 추가

dygraph(eco2) %>% dyRangeSelector()

