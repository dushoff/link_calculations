ufun <- function(df){
	mon <- 487/16
	utab <- data.frame(
		units = c("Day", "Week", "Month")
		, uval = c(1, 7, mon)
	)
	df$id <- 1:nrow(df)
	vf <- merge(df, utab, all = TRUE)
	vg <- vf[order(vf$id),]
	return (vg[1:nrow(df),])
}

findrho <- function(gen, Reff) {
	gbar <- mean(gen)
	
	rfun <- function(x, Reff, gen, gbar){
		Reff - EulerR(gen, gbar/x)
	}
	
	if (is.null(Reff)) {
		rho_eff <- NULL
	} else {
		rho_eff <- sapply(Reff, function(x){
			res <- uniroot(rfun, c(0, 10), gen=gen, Reff=x, gbar=gbar)
			return(res$root)
		})
	}
	
	return(rho_eff)
}

