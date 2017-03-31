#!/bin/bash

#########################################
# USAGE NOTES
#########################################

# The script steps below assume that you're 'cd'ed into a directory that contains your dissertation .tex file(s) and .bib file(s) as well as all of the .tex files from the latex_files directory in this repo (and that those files have been edited following the notes in the Readme -- for example, editing "5_uothesisapa_bibliography.tex" to point to your Bibliography .bib file).

# I'm also assuming here, for simplicity, that each of your dissertation chapters (e.g., Introduction, Methods, Results, Discussion) are in a separate .tex file, and that each does not have a heading (the script steps below will add a heading to each). If they are in a combined file with \chapter{Name of Chapter} headings, that's fine; you can take out those script steps below.

#########################################
# END USAGE NOTES
#########################################

#########################################
# SETTINGS
#########################################

introduction_section_tex_file="introduction.tex"
methods_section_tex_file="methods.tex"
results_section_tex_file="results.tex"
discussion_section_tex_file="discussion.tex"
appendices_tex_file="appendix.tex"

# This should NOT include a file extension (no ".tex" at the end)
# This is the combined tex file that *this script is going to create*
combined_tex_file_lacking_file_extension="/combined_sections_ready_for_rendering"

#########################################
# END SETTINGS
#########################################

#########################################
# CONTATENATE ALL PAPER SECTIONS, AND ADD LATEX CHAPTER HEADINGS
#########################################

# Note: In the lines below, 'if [ -s filename ]' checks whether a file exists and is not blank.

cat "$input_tex_files_directory/0_uothesisapa_preamble.tex" >> "$combined_tex_file_lacking_file_extension"

echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/1_uothesisapa_prefatory_pages.tex" >> "$combined_tex_file_lacking_file_extension"

echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/2_uothesisapa_begin_main_body_of_document.tex" >> "$combined_tex_file_lacking_file_extension"


echo "
%--- Chapter 1 ----------------------------------------------------------------%
\chapter{Introduction}
" >> "$combined_tex_file_lacking_file_extension"

cat "$location_for_temporary_build_files/$introduction_section_tex_file" >> "$combined_tex_file_lacking_file_extension"


echo "
%--- Chapter 2 ----------------------------------------------------------------%
\chapter{Methodology}
" >> "$combined_tex_file_lacking_file_extension"

cat "$location_for_temporary_build_files/$methods_section_tex_file" >> "$combined_tex_file_lacking_file_extension"


echo "
%--- Chapter 3 ----------------------------------------------------------------%
\chapter{ Results}
" >> "$combined_tex_file_lacking_file_extension"

cat "$location_for_temporary_build_files/$results_section_tex_file" >> "$combined_tex_file_lacking_file_extension"


echo "
%--- Chapter 4 ----------------------------------------------------------------%
\chapter{ Discussion}
" >> "$combined_tex_file_lacking_file_extension"
	cat "$location_for_temporary_build_files/$discussion_section_tex_file" >> "$combined_tex_file_lacking_file_extension"


# Note that Appendices must come before the References list, per the UO Grad School style guide (https://gradschool.uoregon.edu/sites/gradschool2.uoregon.edu/files/ETD_Style_Manual_2013_Feb_20.pdf), p. 32.

if [ -z "$appendices_tex_file" ] # If the variable $appendices_tex_file is not blank ("")
then
	echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension"
	echo "%--- Appendices ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension"
	cat "$input_tex_files_directory/appendices.tex" >> "$combined_tex_file_lacking_file_extension"
fi

echo "%--- Bibliography ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension"
echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/5_uothesisapa_bibliography.tex" >> "$combined_tex_file_lacking_file_extension"

echo "%--- Marker for end of document ----------------------------------------------------------------%" >> "$combined_tex_file_lacking_file_extension"
echo -e "\n\n" >> "$combined_tex_file_lacking_file_extension" # Add some extra newlines, just in case they're needed (so that the new file's section starts on its own line).
cat "$input_tex_files_directory/6_uothesisapa_end_of_document.tex" >> "$combined_tex_file_lacking_file_extension"


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

cd "$(dirname '$combined_tex_file_lacking_file_extension')" # Go into the directory of the combined tex file, for simplicity

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

echo -e "Script finished. The rendered PDF can be found at \n\n$combined_tex_file_lacking_file_extension.pdf\n\n"

#########################################
# END FINAL STEPS
#########################################
