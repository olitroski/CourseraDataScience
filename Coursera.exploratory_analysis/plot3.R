# Exploratory data analysis - Project #1
# PLOT 3

# Libraries - Workdirectory
setwd("D:/")
library(lubridate); library(dplyr); library(downloader)

## Download & unzip ----------------------------------------------------------------------------
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download(url, "zipdata.zip")
unzip("zipdata.zip")
dir()   # Check


## Open donwloaded file ------------------------------------------------------------------------
# I want to open the entire file and then subset
data <-  read.table("household_power_consumption.txt", header=TRUE, sep=";", nrow=5)
clase <- sapply(data, class); clase[1:2] <- "character"
data <-  read.table("household_power_consumption.txt", header=TRUE, sep=";", colClasses=clase, na.string = "?")
     # There are some missing marked as "?", that's why na.string option

# Some calculations for later    
data$date_time <- paste(data$Date, data$Time)
data$Date <- dmy(data$Date)

# Subset data base from
data <- filter(data, Date>=dmy("01-02-2007") & Date<=dmy("02-02-2007"))
table(data$Date)   #check

# Use strptime to parse date_time var - Format is: "1/2/2007 00:00:00"
data$date_time <- strptime(data$date_time, "%d/%m/%Y %H:%M:%S")
head(data$date_time)     #check


## Plot 3 -------------------------------------------------------------------------------------
png(filename = "plot3.png", width = 480, height = 480, units = "px", bg = "white")

par(mar = c(5, 5, 4, 2))
# set the plot
plot(data$date_time, data$Sub_metering_1,
      xaxt=NULL, xlab = "", ylab = "Energy sub metering", type="n")

# Add lines
lines(data$date_time, data$Sub_metering_1, col = "black", type = "S")
lines(data$date_time, data$Sub_metering_2, col = "red"  , type = "S")
lines(data$date_time, data$Sub_metering_3, col = "blue" , type = "S")

# Add legent
legend("topright", lty = c(1, 1), lwd = c(1, 1, 1), 
     col = c("black", "red", "blue"), 
     legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# Close
dev.off()