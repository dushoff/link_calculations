
## link_calculations

Sources = Makefile README.md LICENSE.md
-include target.mk

ms = makestuff
-include $(ms)/os.mk

######################################################################

paper_figures = steps.pdf genExp.pdf ebola.pdf measles.pdf rabies.pdf
supp_figures = ebola_gamma.pdf ebola_normal.pdf ebola_sample.pdf

allfigs.pdf: $(paper_figures) $(supp_figures)
	$(pdfcat)

##################################################################

-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/stepR.mk
