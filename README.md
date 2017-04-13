# Unofficial Dissertation Stylesheet for Markdown + LaTeX using APA Format for the University of Oregon

This repository contains template files and sample text for rendering a dissertation using APA format and conforming to the University of Oregon's Graduate School's [fomatting requirements](https://gradschool.uoregon.edu/sites/gradschool2.uoregon.edu/files/ETD_Style_Manual_2015-2016final032016.pdf "University of Oregon ETD Style Manual").

**This repository is not officially associated with the University of Oregon. It is currently graduate-student run.**

## Current Administrator

The current person who administrates this repository is Jacob Levernier, jleverni@uoregon.edu.

## History of this Repository

In 2014 or before, the Graduate School, apparently in consultation with [CMET](https://library.uoregon.edu/cmet "CMET"), officially supported a LaTeX stylesheet for theses and dissertations. In 2016, however, the Graduate School ended its dedicated position for a thesis and dissertation editor, and with it, it seems, official support for LaTeX (technical support can go through CMET, but there's no official expectation of tech. support).

In 2016, Tyler Matta updated the existing Grad School stylesheet to comply with APA format, and generously passed it on to several other graduate students in Psychology. Since then, I've made additional formatting corrections, and have also added support for writing using [Markdown](http://rmarkdown.rstudio.com/authoring_pandoc_markdown.html "RStudio: 'Authoring Pandoc Markdown'") (including [RMarkdown](http://rmarkdown.rstudio.com/lesson-1.html "RMarkdown Introduction")).

Given the amount of work that Tyler and then I had to put in to get the dissertation formatted correctly for the Grad School, I've created this repository. I envision it being grad-student run, though CMET or the Grad School may ask to administrate it at some point. **Contributions are welcome (see [below](#contributing-to-this-repository)).**

## Contributing to this Repository

I've made this repository public so that changes that future grad students are required to make can be saved in one place and thus made more accessible to everyone. 

**We also welcome contributions to this Readme** -- if there are things that you had to work a lot to understand (for example, how to even run the build script in the first place), write up and contribute an explanation! **Pay it forward** : )

If you use these files and are asked to make changes by the Grad. School, and are willing to contribute them back, please follow these steps:

1. Only contribute **formatting** or other **large-scale** changes, rather than changes in **content.** "Formatting" changes include things like indentation, bibliography formatting, etc. They do not include things like changing the license text on your Copyright page or replacing the example text in the Markdown files with text from your own dissertation (changes like those are less useful to share, because almost everyone will make small content adjustments for their own dissertations).
1. 
  1. If you feel comfortable using Git:
    1. Make a fork of this repository (from this repository's page on GitHub, click "Fork").
    1. Create a single commit that contains all of the changes that you would like to share (either by "squashing" your commits (see [here](http://stackoverflow.com/a/5189600 'StackOverflow: Squash my last X commits together using Git'), for example), or by just copying your altered files into a fresh copy of this repository).
    1. Make a pull request through GitHub (from your copy of the repository in GitHub, click "New Pull Request").
  1. If you do not feel comfortable using Git: Send an email to the person who's currently running this repository (see [above](#current-administrator 'Current Administrator')); we'll work together to get your changes incorporated, with gratitude for you being willing to share them.

## Using the Files in this Repository

All `.sh` files in this repository are expected to be run in a Bash shell (i.e., the "Terminal" in Linux or Mac OSX (or Cygwin or Bash for Windows on Windows). I have only tested this in Linux; I'm not sure whether the OSX version of Bash has Perl installed by default (it will need to be if you use the Markdown build script).

### If you want to write in raw (La)TeX:

#### General overview

You can ignore the Markdown files and build script, and just use the .tex and .cls files directly, using the normal pdflatex build process (if you're doing everything fully manually / not using a tool like RStudio):

1. `pdflatex file.tex`
2. `bibtex`
3. `pdflatex file.tex`
4. `pdflatex file.tex`
5. `pdflatex file.tex` (This is one run more than normal, but seems to be necessary to get page numbers to render correctly -- without it, page numbers were off by one for me)

In this case, `pdflatex` should be run on a `.tex` file that is a combined version of all of the `.tex` files in this repo. and your dissertation's `.tex` files, in this order:

1. `0_uothesisapa_preamble.tex`
1. `1_uothesisapa_prefatory_pages.tex`
1. `2_uothesisapa_begin_main_body_of_document.tex`
1. Your dissertation `.tex` file, with each chapter having a heading that looks like this: `\chapter{Chapter name goes here}` (e.g., `\chapter{Methods}`)
1. `5_uothesisapa_bibliography.tex`
1. `6_uothesisapa_end_of_document.tex`

##### Example implementation 1: Build script

The `Example_Raw_LaTeX_Build_Script.sh` script in this repository provides an example for automating this process. The steps in it generally follow the `Markdown_to_LaTeX_PDF_Build_Script.sh` script from this repo. starting at line 254; I've pulled out just the TeX-relevant portions of that script.

For further discussion of this example, please see the discussion in [Issue #1](https://github.com/publicus/unofficial-uoregon-grad-school-dissertation-latex-markdown-apa-format/issues/1 "Issue #1") in this repository.

##### Example implementation 2: Makefile

If you have `GNU Make` and latex tools `pdflatex` and `bibtex`installed on your computer, you can `cd` (i.e., go into) the `latex_files` directory of this repository, and type `make` to generate a pdf file named "main.pdf." Alternatively, `make short` skips the step of re-generating the bibliography database and compiling the PDF file for multiple times. `make clean` cleans every intermediate file.

### If you want to write in (R)markdown:

I've included example Markdown sections from my own dissertation (which is free to adapt under a [CC-BY license](https://creativecommons.org/licenses/by/4.0/ "CC-BY License")), as well as a build script that takes the Markdown, turns it into TeX using [Pandoc](http://pandoc.org/ "Pandoc"), and then compiles a PDF using LaTeX.

You will need to have [pandoc and pandoc-citeproc](http://pandoc.org/installing.html "Pandoc 'Installing' page") installed for converting the Markdown text into TeX. See also the note [above](#using-the-files-in-this-repository "Using the Files in this Repository") about the shell/terminal itself in which to run the build script.

You can replace the example Markdown text with Pandoc-style Markdown (see, e.g., [here](http://rmarkdown.rstudio.com/authoring_bibliographies_and_citations.html "RMarkdown: Citation Syntax") (search for "Citation Syntax") for how to automatically render citations using Pandoc-style Markdown).

### Installing the necessary LaTex Packages on your System

In general, I recommend searching the .tex and .cls files for lines that begin with `\usepackage`, and then making sure that those packages are installed.

If you are running Ubuntu 16.10, e.g., you will need to install `texlive-bibtex-extra` (for the `apacite` LaTeX package) and `texlive-fonts-extra` (for the `bbm` LaTeX package).

### Rendering "Draft" vs. "Final" Versions of your Dissertation

In the file "0_uothesisapa_preamble.tex", you will find a line toward the top like this:

`\documentclass[dissertation, copyright, approved, final]{uothesisapa}`

This line controls how the dissertation is rendered. It has several options:

* You can remove `approved` to remove the page in the rendered PDF that states that the Committee and Grad School have approved the dissertation.
* You can change `final` to `draftcopy` to get a copy that has line numbers and that does not contain the prefatory pages (this is useful to give to Committee members, especially in early drafts, for getting comments, since they can refer to the page and line numbers).
	* `draftcopy` mode not only enables line numbering, but also puts black bars where there is text that overflows a line where latex can't figure out how to break it onto another line (in `final` mode, this can result in an error (the error would say "overfull hbox"), so `draftcopy` mode is a good way of spotting these).
* If you are rendering a Masters thesis, you can use `\documentclass[msthesis]`, along with the other options listed above (e.g., `\documentclass[msthesis, approved, final]{uothesisapa}`).
	* If your Masters thesis does not include a Committee, you can add `lackscommittee` to the list of options (e.g., `\documentclass[msthesis, lackscommittee, approved, final]{uothesisapa}`).

### Explanation of Some Files

The file "3_uothesisapa_chapter_template.tex" is an example bare-bones TeX template to help you test your system. It's not necessary for rendering an actual dissertation, except that it shows how chapters are started (with a `\chapter{Chapter Name}` line).

The same is true of the file "4_uothesisapa_appendix_examples.tex".

The file "5_uothesisapa_bibliography.tex" lists all BibTeX (.bib) files that contain the citation information for your References Cited page. `\bibliography{Bibliography_File}`, for example, means "Look in the same folder as this file for 'Bibliography_File.bib'." Programs such as [Zotero](https://www.zotero.org/ "Zotero") and [Mendeley](https://www.mendeley.com/ "Mendeley") can export citations in .bib format for you (I especially recommend using Zotero with the free [Better Bib(La)TeX plugin](https://github.com/ZotPlus/zotero-better-bibtex "Zotero Better Bib(La)TeX plugin"), linked from [here](https://www.zotero.org/support/plugins "Zotero Plugins")). The files in this repository are currently set up to look for a file called "Bibliography.bib" (an example file is included).

The file "appendices.tex" currently looks for an external file (for my dissertation, it was called "R_Package_Version_Numbers_AUTOMATICALLY_GENERATED_DO_NOT_EDIT_MANUALLY.md.tex" and adds it as an appendix if it is found. 

The files "abstract.tex" and "acknowledgements.tex" do something similar.

The files "cover.tex" and "cv.tex" need to be edited by you for your dissertation.

The file "Markdown_to_LaTeX_PDF_Build_Script.sh" has a "Settings" section at the top, where you can change its settings. This is also the case for the scripts in the "optional_additional_files" directory, "Get_All_R_Library_Version_Numbers_and_Create_Draft_From_Them.sh" and "Get_All_R_Library_Version_Numbers_and_Create_Draft_From_Them_R_Script_Portion.R".

The file "uothesisapa.cls" is the main LaTeX style sheet for the dissertation. It has one section that you might wish to edit: the Copyright page. Search the file for "All rights reserved." and replace that text if you'd like to use a different license (for example, a [Creative Commons](https://creativecommons.org/choose/ "Creative Commons License Chooser") license).

# Contributors

The following people have contributed to this repository. Please pay their work forward by contributing any changes you're asked to make to your own dissertation by the Grad School!

* Samuel Li (2017)
* Jacob Levernier (2016)
* Tyler Matta (2016)
* Kellie Geldreich (2016, offering formatting advice)



