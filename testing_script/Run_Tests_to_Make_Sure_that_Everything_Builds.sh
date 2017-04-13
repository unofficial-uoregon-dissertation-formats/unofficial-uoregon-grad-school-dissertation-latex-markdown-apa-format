#!/bin/bash

########################################
# Settings
########################################

# Get this by running 'sha1sum /path/to/file.pdf' on a rendered PDF from the example files that you've manually inspected. It should be the same for markdown-based and makefile-based PDF output files.
sha1sum_of_pdf_output_that_has_been_manually_checked="67a8f4d37a2d53c1cd65f2c07d3c3a12af3a43b0"

########################################
# End Settings
########################################


# This script will build a pdf using both markdown- and makefile-based methodologies, and give you the checksum of each.


name_of_directory_of_this_script=$(dirname "$0")

echo "Moving up one directory from this script..."
cd "$name_of_directory_of_this_script"/../

echo "Running example markdown tests..."
sleep 2

# Run the markdown-to-latex example build script
./Markdown_to_LaTeX_PDF_Build_Script.sh

echo "Computing the checksum of the output PDF..."

markdown_to_latex_pdf_checksum=$(sha1sum "./builds/temporary_build_files/combined_sections_ready_for_rendering.pdf" | awk '{ print $1 }')

echo "Using the latex output from the previous script to test the makefile..."

echo "Copying the temp. build latex file and the other latex files into a temporary directory (./testing_script/latex_files_for_testing_OK_TO_DELETE), so as not to overwrite any real latex file in that directory..."

mkdir --parents "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files"

cp --recursive "./latex_files/." "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files"
	# The '/.' at the end of './latex_files/." will copy the individual files from latex_files into the new directory, rather than copying them into a copy of the latex_files directory itself.

cp "./builds/temporary_build_files/combined_sections_ready_for_rendering" "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files/main.tex"

find "./builds/temporary_build_files/" -name "*.tex" -exec cp {} "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files/" \;

cp "./Bibliography.bib" "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files/"

echo "Running makefile command..."

cd "./testing_script/latex_files_for_testing_OK_TO_DELETE/latex_files"

make all

echo "Checksumming the output PDF..."

makefile_pdf_checksum=$(sha1sum "./main.pdf" | awk '{ print $1 }')

echo -e "The markdown-based PDF checksum is \n     $markdown_to_latex_pdf_checksum"
echo -e "The Makefile-based PDF checksum is \n     $makefile_pdf_checksum"
echo -e "The expected value for both (set at the top of this script) is \n     $sha1sum_of_pdf_output_that_has_been_manually_checked"

echo "If these are the same, the test has passed."

