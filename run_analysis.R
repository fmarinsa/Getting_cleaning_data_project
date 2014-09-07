
## Getting and Cleaning Data: Course Project
# JMarin - Sept 2014

# 0.- Read master data for activity labels.
  activity_labels  <- read.table("activity_labels.txt", header = FALSE, sep = " ")
# 1.- Creates TOTAL file for X_* file.
  # Header names
  X_test_header <- read.table("features.txt", header = FALSE, sep = " ")
  # Test File
  X_test <- read.table("test/X_Test.txt", header = FALSE, dec = ".")  
  names(X_test)  <- X_test_header[,2]
  
  #Test Labels
  X_test_labels  <- read.table("test/y_test.txt", header = FALSE, sep = " ")
  X_test_labels <- merge(X_test_labels, activity_labels, by="V1")
  names(X_test_labels)  <- c("Activity_code", "Activity_Name")
  X_test  <- cbind(X_test,X_test_labels)
  
  # Test Subjects
  subject_tests  <- read.table("test/subject_test.txt", header = FALSE)
  names(subject_tests)  <- c("Subject")
  
  #merge Tests data with subjects
  X_test  <- cbind(X_test, subject_tests)
  
  # Train file
  X_train <- read.table("train/X_train.txt", header = FALSE, dec = ".")
  names(X_train) <- X_test_header[,2]
  
  
  #Train Labels
  X_train_labels  <- read.table("train/y_train.txt", header = FALSE, sep = " ")
  X_train_labels <- merge(X_train_labels, activity_labels, by="V1")
  names(X_train_labels)  <- c("Activity_code", "Activity_Name")
  X_train  <- cbind(X_train, X_train_labels)
   
  # Train Subjects
  subject_train  <- read.table("train/subject_train.txt", header = FALSE)
  names(subject_train)  <- c("Subject")
  
  #merge Train data with subjects
  X_train  <- cbind(X_train, subject_train)
  
  # Creates Total data frame 
  X_total  <- rbind(X_test, X_train)
  write.table(X_total, "total/X_total.txt")

  # free memory: Deletes X_test and X_train dataframes. 
  rm(X_test)
  rm(X_train)
  rm(X_test_labels)
  rm(X_test_header)
  
# 2.- Select only Std and mean columns. I've created a new file from features.txt that contents 
#     only the names of those columns.
  X_meanstdcol <- read.table("meanColumns.txt", header = FALSE, sep = " ")
  X_Total_meanstd <- X_total[,X_meanstdcol[,1]]
  write.table(X_Total_meanstd, "total/X_total_meanstd.txt")

# 3.- Create Result with means
  
  cols <- ncol(X_Total_meanstd) - 3   # We don't want the last 3 columns: Subject, activity name and code
  result  <- aggregate(X_Total_meanstd[1:cols], by=list(X_Total_meanstd$Subject, X_Total_meanstd$Activity_Name), FUN=mean, simplify=TRUE)
  
  rm(X_Total_meanstd)    # Removes Data frame to free memory
  write.table(result, "total/result.txt", row.name=FALSE)