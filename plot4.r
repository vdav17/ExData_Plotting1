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

#Divide space for 4 charts
par(mfrow=c(2,2))

# Graph1
plot(subdata$datetime,subdata$Global_active_power,type = "l", col = "black", ylab = "Global Active Power", xlab = "")

# Graph2
plot(subdata$datetime,subdata$Voltage,type = "l", col = "black", ylab = "Voltage",xlab = "datetime")

# Graph3
plot(subdata$datetime,subdata$Sub_metering_1,type = "l", col = "black", ylab = "Energy sub metering", xlab = "")
lines(subdata$datetime,subdata$Sub_metering_2, type="l", col="red")
lines(subdata$datetime,subdata$Sub_metering_3, type="l", col="blue")
legend("topright", cex = 0.5, bty ="n",col=c("black","red","blue"), c("Sub_metering_1  ","Sub_metering_2  ", "Sub_metering_3  "),lty=c(1,1), lwd=c(1,1))

# Graph4
plot(subdata$datetime,subdata$Global_reactive_power,type = "l", col = "black", ylab = "Global_reactive_power",xlab = "datetime")


dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()

print("results in ")
getwd()




