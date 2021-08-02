# 외부데이터 가져오기
#엑셀,  csv형태가 많다.


# 오른쪽 하단 Pakages탭 안쓰고 명령으로 설치할 때
# install.pakages("readxl") 


# 패키지 로드
library(readxl)


# 1. 
df_exam <- read_excel("excel_exam.xlsx")
df_exam 


# 2. 컬럼명이 없는 경우
# 컬럼명이 없으면 데이터 첫줄을 컬럼명으로 사용한다
df_exam_novar <- read_excel("excel_exam_novar.xlsx")
df_exam_novar
# 속성 col_names = F를 추가하면 임의의 컬럼이 생긴다.
df_exam_novar <- read_excel("excel_exam_novar.xlsx", col_names = F)
df_exam_novar


# 3. 엑셀문서에서 다른 시트에서 불러오기
# 속성 sheet = 3 
df_exam_sheet <- read_excel("excel_exam_sheet.xlsx", sheet = 3)
df_exam_sheet


# csv파일 로드
df_csv_exam <- read.csv("csv_exam.csv")
df_csv_exam  # 컬럼명이 있다.


# Factor(펙터) : 범주형
# 범주형 데이터 : 남/녀, 상/중/하 와 같이 중간에 다른 값이 포함될 수 없는 값

# csv파일 로드 : 요소가 String인 경우 펙터로 인식할건가?
# 속성 stringsAsFactors = F 문자열을 팩터로 인식할지 여부
# 위 속성은 통계치를 낼때 달라진다.
df_csv_exam <- read.csv("csv_exam.csv",stringsAsFactors = F)
df_csv_exam  # 

# csv파일로 결과 내보내기
df_midterm <- data.frame(eng=c(90,80,70,60), 
                         math=c(50,60,100,20),
                         ban=c(1,1,2,2))  # 범주형에서는 2개
df_midterm
# 데이터 프레임을 csv파일로 저장
# 실행 후 오른쪽 하단 Files탭에 바로 보인다.
write.csv(df_midterm, file="df_midterm.csv")


# R기본파일로 내보내기 (.rda)
save(df_midterm, file="df_midterm.rda")

# .rda 읽기
rm(df_midterm)  # 객체 삭제
load("df_midterm.rda")  # 로드하면서 객체 생성
df_midterm

