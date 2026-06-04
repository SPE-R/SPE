## -----------------------------------------------------------------------------
alkfos <- read.csv("./data/alkfos.csv")


## -----------------------------------------------------------------------------
library(ggplot2, quietly=TRUE)
p0 <- ggplot(data=alkfos, mapping=aes(x=time, y=mean))


## -----------------------------------------------------------------------------
show(p0)


## -----------------------------------------------------------------------------
p1 <- p0 + geom_point() + geom_line()
show(p1)

## ----solution=TRUE------------------------------------------------------------
p1 <- ggplot(data=alkfos, mapping=aes(x=time, y=mean, group=treat)) +
  geom_point() + geom_line()
show(p1)


## ----solution=TRUE------------------------------------------------------------
p2 <- p1 + geom_linerange(mapping=aes(ymin=mean-sem, ymax=mean+sem))
show(p2)


## ----solution=TRUE------------------------------------------------------------
p3 <- p2 + geom_hline(yintercept=0, linewidth=0.1)
show(p3)


## ----solution=TRUE------------------------------------------------------------
p4 <- p3 + scale_x_continuous(breaks=c(0,3,6,9,12,18,24)) +
  scale_y_continuous(breaks=seq(from=-40, to=30, by=5),
                              limits = c(-40, 30))
show(p4)

## ----solution=TRUE------------------------------------------------------------
p5 <- p4 + xlab("Months after randomization") +
  ylab("Percent change in serum alkaline phosphate")
show(p5)


## ----solution=TRUE------------------------------------------------------------
p6 <- p5 + theme_classic(base_size=9)
show(p6)


## ----solution=TRUE------------------------------------------------------------
p <- ggplot(alkfos, mapping=aes(x=time, y=mean, groups=treat)) +
  geom_point(mapping=aes(shape=treat), size=2) +
  scale_shape(name="Treatment", limits=c("placebo", "tamoxifen"),
              labels=c("Control", "Tamoxifen")) +
  geom_line() +
  geom_linerange(mapping=aes(ymin=mean-sem, ymax=mean+sem)) +
  scale_x_continuous(breaks=c(0,3,6,9,12,18,24)) +
  scale_y_continuous(breaks=seq(from=-40, to=30, by=5),
                     limits = c(-40, 30)) +
  xlab("Months after randomization") +
  ylab("Percent change in serum alkaline phosphate") +
  geom_hline(yintercept=0, linewidth=0.1) +
  theme_classic(base_size=9)
show(p)

alkfos |> 
  ggplot(mapping=aes(x=time, y=treat, label=available)) +
  geom_text(size=2) + xlab(NULL) + ylab(NULL) +
  scale_x_continuous(breaks=NULL) +
  scale_y_discrete(limits=c("tamoxifen", "placebo"),
                   labels=c("Tamoxifen", "Control")) +
  theme_bw(base_size=9) +
  theme(panel.grid=element_blank()) -> tab
tab

library(cowplot)
plot_grid(plotlist=list(p, tab), align="v", axis="lr",
          ncol=1, nrow=2, rel_heights=c(5,1))


#-----------------------------------------------------------------

alkfos0 <- subset(alkfos, treat=="placebo")
alkfos1 <- subset(alkfos, treat=="tamoxifen")

par(las=1, mar=c(8, 4, 0, 4) +  0.1, cex=0.9)
plot(mean ~ time, ylim=c(-40,30), data=alkfos, type="n", axes=FALSE,
     xlab = "Months after randomization",
     ylab = "Percent change in serum alkaline phosphate")
## Control group
points(mean ~ time, data=alkfos0, pch=15, cex=1)
lines(mean ~ time, data=alkfos0)
with(alkfos0, segments(time, mean - sem, time, mean + sem))
mtext("Control", side=4, line=0.1, at=tail(alkfos0$mean, 1), cex=0.8)
## Treatment group
points(mean ~ time, data=alkfos1, pch=19, cex=1)
lines(mean ~ time, data=alkfos1)
with(alkfos1, segments(time, mean - sem, time, mean + sem))
mtext("Tamoxifen", side=4, line=0.1, at=tail(alkfos1$mean, 1), cex=0.8)
## Axes and grid lines
abline(h=0, col="grey")     
axis(side=1, at=c(0,3,6,9,12,18,24))
axis(side=2, at=seq(from=-40, to=30, by=5))
## Table
with(alkfos0, mtext(available, side=1, line=5, at=time, cex=0.8))
with(alkfos1, mtext(available, side=1, line=6, at=time, cex=0.8))
mtext("Control", side=1, line=5, at=-2.5, cex=0.8)
mtext("Tamoxifen", side=1, line=6, at=-2.5, cex=0.8)     
