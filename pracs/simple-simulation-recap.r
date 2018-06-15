set.seed(5462319)
#Generate a random 
#sample of size 20 from a normal distribution with mean 100 and standard deviation 10.
#Draw a histogram of the sampled values and compute the conventional summary statistics

 x <- rnorm(20, 100, 10)
 x
 hist(x)
 c(mean(x), sd(x))

 # Repeat the above lines and compare the results.

  x <- rnorm(20, 100, 10)
 hist(x)
 c(mean(x), sd(x))

 #Now replace the sample size 20 by 1000
 #and run again twice the previous command lines with this size
 #but keeping the parameter values as before.
 #Compare the results between the two samples here as well as with those in the previous item.

  x <- rnorm(1000, 100, 10)
 hist(x)
 c(mean(x), sd(x))

  x <- rnorm(1000, 100, 10)
 hist(x)
 c(mean(x), sd(x))

# Generate 500 observations from a Bernoulli distribution, 
#or Bin(1,p) distribution,  
#taking values 1 and 0 with probabilities p and 1-p, respectively,
#when p=0.4:

 X <- rbinom(500, 1, 0.4)
 table(X)

 # Now generate another 0/1 variable Y, being dependent on previously 
 # generated X, so that P(Y=1|X=1)=0.2 and P(Y=1|X=0)=0.1.

 Y <- rbinom(500,1,0.1*X+0.1)
table(X,Y)

stat.table(index = list(X,Y), 
           contents = list(count(),percent(Y)))


# Generate data following a simple linear regression model 

x <- 1:100   
y <- 5 + 0.1*x + rnorm(100,0,10)
plot(x,y)
abline(lm(y~x))
summary(lm(y~x))$coef

# Are your estimates consistent with the data-generating model? 
# Run the code a couple of times to see the variability in the parameter estimates. 



