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

## open png file
png("plot1.png")

## charting - histogram
hist(powerConsumption.workingset$Global_active_power
      , col="red"
      , main="Global Active Power"
      , xlab = "Global Active Power (kilowatts)"
     )

## close and save png file
dev.off()