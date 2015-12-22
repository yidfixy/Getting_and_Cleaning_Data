#---------------------------------------------
# Author: Christopher Ryan
# Date: 12/21/2015
# Course: Getting and Cleaning Data
#---------------------------------------------
# Assignment Requirements:
# The purpose of this project is to demonstrate your ability to collect, 
# work with, and clean a data set. The goal is to prepare tidy data that 
# can be used for later analysis. You will be graded by your peers on a 
# series of yes/no questions related to the project. You will be required 
# to submit:
#
# 1) a tidy data set as described below, 
# 2) a link to a Github repository with your script for performing the analysis, and 
# 3) a code book that describes the variables, the data, and any transformations or 
#   work that you performed to clean up the data called CodeBook.md. You should also 
#   include a README.md in the repo with your scripts. This repo explains how all of 
#   the scripts work and how they are connected.  
#
# You should create one R script called run_analysis.R that does the following. 
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.

#Begin Code
#-----1. Merge training and test sets--------
#Download designated file
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile="incoming_data.zip")
file_date<-Sys.time()
unzip("incoming_data.zip")
setwd(".\UCI HAR Dataset")

#Load in Test and Training Data and Labels
trainData <- read.table("train/X_train.txt")
trainLabel <- read.table("train/y_train.txt")
testData <- read.table("test/x_test.txt")
testLabel <-read.table("test/y_test.txt")
trainSubjects <- read.table("train/subject_train.txt")
testSubjects <- read.table("test/subject_test.txt")

#Combine test and training data
data<-rbind(trainData, testData)
labels<-rbind(trainLabel, testLabel)
subjects<-rbind(trainSubjects, testSubjects)


#-----2. Extract only the measurements on the mean and standard deviation for each measurment--------
#Read in the features data with mean and STDDEV info
features<-read.table("features.txt")
featureIndices <- grep("mean\\(\\)|std\\(\\)", features[,2])

#Select only data with mean/STDDEV and apply column names appropriately
data<-data[,featureIndices]
names(data) <- features[featureIndices,2]


#-----3. Uses descriptive activity names to name the activities in the data set---------------
#Read in the activity data
activities<-read.table("activity_labels.txt")
activityLabel<- activities[labels[,1], 2]
labels[,1]<-activityLabel
names(labels)<-"activity"

#------4. Appropriately labels the data set with descriptive variable names. --------------
names(subjects)<-"subject"
fullData<-cbind(subjects, labels, data)

#------5. From the data set in step 4, creates a second, independent tidy data set with the average 
#     of each variable for each activity and each subject.---------------------------------
#Gather the number of factors in subjects (30)
subjectLen<-length(table(subjects))
#Gather the number of different activities (6)
activityLen<-nrow(activities)
#Gather the number of columns in fullData
columnLen<-ncol(fullData)

#Prepare new data frame for second data set
fullData2<- matrix(NA, nrow=subjectLen*activityLen, ncol=columnLen)
fullData2<as.data.frame(fullData2)
colnames(fullData2)<- colnames(fullData)

row<-1
for(i in 1:subjectLen)
{
  for(j in 1:activityLen)
  {
    fullData2[row,1]<-sort(unique(subjects)[,1])[i]
    fullData2[row,2]<- activities[j,2]
    bool1 <- i == fullData$subject
    bool2 <- activities[j,2] == fullData$activity
    fullData2[row, 3:columnLen] <- colMeans(fullData[bool1&bool2, 3:columnLen])
    row<- row+1
  }
}


write.table(fullData, "clean_data.txt", row.names=FALSE)
write.table(fullData2, "mean_data.txt", row.names = FALSE)
