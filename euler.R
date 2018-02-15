EulerR <- function(tau, C){
	return(1/mean(exp(-tau/C)))
}

## Clumsily vectorize the function above
EulerCurve <- function(CC, tau){
	sapply(CC, function(cc){
		return(EulerR(tau, C=cc))
	})
}

GammaCurve <- function(kappa, rho) {
	if (kappa==0) 
		return(exp(rho))
	return((1+kappa*rho)^(1/kappa))
}

GenCurve <- function(gen, xmax, ymax,
						rho_eff,
						Reff,
					 	lwd=1) {
	gbar <- mean(gen)
	gamshape <- gbar^2/var(gen)
	rho <- seq(0, xmax, by=0.1)
	## Scaling by mean generation time 
	
	baseplot <- function(){
		plot(rho, EulerCurve(gbar/rho, gen)
			 , type="l"
			 , ylim=c(1, ymax)
			 , xlab = expression(Relative~length~of~generation~interval~(rho))
			 , ylab = "Reproductive number"
			 , lwd=lwd
		)
	}
	
	# Version with extra curves
	# Blue is the approximations
	baseplot()
	lines(rho, GammaCurve(1/gamshape, rho), col=momcolor, lwd=lwd)
	
	pp <- c(19, 17, 15)
	
	points(rho_eff, Reff, pch=pp[1:length(Reff)])
	curve(1+x, add=TRUE, col=limcolor, lty=3, lwd=lwd)
	curve(exp(x), add=TRUE, col=limcolor, lty=3, lwd=lwd)
	invisible()
}
