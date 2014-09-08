Getting_cleaning_data_project
=============================

Coursera: Getting and cleaning data. Project.
F. Javier Marín 

# Parameters

This Script does not need parameters.


# Steps.

## 1.- Read Activity Labels.

The first step is create the data frame activity_labels with the descriptions and codes of all the Activity Labels included in file "activity_labels.txt"

       activity_labels  <- read.table("activity_labels.txt", header = FALSE, sep = " ")

## 2.- Read Header names 

Header names are included in file "features.txt". We must read this file and include its content in a new data frame "X_test_header". It has the descriptions of all the key figures.

    X_test_header <- read.table("features.txt", header = FALSE, sep = " ")

## 3.- Read Test file

Test data is in file "test/X_Test.txt". The script creates the data frame X_test with the file's content. It also set the column names for X_test from X_test_header column number 2. 

     X_test <- read.table("test/X_Test.txt", header = FALSE, dec = ".")  
     names(X_test)  <- X_test_header[,2]

## 4.- Test Labels

Next step is assign the activity label (WALKING, REST...) to each row. Activities are stored on file y_test.txt, so we have to load it on a new data frame called X_test_labels. After load it, we will merge with the descriptions of the activities, stored in data frame activity_labels. 

     X_test_labels  <- read.table("test/y_test.txt", header = FALSE, sep = " ")
     X_test_labels <- merge(X_test_labels, activity_labels, by="V1")
     names(X_test_labels)  <- c("Activity_code", "Activity_Name")

Last step is combine test data (X_test) with activity labels (X_test_labels): 
     X_test  <- cbind(X_test,X_test_labels)
  
## 5.- Test Subjects

Subjects are stored on file  subject_test.txt. We have to upload it in a new data frame:

  subject_tests  <- read.table("test/subject_test.txt", header = FALSE)
  names(subject_tests)  <- c("Subject")
  
 ## 6.- Merge Tests data with subjects

We have to combine test data (X_test) with each subject, stored in subject_tests data frame:

  X_test  <- cbind(X_test, subject_tests)
  
 ## 7.-  Train file

Now is time to read train data from file X_train.txt. Header names are identical to test data:

  X_train <- read.table("train/X_train.txt", header = FALSE, dec = ".")
  names(X_train) <- X_test_header[,2]
  
  
 ## 8.- Train Labels

Next step is to assign the activity labels for train data. The process is exactly the same as we did with test data:

  X_train_labels  <- read.table("train/y_train.txt", header = FALSE, sep = " ")
  X_train_labels <- merge(X_train_labels, activity_labels, by="V1")
  names(X_train_labels)  <- c("Activity_code", "Activity_Name")
  X_train  <- cbind(X_train, X_train_labels)
   
 ## 9.- Train Subjects

To complete train data, we need to assign subjects to each row as we did with tests:

  subject_train  <- read.table("train/subject_train.txt", header = FALSE)
  names(subject_train)  <- c("Subject")
  
 ### Merge Train data with subjects
  X_train  <- cbind(X_train, subject_train)
  
 ## 10.- Creates Total data frame 

Now is time to combine train and test data in a new data frame called X_total. We are also creating a flat file into disk with the result:

  X_total  <- rbind(X_test, X_train)
  write.table(X_total, "total/X_total.txt")


  
## 11.- Select only Std and mean columns. 

I've created a new file from features.txt that contents only the names of columns required. As you can see in the file, there are two columns: column number and column name.

  X_meanstdcol <- read.table("meanColumns.txt", header = FALSE, sep = " ")
  X_Total_meanstd <- X_total[,X_meanstdcol[,1]]
  write.table(X_Total_meanstd, "total/X_total_meanstd.txt")

## 12.- Create Result with means
  
Last step is create the result file with the means, aggregated by subject and activity.

  cols <- ncol(X_Total_meanstd) - 3   # We don't want the last 3 columns: Subject, activity name and code
  result  <- aggregate(X_Total_meanstd[1:cols], by=list(X_Total_meanstd$Subject, X_Total_meanstd$Activity_Name), FUN=mean, simplify=TRUE)
  
  rm(X_Total_meanstd)    # Removes Data frame to free memory
  write.table(result, "total/result.txt", row.name=FALSE)
