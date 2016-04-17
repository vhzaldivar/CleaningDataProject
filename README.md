# Cleaning Data Project

## Files in this repo

There are four files in this repo

1. README.md -> this file
2. CodeBook.md -> a codebook describing the data
3. run_analysis.R -> an R script that performs the cleaning of the data (explained below)
4. GroupedData.txt -> the data set that is produced by the script

## Scripts explanation

The file "run_analysis.R" is an R script that perform the following operations

* Sets the correct working directory, assuming you started R Studio in your home directory and there exists the following
  directory tree "/home/USER/R_projects/UCI HAR Dataset" and that under that directory there are the train and test directories
  that contains the files we are interested in. You can change the line "setwd(..." to use ur own directory tree
* Reads the text files in the train subdirectory
  * merges the files to obtain one data frame with all the information using cbind
  * uses the second column of the "features.txt" file as column names
  * do some clean up to remove objects from the environment that are no
    longer needed so we can preserve memory
* Repeat the actions for the files in the test directory
* Combines the two data frames in one using rbind
* Removes the train and test data frames to preserve memory
* Uses grep to subset the data only with the columns that have "mean" (mean) or "std" (standard deviation) in the name
  * we have to use "\\(" in order to remove some columns that contained the mean Frequency
* Uses dyplr package to mutate the ActitivyID column so it contains a character label describing the activity
  * read the file "Activity_labels.txt" (stringsAsFactors = FALSE) and extracts the second column to obtain the labels
  * uses the factor function to generate a factor from the ActivityID column using the labels
  * mutate the data frame so the ActivityID column is now a factor using the labels
* It was not a requirement, but we save this data frame for future use if necessary
  * The file is called "TidyData.txt" (not submitted to this repo)
* Uses group_by and summarise_each to group the data
  * group by SubjectID and ActivityID (in that order)
  * summarize the rest of the columns obtaining the mean
* The final step is to write the grouped and summarised data into a txt file 
  * the file is named "GroupedData.txt"
  * uses "row.names = FALSE" so the row names won't be written to the files
  * uses "quote = FALSE" so the character values are not quoted in the file
  


