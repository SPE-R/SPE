### R code from vignette source '/home/runner/work/SPE/SPE/build/dplyr-s.rnw'

###################################################
### code chunk number 1: dplyr-s.rnw:23-27
###################################################
library(Epi)
suppressPackageStartupMessages(library(dplyr))

data(births) 


###################################################
### code chunk number 2: dplyr-s.rnw:36-38
###################################################
class(births)
head(births)


###################################################
### code chunk number 3: dplyr-s.rnw:42-43
###################################################
str(births)


###################################################
### code chunk number 4: dplyr-s.rnw:48-55
###################################################
births_tbl <- as_tibble(births)

class(births_tbl)
head(births_tbl)

## another alternative is to use the glimpse function
glimpse(births_tbl)


###################################################
### code chunk number 5: dplyr-s.rnw:70-72
###################################################
head(births, 4)
births %>% head(4)


###################################################
### code chunk number 6: dplyr-s.rnw:79-88
###################################################
## classical way
grepl('r', 'spe-r')

## wrong chained way
## here the test done is: does 'r' contain 'spe-r'? 
'spe-r' %>% grepl('r')

## we have to specify explicitly that the chained object is the second argument
'spe-r' %>% grepl('r', .)


###################################################
### code chunk number 7: dplyr-s.rnw:106-120
###################################################
births_tbl <-
  births_tbl %>%
  mutate(
    ## modify hyp varible (conversion into factor)
    hyp = factor(hyp, labels = c("normal", "hyper")),
    ## creating a new variable aggrep
    agegrp = cut(matage, breaks = c(20, 25, 30, 35, 40, 45), right = FALSE),
    ## modify sex variable (conversion into factor)
    sex = factor(sex, levels = c(1, 2), labels = c("M", "F")),
    ## creating a new variable gest4
    gest4 = cut(gestwks, breaks = c(20, 35, 37, 39, 45), right = FALSE)
  )

head(births_tbl)


###################################################
### code chunk number 8: dplyr-s.rnw:130-136
###################################################
births_tbl %>%
  ## select only id, women age group, sex and birth weight of the baby
  select(id, agegrp, sex, bweight) %>%
  ## keep only babies weighing more than 4000g
  filter(bweight > 4000) %>%
  head()


###################################################
### code chunk number 9: dplyr-s.rnw:144-155
###################################################
births_tbl %>%
  ## select only id, women age group, sex and birth weight of the baby
  select(
    id, 
    'Age group' = agegrp, 
    Sex = sex, 
    'Birth weight' = bweight
  ) %>%
  ## rearrange rows to put the heaviest newborn on top
  arrange(desc(`Birth weight`)) %>%
  head()


###################################################
### code chunk number 10: dplyr-s.rnw:162-173
###################################################
births_tbl %>%
  ## select only id, women age group, sex and birth weight of the baby
  select(
    id, 
    'Age group' = agegrp, 
    Sex = sex, 
    'Birth weight' = bweight
  ) %>%
  ## rearrange rows to put the heaviest newborn on top
  arrange(Sex, desc(`Birth weight`)) %>%
  head()


###################################################
### code chunk number 11: dplyr-s.rnw:184-194
###################################################
births.01 <-
  births_tbl %>%
  ## group the data according to the sex attribute
  group_by(sex) %>%
  ## count the number of rows/individuals in each group
  summarise(
    count = n()
  )
births.01 %>%
  head()


###################################################
### code chunk number 12: dplyr-s.rnw:200-205
###################################################
births.02 <-
  births.01 %>%
  mutate(
    percent = count / sum(count) * 100
  )


###################################################
### code chunk number 13: dplyr-s.rnw:212-219
###################################################
births.03 <-
  births.02 %>%
  summarise_if(
    is.numeric,
    sum
  )
births.03


###################################################
### code chunk number 14: dplyr-s.rnw:223-228
###################################################
births.03 %>%
  rename_all(
    ~ paste0(., '.tot')
  ) %>%
  head()


###################################################
### code chunk number 15: dplyr-s.rnw:232-241
###################################################
births.05 <-
  births_tbl %>%
  group_by(sex) %>%
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )
births.05 %>%
  head()


###################################################
### code chunk number 16: dplyr-s.rnw:247-259
###################################################
births.05 %>%
  summarise(
    count.tot = sum(count),
    bweight.mean.tot = weighted.mean(bweight.mean, count)
  )

# this is equivalent to
births_tbl %>%
  summarise(
    count.tot = n(),
    bweight.mean.tot = mean(bweight)
  )


###################################################
### code chunk number 17: dplyr-s.rnw:269-277
###################################################
births.06 <-
  births_tbl %>%
  group_by(sex, lowbw) %>%
  summarise(
    count = n()
  )
births.06 %>%
  head()


###################################################
### code chunk number 18: dplyr-s.rnw:282-293
###################################################
births.06 %>%
  mutate(
    percent = count / sum(count) * 100
  )

births.06 %>%
  ungroup() %>%
  mutate(
    percent = count / sum(count) * 100
  ) %>%
  head()


###################################################
### code chunk number 19: dplyr-s.rnw:303-310
###################################################
births_tbl %>%
  group_by(gest4) %>%
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  ) %>%
  head()


###################################################
### code chunk number 20: dplyr-s.rnw:317-333
###################################################
births_tbl %>%
  ## keep only the newborn with defined gesational time category
  filter(
    !is.na(gest4)
  ) %>%
  group_by(lowbw, gest4) %>%
  ## compute the number of babies in each cross category
  summarise(
    count = n()
  ) %>%
  ## compute the percentage of babies in each gestational time category per 
  ## birth weight category
  mutate(
    percent = count / sum(count, na.rm = TRUE)
  ) %>%
  head()


###################################################
### code chunk number 21: dplyr-s.rnw:337-351
###################################################
births_tbl %>%
  filter(
    !is.na(gest4)
  ) %>%
  group_by(gest4, lowbw) %>%
  summarise(
    count = n()
  ) %>%
  ## compute the percentage of babies in each birth weight category per gestational 
  ## time category
  mutate(
    percent = count / sum(count, na.rm = TRUE)
  ) %>%
  head()


###################################################
### code chunk number 22: dplyr-s.rnw:367-381
###################################################
age <-
  tibble(
    pid = 1:6,
    age = sample(15:25, size = 6, replace = TRUE)
  )

center <-
  tibble(
    pid = c(1, 2, 3, 4, 10),
    center = c('A', 'B', 'A', 'B', 'C')
  )

age
center


###################################################
### code chunk number 23: dplyr-s.rnw:387-388
###################################################
bind_rows(age, center)


###################################################
### code chunk number 24: dplyr-s.rnw:398-404
###################################################
## all individuals from ages are kept
left_join(age, center)
## everithing is kept
full_join(age, center)
## only the individuals present in both dataset are kept
inner_join(age, center)


###################################################
### code chunk number 25: dplyr-s.rnw:409-414
###################################################
inner_join(age, center) %>%
  group_by(center) %>%
  summarise(
    mean_age = mean(age)
  )


###################################################
### code chunk number 26: dplyr-s.rnw:424-455
###################################################
# if(!require(kableExtra)) install.packages('kableExtra')
# library(kableExtra)
# 
# births.08 <-
#   births_tbl %>%
#   filter(
#     !is.na(gest4)
#   ) %>%
#   group_by(gest4) %>%
#   summarise(
#     N = n()
#   ) %>%
#   mutate(
#     `(%)` = (N / sum(N)) %>% scales::percent()
#   )
# 
# ## default
# births.08
# 
# ## markdown flavour (useful fo automatic repport production with knitr)
# births.08 %>%
#   knitr::kable(fromat = 'markdown')
# 
# ## create an html version of the table and save it on the hard drive
# births.08 %>%
#   kable() %>%
#   kable_styling(
#     bootstrap_options = c("striped", "hover", "condensed", "responsive"),
#     full_width = FALSE
#   ) %>%
#   save_kable(file = 'births.08.html', self_contained = TRUE)


###################################################
### code chunk number 27: dplyr-s.rnw:458-464 (eval = FALSE)
###################################################
## ## trick to create dplyr-s.rnw file.
## ## this part have to be lauch manually
## dplyr_e.path <- '/mnt/data/georgesd/_PROJECTS/_SPE/SPE/pracs/dplyr-e.rnw'
## dplyr_e <- readLines(dplyr_e.path)
## dplyr_s <- purrr::map_chr(dplyr_e, ~ sub('results=verbatim', 'results=verbatim', .x))
## writeLines(dplyr_s, sub('-e.rnw$', '-s.rnw', dplyr_e.path))


