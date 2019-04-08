library(data.table)
library(dplyr)

X_train = read.table(choose.files(),header = FALSE)
y_train = read.table(choose.files(),header = FALSE)
subject_train = read.table(choose.files(),header = FALSE)

X_test = read.table(choose.files(),header = FALSE)
y_test = read.table(choose.files(),header = FALSE)
subject_test = read.table(choose.files(),header = FALSE)

features = read.table(choose.files(),header = FALSE)
activity_labels = read.table(choose.files(),header = FALSE)

merge_train = cbind(X_train, y_train, subject_train)
merge_test = cbind(X_test, y_test, subject_test)

merge_all = rbind(merge_train, merge_test)

colnames(X_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(X_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activity_labels) <- c('activityId','activityType')

colNames <- colnames(merge_all)

mean_std <- (grepl("activityId" , colnames) | 
                   grepl("subjectId" , colnames) | 
                   grepl("mean.." , colnames) | 
                   grepl("std.." , colnames) )

MeanStd <- merge_all[ , mean_std == TRUE]

Activity_Names <- merge(MeanStd, activity_labels,
                              by='activityId',
                              all.x=TRUE)
tidied <- aggregate(. ~subjectId + activityId, Activity_Names, mean)
tidiedagain <- tidied[order(tidied$subjectId, tidied$activityId),]

write.table(tidiedagain, "tidieddataset.txt", row.name=FALSE)
