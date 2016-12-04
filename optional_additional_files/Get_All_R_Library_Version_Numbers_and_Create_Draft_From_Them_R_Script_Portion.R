# Cite all R packages loaded in a codebase
# Jacob Levernier
# 2016
# Released under an MIT license

############################
# Settings
############################

location_of_list_of_packages <- "./markdown_draft_examples/R_Package_Version_Numbers_AUTOMATICALLY_GENERATED_DO_NOT_EDIT_MANUALLY.md" # This file should be located in the markdown drafts folder (the script "Markdown_to_LaTeX_PDF_Build_Script.sh" expects that).

bib_file_to_write <- "./R_Packages_Bibliography_Automatically_Generated.bib"

############################
# End Settings
############################

list_of_packages <- suppressMessages( # Use this to avoid extra output.
  scan(location_of_list_of_packages, what = "character", sep="\n")
)

# Add R itself ("base") to the list:
list_of_packages <- c("base", list_of_packages)

package_version_numbers <- as.character(lapply(list_of_packages, function(package_name){
  if(is.element(package_name, installed.packages()[,1])){ # If a package IS installed, get its version number. Otherwise, print "(NA)"
    paste(packageVersion(package_name), sep = ".", collapse = ".")
  } else { # If a package is *not* installed:
    "(NA)"
  }
}))

library('knitr')

# Use knitr's write_bib function to"/home/jacoblevernier/Primary_Syncing_Folder/Documents/Files in Transit/Dissertation_Project/Dissertation_Proposal/Written_Report/Bibliography_and_TeX_Files/R_Packages_Bibliography_Automatically_Generated.bib"e of sources to cite. The function will add "R-" to the name of each package as the citation key for each (e.g., for knitr, you would use '\cite{R-knitr}')
suppressWarnings(write_bib(list_of_packages, file = bib_file_to_write))
# Also save it as a string:
bib_file_contents <- suppressWarnings(write_bib(list_of_packages, file = NULL))

citations_for_list_of_packages <- as.character(lapply(list_of_packages, function(package_name){
  paste("\\cite{R-", package_name, "}", sep = "")
}))

#list_of_packages <- as.character(lapply(list_of_packages, function(package_name){
#  paste("[R library] ", package_name, sep = "")
#}))

data_frame_of_version_numbers <- data.frame(
  "Package Name" = list_of_packages,
  "Version Number (NA if not installed through CRAN)" = package_version_numbers,
  "Package Citation" = citations_for_list_of_packages,
  check.names = FALSE,
  stringsAsFactors = FALSE
)

# Clear the citations of the packages that aren't installed (and thus won't be part of the Bibtex file written above):
data_frame_of_version_numbers[
  which(data_frame_of_version_numbers[["Version Number (NA if not installed through CRAN)"]] == "(NA)"),
  "Package Citation"
] <- ""

# str(data_frame_of_version_numbers)

# Remove citations of packages that don't have citation info (we can check the bibtext file contents for this):
for(row_number in which(data_frame_of_version_numbers[["Package Citation"]] != "")){
  if(!any(grepl(paste("\\{R-", data_frame_of_version_numbers[row_number, "Package Name"], sep = ""), bib_file_contents))){ # If the citation *doesn't* have an entry in the bibtex file...
    data_frame_of_version_numbers[row_number, "Package Citation"] <- "(Not provided by package author)"
  }
}
#View(data_frame_of_version_numbers)

#data_frame_of_version_numbers <- rbind(
#  c("R Base", R.Version()$version.string, "\\cite{R-base}"),
#  data_frame_of_version_numbers
#)

# colnames(data_frame_of_version_numbers) <- c("Package Name", "Version Number (If installed through CRAN)")

kable(
  data_frame_of_version_numbers,
  format = "markdown",
  align = "c" # Center the columns
)


