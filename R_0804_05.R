# 통계 분석 기법을 이용한 가설 검정
# 분석하는 데이터가 분석할 가치가 있는지 확인

# 통계 분석 : 기술 통계 - 데이터의 값을 요약해서 설명
#             추론 통계 - 어떤 값이 발생할 확률을 계산  

# 유의하다 : 의미가 있다.
# 유의하지않다 : 의미를 둘 필요가 없다.

# 유의 확률 - 실제로는 집단간의 차이가 없는데 
#             우연히 그 차이가 발생할 확률

# 유의 확률이 크다 - 집단간의 차이가 유의하지 않다.
#                  - 우연히 발생할 확률이 커서 의미를 두지 않는다.

# 유의 확률이 작다 - 집단간의 차이가 유의하다 
#                  - 우연히 발생할 확률이 적으니, 의미 있다.


# ------------ # t 검정
# 두 집단(빈도)의 평균을 비교하는 것 

# compact와 suv를 cty를 기준으로 비교하는 것 
mpg <- as.data.frame(ggplot2::mpg)
library(dplyr)
mpg_diff <- mpg %>% 
            select(class, cty) %>%  # 자동차 기종과 도시연비
            filter(class %in% c("compact","suv"))

head(mpg_diff)
#     class cty
# 1 compact  18
# 2 compact  21
# 3 compact  20
# 4 compact  21
# 5 compact  16
# 6 compact  18
table(mpg_diff)
#         cty
# class    9 11 12 13 14 15 16 17 18 19 20 21 22 24 26 28 33
# compact  0  0  0  0  0  2  3  4  7  5  5 12  3  2  2  1  1
# suv      2 13  6 13 12  7  2  1  3  1  2  0  0  0  0  0  0

table(mpg_diff$class)
# compact  suv 
# 47       62 

# t검정
# var.equal=T : 집단간 분포가 같다고 가정 
t.test(data=mpg_diff,cty~class, var.equal=T)

# 결과 -------------------------------------
# Two Sample t-test
# 
# data:  cty by class
# t = 11.917, df = 107, p-value < 2.2e-16
# alternative hypothesis: true difference in means between group compact and group suv is not equal to 0
# 95 percent confidence interval:
#   5.525180 7.730139
# sample estimates:
#   mean in group compact     mean in group suv 
# 20.12766              13.50000

# 해석 : p-value(유의확률) < 2.2e-16
# 판단 : p-value가 5%보다 적으면 '유의하다', 5%보다 크면 '유의하지 않다'라고 해석
# 결론 : compact와 suv의 도시연비 차이는 유의하다.
#        즉, 분석할 가치가 있다.

# ------------ # 
# mpg데이터의 도시연비cty와 연료 fl(r레귤러, p프리미엄)간의 t검정 
mpg_diff2 <- mpg %>% select(fl, cty) %>%
            filter(fl %in% c("r", "p")) 

table(mpg_diff2$fl)
# p   r 
# 52 168

t.test(data=mpg_diff2, cty ~ fl, var.equal=T)
# 결과 ---------------------------------------------
# Two Sample t-test
# 
# data:  cty by fl
# t = 1.0662, df = 218, p-value = 0.2875
# alternative hypothesis: true difference in means between group p and group r is not equal to 0
# 95 percent confidence interval:
#   -0.5322946  1.7868733
# sample estimates:
#   mean in group p mean in group r 
# 17.36538        16.73810

# 해석 : p-value = 0.2875 => 유의확률 약 28% ==> 5%를 초과했다.
# 레귤러r과 프리미엄p를 도시연비로 비교하는 것은 유의하지 않다.


# ------------ # 상관관계 분석하기
# 연속되는 두 변수가 어떤 관계가 있는지 검정하는 통계 분석
# 관계 : 도시연비cty와 연료fl의 관계, 
#        자동차 기종class과 도시연비cty의 관계
# 정비례 / 반비례 등으로 나타난다.

# economics에서 실업자 수와 개인 소비지출 간의 관계 검정
economics <- as.data.frame(ggplot2::economics)
cor.test(economics$unemploy, economics$pce)

# 결과 -----------------------------
# Pearson's product-moment correlation
# 
# data:  economics$unemploy and economics$pce
# t = 18.63, df = 572, p-value < 2.2e-16
# alternative hypothesis: true correlation is not equal to 0
# 95 percent confidence interval:
#  0.5608868 0.6630124
# sample estimates:
#       cor 
# 0.6145176 

# 해석 
# p-value < 2.2e-16 : 5%미만이므로 유의하다.
# cor 0.6145176 상관관계값이 양수이므로 정비례 관계  


# ------------ # 상관관계 히트맵 만들기
# 데이터셋 내부의 모든 컬럼의 상호 상관관계 행렬그래프 

head(mtcars)
#                   mpg cyl disp  hp  drat   wt   qsec vs am gear carb
# Mazda RX4         21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
# Mazda RX4 Wag     21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
# Datsun 710        22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
# Hornet 4 Drive    21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
# Hornet Sportabout 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
# Valiant           18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

# 1) 상관행렬 생성
car_cor <- cor(mtcars)
round(car_cor, 2)  # 소수점 두자리

install.packages("corrplot")
library(corrplot)

# 상관관계 히트맵 그래프 - 색상 강약으로 표현
corrplot(car_cor)  # 히트맵

# 상관관계 히트맵 그래프 - 수치로 표현하기
corrplot(car_cor, method = "number")


# 3줄 정리--------
# 1. t.test : t검정, 두 집단의 차이를 비교하는 것이 의미있는가?
# 2. cor.test : 상관관계 - 연속되는 두 데이터의 관계 - 정/반비례 
# 3. cor hip map : 데이터셋 내의 모든 컬럼들의 상호 상관관계 




