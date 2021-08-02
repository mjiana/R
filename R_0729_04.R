library(dplyr)
#-----------------------------------------------------
# 요약통계 산출하기
# exam %>% summarise(새컬럼=그룹함수(컬럼))

# exam에서 수학 평균 요약 통계 산출
exam %>% summarise(mean_math=mean(math))

# 비교 : mutate를 사용하면 행이 추가되므로 모두 다 같은 값이 나온다.
exam %>% mutate(mean_math=mean(math))

# exam에서 수학 평균 요약 통계(최대, 최소, 중앙, 평균, 행개수) 산출
exam %>% summarise(max=max(math), 
                   min=min(math), 
                   median=median(math), 
                   mean=mean(math),
                   n=n())

#-----------------------------------------------------
# 그룹화
# exam %>% group_by(기준컬럼) ~별, ~ 마다

# exam에서 반별 수학 평균 구하기
exam %>% group_by(class) %>% summarise(mean=mean(math))

# exam에서 반별 수학의 총점 평균 최대 최소 학생수 출력력
exam %>% group_by(class) %>% summarise(max=max(math), 
                                       min=min(math), 
                                       median=median(math), 
                                       mean=mean(math),
                                       n=n())

# 만약 mpg 데이터셋이없는 경우 아래처럼 로드
mpg <- as.data.frame(ggplot2::mpg)
#-----------------------------------------------------
# 도전
mpg
# mpg 데이터에서 제조사, 드라이브 별 도시연비 평균 출력
mpg %>% group_by(manufacturer, drv) %>% 
  mutate(tot=mean(cty)) %>% 
  select(manufacturer, drv, cty, tot)

# mpg에서 제조사별 suv차량의 평균연비를 구하고,
# 평균연비를 요약하여 mean_tot에 추가한 뒤 높은 것부터 5줄만 출력
mpg %>% group_by(manufacturer) %>% 
  filter(class=="suv") %>% 
  mutate(tot=(cty+hwy)/2) %>%
  summarise(mean_tot=mean(tot)) %>% 
  arrange(desc(mean_tot)) %>%
  head(5)
  