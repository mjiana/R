# ===================================== #
# 데이터 셋 만들기
# 매우 중요한 기본과정

english <- c(90,80,60,70)
english

math <- c(50, 60, 100, 20)
math

# data set으로 생성하기
df_midterm <- data.frame(english, math)
df_midterm
#   english math
# 1      90   50
# 2      80   60
# 3      60  100
# 4      70   20

# 수학 평균 # 하위항목 $ 표시
mean(df_midterm$math)  # 57.5
# 영어 총점
sum(df_midterm$english)  # 300

# 데이터 프레임에 반컬럼 추가
class <- c(1,1,2,2)
df_midterm <- data.frame(english,math,class)
df_midterm
#   english math class
# 1      90   50     1
# 2      80   60     1
# 3      60  100     2
# 4      70   20     2


