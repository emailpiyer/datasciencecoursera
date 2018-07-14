# 1. Downloading and unzipping dataset
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/HAR_Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/HAR_Dataset.zip",exdir="./data")
# 2. Merging the training and the test sets to create one data set:
# 2.1 Reading files
# Reading trainings tables:
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')
# 2.2 Assigning column names:
colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityID"
colnames(subject_train) <- "subjectID"
      
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityID"
colnames(subject_test) <- "subjectID"
      
colnames(activityLabels) <- c('activityID','activityType')
# 2.3 Merging all data in one set:
mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
Merged <- rbind(mrg_train, mrg_test)
# 3. Extracting only the measurements on the mean and standard deviation for each measurement
# 3.1 Reading column names:
colNames <- colnames(Merged)
# 3.2 Create vector for defining ID, mean and standard deviation:
Mean_SD <- (grepl("activityID" , colNames) | 
                 grepl("subjectID" , colNames) | 
                 grepl("mean.." , colNames) | 
                 grepl("std.." , colNames) 
                 )
# 3.3 Making nessesary subset from Merged:
setForMeanAndStd <- Merged[ , Mean_SD == TRUE]
# 4. Using descriptive activity names to name the activities in the data set:
setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityID',
                              all.x=TRUE)
# 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject:
# 5.1 Making second tidy data set
TidySet <- aggregate(. ~subjectID + activityID, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectID, TidySet$activityID),]
# 5.2 Writing second tidy data set in txt file
write.table(TidySet, "TidySet.txt", row.name=FALSE)
