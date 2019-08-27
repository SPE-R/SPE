### R code from vignette source 'occoh-caco-s.rnw'
### Encoding: ISO8859-1

###################################################
### code chunk number 1: Read in occoh data
###################################################
library(Epi)
library(survival)
url <- "https://raw.githubusercontent.com/SPE-R/SPE/master/pracs/data"
oc <- read.table( paste(url, "occoh.txt", sep = "/"), header=TRUE)
str(oc)
summary(oc)



###################################################
### code chunk number 2: cal.yr
###################################################
oc$ybirth <- cal.yr(oc$birth) 
oc$yentry <- cal.yr(oc$entry) 
oc$yexit <- cal.yr(oc$exit)


###################################################
### code chunk number 3: age.yr
###################################################
oc$agentry <- oc$yentry - oc$ybirth
oc$agexit <- oc$yexit - oc$ybirth 


###################################################
### code chunk number 4: oclexis
###################################################
oc.lex <- Lexis( entry = list( per = yentry, 
                               age = yentry - ybirth ), 
                  exit = list( per = yexit),
           exit.status = chdeath,
                    id = id, data = oc)
str(oc.lex)
summary(oc.lex)


###################################################
### code chunk number 5: plotlexis
###################################################
par(mfrow=c(1,1))
plot( oc.lex, xlim=c(1990, 2010),grid=TRUE )
points( oc.lex, pch=c(NA, 16)[oc.lex$lex.Xst+1] )


###################################################
### code chunk number 6: plotlexage
###################################################
oc.ord <- cbind(ID = 1:1501, oc[ order( oc$agexit, oc$agentry), ] )  
oc.lexord <- Lexis( entry = list( age = agentry ), 
                     exit = list( age = agexit),
              exit.status = chdeath,
                       id = ID, data = oc.ord)
plot(oc.lexord, "age")
points(oc.lexord, pch=ifelse(oc.lexord$lex.Xst==1, 16, NA) )
with( subset(oc.lexord, lex.Xst==1), 
      abline( v=agexit, lty=3))


###################################################
### code chunk number 7: plotlexage2
###################################################
plot(oc.lexord, "age", xlim=c(50, 58), ylim=c(5, 65))
points(oc.lexord, "age", pch=ifelse(oc.lexord$lex.Xst==1, 16, NA))
with( subset(oc.lexord, lex.Xst==1), 
      abline( v=agexit, lty=3))


###################################################
### code chunk number 8: agentry2
###################################################
oc.lex$agen2 <- cut(oc.lex$agentry, br = seq(40, 62, 1) )


###################################################
### code chunk number 9: risksetsample
###################################################
set.seed(98623)
cactrl <- 
   ccwc(entry=agentry, exit=agexit, fail=chdeath, 
        controls = 2, match= agen2, 
        include = list(id, agentry), 
        data=oc.lex, silent=FALSE)
str(cactrl)


###################################################
### code chunk number 10: ocX
###################################################
ocX <- read.table( paste(url, "occoh-Xdata.txt", sep = "/"), header=TRUE)
str(ocX)


###################################################
### code chunk number 11: merge
###################################################
oc.ncc <- merge(cactrl, ocX[, c("id", "smok", "tchol", "sbp")], 
   by = "id")
str(oc.ncc)


###################################################
### code chunk number 12: factor smol
###################################################
oc.ncc$smok <- factor(oc.ncc$smok, 
    labels = c("never", "ex", "1-14/d", ">14/d"))          


###################################################
### code chunk number 13: cccrude smok
###################################################
stat.table( index = list( smok, Fail ), 
          contents = list( count(), percent(smok) ),
           margins = T, data = oc.ncc )
smok.crncc <- glm( Fail ~ smok, family=binomial, data = oc.ncc)
round(ci.exp(smok.crncc), 3) 


###################################################
### code chunk number 14: clogit
###################################################
m.clogit <- clogit( Fail ~ smok + I(sbp/10) + tchol + 
       strata(Set), data = oc.ncc )
summary(m.clogit)
round(ci.exp(m.clogit), 3)


###################################################
### code chunk number 15: subc sample
###################################################
N <- 1501; n <- 260
set.seed(15792)
subcids <- sample(N, n )
oc.lexord$subcind <- 1*(oc.lexord$id %in% subcids)


###################################################
### code chunk number 16: casecoh data
###################################################
oc.cc <- subset( oc.lexord, subcind==1 | chdeath ==1)
oc.cc <- merge( oc.cc, ocX[, c("id", "smok", "tchol", "sbp")], 
   by ="id")
str(oc.cc) 


###################################################
### code chunk number 17: casecoh-lines
###################################################
plot( subset(oc.cc, chdeath==0), "age")    
lines( subset(oc.cc, chdeath==1 & subcind==1), col="blue")  
lines( subset(oc.cc, chdeath==1 & subcind==0), col="red")   
points(subset(oc.cc, chdeath==1), pch=16, 
       col=c("blue", "red")[oc.cc$subcind+1])


###################################################
### code chunk number 18: grouping
###################################################
oc.cc$smok <- factor(oc.cc$smok, 
    labels = c("never", "ex", "1-14/d", ">14/d"))


###################################################
### code chunk number 19: cc-crude HR by smok
###################################################
sm.cc <- stat.table( index = smok, 
   contents = list( Cases = sum(lex.Xst), Pyrs = sum(lex.dur) ),
	 margins = T, data = oc.cc)
print(sm.cc, digits = c(sum=0, ratio=1))
HRcc <- (sm.cc[ 1, -5]/sm.cc[ 1, 1])/(sm.cc[ 2, -5]/sm.cc[2, 1])		
round(HRcc, 3)			


###################################################
### code chunk number 20: weighted cox LinYing
###################################################
oc.cc$survobj <- with(oc.cc, Surv(agentry, agexit, chdeath) )
cch.LY <- cch( survobj ~  smok + I(sbp/10)  + tchol, stratum=NULL,
   subcoh = ~subcind, id = ~id,  cohort.size = N, data = oc.cc, 
    method ="LinYing" )
summary(cch.LY)


###################################################
### code chunk number 21: fullcoh
###################################################
oc.full <- merge( oc.lex, ocX[, c("id", "smok", "tchol", "sbp")], 
   by.x = "id", by.y = "id") 
oc.full$smok <- factor(oc.full$smok, 
    labels = c("never", "ex", "1-14/d", ">14/d"))


###################################################
### code chunk number 22: cox-crude HR by smok
###################################################
sm.coh <- stat.table( index = smok, 
   contents = list( Cases = sum(lex.Xst), Pyrs = sum(lex.dur) ),
	 margins = T, data = oc.full)
print(sm.coh, digits = c(sum=0, ratio=1))
HRcoh <- (sm.coh[ 1, -5]/sm.coh[ 1, 1])/(sm.coh[ 2, -5]/sm.coh[2, 1])		
round(HRcoh, 3)			


###################################################
### code chunk number 23: cox full
###################################################
cox.coh <- coxph( Surv(agentry, agexit, chdeath) ~ 
        smok + I(sbp/10)  + tchol, data = oc.full)
summary(cox.coh)        


###################################################
### code chunk number 24: comparison
###################################################
betas <- cbind( coef(cox.coh), coef(m.clogit), coef(cch.LY) )
colnames(betas) <-  c("coh", "ncc", "cch.LY")
round(betas, 3)

SEs <- cbind( sqrt( diag( cox.coh$var ) ), 
              sqrt( diag( m.clogit$var ) ),
              sqrt( diag( cch.LY$var ) ) )
colnames(SEs) <- colnames(betas) 
round(SEs, 3)


