#-----------------------------------------------------
# 데이터 병합하기
test1 <- data.frame(id=c(1,2,3,4,5),
                    midterm=c(60,80,70,90,85))
test2 <- data.frame(id=c(1,2,3,4,5),
                    final=c(70,83,65,95,80))
test1
test2

# 컬럼병합 : left_join(data1, data2,by="기준컬럼")
# test1과 test2를 id를 기준으로 병합
total <- left_join(test1, test2,by="id") # id:기준컬럼
total


#-----------------------------------------------------
# 도전
# exam에 담임 배정
# teacher컬럼 : 1반 kim, 2반 lee, 3반 park, 4반 choi, 5반 jung
# dataframe t_name을 만들고 기존의 exam과 병합

t_name <- data.frame(class=c(1,2,3,4,5),
                teacher=c("kim","lee","park","choi","jung"))
exam2 <- left_join(exam, t_name, by="class")
exam2

# bind_cols(data1, data2) : 기준컬럼없이 열과 열을 그냥 합친다. 

#-----------------------------------------------------
# 행병합 : bind_rows(data1, data2)

groupA <- data.frame(id=c(1,2,3,4,5),
                     test=c(60,80,70,90,85))
groupB <- data.frame(id=c(6,7,8,9,10),
                     test=c(70,83,65,95,80))
groupALL <- bind_rows(groupA, groupB)
groupALL



