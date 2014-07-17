## #############################################################################################
## 
## Steps:
## 1) Merges the training and the test sets to create one data set.
## 2) Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3) Uses descriptive activity names to name the activities in the data set
## 4) Appropriately labels the data set with descriptive variable names. 
## 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 
##
## #############################################################################################

setwd("~/R/Coursera/assignments/C03-P/Getting-and-Cleaning-Data")

## #############################################################################################
## Step 1: Merges the training and the test sets to create one data set.
## #############################################################################################

## testing data sets
X.tst.DS <- read.table('./UCI HAR Dataset/test/X_test.txt')
Y.tst.DS <- read.table('./UCI HAR Dataset/test/y_test.txt')
S.tst.DS <- read.table('./UCI HAR Dataset/test/subject_test.txt')

## training data sets
X.trn.DS <- read.table('./UCI HAR Dataset/train/X_train.txt')
Y.trn.DS <- read.table('./UCI HAR Dataset/train/y_train.txt')
S.trn.DS <- read.table('./UCI HAR Dataset/train/subject_train.txt')

## combine testing and training datasets rows
X.DS <- rbind(X.tst.DS, X.trn.DS)
Y.DS <- rbind(Y.tst.DS, Y.trn.DS)
S.DS <- rbind(S.tst.DS, S.trn.DS)
##rm(X.tst.DS,X.trn.DS, Y.tst.DS,Y.trn.DS, S.tst.DS,S.trn.DS)

## set column names in cmbined dataset 
names(S.DS) <- c('Subject')
names(Y.DS) <- c('Activity')

head(X.DS)
head(S.DS)
head(Y.DS)

## create one combined dataset --> after step 4

## #############################################################################################
## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
## #############################################################################################
## better implemented after step 4

## #############################################################################################
## Step 3: Uses descriptive activity names to name the activities in the data set
## #############################################################################################
activity.DS <- read.table('./UCI HAR Dataset/activity_labels.txt',col.names=c('id','Activity'))
Y.DS$Activity <- activity.DS[Y.DS$Activity,]$Activity

## #############################################################################################
## Step 4: Appropriately labels the data set with descriptive variable names.
##         - read the features dataset
##         - convert to legal column names: remove , - ( and )
##         - set legal column names on dataset X
## #############################################################################################
features.DS <- read.table('./UCI HAR Dataset/features.txt',col.names=c('id','Feature'))
LegalColNames <- gsub( "-", "" , gsub( "\\,", "", gsub( "\\(" , "", gsub("\\)", "", features.DS$Feature ) ) ) )
names(X.DS) <- LegalColNames ## apply names from features dataset

## Step 2: Extracts only the measurements on the mean and standard deviation for each measurement. 
selected.columns <- features.DS$Feature[grep('mean|std', features.DS$Feature, ignore.case=TRUE)]
XSel.DS <- X.DS[,selected.columns] ## selected columns from dataset X

## Step 1: create one dataset
tidy.DS <- cbind(XSel.DS,S.DS,Y.DS)
write.table(tidy.DS, "tidy.txt", sep="\t")

## #############################################################################################
## Step 5: Creates a second, independent tidy data set with the average of 
##         each variable for each activity and each subject. 
## ############################################################################################
tidy.agr.DS <- aggregate(tidy.DS , by=list(tidy.DS$Activity,tidy.DS$Subject), FUN=mean, rm.NA=T)
write.table(tidy.agr.DS, "aggregate_tidy.txt", sep="\t")
