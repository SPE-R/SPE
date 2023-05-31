### R code from vignette source '/home/runner/work/SPE/SPE/build/tidyverse-s.rnw'

###################################################
### code chunk number 1: tidyverse-s.rnw:30-33
###################################################
library(Epi)
suppressPackageStartupMessages(library(tidyverse))
data(births) 


###################################################
### code chunk number 2: tidyverse-s.rnw:42-44
###################################################
class(births)
head(births)


###################################################
### code chunk number 3: tidyverse-s.rnw:48-49
###################################################
str(births)


###################################################
### code chunk number 4: tidyverse-s.rnw:54-61
###################################################
births_tbl <- as_tibble(births)

class(births_tbl)
births_tbl

## another way to visualize data set is to use glimpse function
glimpse(births_tbl)


###################################################
### code chunk number 5: tidyverse-s.rnw:77-79
###################################################
head(births, 4)
births %>% head(4)


###################################################
### code chunk number 6: tidyverse-s.rnw:85-86
###################################################
4 %>% head(births, .)


###################################################
### code chunk number 7: tidyverse-s.rnw:104-125
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
### code chunk number 8: tidyverse-s.rnw:145-150
###################################################
births_tbl %>%
  ## select only id, women age group, sex and birth weight of the baby
  select(id, agegrp, sex, bweight) %>%
  ## keep only babies weighing more than 4000g
  filter(bweight > 4000) 


###################################################
### code chunk number 9: tidyverse-s.rnw:158-168
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
### code chunk number 10: tidyverse-s.rnw:175-185
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
### code chunk number 11: tidyverse-s.rnw:196-205
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
### code chunk number 12: tidyverse-s.rnw:211-216
###################################################
births.02 <-
  births.01 %>%
  mutate(
    percent = count / sum(count) * 100
  )


###################################################
### code chunk number 13: tidyverse-s.rnw:223-235
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
### code chunk number 14: tidyverse-s.rnw:245-247
###################################################
births.03 %>%
  rename_with(toupper, where(~ !is.numeric(.x)))


###################################################
### code chunk number 15: tidyverse-s.rnw:252-260
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
### code chunk number 16: tidyverse-s.rnw:266-278
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
### code chunk number 17: tidyverse-s.rnw:288-295
###################################################
births.06 <-
  births_tbl %>%
  group_by(sex, lowbw) %>%
  summarise(
    count = n()
  )
births.06


###################################################
### code chunk number 18: tidyverse-s.rnw:300-310
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
### code chunk number 19: tidyverse-s.rnw:321-337
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
### code chunk number 20: tidyverse-s.rnw:344-350
###################################################
births_tbl %>%
  group_by(gest4) %>%
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )


###################################################
### code chunk number 21: tidyverse-s.rnw:357-372
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
### code chunk number 22: tidyverse-s.rnw:376-389
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
### code chunk number 23: tidyverse-s.rnw:405-419
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
### code chunk number 24: tidyverse-s.rnw:425-426
###################################################
bind_rows(age, center)


###################################################
### code chunk number 25: tidyverse-s.rnw:436-442
###################################################
## all individuals from ages are kept
left_join(age, center, by = c('pid'))
## everithing is kept
full_join(age, center, by = c('pid'))
## only the individuals present in both dataset are kept
inner_join(age, center, by = c('pid'))


###################################################
### code chunk number 26: tidyverse-s.rnw:447-452
###################################################
inner_join(age, center, by = c('pid')) %>%
  group_by(center) %>%
  summarise(
    mean_age = mean(age)
  )


###################################################
### code chunk number 27: tidyverse-s.rnw:471-472
###################################################
birth_per_ageg <- births_tbl %>% group_by(agegrp) %>% summarise(total_births = n())


###################################################
### code chunk number 28: tidyverse-s.rnw:475-478
###################################################
(gg.01 <- 
   ggplot(birth_per_ageg, aes(x = agegrp, y = total_births)) + 
   geom_bar(stat = "identity"))


###################################################
### code chunk number 29: tidyverse-s.rnw:482-487
###################################################
(gg.02 <- 
   gg.01 +  
   xlab("Women Age Group") + 
   ylab("Total Births") + 
   ggtitle("Number of Births per Women Age Group"))


###################################################
### code chunk number 30: tidyverse-s.rnw:500-508
###################################################
birth_per_ageg

birth_per_ageg_wide <- 
  birth_per_ageg %>%
  pivot_wider(names_from = 'agegrp', values_from = 'total_births')

birth_per_ageg_wide



###################################################
### code chunk number 31: tidyverse-s.rnw:513-518
###################################################
birth_per_ageg_long <- 
  birth_per_ageg_wide %>%
  pivot_longer(cols = 1:5, names_to = 'agegrp', values_to = 'total_births')

birth_per_ageg_long


###################################################
### code chunk number 32: tidyverse-s.rnw:523-524
###################################################
identical(birth_per_ageg, birth_per_ageg_long)


###################################################
### code chunk number 33: tidyverse-s.rnw:530-535
###################################################
birth_per_ageg_long_02 <-
  birth_per_ageg_long %>%
  mutate(agegrp = as.factor(agegrp))

identical(birth_per_ageg, birth_per_ageg_long_02)


###################################################
### code chunk number 34: tidyverse-s.rnw:547-560
###################################################
## read a csv using core R
fem.csv.core <- read.csv('data/fem.csv')
## read a csv using tidyverse
fem.csv.tidy <- read_csv('data/fem.csv')
## compare
fem.csv.core
fem.csv.tidy
## table dimensions
dim(fem.csv.core)
dim(fem.csv.tidy)
## compare column types
map(fem.csv.core, class)
map(fem.csv.tidy, class)


###################################################
### code chunk number 35: tidyverse-s.rnw:569-583
###################################################
## read a csv using core R
occoh.txt.core <- read.table('data/occoh.txt')
## read a csv using tidyverse
occoh.txt.tidy <- read_table('data/occoh.txt')
occoh.txt.tidy <- read_table('data/occoh.txt')
## compare
occoh.txt.core
occoh.txt.tidy
## table dimensions
dim(occoh.txt.core)
dim(occoh.txt.tidy)
## compare column types
map(occoh.txt.core, class)
map(occoh.txt.tidy, class)


###################################################
### code chunk number 36: tidyverse-s.rnw:598-599
###################################################
countries <- c("Estonia", "Finland", "Denmark", "United Kingdom")


###################################################
### code chunk number 37: tidyverse-s.rnw:603-604
###################################################
country_initials <- str_sub(countries, start = 1, end = 3)


###################################################
### code chunk number 38: tidyverse-s.rnw:608-609
###################################################
countries_upper <- str_to_upper(countries)


###################################################
### code chunk number 39: tidyverse-s.rnw:613-614
###################################################
countries_modified <- str_replace(countries, "United", "Utd")


###################################################
### code chunk number 40: tidyverse-s.rnw:618-619
###################################################
a_positions <- str_locate_all(countries, "n")


###################################################
### code chunk number 41: tidyverse-s.rnw:629-630
###################################################
character_counts <- str_length(countries)


###################################################
### code chunk number 42: tidyverse-s.rnw:646-653
###################################################
grades <- 
  list(
    c1 = c(80, 85, 90), 
    c2 = c(75, 70, 85, 88), 
    c3 = c(90, 85, 95)
  )
mean_grades <- map(grades, mean)


###################################################
### code chunk number 43: tidyverse-s.rnw:660-664
###################################################
map(grades, mean)
map_dbl(grades, mean)
map_chr(grades, mean)
map_df(grades, mean)


###################################################
### code chunk number 44: tidyverse-s.rnw:677-679
###################################################
1:10 %>% reduce(`*`)
1:10 %>% accumulate(`*`)


###################################################
### code chunk number 45: tidyverse-s.rnw:688-719
###################################################
# if(!require(kableExtra)) install.packages('kableExtra')
library(kableExtra)

births.08 <-
  births_tbl %>%
  filter(
    !is.na(gest4)
  ) %>%
  group_by(gest4) %>%
  summarise(
    N = n()
  ) %>%
  mutate(
    `(%)` = (N / sum(N)) %>% scales::percent()
  )

## default
births.08

## markdown flavor (useful fo automatic report production with knitr)
# births.08 %>%
#   knitr::kable(fromat = 'markdown')

## create an html version of the table and save it on the hard drive
births.08 %>%
  kable() %>%
  kable_styling(
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = FALSE
  ) %>%
  save_kable(file = 'births.08.html', self_contained = TRUE)


###################################################
### code chunk number 46: tidyverse-s.rnw:722-728 (eval = FALSE)
###################################################
## ## trick to create dplyr-s.rnw file.
## ## this part have to be lauch manually
## dplyr_e.path <- '~/OneDrive - IARC/PROJECT/_SPE/SPE/pracs/tidyverse-e.rnw'
## dplyr_e <- readLines(dplyr_e.path)
## dplyr_s <- purrr::map_chr(dplyr_e, ~ sub('results=verbatim', 'results=verbatim', .x))
## writeLines(dplyr_s, sub('-e.rnw$', '-s.rnw', dplyr_e.path))


