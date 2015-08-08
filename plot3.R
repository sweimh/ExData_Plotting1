library("data.table")
## read in full data table
powerConsumption <- data.table(
  read.table(
    file.path(getwd(), "household_power_consumption.txt"), header=TRUE, sep=";"
  )
)

## subset data to two days
powerConsumption.workingset <- subset(powerConsumption, Date %in% c("1/2/2007","2/2/2007"))

## convert Global_ative_power to character then to number (directly as.numeric conversion changes value)
powerConsumption.workingset$Global_active_power <- 
  as.numeric(
    as.character(
      powerConsumption.workingset$Global_active_power
    )
  )

## create date subset
dateSet <- powerConsumption.workingset$Date  
dateSet <- strptime(dateSet, "%e/%m/%Y")

## create time subset
timeSet = powerConsumption.workingset$Time

## join date & time into a new Date Time column
## paste is joining date & time, but result column is not truely datetime formate
powerConsumption.workingset$DateTime <- paste(dateSet, timeSet)

## open png file
png("plot3.png")

## create plot layer one, no y-axis text (yaxt)
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
       , powerConsumption.workingset$Sub_metering_1
       , type="l"
       , xlab = ""
       , ylab = "Energy sub metering"
       , yaxt="n")

## plot 2nd data series as layer two
lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
          , powerConsumption.workingset$Sub_metering_2
          , type="l"
          , col = "red")

## plot 3rd data series as layer three
lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
          , powerConsumption.workingset$Sub_metering_3
          , type="l"
          , col = "green")

## add chart legend as layer four
legend("topright", lty=1, 
       legend= c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","green"))

## add y-axis w/ specific scaling as layer five
axis(2, at = seq(10, 30, by = 10), las=2)

dev.off()