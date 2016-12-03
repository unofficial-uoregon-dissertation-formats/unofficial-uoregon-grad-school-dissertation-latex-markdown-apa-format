# University of Oregon unofficial Dissertation Stylesheet for Markdown + LaTeX using APA Format

This repository contains template files and sample text for rendering a dissertation using APA format and conforming to the University of Oregon's Graduate School's [https://gradschool.uoregon.edu/sites/gradschool2.uoregon.edu/files/ETD_Style_Manual_2015-2016final032016.pdf](fomatting requirements "University of Oregon ETD Style Manual").

**This repository is not officially associated with the University of Oregon. It is graduate-student run.**

## History of this Repository

In 2014 or before, the Graduate School, apparently in consultation with [https://library.uoregon.edu/cmet](CMET "CMET"), officially supported a LaTeX stylesheet for theses and dissertations. In 2016, however, the Graduate School ended its dedicated position for a thesis and dissertation editor, and with it, it seems, official support for LaTeX (technical support can go through CMET, but there's no official expectation of tech. support).

In 2016, Tyler Matta updated the existing Grad School stylesheet to comply with APA format, and generously passed it on to several other graduate students in Psychology. Since then, I've made additional formatting corrections, and have also added support for writing using [http://rmarkdown.rstudio.com/authoring_pandoc_markdown.html](Markdown "RStudio: 'Authoring Pandoc Markdown'") (including [http://rmarkdown.rstudio.com/lesson-1.html](RMarkdown "RMarkdown Introduction")).

Given the amount of work that Tyler and then I had to put in to get the dissertation formatted correctly for the Grad School, I've created this repository. I envision it being grad-student run, though CMET or the Grad School may ask to administrate it at some point. **Contributins are welcome (see below).**

## Contributing to this Repository

I've made this repository public so that changes that future grad students are required to make can be saved in one place and thus made more accessible to everyone. 

If you use these files and are asked to make changes by the Grad. School, and are willing to contribute them back, please follow these steps:

1. Only contribute **formatting** or other **large-scale** changes, rather than changes in **content.** "Formatting" changes include things like indentation, bibliography formatting, etc. They do not include things like changing the license text on your Copyright page (changes like those are less useful to share, because almost everyone will make small content adjustments for their own dissertations).

## What this Repository Contains



## Using the Files in this Repository

### If you want to write in raw (La)TeX:

You can ignore the Markdown files and build script, and just use the .tex and .cls files directly.


### If you want to write in (R)markdown:

I've included example Markdown sections from my own dissertation (which is free to adapt under a [https://creativecommons.org/licenses/by/4.0/](CC-BY license "CC-BY License")), as well as a build script that takes the Markdown, turns it into TeX using [http://pandoc.org/](Pandoc "Pandoc"), and then compiles a PDF using LaTeX.

