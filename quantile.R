lnquantiles <- function(mean, sdlog, nQuant=1000){
	q <- (2*(1:nQuant)-1)/(2*nQuant)
	lat <- qlnorm(q, sdlog=sdlog)
	return(lat*mean/mean(lat))
}

## Take a weighted sample from a list of functional periods
## Return a random infection time associated with each
## We might want a paired version of this in future; if so, be
## careful about false pairing with quantiles

genSamp <- function(lat, inf, nsamp=100){
	inf <- sample(inf, size=nsamp, replace=TRUE, prob=inf/sum(inf))
	lat <- sample(lat, size=nsamp, replace=(nsamp>length(lat)))

	return(runif(nsamp, min=lat, max=lat+inf))
}
