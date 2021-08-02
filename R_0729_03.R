# ---------------------------------- #
# 데이터 전처리
# dplyr : 가장 중요한 분석 패키지
# library(dplyr)로 로드해야 사용할 수 있다.

# 많이 사용하는 함수
# filter(조건절) : 행 선택  # SQL where과 비슷
# select(컬럼) : 열 선택
# arrange(desc(컬럼)) : 정렬
# mutate() : 분석 시 변수(컬럼, 열) 추가
# summerise() : 분석결과의 통계
# group_by() : 그룹화
# left_join() : 기준컬럼으로 열 합치기
# bind_cols() : 기준없이 열 합치기
# bind_rows() : 행 합치기

# 소스 ---> 추출 ---> 요약

# 데이터 추출하기 - 행 추출하기
library(dplyr)
exam <- read.csv("csv_exam.csv")
exam

# exam에서 class가 1인 행 출력
exam %>% filter(class==1)

# exam에서 class가 2인 행 출력
exam %>% filter(class==2)

# exam에서 class가 1이 아닌 행 출력
exam %>% filter(class!=1)


# 행 출력 실습 ------------------------------------------------
# 수학 점수 50 이상
exam %>% filter(math>=50)

# 영어 점수 80 이상
exam %>% filter(english>=80)

# 1반이면서 수학점수가 50점 이상
exam %>% filter(class==1 & math>=50)

# 2반이면서 영어 점수가 80점 이상
exam %>% filter(class==2 & english>=80)

# 수학점수가 90점 이상이거나 영어점수가 90점 이상
exam %>% filter(math>=90 | english>=90)

# 영어 점수가 90점 미만이거나 과학점수가 50점 미만
exam %>% filter(english<90 | science<50)

# 1, 3, 5반 해당
exam %>% filter(class==1 | class==3 | class==5)
exam %>% filter(class %in% c(1,3,5))  # %in%을 이용
exam %>% filter((class %% 2) != 0)  # 나머지 %%

# 1반 정보를 추출하여 변수 class1에 대입
class1 <- exam %>% filter(class==1)
class1

# 2반 정보를 추출하여 변수 class2에 대입
class2 <- exam %>% filter(class==2)
class2

# ---------------------------------- #
# 데이터 추출하기 - 열추출하기
# 데이터 셋 exam %>% select(컬럼,,,,, -제외컬럼)
exam

# exam에서 수학컬럼 추출
exam %>% select(math)

# exam에서 영어컬럼 추출
exam %>% select(english)

# exam에서 반,수학,영어 추출
exam %>% select(class, math, english)

# exam에서수학컬럼 제외
exam %>% select(-math)

# exam에서 수학, 영어 컬럼 제외
exam %>% select(-math, -english)


# ---------------------------------- #
# 데이터 추출하기 - 행과 열 모두 추출하기
# 데이터셋 %>% 행추출 %>% 열추출
exam

# exam에서 클래스가 1인 것 중에서 영어만 추출
exam %>% filter(class==1) %>% select(english)

# exam에서 id과 math 중에서 처음 6행만 출력
exam %>% select(id, math) %>% head()


#-----------------------------------------------------
# 데이터 정렬 arrange()  # SQL에서 order by 기능능
exam %>% arrange(math)  # 수학점수 올림차순
exam %>% arrange(desc(math))  # 수학점수 내림차순
# 2차 정렬, 반으로 먼저 정렬 후 같은반은 수학점수 올림차순
exam %>% arrange(class, math) 


#-----------------------------------------------------
# 새로운 컬럼 추가하기
# exam %>% mutate(새컬럼 = 기존+기존)

# 영어 수학 과학의 총점 total 컬럼 생성
exam %>% mutate(total = math+english+science)

# 평균 avg 추가
exam  %>% mutate(total = math+english+science) %>% mutate(avg = total/3)


# exam에서 과학점수가 60점 이상이면 pass 아니면 fail인 컬럼 test 추가
exam %>% mutate(test = ifelse(science>=60,"pass","fail"))

# exam에서 총점을 구한 후 총점이 높은 순서부터터 출력
exam  %>% mutate(total = math+english+science) %>% arrange(desc(total))

