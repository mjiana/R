# 미국 주별 강력범죄율 단계 구분도
install.packages("ggiraphExtra")
library(ggiraphExtra)

# 검토
head(USArrests)
str(USArrests)
# 주 이름에 컬럼명이 없다.
# 컬럼명에 대소문자가 섞여있다.
# 컬럼은 정수와 실수로 구성되어 있다.


# tibble : 데이터프레임 대신 사용 가능
# 심플한 데이터 프레임 : 대용량 데이터를 간단/간략하게 표현
# data.frame은 문자로 구성된 데이터가 factor로 인식 되는 경우가 종종 있다.
# tibble은 문자로만 인식된다.
library(tibble)

# 주 state 컬렴명 추가
crime <- rownames_to_column(USArrests, var="state")
head(crime)

# state 컬럼 값 소문자로 변경
crime$state <- tolower(crime$state)
# 컬럼명 소문자 변경
colnames(crime) <- tolower(colnames(crime))
head(crime)

library(ggplot2)

# 지도 데이터로 변경
states_map <- map_data("state")
str(states_map)
# $ long     : num 경도  -87.5 -87.5 -87.5 -87.5 -87.6 ...
# $ lat      : num 위도  30.4 30.4 30.4 30.3 30.3 ...
# $ group    : num  1 1 1 1 1 1 1 1 1 1 ...
# $ order    : int  1 2 3 4 5 6 7 8 9 10 ...
# $ region   : chr  "alabama" "alabama" "alabama" "alabama" ...
# $ subregion: chr

# 지도 시각화
ggChoropleth(data=crime, # 지도에 표시할 데이터
             aes(fill=murder,  # 살인으로 색상 구분
                 map_id=state),  # 지역기준
                 map=states_map)  # 지도 데이터

# 인터랙티브(반응형) 지도 시각화
ggChoropleth(data=crime, # 지도에 표시할 데이터
             aes(fill=murder,  # 살인으로 색상 구분
                 map_id=state),  # 지역기준
             map=states_map,   # 지도 데이터
             interactive = T)  # 인터랙티브 설정








