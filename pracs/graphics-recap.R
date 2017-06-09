### R code from vignette source 'graphics-e.rnw'

###################################################
### code chunk number 1: graphics-e.rnw:10-11
###################################################
alkfos <- read.csv("data/alkfos.csv") # change filename as needed


###################################################
### code chunk number 2: graphics-e.rnw:19-20
###################################################
source("data/alkfos-house.r")

upper <- means + sems
lower <- means - sems
upper
lower

ylim <- range(c(lower,upper))
ylim

par(mar=.1 + c(8,4,4,2))
plot( times, means[1,],
      type="b",   # boths dots and lines
      xaxt="n",   # no x-axis
      ylim=ylim,
      ylab="alkaline phosphatase" )
# Add the points for the second gropu
points(times,means[2,], type="b")
# The the vertial error-bars
segments( times, upper[1,], times, lower[1,] )
segments( times, upper[2,], times, lower[2,])
# Draw the x-axis at the times
axis( 1, at=times )
# Plot the availabe numbers below the x-axis
mtext( available[1,], side=1, line=5, at=times)
mtext( available[2,], side=1, line=6, at=times)


par(mar=.1 + c(8,5,4,2))
plot(times,means[1,], type="b", ylim=ylim, xaxt="n",
     ylab="% change in alkaline phosphatase",
     xlab="Months after randomization",
     las=1, # All axis labels horizontal
     pch=16, # Dot as plotting symbol
     bty="n", lwd=2 ) # No box around the plot
segments(times ,  upper[1,], times , lower[1,], lwd=2 )
times2 <- times + 0.25 # Plot the points and bars a little bit offset
points  (times2, means[2,], type="b", pch=18, lwd=2, cex=1.3)
segments(times2, upper[2,], times2, lower[2,], lwd=2 )
axis(1,at=times)
mtext(available[1,],side=1, line=5, at=times)
mtext(available[2,],side=1, line=6, at=times)
# par("usr") reaturns the actual x- and y coordinates of the axis ends.
mtext("Placebo"  , side=1, line=5, adj=1, at=par("usr")[1] )
mtext("Tamoxifen", side=1, line=6, adj=1, at=par("usr")[1] )
abline(h=0) # Horizontal line

###################################################
### code chunk number 4: graphics-e.rnw:98-100
###################################################
library(ggplot2)
qplot(x=times, y=means, group=treat, 
      geom=c("point", "line") , data=ggdata)


###################################################
### code chunk number 5: graphics-e.rnw:112-115
###################################################
p <- qplot(x=times, y=means, group=treat, 
           ymin=means-sems, ymax=means+sems, 
           yintercept=0, 
           geom=c("point", "line", "linerange"), 
           data=ggdata)
print(p)


###################################################
### code chunk number 6: graphics-e.rnw:127-131
###################################################
p <- p + 
 scale_x_continuous(name="Months after randomization", 
                    breaks=times[1:7]) +
 scale_y_continuous(name=
                    "% change in alkaline phosphatase")
print(p)


###################################################
### code chunk number 7: graphics-e.rnw:135-136
###################################################
p + theme_bw()


###################################################
### code chunk number 8: graphics-e.rnw:144-151
###################################################
p <- ggplot(data=ggdata, 
            aes(x=times, y=means, ymin=means-sems, 
                ymax=means+sems, group=treat)) +
    geom_point() +
    geom_line() +
    geom_linerange() +
    geom_hline(yintercept=0, colour="darkgrey") +
    scale_x_continuous(breaks=times[1:7])
p

###################################################
### code chunk number 9: graphics-e.rnw:164-168
###################################################
tab <- ggplot(data=ggdata, 
              aes(x=times, y=treat, label=available)) +
    geom_text(size=3) + 
    xlab(NULL) + 
    ylab(NULL) + 
    scale_x_continuous(breaks=NULL)
tab


###################################################
### code chunk number 10: graphics-e.rnw:173-177
###################################################
library(grid)
Layout <- grid.layout(nrow = 2, ncol = 1, 
         heights = unit(c(2, 0.25), c("null", "null")))
grid.show.layout(Layout)


###################################################
### code chunk number 11: graphics-e.rnw:183-187
###################################################
grid.newpage() #Clear the page
pushViewport(viewport(layout=Layout))
print(p, vp=viewport(layout.pos.row=1, layout.pos.col=1))
print(tab, vp=viewport(layout.pos.row=2, layout.pos.col=1))


###################################################
### code chunk number 12: graphics-e.rnw:192-194
###################################################
library(cowplot)
plot_grid(p, tab, align="v", ncol=1, nrow=2, 
          rel_heights=c(5,1))


