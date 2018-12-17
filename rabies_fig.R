library(bbmle)
library(dplyr)
library(tidyr)
library(ggplot2); theme_set(theme_bw())
library(gridExtra)

source("euler.R")
source("quantile.R")
source("functions.R")
source("mle.R")
source("colors.R")

## Points corresponding to Hampson et al. 2009
Reff <- c(1.14, 1.19)

inf <- read.csv("rabies_inf.csv")
lat <- read.csv("rabies_lat.csv")

inf <- ufun(inf)
inf$val <- inf$num*inf$uval
mean(inf$val, na.rm = TRUE)
sd(inf$val, na.rm = TRUE)

lat <- ufun(lat)
lat$val <- lat$num*lat$uval
mean(lat$val, na.rm = TRUE)
sd(lat$val, na.rm = TRUE)

xmax <- 1
ymax <- exp(xmax)

inf <- inf$val[!is.na(inf$val)]
lat <- lat$val[!is.na(lat$val)]

set.seed(101)
gen <- genSamp(lat, inf, nsamp=10000)

rho_eff <- findrho(gen, Reff)

mle <- gammaMLE(gen)

g <- GenCurve_DC(gen, xmax, ymax, rho_eff, Reff,
				 legend.position=c(0.29, 0.9))

rdata <- rbind(g$data, data_frame(
	x=seq(0, xmax, by=0.1),
	gitype="approximation theory (MLE)",
	value=GammaCurve(1/mle[1], x)
)) %>%
	mutate(gitype=factor(gitype, levels=c("empirical", "approximation theory (moment)",
										  "approximation theory (MLE)")))

g1 <- g %+% rdata + 
	geom_segment(x=rho_eff[1], y=Reff[1], xend=rho_eff[1], yend=Reff[1]+0.1) +
	geom_segment(x=rho_eff[2], y=Reff[2], xend=rho_eff[2], yend=Reff[2]+0.2) +
	annotate("text", x=0.07, y=1.3, label=c("Ngorongoro"))+
	annotate("text", x=0.18, y=1.45, label=c("Serengeti"))+
	geom_point(data=data.frame(x=rho_eff, y=Reff), aes(x, y), pch=21, fill='white',
			   size=3, stroke=2) +
	scale_color_manual(values=c(rgb(0,0,0,0.3), "black", mlecolor)) +
	scale_linetype_manual(values=c(1, 1, 2)) +
	scale_size_manual(values=c(4, 1.5, 1.5)) +
	theme(
		legend.position = c(0.33, 0.91)
	)

g2 <- ggplot(data.frame(x=gen)) +
	geom_histogram(aes(x, y=..density..), fill=NA, col="black", breaks=seq(0, 260, by=10)) +
	stat_function(fun=function(x) dgamma(x, shape=mean(gen)^2/var(gen), scale=var(gen)/mean(gen)), col="black", lwd=1.5, n=1000) +
	stat_function(fun=function(x) dgamma(x, shape=mle[1], scale=mle[2]), col=mlecolor, lwd=1.5, lty=2, n=1000, xlim=c(0, 200)) +
	scale_x_continuous("Generation interval (days)") +
	theme(
		axis.title.y = element_blank(),
		axis.ticks.y = element_blank(),
		axis.text.y = element_blank(),
		panel.border = element_blank(),
		axis.line.x = element_line(),
		panel.grid = element_blank()
	)

## draw r-R curve
pdf("rabies.pdf", width=8, height=6) 
grid.arrange(g1, g2, nrow=1, widths=c(2, 1))
dev.off()
