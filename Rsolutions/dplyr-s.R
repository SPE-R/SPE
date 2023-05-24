### R code from vignette source '/home/runner/work/SPE/SPE/build/dplyr-s.rnw'

###################################################
### code chunk number 1: dplyr-s.rnw:30-33
###################################################
library(Epi)
suppressPackageStartupMessages(library(dplyr))
data(births) 


###################################################
### code chunk number 2: dplyr-s.rnw:42-44
###################################################
class(births)
head(births)


###################################################
### code chunk number 3: dplyr-s.rnw:48-49
###################################################
str(births)


###################################################
### code chunk number 4: dplyr-s.rnw:54-61
###################################################
births_tbl <- as_tibble(births)

class(births_tbl)
births_tbl

## another way to visualize data set is to use glimpse function
glimpse(births_tbl)


###################################################
### code chunk number 5: dplyr-s.rnw:77-79
###################################################
head(births, 4)
births %>% head(4)


###################################################
### code chunk number 6: dplyr-s.rnw:85-86
###################################################
4 %>% head(births, .)


###################################################
### code chunk number 7: dplyr-s.rnw:104-125
###################################################
births_tbl <-
  births_tbl %>%
  mutate(
    ## modify hyp varible (conversion into factor)
    hyp = factor(hyp, levels = c(0, 1), labels = c("normal", "hyper")),
    ## creating a new variable aggrep
    agegrp = cut(matage, breaks = c(20, 25, 30, 35, 40, 45), right = FALSE),
    ## modify sex variable (conversion into factor)
    sex = factor(sex, levels = c(1, 2), labels = c("M", "F")),
    ## creating a new variable gest4 with case_when instead of cut
    gest4 = 
      case_when(
        gestwks < 25 ~ 'less than 25 weeks',
        gestwks >= 25 & gestwks < 30  ~ '25-30 weeks',
        gestwks >= 30 & gestwks < 35  ~ '30-35 weeks',
        gestwks >= 35 & gestwks < 40  ~ '35-40 weeks',
        gestwks >= 40  ~ 'more than 40 weeks'
      ) 
  )

births_tbl


###################################################
### code chunk number 8: dplyr-s.rnw:145-150
###################################################
births_tbl %>%
  ## select only id, women age group, sex and birth weight of the baby
  select(id, agegrp, sex, bweight) %>%
  ## keep only babies weighing more than 4000g
  filter(bweight > 4000) 


###################################################
### code chunk number 9: dplyr-s.rnw:158-168
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
  arrange(desc(`Birth weight`))


###################################################
### code chunk number 10: dplyr-s.rnw:175-185
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
  arrange(Sex, desc(`Birth weight`))


###################################################
### code chunk number 11: dplyr-s.rnw:196-205
###################################################
births.01 <-
  births_tbl %>%
  ## group the data according to the sex attribute
  group_by(sex) %>%
  ## count the number of rows/individuals in each group
  summarise(
    count = n()
  )
births.01


###################################################
### code chunk number 12: dplyr-s.rnw:211-216
###################################################
births.02 <-
  births.01 %>%
  mutate(
    percent = count / sum(count) * 100
  )


###################################################
### code chunk number 13: dplyr-s.rnw:223-235
###################################################
births.03 <-
  births_tbl %>%
  select(gest4, sex, gestwks, bweight, matage) %>%
  group_by(gest4, sex) %>%
  summarise(
    across(
      where(is.numeric),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = 'drop'
  )
births.03


###################################################
### code chunk number 14: dplyr-s.rnw:245-247
###################################################
births.03 %>%
  rename_with(toupper, where(~ !is.numeric(.x)))


###################################################
### code chunk number 15: dplyr-s.rnw:252-260
###################################################
births.05 <-
  births_tbl %>%
  group_by(sex) %>%
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )
births.05


###################################################
### code chunk number 16: dplyr-s.rnw:266-278
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
### code chunk number 17: dplyr-s.rnw:288-295
###################################################
births.06 <-
  births_tbl %>%
  group_by(sex, lowbw) %>%
  summarise(
    count = n()
  )
births.06


###################################################
### code chunk number 18: dplyr-s.rnw:300-310
###################################################
births.06 %>%
  mutate(
    percent = count / sum(count) * 100
  )

births.06 %>%
  ungroup() %>%
  mutate(
    percent = count / sum(count) * 100
  )


###################################################
### code chunk number 19: dplyr-s.rnw:321-337
###################################################
## this tibble will still be grouped by sex
births_tbl %>%
  group_by(sex, lowbw) %>%
  summarise(
    count = n()
  )

## this tibble will be group free
births_tbl %>%
  group_by(sex, lowbw) %>%
  summarise(
    count = n(),
    .groups = 'drop'
  )




###################################################
### code chunk number 20: dplyr-s.rnw:344-350
###################################################
births_tbl %>%
  group_by(gest4) %>%
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )


###################################################
### code chunk number 21: dplyr-s.rnw:357-372
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
  )


###################################################
### code chunk number 22: dplyr-s.rnw:376-389
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
  )


###################################################
### code chunk number 23: dplyr-s.rnw:405-419
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
### code chunk number 24: dplyr-s.rnw:425-426
###################################################
bind_rows(age, center)


###################################################
### code chunk number 25: dplyr-s.rnw:436-442
###################################################
## all individuals from ages are kept
left_join(age, center)
## everithing is kept
full_join(age, center)
## only the individuals present in both dataset are kept
inner_join(age, center)


###################################################
### code chunk number 26: dplyr-s.rnw:447-452
###################################################
inner_join(age, center) %>%
  group_by(center) %>%
  summarise(
    mean_age = mean(age)
  )


###################################################
### code chunk number 27: dplyr-s.rnw:462-493
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
### code chunk number 28: dplyr-s.rnw:496-502 (eval = FALSE)
###################################################
## ## trick to create dplyr-s.rnw file.
## ## this part have to be lauch manually
## dplyr_e.path <- '~/OneDrive - IARC/PROJECT/_SPE/SPE/pracs/dplyr-e.rnw'
## dplyr_e <- readLines(dplyr_e.path)
## dplyr_s <- purrr::map_chr(dplyr_e, ~ sub('results=verbatim', 'results=verbatim', .x))
## writeLines(dplyr_s, sub('-e.rnw$', '-s.rnw', dplyr_e.path))


