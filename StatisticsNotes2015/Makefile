fname=NGS-Statistics-Weeks-1and2



all:
	Rscript -e "library(knitr); knit2pdf('$(fname).Rnw')"


final:
	pdflatex $(fname).tex
	cp $(fname).pdf $(fname)-FINAL.pdf
	rm $(fname).pdf

clean:
	\rm -rf *.pdf *.nav *.aux *.log *.out *.snm *.toc *.vrb *.tex
