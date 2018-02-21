library(bbmle)
source("euler.R")
source("quantile.R")
source("functions.R")
source("mle.R")
source("colors.R")

## Points corresponding to Hampson et al. 2009
Reff <- c(1.06, 1.32)

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

rho_eff <- findrho(gen, Reff)
mle <- gammaMLE(gen)

## draw r-R curve
pdf("rabies.pdf", width=8, height=6) 
par(mfrow=c(1,2))
GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
curve(GammaCurve(1/mle[1], x), add=TRUE, lwd=2, col=mlecolor, lty=2)
legend(
	"topleft"
	, legend=c("empirical", "moment", "MLE")
	, lty=c(1, 2, 2)
	, lwd=2
	, seg.len=4
	, col=c("black", momcolor, mlecolor)
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
	, col=momcolor
	, lty=2
	, lwd=2
)
curve(dgamma(x, shape=mle[1], scale=mle[2])
	, add=TRUE
	, col=mlecolor
	, lty=2
	, lwd=2
)
dev.off()

nsamp <- 50
nrep <- 500

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
	) %>%
	mutate(key=factor(key, levels=c("moment", "mle")))

ggrabies <- (
	ggplot(samp_df, aes(x=rho))
	+ geom_ribbon(aes(ymin=lwr, ymax=upr, group=key, col=key, fill=key), alpha=0.2, lwd=1, color=FALSE)
	+ geom_line(aes(y=mean, group=key, col=key), lwd=1, lty=2)
	+ scale_color_manual(values=c(momcolor, mlecolor))
	+ scale_fill_manual(values=c(momcolor, mlecolor))
	+ stat_function(fun=function(x) EulerCurve(mean(gen)/x, gen), col="black", lty=1, lwd=1)
	+ stat_function(fun=exp, col=limcolor, lty=3, lwd=1)
	+ stat_function(fun=function(x) x+1, col=limcolor, lty=3, lwd=1)
	+ geom_point(data=data.frame(rho=rho_eff, R=Reff), aes(y=R), pch=c(19, 17), size=2)
	+ scale_x_continuous(expression(Relative~length~of~generation~interval~(rho)), expand=c(0,0))
	+ scale_y_continuous("Reproductive number") 
	+ theme(
		legend.title = element_blank(),
		legend.position = c(0.1, 0.85),
		panel.grid = element_blank()
	)
)

ggsave("rabies_sample.pdf", ggrabies, width=6, height=4)


