
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

colors.Rout: colors.R

## Daniel-style sourcing (fake step rules)
ebola_fig.R: colors.R euler.R quantile.R mle.R
ebola_fig.Rout: ebola_fig.R
ebola_sample.pdf ebola_normal.pdf ebola.pdf: ebola_fig.Rout ;
Ignore += ebola_sample.pdf ebola_normal.pdf ebola.pdf

rabies_fig.R: colors.R euler.R quantile.R functions.R mle.R
rabies_fig.R: rdata_2002_2007.csv
rabies_fig.Rout: rabies_fig.R
rabies_sample.pdf rabies.pdf: rabies_fig.Rout ;
Ignore += rabies.pdf rabies_sample.pdf

measles_fig.R: colors.R euler.R quantile.R functions.R
measles_fig.Rout: measles_fig.R
measles.pdf: measles_fig.Rout ;
Ignore += measles.pdf

## X figure
genExp.R: euler.R
genExp.Rout: genExp.R
genExp.pdf: genExp.Rout ;
Ignore += genExp.pdf

## Steps figure
steps_fig.Rout: steps_fig.R
steps.pdf: steps_fig.Rout ;
Ignore += steps.pdf

######################################################################

## JD style (same code, mostly?)

#### Ebola 

## Parameters and basic calculations
ebola_calc.Rout: quantile.Rout ebola_calc.R

## Look at the numbers for Weitz
ebola_comp.Rout: ebola_calc.Rout euler.Rout rcomp.R ebola_comp.R
	$(run-R)

## Main approximation curve
ebola_curve.Rout: colors.Rout euler.Rout ebola_calc.Rout ebola_curve.R

#### Measles

measles_calc.Rout: euler.Rout quantile.Rout functions.Rout measles_calc.R

measles_comp.Rout: measles_calc.Rout rcomp.R 
	$(run-R)

######################################################################

include makestuff.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
-include $(ms)/masterR.mk
# -include $(ms)/texdeps.mk
