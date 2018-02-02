
## link_calculations

Sources = Makefile .gitignore .ignore README.md makestuff.mk LICENSE.md
-include target.mk

# -include $(ms)/perl.def

##################################################################

## Content

## Just trying to get a handle on some stuff

Sources += $(wildcard *.R)

functions.Rout: functions.R

test.Rout: functions.Rout test.R

ebola.Rout: 

######################################################################

include makestuff.mk
-include $(ms)/git.mk
-include $(ms)/visual.mk

-include $(ms)/wrapR.mk
# -include $(ms)/texdeps.mk
