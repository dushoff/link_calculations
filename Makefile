
## link_calculations

Sources = Makefile .gitignore .ignore README.md makestuff.mk LICENSE.md
-include target.mk

# -include $(ms)/perl.def

##################################################################

## Content

## Just trying to get a handle on some stuff

Sources += $(wildcard *.R)

functions.Rout: functions.R

######################################################################

## Data

Sources += jd.local

jd.lmk:
%.lmk: %.local
	$(CP) $< local.mk

Ignore += rdata_2002_2007.csv
rdata_2002_2007.csv:
	$(CP) $(Drop)/$@ .

######################################################################

## Daniel-style sourcing (fake step rules
ebola_fig.R: euler.R quantile.R
ebola_fig.Rout: ebola_fig.R
ebola.pdf: ebola_fig.Rout ;
Ignore += ebola.pdf

rabies_fig.R: euler.R quantile.R functions.R mle.R
rabies_fig.R: rdata_2002_2007.csv
rabies_fig.Rout: rabies_fig.R
rabies.pdf: rabies_fig.Rout ;
Ignore += rabies.pdf

genExp.R: euler.R
genExp.Rout: genExp.R
genExp.pdf: genExp.Rout ;
Ignore += genExp.pdf

steps_fig.Rout: steps_fig.R
steps.pdf: steps_fig.Rout ;
Ignore += steps.pdf

######################################################################

include makestuff.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/texdeps.mk
