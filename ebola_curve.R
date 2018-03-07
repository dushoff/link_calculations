library(bbmle)
library(tidyr)
library(dplyr)

library(ggplot2); theme_set(theme_bw())

GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd=2)
legend(
	"topleft"
	, legend=c("empirical", "moment")
	, lty=c(1, 2)
	, lwd=2
	, seg.len=4
	, col=c("black", momcolor)
)
