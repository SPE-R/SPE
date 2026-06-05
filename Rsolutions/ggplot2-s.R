## ----include=FALSE------------------------------------------------------------
# results and fig.show defaults are now handled globally in _common.R
# based on the SPE_SOLUTIONS env var.
knitr::opts_chunk$set(keep.source = TRUE,
                      eps = FALSE,
                      include = TRUE,
                      prefix.string = "./graph/graphics")


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


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p1 <- ggplot(data=alkfos, mapping=aes(x=time, y=mean)) +
#   geom_point() + geom_line()
# show(p1)


## ----solution=TRUE------------------------------------------------------------
p1 <- ggplot(data=alkfos, mapping=aes(x=time, y=mean, group=treat)) +
  geom_point() + geom_line()
show(p1)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p2 <- p1 + geom_linerange(...)
# show(p2)


## ----solution=TRUE------------------------------------------------------------
p2 <- p1 + geom_linerange(mapping=aes(ymin=mean-sem, ymax=mean+sem))
show(p2)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p3 <- p2 + geom_hline(...)
# show(p3)


## ----solution=TRUE------------------------------------------------------------
p3 <- p2 + geom_hline(yintercept=0, linewidth=0.1)
show(p3)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p4 <- p3 + scale_x_continuous() + scale_y_continuous()
# show(p4)


## ----solution=TRUE------------------------------------------------------------
p4 <- p3 + scale_x_continuous(breaks=c(0,3,6,9,12,18,24)) +
  scale_y_continuous(breaks=seq(from=-40, to=30, by=5),
                              limits = c(-40, 30))
show(p4)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p5 <- p4 + xlab(...) + ylab(...)
# show(p5)


## ----solution=TRUE------------------------------------------------------------
p5 <- p4 + xlab("Months after randomization") +
  ylab("Percent change in serum alkaline phosphate")
show(p5)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p6 <- p5 + ...
# show(p6)


## ----solution=TRUE------------------------------------------------------------
p6 <- p5 + theme_classic(base_size=9)
show(p6)


## ----exercise=TRUE, eval=FALSE------------------------------------------------
# p <- ...
# show(p)


## ----solution=TRUE------------------------------------------------------------
p <- ggplot(alkfos, mapping=aes(x=time, y=mean, groups=treat)) +
  geom_point(mapping=aes(shape=treat)) +
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


## ----eval=spe_solutions()-----------------------------------------------------
tab <- ggplot(data=alkfos,
              mapping=aes(x=time, y=treat, label=available)) +
              geom_text(size=2) + xlab(NULL) + ylab(NULL) +
              scale_x_continuous(breaks=NULL) +
              theme_bw(base_size=9) +
              theme(panel.grid=element_blank())
tab


## ----eval=spe_solutions()-----------------------------------------------------
library(cowplot)
plot_grid(plotlist=list(p, tab), align="v", axis="lr",
          ncol=1, nrow=2, rel_heights=c(5,1))

