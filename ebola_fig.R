library(bbmle)
library(tidyr)
library(dplyr)

library(ggplot2); theme_set(theme_bw())

## Points corresponding to WHO estimates
Ghat <- 15.3
Reff <- c(1.81, 1.51, 1.38)
doub <- c(15.7, 23.6, 30.2)

latmean <- 11.4
latshape <- 0.64
infmean <- 5
infshape <- 0.8
numSamps <- 10000

source("colors.R")
source("euler.R")
source("quantile.R")
source("mle.R")

xmax <- 2
ymax <- 5

lat <- lnquantiles(mean=latmean, sdlog=latshape, numSamps)
inf <- lnquantiles(mean=infmean, sdlog=infshape, numSamps)

gen <- genSamp(lat, inf, nsamp=numSamps)

rho_eff <- Ghat*log(2)/doub

## draw r-R curve
pdf("ebola.pdf", width=6, heigh=4) 
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

## normal approx
pdf("ebola_normal.pdf", width=6, heigh=4) 
NormalCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
legend(
	"topleft"
	, legend=c("empirical", "moment", "normal")
	, lty=c(1, 1, 2)
	, lwd=2
	, seg.len=4
	, col=c("black", momcolor, norcolor)
)
dev.off()

nsamp <- c(10, 50, 100)
nrep <- 1000

samp_list <- lapply(nsamp, function(nn) {
	replicate(nrep, {
		s <- sample(gen, nn)
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
})
	
samp_df <- samp_list %>%
	lapply(bind_rows, .id="sim") %>%
	bind_rows(.id="n") %>%
	mutate(n=factor(n, labels=paste0("n=", nsamp))) %>%
	gather(key, value, -sim, -rho, -n) %>%
	group_by(rho, key, n) %>%
	summarize(
		lwr=quantile(value, 0.025),
		upr=quantile(value, 0.975),
		mean=mean(value)
	) %>%
	group_by %>%
	mutate(key=factor(key, levels=c("moment", "mle")))

ggebola <- (
	ggplot(samp_df, aes(x=rho))
	+ stat_function(fun=function(x) EulerCurve(mean(gen)/x, gen), col="black", lty=1, lwd=1)
	+ stat_function(fun=exp, col=limcolor, lty=3, lwd=1)
	+ stat_function(fun=function(x) x+1, col=limcolor, lty=3, lwd=1)
	+ geom_ribbon(aes(ymin=lwr, ymax=upr, group=key, col=key, fill=key), alpha=0.2, lwd=0.5, lty=1)
	+ geom_line(aes(y=mean, group=key, col=key), lwd=1, lty=2)
	+ scale_color_manual(values=c(momcolor, mlecolor))
	+ scale_fill_manual(values=c(momcolor, mlecolor))
	+ geom_point(data=data.frame(rho=rho_eff, R=Reff), aes(y=R), pch=c(19, 17, 15, 19, 17, 15, 19, 17, 15), size=2)
	+ scale_x_continuous(expression(Relative~length~of~generation~interval~(rho)), expand=c(0,0), breaks=c(0, 0.5, 1, 1.5))
	+ scale_y_continuous("Reproductive number") 
	+ facet_grid(~n)
	+ theme(
		legend.title = element_blank(),
		legend.position = c(0.05, 0.85),
		panel.grid = element_blank(),
		strip.background = element_blank(),
		panel.spacing = unit(0, "cm")
	)
)

ggsave("ebola_sample.pdf", ggebola, width=12, height=4)
