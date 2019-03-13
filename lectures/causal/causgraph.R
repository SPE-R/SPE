pdf("instvar.pdf",height=3,width=6)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim=0:1*100, ylim=0:1*80, xaxt="n", yaxt="n", xlab="", ylab="" )
b<-0; w=12
bz  <- tbox( "Z", 10, 60, w,w, col.txt="green",col.border=b)
bx  <- tbox( "X", 50, 60, w,w, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,w, col.txt="blue" ,col.border=b)
bu  <- tbox( "U", 70, 20, w,w, col.txt="red" ,col.border=b)
#boxarr( bx, by , col=1, lwd=3 )
#boxarr( bu, bx , col=2, lwd=3 )
#boxarr( bu, by , col=2, lwd=3 )

text( boxarr( bz, bx , col="green", lwd=3 ), expression(delta), col="green", adj=c(0,-0.2), cex=0.8 )
text( boxarr( bx, by , col="blue", lwd=3 ), expression(beta), col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( bu, bx , col="red", lwd=3 )
text( boxarr( bu, by , col="red", lwd=3 ), expression(gamma), col="red", adj=c(1,-0.2), cex=0.8 )
dev.off()


pdf("confound.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n",
 xlab="", ylab="" )
b<-0; w=12
bx  <- tbox( "X", 50, 60, w,w, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,w, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,w, col.txt="red" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=3 ), "?", col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( bu, bx , col=2, lwd=3 )
boxarr( bu, by , col=2, lwd=3 )

dev.off()

pdf("mediation.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n",
 xlab="", ylab="" )
b<-0; w=12
bx  <- tbox( "X", 50, 60, w,w, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,w, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,w, col.txt="red" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=3 ), "?", col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( bx, bu , col=2, lwd=3 )
boxarr( bu, by , col=2, lwd=3 )
dev.off()

pdf("mediation_conf.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=2)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n",
 xlab="", ylab="" )
b<-0; w=12
bx  <- tbox( "X", 50, 60, w,w, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,w, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,w, col.txt="red" ,col.border=b)
bw  <- tbox( "W", 90, 28, w,w, col.txt="black" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=2 ), "?", col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( bx, bu , col=2, lwd=2 )
boxarr( bu, by , col=2, lwd=2 )
boxarr( bw, by , col=1, lwd=2 )
boxarr( bw, bu , col=1, lwd=2 ,gap=0)
dev.off()

pdf("revcaus.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n",
 xlab="", ylab="" )
b<-0; w=12
bx  <- tbox( "X", 50, 60, w,w, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,w, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,w, col.txt="red" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=3 ), "?", col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( by, bu , col=2, lwd=3 )
boxarr( bu, bx , col=2, lwd=3 )
dev.off()

pdf("wrongadjust.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n", xlab="", ylab="" )
b<-0; w=12
bx  <- tbox( "X", 50, 60, w,h, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,h, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,h, col.txt="red" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=3 ), "?", col="blue", adj=c(0,-0.2), cex=0.8 )
boxarr( bx, bu , col=2, lwd=3 )
boxarr( by, bu , col=2, lwd=3 )
dev.off()

pdf("direffect.pdf",height=3,width=4)
par( mar=c(0,0,0,0), cex=3)
plot( NA, bty="n",xlim= c(40,100), ylim=0:1*80, xaxt="n", yaxt="n", xlab="", ylab="" )
b<-0; w=12; h=12
bx  <- tbox( "X", 50, 60, w,h, col.txt="blue" ,col.border=b)
by  <- tbox( "Y", 90, 60, w,h, col.txt="blue" ,col.border=b)
bu  <- tbox( "Z", 70, 20, w,h, col.txt="red" ,col.border=b)
text( boxarr( bx, by , col="blue", lwd=3 ), "?",adj=c(0,-0.2) ,col="blue",  cex=0.8 )
boxarr( bx, bu , col=2, lwd=3 )
boxarr( bu, by, col=2, lwd=3 )
dev.off()


pdf("mendrand.pdf",height=4,width=8)
par( mar=c(0,0,0,0), cex=2)
plot( NA, bty="n",xlim=0:1*100, ylim=0:1*80, xaxt="n", yaxt="n", xlab="", ylab="" )
b<-0;  h=12; w=22
bz  <- tbox( "FTO", 10, 60, w,h, col.txt="green",col.border=b)
bx  <- tbox( "BMI", 50, 60, w,h, col.txt="blue" ,col.border=b)
by  <- tbox( "Glucose \n (Diabetes)", 90, 60, 25,h, col.txt="blue" ,col.border=b)
bu  <- tbox( "U", 70, 20, w,w, col.txt="red" ,col.border=b)
boxarr( bx, by , col="blue", lwd=3 )
boxarr( bz, bx , col=	1, lwd=3 )
boxarr( bu, by , col=2, lwd=3 )
boxarr( bu, bx , col="red", lwd=3 )
dev.off()

