Getting and Cleaning Data Code Book

This CodeBook details the steps taken to extract and transform data used in the Getting and Cleaning Data project on Coursera.

1. Data is collected from the following location: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. The file is saved and unzipped as incoming_data.zip to UCI HAR Dataset
3. Working directory is moved into UCI HAR Dataset
4. The following data sets are read into R variables
  trainData - "train/X_train.txt"
  trainLabel - "train/y_train.txt"
  testData - "test/x_test.txt"
  testLabel - "test/y_test.txt"
  trainSubjects - "train/subject_train.txt"
  testSubjects -"test/subject_test.txt"
5. The matching test and training data sets are concatenated as follows:
  data is a grouping of trainData and testData
  labels is a grouping of trainLabel and testLabel
  subjects is a groping of trainSubjects and testSubjects
6. The features.txt file is read into the R variable features
7. The column indices which are labeled as having mean or standard deviation data are marked and stored in the featureIndices variable
8. The data variable is updated to only include the indices contained in the featureIndices variable. Column names are copied as well.
9. the activity_labels.txt file is read into the activityLabel variable in R
10. A data set consisting of the subjects, their label, and their respective data is created by column binding to the fullData variable
11. A second data set is created by taking the subject and activities and their mean values over their measurements which is saved to the variable fullData2
12. fullData is printed to "clean_data.txt" and fullData2 is printed to "mean_data.txt"
