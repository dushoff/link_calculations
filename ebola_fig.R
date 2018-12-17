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
g <- GenCurve_DC(gen, xmax, ymax, rho_eff, Reff,
			legend.position=c(0.285, 0.9),
			labels=c("Guinea", 
			  "Liberia", 
			  "Sierra Leone"))
dev.off()

q <- (2*(1:numSamps)-1)/(2*numSamps)
normgen <- qnorm(q, mean = mean(gen), sd = sd(gen))
normdf <- rbind(g$data, data_frame(
	x=seq(0, xmax, by=0.1),
	gitype="normal approximation",
	value=EulerCurve(mean(gen)/x, normgen)
)) %>%
	mutate(gitype=factor(gitype, levels=c("empirical", "approximation theory (moment)",
										  "normal approximation")))

## normal approx
pdf("ebola_normal.pdf", width=6, heigh=4) 
g %+% normdf +
	scale_color_manual(values=c(rgb(0,0,0,0.3), "black", norcolor)) +
	scale_linetype_manual(values=c(1, 1, 2)) +
	scale_size_manual(values=c(4, 1.5, 1.5)) +
	theme(
		legend.position = c(0.285, 0.864)
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
	mutate(key=factor(key, levels=c("moment", "mle"),
					  labels=c("moment", "MLE")))

ggebola <- (
	ggplot(samp_df, aes(x=rho))
	+ stat_function(fun=exp, col=limcolor, lty=3, lwd=1)
	+ stat_function(fun=function(x) x+1, col=limcolor, lty=3, lwd=1)
	+ geom_ribbon(aes(ymin=lwr, ymax=upr, col=key, group=key, fill=key), alpha=0.4, lwd=0.5, lty=1)
	+ geom_line(aes(y=mean, group=key, col=key), lwd=1.5, lty=2)
	+ geom_line(data=filter(g$data, gitype=="empirical"), aes(x, value), lwd=3, col=rgb(0,0,0,0.3))
	+ scale_color_manual(values=c(momcolor, mlecolor))
	+ scale_fill_manual(values=c(momcolor, mlecolor))
	+ scale_x_continuous(expression(Relative~length~of~generation~interval~(rho)), expand=c(0,0), breaks=c(0, 0.5, 1, 1.5))
	+ scale_y_continuous("Reproductive number") 
	+ facet_grid(~n)
	+ theme(
		legend.title = element_blank(),
		legend.position = c(0.115, 0.83),
		panel.grid = element_blank(),
		strip.background = element_blank(),
		panel.spacing = unit(0, "cm"),
		legend.key.width = unit(3, "line")
	)
)

ggsave("ebola_sample.pdf", ggebola, width=6, height=3)
