1.Merges the training and the test sets to create one data set.
#read the test data
X_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")
subject_test<-read.table("./test/subject_test.txt")

# read the train data
X_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")
subject_train<-read.table("./train/subject_train.txt")

#cbind the test data and train data

test<-cbind(subject_test,X_test,y_test)
train<-cbind(subject_train,X_train,y_train)

#rbind the  test and train data
data1<-rbind(test,train)

#2.Extracts only the measurements on the mean and standard deviation for each measurement
 #rbind the features data
X_data<-rbind(X_test,X_train)
features<-read.table("features.txt")
#grep and get the features that including mean and std 
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2])
data2<-X_data[,meanStdIndices]
#give the names(features) to data2
names(data2)<-features[,2][meanStdIndices]
str(data2)

#3.Uses descriptive activity names to name the activities in the data set
library(dplyr)
activity_labels<-read.table("activity_labels.txt")
labels<-rbind(y_test,y_train)
labels1<-left_join(activity_labels,labels,by="V1")
labels1<-labels1[,2]
names(labels1)<-activity

#4.Appropriately labels the data set with descriptive variable names.
# get the origin data from data1
data3<-data1[,c(meanStdIndices,562,563)]
#give the names to data3
names(data3)<-c("subject",as.character(features[,2][meanStdIndices]),"numbers")
names(activity_labels)<-c("numbers","labels")
#merge the data3 and activity_labels by numbers
data3<-left_join(data3,activity_labels,by="numbers")
data3<-data3[,-68]
str(data3)
write.table(data3, "merged_data.txt")




5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(reshape2)
library(plyr)
#melt the data3 into the long data
data4<-melt(data3,id.vars=c("subject","labels"),variable.name="variable",value.name="numbers")

#calcult the average of each variable for each activity and each subject
data5<-ddply(data4,c("labels","subject","variable"),summarise,mean=mean(numbers))
write.table(data5, "data_with_means.txt")