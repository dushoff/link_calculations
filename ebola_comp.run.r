# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.ebola_calc.RData')
load('.euler.RData')

rtargetname <- "ebola_comp"
pdfname <- ".ebola_comp.Rout.pdf"
csvname <- "ebola_comp.Rout.csv"
rdsname <- "ebola_comp.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file ebola_comp.wrapR.r
source('rcomp.R', echo=TRUE)
source('ebola_comp.R', echo=TRUE)
# Wrapped output file ebola_comp.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script ebola_comp.wrapR.r (or something it called) did not close properly
save.image(file=".ebola_comp.RData")

