# read data in from working directory
data1 <- read.table("~/household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?")
head(data1)

# subset data 
data2 <- subset(data1, grepl("^[1,2]/2/2007", data1$Date), value=TRUE)
head(data2)

# format Date
data2$Date <- as.character(data2$Date)
data2$Date <- as.Date(data2$Date, format="%d/%m/%Y")
head(data2)
class(data2$Date)

# format Time
data2$Time <- paste(data2$Date, data2$Time)
data2$Time <- strptime(data2$Time, format="%Y-%m-%d %H:%M:%S")
head(data2)
class(data2$Time)

# plots
png(filename="~/plot4.png", width=480, height=480)
par(mfrow=c(2,2))
plot(data2$Time, data2$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")

plot(data2$Time, data2$Voltage, type="l", xlab="datetime", ylab="Voltage")

plot(data2$Time, data2$Sub_metering_1, type="l", xlab="", ylab="Energy sub metering")
lines(data2$Time, data2$Sub_metering_2, type="l", col="red")
lines(data2$Time, data2$Sub_metering_3,  type="l", col="blue")
legend("topright", c("Sub metering 1","Sub metering 2", "Sub metering 3"), lty=1, lwd=2, col=c("black", "red", "blue"))

plot(data2$Time, data2$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")

dev.off()




