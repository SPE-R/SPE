plot1 <- function() {
  plot(oc.lex,
       grid = list( seq(1990, 2010, 5), seq( 35, 85, 5)), 
       xlim = c(1990, 2010), ylim = c(35, 85), 
       lty.grid = 1, xaxs='i', yaxs = 'i', 
       xlab = "Calendar year", ylab = "Age (years)") 
  points( oc.lex,  pch = c(NA, 16)[oc.lex$lex.Xst+1], cex=0.5)
}

plot2 <- function(){
  plot(oc.lexord, 
       time.scale = "age",  
       xlim = c(40, 80), 
       xlab = "Age (years)" ) 
  points(oc.lexord, time.scale = "age", 
         pch = c(NA, 16)[oc.lexord$lex.Xst+1], cex=0.5)
  with( subset(oc.lexord, lex.Xst==1), 
        abline( v = agexit, lty = 3, lwd = 0.5 ))
}

plot3 <- function() {
  plot(oc.lexord, 
       time.scale = "age", ylim = c(5, 65),
       xlim = c(50, 58), 
       xlab = "Age (years)" ) 
  points(oc.lexord, time.scale = "age", 
         pch = c(NA, 16)[oc.lexord$lex.Xst+1], cex=0.5)
  with( subset(oc.lexord, lex.Xst==1), 
        abline( v = agexit, lty = 3, lwd = 0.5 ) )
}

plot4 <- function() {
  plot(subset(oc.lexord, chdeath==0 & id %in% subcids), 
       time.scale = "age",  
       xlim = c(40, 80), # ylim = c(18,210),
       xlab = "Age (years)" ) 
  lines(subset(oc.lexord, chdeath==1 & id %in% subcids ), 
        time.scale = "age", lwd=0.5, col = 'blue' )
  points(subset(oc.lexord, chdeath==1 & id %in% subcids ), 
         time.scale = "age", pch = 16, col='blue',  cex=0.5)             
  lines(subset(oc.lexord, chdeath==1 & !(id %in% subcids) ), 
        time.scale = "age", lty = 3, lwd=0.5, col = 'black' )
  points(subset(oc.lexord, chdeath==1 & !(id %in% subcids) ), 
         time.scale = "age", pch = 16, col='black',  cex=0.5)
}
