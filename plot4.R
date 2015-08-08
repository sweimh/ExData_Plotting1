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
png("plot4.png")

## partition chart into 2x2 slots, margin: bottom:left:top:righ <=> 4:4:4:2
par(mfrow = c(2, 2), mar = c(4,4,4,2))

## top left
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
     , powerConsumption.workingset$Global_active_power
     , ylab = "Global Active Power"
     , xlab = ""
     , type = "l"
)
    
## top right
##set right numeric data types for "Voltage"
powerConsumption.workingset$Voltage <- setNumeric(powerConsumption.workingset$Voltage)
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
     , powerConsumption.workingset$Voltage
     , ylab = "Voltage"
     , xlab = "datetime"
     , type = "l"
)
    
## bottom left
powerConsumption.workingset$Sub_metering_1 <- setNumeric(powerConsumption.workingset$Sub_metering_1)
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
     , powerConsumption.workingset$Sub_metering_1
     , type="l"
     , xlab = ""
     , ylab = "Energy sub metering"
     , yaxt="n"
)
    
  powerConsumption.workingset$Sub_metering_2 <- setNumeric(powerConsumption.workingset$Sub_metering_2)
  lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
        , powerConsumption.workingset$Sub_metering_2
        , type="l"
        , col = "red"
      )
    
  powerConsumption.workingset$Sub_metering_3 <- setNumeric(powerConsumption.workingset$Sub_metering_3)
  lines(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
        , powerConsumption.workingset$Sub_metering_3
        , type="l"
        , col = "blue"
      )
    
  legend("topright"
         , lty=1, bty="n"
         , legend= c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
         , col=c("black","red","blue")
       )
    
  axis(2, at = seq(0, 30, by = 10))
    
##bottom right
##set right numeric data types for "Global_reactive_power"
powerConsumption.workingset$Global_reactive_power <- setNumeric(powerConsumption.workingset$Global_reactive_power)
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
     , powerConsumption.workingset$Global_reactive_power
     , ylab = "Global_reactive_power"
     , xlab = "datetime"
     , type = "l"
)

dev.off()