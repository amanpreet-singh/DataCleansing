# R script called run_analysis.R that uses Human Activity Recognition Using Smartphones Dataset(Version 1.0) to do the following: 
#       1. Merges the training and the test sets to create one data set.
#       2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#       3. Uses descriptive activity names to name the activities in the data set
#       4. Appropriately labels the data set with descriptive variable names. 
#       5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Pre-requisite:
# 1. Downloaded the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# 2. Unzip the downloaded zip file
# 3. Set the current working directory to unzipped Samsung data directory

# Loading the activity labels
activitylabels <- read.table("./activity_labels.txt",col.names = c("activityid","activityname"))

# Loading and tidying the features data
features <- read.table("./features.txt",col.names = c("featureid","featurename"))
features$tidyname<- tolower(gsub("\\(|\\)|-|,","",features$featurename))

# Loading training data
trainsubject <- read.table("./train/subject_train.txt", col.names = c("subjectid"))
trainset <- read.table("./train/X_train.txt",col.names=features$tidyname)
trainactivity <- read.table("./train/y_train.txt",col.names=c("activityid"))

# Loading test data
testsubject <- read.table("./test/subject_test.txt", col.names = c("subjectid"))
testset <- read.table("./test/X_test.txt",col.names=features$tidyname)
testactivity <- read.table("./test/y_test.txt",col.names=c("activityid"))

# Bind the training subject, activity and set together into traindata
traindata<- cbind(trainsubject,trainactivity,trainset)

# Bind the test subject, activity and set together into testdata
testdata<- cbind(testsubject,testactivity,testset)

# 1. Merge the training and the test sets to create one data set called mergeddata.
mergeddata <- rbind(traindata,testdata)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
meanstddata <- mergeddata[,grep("mean|std",names(mergeddata))]

# Addressing both point 3 & 4 together
# 3. Adding the subject and activity data in the dataset 
# 4. Appropriately labels the data set with descriptive variable names. Completed as part of the above steps
mergeddata <- merge(activitylabels,mergeddata,by.x="activityid",by.y="activityid")
meanstddata <- cbind(subjectid=mergeddata$subjectid,activityname=mergeddata$activityname,meanstddata)


# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
aggrdata <- aggregate(.~subjectid+activityname,data = meanstddata,FUN = mean,na.rm=TRUE)

# Publishing the aggregated dataset to a file in the current working directory
write.table(aggrdata,file="./tidydata.txt",row.name=FALSE)