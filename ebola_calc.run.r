# This file was generated automatically by wrapR.pl
# You probably don't want to edit it
load('.quantile.RData')

rtargetname <- "ebola_calc"
pdfname <- ".ebola_calc.Rout.pdf"
csvname <- "ebola_calc.Rout.csv"
rdsname <- "ebola_calc.Rds"
pdf(pdfname)
# End RR preface

# Generated using wrapR file ebola_calc.wrapR.r
source('ebola_calc.R', echo=TRUE)
# Wrapped output file ebola_calc.wrapR.rout
# Begin RR postscript
warnings()
proc.time()

# If you see this in your terminal, the R script ebola_calc.wrapR.r (or something it called) did not close properly
save.image(file=".ebola_calc.RData")

