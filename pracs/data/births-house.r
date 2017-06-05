
births$hyp <- factor(births$hyp,labels=c("normal","hyper"))
births$sex <- factor(births$sex,labels=c("M","F"))
births$agegrp <- cut(births$matage,breaks=c(20,25,30,35,40,45),right=FALSE)
births$gest4 <- cut(births$gestwks,breaks=c(20,35,37,39,45),right=FALSE)

