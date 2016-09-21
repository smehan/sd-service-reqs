###########################################################
### Importing and cleansing Service Desk Request Data
###########################################################
library(ggplot2)
library(scales)
library(ggthemes)
library(plyr)
library(dplyr)
library(stringr)
library(reshape2)
library(lubridate)

# assemble the main datafile
sd_req <- read.csv("Data/Service_Desk_8-1thru9-20.csv", header=TRUE, 
                       sep = ",", stringsAsFactors = FALSE)
# end

factor(sd_req$Status)