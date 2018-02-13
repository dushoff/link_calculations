library(bbmle)
library(tidyr)
library(dplyr)
library(ggplot2); theme_set(theme_bw())

## Points corresponding to WHO estimates
Ghat <- 15.3
Reff <- c(1.81, 1.51, 1.38)
doub <- c(15.7, 23.6, 30.2)

latmean <- 11.4
latshape <- 0.6
infmean <- 5
infshape <- 0.8
numSamps <- 10000

source("euler.R")
source("quantile.R")

xmax <- 2
ymax <- 5

lat <- lnquantiles(mean=latmean, sdlog=latshape, numSamps)
inf <- lnquantiles(mean=infmean, sdlog=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- Ghat*log(2)/doub

## draw r-R curve
pdf("ebola.pdf", width=6, heigh=4) 
GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
dev.off()

nsamp <- 50
nrep <- 10

samp_list <- replicate(nrep, {
	s <- sample(gen, nsamp)
	gbar <- mean(s)
	gamshape <- gbar^2/var(s)
	mleshape <- suppressWarnings(unname(gammaMLE(s)[1]))
	
	rho <- seq(0, xmax, by=0.1)
	
	data.frame(
		rho=rho,
		moment=GammaCurve(1/gamshape, rho),
		mle=GammaCurve(1/mleshape, rho)
	)
}, simplify=FALSE)

samp_df <- samp_list %>%
	bind_rows(.id="sim") %>%
	gather(key, value, -sim, -rho) %>%
	group_by(rho, key) %>%
	summarize(
		lwr=quantile(value, 0.025),
		upr=quantile(value, 0.975),
		mean=mean(value)
	)

ggplot(samp_df, aes(x=rho, group=key, col=key, fill=key)) +
	geom_ribbon(aes(ymin=lwr, ymax=upr), alpha=0.2, col=NA) +
	geom_line(aes(y=mean, group=key)) +
	stat_function(fun=function(x) EulerCurve(mean(gen)/x, gen), col="black")

	

	
	
