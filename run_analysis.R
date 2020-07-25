# Downloading & unzipping the document
if(!file.exist("./data")) {dir.create("./data")}
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile = "./data/DP4.zip")
unzip(zipfile = "./data/DP4.zip",exdir = "./data")
# Reading tables
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
# Naming the columns
colnames(x_train) <- features[,2]
colnames(y_train) <- "activity_id"
colnames(subject_train) <- "subject_id"
colnames(x_test) <- features[,2]
colnames(y_test) <- "activity_id"
colnames(subject_test) <- "subject_id"
colnames(activity_labels) <- c("activity_id","activity_type")
# Merging all the data
train <- cbind(y_train,subject_train,x_train)
test <- cbind(y_test,subject_test,x_test)
CourseData <- rbind(train,test)
# Reading column names
Cnames <- colnames(CourseData)
# Getting id, mean and std
mean_std <- (grepl("activity_id",Cnames) |
             grepl("subject_id",Cnames) |
             grepl("mean",Cnames) |
             grepl("std",Cnames)
             )
Measurement <- CourseData[,mean_std == TRUE]
Measurements <- as.data.frame(sapply(Measurement,as.numeric))
# The data set has already been named before
# Making a second tidy data set
SecondSet <- aggregate(.~subject_id + activity_id,Measurements,mean)
# Naming the activities with descriptive names from activity_label.txt
SetWithActivityNames <- merge(Measurements,activity_labels,by = "activity_id",all.x = TRUE)
write.table(SecondSet,"second_set.txt",row.name = FALSE)
