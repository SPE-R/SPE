library(Epi)
data(births)
names(births) 
head(births)  
source("data/births-house.r")

help(stat.table)

stat.table(index = sex, data = births)

stat.table(index = sex, contents = list(count(), percent(sex)), data=births)

#You can also calculate marginal tables by specifying  margin=TRUE

stat.table(index = sex, contents = list(count(), percent(sex)),
  margin=TRUE, data=births)

# To see how the mean birth weight changes with sex, try

stat.table(index = sex, contents = mean(bweight), data=births)

# Add the count to this table. Add the margin with margin=TRUE. 

stat.table(index = sex, contents = list(count(), mean(bweight)), 
   margin=T, data=births)

# As an alternative to  bweight we can look at  lowbw with

stat.table(index = sex, contents = percent(lowbw), data=births)

# All the percentages are 100! To use the percent function the variable 
#  lowbw must also be in the index, as in

stat.table(index = list(sex,lowbw), contents = percent(lowbw), data=births)

# The final column is the percentage of babies with low birth weight by different categories of gestation.

# Obtain a table showing the frequency distribution of gest4.
# Show how the mean birth weight changes with gest4.
# Show how the percentage of low birth weight babies changes with gest4.

stat.table(index = gest4, contents = count(), data=births)
stat.table(index = gest4, contents = mean(bweight), data=births)
stat.table(index = list(lowbw,gest4), contents = percent(lowbw), data=births)

# Another way of obtaining the percentage of low birth weight babies by 
# gestation is to use the ratio function:

stat.table(gest4,ratio(lowbw,1,100),data=births)

# Supply your own column headings using tagged lists as the
# value of the contents argument, within a stat.table call:

stat.table(gest4,contents = list( N=count(), 
     "(%)" = percent(gest4)),data=births)

# This improves the readability of the table.  It remains to give an
# informative title to the index variable. 

stat.table(index = list("Gestation time" = gest4), 
        contents = list( N=count(),"(%)" = percent(gest4)),data=births)

# Two-way Tables

stat.table(list(sex,hyp), contents=mean(bweight), data=births)
stat.table(list(sex,hyp), contents=list(count(), mean(bweight)),
   margin=T, data=births)

stat.table(list(sex,hyp), contents=list(count(),mean(bweight)),margin=T, data=births)
stat.table(list(sex,hyp), contents=list(count(),ratio(lowbw,1,100)),margin=T, data=births)


#Printing

odds.tab <- stat.table(gest4, list("odds of low bw" = ratio(lowbw,1-lowbw)), 
              data=births)
print(odds.tab)
print(odds.tab, width=15, digits=3)



