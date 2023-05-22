### R code from vignette source '/home/runner/work/SPE/SPE/build/tab-s.rnw'

###################################################
### code chunk number 1: Looking at births data
###################################################
library(Epi)
data(births)
names(births) 
head(births)  


###################################################
### code chunk number 2: house
###################################################
source("data/births-house.r")


###################################################
### code chunk number 3: sex1
###################################################
stat.table(index = sex, data = births)


###################################################
### code chunk number 4: sex2
###################################################
stat.table(index = sex, contents = list(count(), percent(sex)), data=births)


###################################################
### code chunk number 5: sex3
###################################################
stat.table(index = sex, contents = list(count(), percent(sex)),
  margin=TRUE, data=births)


###################################################
### code chunk number 6: bwsex1
###################################################
stat.table(index = sex, contents = mean(bweight), data=births)


###################################################
### code chunk number 7: bwsex2
###################################################
stat.table(index = sex, contents = list(count(), mean(bweight)), 
   margin=T, data=births)


###################################################
### code chunk number 8: lowbwsex1
###################################################
stat.table(index = sex, contents = percent(lowbw), data=births)


###################################################
### code chunk number 9: lowbwsex2
###################################################
stat.table(index = list(sex,lowbw), contents = percent(lowbw), data=births)


###################################################
### code chunk number 10: exercise on tables
###################################################
stat.table(index = gest4, contents = count(), data=births)
stat.table(index = gest4, contents = mean(bweight), data=births)
stat.table(index = list(lowbw,gest4), contents = percent(lowbw), data=births)


###################################################
### code chunk number 11: ratio
###################################################
stat.table(gest4,ratio(lowbw,1,100),data=births)


###################################################
### code chunk number 12: tagged
###################################################
stat.table(gest4,contents = list( N=count(), 
     "(%)" = percent(gest4)),data=births)


###################################################
### code chunk number 13: named
###################################################
stat.table(index = list("Gestation time" = gest4),data=births)


###################################################
### code chunk number 14: twoway
###################################################
stat.table(list(sex,hyp), contents=mean(bweight), data=births)


###################################################
### code chunk number 15: twoway2
###################################################
stat.table(list(sex,hyp), contents=list(count(), mean(bweight)),
   margin=T, data=births)


###################################################
### code chunk number 16: two way tables exc
###################################################
stat.table(list(sex,hyp), contents=list(count(),mean(bweight)),margin=T, data=births)
stat.table(list(sex,hyp), contents=list(count(),ratio(lowbw,1,100)),margin=T, data=births)


###################################################
### code chunk number 17: printing1
###################################################
odds.tab <- stat.table(gest4, list("odds of low bw" = ratio(lowbw,1-lowbw)), 
              data=births)
print(odds.tab)


###################################################
### code chunk number 18: printing2
###################################################
print(odds.tab, width=15, digits=3)


