#loading library dplyr 
library(dplyr)

#unzip zip file downloaded for Getting and Cleaning Data project
unzip(zipfile = "/Users/kumarshaket/Downloads/getdata_projectfiles_UCI.zip", exdir="/Users/kumarshaket/Desktop/Coursera/datafiles")

#set directory path to UCI Data Set Directory
setwd("/Users/kumarshaket/Desktop/Coursera/datafiles/UCI HAR Dataset")

#Read train Data from Data Set
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/Y_train.txt")
subtrain <- read.table("./train/subject_train.txt")

#Read test Data from DataSet
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/Y_test.txt")
subtest <- read.table("./test/subject_test.txt")

# Read activity  from DataSet
activity <- read.table("./activity_labels.txt")

#Read data description from Dataset
feature <- read.table("./features.txt")

# 1. Merges the training and the test sets to create one data set.
x_merge <- rbind(xtrain,xtest)
y_merge <- rbind(ytrain,ytest)
sub_merge <- rbind(subtrain,subtest)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
svar <- feature[grep("mean\\(\\)|std\\(\\)",feature[,2]),]
x_merge <- x_merge[,svar[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_merge)= "activity"
y_merge$activitylabel <- factor(y_merge$activity,labels = as.character(activity[,2]))

# 4. Appropriately labels the data set with descriptive variable names.
colnames(x_merge) <- feature[svar[,1],2]
colnames(sub_merge) <- "subjects"

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
total <- cbind(x_merge, y_merge, sub_merge)
total_mean <- total %>% group_by(activitylabel, subjects) %>% summarise_all(funs(mean))
write.table(total_mean, file = "/Users/kumarshaket/Desktop/Coursera/Module4 Projects/CleaningData_Project/tidydata.txt", row.names = FALSE, col.names = TRUE)
