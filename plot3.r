#Get file if its not present
if(!file.exists("exdata%2Fdata%2Fhousehold_power_consumption.zip")) {
  temp <- tempfile()
  download.file("http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
  file <- unzip(temp)
  unlink(temp)
}

#Make necessary cleaning
data <- read.csv2("household_power_consumption.txt",sep=";", header = TRUE)
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
subdata <- data[(data$Date=="2007-02-01") | (data$Date=="2007-02-02"),]
subdata <- transform(subdata, datetime=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S")
subdata$Global_reactive_power <- as.numeric(as.character(subdata$Global_reactive_power))
subdata$Sub_metering_1 <- as.numeric(as.character(subdata$Sub_metering_1))
subdata$Sub_metering_2 <- as.numeric(as.character(subdata$Sub_metering_2))
subdata$Sub_metering_3 <- as.numeric(as.character(subdata$Sub_metering_3))
subdata$Global_active_power <- as.numeric(levels(subdata$Global_active_power))[subdata$Global_active_power]

#Make the hist plot
plot(subdata$datetime,subdata$Sub_metering_1,type = "l", col = "black", ylab = "Energy sub metering", xlab = "")
lines(subdata$datetime,subdata$Sub_metering_2, type="l", col="red")
lines(subdata$datetime,subdata$Sub_metering_3, type="l", col="blue")
legend("topright", cex = 0.50,col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

#Copy to file
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()

print("results in ")
getwd()