library(tidyr)
library(dplyr)

library(ggplot2); theme_set(theme_bw())

## Points corresponding to May and Anderson estimates
Reff <- c(12.5, 18)

latmedian <- 12.5 ## cummings et al
latdisp <- 1.23 ## dispersion 
infmean <- 6.5
infshape <- 5
numSamps <- 10000

source("colors.R")
source("euler.R")
source("quantile.R")
source("functions.R")

xmax <- 3.3
ymax <- exp(xmax)

lat <- lnquantiles2(median=12.5, disp=latdisp, numSamps)
inf <- gammaquantiles(mean=infmean, shape=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- findrho(gen, Reff)

g <- GenCurve_DC(gen, xmax, ymax, rho_eff, Reff,
				 legend.position=c(0.29, 0.9))

## draw r-R curve
pdf("measles.pdf", width=6, heigh=4) 
	g + annotate("text", x=1.35, y=(12.5+18)/2, label=c("Biologically realistic range (12.5 \u2013 18)"))+
		geom_point(data=data.frame(x=rho_eff, y=Reff), aes(x, y), pch=21, fill='white',
			   size=3, stroke=2) +
		annotate("segment", x=2.3, y=Reff[1], xend=2.3, yend=Reff[2], arrow=arrow(length=unit(0.1, "inches"))) +
		annotate("segment", x=2.3, y=Reff[2], xend=2.3, yend=Reff[1], arrow=arrow(length=unit(0.1, "inches")))
dev.off()
	