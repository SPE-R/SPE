## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", fig.show = "hide", keep.source = TRUE, eps = FALSE, include = TRUE, prefix.string = "./graph/graphics")


## -----------------------------------------------------------------------------
# change filename as needed
alkfos <- read.csv("./data/alkfos.csv") 


## ----echo=FALSE---------------------------------------------------------------
source("./data/alkfos-house.r")


## -----------------------------------------------------------------------------
ggdata <- data.frame(
  times = rep(times, 2),
  means = c(means[1, ], means[2, ]),
  sds = c(sds[1, ], sds[2, ]),
  available = c(available[1, ], available[2, ]),
  treat = rep(c("placebo", "tamoxifen"), each = 7)
)
ggdata <- transform(ggdata, sems = sds / sqrt(available))


## -----------------------------------------------------------------------------
library(ggplot2)
qplot(
  x = times, 
  y = means, 
  group = treat, 
  geom = c("point", "line"), 
  data = ggdata
)


## -----------------------------------------------------------------------------
p <- qplot(
  x = times, y = means, group = treat,
  ymin = means - sems, ymax = means + sems,
  yintercept = 0, geom = c("point", "line", "linerange"),
  data = ggdata
)
print(p)


## -----------------------------------------------------------------------------
p <- p +
  scale_x_continuous(
    name = "Months after randomization",
    breaks = ggdata$times
  ) +
  scale_y_continuous(name = "% change in alkaline phosphatase")
print(p)


## -----------------------------------------------------------------------------
p + theme_bw()


## -----------------------------------------------------------------------------
p <- ggplot(
  data = ggdata,
  aes(
    x = times, 
    y = means, 
    ymin = means - sems, 
    ymax = means + sems,
    group = treat
  )
) +
  geom_point() +
  geom_line() +
  geom_linerange() +
  geom_hline(yintercept = 0, colour = "darkgrey") +
  scale_x_continuous(breaks = ggdata$times) +
  scale_y_continuous(breaks = seq(-35, 25, 5))
print(p)


## -----------------------------------------------------------------------------
tab <- 
  ggplot(
    data = ggdata, 
    aes(x = times, y = treat, label = available)
  ) +
  geom_text(size = 3) +
  xlab(NULL) +
  ylab(NULL) +
  scale_x_continuous(breaks = NULL)
tab


## -----------------------------------------------------------------------------
library(grid)
Layout <- grid.layout(nrow = 2, ncol = 1, heights = unit(
  c(2, 0.25),
  c("null", "null")
))
grid.show.layout(Layout)


## -----------------------------------------------------------------------------
grid.newpage() # Clear the page
pushViewport(viewport(layout = Layout))
print(p, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))
print(tab, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))


## -----------------------------------------------------------------------------
library(cowplot)
plot_grid(
  p, 
  tab, 
  align = "v", 
  ncol = 1, 
  nrow = 2, 
  rel_heights = c(5, 1)
)


## -----------------------------------------------------------------------------
theme_set(theme_cowplot())
plot_grid(
  p, 
  tab, 
  align = "v", 
  ncol = 1, 
  nrow = 2, 
  rel_heights = c(5, 1)
)

