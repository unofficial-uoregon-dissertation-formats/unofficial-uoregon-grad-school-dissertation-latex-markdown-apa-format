SHELL = /bin/sh

all: main.pdf

main.pdf: *.tex *.bib
	pdflatex main.tex
	bibtex main
	touch main.tex
	pdflatex main.tex
	pdflatex main.tex
	pdflatex main.tex

short: *.tex 
	pdflatex main.tex

clean:
	if (rm -f *.pdf *.lof *.lot *.out *.log *.aux *.bbl *.blg *.toc *.dvi *.ps *.brf *.lbl) then :; fi

