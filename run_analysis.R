####preping the libraries to be used
library(reshape2)

####setting working directory for convenience
setwd('C:\\Users\\Mervin\\getting-and-cleaning-data-project\\UCI HAR Dataset')

####What to do?
# 1. Merge the training and the test sets to create one data set.
# 2. Extract only the measurements on the mean and standard deviation for each measurement
# 3. Use descriptive activity names to name the activities in the data set
# 4. Appropriately label the data set with descriptive activity names.
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.


#### Getting data from files and naming variables
activityLabels <- read.table("activity_labels.txt")
activityLabels[,2] <- as.character(activityLabels[,2])
features <- read.table("features.txt")
features[,2] <- as.character(features[,2])

featuresWanted <- grep(".*mean.*|.*std.*", features[,2])
featuresWanted.names <- features[featuresWanted,2]
featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)
featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)
featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)

#### Loading the train datasets to be used
train <- read.table("train/X_train.txt")[featuresWanted]
trainActivities <- read.table("train/Y_train.txt")
trainSubjects <- read.table("train/subject_train.txt")
train <- cbind(trainSubjects, trainActivities, train)

#### Loading the test datasets to be used
test <- read.table("test/X_test.txt")[featuresWanted]
testActivities <- read.table("test/Y_test.txt")
testSubjects <- read.table("test/subject_test.txt")
test <- cbind(testSubjects, testActivities, test)

#### Combining / Merging test data set and training data set and setting the column names
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", featuresWanted.names)

#### Creating factors from the activities
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)
allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

#### creating the tidydataset txt file
write.table(allData.mean, "tidydataset.txt", row.names = FALSE, quote = FALSE)