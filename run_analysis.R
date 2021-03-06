library(dplyr)
library(tidyverse)
library(data.table)


##download data from internet  
download.data <- function (filename) {
            if (!file.exists(file.path("./data")))
            {
                        dir.create("./data")
                        download.file(fileurl, filename)
                        unzip(filename, exdir="./data")            
            }
}

##read both train and test activities from the directory  
readFeatures <- function() {
            trainFeatures <<- read.table(file.path(directorypath,"train", "X_train.txt" ), 
                                         header = FALSE,
                                         col.names = as.character(featureLabels$featurename), check.names = FALSE)
            
            testFeatures <<-read.table(file.path(directorypath,"test", "X_test.txt"), 
                                       header = FALSE,
                                       col.names = as.character(featureLabels$featurename), check.names = FALSE)
}

##read both train and test labels from the directory  
readActivities <- function() {
            
            trainActivties <<- read.table(file.path(directorypath,"train", "Y_train.txt" ), 
                                          header = FALSE, 
                                          col.names=c("actcode"))
            testActivities <<-read.table(file.path(directorypath,"test", "Y_test.txt" ), 
                                         header = FALSE, 
                                         col.names=c("actcode"))
            
}

##read both train and test subjects from the directory  
readSubjects <- function() {
            
            trainSubjects <<- read.table(file.path(directorypath,"train", "subject_train.txt" ), 
                                         header = FALSE, 
                                         col.names=c("subject"))
            
            testSubjects <<-read.table(file.path(directorypath,"test", "subject_test.txt" ), 
                                       header = FALSE, 
                                       col.names=c("subject"))
            
}

##read both activty and feature labels from the directory  
readLabels <- function() {
            ##Activity labels  
            activityLabels <<- read.table(file.path(directorypath,"activity_labels.txt" ), 
                                          header = ,
                                          col.names = c("actcode", "activityname"))
            ##Feature Labels
            featureLabels <<- read.table(file.path(directorypath,"features.txt" ), 
                                         header = FALSE,
                                         col.names = c("featurecode", "featurename"))            
}

########## CODE FOR ACTIONS AS PER PROJECT REQUIREMENTS #########

fileurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
directorypath <- "./data/UCI HAR Dataset" 


########## DOWNLOAD UCI HAR DATA, UNZIP #########################
download.data(datazipfilename)


##########  READ MASTER VARIABLES ###############################
readLabels()

##########  READ OBSERVATION DATA ###############################
readFeatures()
readActivities()
readSubjects()


########### MERGE TRAIN & TEST DATA #############################
dataFeatures <- rbind.data.frame(trainFeatures, testFeatures)
dataActivity <- rbind.data.frame(trainActivties, testActivities)
dataSubjects <- rbind.data.frame(trainSubjects, testSubjects)

##Merge into single dataset
dataMerged <- cbind(dataSubjects, dataActivity, dataFeatures)

########### SELECT ONLY MEAN & SD COLUMNS ########################
meanSDCols <- featureLabels$featurename[grep("mean\\(\\)|std\\(\\)", 
                                             featureLabels$featurename)]

tidyData <- select(dataMerged, subject, actcode, as.character(meanSDCols))

########### SUBSTITUTE ACTIVTY NAMES FOR CODE ####################
tidyData$actcode <- activityLabels$activityname[tidyData$actcode]
names(tidyData)[2] = "activity"

########### DESCRIPTIBVE NAMES FOR COLUMNS #######################
names(tidyData)<-gsub("-mean\\(\\)", ":Mean", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-std\\(\\)", ":STD", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-freq\\(\\)", ":Frequency", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("-", ":", names(tidyData), ignore.case = TRUE)
names(tidyData)<-gsub("Acc", "Accelerometer", names(tidyData))
names(tidyData)<-gsub("Gyro", "Gyroscope", names(tidyData))
names(tidyData)<-gsub("BodyBody", "Body", names(tidyData))
names(tidyData)<-gsub("Mag", "Magnitude", names(tidyData))
names(tidyData)<-gsub("^t", "Time", names(tidyData))
names(tidyData)<-gsub("^f", "Frequency", names(tidyData))
names(tidyData)<-gsub("tBody", "TimeBody", names(tidyData))

##Get Mean of all observations after grouping by subject & activity
finalData <- tidyData %>%
            group_by(subject, activity) %>%
            summarise(across(everything(),mean))

########### Write to a text table ################################
write.table(finalData,"FinalAveragesData.txt")














