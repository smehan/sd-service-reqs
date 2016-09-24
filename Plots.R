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
library(qcc)

###########################################################
### Class to model time series analysis
###########################################################

## get the dataframe loaded and cleansed in Import.R
sd_req_df <- readRDS("data/sd_req_df.RDS")

##### calculate # of days between created and closed and cast as integer
sd_req_df$tot_days <- as.integer(round((sd_req_df$New.Closed - sd_req_df$New.Created), 3))
# end

#### create subsets by year
sd_req_2015_df <- subset(sd_req_df, New.Created > '2015-01-01' &
                         New.Created < '2015-12-31')
sd_req_2016_df <- subset(sd_req_df, New.Created > '2016-01-01')
sd_req_1516_df <- subset(sd_req_df, New.Created > '2015-01-01')
### subset after visual management implemented in daily stand-up 
sd_req_2016_89 <- subset(sd_req_df, New.Created > '2016-08-01')
### subset after kanban implemented
sd_req_2016_9 <- subset(sd_req_df, New.Created > '2016-08-29')
#########

ggplot(sd_req_2016_df) +
  aes(x=sd_req_2016_df$New.Created.Day, y=sd_req_2016_df$tot_days) +
  geom_line()

ggplot(sd_req_2016_df) +
  aes(x=sd_req_2016_df$New.Created.Day, y=sd_req_2016_df$tot_days) +
  geom_point() +
  stat_smooth(method = 'lm', na.rm = TRUE) +
  xlab('SRS Ticket Created') +
  ylab('Total Days Open') +
  ggtitle('Service Desk SRS Tickets January 1 - September 20 2016')

qplot(sd_req_2015_df$tot_days,
      geom="histogram",
      binwidth = 10,  
      main = "Histogram SRS Tickets", 
      xlab = "SRS Tickets",  
      fill=I("blue"))

qplot(sd_req_2016_df$tot_days,
      geom="histogram",
      binwidth = 10,  
      main = "Histogram SRS Tickets", 
      xlab = "SRS Tickets",  
      fill=I("blue"))

####################################################################
## Plot 2015 and 2016 SRS tickets
## red lines indicate kanban implementation boundary
## green lines indicate visual management implementation boundary
####################################################################
ggplot() + 
  geom_line(data = sd_req_1516_df, 
            aes(x=New.Created, y=tot_days)) +
  geom_vline(xintercept=as.numeric(as.Date("2016-08-30")), 
             color = "red") +
  geom_text(aes(x=(xintercept=as.Date("2016-08-30")), label = "Kanban Implemented",
                y=200),
            color = "red",
            angle = 90,
            vjust = 1) +
  geom_vline(xintercept=as.numeric(as.Date("2016-08-01")), 
              color = "blue") +
  geom_text(aes(x=(xintercept=as.Date("2016-08-01")), 
                label = "Visual Management Implemented",
                y=200),
            color = "blue",
            angle = 90,
            vjust = 1) +
  geom_hline(yintercept = as.numeric(max(sd_req_2016_9$tot_days, na.rm=TRUE)),
              color = "red") +
  geom_hline(yintercept = as.numeric(max(sd_req_2016_89$tot_days, na.rm=TRUE)),  
              color = "blue") +
  geom_label(aes(x=as.Date("2015-03-01"),
                y=300, 
                label = "Horizontal lines represent \n max days to close"), 
            color = "azure4",
            vjust = 1) +
  ggtitle('Total Days to Close Service Desk Tickets 2015-2016') +
  labs(x="Ticket Create Date",y="Total Days to Close") +
  theme(legend.position='none') 

# TODO
# add time series script to show 2015 and 2016 overlayed plots

# Need to create a time-series for each variable of concern. Order them by a posix date.
sd_req_xts <- xts(sd_req_df$tot_days, order.by = sd_req_df$New.Created.Day)

### subset the time series into years for comparisons
# 2015
sd_req_15 <- window(sd_req_xts['2015'])
plot(sd_req_15[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)
# 2016
sd_req_16 <- window(sd_req_xts['2016'])
plot(sd_req_16[,1],major.ticks='months',minor.ticks=FALSE,main=NULL,col=3)

