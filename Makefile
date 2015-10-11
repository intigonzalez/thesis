# Automatiser la compilation du document en utilisant un  Makefile.
# Pour un fichier $(DOC).tex, le Makefile suivant réalise dans l'ordre :
#
#    * une compilation latex pour faire le .aux pour créer la bibliographie ;
#    * la compilation de génération de l'index ;
#    * le formatage de l'index ;
#    * les deux compilations de génération et d'inclusion de la table des matières ;
#    * la conversion du document au format PostScript.

DOC=these
   
SRC = these.tex introducing-contributions.tex

include acknowledgments/make.mk
include introduction/make.mk
include chapter1/make.mk
include chapter2/make.mk
include chapter4/make.mk
include chapter5/make.mk
include chapter6/make.mk
include glossary/make.mk
include annex/make.mk
include resume/make.mk

SRC_LOG=$(SRC:%.tex=%.log)
SRC_LOG=$(SRC:%.tex=%.log)

DIFF_VERSION_BASE_PATH=/home/inti/Desktop/PhD_Diff

all: $(DOC).pdf

quick: $(DOC).tex $(TEX_FILES)
	pdflatex -shell-escape $(DOC).tex

exec-summary: executive/executive.tex $(SRC) ./biblio/biblio_$(DOC).bib
	pdflatex -shell-escape executive/executive.tex
	bibtex executive
	pdflatex -shell-escape executive/executive.tex
	pdflatex -shell-escape executive/reviewers.tex

$(DOC).pdf : $(SRC) ./biblio/biblio_$(DOC).bib
	pdflatex -shell-escape $(DOC).tex
	bibtex $(DOC)
	makeglossaries $(DOC)
	pdflatex -shell-escape $(DOC).tex
	pdflatex -shell-escape $(DOC).tex

create_diff_version:
	@for number in $(SRC) ; do \
        echo "$${number}" ; \
    done > files.txt
	@echo "executive/executive.tex" >> files.txt
	@./create_diff_copy.sh v2 $(DIFF_VERSION_BASE_PATH)/PhD_Copy $(DIFF_VERSION_BASE_PATH)/PhD_Old $(DIFF_VERSION_BASE_PATH)/Diff files.txt
	@rm -f files.txt


#---------------------------
# commandes "utilitaires"
#---------------------------
clean : 
	rm -f $(DOC).dvi $(DOC).aux $(DOC).lof $(DOC).log $(DOC).toc 
	rm -f $(DOC).ps $(DOC).pdf
	rm -f $(DOC).bbl $(DOC).blg
	rm -f $(DOC).acr $(DOC).glo these.acn these.ist these.out texput.log these.gls these.glsdefs these.glg
	rm -f macro.log
	rm -f $(DOC).idx $(DOC).ilg $(DOC).ind

diff : 
	diff -b -B --brief -X .diffignore -r ../$(DOC)/ /mnt/usbstorage/$(DOC)/

xe : 
	xemacs $(DOC).tex $(TEX_FILES) ./biblio/biblio_$(DOC).bib &

dv : 
	xdvi -s 0 -paper a4 $(DOC).dvi &

tar:
	tar -cz * > ../sauvegardes_$(DOC)/sauvegarde_$(DOC)_$(shell date +%F).tar.gz
#    cd ..; tar -cz $(DOC) > sauvegarde_$(DOC)_$(shell date +%F).tar.gz

#pour detarer:
#gzip -cd sauvegarde_these_2004-09-14.tar.gz | tar xf -
#ne pas le faire dans le home, sinon ça écrase la version courante.

#Il suffit de taper make et d'attendre un peu pour avoir un document prêt à imprimer.
#Accessoirement, make clean permet d'effacer tous les fichiers générés






































