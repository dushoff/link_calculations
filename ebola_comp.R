
data.frame(rho_eff
	, pseudo = EulerCurve(gbar/rho_eff, gen)
	, matching = GammaCurve(1/gamshape, rho_eff)
	, Reff
)
