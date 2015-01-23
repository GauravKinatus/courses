#Project - Creating a tidy data from UIC Human Activity Record dataset
Author: Gaurav Garg <gaurav_garg@yahoo.com>

#Assumptions:
1. Script (run_analysis.r) and the data are located in the working directory
2. Input files: "activity_labels.txt",  "subject_train.txt",  "X_train.txt", "y_train.txt", "subject_test.txt", "X_test.txt", "y_test.txt"       
2. Output (tidydata.txt): written back to the working directory.

#Reconstructing the Dataset:
There are 30 subjects identified by the variable Subject (1-30). These 30 voulenteers perform 6 activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING). The data recorded for all the activities for all 30 subjects is randomly divided into traing group (30%) and testing group (70%). The data files are organized in two folders for data recorded from the training group and the test group. As stated in the assumption, this script assumes all the input files are pulled in the working directory. Each group has three files:
a) X_train.txt: contains the recording from the sensors. There is similar file in X_test.txt
b) subject_train.txt: contains the Subject Id for each row in X. There is similar file in subject_test.txt 
c) y_train.txt: contains the activity id (1-6) for each row. There is similar file in y_test.txt

#What is Happening:
1. Read the data files relevant for the train group. 
2. The script uses cBind to bring the columns from file X_train.txt (sensor data), subject_train.txt (Subject Id) and y_train.txt(Activity Id) respectively. This yields a dataframe of 7352 rows and 563 columns (561 sensor recordngs, Subject, Activity_Id)
3. The script then repeats the similar steps for creating another data frame for the files in the test folder. After combining with cBind, we get 2947 rows and 563 columns(561 sensor recordngs, Subject, Activity_Id). The rows represents activity over several days.
4. We use rBind to combine the training rows and test rows to create a single data table with 10299 rows and 563 columns.
5. The script replaces the default variable names with the sensor variables stored in the file features.txt. Since the variables use hyphen, we need to use Unique = TRUE for R to interpret the variable names uniquely. The script also assigns column names to Subject Id as Subject and Actvitiy code as Activity_Id.
6. Replace the Activity codes with the actual Activity description using merge(). Since we dont need the Activity_Id, the scrip subsets the table and drops the Activity_Id column
7. This is an *important step*: the script subsets and extracts only those columns that has std (standard deviation) or mean (Average/mean) sensor reading *anywhere in the variable name*. Of course, we need the Subject and Activity columns to identify the rows. 
8. As a last step, the script melts the data table and creates a table on average of each variable for each activity and each subject. 

#Output
Each row represents the average of each variable for a subject and activity. The assignment asks for average of each variable, for each activity and each subject. Since Activity is the first, I interpret it as an the inner loop and subject as the outer loop for the groupings. i.e. First six rows record the average readings for activity 1-6 for subject 1. The process repeats for subject 2, subject 3 and so on, resulting in 180 rows (30 subjects x 6 activities).




