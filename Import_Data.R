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
sd_req <- read.csv("Data/SD_Requests_1-1-15_thru_9-30-16.csv", header=TRUE, 
                       sep = ",", stringsAsFactors = FALSE)
# end

factor(sd_req$Status)