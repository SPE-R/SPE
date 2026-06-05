set.seed(202406)
n=2000
U = rnorm(n)
dat = data.frame(Q = rnorm(n))
dat$W = 2*dat$Q+rnorm(n)
dat$X = -2*dat$W +3*U+ rnorm(n)
dat$Z = -2*U+rnorm(n)
dat$Y = dat$Z-3*dat$W+dat$Q+rnorm(n)
rm(U)
dat<- round(dat,3)


