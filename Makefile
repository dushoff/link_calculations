
## link_calculations

## This is link_calculations, a screens project directory

current: target
-include target.mk

# include makestuff/perl.def


######################################################################

Ignore += README.html
README.html: README.md

figs = $(paper_figures) $(supp_figures)

## make2graph

# figs.mg.png:

Ignore += rdeps.make
rdeps.make: $(wildcard *.rdeps)
	$(cat)

Ignore += *.rdlog
%.rdlog: rdeps.make
	make -f $< -nd $($*) > $@

Ignore += *.dot
%.dot: %.rdlog
	make2graph $< > $@

Ignore += *.mg.png
%.mg.png: %.dot
	dot -Tpng -o $@ $< 

######################################################################

paper_figures = steps.pdf genExp.pdf ebola.pdf measles.pdf rabies.pdf
supp_figures = ebola_gamma.pdf ebola_normal.pdf ebola_sample.pdf

Ignore += allfigs.pdf
allfigs.pdf: $(paper_figures) $(supp_figures)
	$(pdfcat)

##################################################################

# Content

vim_session:
	bash -cl "vmt"

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff
Makefile: makestuff/Makefile
makestuff/Makefile:
	git clone $(msrepo)/makestuff
	ls $@

-include makestuff/os.mk
-include makestuff/visual.mk
-include makestuff/projdir.mk
-include makestuff/pandoc.mk
-include makestuff/stepR.mk
-include makestuff/git.mk
