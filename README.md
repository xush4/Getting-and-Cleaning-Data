
# Overview

The run_analysis.R implements these 5 steps to analyze the data provided here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The ZIP file has to be located in the same directory where the run_analysis.R is located.
The files are unzipped to this location and the directory structure is left unchanged when
the datasets are read. The features and activity files are located in the subdirectory
"UCI HAR Dataset" and the X Y and Subject files are separated into a training and a testing
section. 

The 5 Steps are:
1.Merges the training and the test sets to create one data set.
2.Extracts only the measurements on the mean and standard deviation for each measurement. 
3.Uses descriptive activity names to name the activities in the data set
4.Appropriately labels the data set with descriptive variable names. 
5.Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## Read and Merges the training and the test sets to create one data set.
This step is strightforward. The files are read from the original location.
The dataset containing all the measurement is the X.DS. This is avialbale in
2 versions. A training dataset and a testing dataset. Since the column names
are not provided in the datasets itself, but instead in another dataset (features.txt),
the merging of the 3 datasets (X, Activity and Subject) is implemented after the 4th step of the script, which sets
legal column names for the dataset. If it would be implmented in the first step, the setting of the
column names would be more complicated. The training and testing datasets can be easilly combined using the rbind
command. Since the activity and subject dataset both only have 1 column, the setting of legal column names can  
be simply performed using a simple assignment (names(S.DS) <- c('Subject'))

## Extracts only the measurements on the mean and standard deviation for each measurement. 
Column names, that contain standard deviation or mean measurements can be recognized by their
column names. Since the naming of the individual columns is performed in step 4, this step is
completely implemented after the columns in the dataset (X) have been appropriately named with
the column names provided in the features dataset.

## Uses descriptive activity names to name the activities in the data set
The activity_labels.txt dataset contains a level indicator and a description of the
activity (1 WALKING
, 2 WALKING_UPSTAIRS, 
3 WALKING_DOWNSTAIRS, 
4 SITTING
, 5 STANDING, 
6 LAYING
)
These 6 categories can be easilly assigned to the column in the Y dataset (both training and testing).
The replacement of the number in the Y.DS$Activity column with the appropriate activity description from
the activities dataset (activity.DS) can be implemented without a for loop and also without a lapply statement
by assigneing the activity column from the activity.DS dataset subsetting by the number provided by the Y.DS$Activity column.
The subsetting retrieves and individual row. This rows description is referenced by name $Activity. This value is assigned
to the column activity in the Y.DS dataset. Y.DS$Activity <- activity.DS[Y.DS$Activity,]$Activity

## Appropriately labels the data set with descriptive variable names. 
The labels for the dataset (X.DS) are provided in the features dataset. The number and order of rows in the features dataset matches
the columns in the X.DS dataset. Before the names can be applied using the names command, some special character, which are not
legal specifiers in the R language have to be removed using the gsub command. The indiviual replacements in the gsub are nested.
There characters are replaced: - dash , comma ( open and ) close brackets. These names are then applied to the full X.DS dataset.
The next step filters the column names for only the names that indicate either a standard deviation value or a means values this
is performed by the grep command. This delivers a list of relevant column names in the variable 'selected.columns'.
This list is then used for subsetting the columns in the X.DS dataset. This dataset is now combined column wise with
the activity and subject datset: cbind(XSel.DS,S.DS,Y.DS).

## Creates a second, independent tidy data set with the average of each variable for each activity and each subject
The independet tidy dataset is created using the aggregate function. The columns which are aggregated are provided
as parameter "by" to the aggregate function. The parameter is a list of column names to be aggregated by=list(tidy.DS$Activity,tidy.DS$Subject).

