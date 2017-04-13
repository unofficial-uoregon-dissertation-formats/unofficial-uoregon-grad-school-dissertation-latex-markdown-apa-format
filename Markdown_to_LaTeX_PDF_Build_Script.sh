#!/bin/bash

# Combine Markdown Sections and Render them into a Dissertation
# Jacob Levernier
# 2016
# Released under an MIT license

#########################################
# SETTINGS
#########################################

# This should NOT have a trailing slash ('/')
location_for_temporary_build_files="./builds/temporary_build_files"

# This should NOT have a trailing slash ('/')
markdown_drafts_directory="./markdown_draft_examples"

# Note that this filename is also defined in 5_uothesisapa_bibliography.tex. So if you change it here, you also need to change it there.
bibliography_bib_file="./Bibliography.bib"

# This should NOT have a trailing slash ('/')
input_tex_files_directory="./latex_files"

# Note that this filename is also defined in uothesisapa.cls. So if you change it here, you also need to change it there.
file_for_latex_to_read_version_control_commit_number="$input_tex_files_directory/version_control_commit_number_to_print_on_draft_title_page.tex"

include_git_commit_number_true_or_false=true # This should be either 'true' or 'false'

# The steps below will work even if any of these files doesn't yet exist (it will ignore it if it doesn't yet exist):
# These are all expected to be within $markdown_drafts_directory/
abstract_section_markdown_file="Abstract_Section.md" # Note that this filename is also defined in abstract.tex. So if you change it here, you also need to change it there.
acknowledgements_section_markdown_file="Acknowledgements_Section.md" # Note that this filename is also defined in acknowledgements.tex. So if you change it here, you also need to change it there.
dedication_section_markdown_file="Dedication_Section.md" # Note that this filename is also defined in dedication.tex. So if you change it here, you also need to change it there.
introduction_section_markdown_file="Literature_Review_Section.md"
methods_section_markdown_file="Methods_Section.md"
results_section_markdown_file="Results_Section.md"
discussion_section_markdown_file="Discussion_Section.md"

# This should NOT include a file extension (no ".tex" at the end)
combined_tex_file_lacking_file_extension="combined_sections_ready_for_rendering"

combined_tex_file_lacking_file_extension_including_directory="$location_for_temporary_build_files/$combined_tex_file_lacking_file_extension"

location_of_pandoc="/usr/bin/pandoc"

####################
# Optional:
####################
automatically_find_and_cite_all_R_packages_in_your_code=false # This should be "true" or "false"

# Uncomment this if you set the above variable to 'true':
	location_of_script_for_creating_r_package_appendix="./optional_additional_files/Get_All_R_Library_Version_Numbers_and_Create_Draft_From_Them.sh"
	
# This is set in the script located at 'location_of_script_for_creating_r_package_appendix':
	file_saved_by_file_at_location_of_script_for_creating_r_package_appendix="./markdown_draft_examples/R_Package_Version_Numbers_AUTOMATICALLY_GENERATED_DO_NOT_EDIT_MANUALLY.md"

# Also note that if you set the above variable to 'true', you need to make a change in the file "5_uothesisapa_bibliography.tex" (read the comment in that file).
	r_packages_bib_file="./R_Packages_Bibliography_Automatically_Generated.bib" 	# Optional, for citing R packages
####################

automatically_cd_to_directory_of_this_script=true # This should be 'true' or 'false'.

#########################################
# END SETTINGS
#########################################

#########################################
# INITIAL STEPS
#########################################

if [ "$automatically_cd_to_directory_of_this_script" == "true" ]
then
	cd "$(dirname "$0")" # cd (go to the directory of) this script.
fi

# Create the directory we'll be using for the build, if it doesn't already exist:
mkdir --parents "$location_for_temporary_build_files"

# Remove any pdflatex cruft left over in the build folder from previous runs of this script:
if [ ! -z "$location_for_temporary_build_files" ] # Since we're using rm below, we'll make sure that the variable isn't just a blank string (which would then look to bash like just ".*", which would delete everything in the current directory : (
then
	number_of_files_in_temporary_build_directory=$(ls --almost-all "$location_for_temporary_build_files/" | wc --lines)
	echo "There are currently $number_of_files_in_temporary_build_directory files in the temporary build directory."
	if [ $number_of_files_in_temporary_build_directory -gt 0 ] # If the directory is *not empty* (its number of files is greater than 0)
	then
		echo -e "\n\n"
		echo -e "Deleting the below files (press Ctrl+C in the next 10 seconds if this does NOT look ok to you)...\n\n"
		ls "$location_for_temporary_build_files/"*
		echo -e "\nDeleting the above files (press Ctrl+C in the next 10 seconds if this does NOT look ok to you)..."
		sleep 10 # Wait for this many seconds before proceeding...
		rm -f "$location_for_temporary_build_files/"* # The -f flag here will suppress any warnings if no such files exist.
	else # If the directory *is* empty
		echo "There are no files in the temporary build directory to delete. Moving on..."
	fi
else
	echo "NOTE WELL: The variable 'location_for_temporary_build_files' is NOT set in the script. Thus, we are not deleting anything in preparation for the new run. We are also exiting the script so that you can take a look."
	exit 1 # Exit the script.
fi

#########################################
# END INITIAL STEPS
#########################################

#########################################
# ADD AN APPENDIX WITH THE CITATIONS FOR ALL R PACKAGES CALLED WITH library() or require() (assuming one invocation of either function per line) IN THE CODEBASE
#########################################

# If we've been asked to above, automatically gather all R packages (searching for 'library' and 'require' commands in all R files in the codebase) and cite them:
if [ "$automatically_find_and_cite_all_R_packages_in_your_code" == "true" ]
then
	chmod +x "$location_of_script_for_creating_r_package_appendix"
	"$location_of_script_for_creating_r_package_appendix"
fi

#########################################
# END ADD AN APPENDIX WITH THE CITATIONS FOR ALL R PACKAGES CALLED WITH library() or require() (assuming one invocation of either function per line) IN THE CODEBASE
#########################################

#########################################
# ADD THE CURRENT GIT COMMIT TO A FILE THAT LATEX WILL READ
# (This is defined in uothesisapa.cls -- search in it for "version control commit number")
#########################################

if [ "$include_git_commit_number_true_or_false" == "true" ]
then
	echo "Including most recent git commit number (this can be changed in the build script's Settings section)..."
	
	# Get the most recent commit number
	most_recent_version_control_commit=$(git log --pretty=format:'%h' -n 1)

	# Write the commit number to the file, overwriting whatever is currently there
	echo "$most_recent_version_control_commit" > "$file_for_latex_to_read_version_control_commit_number"
else
	echo "NOT including most recent git commit number (this can be changed in the build script's Settings section)..."
fi

#########################################
# END ADD THE CURRENT DATE AND GIT COMMIT TO THE PAPER METADATA SECTION
#########################################

#########################################
# DEFINE A FUNCTION FOR USING PANDOC TO CONVERT FROM MARKDOWN TO TEX
#########################################

# This function expects one argument ('$1') in the lines below, the input filename

function pandoc_render_tex_from_markdown(){
	cat "$markdown_drafts_directory/$1" |\
	perl -0777 -pe 's/<!--.*?-->//igs' |\
	"$location_of_pandoc" \
	-f markdown+table_captions+yaml_metadata_block+startnum \
	--parse-raw \
	--mathjax \
	--natbib \
	--smart \
	-o "$location_for_temporary_build_files/$1.tex"	
	
	# This can be inserted after the first line. I ended up not liking it, though, and so have commented it out here:
		# perl -0777 -pe 's/<!--\s?TODO: (.*?)-->/\\todo[]{\1}/igs' |
		#  Explanation of the perl '<!--\s?TODO: (.*?)-->' line: This replaces "<!-- TODO: ... -->" with "\todo[]{...}", which will get turned into a todo list by the todonotes latex package and placed at the beginning of a draft-class document.
	# Explanation of the perl '<!--.*?-->' line: Pandoc will render HTML comments that have any '--' inside of them. So we're deleting all comments left over.
	
	perl -pi -e 's/\\%20/ /g' "$location_for_temporary_build_files/$1.tex"
		# Pandoc 1.17.1 has an annoying "feature" of html-encoding all graphic filenames with spaces (apparently, this is stopped in 1.17.2). I don't have any other spaces in the document that are html-encoded, so I'm finding all instances of '\%20' and replacing them with a space (' ').
	
	perl -pi -e 's/\\includegraphics{/\\includegraphics[max width=\\textwidth, max height=0.75\\textheight]{/g' "$location_for_temporary_build_files/$1.tex"
		# In order to get figures/images to scale correctly, I'm having perl insert the width=\textwidth option throughout the file. Maximum height is scaled to 75% of the page's textheight in order to allow space for multi-line captions.
	
} # End of function definition

# NOTE: Options used above for use with only latex (and not pandoc-citeproc):
	# '--natbib' will cause Pandoc to convert all citations into latex `\cite{}` (and similar) commands, so that natbib/bibtex can handle actually creating a Bibliography from them and converting them into text.
	# '--standalone' is removed, so that extra header and footer tex content don't get added.
	# '--csl "$input_tex_files_directory/Bibliography_and_TeX_Files/apa.csl"' is removed, because pandoc-citeproc is not needed to render citations.
	# '--filter="/usr/bin/pandoc-citeproc"' is removed, because pandoc-citeproc is not needed to render citations.

#########################################
# END OF DEFINE A FUNCTION FOR USING PANDOC TO CONVERT FROM MARKDOWN TO TEX
#########################################

#########################################
# ONE BY ONE, USE PANDOC TO RENDER THE BODY TEXT SECTIONS, SO THAT WE CAN CONCATENATE THEM TOGETHER WITH EXTRA HEADINGS
#########################################

if [ "$automatically_find_and_cite_all_R_packages_in_your_code" == "true" ]
then
	additional_files_to_list_for_converting="$file_saved_by_file_at_location_of_script_for_creating_r_package_appendix"
fi

for file_name in \
	"$abstract_section_markdown_file" \
	"$acknowledgements_section_markdown_file" \
	"$dedication_section_markdown_file" \
	"$introduction_section_markdown_file" \
	"$methods_section_markdown_file" \
	"$results_section_markdown_file" \
	"$discussion_section_markdown_file" \
	$additional_files_to_list_for_converting
do
	echo "Processing '$markdown_drafts_directory/$file_name' to convert it into a TeX file..."
	
	if [ -s "$markdown_drafts_directory/$file_name" ] # If the file exists and is not blank (i.e., has a size greater than 0)
	then
		# Run the pandoc function defined above to create a TeX file for this section
		pandoc_render_tex_from_markdown "$file_name"
	else # If the file does NOT exist
		echo "The file does not exist or is blank. Skipping it..."
	fi
done

#########################################
# END OF ONE BY ONE, USE PANDOC TO RENDER THE BODY TEXT SECTIONS, SO THAT WE CAN CONCATENATE THEM TOGETHER WITH EXTRA HEADINGS
#########################################

#########################################
# COPY ADDITIONAL TEX FILES INTO THE BUILD DIRECTORY
#########################################

if [ "$include_git_commit_number_true_or_false" == "true" ]
then
	additional_file_to_list_for_copying="$file_for_latex_to_read_version_control_commit_number"
fi

if [ "$automatically_find_and_cite_all_R_packages_in_your_code" == "true" ]
then
	additional_file_to_list_for_copying="$additional_file_to_list_for_copying $r_packages_bib_file"
fi

for file_name in \
	"$input_tex_files_directory/cv.tex" \
	"$input_tex_files_directory/acknowledgements.tex" \
	"$input_tex_files_directory/dedication.tex" \
	"$input_tex_files_directory/cover.tex" \
	"$input_tex_files_directory/abstract.tex" \
	"$input_tex_files_directory/uothesisapa.cls" \
	"$bibliography_bib_file" \
	$additional_file_to_list_for_copying
do
	echo "Copying '$file_name' to build directory..."
	
	if [ -s "$file_name" ] # If the file exists and is not blank (i.e., has a size greater than 0)
	then
		# Run the pandoc function defined above to create a TeX file for this section
		cp "$file_name"	"$location_for_temporary_build_files/"
	else # If the file does NOT exist
		echo "The file does not exist or is blank. Skipping it..."
	fi
done

#########################################
# END COPY ADDITIONAL TEX FILES INTO THE BUILD DIRECTORY
#########################################

#########################################
# CONTATENATE ALL PAPER SECTIONS, AND ADD LATEX CHAPTER HEADINGS
#########################################

# Note: In the lines below, 'if [ -s filename ]' checks whether a file exiasts and is not blank.

cat "$input_tex_files_directory/0_uothesisapa_preamble.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"

echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension_including_directory" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/1_uothesisapa_prefatory_pages.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"

echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension_including_directory" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/2_uothesisapa_begin_main_body_of_document.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"

if [ -s "$location_for_temporary_build_files/$introduction_section_markdown_file.tex" ]
then
	echo "
%--- Chapter 1 ----------------------------------------------------------------%
\chapter{Introduction}
" >> "$combined_tex_file_lacking_file_extension_including_directory"
	cat "$location_for_temporary_build_files/$introduction_section_markdown_file.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"
fi

if [ -s "$location_for_temporary_build_files/$methods_section_markdown_file.tex" ]
then
	echo "
%--- Chapter 2 ----------------------------------------------------------------%
\chapter{Methodology}
" >> "$combined_tex_file_lacking_file_extension_including_directory"
	cat "$location_for_temporary_build_files/$methods_section_markdown_file.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"
fi

if [ -s "$location_for_temporary_build_files/$results_section_markdown_file.tex" ]
then
	echo "
%--- Chapter 3 ----------------------------------------------------------------%
\chapter{ Results}
" >> "$combined_tex_file_lacking_file_extension_including_directory"
	cat "$location_for_temporary_build_files/$results_section_markdown_file.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"
fi

if [ -s "$location_for_temporary_build_files/$discussion_section_markdown_file.tex" ]
then
	echo "
%--- Chapter 4 ----------------------------------------------------------------%
\chapter{ Discussion}
" >> "$combined_tex_file_lacking_file_extension_including_directory"
	cat "$location_for_temporary_build_files/$discussion_section_markdown_file.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"
fi

# Note that Appendices must come before the References list, per the UO Grad School style guide (https://gradschool.uoregon.edu/sites/gradschool2.uoregon.edu/files/ETD_Style_Manual_2013_Feb_20.pdf), p. 32.

echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension_including_directory"
echo "%--- Appendices ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension_including_directory"
cat "$input_tex_files_directory/appendices.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"

echo "%--- Bibliography ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension_including_directory"
echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension_including_directory" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/5_uothesisapa_bibliography.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"

echo "%--- Marker for end of document ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension_including_directory"
echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension_including_directory" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/6_uothesisapa_end_of_document.tex" >> "$combined_tex_file_lacking_file_extension_including_directory"


#########################################
# END OF CONTATENATE ALL PAPER SECTIONS, AND ADD LATEX CHAPTER HEADINGS
#########################################

#########################################
# RUN PDFLATEX AND BIBTEX ON THE COMBINED FILE TO RENDER A PDF
#########################################

# As weird as it looks, the correct/normal way to render a pdf file is to use five steps, running these commands in this order:
# 1. pdflatex file.tex
# 2. bibtex
# 3. pdflatex file.tex
# 4. pdflatex file.tex
# 5. pdflatex file.tex (This is one run more than normal, but seems to be necessary to get page numbers to render correctly -- without it, page numbers were off by one for me).
# The last few runs of pdflatex finish rendering references (including to tables and figures)

cd "$location_for_temporary_build_files"

echo "Running first round of pdflatex..."
sleep 2
pdflatex "$combined_tex_file_lacking_file_extension" # --output-directory "$location_for_temporary_build_files"

echo "Running bibtex..."
sleep 2
bibtex "$combined_tex_file_lacking_file_extension.aux"

echo "Running second round of pdflatex..."
sleep 2
pdflatex "$combined_tex_file_lacking_file_extension" # --output-directory "$location_for_temporary_build_files"

echo "Running third round of pdflatex..."
sleep 2
pdflatex "$combined_tex_file_lacking_file_extension" # --output-directory "$location_for_temporary_build_files"

echo "Running fourth round of pdflatex (this round was added because without it, Table of Contents page numbers were often off by 1)..."
sleep 2
pdflatex "$combined_tex_file_lacking_file_extension" # --output-directory "$location_for_temporary_build_files"

#########################################
# RUN PDFLATEX AND BIBTEX ON THE COMBINED FILE TO RENDER A PDF
#########################################

#########################################
# FINAL STEPS
#########################################

echo -e "Script finished. The rendered PDF can be found at \n\n$location_for_temporary_build_files/$combined_tex_file_lacking_file_extension.pdf\n\n"

#########################################
# END FINAL STEPS
#########################################
