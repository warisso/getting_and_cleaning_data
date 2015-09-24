#####################################################################################################################
# This is the description of the file run_analysis.R.
# 1. At first, it checks about the availability of the data.table package otherwise it installs the package
# 2. Checking for the existence of the directory "UCI HAR Dataset" otherwise download the Dataset.zip from the website
# 3. loading sets from test and train files
# 4. it uses descriptive activity names to name the activities in the data set 
# 5. it labels the data set with descriptive activity names 
# 6. merge test and training sets into one data set, including the activities 
# 7. extract only the measurements on the mean and standard deviation for each measurement 
# 8. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#####################################################################################################################

#1. Checking "data.table" package

if (!require("data.table")){
install.packages("data.table")
}

library(data.table)

#2. Checking directory or downloading the dataset

if(!dir.exists("./UCI HAR Dataset")){

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"  

download.file(fileUrl, destfile = "Dataset.zip") 

unzip("Dataset.zip") 
}

#3. loading sets from test and train files

testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE) 
testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE) 
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE) 
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE) 
trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE) 
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE) 
  
# 4. it uses descriptive activity names to name the activities in the data set 
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character") 
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2) 
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2) 
 
# 5. it labels the data set with descriptive activity names 
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character") 
colnames(testData)<-features$V2 
colnames(trainData)<-features$V2 
colnames(testData_act)<-c("Activity") 
colnames(trainData_act)<-c("Activity") 
colnames(testData_sub)<-c("Subject") 
colnames(trainData_sub)<-c("Subject") 
 
# 6. merge test and training sets into one data set, including the activities 

testData<-cbind(testData,testData_act) 
testData<-cbind(testData,testData_sub) 
trainData<-cbind(trainData,trainData_act) 
trainData<-cbind(trainData,trainData_sub) 
bd<-rbind(testData,trainData) 
 
# 7. extract only the measurements on the mean and standard deviation for each measurement 

bdmean<-sapply(bd,mean,na.rm=TRUE) 
bdsd<-sapply(bd,sd,na.rm=TRUE) 
 
# 8. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

DT <- data.table(bd) 
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"] 
write.table(tidy,file="tidy.csv",sep=",",row.names = FALSE) 
