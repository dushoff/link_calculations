# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.euler.RData')
load('.quantile.RData')
load('.functions.RData')

rtargetname <- "measles_calc"
pdfname <- ".measles_calc.Rout.pdf"
csvname <- "measles_calc.Rout.csv"
rdsname <- "measles_calc.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file measles_calc.wrapR.r
source('measles_calc.R', echo=TRUE)
# Wrapped output file measles_calc.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script measles_calc.wrapR.r (or something it called) did not close properly
save.image(file=".measles_calc.RData")

