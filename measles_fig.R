## Points corresponding to ??? estimates
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

## draw r-R curve
pdf("measles.pdf", width=6, heigh=4) 
GenCurve(gen, xmax, ymax, NA, NA, lwd=3, lwd2=5)
legend(
	"topleft"
	, legend=c("empirical", "approximation theory (moment)")
	, lty=c(1, 2)
	, lwd=c(5, 3)
	, seg.len=2.5
	, col=c("black", momcolor)
)
abline(h=Reff, col="gray")
dev.off()
