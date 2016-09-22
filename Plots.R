###########################################################
### Load packages
###########################################################
library(stringr)
library(purrr)
library(plyr)
library(ggplot2)
library(lubridate)
library(xts)
library(forecast)

###########################################################
### Class to model time series analysis
###########################################################

## get the dataframe loaded and cleansed in Import.R
sd_req_df <- readRDS("data/sd_req_df.RDS")

sd_req_2016_df <- subset(sd_req_df, New.Created > '2015-01-01')

##### calculate # of days between created and closed and cast as integer
sd_req_2016_df$tot_days <- as.integer(round((sd_req_2016_df$New.Closed - sd_req_2016_df$New.Created), 3))
# end

ggplot(sd_req_2016_df) +
  aes(x=sd_req_2016_df$New.Created.Day, y=sd_req_2016_df$tot_days) +
  geom_line()

ggplot(sd_req_2016_df) +
  aes(x=sd_req_2016_df$New.Created.Day, y=sd_req_2016_df$tot_days) +
  geom_point() +
  stat_smooth(method = 'lm', na.rm = TRUE) +
  xlab('SRS Ticket Created') +
  ylab('Total Days Open') +
  ggtitle('Service Desk SRS Tickets August 1 - September 20')


ggplot(sd_req_2016_df) +
  aes(sd_req_2016_df$tot_days) + 
  geom_histogram()
