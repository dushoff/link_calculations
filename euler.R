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
					 	lwd=1,
					 	lwd2) {
	gbar <- mean(gen)
	gamshape <- gbar^2/var(gen)
	rho <- seq(0, xmax, by=0.1)
	## Scaling by mean generation time 
	
	if (missing(lwd2)) lwd2 <- lwd
	
	baseplot <- function(){
		plot(rho, EulerCurve(gbar/rho, gen)
			 , type="l"
			 , ylim=c(1, ymax)
			 , xlab = expression(Relative~length~of~generation~interval~(rho))
			 , ylab = "Reproductive number"
			 , lwd=lwd2
		)
	}
	
	# Version with extra curves
	# Blue is the approximations
	baseplot()
	lines(rho, GammaCurve(1/gamshape, rho), col=momcolor, lwd=lwd, lty=2)
	
	pp <- c(19, 17, 15)
	
	curve(1+x, add=TRUE, col=limcolor, lty=3, lwd=lwd)
	curve(exp(x), add=TRUE, col=limcolor, lty=3, lwd=lwd)
	points(rho_eff, Reff, pch=pp[1:length(Reff)], cex=2)
	
	invisible()
}


GenCurve_DC <- function(gen, xmax, ymax,
						rho_eff,
						Reff,
						lwd=1,
						lwd2,
						legend.position,
						labels) {
	gbar <- mean(gen)
	gamshape <- gbar^2/var(gen)
	rho <- seq(0, xmax, by=0.1)  # :Scaling by mean generation time 
	
	if (missing(lwd2)) lwd2 <- lwd
	
	y.euler <- EulerCurve(gbar/rho, gen)
	y.gamma <- GammaCurve(1/gamshape, rho)
	df <- data.frame(x = rho, 
					 empirical      = y.euler, 
					 gamma.approx   = y.gamma)
	
	colnames(df)[3] <- "approximation theory (moment)"
	
	cols <- c("empirical" = rgb(0,0,0,0.3), 
			  "approximation theory (moment)" = "black")
	
	thesizes <- c("empirical" = 4, 
				  "approximation theory (moment)" = 1.5)
	
	thelinetypes <- c("empirical" = 'solid', 
					  "approximation theory (moment)" = 'solid')
	
	ddf <- df %>%
		gather('gitype','value', 2:3) %>%
		mutate(gitype=factor(gitype, 
							 levels=c("empirical", "approximation theory (moment)", "approximation theory (MLE)")) )
	
	g <- ggplot(ddf)+
		stat_function(fun= function(x) 1+x, col=limcolor, lty=3, lwd=1) +
		stat_function(fun= exp, col=limcolor, lty=3, lwd=1) +
		geom_line(aes(x=x, y=value, 
					  colour = gitype,
					  size = gitype, 
					  linetype = gitype))+
		scale_color_manual( values = cols)+
		scale_size_manual(values=thesizes)+
		scale_linetype_manual(values = thelinetypes)+
		xlab(expression(Relative~length~of~generation~interval~(rho)))+
		scale_y_continuous('Reproduction number', limits = c(1, ymax))+
		theme(axis.text = element_text(size=12),
			  axis.title = element_text(size=12),
			  legend.text = element_text(size=12),
			  legend.title = element_blank(),
			  legend.position = legend.position,
			  legend.key.width = unit(3, "line"),
			  panel.grid.minor = element_blank())
	
	if (!missing(labels)) {
		# Adding countries
		dfc <- data.frame(x = rho_eff,
						  y = Reff, 
						  labels = labels)
		
		y.labels <- max(Reff) + 1 + 0.4*c(0:(length(labels)-1))
		
		g <- g + 
			geom_segment(data = dfc, 
						 aes(x=x, xend=x, y=y, yend= 0.95 * y.labels),
						 size = 0.3)+
			geom_point(data = dfc, aes(x=x, y=y), 
					   pch=21, fill='white',
					   size=3, stroke=2) +
			geom_text(data = dfc, 
					  aes(x=x, y= y.labels, 
					  	label = labels))
	}
	
	print(g)
	
	invisible(g)
}

NormalCurve <- function(gen, xmax, ymax,
						rho_eff,
						Reff,
						lwd=1,
						lwd2) {
	nQuant <- 10000
	q <- (2*(1:nQuant)-1)/(2*nQuant)
	gbar <- mean(gen)
	normgen <- qnorm(q, mean = gbar, sd = sd(gen))
	
	GenCurve(gen, xmax, ymax, rho_eff, Reff, lwd, lwd2)
	
	rho <- seq(0, xmax, by=0.1)
	
	lines(rho, EulerCurve(gbar/rho, normgen), col=norcolor, lty=2, lwd=lwd)
}
