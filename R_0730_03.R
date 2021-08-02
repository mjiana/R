# ------------------------------------- # 그래프 그리기
# ggplot2를 많이 사용한다

# 1단계: 배경 설정 (x축, y축)
# 2단계: 그래프 추가 (점, 선, 막대 등)
# 3단계: 설정 (축의 범위, 색, 표식 등)

# ------------------------------------- # 종류1: 산점도 그래프
# 변수간의 관계 표현 시 사용
# x축과 y축의 정비례, 반비례 등 확인 가능

library(ggplot2)
mpg

# 배기량(displ)이 고속도로 연비(hwy)와 어떤 관계인지 확인
# 1단계: 축 지정
ggplot(data = mpg, aes(x=displ, y=hwy))  

# 2단계: 점 그래프
ggplot(data = mpg, aes(x=displ, y=hwy)) + geom_point() 
# 임의 해석 : 배기량과 고속도로연비는 반비례 관계

# 3단계: 축의 범위 설정
ggplot(data = mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  xlim(3,6) +  # x축 범위 
  ylim(10,30)  # y축 범위



# ------------------------------------- # 종류2: 막대 그래프
# 집단간의 차이 표현 시 많이 사용
# ~별, ~마다 => 그룹화와 관련도 높음
# 예시: 드라이브별 고속도로 평균연비 비교

mpg <- as.data.frame(ggplot2::mpg)  # 데이터 재입력

df_mpg <- mpg %>% 
  group_by(drv) %>%
  summarise(mean_hwy=mean(hwy))

df_mpg

# 1단계 x,y축 지정
ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) 

# 2단계 막대그래프 : geom_col()
ggplot(data=df_mpg, aes(x=drv, y=mean_hwy)) + geom_col()

# 3단계 순서나열
# reorder(drv,-mean_hwy) -는 내림차순, 없으면 올림차순
ggplot(data=df_mpg, aes(x=reorder(drv,-mean_hwy), y=mean_hwy)) +  
  geom_col() 


# 비교 : geom_bar() 드라이브별 빈도(존재 개수)
ggplot(data=mpg, aes(x=drv)) + geom_bar()  # 빈도 그래프
table(mpg$drv)  # 빈도 표
# 4   f   r 
# 103 106  25


# 간단 구분
# geom_bar() : y축 = 빈도 / geom_col() : y축 = 값



# ------------------------------------- # 종류2: 선 그래프
# 시간에 따른 데이터 변화 표현 시 사용 - 시계열 데이터 처리

economics
# 날짜          ?   인구수 저축률           비고용
#  date         pce    pop psavert uempmed unemploy
#   <date>     <dbl>  <dbl>   <dbl>   <dbl>    <dbl>
# 1 1967-07-01  507. 198712    12.6     4.5     2944
# 2 1967-08-01  510. 198911    12.6     4.7     2945

# 시간에 따른 비고용 그래프 표시
boxplot(economics$unemploy)
boxplot(economics$unemploy)$stats
#       [,1]
# [1,]  2685
# [2,]  6280
# [3,]  7494
# [4,]  8692
# [5,] 12298


# 1단계
ggplot(data=economics, aes(x=date, y=unemploy))

# 2단계: 선그래프
ggplot(data=economics, aes(x=date, y=unemploy)) +geom_line()
# 임의해석 : 5년 주기로 고용률의 격차


# ------------------------------------- # 종류3 : 박스 그래프
# 집단간의 분포차이 표현 시 많이 사용
# geom_boxplot(): boxplot()을 여러개 보여주는 효과

# 드라이브별 고속도로연비 분포 비교
ggplot(data=mpg, aes(x=drv, y=hwy)) + geom_boxplot()


