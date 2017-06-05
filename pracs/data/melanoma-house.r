mel$sex <- factor(mel$sex,labels=c("M","F"))
mel$skin <- factor(mel$skin,labels=c("dark","medium","light"))
mel$hair <- factor(mel$hair,labels=c("dark","light_brown","blonde","red"))
mel$eyes <- factor(mel$eyes,labels=c("brown","grey-green","blue"))
mel$freckles <- 4 - mel$freckles
mel$age.cat <- cut(mel$age,breaks=c(20,30,40,50,60,70,85),right=F)
mel$freckles <- factor(mel$freckles,labels=c("none","some","many"))

mel$hair2 <- Relevel(mel$hair,list("dark"=1,"other"=c(2,3,4)))
mel$nvsma4 <- cut(mel$nvsmall,breaks=c(0,1,2,5,50),right=F)
mel$nvlar3 <- cut(mel$nvlarge,breaks=c(0,1,2,15),right=F)
