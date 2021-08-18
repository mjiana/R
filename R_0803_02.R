# ------------------------ # 지역별 연령대 비율
# ------------ # 확인
table(welfare$code_region) # 7개 지역으로 구별
#  1    2    3    4    5    6    7 
#2486 3711 2785 2036 1467 1257 2922
class(welfare$code_region)  # "numeric"

# ------------ # 지역을 분석하기 용이하도록 문자로 치환하기
# Koweps_Codebook.xlsx 시트1 7개 권역별 지역구분 값
# 1. 서울  2. 수도권(인천/경기)  3. 부산/경남/울산   
# 4.대구/경북  5. 대전/충남  6. 강원/충북  7.광주/전남/전북/제주도

# 데이터 프레임 생성 후 컬럼 병합
list_region <- data.frame(code_region=c(1:7), 
                          region=c("서울",
                                   "수도권(인천/경기)",
                                   "부산/경남/울산",
                                   "대구/경북",
                                   "대전/충남",
                                   "강원/충북",
                                   "광주/전남/전북/제주도"))
list_region

# code_region을 기준으로 열 병합
welfare <- left_join(welfare,list_region,id="code_region")

table(welfare$region)
table(is.na(welfare$region))  # NA 없음

# ------------ # 지역별 인구 수 출력
welfare %>% 
  group_by(region) %>% 
  summarise(n=n())


# ------------ # 지역별 노년층 비율을 올림차순으로 정렬 후 그래프 출력
# 노년층 비율 : (노인인구/지역별 인구)*100
table(ageg)
rg_old <- welfare %>% 
  group_by(region, ageg) %>%  # 7지역, 3연령대
  summarise(n=n()) %>% 
  mutate(tot=sum(n)) %>%  # 지역별 인구 수 
  mutate(older=(n/tot)*100) %>% # 각 연령별 비율 
  filter(ageg=="old") %>%  # 노년층 선택 
  arrange(older)  # 정렬 

rg_old

# 시각화 
ggplot(data=rg_old, 
       aes(x=reorder(region,older), y=older, fill=region)) + 
  geom_col() + coord_flip()




