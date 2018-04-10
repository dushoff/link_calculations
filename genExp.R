source("euler.R")

rho <- seq(0, 3, length.out=101)

pdf("genExp.pdf", width=6, heigh=4)
plot(
	NA
	, xlim=c(0, max(rho))
	, ylim=c(1,10)
	, xlab=expression(Relative~length~of~generation~interval~(rho))
	, ylab="Reproductive number"
)


lines(rho, GammaCurve(1, rho), lwd=2)
lines(rho, GammaCurve(1/2, rho), lty=2, lwd=2)
lines(rho, GammaCurve(1/4, rho), lty=3, lwd=2)
lines(rho, GammaCurve(0, rho), lty=4, lwd=2)

legend(
	"topleft"
	, legend=c("0", "1/4", "1/2", "1")
	, lty=4:1
	, title="Squared CV"
	, lwd=2
	, seg.len=4
)
dev.off()

