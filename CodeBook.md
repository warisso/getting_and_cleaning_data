##Introduction
The present file describes the applied data, the files and the script designed to create and independent tidy dataset.

##Original dataset
As described in the exercise, the data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
where the data for the project can be downloaded from the following website:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
In the run_analysis.R file it is considered the possibility to download the file form the web or checking if the directory and files exist in the computer.

##Data.table package
Along the run_analysis.R file the data.table package is applied. As a first important step the script checks for the existence of data.table package. In case the package is not installed the script will proceed to install the package.

##Name the activities in the data set
The class labels linked with their activity names are loaded from the activity_labels.txt file. The numbers of the testData_act and trainData_act data frames are replaced by those names:
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)
Appropriately labels the data set with descriptive activity names
Each data frame of the data set is labeled - using the features.txt - with the information about the variables used on the feature vector. The Activity and Subject columns are also named properly before merging them to the test and train dataset.
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")

##Merge test and training sets into one data set, including the activities
The Activity and Subject columns are appended to the test and train data frames, and then are both merged in the bigData data frame.
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
bd<-rbind(testData,trainData)

##Extracting the measurements on the mean and standard deviation for each measurement
mean() and sd() are used against bigData via sapply() to extract the requested measurements.
bdmean<-sapply(bigData,mean,na.rm=TRUE)
bdsd<-sapply(bigData,sd,na.rm=TRUE)
A warning is returned for the Activity column because it's not numeric. This does not impact the calculation of the rest and NA is stored in the new data frames instead, since mean and sd are not applicable in this case. The same applies for Subject where we're not interested about the mean and sd, but since it's numeric already there is no warning.

##Creates a tidy data set with the average of each variable
Finally the desired result, a tidy data table is created with the average of each measurement per activity/subject combination. The new dataset is saved in tidy.csv file.
DT <- data.table(bd)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="tidy.csv",sep=",",col.names = NA)

##Variables in the tidy file
All variables are means of corresponding values from raw data, grouped by ID Fields. Numbers indicate number of feature from raw dataset.
•	1 tBodyAcc-mean()-X
•	2 tBodyAcc-mean()-Y
•	3 tBodyAcc-mean()-Z
•	4 tBodyAcc-std()-X
•	5 tBodyAcc-std()-Y
•	6 tBodyAcc-std()-Z
•	41 tGravityAcc-mean()-X
•	42 tGravityAcc-mean()-Y
•	43 tGravityAcc-mean()-Z
•	44 tGravityAcc-std()-X
•	45 tGravityAcc-std()-Y
•	46 tGravityAcc-std()-Z
•	81 tBodyAccJerk-mean()-X
•	82 tBodyAccJerk-mean()-Y
•	83 tBodyAccJerk-mean()-Z
•	84 tBodyAccJerk-std()-X
•	85 tBodyAccJerk-std()-Y
•	86 tBodyAccJerk-std()-Z
•	121 tBodyGyro-mean()-X
•	122 tBodyGyro-mean()-Y
•	123 tBodyGyro-mean()-Z
•	124 tBodyGyro-std()-X
•	125 tBodyGyro-std()-Y
•	126 tBodyGyro-std()-Z
•	161 tBodyGyroJerk-mean()-X
•	162 tBodyGyroJerk-mean()-Y
•	163 tBodyGyroJerk-mean()-Z
•	164 tBodyGyroJerk-std()-X
•	165 tBodyGyroJerk-std()-Y
•	166 tBodyGyroJerk-std()-Z
•	201 tBodyAccMag-mean()
•	202 tBodyAccMag-std()
•	214 tGravityAccMag-mean()
•	215 tGravityAccMag-std()
•	227 tBodyAccJerkMag-mean()
•	228 tBodyAccJerkMag-std()
•	240 tBodyGyroMag-mean()
•	241 tBodyGyroMag-std()
•	253 tBodyGyroJerkMag-mean()
•	254 tBodyGyroJerkMag-std()
•	266 fBodyAcc-mean()-X
•	267 fBodyAcc-mean()-Y
•	268 fBodyAcc-mean()-Z
•	269 fBodyAcc-std()-X
•	270 fBodyAcc-std()-Y
•	271 fBodyAcc-std()-Z
•	345 fBodyAccJerk-mean()-X
•	346 fBodyAccJerk-mean()-Y
•	347 fBodyAccJerk-mean()-Z
•	348 fBodyAccJerk-std()-X
•	349 fBodyAccJerk-std()-Y
•	350 fBodyAccJerk-std()-Z
•	424 fBodyGyro-mean()-X
•	425 fBodyGyro-mean()-Y
•	426 fBodyGyro-mean()-Z
•	427 fBodyGyro-std()-X
•	428 fBodyGyro-std()-Y
•	429 fBodyGyro-std()-Z
•	503 fBodyAccMag-mean()
•	504 fBodyAccMag-std()
•	516 fBodyBodyAccJerkMag-mean()
•	517 fBodyBodyAccJerkMag-std()
•	529 fBodyBodyGyroMag-mean()
•	530 fBodyBodyGyroMag-std()
•	542 fBodyBodyGyroJerkMag-mean()
•	543 fBodyBodyGyroJerkMag-std()
