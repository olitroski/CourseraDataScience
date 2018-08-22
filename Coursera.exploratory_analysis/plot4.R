# Exploratory data analysis - Project #1
# PLOT 4

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


## Plot 4 -------------------------------------------------------------------------------------
png(filename = "plot4.png", width = 480, height = 480, units = "px", bg = "white")
par(mfrow = c(2, 2), mar = c(5, 5, 2, 2), cex=.5)

## Plot 4-1
plot(data$date_time, data$Global_active_power,     # Set blank plot
     xaxt=NULL, xlab = "", ylab = "Global Active Power", type="n")  
lines(data$date_time, data$Global_active_power, type="S")   # Add the line plot


## Plot 4-2
plot(data$date_time, data$Voltage,              # Set blank plot
     xaxt=NULL, xlab="datetime", ylab="Voltage", type="n")
lines(data$date_time, data$Voltage, type="S")   # Add line plot


## Plot 4-3
plot(data$date_time, data$Sub_metering_1,       # set the plot
xaxt=NULL, xlab = "", ylab = "Energy sub metering", type="n")
# Add lines
lines(data$date_time, data$Sub_metering_1, col = "black", type = "S")
lines(data$date_time, data$Sub_metering_2, col = "red"  , type = "S")
lines(data$date_time, data$Sub_metering_3, col = "blue" , type = "S")
# Add legent
legend("topright", lty = c(1, 1), lwd = c(1, 1, 1), bty = "n",
col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))


## Plot 4-4
plot(data$date_time, data$Global_reactive_power,              # Set blank plot
     xaxt=NULL, xlab="datetime", ylab="Global_reactive_power", type="n")
lines(data$date_time, data$Global_reactive_power, type="S")   # Add line plot

# Close
dev.off()
