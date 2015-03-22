library(plyr)

#getting initial data
activities1 <- read.table('./UCI HAR Dataset/train/y_train.txt')
activities2 <- read.table('./UCI HAR Dataset/test/y_test.txt')
features1 <- read.table('./UCI HAR Dataset/train/X_train.txt')
features2 <- read.table('./UCI HAR Dataset/test/X_test.txt')
subjects1 <- read.table('./UCI HAR Dataset/train/subject_train.txt')
subjects2 <- read.table('./UCI HAR Dataset/test/subject_test.txt')

#constructing data frame by concatenating of initial tables
dataFrame <- cbind( rbind(features1,features2), cbind( rbind(activities1,activities2), rbind(subjects1,subjects2)))

#adding column names
featuresNames <- read.table('./UCI HAR Dataset/features.txt')[[2]]
names(dataFrame) <- c(as.character(featuresNames),'activities','subjects')

#filtering column names by selecting ones containg mean- and std- measuares
subsetFeatureNames <- featuresNames[grep("mean\\(\\)|std\\(\\)", featuresNames)]
dataFrame_names <- c(as.character(subsetFeatureNames),'activities','subjects')
dataFrame <- subset(dataframe, select = dataFrame_names)

#applying activity's names to the activity columns
activityLabels <- read.table('./UCI HAR Dataset/activity_labels.txt')[[2]]
dataFrame$activities <- activityLabels[dataFrame$activities]

#transforming columns names to more understandable form
names(dataFrame)<-gsub("^t", "time", names(dataFrame))
names(dataFrame)<-gsub("^f", "frequency", names(dataFrame))
names(dataFrame)<-gsub("Acc", "Accelerometer", names(dataFrame))
names(dataFrame)<-gsub("Gyro", "Gyroscope", names(dataFrame))
names(dataFrame)<-gsub("Mag", "Magnitude", names(dataFrame))

#creating new tidy data set with the average of each variable for each activity and each subject
dataFrame <- aggregate(. ~subjects + activities, dataFrame, mean)
dataFrame <- dataFrame[order(dataFrame$subjects,dataFrame$activities),]

#output
write.table(dataFrame,file = 'tidydata.txt',row.names = FALSE)
