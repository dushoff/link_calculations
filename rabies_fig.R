library(bbmle)
source("euler.R")
source("quantile.R")
source("functions.R")

rdata <- read.csv("rdata_2002_2007.csv")
lat <- with(rdata, {data.frame(
	num=Incubation.period
	, units = Incubation.period.units
)})

inf <- with(rdata, {data.frame(
	num=Infectious.period
	, units = Infectious.period.units
)})

inf <- ufun(inf)
inf$val <- inf$num*inf$uval
mean(inf$val, na.rm = TRUE)
sd(inf$val, na.rm = TRUE)

lat <- ufun(lat)
lat$val <- lat$num*lat$uval
mean(lat$val, na.rm = TRUE)
sd(lat$val, na.rm = TRUE)

xmax <- 1.5
ymax <- exp(xmax)

inf <- inf$val[!is.na(inf$val)]
lat <- lat$val[!is.na(lat$val)]

set.seed(101)
gen <- genSamp(lat, inf, nsamp=length(lat))

## Points corresponding to WHO estimates
Reff <- c(1.06, 1.32)
rho_eff <- findrho(gen, Reff)

mle <- gammaMLE(gen)

## draw r-R curve
pdf("rabies.pdf", width=8, heigh=6) 
par(mfrow=c(1,2))
GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
curve(GammaCurve(1/mle[1], x), add=TRUE, lwd=2, col="blue", lty=2)
legend(
	"topleft"
	, legend=c("empirical", "moment", "MLE")
	, lty=c(1, 1, 2)
	, lwd=2
	, seg.len=4
	, col=c("black", "blue", "blue")
)

hist(gen
	, freq=FALSE
	, breaks=30
	, xlab="Generation interval (days)"
	, main=""
	, yaxt="n"
	, ylab=""
)
curve(dgamma(x, shape=mean(gen)^2/var(gen), scale=var(gen)/mean(gen))
	, add=TRUE
	, col="blue"
	, lwd=2
)
curve(dgamma(x, shape=mle[1], scale=mle[2])
	, add=TRUE
	, col="blue"
	, lty=2
	, lwd=2
)
dev.off()
