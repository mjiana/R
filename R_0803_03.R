# ------------------------ # 자연어 처리 / 텍스트 마이닝
# ------------ # 패키지 설치 
install.packages("rJava")
install.packages("memoise")
install.packages("KoNLP")  # 설치 불가, 
# 별도 압축 파일로 설치 
# 복사 위치 C:/Program Files/R/R-4.1.0/library
# 압축파일 해제 - 폴더생성 안함


Sys.getenv("JAVA_HOME")  # "C:\\Java\\jdk1.8.0_201"
install.packages(c("stringr","hash","tau","Sejong",
                   "RSQLite","devtools","hask")) 
# hask 설치 안됨

library("tau")
library("rJava")
library("hash")
# library("hask")
library("vctrs")
library("Sejong")
library("RSQLite")
library("KoNLP")

useNIADic()
# R studio를 관리자모드로 실행해야 오류가 나지 않는다.

# ------------ # 힙합 가사 텍스트 마이닝
# hiphop.txt
library("dplyr")

txt <- readLines("hiphop.txt")
head(txt)


# stringr을 이용해서 문서 내부 특수문자 제거
library("stringr")
txt <- str_replace_all(txt,"\\W"," ")  # W 대문자 
head(txt)


# extractNoun()함수를 이용한 명사 추출
extractNoun("대한민국의 영토는 한반도와 그 부속도서로 한다")
# "대한민국" "영토"     "한반도"   "부속도서" "한"   


# ------------ # hiphop.txt에서 명사를 추출하여 변수에 저장
nouns <- extractNoun(txt)
class(nouns)  # list


# ------------ # 
wordcount <- table(unlist(nouns))
class(wordcount)  # table  빈도표
head(wordcount, 30)


# ------------ # 빈도표 데이터프레임으로 전환, 
# stringsAsFactors : 스트링을 팩터로 인식할 것인지 선택
df_word <- as.data.frame(wordcount, stringsAsFactors = F)
head(df_word)

# love love love hi hi a  ==> string(단어)일 경우 love 3, h2, a 1
# love love love hi hi a  ==> factors(구성요소)일 경우 3종류


# ------------------------ # 전처리 가공

# ------------ # 1. 컬럼명 수정 : Var1 => word, Freq => freq
df_word <- rename(df_word,word=Var1,freq=Freq)
head(df_word)

# ------------ # 2. word컬럼이 2글자 이상인 것만 선택
df_word <- filter(df_word, nchar(word) >= 2)
head(df_word)

# ------------------------ # 워드클라우드 그리기
install.packages("wordcloud")
library(wordcloud)
library(RColorBrewer)

# 색상표 준비
pal <- brewer.pal(20, "Dark2")
# Dark2 색상표에서 8가지 색상 추출 
set.seed(1234)
wordcloud(
  words = df_word$word,  # 단어
  freq = df_word$freq,  # 빈도 
  min.freq = 2,  # 최소 빈도
  max.words = 200,  # 사용할 단어의 최대 개수
  random.order = F,  # 무작위 순서 여부, 고빈도 단어를 중앙 배치한다.
  rot.per = 0.1,  # 단어의 회전비율
  scale = c(2,0,3),  # 단어크기 범위
  colors = pal
  )

# 색상표 준비
pal <- brewer.pal(9, "Reds")  # Blues  Reds
set.seed(1234)  # 특정한 목적을 위해 같은 순서의 난수를 만든다.
wordcloud(
  words = df_word$word,  # 단어
  freq = df_word$freq,  # 빈도 
  min.freq = 2,  # 최소 빈도
  max.words = 200,  # 사용할 단어의 최대 개수
  random.order = F,  # 무작위 순서 여부, 고빈도 단어를 중앙 배치한다.
  rot.per = 0.15,  # 단어의 회전비율
  scale = c(4,0,5),  # 단어크기 범위
  colors = pal
)

# hiphop에서 가장 많이 나오는 단어 10개 출력 후 그래프
hh <- df_word %>% arrange(desc(freq)) %>% head(10)
library(ggplot2)
ggplot(data=hh, aes(x=reorder(word,freq), y=freq, fill=reorder(word,freq))) + 
  geom_col()

# 범례 순서를 변경하려면 fill에서 reorder를 넣는다.

