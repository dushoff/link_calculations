gammaMLE <- function(gen) {
	m <- mle2(gen~dgamma(shape=shape, scale=scale)
			  , data=data.frame(gen=gen)
			  , start=list(
			  	shape=mean(gen)^2/var(gen), scale=var(gen)/mean(gen)
			  ))
	
	coef(m)
}
