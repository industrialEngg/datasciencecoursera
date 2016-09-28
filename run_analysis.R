fil1<-read.table(f1[2])
dir1<-"C:/Users/bag9031/Documents/Personal/Getting And Cleaning Data/Project/UCI HAR Dataset"
dirtrain<-"C:/Users/bag9031/Documents/Personal/Getting And Cleaning Data/Project/UCI HAR Dataset/train"
dirtest<-"C:/Users/bag9031/Documents/Personal/Getting And Cleaning Data/Project/UCI HAR Dataset/test"

################################# Read Data - Train & Test#######################################

setwd(dir1)
activitlabels<-read.table("activity_labels.txt") ## Load data containing activity labels
features<-read.table("features.txt")  ## Read file containing column names/ feature labels of the data set

setwd(dirtrain) ## Change directory to folder containing Test Data

subjecttrain<-read.table("subject_train.txt")
xtrain<-read.table("X_train.txt") ## Read training data
ytrain<-read.table("y_train.txt") ## Read row labels of the training data
colnames(ytrain)<-c("Labels")

setwd(dirtest) ## Change directory to folder containing Test Data

subjectest<-read.table("subject_test.txt")
xtest<-read.table("X_test.txt") ## Read training data
ytest<-read.table("y_test.txt") ## Read row labels of the training data
colnames(ytest)<-c("Labels")


###################################### End of Read Data###########################################


###################################### Merge Train & Test Files ###########################################

# Use row bind command to consolidate training & test files

subjectfinal<-rbind(subjecttrain,subjectest)
xfinal<-rbind(xtrain, xtest) 

yfinal<-rbind(ytrain, ytest)
colnames(yfinal)<-c("Labels")
x1<-xfinal

###################################### End of Merge Train & Test Files ###########################################

colnames(x1)<-features$V2  # Give column names for the training data from the feature file 

ft<-features$V2 ## Get all column names from feature table
m<-c("*mean*","*std*") ## create a list with key variable names to be searched through the column names. The variables are mean & standard deviation
m2<-grepl(paste(m, collapse = "|"),ft)
fnames<-ft[m2] ## Store all selected column names into a variable
fnames<-as.character(fnames)

x1<-x1[,fnames] ## Select only columns Mean and Standard Deviation

## Code below assigns the activity labels for training data activity (coded 1-6)
y1<-yfinal$Labels
y1[y1 == 1]<-"WALKING"
y1[y1 == 2]<-"WALKING_UPSTAIRS"
y1[y1 == 3]<-"WALKING_DOWNSTAIRS"
y1[y1 == 4]<-"SITTING"
y1[y1 == 5]<-"STANDING"
y1[y1 == 6]<-"LAYING"

yt<-cbind(yfinal, y1)
colnames(yt)<-c("Label","Activity_Descrip")

x2<-cbind(yt, x1) ## Merge training data with train labels
colnames(subjectfinal)<-"Subject"  ## Assign column lavel for subjects_train data
x2<-cbind(subjectfinal,x2)   ## Merge Subject ID and existing train data
dim(x2)


###################################### Create Summmary by Subject & Activity Labels ###########################################

agg<-aggregate(x2[,c(-1,-2,-3)], by =list(x2[,1],x2[,3]), FUN=mean)
dim(agg)
a<-colnames(agg)
a[1]<-"Subject.ID" # Rename column 1 label
a[2]<-"Activity.Label" ## Rename column 2 label
colnames(agg)<-a

