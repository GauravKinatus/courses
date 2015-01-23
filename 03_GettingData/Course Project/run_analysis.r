# Coursera: Getting and Cleaning Data
# Project - creating a tidy data from UIC Human Activity Record dataset
# Author: Gaurav Garg <gaurav_garg@yahoo.com>

## This script performs the following:
#1. Merges the training and thetestsetstocreateonedataset.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the dataset
#4. Appropriately labels the data set with descriptive variable names.
#5. From the dataset in step4, creates a second,independent tidy dataset with the average of each
#   variable for each activity and each subject.

# read the files for the training subject
train.x <-read.table("X_train.txt")
train.y <- read.table("y_train.txt")
train.subjects <- read.table("subject_train.txt")
# read the files for the test subjects
test.x <-read.table("X_test.txt")
test.y <- read.table("y_test.txt")
test.subjects <- read.table("subject_test.txt")

#stich the data columns: sensor data, subject Id and the activity id.
train.table <- cbind(train.x, train.subjects, train.y)
#repeat for the process test subject
test.table <- cbind(test.x, test.subjects, test.y)
#merge training and test data
total.table <- rbind(train.table, test.table)

##Step3: Uses descriptive activity names to name the activities in the dataset

#read the features and set them as column names
data.col.names <- read.table("features.txt")
data.col.names_new <- make.names(data.col.names[,2],unique=TRUE) # if we dont use as.character, R uses "factor" as a class
colnames(total.table) <- c(as.character(data.col.names_new),"Subject", "Activity_Id")

#substitute the activity ids with activity names
activity.lookup.table <-read.table("activity_labels.txt", col.names=c("Activity_Id","Activity"))
total.table <- merge(total.table, activity.lookup.table, by='Activity_Id', all = TRUE)
total.table <- total.table[,-1] 

library(dplyr)
# subset the combined dataframe to include only the columns containing "mean" in the variable name.
total.table.filtered1 <- select(total.table,contains("mean"))

# subset the combined dataframe to include only the columns containing "std" in the variable name.
total.table.filtered2 <- select(total.table,contains("std"))

# combine the columns with Subject and Activity to create a full dataframe
total.table.filtered <- cbind(total.table.filtered1, total.table.filtered2)
total.table.filtered <- cbind(total.table.filtered1, total.table.filtered2, 
                              Subject=total.table$Subject, Activity = total.table$Activity)

library(reshape2)
HAR.Melt <- melt(total.table.filtered, id=c("Subject", "Activity"))
activity_data <- dcast(HAR.Melt,Subject+Activity~variable,mean)
write.table(activity_data,file="tidy_output.txt", row.names=FALSE)