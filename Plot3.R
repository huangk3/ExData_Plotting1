##set the work directory;
setwd("~/Documents/Coursera/R_Programing/assignment")

##Download the data file from the url;
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","household_power_consumption", method = "curl")

##unzip the downloaded data to current directory and delete the zipped one;
unzip("household_power_consumption")
file.remove("household_power_consumption")

##get the column class of the data;
initial<-read.table("household_power_consumption.txt", sep=';', header = TRUE, nrows=10)
Classes<-sapply(initial, class)

## Content of "Classes" shows the columns 3-8 are factor variable; 

##read the file into dataset;
household_power_consumption<-read.table("household_power_consumption.txt", sep=';', header = TRUE,nrows=2075259, na.strings = "?")

##Change the format of Date column and store it; 
date<-strptime(household_power_consumption$Date, "%d/%m/%Y")

##subset date to the beginning two days of 2007Feb;
target_date<-date>=strptime("01/02/2007", "%d/%m/%Y")&date<strptime("03/02/2007", "%d/%m/%Y")

##subset the data frame to the two days;
subdata<-household_power_consumption[target_date, ]

## remove the household_power_consumption data object to release memory;
rm (household_power_consumption)
##convert the format of column 3-8 to be numeric; 
for(i in c(3:8)) {subdata[,i] <- as.numeric(as.character(subdata[,i]))}

#concatenate the date and time to generate continues time line.
d<-strptime(paste(subdata$Date, subdata$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
newdata<-data.frame(d, subdata)

##open a png device;
png(file="Plot3.png")

##Plot the graph of the "Sub_metering_1" variable Without showing the line;
with(newdata, plot(d, Sub_metering_1, xlab="", ylab="Energy sub metering", type="n", main=("")))
##add the lines for each sub metering and the legends;
with(newdata, lines(d, Sub_metering_1, col = "black", type = "l"))
with(newdata, lines(d, Sub_metering_2, col = "red", type = "l"))
with(newdata, lines(d, Sub_metering_3, col = "blue", type = "l"))
legend("topright", lty=c(1,1,1), col=c("black", "red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
##Close the png device
dev.off()
