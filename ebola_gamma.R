library(tidyr)
library(dplyr)

library(ggplot2); theme_set(theme_bw())

## Points corresponding to WHO estimates
Ghat <- 15.3
Reff <- c(1.81, 1.51, 1.38)
doub <- c(15.7, 23.6, 30.2)

latmean <- 11.4
latshape <- 1.75
infmean <- 5
infshape <- (5/4.7)^2
numSamps <- 10000

source("colors.R")
source("euler.R")
source("quantile.R")

xmax <- 2
ymax <- 5

lat <- gammaquantiles(mean=latmean, shape=latshape, numSamps)
inf <- gammaquantiles(mean=infmean, shape=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- Ghat*log(2)/doub

## draw r-R curve
pdf("ebola_gamma.pdf", width=6, heigh=4) 
GenCurve_DC(gen, xmax, ymax, rho_eff, Reff,
			legend.position=c(0.285, 0.9),
			labels=c("Guinea", 
					 "Liberia", 
					 "Sierra Leone"))
dev.off()
