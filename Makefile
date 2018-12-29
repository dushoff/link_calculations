
## link_calculations

Sources = Makefile README.md makestuff.mk LICENSE.md
-include target.mk

# -include $(ms)/perl.def

######################################################################

paper_figures: steps.pdf genExp.pdf ebola.pdf measles.pdf rabies.pdf
supp_figures: ebola_gamma.pdf ebola_normal.pdf ebola_sample.pdf

##################################################################

include makestuff.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/stepR.mk
