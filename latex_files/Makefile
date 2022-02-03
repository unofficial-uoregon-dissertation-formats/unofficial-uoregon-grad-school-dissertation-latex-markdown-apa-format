SHELL = /bin/sh
MAIN = main
LATEX = pdflatex

all: $(MAIN).pdf findref

$(MAIN).pdf: *.tex $(MAIN).bib
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	bibtex $(LATEXFLAGS) $(MAIN)
	touch $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

short: *.tex 
	$(LATEX) $(LATEXFLAGS) $(MAIN).tex

findref:
	@echo
	@test \
          `grep -c undefined $(MAIN).log | grep -v There | sed 's/.*\`//g' | sed "s/'.*//g"` = "0" \
            && echo "No undefined references" \
            || echo Finding undefined references ; \
               for uref in `grep undefined $(MAIN).log | grep -v There | sed 's/.*\`//g' | sed "s/'.*//g"`; \
               do  \
                echo "--> $$uref ";\
                grep -n "[rc][ei].*$$uref" *.tex | grep -v '.tex:[0-9]*:%' | sed 's/:/ -- Line /' | sed 's/:/:  /';\
                echo ;\
               done

clean:
	$(RM) *.aux *.log *.out *.lof *.lot *.lol *.toc *.lbl *.brf *.fls *.fdb_latexmk $(MAIN).dvi $(MAIN).ps $(MAIN).pdf $(MAIN).bbl $(MAIN).blg $(MAIN).synctex.gz $(MAIN).tdo acs-$(MAIN).bib


