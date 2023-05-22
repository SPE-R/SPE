### R code from vignette source '/home/runner/work/SPE/SPE/build/logistic-s.rnw'

###################################################
### code chunk number 1: Reading the data
###################################################
library(Epi)
mel <- read.table("http://bendixcarstensen.com/SPE/data/melanoma.dat", header=TRUE, na.strings=".")
str(mel)
head(mel, n=20)


###################################################
### code chunk number 2: Run the house keeping script
###################################################
source("http://bendixcarstensen.com/SPE/data/melanoma-house.r")


###################################################
### code chunk number 3: Structure and summary
###################################################
str(mel)
summary(mel)


###################################################
### code chunk number 4: cases and controls by each variable separately
###################################################
with(mel, table(cc,skin))
stat.table(skin, contents=ratio(cc,1-cc), data=mel)


###################################################
### code chunk number 5: Effect of skin
###################################################
effx(cc, type="binary", exposure=skin, data=mel)


###################################################
### code chunk number 6: Effects of hair eyes and freckles
###################################################
with(mel, table(cc,hair))
stat.table(hair, contents=ratio(cc,1-cc), data=mel)
effx(cc,type="binary",exposure=hair,data=mel)

with(mel, table(cc,eyes))
stat.table(eyes, contents=ratio(cc,1-cc), data=mel)
effx(cc, type="binary", exposure=eyes, data=mel)

with(mel, table(cc,freckles))
stat.table(freckles, contents=ratio(cc,1-cc),data=mel)
effx(cc, type="binary", exposure=freckles, data=mel)


###################################################
### code chunk number 7: Fitting the glm
###################################################
mf <- glm(cc ~ freckles, family="binomial", data=mel)
round(ci.exp( mf ),2)



###################################################
### code chunk number 8: controlling for age and sex
###################################################
effx(cc, typ="binary", exposure=freckles, control=list(age.cat,sex),data=mel)


###################################################
### code chunk number 9: freckles controlling for age and sex using glm
###################################################
mfas <- glm(cc ~ freckles + age.cat + sex, family="binomial", data=mel)
round(ci.exp(mfas), 2)


###################################################
### code chunk number 10: Likelihood ratio test for the effects of freckles
###################################################
mas <- glm(cc ~ age.cat + sex, family="binomial", data=subset(mel, !is.na(freckles)) )
anova(mas, mfas, test="Chisq")


###################################################
### code chunk number 11: P-value
###################################################
1 - pchisq(48.786, 2)


###################################################
### code chunk number 12: hair colour controlling for age and sex
###################################################
mas2 <- glm(cc ~ age.cat + sex, family="binomial", 
               data=subset(mel, !is.na(hair)) )
mhas <- glm(cc ~ hair + age.cat + sex, family="binomial", 
               data=subset(mel, !is.na(hair)) )
round(ci.exp(mhas), 2)
anova(mas2, mhas, test="Chisq")


###################################################
### code chunk number 13: Effect of hair2
###################################################
effx(cc, type="binary", exposure=hair2, control=list(age.cat,sex), data=mel)


###################################################
### code chunk number 14: Effect of hair2 using glm
###################################################
mh2 <- glm(cc ~ hair2 + age.cat + sex, family="binomial", 
             data = subset(mel, !is.na(hair2)) )
ci.exp(mh2 )


###################################################
### code chunk number 15: LR test
###################################################
m1 <- glm(cc ~ age.cat + sex, data = subset(mel, !is.na(hair2)) )
anova(m1, mh2,test="Chisq")


###################################################
### code chunk number 16: Effect of freckles controlled for age.cat and sex and stratified by hair2
###################################################
effx(cc, type="binary", exposure=freckles, 
                  control=list(age.cat,sex), strata=hair2, data=mel)


###################################################
### code chunk number 17: Effect of freckles controlled for age.cat sex and hair2
###################################################
effx(cc, type="binary", exposure=freckles, 
                  control=list(age.cat,sex,hair2), data=mel)


###################################################
### code chunk number 18: Effect of freckles controlled for age.cat and sex and stratified by hair2
###################################################
effx(cc, type="binary", exposure=freckles, 
           control=list(age.cat,sex), strata=hair2,data=mel)


###################################################
### code chunk number 19: Nested effects using glm
###################################################
mfas.h <- glm(cc ~ hair2/freckles + age.cat + sex, family="binomial", data=mel)
ci.exp(mfas.h )


###################################################
### code chunk number 20: Distribution of naevi
###################################################
with(mel, stem(nvsmall))
with(mel, stem(nvlarge))


###################################################
### code chunk number 21: Joint frequency of nvsma4 and nvlar3
###################################################
stat.table(list(nvsma4,nvlar3),contents=percent(nvlar3),data=mel)
#High frequencies on the diagonal shows a strong association


###################################################
### code chunk number 22: Effects of naevi on melanoma
###################################################
effx(cc,type="binary",exposure=nvsma4,control=list(age.cat,sex),data=mel)
mns <- glm(cc ~ nvsma4 + age.cat + sex, family="binomial",data=mel)
round(ci.exp(mns), 2)


###################################################
### code chunk number 23: logistic-s.rnw:283-286
###################################################
effx(cc, type="binary", exposure=nvlar3, control=list(age.cat,sex), data=mel)
mnl <- glm(cc ~ nvlar3 + age.cat + sex, family="binomial", data=mel)
round(ci.exp(mnl), 2)


###################################################
### code chunk number 24: logistic-s.rnw:293-296
###################################################
mnls <- glm(cc ~ nvsma4 + nvlar3 + age.cat + sex, family="binomial", data=mel)
# Coeffs for nvsma4 are the effects of nvsma4 controlled for age.cat, sex, and nvlar3. 
# Similarly for the coefficients for nvlar3.


###################################################
### code chunk number 25: Linear effect of freckles
###################################################
mel$fscore<-as.numeric(mel$freckles)
effx(cc, type="binary", exposure=fscore, control=list(age.cat,sex), data=mel)


###################################################
### code chunk number 26: logistic-s.rnw:309-312
###################################################
m1 <- glm(cc ~ freckles + age.cat + sex, family="binomial", data=mel)
m2 <- glm(cc ~ fscore + age.cat + sex, family="binomial", data=mel)
anova(m2, m1, test="Chisq")


###################################################
### code chunk number 27: Using cumulative contrasts to study linearity
###################################################
m1 <- glm(cc ~ C(freckles, contr.cum) + age.cat + sex, family="binomial",data=mel)
round(ci.exp(m1 ), 2)
m2 <- glm(cc ~ fscore + age.cat + sex, family="binomial",data=mel)
round(ci.exp(m2), 2)


###################################################
### code chunk number 28: Plots
###################################################
m <- glm(cc ~ nvsma4 + nvlar3 + age.cat + sex, family="binomial",data=mel)
plotEst( exp( ci.lin(m)[ 2:5, -(2:4)] ), xlog=T, vref=1 )


