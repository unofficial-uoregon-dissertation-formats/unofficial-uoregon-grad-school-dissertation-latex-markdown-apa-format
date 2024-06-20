% ----------------------------------------------------------------
%% uothesis.cls
%% Support for formatting of documents associated
%% with the graduate requirements for the doctoral degrees as
%% defined by the University of Oregon Graduate School.
%% All contact regarding this package should be to
%% the University of Oregon CMET Consulting.
%% Released under the LaTeX Project Public License v1.3c or later
%% See http://www.latex-project.org/lppl.txt
%% ----------------------------------------------------------------
%%
%% updated 20JUN2014
%% Added co-chairs, updated cover page for 2023 guidance
%%
%% updated 09JUN2014
%% macro cvitem may be commented out for skipped content
%% extra periods in figures and tables were removed. Oct2013 A.C.
%% acknowledgeable was made optional. Missing periods in list of tables/figures were added. May2014 S.F.
%% numbered lines in toc and lists were aligned to the left, & reduced the spacing from the numbering. Jun2014 S.F.
%% ----------------------------------------------------------------
%%
%% updated 07AUG2016
%% Formatted for APA (section headers, in-text citations, and references page(s))
%% Minor changes to CV and Approval Page
%% TOC now lists to the third level of section headers
%%
%% updated 24APR2021
%% Removed requirement for APA in-text reference citations
%%
%%----------------------------------------------------------------------------%%
%% Identification
%%----------------------------------------------------------------------------%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{uothesisapa} %[2012/02/08 v2.5.6 Submission to University of Oregon Graduate School]
\typeout{UO Dissertation Class for APA style}
\typeout{}
\typeout{Based on the UO Thesis macros by Bart Massey, et al.}
\typeout{Currently maintained by Sam Pollard}
\typeout{Accepted by the University of Oregon Graduate School}
\typeout{for multiple citation formats used with PhD Dissertations}
\typeout{20 Jun 2024}
\typeout{}
\listfiles
\newif\ifthesis
\newif\ifdraftcopy
\newif\ifcommitteedraft
\newif\iflatedraft
\newif\ifdraftimage
\newif\ifdraft
\newif\iffinal
\newif\ifsc
\newif\iflipsum
\newif\ifjustified
\newif\ifamstex
\newif\ifchem
\newif\ifbound
%\newif\ifnatbib
\newif\ifapacite
\newif\ifnotables
\newif\ifnofigures
\newif\iflistings
\newif\if@dissertation
\newif\if@approved
\newif\if@copyright
\newif\if@gsmodern
\newif\if@numsections
\newif\if@contnumb
\newif\if@draftimage
\newif\if@lackscommittee

\DeclareOption{dissertation}{\@dissertationtrue\thesistrue}
\DeclareOption{msthesis}{\@dissertationfalse\thesistrue}
\DeclareOption{approved}{\@approvedtrue}
\DeclareOption{draftimages}{\draftimagetrue\PassOptionsToPackage{draft}{graphicx}}
\DeclareOption{draftcopy}{\drafttrue\draftcopytrue\boundtrue}
\DeclareOption{lackscommittee}{\@lackscommitteetrue}
\DeclareOption{committeedraft}{\drafttrue\committeedrafttrue}
\DeclareOption{latedraft}{\drafttrue\latedrafttrue}
\DeclareOption{copyright}{\@copyrighttrue}
\DeclareOption{gsmodern}{\@gsmoderntrue}
\DeclareOption{numsections}{\@numsectionstrue}
\DeclareOption{amstex}{\amstextrue}
\DeclareOption{chemistry}{\chemtrue\amstextrue}
\DeclareOption{smallcaps}{\sctrue}
\DeclareOption{justified}{\justifiedtrue}
\DeclareOption{nofigures}{\nofigurestrue}
\DeclareOption{notables}{\notablestrue}
\DeclareOption{cheqns}{}
\DeclareOption{final}{\draftcopyfalse\draftimagefalse
\committeedraftfalse\latedraftfalse\finaltrue}
\DeclareOption{lipsum}{\lipsumtrue}
\DeclareOption{bound}{\boundtrue}
\DeclareOption{apacite}{\apacitetrue}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{apacite}}
\ProcessOptions
\ifthesis\else
\typeout{warning: Neither msthesis nor dissertation specified}
\fi
\ifbound
\typeout{PAGE FORMAT CHANGED FOR BINDING AND PRINTING}
\typeout{This format DOES NOT COMPLY with University of Oregon Guidelines}
\typeout{For personal use only!}
\fi
\iflatedraft\PassOptionsToClass{12pt,draft}{report}\fi
\ifcommitteedraft\PassOptionsToClass{12pt,draft}{report}\fi
\ifdraftcopy\PassOptionsToClass{10pt,draft}{report}
\PassOptionsToClass{draft}{todonotes}\fi
\iffinal
\ifbound
\PassOptionsToClass{12pt,twoside}{report}
\else
\PassOptionsToClass{12pt}{report}
\fi\fi
\LoadClass{report}
\RequirePackage[letterpaper]{geometry} % Prevents from using A4
\RequirePackage{float}
%\RequirePackage{subfig}
\RequirePackage{subcaption}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{graphicx}
\RequirePackage{setspace}
\RequirePackage{xspace}
\RequirePackage[left,pagewise]{lineno}
\RequirePackage{layouts}
\RequirePackage[colorinlistoftodos]{todonotes}
\RequirePackage{ragged2e}
\captionsetup{labelsep=space}
\setlength\RaggedRightRightskip{0pt plus 1cm}
\setlength\RaggedRightParindent{0.5in}

\ifchem
\RequirePackage[version=3]{mhchem}
\RequirePackage[super, biblabel=brackets]{achemso}
\fi
\ifamstex
\RequirePackage{amsmath,amsthm,amssymb}
\fi
\iflipsum
\RequirePackage{lipsum}
\fi
\ifapacite
\RequirePackage[natbibapa]{apacite}
\bibliographystyle{apacite}
\fi

\ifdraft
\RequirePackage{draftwatermark}
\newcommand{\watermark}[5]{\SetWatermarkAngle{#1}
\SetWatermarkLightness{#2}
\SetWatermarkFontSize{#3}
\SetWatermarkScale{#4}
\SetWatermarkText{\uppercase{#5}}}
\ifdraftcopy\watermark{45}{0.95}{5cm}{2.5}{Draft}\fi
\ifcommitteedraft\watermark{45}{0.95}{5cm}{2.25}{Committee Draft}\fi
\iflatedraft\watermark{45}{0.95}{5cm}{2.5}{Review Proof}\fi
\fi

\newcommand{\cleanbreak}{
\ifjustified
\\\hfil
\else
\newline
\fi}

\ifchem
\newcounter{reaction}
\renewcommand\thereaction{Formula\ \thechapter.\arabic{reaction}}
\@addtoreset{reaction}{chapter}
\newcommand\reactiontag{\refstepcounter{reaction}\tag{\thereaction}}
\newcommand{\chem}[2][]{\begin{equation}\cee{#2}%
\ifx\@empty#1\@empty\else\label{#1}\fi\reactiontag\end{equation}}
\newcommand{\chemarray}[3][]{\begin{equation}\begin{array}{#2}\cee{#3}%
\end{array}\ifx\@empty#1\@empty\else\label{#1}\fi\reactiontag\end{equation}}
\newcommand{\Chem}[2][]{\begin{multline}\cee{#2}%
\ifx\@empty#1\@empty\else\label{#1}\fi\reactiontag\end{multline}}
\fi
\newcommand*{\cst@xspace}{\expandafter\xspace}
\newcommand*{\cst@latin}{\expandafter}
\newcommand*{\etc}{\@ifnextchar.{\cst@etc}{\cst@etc.\cst@xspace}}
\newcommand*{\invacuo}{\cst@latin{in vacuo}\cst@xspace}
\newcommand*{\etal}{\@ifnextchar.{\cst@etal}{\cst@etal.\cst@xspace}}
\newcommand*{\eg}{\cst@eg.}
\newcommand*{\ie}{\cst@ie.}
\newcommand*{\cst@etal}{\cst@latin{et~al}}
\newcommand*{\cst@etc}{\cst@latin{etc}}
\newcommand*{\cst@ie}{\cst@latin{i.e\spacefactor999\relax}}
\newcommand*{\cst@eg}{\cst@latin{e.g\spacefactor999\relax}}

\newenvironment{normalspace}{\begin{singlespacing}}{\end{singlespacing}}
\def\@mydouble{\endsinglespace\large\normalsize\setstretch{1.7}}
\def\@mysingle{\singlespace\large\normalsize\setstretch{1.7}}
\def\@mybibsingle{\singlespace\large\normalsize\setstretch{1}}
\def\@draftdate{{\the\year/\/\two@digits{\the\month}/\/\two@digits{\the\day}}}
\def\@longdraftdate{\today}
\if@dissertation
   \ifdraftcopy
     \gdef\@cappapertype{Dissertation Draft}
   \else
     \gdef\@cappapertype{Dissertation}
   \fi
\else
   \ifdraftcopy
     \gdef\@cappapertype{Thesis Draft}
   \else
     \gdef\@cappapertype{Thesis}
   \fi
\fi
\xdef\@upperpapertype{\uppercase{\@cappapertype}}
\xdef\@papertype{\lowercase{\@cappapertype}}
\ifdraftcopy
   \def\@draftstring{{{\sc Draft of} \@draftdate}}
\else
   \def\@draftstring{}
\fi
\def\@disclaimer{
\ifcommitteedraft\textcolor{red}{\textbf{\uppercase{committee draft}}}\fi
\iflatedraft\textcolor{red}{\textbf{\uppercase{review proof}}}\fi
\ifdraftcopy\textcolor{red}{\textbf{\uppercase{editing draft}}}\fi
\vspace*{0.5in}

\textcolor{red}{\textbf{\uppercase{This is a draft copy for review and editing purposes only!}}}
\vspace*{10pt}
\setlength\fboxsep{10pt}
\setlength\fboxrule{2pt}
\framebox[1\columnwidth]{\parbox{0.95\columnwidth}{\textcolor{black}
{\textbf{This draft format in no way complies with the University
of Oregon Style Graduate School Style Guide for theses or dissertations.
This draft may employ 10 point fonts for paper conservation, line numbering
for ease of editing, or watermarking and editing notations;  all of which violate
the Graduate School Style Guide for final documents.  See the uothesis.cls
documentation for instructions on producing a properly formatted document.}}}}}
\def\@bounddisclaimer{%
\parbox{0.75\textwidth}{\centering
\begin{spacing}{0.5}
{\tiny This document is for the personal use of the author and does not comply
with the University of Oregon Graduate School.  Please contact the University
of Oregon Graduate School for information on how to obtain an official copy
of this document.}
\end{spacing}}\\
\vfill\LaTeX
}

\def\covertitle#1{\gdef\@covertitle{#1}\gdef\@uppercovertitle{\begin{doublespace} \uppercase{#1} \end{doublespace}}}
\def\abstracttitle#1{\gdef\@abstracttitle{#1}\gdef\@upperabstracttitle{\uppercase{#1}}}

\def\author#1{\gdef\@author{#1}\gdef\@upperauthor{\uppercase{#1}}}
\def\narrowauthor#1{\gdef\@narrowauthor{#1}\gdef\@uppernarrowauthor{\uppercase{#1}}}

\def\department#1{\gdef\@department{#1}}
\def\narrowdepartment#1{\gdef\@narrowdepartment{#1}}

\def\major#1{\gdef\@major{#1}}


\def\chair#1{\gdef\@chair{#1}}

\newif\if@cochair
\def\cochair#1{\gdef\@cochair{#1}\@cochairtrue}

% CM: I needed two equal co-chairs instead of one chair and one co-chair so I added this command which basically is just a pass-through (see later)
\newif\if@cochairs
\def\cochairs#1{\gdef\@cochairs{#1}\@cochairstrue}

\def\committee#1{\gdef\@committee{#1}}
\def\graddean#1{\gdef\@graddean{#1}}

\def\degreetype#1{\gdef\@degree{#1}}
\def\degreemonth#1{\gdef\@degreemonth{#1}}
\def\degreeyear#1{\gdef\thedegreeyear{#1}}

\long\def\abstract#1{\gdef\@abstract{#1}}
\newif\if@dedication
\long\def\dedication#1{\gdef\@dedication{#1}\@dedicationtrue}
\newif\if@acknowledge
\long\def\acknowledge#1{\gdef\@acknowledge{#1}\@acknowledgetrue}

\def\@optional#1{\let\what=\expandafter\csname #1
\endcsname\ifx\what\relax\else\what\fi}
\newcommand{\@sigline}[2]{Approved: \rule{#1}{.4pt}\\*[-0.25\baselineskip]{#2}}
\newcommand{\@Sigline}[1]{Approved: \hrule\vspace*{-\parskip}\vspace*{4pt}{#1}}


%------------------------------------------------------------------------------%
% CV Definitions
%------------------------------------------------------------------------------%
\def\cvoneline#1#2{ \\*[\baselineskip] {#1}: {#2}}
\def\cvmultiline#1#2{
  \par\vspace{1.5\baselineskip}\noindent{#1}:\\*[\baselineskip]\nopagebreak\indent\parbox[b]{5in}{#2}
}
\newlength{\@cvhangindent}
\setlength{\@cvhangindent}{\parindent}
\addtolength{\@cvhangindent}{.5in}  % this drives the amount of indent after line 1
\long\def\cvpars#1{\par #1}
\long\def\cvitem#1#2{\par\vspace{.75\baselineskip}\noindent{\hspace*{-4pt}#1}:\vspace{\baselineskip}\nopagebreak\par{#2}}

\gdef\@schools{}
\gdef\@degrees{}
\gdef\@birthplace{}
\gdef\@birthday{}
\gdef\@interests{}
\gdef\@awards{}
\gdef\@experience{}
\gdef\@publications{}
\def\birthplace#1{\gdef\@birthplace{#1}}
\def\birthday#1{\gdef\@birthdate{#1}}
\def\school#1{\expandafter\gdef\expandafter\@schools\expandafter{\@schools\cvpars{#1}}}
\long\def\degree#1{\expandafter\gdef\expandafter\@degrees\expandafter{\@degrees\cvpars{#1}}}
\def\interests#1{\expandafter\gdef\expandafter\@interests\expandafter{\@interests\cvpars{#1}}}
\def\position#1{\expandafter\gdef\expandafter\@experience\expandafter{\@experience\cvpars{\hspace*{-3pt}#1\vspace{-.75\baselineskip}}}}
\def\award#1{\expandafter\gdef\expandafter\@awards\expandafter{\@awards\cvpars{\hspace*{-3pt}#1\vspace{-.75\baselineskip}}}}
\def\publication#1{\expandafter\gdef\expandafter\@publications\expandafter{\@publications\cvpars{\hspace*{-3pt}#1}}}
\setstretch{1.7}

%------------------------------------------------------------------------------%
% Define headers and footers
%------------------------------------------------------------------------------%
\newcommand{\@normalheaderdims}{
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}

\ifbound
  \oddsidemargin 0.6in
  \evensidemargin 0.6in
  \textwidth 5.8in
  \footskip 0.5in
  \footnotesep 15pt
  \parindent 24pt
  \topmargin 0in
\else
  \oddsidemargin 0.25in
  \evensidemargin 0.25in
  \textwidth 6in
  \footskip 0.25in
  \footnotesep 15pt
  \parindent 24pt
  \topmargin 0in
\fi

\@normalheaderdims

\def\@fromtopskip#1{
  \@tempdima=#1
     \advance\@tempdima by-1in
     \advance\@tempdima by-\topmargin
     \advance\@tempdima by-\headheight
     \advance\@tempdima by-\headsep
     \advance\@tempdima by-\baselineskip
     \advance\@tempdima by12pt
     \hbox to0pt{}\nointerlineskip\vskip\@tempdima
}

\setcounter{tocdepth}{3}
\newcounter{@shownumdepth}

\if@gsmodern
  \setcounter{@shownumdepth}{2}
\else
\if@numsections
   \setcounter{@shownumdepth}{2}
\else
   \setcounter{@shownumdepth}{0}  % 0 supresses section numbers
   \setcounter{secnumdepth}{3}
\fi
\fi

\def\@emit#1{\if@filesw\immediate\write\@mainaux{#1}\fi}
\hyphenpenalty=500000
\tolerance=5000
\widowpenalty=10000
\clubpenalty=10000
\raggedbottom

\def\@maketitlepage{
  \newpage
  \thispagestyle{empty}
  \ifdraftcopy\linenumbers\fi
  \begin{center}
  \vspace*{0.25in}
  \doublespacing
  \@covertitle
  \singlespacing
  \vfill
  by \\*[\baselineskip]
  \@author\\*
  \vfil
  \ifdraft\@disclaimer\\\fi\vfill
  \doublespacing
   A \@papertype\ accepted and approved in partial fulfillment of the \\*
   requirements for the degree of \\*
   \@degree \\*
   in \@major \\*[\baselineskip]

   Dissertation Committee:\\*
   \if@cochairs
     \@cochairs
   \else
     \@chair, Chair\\*
     \if@cochair
       \@cochair, Co-chair\\*
     \fi
   \fi
   \if@lackscommittee
     % If we don't have a committee, do nothing. Otherwise, render the committee. Rather, just enter a few blank lines.
   \else
     \@committee
   \fi
   \vfill
   University of Oregon \\*
   \@degreemonth ~\thedegreeyear\\
   \end{center}
}

\def\@makecopyrightpage{
\if@copyright
\clearpage
\thispagestyle{plain}
\@fromtopskip{5in}
\begin{singlespacing}
\ifbound\else\begin{center}
% Automatically give the author and year, without an extra linebreak beneath (as you would get from using '\ifbound\else\centerline{\copyright ~\thedegreeyear ~\@author}\fi'):
\copyright ~\thedegreeyear ~\@author \\

All rights reserved.

%%%%%%%%%%%%%%%%%%%%%%
% Below is an example for a Creative-Commons style license, if you want
% to use one (if you use this, delete "All rights reserved." above). It
% assumes that you've downloaded the logo for the license (you'll need
% to change '/path/to/logo/image.eps' where you stored the file.
% (You would uncomment both of the lines below, and choose whatever
% license you wanted (not just Attribution, but maybe a more restrictive
% license -- see https://creativecommons.org/choose/ for help choosing).
%%%%%%%%%%%%%%%%%%%%%%

%This work, including text and images of this document but not including supplemental files (for example, not including software code and data), is licensed under a Creative Commons\\ \textbf{\href{http://creativecommons.org/licenses/by/4.0/}{Attribution 4.0 International License}.}\\

%\raisebox{-.5\height}{\includegraphics[height=2em]{/path/to/logo/image.eps}}

%%%%%%%%%%%%%%%%%%%%%%
% End of example
%%%%%%%%%%%%%%%%%%%%%%

\end{center}\fi

\ifbound{\centering\@bounddisclaimer}\else\vfill\fi\vfil

\end{singlespacing}
\fi
}

%------------------------------------------------------------------------------%
% Define Abstract
%------------------------------------------------------------------------------%
\def\@makeabstractpage{
  \clearpage
  \pagestyle{plain}
  \@startchapter{\@upperpapertype\ ABSTRACT}
  \begin{spacing}{1}
    \vspace*{3ex}
    \noindent
    \@author\\*[\baselineskip]
    \@degree\ in \@major \\*[\baselineskip]
    Title: \@abstracttitle\\*[\baselineskip]
    %\\*[2\baselineskip]
  \end{spacing}
  \ifjustified
  \else
    \RaggedRight
  \fi
  \@abstract
}

%------------------------------------------------------------------------------%
% Define Acknowledgments
%------------------------------------------------------------------------------%
\def\@makeackpage{
  \if@acknowledge
    \clearpage
    \thispagestyle{plain}
    \@startchapter{ACKNOWLEDGEMENTS}
    \vspace*{\baselineskip}
    \par
      \ifcommitteedraft
        \begin{center}\@disclaimer\end{center}
        \else
          \ifjustified
          \else
            \RaggedRight
          \fi
          \@acknowledge
          \iflatedraft
            \vfill
            \begin{center} \textcolor{red}{\textbf{\uppercase{review proof}}}\\ \end{center}
          \fi
      \fi
  \fi
}

%------------------------------------------------------------------------------%
% Define Dedication
%------------------------------------------------------------------------------%

% Changed by Jacob L. throughout this dedication section definition: all instances of '\begin{center}' and '\end{center}' were replaced with '\begin{flushleft}' and '\end{flushleft}', following the Graduate School's request to left-justify the text.

\def\@makededpage{
  \if@dedication
    \clearpage
    \thispagestyle{plain}
    \settowidth{\@tempdima}{\@dedication}
    \ifcommitteedraft
      \setlength{\@tempdima}{0pt}
    \fi
    \ifdim\@tempdima<\textwidth
      \@fromtopskip{4in}
      \@chapterline{}
    \else
      \@fromtopskip{3in}
      \@startchapter{}
    \fi
    \vspace*{\baselineskip}
    \par
    \ifcommitteedraft
      \begin{flushleft}\@disclaimer \end{flushleft}
    \else
      \begin{flushleft}\@dedication \end{flushleft}
      \vfill
        \iflatedraft
          \begin{flushleft}
            \textcolor{red}{\textbf{\uppercase{review proof}}}\\
          \end{flushleft}
        \fi
    \fi
  \fi
}

%------------------------------------------------------------------------------%
% Define CV
% Comment out irrelevant lines with irrelevant section headers.
%------------------------------------------------------------------------------%
\def\@makevita{
  \clearpage
  \thispagestyle{plain}
  \@startchapter{CURRICULUM VITAE}
  \begin{singlespacing}
    \vspace*{3ex}
    \noindent NAME OF AUTHOR:\quad \@author \vskip1.5\baselineskip
    \everypar={\hangindent=\@cvhangindent}
    \noindent GRADUATE AND UNDERGRADUATE SCHOOLS ATTENDED: \vskip\baselineskip \@schools \vskip\baselineskip
    \vskip \baselineskip
    \noindent DEGREES AWARDED: \vskip\baselineskip \@degrees \vskip\baselineskip
    \vskip \baselineskip
    \noindent AREAS OF SPECIAL INTEREST: \vskip\baselineskip \@interests \vskip\baselineskip
    \everypar={
      \parskip=0.75\baselineskip
      \hangindent=\@cvhangindent
      \interlinepenalty=\@M
    }
    \cvitem{PROFESSIONAL EXPERIENCE}{\@experience} \vskip .5\baselineskip
    \cvitem{GRANTS, AWARDS AND HONORS}{\@awards} \vskip .5\baselineskip
    \cvitem{PUBLICATIONS}{\@publications} \vskip .5\baselineskip
    \par
  \end{singlespacing}
}

\def\@maketitlepages{
  \pagenumbering{arabic}
  \@maketitlepage
  \@makecopyrightpage
  \@makeabstractpage
  \@makevita
  \@makeackpage
  \@makededpage
  \begin{singlespacing}
    \clearpage
    \@tableofcontents
    \ifnofigures\else
    \IfFileExists{\jobname.\ext@figure}{\@listoffigures}{\@starttoc{\ext@figure}}
    \fi
    \ifnotables\else
    \IfFileExists{\jobname.\ext@table}{\@listoftables}{\@starttoc{\ext@table}}
    \fi
    \iflistings
    \def\ext@listing{lol}
    \IfFileExists{\jobname.\ext@listing}{\@listoflistings}{\@starttoc{\ext@listing}}
    \fi
    \clearpage
    \@normalheaderdims
    \clearpage
  \end{singlespacing}}

\def\@makedraftcover{
\clearpage
\thispagestyle{empty}
\linenumbers
\begin{center}
\vspace*{0.25in}
{\large \@upperpapertype}\\
\begin{singlespacing}
{\large \@covertitle}\\
\vspace*{\baselineskip}
Draft of \@longdraftdate\\

% Added by Jacob L. to render a version control commit number on the title page in draft form¸ to make it easier to understand which copy a committee member was given.
\gdef\versioncontrolcommitnumberfilename{version_control_commit_number_to_print_on_draft_title_page.tex}

\IfFileExists{\versioncontrolcommitnumberfilename} % If the file exists, import it; otherwise, ignore it.
    {\gdef\versioncontrolcommitnumber{\input{\versioncontrolcommitnumberfilename}}} % If the file DOES exist
    {\gdef\versioncontrolcommitnumber{}} % If the file DOES NOT exist, we'll define a blank default for the variable \versioncontrolcommitnumber

\sbox0{\versioncontrolcommitnumber}
\ifdim\wd0=0pt % Following http://tex.stackexchange.com/a/44924/56363, assess whether the text is "empty" by seeing whether its printed form has any width (a blank string doesn't). IF id doesn't have any width, we'll print nothing. Otherwise, we'll print the message below the '\else' line.
  % print nothing
\else
  Version Control commit number \versioncontrolcommitnumber
\fi

% END of section for rendering version control commit numbers

\@author
\end{singlespacing}
\end{center}
{\small
\begin{singlespacing}
\begin{center}ABSTRACT\end{center}
{\footnotesize \par\@abstract}
\vfill
\begin{center}
\noindent
\@disclaimer\\
\end{center}
\end{singlespacing}}
\clearpage}

\def\maketitle{
  \ifdraftcopy
    \iflatedraft
      \@maketitlepages
    \else
      \ifcommitteedraft
        \@maketitlepages
      \else
        \@makedraftcover
        \pagenumbering{arabic}
        \listoftodos \clearpage
        \@tableofcontents
        \ifnofigures\else
        \IfFileExists{\jobname.\ext@figure}{\@listoffigures}{\@starttoc{\ext@figure}}
        \fi
        \ifnotables\else
        \IfFileExists{\jobname.\ext@table}{\@listoftables}{\@starttoc{\ext@table}}
        \fi
        \iflistings
        \def\ext@listing{lol}
        \IfFileExists{\jobname.\ext@listing}{\@listoflistings}{\@starttoc{\ext@listing}}
        \fi
      \fi
    \fi
  \else
    \@maketitlepages
  \fi
  \pagestyle{plain}
  \ifjustified\else\RaggedRight\fi
}

\def\@footlines#1{\hbox to\textwidth{#1}}
  \ifbound
    \def\@footer{\hfill\rm\thepage}
  \else
    \def\@footer{\hfil\rm\thepage\hfil}
  \fi
\def\ps@tocheadings{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{}
  \let\@evenfoot\@oddfoot
  \let\@evenhead\@oddhead
}
\def\ps@tocextraheadings{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{{\hbox to\textwidth{Chapter\hfil{Page}}}}
  \def\@evenfoot\@oddfoot
  \def\@evenhead{{\hbox to\textwidth{Chapter\hfil{Page}}}}
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}
\def\ps@lofextraheadings{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{{\hbox to\textwidth{Figure\hfil{Page}}}}
  \def\@evenfoot\@oddfoot
  \def\@evenhead{{\hbox to\textwidth{Figure\hfil{Page}}}}
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}
\def\ps@lotextraheadings{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{{\hbox to\textwidth{Table\hfil{Page}}}}
  \def\@evenfoot\@oddfoot
  \def\@evenhead{{\hbox to\textwidth{Table\hfil{Page}}}}
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}
\def\ps@lolextraheadings{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{{\hbox to\textwidth{Listing\hfil{Page}}}}
  \def\@evenfoot\@oddfoot
  \def\@evenhead{{\hbox to\textwidth{Listing\hfil{Page}}}}
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}
\def\ps@plain{
  \def\@oddfoot{\@footlines{\@footer}}
  \def\@oddhead{}
  \let\@evenfoot\@oddfoot
  \let\@evenhead\@oddhead
  \textheight 620pt
  \headheight 14pt
  \headsep 14pt
}

%------------------------------------------------------------------------------%
% TOC, LOF and LOT
%------------------------------------------------------------------------------%
\renewcommand*{\@dotsep}{.5} % Added by JL to change the TOC dot spacing.

\renewcommand*{\@tocrmarg}{8em} % Added by JL to change the TOC text right margin (since all TOC lines must have at least three dots between the text and the page number). I just played around with this number and dotsep above until the TOC looked correct. See http://tex.stackexchange.com/a/49898 for an overview of dotsep, tocrmarg, and pnumwidth.

% Added by JL following http://tex.stackexchange.com/a/16036
  %\usepackage{tocloft}
  %\renewcommand{\cftbeforetoctitleskip}{-0.25in}
  %\renewcommand{\cftchapaftersnum}{ }
  %\renewcommand{\cftaftertoctitleskip}{2.0\baselineskip}

\def\@tableofcontents{%
  \clearpage
  \markboth{Chapter}{Chapter}
  \thispagestyle{tocheadings}
  \@startchapter{TABLE OF CONTENTS}
  \vspace*{14pt}
  \noindent
  \makebox[\textwidth][l]{Chapter \hfill Page}
  \protect\nopagebreak\noindent\sloppy\pagestyle{tocextraheadings}\@mysingle\@starttoc{toc} % '\protect\nopagebreak\protect\noindent\sloppy' added by JL following http://tex.stackexchange.com/a/24799 in order to encourage better line breaking in Table of Contents entries for long headings. This gets the ToC formatted correctly in final mode (as opposed to just in draft mode).
}

\def\@listoffigures{%
  \clearpage
  \markboth{Figure}{Figure}
  \thispagestyle{tocheadings}
  \@startchapter{LIST OF FIGURES}
  \vspace*{14pt}
  \noindent
  \makebox[\textwidth][l]{Figure \hfill Page}
  \protect\nopagebreak\sloppy\pagestyle{lofextraheadings}\@mydouble\@starttoc{\ext@figure} % '\protect\nopagebreak\protect\noindent\sloppy' added by JL following http://tex.stackexchange.com/a/24799 in order to encourage better line breaking in Table of Contents entries for long headings. This gets the ToC formatted correctly in final mode (as opposed to just in draft mode).
}

\def\@listoftables{%
  \clearpage
  \markboth{Table}{Table}
  \thispagestyle{tocheadings}
  \@startchapter{LIST OF TABLES}
  \vspace*{14pt}
  \noindent
  \makebox[\textwidth][l]{Table \hfill Page}
  \protect\nopagebreak\sloppy\pagestyle{lotextraheadings}\@mydouble\@starttoc{\ext@table} % '\protect\nopagebreak\protect\noindent\sloppy' added by JL following http://tex.stackexchange.com/a/24799 in order to encourage better line breaking in Table of Contents entries for long headings. This gets the ToC formatted correctly in final mode (as opposed to just in draft mode).
}

\def\@listoflistings{%
  \clearpage
  \markboth{Listing}{Listing}
  \thispagestyle{tocheadings}
  \@startchapter{LIST OF SOURCE CODE LISTINGS}
  \vspace*{14pt}
  \noindent
  \makebox[\textwidth][l]{Listing \hfill Page}
  \protect\nopagebreak\sloppy\pagestyle{lolextraheadings}\@mydouble\@starttoc{\ext@listing}
}
\if@gsmodern
   \def\numberline#1{\hbox to\@tempdima{\hskip 2.75em #1.\hfil}}
\else
   \def\numberline#1{\hbox to\@tempdima{\hfil #1. \hskip 2.75em}}
\fi
\def\@dottedtocline#1#2#3#4#5{ % JL: For a line-by-line explanation of this code, see https://tex.stackexchange.com/questions/197360/meaning-of-advance-leftskip-tempdima-null-nobreak-hskip-leftskip
  \ifnum #1>\c@tocdepth
  \else
    \vskip \z@ \@plus.2\p@
    {\leftskip=#2\relax \rightskip=\@tocrmarg
     \parfillskip=-\rightskip
     \parindent=#2\relax \hangindent=0em % Changed by JL. This was #2\relax for parindent and 1.5em for hangindent, but the Grad School told me that there should NOT be a hanging indent in wrapped TOC lines.
     \singlespace\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima=#3\relax
     \advance\leftskip by\@tempdima \null\nobreak
     \hskip -\leftskip
     {#4}\nobreak
     \leaders\hbox{
       $\m@th
       \mkern \@dotsep mu\hbox{.}\mkern
       \@dotsep
       mu$
     }\hfill
     \nobreak
     %\def\@pnumwidth{0in} % Added by JL following http://tex.stackexchange.com/a/251457 to adjust the amount of space between the last line of each TOC entry and the page number (since there need to be at least 3 dots between them).
     \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}
      \par
    }
  \fi
}
\def\@sechack{\relax}

%--- This is the chapter format for the TOC
\def\l@chapter#1#2{
   \pagebreak[3]\par % Was: \pagebreak[3]\par\vskip\baselineskip
   \@dottedtocline{0}{0em}{1.8em}{#1}{#2}  %  {1.8em} is the space between chapter# and title #2 is the page number
   \nopagebreak\par
   \gdef\@sechack{\vskip\baselineskip\gdef\@sechack{\relax}}} %was \vskip\baselineskip\gdef removed to reduce the space

%--- This is the section format for the TOC
\if@gsmodern
   \def\l@section{\@sechack\@dottedtocline{1}{0.5in}{2em}}
\else
  \if@numsections
     \def\l@section{
       \@sechack\@dottedtocline{1}{0.5in}{2em}}
  \fi
\fi
\def\l@figure{\@dottedtocline{0}{0in}{2.3em}}%
\def\l@table{\@dottedtocline{0}{0in}{2em}}

%------------------------------------------------------------------------------%
% CHAPTER HEADINGS FORMATTING
%------------------------------------------------------------------------------%
\def\@chapapp{CHAPTER}
\renewcommand{\thechapter}{\arabic{chapter}}
\def\@makechapterhead#1{{
\centering
\ifnum \c@secnumdepth>\m@ne
  \@chapapp{}
  \if@appendices
    \ifnum 1=\aux@appendices
      \ifnum 1=\c@chapter
        \else
          \typeout{warning:
                   extra appendices; rerun LaTeX}
          \thechapter
        \fi
      \else
        \thechapter
      \fi
    \else
      \Roman{chapter}
    \fi
    \par
    \vskip 0pt  %-- Was 2ex.  Removes extra space between chapter num and Chapter titel
  \fi
  \ifsc\textsc{#1}\else\uppercase{#1}\fi\par\nopagebreak\vskip 0pt}} % was 4ex. Removed the space between chapter title and paragraph
  \def\@makeschapterhead#1{{
    \@startchapter{\ifsc\textsc{#1}\else\uppercase{#1}\fi}\par
    \nopagebreak\vskip 4ex}}

\def\chapter{
  \clearpage\global\@topnum\z@
  \@afterindenttrue\secdef\@chapter\@schapter
}
\def\@chapter[#1]#2{
  \stepcounter{chapter}
  \if@appendices
    \protected@edef\@currentlabel{\csname p@chapter\endcsname\Alph{chapter}}
  \else
    \protected@edef\@currentlabel{\csname p@chapter\endcsname\Roman{chapter}}
  \fi
  \typeout{[#1]}

  \if@appendices
    \ifnum\c@chapter=1
      \ifnum\aux@appendices=1
        \addtocontents{toc}{
          \protect\vspace{3ex}  %  Was: \protect\pagebreak[3]\protect\vspace{3ex}
          \protect\noindent\sloppy % '\sloppy' added by JL following http://tex.stackexchange.com/a/24799 in order to encourage better line breaking in Table of Contents entries for long headings.
          {}\protect\nopagebreak
        }
      \else
        \addtocontents{toc}{
          \protect\vspace{3ex}  % Was:\protect\pagebreak[3]\protect\vspace{3ex}
          \protect\noindent\sloppy % '\sloppy' added by JL following http://tex.stackexchange.com/a/24799 in order to encourage better line breaking in Table of Contents entries for long headings.
          {APPENDICES}\protect\nopagebreak
        }
      \fi
    \fi
  \fi

  \@emit{\string\global\string\aux@appendices=\number\c@chapter}
  \ifnum \c@secnumdepth >\m@ne
    \if@appendices
      \ifnum\aux@appendices=1
        \cleardoublepage
        \phantomsection % Added by JL for compatibility with the hyperref package, following http://tex.stackexchange.com/a/23503 (this will get the hyperlink anchor for the line to be correct, so that when it's clicked on, it will take the reader to the correct page)
        \addcontentsline{toc}{chapter}
          {APPENDIX:
            \ifsc\textsc{#1}
            \else\uppercase{#1}
            \fi
          }
      \else\ifnum\aux@appendices > 1
        \cleardoublepage
        \phantomsection % Added by JL for compatibility with the hyperref package, following http://tex.stackexchange.com/a/23503 (this will get the hyperlink anchor for the line to be correct, so that when it's clicked on, it will take the reader to the correct page)
        \addcontentsline{toc}{chapter}
        {\protect\number@appendix{\number\c@chapter}{\Alph{chapter}} % removed . from {\Alph{chapter}. } everything seems okay.
           \ifsc\textsc{#1}
           \else\uppercase{#1}
           \fi
        }
        \fi
      \fi
    \else
    \cleardoublepage
    \phantomsection % Added by JL for compatibility with the hyperref package, following http://tex.stackexchange.com/a/23503 (this will get the hyperlink anchor for the line to be correct, so that when it's clicked on, it will take the reader to the correct page)
    \addcontentsline{toc}{chapter}
    {\protect\numberline{\Roman{chapter}}
        \ifsc\textsc{#1}
        \else\uppercase{#1}
        \fi
    }
  \fi
  \fi
  \chaptermark{\ifsc\textsc{#1}\else\uppercase{#1}\fi.}
  \if@twocolumn
  \@topnewpage[\@makechapterhead{\ifsc\textsc{#2}
  \else\uppercase{#2}\fi}]
  \else
  \@makechapterhead{\ifsc\textsc{#2}\else\uppercase{#2}\fi}
  \@afterheading
  \fi
}
\def\@schapter#1{
\if@twocolumn
\@topnewpage[\@makeschapterhead{\ifsc\textsc{#1}\else
\uppercase{#1}\fi}]
\else
\@makeschapterhead{\ifsc\textsc{#1}\else\uppercase{#1}\fi}
\@afterheading
\fi}
\def\chapter{
\clearpage\global\@topnum\z@
\@afterindenttrue \secdef\@chapter\@schapter}
\def\@chapterline#1{\centerline{#1}}
\def\@startchapter#1{\@chapterline{#1}}



%------------------------------------------------------------------------------%
% SECTION HEADINGS
%------------------------------------------------------------------------------%
\newcommand*{\addperi}[1]{#1.}

\if@gsmodern
  \def\section{\@startsection{section}{1}{\z@}{3ex}{2ex}{}}
  \renewcommand{\thesection}{\thechapter.\arabic{section}}
  \def\subsection{\@startsection{subsection}{2}{\z@}{3ex}{2ex}{}}
  \renewcommand{\thesubsection}{\thesection.\arabic{subsection}}
  \def\subsubsection{\@startsection{subsubsection}{3}{\z@}{3ex}{2ex}{}}
  \renewcommand{\thesubsubsection}{\thesubsection\arabic{subsubsection}}
  \renewcommand{\theequation}{\thechapter.\arabic{equation}}
\else
  \if@numsections
    \def\section{\@startsection{section}{1}{\z@}{3ex}{2ex}{\centering}}
    \renewcommand{\thesection}{\thechapter.\arabic{section}}
    \def\subsection{\@startsection{subsection}{2}{\z@}{3ex}{2ex}{\centering}}
    \renewcommand{\thesubsection}{}
    \def\subsubsection{\@startsection{subsubsection}{3}{\z@}{2ex}{2ex}{\centering}}
    \renewcommand{\thesubsubsection}{}
    \renewcommand{\theequation}{\thechapter.\arabic{equation}}
  \else
    \def\section{\@startsection{section}{1}{\z@}{.01ex}{.01ex}{\normalfont\normalsize\bfseries}}
    \def\subsection{\@startsection{subsection}{2}{\parindent}{\z@}{-1em}{\normalfont\normalsize\bfseries\addperi}}
    \def\subsubsection{\@startsection{subsubsection}{3}{\parindent}{\z@}{-1ex}{\normalfont\normalsize\bfseries\itshape\addperi}}
  \fi
\fi


\newcommand{\@bibsection}[1]{
\cleardoublepage
\phantomsection % Added by JL for compatibility with the hyperref package, following http://tex.stackexchange.com/a/23503 (this will get the hyperlink anchor for the line to be correct, so that when it's clicked on, it will take the reader to the correct page)
\addcontentsline{toc}{chapter}{#1}
\@startchapter{#1}
% Commented out by Jacob L. because it was causing errors (re: \c@citation being undefined), and I don't think that it was doing anything useful in my draft, anyway, since I can look for question marks in the text to find unrendered citations. [shrug]...
%\ifnum \c@citation > 0
%\centering
%\setlength\fboxsep{10pt}
%\setlength\fboxrule{2pt}
%\begin{center}
%\framebox[1\columnwidth]{\parbox{0.95\columnwidth}{\textcolor{red}
%{\centering\textbf{There are unresolved citation issues!\\*%
% Number of unresolved citations: \arabic{citation}.\\*%
%}}}}
%\end{center}
%\fi
\singlespacing
\@mybibsingle
\vspace*{3ex}}
\def\thebibliography#1{
\@bibsection{REFERENCES CITED}\list
{[\arabic{enumi}]}{\labelwidth\z@ \itemindent-\parindent
\leftmargin\parindent
\interlinepenalty\@M
\usecounter{enumi}}
\def\newblock{\hskip .11em plus .33em minus -.07em}
\sloppy
\raggedright
\sfcode`\.=1000\relax}
\let\endthebibliography=\endlist
\AtEndOfClass{\renewcommand\bibname{REFERENCES CITED}}

\def\thefigure{\@arabic\c@figure}
\def\fnum@figure{Figure \thefigure.}
\def\thetable{\@arabic\c@table}
\def\fnum@table{Table \thetable.}
\if@gsmodern
\else
\def\cl@chapter{\@elt{section}\@elt{footnote}\@elt{equation}}
\fi
\if@gsmodern
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}
\fi

\renewcommand{\descriptionlabel}[1]{
\hspace{\labelsep}\textit{#1}}

\newif\if@appendices
\newcount\aux@appendices
\def\number@appendix#1#2{
\ifnum 1=\aux@appendices
\ifnum 1=#1
{\protect\hspace*{0.5in}}
\else
\numberline{#2}
\fi
\else
\numberline{#2}
\fi}
\def\appendix{
\par
\setcounter{chapter}{0}
\def\@chapapp{\uppercase{appendix}}
\def\thechapter{\Alph{chapter}}
\@appendicestrue}



\ifx\@savdim\undefined
\let\@savdim\@savsk
\newskip\@savsk
\fi
\def\@bsphack{\relax
\ifmmode
\else
\@savsk\lastskip
\@savsf
\ifhmode
\spacefactor
\else
\lastpenalty\@savdim\prevdepth\removelastskip%
\fi
\fi}
\def\@esphack{\relax
   \ifmmode
   \else\ifvmode
           \penalty\if@nobreak\@M
                   \else\if@inlabel\@M
                        \else\if@noskipsec\@M
                             \else\@savsf
                             \fi
                        \fi
                   \fi
           \prevdepth\@savdim\vskip\@savsk
        \else
           \spacefactor\@savsf\relax
           \ifdim\@savsk>\z@\ignorespaces
           \fi
        \fi
   \fi}

\def\@@begintheorem#1#2#3{\noindent
\list{}{\rightmargin=\leftmargin
\itemindent=\leftmargin}
\item[\underline{#1\ #2}#3]\hskip
0pt\par\nobreak\ignorespaces}
\def\@begintheorem#1#2{
\@@begintheorem{#1}{#2}{}}
\def\@opargbegintheorem#1#2#3{
\@@begintheorem{#1}{#2}{ (#3)}}
\def\@qed{{\unskip\nobreak
\hfil\penalty50\hskip1em\null\nobreak\hfil
\qedsymbol\parfillskip\z@\finalhyphendemerits0\par}}
\def\@endtheorem{\expandafter
\ifx\csname qedsymbol\endcsname\relax
\else\@qed\fi\endlist}
\def\qedbox{{\mathsurround\z@$\Box$}}
\let\labelitemi=\labelitemii
\let\labelitemii=\labelitemiii
\let\labelitemiii=\labelitemiv
\catcode`\*=11
\let\itemize*=\enumerate
\let\enditemize*=\endenumerate
\@makeother\*
\let\@itemize=\itemize
\def\itemize{
\typeout{Warning: Itemize
deprecated by Grad. School}
\global\let\itemize=\@itemize
\itemize}
\newenvironment{quote*}
{\list{}{\rightmargin\leftmargin}
\item\relax}
{\endlist}
\renewenvironment{quote}
{\begin{quote*}\setstretch{1.7}}
{\end{quote*}}

\newif\if@pagesspecial
\newcommand{\pagesref}[5]{{
\@pagesspecialtrue
\expandafter\ifx\csname r@#1\endcsname\relax
\@pagesspecialfalse\else\fi
\expandafter\ifx\csname r@#2\endcsname\relax
\@pagesspecialfalse\else\fi
\if@pagesspecial
\@tempcnta=\pageref{#1}
\@tempcntb=\pageref{#2}
\ifnum\@tempcnta=\@tempcntb\else\@pagesspecialfalse\fi
\if@pagesspecial
\ifnum\@tempcnta=\c@page
{#5}
\else
\mbox{{#3}\pageref{#1}}
\fi
\fi
\fi
\if@pagesspecial
\else
\mbox{{#4}\pageref{#1}--\pageref{#2}}
\fi}}
\newcommand{\pages}[2]{\pagesref{#1}{#2}
{p.\hspace*{0.2em}}{pp.\hspace*{0.2em}}{this page}}

%% Originally written by Mark VandeWettering
%% Modified by Chet Haase, Christian Frank, Lars Hansen,
%% J. Paul Walser, Bei Li, Bart Massey, et al.
%% "maintained" (as per LPPL maintenance status) by
%% Michael D. Anderson
%%
%% It may be distributed and/or modified under the conditions of
%% the LaTeX Project Public License (LPPL), either version 1.3c of
%% this license or (at your option) any later version.  The latest
%% version of this license is in the file:
%%
%% http://www.latex-project.org/lppl.txt
%%
%%
%%
%% End of file `uothesis.cls'.
