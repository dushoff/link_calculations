
## link_calculations

Sources = Makefile README.md LICENSE.md
-include target.mk

ms = makestuff
Makefile: $(ms) $(ms)/Makefile

$(ms)/%.mk: $(ms)/Makefile ;
$(ms)/Makefile:
	git submodule update -i

-include $(ms)/os.mk

######################################################################

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

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/pandoc.mk

-include $(ms)/stepR.mk
