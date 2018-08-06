setwd("~/user-analysis/Blade&Soul/code")
dev.off()
rm(list = ls())

tr_label <- read.csv('/Users/kyubonglee/Desktop/final_data_rev/train/train_label.csv')
#학습 대상 계정들의 고유 아이디 및 이탈 여부 (Retained, week, month, 2month)를 나타내는 파일

tr_activity <- read.csv('/Users/kyubonglee/Desktop/final_data_rev/train/train_activity.csv')
#유저의 인게임 활동량을 일주일 단위로 집계한 파일

tr_party <- read.csv('/Users/kyubonglee/Desktop/final_data_rev/train/train_party.csv')
#유저간 파티 구성 관계를 집계한 파일

colnames(tr_party)
head(tr_party$hashed)
glimpse(tr_party)
3 + 2






head(tr_label)
table(tr_label$label)


library(dplyr)
length(unique(tr_activity$acc_id))
dim(tr_activity)

object.size(tr_activity)


colnames(tr_activity)


set.seed(726)
sample_idx <- sample(nrow(tr_activity), size = 10000, replace = F)

sample_activity <- tr_activity[sample_idx, ]

head(sample_activity)
summary(sample_activity)
hist(sample_activity$cnt_clear_bam)


library(dplyr)
glimpse(sample_activity)

summary(tr_label)
head(tr_label, n = c(2600, 2700))
summary(tr_activity)
summary(tr_party)
colnames(tr_party)
head(tr_activity)
test1 <- tr_activity[tr_activity$acc_id == '3dc6f2875dc6e6f35b9e2bdb25b391a8003386ff23becd109415062b2bd58709', ]
rm(idx)
test2 <- tr_activity[tr_activity$acc_id == 'b8856358ff62e596fa07e3e40b8e7fd4b7729263c72b442803c4f22e41d6198b',]
tr_activity[idx, ]
idx
