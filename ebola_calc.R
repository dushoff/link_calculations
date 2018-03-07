
## Points corresponding to WHO estimates
Ghat <- 15.3
Reff <- c(1.81, 1.51, 1.38)
doub <- c(15.7, 23.6, 30.2)

latmean <- 11.4
latshape <- 0.6
infmean <- 5
infshape <- 0.8
numSamps <- 10000

xmax <- 2
ymax <- 5

lat <- lnquantiles(mean=latmean, sdlog=latshape, numSamps)
inf <- lnquantiles(mean=infmean, sdlog=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- Ghat*log(2)/doub

