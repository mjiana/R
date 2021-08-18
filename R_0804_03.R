# ------------ # 대한민국 
# 시도별 인구대비 결핵환자 수 단계 구분도 만들기

library(stringr)
library(devtools)

# 지도 데이터 로드
devtools::install_github("cardiomoon/kormaps2014")
library(kormaps2014)
# 오류날 경우 시스템 환경변수 Path에서 리눅스 명령어 경로 삭제 

library(dplyr)
library(ggiraphExtra)
library(ggplot2)

# ------------ # 인구 수
# 컬럼명 변경
str(changeCode(korpop1))
korpop1 <- rename(korpop1, 
                  pop=총인구_명, name=행정구역별_읍면동)

str(changeCode(korpop1))
# 한글 인코딩
korpop1$name <- iconv(korpop1 $name, "UTF-8", "CP949")

ggChoropleth(data=korpop1,  # 자료 데이터
             aes(fill=pop,  
                 map_id=code,  # 지역기준
                 tooltip=name),  # 지도에 표시할 지역명
             map=kormap1,  # 지도 데이터
             interactive = T)  # 인터랙티브 

# ------------ # 결핵환자 수
str(changeCode(tbc))
# 한글 인코딩
tbc$name <- iconv(tbc$name, "UTF-8", "CP949")
tbc$name <- iconv(tbc$name1, "UTF-8", "CP949")

str(changeCode(tbc))

# 인터랙티브 단계 그래프
ggChoropleth(data=tbc,  # 자료 데이터
             aes(fill=NewPts,  
                 map_id=code,  # 지역기준
                 tooltip=name),  # 지도에 표시할 지역명
             map=kormap1,  # 지도 데이터
             interactive = T)  # 인터랙티브 


