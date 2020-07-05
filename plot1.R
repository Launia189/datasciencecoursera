# read data in from working directory
data1 <- read.table("~/household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?")
head(data1)

# subset data 
data2 <- subset(data1, grepl("^[1,2]/2/2007", data2$Date), value=TRUE)

# plot
png(filename="~/plot1.png", width=480, height=480)
hist(data2$Global_active_power, main="Global Active Power", col="red", xlab="Global Active Power (kilowatts)")
dev.off()


