# 라이브러리
library("tau")
library("rJava")
library("hash")
library("vctrs")
library("Sejong")
library("RSQLite")
library("KoNLP")

useNIADic()  
# R Studio 바로가기 속성 - 호환성탭 - 관리자 권한으로 실행
# 설정해놓으면 바로 실행 가능하다.


# ------------------------ # 국정원 트윗 분석
# ------------ # 로드
twitter <- read.csv("twitter.csv", 
                    header = T,  # 컬럼명 존재
                    stringsAsFactors = F,
                    fileEncoding = "UTF-8")


# ------------ # 검토
head(twitter)  # 컬럼명이 한글로 존재한다.
dim(twitter)  # 자료크기 측정 : 3743행 * 5열 
str(twitter)  # 전체 데이터형 검사
# $ X       : int => 불필요 데이터, 나중에 삭제
# $ 번호    : int
# $ 계정이름: chr 
# $ 작성일  : chr 
# $ 내용    : chr 


# ------------ # 한글 컬럼명 수정
library(dplyr)

# rename(변수명, 새 명칭 = 기존 명칭)
twitter <- rename(twitter, no=번호, id=계정이름, date=작성일, tw=내용)
str(twitter)  # 전체 데이터형 검사
# $ X   : int 
# $ no  : int 
# $ id  : chr  
# $ date: chr 
# $ tw  : chr 


# ------------ # 특수문자 제거
library(stringr)

twitter$tw <- str_replace_all(twitter$tw, "\\W", " ")
head(twitter$tw)


# ------------ # 명사 테이블 생성
# 명사 리스트
nouns <- extractNoun(twitter$tw)
# 빈도 테이블
wordcount <- table(unlist(nouns))


# ------------ # 데이터 프레임 전환
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
head(df_word)


# ------------ # 변수(컬럼)명 변경
df_word <- rename(df_word, word=Var1, freq=Freq)
head(df_word)


# ------------ # 2글자 이상만 추출
df_word <- filter(df_word, nchar(word) >= 2)
head(df_word)


# ------------ # 빈도수 높은 단어 상위 100개
top100 <- df_word %>% arrange(desc(freq)) %>% head(100)
top100


# ------------ # 시각화
library(ggplot2)

# 빈도수 높은 단어 상위 20개
top20 <- df_word %>% arrange(desc(freq)) %>% head(20)
top20

# 기본
ggplot(data=top20, aes(x=word, y=freq, fill=word)) + 
  geom_col() + coord_flip()

# 정렬
ggplot(data=top20, 
       aes(x=reorder(word,-freq), y=freq, 
           fill=reorder(word,freq))) + 
  geom_col() + coord_flip()

# 빈도값 표시
ggplot(data=top20, 
       aes(x=reorder(word,-freq), y=freq, 
           fill=reorder(word,freq))) + 
  geom_col() + coord_flip() + 
  geom_text(aes(label=freq), hjust=-0.3)  # 빈도값 표현 코드


# ------------ # 클라우드 그래프 그리기
library(wordcloud)
library(RColorBrewer)

# 색상표 준비
pal <- brewer.pal(8, "Dark2")
# Dark2 색상표에서 8가지 색상 추출 
set.seed(1234)
wordcloud(
  words = df_word$word,  # 단어
  freq = df_word$freq,  # 빈도 
  min.freq = 2,  # 최소 빈도
  max.words = 200,  # 사용할 단어의 최대 개수
  random.order = F,  # 무작위 순서 여부, 고빈도 단어를 중앙 배치한다.
  rot.per = 0.05,  # 단어의 회전비율
  scale = c(4,0,1),  # 단어크기 범위
  colors = pal
)









