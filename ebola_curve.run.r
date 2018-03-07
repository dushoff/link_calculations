# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.colors.RData')
load('.euler.RData')
load('.ebola_calc.RData')

rtargetname <- "ebola_curve"
pdfname <- ".ebola_curve.Rout.pdf"
csvname <- "ebola_curve.Rout.csv"
rdsname <- "ebola_curve.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file ebola_curve.wrapR.r
source('ebola_curve.R', echo=TRUE)
# Wrapped output file ebola_curve.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script ebola_curve.wrapR.r (or something it called) did not close properly
save.image(file=".ebola_curve.RData")

