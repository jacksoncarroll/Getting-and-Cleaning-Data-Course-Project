## The purpose of this project is to demonstrate my ability to collect, work
## with, and clean a data set

## 0. Setup of the enivironmenmt
## Verify installation of the correct packages
if (!require("data.table")) {
        install.packages("data.table")
}

if (!require("reshape2")) {
        install.packages("reshape2")
}

require("data.table")
require("reshape2")

## Load the activity labels and the features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

## 1. Merge the training and the test sets to create one data set
## Load the datasets
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## Set the features
names(X_test) = features
names(X_train) = features

## 2. Extract only the measurements on
## the mean and standard deviation for each measurement. 
extract_features <- grepl("mean|std", features)
X_test = X_test[,extract_features]
X_train = X_train[,extract_features]

## Load activity labels
y_test[,2] = activity_labels[y_test[,1]]
names(y_test) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"
y_train[,2] = activity_labels[y_train[,1]]
names(y_train) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

## Merge the datasets
test_data <- cbind(as.data.table(subject_test), y_test, X_test)
train_data <- cbind(as.data.table(subject_train), y_train, X_train)
data = rbind(test_data, train_data)

## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names
labels = c("subject", "Activity_ID", "Activity_Label")
labelledData = setdiff(colnames(data), labels)

melted_data = melt(data, id = labels, measure.vars = labelledData)

## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject
tidy_data = dcast(melted_data, subject + Activity_Label ~ variable, mean)
write.table(tidy_data, file = "./tidy_data.txt", row.name=FALSE)

