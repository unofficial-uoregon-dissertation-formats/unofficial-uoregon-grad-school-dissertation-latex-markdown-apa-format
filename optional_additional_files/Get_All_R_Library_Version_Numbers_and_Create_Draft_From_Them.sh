#!/bin/bash

# Find all R packages loaded in a codebase
# Jacob Levernier
# 2016
# Released under an MIT license

############################
# Settings
############################

file_to_save="./markdown_draft_examples/R_Package_Version_Numbers_AUTOMATICALLY_GENERATED_DO_NOT_EDIT_MANUALLY.md" # This file should be located in the markdown drafts folder (the script "Markdown_to_LaTeX_PDF_Build_Script.sh" expects that).

code_directory_to_search="/path/to/your/code"

############################
# End Settings
############################

# Get all 'library()' calls, and save them to a file:
grep --recursive --include="*.R*" --only-matching --no-filename "library(.*)" "$code_directory_to_search" > "$file_to_save"
# Also get all 'require()' calls, and append them to the file:
grep --recursive --include="*.R*" --only-matching --no-filename "require(.*)" "$code_directory_to_search" >> "$file_to_save"

# Remove all 'library' and 'require' start-of-line strings:
perl -pi -e 's/^(require|library)//g' "$file_to_save"

# Remove all lines beginning with 'Binary file' (which is a false positive):
perl -pi -e 's/^Binary file.*$//g' "$file_to_save"

# Delete anything after the first encountered closing parenthesis (this assumes that there isn't more than one library() call per line of code in the codebase):
perl -pi -e 's/\).*$//g' "$file_to_save"

# Replace all commas with newlines
perl -pi -e 's/,/\n/g' "$file_to_save"

# Delete all opening parentheses:
perl -pi -e 's/\(//g' "$file_to_save"

# Remove all single- and double-quote marks:
perl -pi -e 's/"//g' "$file_to_save"
perl -pi -e "s/'//g" "$file_to_save"

# Get only unique values from the file:
unique_values=$(cat "$file_to_save" | sort --unique)

echo "$unique_values" > "$file_to_save"

# Run the R Script
markdown_table=$(Rscript "/home/jacoblevernier/Primary_Syncing_Folder/Documents/Files in Transit/Dissertation_Project/Dissertation_Proposal/Written_Report/Get_All_R_Library_Version_Numbers_and_Create_Draft_From_Them_R_Script_Portion.R")

# (Over)Write the final markdown file:

echo -e "% Generated using Get_All_R_Library_Version_Numbers_and_Create_Draft_From_Them.sh\n\n" > "$file_to_save" # Add a comment (which will be ignored by Pandoc) re: the source of the file.

echo "\chapter{R base and library version numbers}" >> "$file_to_save"
#echo "\section{(Generated from package documentation within R)}" >> "$file_to_save"
echo "\begin{center}Version numbers of R base and R packages used in this project. This table was generated automatically from package documentation within R; author names are therefore as the authors wished them to be printed.\end{center}" >> "$file_to_save"

echo -e "\n\n" >> "$file_to_save"

echo "$markdown_table" >> "$file_to_save"
