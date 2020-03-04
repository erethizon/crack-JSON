rm(list =ls())
library(tidyr)
library(dplyr)
library(purrr)
library(repurrrsive)
library(jsonlite)


mydata<-read.csv("Data/test_JSON_annotations.csv",
                 sep = ",", stringsAsFactors = F)
#yields df with two columns, 2nd colum is json format

#create tibble
mydata<-tibble(entries = mydata)
#extract JSON column
mydata<-mydata %>% mutate(
  ann_data=map(entries$annotations, fromJSON, flatten = T))
#unnest first level JSON
mydata1<-mydata %>% unnest_wider(ann_data)

#unnest second level
mydata2<-mydata1 %>% unnest_wider(value) #why did names get messed up?

#now extract columns from value (not sure why this is unnest_longer rather that unnest_wider but it does what I want)
mydata3<-mydata2 %>% unnest_longer(...1)

#This is mostly what I want but leaves the "...1$answers.WHATBEHAVIORSDOYOUSEE" list element as having > 1 entry per column.  See below in output.

#Now save the data that I need, since these columns are not proper columns in mydata3.  See the behavior df below.

entries<-mydata3$entries[1]
choice<-mydata3$...1[1] #why did I get this `...1` naming?
how_many<-mydata3$...1[2]
snowdepth<-mydata3$...1[6]
behavior<-mydata3$...1[5]

desired<-cbind(entries, choice, how_many, snowdepth)

#save output
write.csv(desired, "desired_output.csv")
