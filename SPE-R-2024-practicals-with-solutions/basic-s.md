

# Practice with basic R

The main purpose of this session is to give participants who have not
had much (or any) experience with using `R` a chance to
practice the basics and to ask questions. For others, it should serve
as a reminder of some of the basic features of the language.

R can be installed on all major platforms (*i.e.* Windows, macOS,
Linux).  We do not assume in this exercise that you are using any
particular platform. Many people like to use the RStudio graphical
user interface (GUI), which gives the same look and feel across all
platforms.

## The working directory

A key concept in `R` is the *working directory* (or *folder* 
in the terminology of Windows). The working directory is
where `R` looks for data files that you may want to read in and
where `R` will write out any files you create.  It is a good
idea to keep separate working directories for different projects. In
this course we recommend that you keep a separate working directory
for each exercise.

If you are working on the command line in a terminal, then you can
change to the correct working directory and then launch `R` by
typing *R*.

If you are using a GUI then you will typically need to change to the
correct working directory after starting `R`. In RStudio, you
can change directory from the *Session* menu. However it is much
more useful to create a new *project* to keep your source files
and data. When you open a project in the RStudio GUI, your working
directory is automatically changed to the directory associated with
the project.

You can display the current working directory with the `getwd()`
(*get working directory*) function and set it with the `setwd()`
(*set working directory*) function. The function `dir()` can be
used to see what files you have in the working directory.

## The workspace

You can quit `R` by typing


```r
q()
```

at the `R` command prompt. You will be asked if you want to
save your workspace. We strongly recommend that you answer *no* to this
question. If you answer *yes* then R will write a file named
`.RData` into the working directory containing all the objects
you created during your session. This file will be automatically loaded
the next time you start `R` and this will restore all the objects
in your workspace. 

It may seem convenient to keep your R objects from one session to another.
But this has many disadvantages.

-  You may not remember how an object was created. This becomes a
  problem if you need to redo your analysis after the data has been
  changed or updated, or if you accidentally delete the object.
-  An object might be modified or overwritten. In this case your 
  analysis will give you a different answer but you will not know why.
  You may not even notice that the answer has changed.
-  It becomes impossible to clean your workspace if you cannot
  remember which objects are required by which analyses. As a result,
  your workspace will become cluttered with old objects.


We strongly recommend that you follow some basic principles of
reproducible research.

-  Always start with a clean (empty) workspace.
-  Read in the data you need from a pristine source.
-  Put your R commands in a script file so that they can be run
  again in a future session.
-  All modifications to the data that you need to make should be
  done in R using a script and not by editing the data source. This
  way, if the original data is modified or updated then you can run
  the script again on the updated data.


## Using R as a calculator

Try using R as an interactive calculator by typing different
arithmetic expressions on the command line.  Pressing the return key
on the command line finishes the expression. R will then evaluate the
expression and print out the result.

Note that R allows you to recall previous commands using the vertical
arrow key. You can edit a recalled command and then resubmit it by
pressing the return key. Keeping that in mind, try the following:


```r
12 + 16
(12 + 16) * 5
sqrt((12 + 16) * 5) # square root
round(sqrt((12 + 16) * 5), 2) # round to two decimal places
```

The hash symbol `#` denotes the start of a *comment*. 
Anything after the hash is ignored by R.

Round braces are used a lot in R. In the above expressions, they are
used in two different ways. Firstly, they can be used to establish the
order of operations. In the example


```r
(12 + 16) * 5
```

```
## [1] 140
```

they ensure that 12 is added to 16 before the result is multiplied by 5.
If you omit the braces then you get a different answer


```r
12 + 16 * 5
```

```
## [1] 92
```

because multiplication has higher *precedence* than addition. The
second use of round braces is in a function call (e.g. `sqrt`,
`round`). To call a function in R, type the name followed by the
arguments inside round braces. Some functions take multiple arguments,
and in this case they are separated by commas.

You can see that complicated expressions in R can have several levels
of nested braces.  To keep track of these, it helps to use a
syntax-highlighting editor. For example, in RStudio, when you type an
opening bracket `(`, RStudio will automatically add a closing
bracket `)`, and when the cursor moves past a closing bracket,
RStudio will automatically highlight the corresponding opening
bracket.  Features like this can make it much easier to write R code
free from syntax errors.

Instead of printing the result to the screen, you can store it in an object, say


```r
a <- round(sqrt((12 + 16) * 5), 2)
```

In this case `R` does not print anything to the screen. You can
see the results of the calculation, stored in the object `a`,
by typing `a` and also use `a` for further calculations,
e.g:


```r
exp(a)
log(a) # natural logarithm
log10(a) # log to the base 10
```

The left arrow expression `<-`, pronounced *gets*, is called
the assignment operator, and is obtained by typing `<` followed
by `-` (with no space in between).  It is also possible to use
the equals sign `=` for assignment.

Note that object names in R are case sensitive. So you can assign
different values to objects named `A` and `a`.

## Vectors

All commands in R are *functions* which act on *objects*.  One
important kind of object is a *vector*, which is an ordered
collection of numbers, or character strings (e.g. *Charles Darwin*),
or logical values (`TRUE` or `FALSE`). The components of a
vector must be of the same type (numeric, character, or logical).  The
combine function `c()`, together with the assignment operator, is
used to create vectors. Thus


```r
v <- c(4, 6, 1, 2.2)
```

creates a vector `v` with components 4, 6, 1, 2.2 and assigns the
result to the vector `v`.

A key feature of the R language is that many operations are *vectorized*, 
meaning that you can carry out the same operation on
each element of a vector in a single operation. Try


```r
v
```

```
## [1] 4.0 6.0 1.0 2.2
```

```r
3 + v
```

```
## [1] 7.0 9.0 4.0 5.2
```

```r
3 * v
```

```
## [1] 12.0 18.0  3.0  6.6
```

and you will see that R understands what to do in each case. 

R extends ordinary arithmetic with the concept of a *missing value* 
represented by the symbol `NA` (*Not Available*). Any
operation on a missing value creates another missing value. You can
see this by repeating the same operations on a vector containing a
missing value:


```r
v <- c(4, 6, NA)
3 + v
```

```
## [1]  7  9 NA
```

```r
3 * v
```

```
## [1] 12 18 NA
```

The fact that every operation on a missing value produces a missing value
can be a nuisance when you want to create a summary statistic for a vector:


```r
mean(v)
```

```
## [1] NA
```

While it is true that the mean of `v` is unknown because the value
of the third element is missing, we normally want the mean of the
non-missing elements. Fortunately the `mean` function has an
optional argument called `na.rm` which can be used for this.


```r
mean(v, na.rm = TRUE)
```

```
## [1] 5
```

Many functions in R have optional arguments that can be omitted, in which
case they take their default value (For example, the `mean` function has
default `na.rm=FALSE`). You can explicitly values to optional arguments
in the function call to override the default behaviour.

You can get a description of the structure of any object using the
function `str()`. For example, `str(v)` shows that `v`
is numeric with 4 components. If you just want to know the length of a
vector then it is much easier to use the `length` function.


```r
length(v)
```

```
## [1] 3
```

## Sequences

There are short-cut functions for creating vectors with a regular
structure. For example, if you want a vector containing the sequence of
integers from 1 to 10, you can use


```r
1:10
```

```
##  [1]  1  2  3  4  5  6  7  8  9 10
```

The `seq()` function allows the creation of more general
sequences. For example, the vector (15, 20, 25, ... ,85) can be created
with


```r
seq(from = 15, to = 85, by = 5)
```

```
##  [1] 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85
```

The objects created by the `:` operator and the `seq()` function
are ordinary vectors, and can be combined with other vectors using the
combine function:


```r
c(5, seq(from = 20, to = 85, by = 5))
```

```
##  [1]  5 20 25 30 35 40 45 50 55 60 65 70 75 80 85
```

You can learn more about functions by typing `?` followed by the
function name. For example `?seq` gives information about the
syntax and usage of the function `seq()`.


1.  Create a vector `w` with components 1, -1, 2, -2
  
2.  Display this vector
  
  ```
  ## [1]  1 -1  2 -2
  ```
3.  Obtain a description of `w` using `str()`
  
  ```
  ##  num [1:4] 1 -1 2 -2
  ```
4.  Create the vector `w+1`, and display it.
  
  ```
  ## [1]  2  0  3 -1
  ```
5.  Create the vector `v` with components (5, 10, 15, ... , 75) using seq().
  
  ```
  ##  [1]  5 10 15 20 25 30 35 40 45 50 55 60 65 70 75
  ```
6.  Now add the components 0 and 1 to the beginning of `v` using c().
  
  ```
  ##  [1]  0  1  5 10 15 20 25 30 35 40 45 50 55 60 65 70 75
  ```
7.  Find the length of this vector.
  
  ```
  ## [1] 17
  ```


## Displaying and changing parts of a vector (indexing)

Square brackets in R are used to extract parts of vectors. So
`x[1]` gives the first element of vector `x`. Since R is
vectorized you can also supply a vector of integer index values inside
the square brackets. Any expression that creates an integer vector
will work.

Try the following commands:


```r
x <- c(2, 7, 0, 9, 10, 23, 11, 4, 7, 8, 6, 0)
x[4]
```

```
## [1] 9
```

```r
x[3:5]
```

```
## [1]  0  9 10
```

```r
x[c(1, 5, 8)]
```

```
## [1]  2 10  4
```

Trying to extract an element that is beyond the end of the vector is,
surprisingly, not an error. Instead, this returns a missing value


```r
N <- length(x)
x[N + 1]
```

```
## [1] NA
```

There is a reason for this behaviour, which we will discuss in the recap.

`R` also allows *logical subscripting*. Try the following


```r
x > 10
```

```
##  [1] FALSE FALSE FALSE FALSE FALSE  TRUE  TRUE FALSE FALSE FALSE FALSE FALSE
```

```r
x[x > 10]
```

```
## [1] 23 11
```

The first expression creates a logical vector of the same length as
`x`, where each element has the value `TRUE` or
`FALSE` depending on whether or not the corresponding element
of `x` is greater than 10. If you supply a logical vector as an
index, `R` selects only those elements for which the conditions is
`TRUE`.

You can combine two logical vectors with the operators `&`
(logical and) and `|` (logical or). For example, to select
elements of x that are between 10 and 20 we combine two one-sided logical
conditions for $x \geq 10$ *and* $x \leq 20$:


```r
x[x >= 10 & x <= 20]
```

```
## [1] 10 11
```

The remaining elements of `x` that are *either* less than 10 
*or* greater than 20 are selected with


```r
x[x < 10 | x > 20]
```

```
##  [1]  2  7  0  9 23  4  7  8  6  0
```

Indexing can also be used to replace parts of a vector:


```r
x[1] <- 1000
x
```

```
##  [1] 1000    7    0    9   10   23   11    4    7    8    6    0
```

This replaces the first element of `x`. Logical subscripting is
useful for replacing parts of a vector that satisfy a certain condition.
For example to replace all elements that take the value 0 with the value 1:


```r
x[x == 0] <- 1
x
```

```
##  [1] 1000    7    1    9   10   23   11    4    7    8    6    1
```

If you want to replace parts of a vector then you need to make sure
that the replacement value is either a single value, as in the example
above, or a vector equal in length to the number of elements to be
replaced. For example, to replace elements 2, 3, and 4 we need to
supply a vector of replacement values of length 3.


```r
x[2:4] <- c(0, 8, 1)
x
```

```
##  [1] 1000    0    8    1   10   23   11    4    7    8    6    1
```

It is important to remember this when you are using logical
subscripting because the number of elements to be replaced is not
given explicitly in the R code, and it is easy to get confused about
how many values need to be replaced.  If we want to add 3 to every
element that is less than 3 then we can break the operation down into
3 steps:


```r
y <- x[x < 3]
y <- y + 3
x[x < 3] <- y
x
```

```
##  [1] 1000    3    8    4   10   23   11    4    7    8    6    4
```

First we extract the values to be modified, then we modify them, then we
write back the modified values to the original positions. R experts will
normally do this in a single expression.


```r
x[x < 3] <- x[x < 3] + 3
```

Remember, if you are confused by a complicated expression you can usually
break it down into simpler steps.

If you want to create an entirely new vector based on some logical
condition then use the `ifelse()` function. This function takes
three arguments: the first is a logical vector; the second is the
value taken by elements of the logical vector that are `TRUE`; and
the third is the value taken by elements that are `FALSE`.

In this example, we use the remainder operator `%%` to identify
elements of `x` that have value 0 when divided by 2 (i.e. the even numbers)
and then create a new character vector with the labels *even* and *odd*:


```r
x %% 2
```

```
##  [1] 0 1 0 0 0 1 1 0 1 0 0 0
```

```r
ifelse(x %% 2 == 0, "even", "odd")
```

```
##  [1] "even" "odd"  "even" "even" "even" "odd"  "odd"  "even" "odd"  "even"
## [11] "even" "even"
```


Now try the following:

1.  Display elements that are less than 10, but greater than 4
2.  Modify the vector x, replacing by 10 all values that are greater than 10
3.  Modify the vector x, multiplying by 2 all elements that are smaller than 5 (Remember you can do this in steps).


## Lists

Collections of components of different types are called *lists*,
and are created with the `list()` function. Thus


```r
m <- list(4, TRUE, "name of company")
m
```

```
## [[1]]
## [1] 4
## 
## [[2]]
## [1] TRUE
## 
## [[3]]
## [1] "name of company"
```

creates a list with 3 components: the first is numeric, the second
is logical and the third is character. A list element can be any
object, including another list. This flexibility means that functions
that need to return a lot of complex information, such as statistical
modelling functions, often return a list.

As with vectors, single square brackets are used to take a subset of a
list, but the result will always be another list, even if you select
only one element


```r
m[1:2] # A list containing first two elements of m
```

```
## [[1]]
## [1] 4
## 
## [[2]]
## [1] TRUE
```

```r
m[3] # A list containing the third element of m
```

```
## [[1]]
## [1] "name of company"
```

If you just want to extract a single element of a list then you must use
double square braces:


```r
m[[3]] # Extract third element
```

```
## [1] "name of company"
```

Lists are more useful when their elements are named. You can name an element
by using the syntax `name=value` in the call to the `list` function:


```r
mylist <- list(
  name = c("Joe", "Ann", "Jack", "Tom"),
  age = c(34, 50, 27, 42)
)
mylist
```

```
## $name
## [1] "Joe"  "Ann"  "Jack" "Tom" 
## 
## $age
## [1] 34 50 27 42
```

This creates a new list with the elements *name*, a character
vector of names, and *age* a numeric vector of ages. The components
of the list can be extracted with a dollar sign `$`


```r
mylist$name
```

```
## [1] "Joe"  "Ann"  "Jack" "Tom"
```

```r
mylist$age
```

```
## [1] 34 50 27 42
```

## Data frames

Data frames are a special structure used when we want to store several vectors of the
same length, and corresponding elements of each vector refer to the same record.
For example, here we create a simple data frame containing the names of some individuals
along with their age in years, their sex (coded 1 or 2) and their height in cm.


```r
mydata <- data.frame(
  name = c("Joe", "Ann", "Jack", "Tom"),
  age = c(34, 50, 27, 42), 
  sex = c(1, 2, 1, 1),
  height = c(185, 170, 175, 182)
)
```

The construction of a data frame is just like a named list (except
that we use the constructor function `data.frame` instead of `list`). In fact data frames are also lists so, for example, you can
extract vectors using the dollar sign:


```r
mydata$height
```

```
## [1] 185 170 175 182
```

On the other hand, data frames are also two dimensional objects:


```r
mydata
```

```
##   name age sex height
## 1  Joe  34   1    185
## 2  Ann  50   2    170
## 3 Jack  27   1    175
## 4  Tom  42   1    182
```

When you print a data frame, each variable appears in a separate
column.  You can use square brackets with two comma-separated
arguments to take subsets of rows or columns.


```r
mydata[1, ]
```

```
##   name age sex height
## 1  Joe  34   1    185
```

```r
mydata[, c("age", "height")]
```

```
##   age height
## 1  34    185
## 2  50    170
## 3  27    175
## 4  42    182
```

```r
mydata[2, 4]
```

```
## [1] 170
```

We will look into indexing of data frames in more detail below.

Now let's create another data frame with more individuals than the
first one:


```r
yourdata <- data.frame(
  name = c("Ann", "Peter", "Sue", "Jack", "Tom", "Joe", "Jane"),
  weight = c(67, 81, 56, 90, 72, 79, 69)
)
```

This new data frame contains the weights of the individuals. The two
data sets can be joined together with the `merge` function.


```r
newdata <- merge(mydata, yourdata)
newdata
```

```
##   name age sex height weight
## 1  Ann  50   2    170     67
## 2 Jack  27   1    175     90
## 3  Joe  34   1    185     79
## 4  Tom  42   1    182     72
```

The `merge` function uses the variables common to both data
frames -- in this case the variable *name* -- to uniquely identify
each row.  By default, only rows that are in both data frames are
preserved, the rest are discarded.  In the above example, the records
for Peter, Sue, and Jane, which are not in `mydata` are
discarded. If you want to keep them, use the optional argument `all=TRUE`.
  

```r
newdata <- merge(mydata, yourdata, all = TRUE)
newdata
```

```
##    name age sex height weight
## 1   Ann  50   2    170     67
## 2  Jack  27   1    175     90
## 3  Jane  NA  NA     NA     69
## 4   Joe  34   1    185     79
## 5 Peter  NA  NA     NA     81
## 6   Sue  NA  NA     NA     56
## 7   Tom  42   1    182     72
```

This keeps a row for all individuals but since Peter, Sue and Jane
have no recorded age, height, or sex these are missing values.

## Working with built-in data frames

We shall use the births data which concern 500 mothers who had
singleton births (i.e. no twins) in a large London hospital. The
outcome of interest is the birth weight of the baby, also dichotomised
as normal or low birth weight. These data are available in the [Epi](https://cran.r-project.org/web/packages/Epi/index.html)
package:


```r
library(Epi)
data(births)
objects()
```

```
##  [1] "births"   "m"        "mydata"   "mylist"   "N"        "newdata" 
##  [7] "v"        "w"        "x"        "y"        "yourdata"
```

The function `objects()` shows what is in your workspace. To
find out a bit more about `births` try

```r
help(births)
```



The dataframe `"diet"` in the Epi package contains data from a follow-up study with
coronary heart disease as the end-point.  


1. Load these data with
  
  ```r
  data(diet)
  ```
  and print the contents of the data frame to the screen..
2. Check that you now have two objects, `births`, and `diet` in your workspace.
3. Get help on the object `diet`.
4. Remove the object `diet` with the command

  
  ```r
  remove(diet)
  ```

5. Check that the object `diet` is no longer in your workspace.


## Referencing parts of the data frame (indexing)

Typing `births` will list the entire data frame -- not usually
very helpful. You can use the `head` function to see just the
first few rows of a data frame


```r
head(births)
```

```
##   id bweight lowbw gestwks preterm matage hyp sex
## 1  1    2974     0   38.52       0     34   0   2
## 2  2    3270     0      NA      NA     30   0   1
## 3  3    2620     0   38.15       0     35   0   2
## 4  4    3751     0   39.80       0     31   0   1
## 5  5    3200     0   38.89       0     33   1   1
## 6  6    3673     0   40.97       0     33   0   2
```

Now try


```r
births[1, ]
```

```
##   id bweight lowbw gestwks preterm matage hyp sex
## 1  1    2974     0   38.52       0     34   0   2
```

This will list all the values for the first row. Similarly,

```r
births[2, ]
```

```
##   id bweight lowbw gestwks preterm matage hyp sex
## 2  2    3270     0      NA      NA     30   0   1
```
will list the value taken by the second row, and so on.
To list the data for the first 10 subjects, try


```r
births[1:10, ]
```

```
##    id bweight lowbw gestwks preterm matage hyp sex
## 1   1    2974     0   38.52       0     34   0   2
## 2   2    3270     0      NA      NA     30   0   1
## 3   3    2620     0   38.15       0     35   0   2
## 4   4    3751     0   39.80       0     31   0   1
## 5   5    3200     0   38.89       0     33   1   1
## 6   6    3673     0   40.97       0     33   0   2
## 7   7    3628     0   42.14       0     29   0   2
## 8   8    3773     0   40.21       0     37   0   1
## 9   9    3960     0   42.03       0     36   0   2
## 10 10    3405     0   39.33       0     39   0   1
```

Often we want to extract rows of a data frame based on a condition.
To select all subjects with height less than 180 cm from the
data frame `mydata` we can use the `subset()` function.


```r
subset(mydata, height < 180)
```

```
##   name age sex height
## 2  Ann  50   2    170
## 3 Jack  27   1    175
```

## Summaries

A good way to start an analysis is to ask for a
summary of the data by typing


```r
summary(births)
```

```
##        id           bweight         lowbw         gestwks         preterm      
##  Min.   :  1.0   Min.   : 628   Min.   :0.00   Min.   :24.69   Min.   :0.0000  
##  1st Qu.:125.8   1st Qu.:2862   1st Qu.:0.00   1st Qu.:37.94   1st Qu.:0.0000  
##  Median :250.5   Median :3188   Median :0.00   Median :39.12   Median :0.0000  
##  Mean   :250.5   Mean   :3137   Mean   :0.12   Mean   :38.72   Mean   :0.1286  
##  3rd Qu.:375.2   3rd Qu.:3551   3rd Qu.:0.00   3rd Qu.:40.09   3rd Qu.:0.0000  
##  Max.   :500.0   Max.   :4553   Max.   :1.00   Max.   :43.16   Max.   :1.0000  
##                                                NA's   :10      NA's   :10      
##      matage           hyp             sex       
##  Min.   :23.00   Min.   :0.000   Min.   :1.000  
##  1st Qu.:31.00   1st Qu.:0.000   1st Qu.:1.000  
##  Median :34.00   Median :0.000   Median :1.000  
##  Mean   :34.03   Mean   :0.144   Mean   :1.472  
##  3rd Qu.:37.00   3rd Qu.:0.000   3rd Qu.:2.000  
##  Max.   :43.00   Max.   :1.000   Max.   :2.000  
## 
```

This prints some summary statistics (minimum, lower quartile, mean, median,
upper quartile, maximum). For variables with missing values, the number
of `NA`s is also printed.

To see the names of the variables in the data frame try


```r
names(births)
```

```
## [1] "id"      "bweight" "lowbw"   "gestwks" "preterm" "matage"  "hyp"    
## [8] "sex"
```

Variables in a data frame can be referred to by name, but to do so
it is necessary also to specify the name of the data frame.  Thus
`births$hyp` refers to the variable `hyp` in the `births`
data frame, and typing `births$hyp` will print the data on this
variable.  To summarize the variable `hyp` try


```r
summary(births$hyp)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   0.000   0.000   0.144   0.000   1.000
```

Alternatively you can use


```r
with(births, summary(hyp))
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   0.000   0.000   0.000   0.144   0.000   1.000
```

## Generating new variables

New variables can be produced using assignment together with the usual
mathematical operations and functions. For example


```r
logbw <- log(births$bweight)
```

produces the variable `logbw` in your workspace,  while


```r
births$logbw <- log(births$bweight)
```

produces the variable `logbw` in the `births` data frame.

You can also replace existing variables. For example `bweight` measures
birth weight in grams. To convert the units to kilograms we replace the
original variable with a new one:


```r
births$bweight <- births$bweight / 1000
```

## Turning a variable into a factor

In R categorical variables are known as *factors*, and the
different categories are called the *levels* of the factor.
Variables such as `hyp` and `sex` are originally coded using
integer codes, and by default R will interpret these codes as numeric
values taken by the variables. Factors will become very important
later in the course when we study modelling functions, where
factors and numeric variables are treated very differently. For the moment,
you can think of factors as *value labels* that are more informative
than numeric codes.

For R to recognize that the codes refer to categories it is necessary
to convert the variables to be factors, and to label the levels. To
convert the variable `hyp` to be a factor, try


```r
births$hyp <- factor(births$hyp, labels = c("normal", "hyper"))
```

This takes the original numeric codes (0, 1) and replaces them with 
informative labels *normal'' and ``hyper* for normal blood pressure
and hypertension, respectively. 


1.  Convert the variable `sex` into a factor
with labels `"M"` and `"F"` for values 1 and 2, respectively
  


## Frequency tables
When starting to look at any new data frame the first step is to check
that the values of the variables make sense and correspond to the
codes defined in the coding schedule. For categorical variables
(factors) this can be done by looking at one-way frequency tables and
checking that only the specified codes (levels) occur.  The most
useful function for making simple frequency tables is `table`.
The distribution of the factor `hyp` can be viewed using


```r
with(births, table(hyp))
```

```
## hyp
## normal  hyper 
##    428     72
```

or by specifying the data frame as in


```r
table(births$hyp)
```

```
## 
## normal  hyper 
##    428     72
```
For simple expressions the choice is a matter of taste, but `with`
is shorter for more complicated expressions.


1. Find the frequency distribution of `sex`.
  
  ```
  ## 
  ##   M   F 
  ## 264 236
  ```
  
  ```
  ## sex
  ##   M   F 
  ## 264 236
  ```

2.  If you give two or more arguments to the `table` function
  then it produces cross-tabulations.  Find the two-way frequency
  distribution of `sex` and `hyp`.
  
  ```
  ##    hyp
  ## sex normal hyper
  ##   M    221    43
  ##   F    207    29
  ```

3.  Create a logical variable called `early` according to whether `gestwks` 
  is less than 30 or not. Make a frequency table of `early`.
  
  ```
  ## early
  ## FALSE  TRUE 
  ##   485     5
  ```


## Grouping the values of a numeric variable

For a numeric variable like `matage` it is often useful
to  group the values and to create a new factor which codes the groups.
For example we might cut the values taken by `matage` into  the
groups 20--29, 30--34, 35--39, 40--44, and then create a factor called
`agegrp` with 4 levels corresponding to the four groups. The best way of doing this is
with the function `cut`. Try


```r
births$agegrp <- 
  cut(
    births$matage, 
    breaks = c(20, 30, 35, 40, 45), 
    right = FALSE
  )
with(births, table(agegrp))
```

```
## agegrp
## [20,30) [30,35) [35,40) [40,45) 
##      70     200     194      36
```
By default the factor levels are labelled `[20-25)`,
`[25-30)`, etc., where `[20-25)` refers to the interval
which includes the left hand end (20) but not the right hand end
(25). This is the reason for `right=FALSE`. When `right=TRUE`
(which is the default) the intervals include the right hand end but
not the left hand.

Observations which are not inside the range specified by the `breaks`
argument result in missing values for the new factor. Hence it
is important that the first element in `breaks` is smaller than the
smallest value in your data, and the last element is larger than the
largest value.


1. Summarize the numeric variable `gestwks`, which records the
  length of gestation for the baby, and make a note of the range of
  values.
  
  ```
  ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  ##   24.69   37.94   39.12   38.72   40.09   43.16      10
  ```

2. Create a new factor `gest4` which cuts `gestwks` at 20,
  35, 37, 39, and  45 weeks, including the left hand end, but not the
  right hand. Make a table of the frequencies for the four levels of `gest4`.



