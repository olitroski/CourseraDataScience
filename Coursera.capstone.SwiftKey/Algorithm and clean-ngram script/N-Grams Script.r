## Versión final de la captura de N-Grams
setwd("D:/GoogleDrive/Coursera/10 Capstone project")
library(stringi)    # Para limpiar
library(dplyr)      # Parar algún data management
library(quanteda)   # For N-Grams


## Loading the data ---------------------------------------------------------------------
# ...stop...

# Create connection in binary mode to avoid rare stuff, read and take sample of 5%
con <- file("en_US.twitter.txt", "rb", encoding = "UTF-8")
twitter <- readLines(con, encoding = "UTF-8", skipNul = TRUE); close(con)
twitter <- sample(twitter, length(twitter)*0.05)

con <- file("en_US.blogs.txt", "rb", encoding = "UTF-8")
blogs <- readLines(con, encoding = "UTF-8", skipNul = TRUE); close(con)
blogs <- sample(blogs, length(blogs)*0.05)

con <- file("en_US.news.txt", "rb", encoding = "UTF-8")
news <- readLines(con, encoding = "UTF-8", skipNul = TRUE); close(con)
news <- sample(news, length(news)*0.05)

# Final sample
sample <- c(twitter, blogs, news)
saveRDS(sample, "01.sample.rds")



## Cleaning -----------------------------------------------------------------------------
sample <- readRDS("01.sample.rds")

# Clean the sample using Stringi package
sample <- stri_trans_tolower(sample)
sample <- stri_enc_toascii(sample)
sample <- stri_replace_all_regex(sample,'\032','')
sample <- stri_replace_all_regex(sample,"(?!')[[:punct:]]", ' ')
sample <- stri_replace_all_regex(sample,'[[:digit:]]+',' ')
sample <- stri_replace_all_regex(sample, "\\s[bcdefghjklmnopqrstuvwxyz]\\s", " ")
sample <- stri_replace_all_regex(sample, "[<>=\\$\\_]", " ")
sample <- stri_replace_all_regex(sample,'[[:space:]]+',' ')
saveRDS(sample, "02.clean.sample.rds")



## Get and clean the n-grams ------------------------------------------------------------
sample <- readRDS("02.clean.sample.rds")


# A little function to  capture the ngrams into a data frame
NG <- function(tokendata, ng=1) {
     # Get the packages
     require(quanteda); require(dplyr)
     
     # Get tokenize version of ngrams from quanteda package
     data <- tokenize(tokendata, ngrams = ng)

     # With te result, who is a list with the ngram-tokenization process
     data <- unlist(data)
     data <- table(data)
     data <- as.data.frame(data)
     data <- arrange(data, -Freq) %>% filter(Freq>1)
     
     # Remove "_" character if ngram>1
     if (ng>1) {data$data <- gsub("_", " ", data$data)}
     return(data)
}


# Make the fucking ngrams, for good now.
ngram1 <- NG(sample, 1)
ngram2 <- NG(sample, 2)
ngram3 <- NG(sample, 3)
ngram4 <- NG(sample, 4)
ngram5 <- NG(sample, 5)
ngram6 <- NG(sample, 6)


# Split ngrams in columns ---------------------------------------------------------------
grams <- c("ngram1", "ngram2", "ngram3", "ngram4", "ngram5", "ngram6")

for (gram in grams) {
     # Write table
     eval(parse(text=paste("input  <- ", gram, "$data", sep="")))
     write.table(input, "temp.txt", quote=FALSE, row.names=FALSE, 
                 col.names=FALSE,  fileEncoding="UTF-8")
     
     # Read and fix ngrams
     temp <- read.table("temp.txt", sep=" ", quote="$", stringsAsFactors = FALSE)
     freq <- eval(parse(text=paste("input  <- ", gram, "$Freq", sep="")))
     temp <- data.frame(temp, freq)
     
     # Replace the ngram
     eval(parse(text= paste(gram, " <- temp", sep="")))
}

# Save the ngrams
saveRDS(ngram1, "ngram1.rds")
saveRDS(ngram2, "ngram2.rds")
saveRDS(ngram3, "ngram3.rds")
saveRDS(ngram4, "ngram4.rds")
saveRDS(ngram5, "ngram5.rds")
saveRDS(ngram6, "ngram6.rds")