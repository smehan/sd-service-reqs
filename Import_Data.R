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
sd_req_df <- read.csv("Data/Service_Desk_8-1thru9-20.csv", header=TRUE, 
                       sep = ",", stringsAsFactors = FALSE)
# end

# Convert dates to posix date objects
sd_req_df$Date.Created <- mdy_hms(sd_req_df$Date.Created)
sd_req_df$Date.Closed <- mdy_hms(sd_req_df$Date.Closed)
sd_req_df$Date.Assigned <- mdy_hms(sd_req_df$Date.Assigned)
# end

##################################
# serialize the df
##################################
saveRDS(sd_req_df, file="Data/sd_req_df.RDS")

