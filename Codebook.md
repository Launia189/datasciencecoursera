---
title: "Codebook"
author: "Launia White"
date: "6/26/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Website to download project data:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

From the website--about the data:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

## Data files:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

## Program:  run_analysis.R

 This program does the following:
 
1. Merges the training and the test sets to create one data set.

2. Extracts only the measurements on the mean and standard deviation for 
   each measurement.
   
3. Uses descriptive activity names to name the activities in the data set

4. Appropriately labels the data set with descriptive variable names.

5. From the data set in step 4, creates a second, independent tidy data set 
   with the average of each variable for each activity and each subject.

## Program steps:
Note: UCI HAR Dataset needs to be in your working directory before the running program run_analysis.R

1. Read in subject data for Test

```{r subject_test}
subject_test <- read.table("~/UCI HAR Dataset/Test/subject_test.txt")
names(subject_test)[1]="subjectNumber"
```

2. Read in measurement data for Test

```{r x_test}
X_test <- read.table("~/UCI HAR Dataset/Test/X_test.txt")
```

3. Get column names for test measurements

```{r features}
features <- data.frame(read.table("~/UCI HAR Dataset/features.txt"))
setnames(features, names(features), c("featureNum", "featureName"))
colnames(X_test) <- features$featureName
```

4. Keep mean and std only for measurement variables

```{r featureskeep}
featureskeep <- grep("mean\\(\\)|std\\(\\)",features$featureName,value=TRUE)  
testkeep<- subset(X_test,select=featureskeep) 
```

5. Read in labels (activityNumber) for Test
```{r y_test}
y_test <- read.table("~/UCI HAR Dataset/Test/y_test.txt")
names(y_test)[1]="activityNumber" 
```

6. Use cbind to merge data sets
```{r testdata}
testdata <- cbind(subject_test, y_test, testkeep)
head(testdata) 
```

7. Read in subject data for Train

```{r subject_train}
subject_train <- read.table("~/UCI HAR Dataset/Train/subject_train.txt")
names(subject_train)[1]="subjectNumber" 
```

8. Read in measurement data for Train

```{r X_train}
X_train <- read.table("~/UCI HAR Dataset/Train/X_train.txt")
```

9. Get column names for train measurements

```{r x_train}
colnames(X_train) <- features$featureName 
```

10. Keep mean and std only for measurement variables
```{r trainkeep}
trainkeep<- subset(X_train,select=featureskeep) 
```

11. Read in labels for Train

```{r y_train}
y_train <- read.table("~/UCI HAR Dataset/Train/y_train.txt")
names(y_train)[1]="activityNumber"
```

12. Use cbind to merge data sets

```{r traindata}
traindata <- cbind(subject_train, y_train, trainkeep) 
```

13. Merge test and train data

```{r testtrain}
testtrain <- rbind(testdata,traindata)
```

14. Merge in activity labels

```{r activity_labels}
activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt")
names(activity_labels)[1]="activityNumber" 
names(activity_labels)[2]="activityDescription"
testtrain <- merge(testtrain,activity_labels,by="activityNumber")
```

15. Create tidy dataset and write out to working directory

```{r create_tidydata}
testtrain$subjectNumber <- as.factor(testtrain$subjectNumber)
testtrain <- data.table(testtrain)
tidyData <- aggregate(. ~subjectNumber + activityDescription, testtrain, mean)
tidyData <- tidyData[order(tidyData$subjectNumber,tidyData$activityDescription),]
dim(tidyData)
write.table(tidyData, file = "~/Tidydata.txt", row.names = FALSE)
```

16. Code to read tidydata.txt from working directory

```{r read_tidydata}
data <- read.table("~/Tidydata.txt", header=TRUE)
```

Tidydata.txt variable list and description of measurement data from the website:
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

subjectNumber

activityDescription

activityNumber

tBodyAcc-XYZ

tGravityAcc-XYZ

tBodyAccJerk-XYZ

tBodyGyro-XYZ

tBodyGyroJerk-XYZ

tBodyAccMag

tGravityAccMag

tBodyAccJerkMag

tBodyGyroMag

tBodyGyroJerkMag

fBodyAcc-XYZ

fBodyAccJerk-XYZ

fBodyGyro-XYZ

fBodyAccMag

fBodyAccJerkMag

fBodyGyroMag

fBodyGyroJerkMag

The set of variables that were estimated from these signals are: 
mean(): Mean value
std(): Standard deviation


