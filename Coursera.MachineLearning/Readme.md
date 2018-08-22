# Machine Learnings: Barbel lifts perform prediction
Oliver Rojas  

## Introduction
Using sport it is now possible to collect a large amount of data about personal activity. These type of devices are part of the quantified self movement - a group of enthusiasts who take measurements about themselves regularly to improve their health, to find patterns in their behavior, or because they are tech geeks. One thing that people regularly do is quantify how much of a particular activity they do, but they rarely quantify how well they do it.

The goal of this report is to predict the manner in which some people did the exercise using the data from accelerometers placed on the belt, forearm, arm, and dumbell of six participants to predict how well they were doing the exercise in terms of the classification of the data. 



## Download data

#### Libraries


```r
library(dplyr); library(downloader); library(caret); library(randomForest); library(knitr)
```


#### Download the data


```r
# Download Data sets
train.url <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
test.url  <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"

download(train.url, "training.csv")
download(test.url, "testing.csv")
```


```r
# Load data
train <- read.csv("training.csv", stringsAsFactors = FALSE)
test  <- read.csv("testing.csv", stringsAsFactors = FALSE)
```


#### Description of the data


```r
dim(train)
```

```
## [1] 19622   160
```

```r
names(train)[160]
```

```
## [1] "classe"
```

```r
table(train$classe)
```

```
## 
##    A    B    C    D    E 
## 5580 3797 3422 3216 3607
```


The training data have 19622 observations and 160 variables, the target varible name is "classe" and the distribution of the clases to predict are in the table above.


## Preprocessing
I will only use columns with no missing data, so I must clean it before the model fitting in both train and test sets


```r
miss  <- apply(train, 2, function(var) {sum(is.na(var))})     # Count missing for every var
train <- train[, which(miss == 0)]
test  <- test[, which(miss == 0)]
```

The first 7 columns are identifier data, so I will drop it

```r
train <- select(train, -(1:7))
test  <- select(test, -(1:7))
```

There are no numeric variables that have no useful data, also drop it

```r
train$classe <- factor(train$classe)
test$problem_id <- factor(test$problem_id)

char <- NULL
for (i in 1:length(train)) { char[i] <- !is.character(train[[i]]) }
train <- train[,char]
test <- test[,char]
```


## Adjust prediction model

#### Selection of the model
The selected a method to build the model to predict the excersises was **Random Forest** algorithm, because of the accuracy of the method, speed it's not a problem, same as the interpretability issue, since the goal here is only to predict.

#### Data Spliting
In order to perform Cross Validation I choosed to split the data in Training and Test set in a 70/30 proportion


```r
cvindex <- createDataPartition(y = train$classe, p = 0.7, list = FALSE)
train <- train[ cvindex,]
cross <- train[-cvindex,]
```

#### Model fit
The model was fitted using Random forest method.


```r
fit <- randomForest(classe ~ ., data = train)
```

#### Cross-Validation perform
cross validation was performed in the test set created before. The out of sample error is expected to me small because of accuracy of the method selected. 


```r
predict <- predict(fit, cross)
confusionMatrix(cross$classe, predict)
```

```
## Confusion Matrix and Statistics
## 
##           Reference
## Prediction    A    B    C    D    E
##          A 1140    0    0    0    0
##          B    0  834    0    0    0
##          C    0    0  715    0    0
##          D    0    0    0  651    0
##          E    0    0    0    0  788
## 
## Overall Statistics
##                                      
##                Accuracy : 1          
##                  95% CI : (0.9991, 1)
##     No Information Rate : 0.2762     
##     P-Value [Acc > NIR] : < 2.2e-16  
##                                      
##                   Kappa : 1          
##  Mcnemar's Test P-Value : NA         
## 
## Statistics by Class:
## 
##                      Class: A Class: B Class: C Class: D Class: E
## Sensitivity            1.0000    1.000   1.0000   1.0000   1.0000
## Specificity            1.0000    1.000   1.0000   1.0000   1.0000
## Pos Pred Value         1.0000    1.000   1.0000   1.0000   1.0000
## Neg Pred Value         1.0000    1.000   1.0000   1.0000   1.0000
## Prevalence             0.2762    0.202   0.1732   0.1577   0.1909
## Detection Rate         0.2762    0.202   0.1732   0.1577   0.1909
## Detection Prevalence   0.2762    0.202   0.1732   0.1577   0.1909
## Balanced Accuracy      1.0000    1.000   1.0000   1.0000   1.0000
```


## Perdicting new cases
As part of this assignment I use the fitted model to predict the exercise category of 20 new test cases.


```r
test.predict <- predict(fit, test)
test.predict
```

```
##  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 
##  B  A  B  A  A  E  D  B  A  A  B  C  B  A  E  E  A  B  B  B 
## Levels: A B C D E
```


#### Exporting the data
Finaly the results was exported in text form and uploaded for grade.

```r
for (i in 1:20) {
file <- paste("anw", i, ".txt", sep="")
write.table(as.character(test.predict[i]), file, quote=FALSE, row.names=FALSE, col.names=FALSE)
}
```






































