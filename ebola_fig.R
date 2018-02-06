source("euler.R")
source("functions.R")

xmax <- 2
ymax <- 5

lat <- lnquantiles(mean=11.4, sdlog=0.6, 10000)
inf <- lnquantiles(mean=5, sdlog=0.8, 10000)

gen <- genSamp(lat, inf, nsamp=10000)

## Points corresponding to WHO estimates
Ghat <- 15.3
Reff <- c(1.81, 1.51, 1.38)
doub <- c(15.7, 23.6, 30.2)

rho_eff <- Ghat*log(2)/doub

## draw r-R curve
pdf("ebola.pdf", width=6, heigh=4) 
GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
dev.off()
