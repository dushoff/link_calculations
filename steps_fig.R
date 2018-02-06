par (cex=1.5)

finTime <- 8
i0 <- 10
C <- 4

steps <- 2
mult <- 6
ss <- mult*steps

basePlot <- function(t, i){
	plot(t, i
		 , type = "l"
		 , xlab = "Time (weeks)"
		 , ylab = "Weekly incidence"
	)
}

arrowStep <- function(t, i, astart, adist, asteps, ss){
	pts <- (astart + adist*(0:asteps)/asteps)*ss
	x <- t[pts]
	y <- i[pts]
	points(c(min(x), max(x)), c(min(y), max(y))) 
	arrows(x[-length(x)], y[-length(y)] 
		   , x[-1], y[-length(y)] 
	)
	arrows(x[-1], y[-length(y)] 
		   , x[-1], y[-1]
		   , length=0
	)
}

t <- (0:(finTime*ss))/ss
i <- i0*exp(t/C)

pdf("steps.pdf", width=10, heigh=5)
par(mfrow=c(1,2))
basePlot(t, i)
arrowStep(t, i, astart=3, adist=4, asteps=3, ss) ## gen length 4/3 days
text(2.5, 70, paste0("Reproduction number: ", round(exp(4/3/C), 2)))

basePlot(t, i)
arrowStep(t, i, astart=3, adist=4, asteps=2, ss) ## gen length 2 days
text(2.5, 70, paste0("Reproduction number: ", round(exp(2/C), 2)))
dev.off()
