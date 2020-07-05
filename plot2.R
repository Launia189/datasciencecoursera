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

# weekday
data2$Weekday <- weekdays(data2$Time, abbreviate=TRUE)
head(data2)

# plot
png(filename="~/plot2.png", width=480, height=480)
plot(data2$Time, data2$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
dev.off()




