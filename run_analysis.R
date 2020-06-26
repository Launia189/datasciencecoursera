#Course 3 - Week 4 - Project
library(data.table)
library(tidyr)
# getwd()
# UCI HAR Dataset needs to be in your working directory

# This program needs to accomplish the following:
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for 
#   each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set 
#   with the average of each variable for each activity and each subject.

# read in subject data for Test
subject_test <- read.table("~/UCI HAR Dataset/Test/subject_test.txt")
names(subject_test)[1]="subjectNumber"
head(subject_test)
dim(subject_test)

# read in measurement data for Test
X_test <- read.table("~/UCI HAR Dataset/Test/X_test.txt")
names(X_test)
head(X_test)
dim(X_test)

# get column names for test measurements
features <- data.frame(read.table("~/UCI HAR Dataset/features.txt"))
setnames(features, names(features), c("featureNum", "featureName"))
colnames(X_test) <- features$featureName
X_test
names(X_test)

# keep mean and std only for measurement variables
featureskeep <- grep("mean\\(\\)|std\\(\\)",features$featureName,value=TRUE)  
testkeep<- subset(X_test,select=featureskeep) 

# read in labels (activityNumber) for Test
y_test <- read.table("~/UCI HAR Dataset/Test/y_test.txt")
names(y_test)[1]="activityNumber"
head(y_test)
dim(y_test)

# use cbind to merge data sets
testdata <- cbind(subject_test, y_test, testkeep)
head(testdata)


# read in subject data for Train
subject_train <- read.table("~/UCI HAR Dataset/Train/subject_train.txt")
names(subject_train)[1]="subjectNumber"
head(subject_train)
dim(subject_train)

# read in measurement data for Train
X_train <- read.table("~/UCI HAR Dataset/Train/X_train.txt")
names(X_train)
head(X_train)
dim(X_train)

# get column names for train measurements
colnames(X_train) <- features$featureName
X_train
names(X_train)

# keep mean and std only for measurement variables
trainkeep<- subset(X_train,select=featureskeep) 

# read in labels for Train
y_train <- read.table("~/UCI HAR Dataset/Train/y_train.txt")
names(y_train)[1]="activityNumber"
head(y_train)
dim(y_train)

# use cbind to merge data sets
traindata <- cbind(subject_train, y_train, trainkeep)
head(traindata)
dim(traindata)

# merge test and train data
testtrain <- rbind(testdata,traindata)
head(testtrain)
dim(testtrain)

# merge in activity labels
activity_labels <- read.table("~/UCI HAR Dataset/activity_labels.txt")
names(activity_labels)[1]="activityNumber" 
names(activity_labels)[2]="activityDescription"
testtrain <- merge(testtrain,activity_labels,by="activityNumber")
head(testtrain)

# could use gsub() to replace abbreviations with longer descriptions
# names(testtrain)<-gsub("Acc", "Accelerometer", names(testtrain))
# but this would make very long variables which could be truncated when
# read into other software packages

# tidy dataset
testtrain$subjectNumber <- as.factor(testtrain$subjectNumber)
testtrain <- data.table(testtrain)
tidyData <- aggregate(. ~subjectNumber + activityDescription, testtrain, mean)
tidyData <- tidyData[order(tidyData$subjectNumber,tidyData$activityDescription),]
dim(tidyData)
write.table(tidyData, file = "~/Tidydata.txt", row.names = FALSE)

head(tidyData)

# code to read data in
data <- read.table("~/Tidydata.txt", header=TRUE)
head(data)