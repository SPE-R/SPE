kt1<-read.csv("kt1_23b.csv")
kt1$kt1<-ifelse(kt1$KT1a==0,kt1$KT1,kt1$KT1a)
kt1<-kt1[kt1$kt1>0,]
