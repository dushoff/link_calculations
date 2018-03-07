gbar <- mean(gen)
gamshape <- gbar^2/var(gen)
rho <- seq(0, xmax, by=0.1)

comp <- data.frame(rho
	, pseudo = EulerCurve(gbar/rho, gen)
	, matching = GammaCurve(1/gamshape, rho)
)

comp$diff <- with(comp, pseudo/matching - 1)

print(comp)

