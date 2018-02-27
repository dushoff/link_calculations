## Points corresponding to ??? estimates
Reff <- 14

latmedian <- 12.5 ## cummings et al
latdisp <- 1.23 ## dispersion 
infmean <- 3.65
infshape <- 5
numSamps <- 10000

source("colors.R")
source("euler.R")
source("quantile.R")
source("functions.R")

xmax <- 3
ymax <- exp(xmax)

lat <- lnquantiles2(median=12.5, disp=latdisp, numSamps)
inf <- gammaquantiles(mean=infmean, shape=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- findrho(gen, Reff)

## draw r-R curve
pdf("measles.pdf", width=6, heigh=4) 
GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
legend(
	"topleft"
	, legend=c("empirical", "moment")
	, lty=c(1, 2)
	, lwd=2
	, seg.len=4
	, col=c("black", momcolor)
)
dev.off()
