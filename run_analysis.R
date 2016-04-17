## Tidy Data Project
## Script that performs the operations needed to clean some data
## course project for the "Getting and Cleaning Data" course
## author: Victor Zaldivar
## date : april 2016
## mail: vhzaldivar (at) gmail.com


## First Merge the train and test data sets in one

## read first dataset

## first we read the three files in the train directory to
## obtaint a single table with all the information
## 
## subject_train.txt should be the first column 
## X_train.txt are all the measures
## y_train.txt are the activity labels
## we take advantage of the col.names parameter to
## set the appropiate names to the columns of the data sets

## We make sure we are in the correct working directory

setwd("~/R_projects/UCI HAR Dataset")

tsubject <- read.table("./train/subject_train.txt", col.names = "SubjectID")
tlabels <- read.table("./train/y_train.txt", col.names = "ActivityID")
## for the third file (the feautures) we need to read the features names
## which are on the file "features.txt"
cnames <- read.table ("./features.txt", stringsAsFactors = FALSE)

## since the file has two columns we need to extract only the 
## second colummn

col_names <- cnames[,2]

tfeatures <- read.table("./train/X_train.txt", col.names = col_names)

## now we combine them into a single data frame
## first column is the subjectID, second is the activityLabel
## next 561 are the measures

train_df <- cbind(tsubject,tlabels, tfeatures)

## clean up to preserve memory
rm(tsubject, tlabels, tfeatures, cnames)

## We do the same for the files in the test directory

xsubject <- read.table("./test/subject_test.txt", col.names = "SubjectID")
xlabels <- read.table("./test/y_test.txt", col.names = "ActivityID")

## We use the features labels that we already have
xfeatures <- read.table("./test/X_test.txt", col.names = col_names)

## now we combine them into a single data frame
## first column is the subjectID, second is the activityLabel
## next 561 are the measures

test_df <- cbind(xsubject,xlabels, xfeatures)

## we do some clean up to preserve memory
rm(xsubject, xlabels, xfeatures)

## Finally we combine both data sets in one

mydf <- rbind(train_df, test_df)

## clean up

rm(train_df, test_df)

## we use grep to select only the mean and std of each measurement

mydf <- mydf[,grep("mean\\(|std\\(", col_names)]

## we change the activityID with the label corresponding to that activity
## to do that we are going to read the activity labels from the file
## activity_labels.txt and use its second columns as the labels for that factor
## we will use the mutate function from dyplr to change the data frame column

act_labels <- read.table("./activity_labels.txt", stringsAsFactors = FALSE)

library(dplyr)

mydf <- mutate(mydf, ActivityID = factor(ActivityID, labels = act_labels[,2]))

## clean up
rm(act_labels)

## write the tidy dataset to future use

write.table(mydf, "./tidyData.txt", row.names = FALSE, quote = FALSE)

## generate a new data set with the average values for each measurement
## we will use the group_by and summarize_each functions of the
## dyplr package

gr_df <- mydf %>% group_by(SubjectID,ActivityID) %>%
        summarise_each(funs(mean(.)))

## Save this data set to future use

write.table(gr_df, "./groupedData.txt", row.names=FALSE, quote = FALSE)



