# Tidy data ---------------------------------------------------------


#trend_data3<- trend_data3%>%
# pivot_longer(c(`DC Comics: (United States)`, `Marvel Comics: (United States)`), names_to = "type", values_to = "close")

#trend_data3

#trend_data3$date <- mdy(trend_data3$date) 

#trend_data3$type <- as.factor(trend_data3$type)

#write.csv(trend_data3, '/Users/admin/Desktop/Stat651_DataViz/sta651_assignments/Gibson_Lydia_Stat651_Midterm1/Problem_02_replaced_data/Comics/Comics3.csv', row.names=FALSE)

#trend_description3 <- tibble(
# type = c("", ""),
#text = c("", "")
#) 

#trend_description3

library(shiny)
library(shinythemes)
library(dplyr)
library(readr)
library(tidyverse)
library(lubridate)


read_csv("multiTimeline-2.csv") %>% 
  pivot_longer(c(`DC Comics: (United States)`, `Marvel Comics: (United States)`), 
               names_to = "type", 
               values_to = "close") %>% 
  mutate(date = mdy(Day)) %>% 
  select(type, date, close) %>% 
  arrange(desc(type)) %>% 
  write_csv("/Users/admin/Desktop/Stat651_DataViz/sta651_assignments/Gibson_Lydia_Stat651_Midterm1/Problem_02_replaced_data/Comics/Comics4.csv")