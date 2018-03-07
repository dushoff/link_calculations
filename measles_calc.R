## Points corresponding to ??? estimates
Reff <- 14

latmedian <- 12.5 ## cummings et al
latdisp <- 1.23 ## dispersion 
infmean <- 3.65
infshape <- 5
numSamps <- 10000

xmax <- 3
ymax <- exp(xmax)

lat <- lnquantiles2(median=12.5, disp=latdisp, numSamps)
inf <- gammaquantiles(mean=infmean, shape=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- findrho(gen, Reff)
