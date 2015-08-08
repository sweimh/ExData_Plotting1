library("data.table")
## project assumes data file "household_power_consumption.txt" exists in the same directory as script

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

## function to clean up numeric columns
setNumeric <- function (value){
  as.numeric(
    as.character(
      value
    )
  )  
}

## open png file
png("plot3.png")

## create plot layer one, no y-axis text (yaxt)
powerConsumption.workingset$Sub_metering_1 <- setNumeric(powerConsumption.workingset$Sub_metering_1)
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
       , powerConsumption.workingset$Sub_metering_1
       , type="l"
       , xlab = ""
       , ylab = "Energy sub metering"
       , yaxt="n")

## plot 2nd data series as layer two
powerConsumption.workingset$Sub_metering_2 <- setNumeric(powerConsumption.workingset$Sub_metering_2)
lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
          , powerConsumption.workingset$Sub_metering_2
          , type="l"
          , col = "red")

## plot 3rd data series as layer three
powerConsumption.workingset$Sub_metering_3 <- setNumeric(powerConsumption.workingset$Sub_metering_3)
lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
          , powerConsumption.workingset$Sub_metering_3
          , type="l"
          , col = "blue")

## add chart legend as layer four
legend("topright", lty=1, 
       legend= c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"))

## add y-axis w/ specific scaling as layer five
axis(2, at = seq(0, 30, by = 10))

dev.off()