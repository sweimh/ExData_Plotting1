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


## open png file
png("plot2.png")

## charting - plot, line chart
plot(strptime(powerConsumption.workingset$DateTime,"%F %H:%M:%S")
    , powerConsumption.workingset$Global_active_power
    , type="l"
    , xlab = ""
    , ylab = "Global Active Power (kilowatts)")

## close and save png file
dev.off()

