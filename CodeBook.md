run_analysis.R script is the script which performs the 5 actions asked for in the "Getting and Cleaning Data Course Project". 

STRUCTURE
The file contains 4 functions, followed by the script which executes the 5 actions required by the assignment. The functions are meant to make the code more readable. These functions use globally scoped variables for data tables


1. download.data  		: Download and unzip teh dataset local folder
2. readLabelsAndNames		: read activity label and feature functions(names) and store as variavles
3. readActivities 		: read all actvitiy observations data from Train and Test 
4. readFeatures   		: read all features observations data from Train and Test 
5. readSubjects   		: read all subjects observations data from Train and Test 


STEP#1 
Download the dataset from cloudfront url for the project @ https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Dataset downloaded and extracted under the folder called UCI HAR Dataset. download.data function performs this task

STEP#2
Load data into R variables for feature names, activity labels & observation data (activity, subject and feature)

1. activityLabels = Activity labels (code and description) in ./activity_labels.text file. These are the activities done by each subject. [ROWS=6, COLS=2, column names = actcode, activityname]

2. featureneNames = Feature specification of 561 columns from accelerometer and gyroscope from the ./features.txt. These are the features recorded in the observations data. [ROWS=561, COLS=2, column names = featurecode, featurename]

3. trainSubjects  = Subjects Observation data set contained in ./Train/subject_train.text file [ROWS=7352, COLS=1, column name = subject]

4. testSubjects   = Subjects Observation data set contained in ./Test/subject_test.text file [ROWS=2947, COLS=1, column name = subject]

5. trainActivties = Activity Observation data set contained in ./Train/X_Train.text file [ROWS=7352, COLS=1, column name = actcode]

6. testActivties  = Activity Observation data set contained in ./Test/y_test.text file [ROWS=2947, COLS=1, column name = actcode]
 
7. trainFeatures  = features Observation data set contained in ./Test/X_train.text file [ROWS=7352, COLS=561, column names = 1-561 

8. features of features.text file]
testFeatures   = features Observation data set contained in ./Test/X_Test.text file [ROWS=2947, COLS=561, column names = 1-561 features of features.text file]


#STEP 3
Create one data set which combines all observations data by combining corresponding train & test data sets
1. Combine feature observations data of train and test into variable data set "dataFeatures" (use rbind to bind rows)
2. Combine Subject observations data of train and test data into variable data set "dataSubjects" (use rbind to bind rows)
3. Combine activity observations data of train and test data into variable data set "dataActivity" (use rbind to bind rows)
4. Finally, combine all into one dataset called "dataMerged" which contains all the data that is required to be bound together. (use cbind to bind columns)

#STEP 4
Subset "dataMerged" to contain only "activity", subject and "features observation data comtaining mean and standard deviation". 
Select only those columns whose names contain mean() or std()
	- "mean" followed by a "()" e.g.  tBodyAcc-mean() 
	- "std" followed by a "()" are chosen e.g. fBodyAccJerk-std()

This dataset is called "tidyData" with [ROWS = 10299, COLS=68, column names= subject, activity, <columns containing mean() and std()]

#STEP 5
Substitute variable actcode in merged data with Activity names and rename the variable as "activity". 

#STEP 6
Assign intuitive & descriptive names to variables of the dataset which are human readable. Use gsub to find specific key words and replace with more informed text.

a) Change "-mean" to ":Mean"
b) Change hyphenated "-std" to ":STD"
c) Change all Hyphens to semicolons
d) Rename short words with human understandable text 
            i)    "Acc" to "Accelerometer"
            ii)   "t" with time 
            iii)  "freq" with Frequency etc
	iv)   "Gyro" with "Gyroscope"
	v)    "BodyBody" with "Body"
	vi)   "Mag" with "Magnitude"
	vii)  "t" with "Time" when "t" is first letter of the feature name
	viii) "f" with "Frequency" when "f" is first letter of the feature name
	ix)   "tBody" with "TimeBody"

#STEP 7
Calculate the mean of the observations. For this, group the data by activity and subject and use the summarize function for all the columns other than the grouped columns. 
This dataset is called "finalData". [ROWS=180, COLUMNS=68]

#STEP 8
Save the data table in the "FinalAveragesData.txt" file. 


