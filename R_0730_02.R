# ------------------------------------- # mpg데이터 이상치 처리
library(ggplot2)
mpg <- as.data.frame(ggplot2::mpg)

# ------------------------------------- # 고속도로 연비 boxplot 출력
# 그림으로 보기
boxplot(mpg$hwy)

# 통계로 찾기
boxplot(mpg$hwy)$stats
#       [,1]
# [1,]   12  <------- 미만 극단치
# [2,]   18
# [3,]   24
# [4,]   27
# [5,]   36 <-------- 초과 극단치 




# 결과 확인 후 12미만, 37 이상은 이상치로 처리하기로 결정

# 이상치 => 결측치 전환
mpg$hwy <- ifelse(mpg$hwy < 12 | mpg$hwy >= 37, NA, mpg$hwy)

# 빈도 측정
table(is.na(mpg$hwy))  # TRUE == NA, 결측치

# 분석 - 드라이브별 평균 고속도로 연비
library(dplyr)
# 1. na.rm=T
mpg %>% group_by(drv) %>% summarise(mean_hwy=mean(hwy, na.rm=T))

# 2. 필터링으로 처리
mpg %>% group_by(drv) %>% filter(!is.na(hwy)) %>% 
  summarise(mean_hwy=mean(hwy))

