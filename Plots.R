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

sd_req_2016_df <- subset(sd_req_df, New.Created > '2016-08-01')

##### calculate # of days between created and closed and cast as integer
sd_req_2016_df$tot_days <- as.integer(round((sd_req_2016_df$New.Closed - sd_req_2016_df$New.Created), 3))
# end

plot(sd_req_2016_df$New.Created.Day, sd_req_2016_df$tot_days)

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

###########################################################
## Create scatter plots of SRS request data
###########################################################

ggplot(sd_req_2016_df) +
  aes(x=New.Created.Day, y=tot_days) +
#  geom_point(aes(color = Dept)) +
#  geom_jitter() +
  ggtitle("SRS Tickets") +
  labs(x="Day", y="Duration")

# Need to create a time-series for each variable of concern. Order them by a posix date.
tot_closed_xts <- xts(sd_req_df$tot_days, order.by = sd_req_df$New.Created.Day)

# Plot time-series curve for the month of August, 2014.
plot.ts(tot_closed_xts['2016-01'], main="SRS Tickets per day\nSince August 1, 2016",
        xlab="Day", ylab="Count", col="red")




###########################################################
## Plot multiple time series plots to compare years
###########################################################
autoplot(tot_closed_xts, facet=NULL) +
  ggtitle('All SRS Tickets')
