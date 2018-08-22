## Script para mi algoritmo de prediccion, solo con n-grams
setwd("D:/GoogleDrive/Coursera/10 Capstone project")
library(stringi)    # Para limpiar
library(dplyr)      # Parar alg?n data management
library(quanteda)   # For N-Grams
`%notin%` <- function(x,y) !(x %in% y)   # <-- look at this... clever ah.


# Load the n-gram data
ngram1 <- readRDS("ngram1.rds")
ngram2 <- readRDS("ngram2.rds")
ngram3 <- readRDS("ngram3.rds")
ngram4 <- readRDS("ngram4.rds")
ngram5 <- readRDS("ngram5.rds")



## Function to process the text and parse the prediction algorithm -----------------------
textpred <- function(text, nsug=10)  {
# text <- "you can see the rain falling"

# A fix for NULL
if (nchar(text)==0) {
     return("Type a word")
} else {

# Cleaning using que same system as in my ngram task 'stringi package'
text <- stri_trans_tolower(text)
text <- stri_enc_toascii(text)
text <- stri_replace_all_regex(text,'\032','')
text <- stri_replace_all_regex(text,"(?!')[[:punct:]]", ' ')
text <- stri_replace_all_regex(text,'[[:digit:]]+',' ')
text <- stri_replace_all_regex(text,'[[:space:]]+',' ')
text <- stri_replace_all_regex(text, "\\s[bcdefghjklmnopqrstuvwxyz]\\s", " ")
text <- tokenize(text)
text <- unlist(text)


# Extract information about the text
ntext <- length(text)
# nsug <- 10     # Suggested words

     # what if i have more than 5 words
     if (ntext > 4) {
          text <- text[(ntext-3):length(text)]
          ntext <- length(text)
     }


## 1 Word -> Ngram=2 --------------------------------------------------------------------
if (ntext == 1) {
     word <- filter(ngram2, ngram2[1] == text)
     word <- slice(word, 1:nsug)
     word <- select(word, word=dim(word)[2]-1, freq=dim(word)[2])
     
     # Less than 10 words -> look for in Ngram=1
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Drop words already found in ngram1
          add <- filter(ngram1, V1 %notin% have)
          add <- add[1:n,]
          # Complete to 10
          names(add) <- c("word", "freq")
          word <- rbind(word, add)
     }



## 2 Word -> Ngram=3 --------------------------------------------------------------------
} else if (ntext == 2) {
     word <- filter(ngram3, ngram3[1] == text[1])     
     word <- filter(word, word[2] == text[2])
     word <- slice(word, 1:nsug)
     word <- select(word, word=dim(word)[2]-1, freq=dim(word)[2])
     
     # Less than 10 words -> look for in NGram=2
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Cut a word for the left and Do a search 
          text2 <- text[2:length(text)]
          add   <- filter(ngram2, V1 == text2)
          add   <- filter(add, V2 %notin% have)
          # Complete to 10
          add <- add[1:n,]
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          word <- rbind(word, add)
     }

     # Less than 10 words -> look for in Ngram=1
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Drop words already found in ngram1
          add <- filter(ngram1, V1 %notin% have)
          add <- add[1:n,]
          # Complete to 10
          names(add) <- c("word", "freq")
          word <- rbind(word, add)
     }    



## 3 Word -> Ngram=4 --------------------------------------------------------------------
} else if (ntext == 3) {
     word <- filter(ngram4, ngram4[1] == text[1])
     word <- filter(word, word[2] == text[2])
     word <- filter(word, word[3] == text[3])
     word <- slice(word, 1:nsug)
     word <- select(word, word=dim(word)[2]-1, freq=dim(word)[2])

     # If <10 look for Ngram=3
     if (dim(word)[1] < nsug) {  
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Cut a word for the left and Do a search 
          text3 <- text[2:length(text)]          
          add <- filter(ngram3, ngram3[1] == text3[1])
          add <- filter(add, add[2] == text3[2])
          add <- filter(add, V3 %notin% have)
          add <- slice(add, 1:n)
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          # Complete to 10
          word <- rbind(word, add)
     
     }

     # Less than 10 words -> look for in NGram=2
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Cut a word for the left and Do a search 
          text2 <- text[3:length(text)]
          add   <- filter(ngram2, V1 == text2)
          add   <- filter(add, V2 %notin% have)
          # Complete to 10
          add <- add[1:n,]
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          word <- rbind(word, add)
     }

     # Less than 10 words -> look for in Ngram=1
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Drop words already found in ngram1
          add <- filter(ngram1, V1 %notin% have)
          add <- add[1:n,]
          # Complete to 10
          names(add) <- c("word", "freq")
          word <- rbind(word, add)
     }  



## 4 Word -> Ngram=5 --------------------------------------------------------------------
} else if (ntext == 4) {
     word <- filter(ngram5, ngram5[1] == text[1])
     word <- filter(word, word[2] == text[2])
     word <- filter(word, word[3] == text[3])
     word <- filter(word, word[4] == text[4])    
     word <- slice(word, 1:nsug)
     word <- select(word, word=dim(word)[2]-1, freq=dim(word)[2])
     
     # if <10 look for Ngram=4
     if (dim(word)[1] < nsug) {  
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word     
          # Cut a word for the left and Do a search 
          text4 <- text[2:length(text)]    
          add <- filter(ngram4, ngram4[1] == text4[1])
          add <- filter(add, add[2] == text4[2])
          add <- filter(add, add[3] == text4[3])
          add <- filter(add, V4 %notin% have)
          add <- slice(add, 1:n)
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          # Complete to 10
          word <- rbind(word, add)          
     }


     # If <10 look for Ngram=3
     if (dim(word)[1] < nsug) {  
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Cut a word for the left and Do a search 
          text3 <- text[2:length(text)]          
          add <- filter(ngram3, ngram3[1] == text3[1])
          add <- filter(add, add[2] == text3[2])
          add <- filter(add, V3 %notin% have)
          add <- slice(add, 1:n)
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          # Complete to 10
          word <- rbind(word, add)
     
     }

     # Less than 10 words -> look for in NGram=2
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Cut a word for the left and Do a search 
          text2 <- text[3:length(text)]
          add   <- filter(ngram2, V1 == text2)
          add   <- filter(add, V2 %notin% have)
          # Complete to 10
          add <- add[1:n,]
          add <- select(add, word=dim(add)[2]-1, freq=dim(add)[2])
          word <- rbind(word, add)
     }

     # Less than 10 words -> look for in Ngram=1
     if (dim(word)[1] < nsug) {
          # Save founds
          n   <- nsug - dim(word)[1]
          have <- word$word
          # Drop words already found in ngram1
          add <- filter(ngram1, V1 %notin% have)
          add <- add[1:n,]
          # Complete to 10
          names(add) <- c("word", "freq")
          word <- rbind(word, add)
     }  

}  # Fin del if


# Dejarlo bonito
len  <- seq(from = 1, to = dim(word)[1], by=1)
word <- mutate(word, NextWord = word, ProbRank=len) %>% select(-freq, - word)
return(word)

}
} # Fin de la funci?n

