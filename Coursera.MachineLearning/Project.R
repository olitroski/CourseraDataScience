## Proyecto coursera Practical Machine Learning
rm(list=ls())
setwd("D:/")
library(dplyr); library(downloader); library(caret); library(randomForest)


# Data sets
train.url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test.url  <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download(train.url, "training.csv")
download(test.url, "testing.csv")
rm(test.url, train.url)

train <- read.csv("training.csv", stringsAsFactors = FALSE)
test  <- read.csv("testing.csv", stringsAsFactors = FALSE)

dim(train)
names(train)[160]
table(train$classe)    # 5 levels Ok, var id = 160



## Preprocessing
# I will only use columns with no missing data, so I must clean before calculations in both train and test sets
miss  <- apply(train, 2, function(var) {sum(is.na(var))})     # Count missing for every var
train <- train[, which(miss == 0)]
test  <- test[, which(miss == 0)]


# The first 7 columns are identifier data, so I will drop it
train <- select(train, -(1:7))
test  <- select(test, -(1:7))


# There are no numeric variables that have no useful data, also drop it
train$classe <- factor(train$classe)
test$problem_id <- factor(test$problem_id)

char <- NULL
for (i in 1:length(train)) { char[i] <- !is.character(train[[i]]) }
train <- train[,char]
test <- test[,char]

rm(list=setdiff(ls(), c("test", "train")))



## Cross validation
# I will use a train/test split strategy to crossvalidation with a 70/30 partition
cvindex <- createDataPartition(y = train$classe, p = 0.7, list = FALSE)
train <- train[ cvindex,]
cross <- train[-cvindex,]


## Prediction model
fit <- randomForest(classe ~ ., data = train)

## crossvalidate the model 
predict <- predict(fit, cross)
confusionMatrix(cross$classe, predict)


## PRedict in the testeing data
test.predict <- predict(fit, test)


# make files to upload 
for (i in 1:20) {
file <- paste("anw", i, ".txt", sep="")
write.table(as.character(test.predict[i]), file, quote=FALSE, row.names=FALSE, col.names=FALSE)
}
