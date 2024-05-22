## ----include=FALSE------------------------------------------------------------
knitr::opts_chunk$set(results = "markup", prefix.string = "./graph/tidyverse")


## -----------------------------------------------------------------------------
library(Epi)
suppressPackageStartupMessages(library(tidyverse))
data(births)


## -----------------------------------------------------------------------------
class(births)
head(births)


## -----------------------------------------------------------------------------
str(births)


## -----------------------------------------------------------------------------
births_tbl <- as_tibble(births)

class(births_tbl)
births_tbl

# another way to visualize data set is to use glimpse function
glimpse(births_tbl)


## -----------------------------------------------------------------------------
head(births, 4)
births |> head(4)


## -----------------------------------------------------------------------------
4 %>% head(births, .)


## -----------------------------------------------------------------------------
4 |> (\(.) head(births, .))() # Note the extra parentheses


## -----------------------------------------------------------------------------
births_tbl <-
  births_tbl |>
  mutate(
    # modify hyp varible (conversion into factor)
    hyp = 
      factor(
        hyp, 
        levels = c(0, 1), 
        labels = c("normal", "hyper")
      ),
    # creating a new variable aggrep
    agegrp = 
      cut(
        matage, 
        breaks = c(20, 25, 30, 35, 40, 45), 
        right = FALSE
      ),
    # modify sex variable (conversion into factor)
    sex = 
      factor(
        sex, 
        levels = c(1, 2), 
        labels = c("M", "F")
      ),
    # creating a new variable gest4 with case_when instead of cut
    gest4 =
      case_when(
        gestwks < 25 ~ "less than 25 weeks",
        gestwks >= 25 & gestwks < 30 ~ "25-30 weeks",
        gestwks >= 30 & gestwks < 35 ~ "30-35 weeks",
        gestwks >= 35 ~ "more than 35 weeks"
      )
  )

births_tbl


## -----------------------------------------------------------------------------
births_tbl |>
  # select only id, women age group, sex 
  # and birth weight of the baby
  select(id, agegrp, sex, bweight) |>
  # keep only babies weighing more than 4000g
  filter(bweight > 4000)


## -----------------------------------------------------------------------------
births_tbl |>
  # select only id, women age group, sex 
  # and birth weight of the baby
  select(
    id,
    "Age group" = agegrp,
    Sex = sex,
    "Birth weight" = bweight
  ) |>
  # rearrange rows to put the heaviest newborn on top
  arrange(desc(`Birth weight`))


## -----------------------------------------------------------------------------
births_tbl |>
  # select only id, women age group, sex 
  # and birth weight of the baby
  select(
    id,
    "Age group" = agegrp,
    Sex = sex,
    "Birth weight" = bweight
  ) |>
  # rearrange rows to put the heaviest newborn on top
  arrange(Sex, desc(`Birth weight`))


## -----------------------------------------------------------------------------
births.01 <-
  births_tbl |>
  # group the data according to the sex attribute
  group_by(sex) |>
  # count the number of rows/individuals in each group
  summarise(
    count = n()
  )
births.01


## -----------------------------------------------------------------------------
births.02 <-
  births.01 |>
  mutate(
    percent = count / sum(count) * 100
  )


## -----------------------------------------------------------------------------
births.03 <-
  births_tbl |>
  select(gest4, sex, gestwks, bweight, matage) |>
  group_by(gest4, sex) |>
  summarise(
    across(
      where(is.numeric),
      ~ mean(.x, na.rm = TRUE)
    ),
    .groups = "drop"
  )
births.03


## -----------------------------------------------------------------------------
births.03 |>
  rename_with(toupper, where(~ !is.numeric(.x)))


## -----------------------------------------------------------------------------
births.05 <-
  births_tbl |>
  group_by(sex) |>
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )
births.05


## -----------------------------------------------------------------------------
births.05 |>
  summarise(
    count.tot = sum(count),
    bweight.mean.tot = weighted.mean(bweight.mean, count)
  )

# this is equivalent to
births_tbl |>
  summarise(
    count.tot = n(),
    bweight.mean.tot = mean(bweight)
  )


## -----------------------------------------------------------------------------
births.06 <-
  births_tbl |>
  group_by(sex, lowbw) |>
  summarise(
    count = n()
  )
births.06


## -----------------------------------------------------------------------------
births.06 |>
  mutate(
    percent = count / sum(count) * 100
  )

births.06 |>
  ungroup() |>
  mutate(
    percent = count / sum(count) * 100
  )


## ----message = FALSE----------------------------------------------------------
# this tibble will still be grouped by sex
births_tbl |>
  group_by(sex, lowbw) |>
  summarise(
    count = n()
  )

# this tibble will be group free
births_tbl |>
  group_by(sex, lowbw) |>
  summarise(
    count = n(),
    .groups = "drop"
  )


## -----------------------------------------------------------------------------
births_tbl |>
  group_by(gest4) |>
  summarise(
    count = n(),
    bweight.mean = mean(bweight)
  )


## -----------------------------------------------------------------------------
births_tbl |>
  # keep only the newborn with defined gesational time category
  filter(
    !is.na(gest4)
  ) |>
  group_by(lowbw, gest4) |>
  # compute the number of babies in each cross category
  summarise(
    count = n()
  ) |>
  # compute the percentage of babies in each gestational 
  # time category per birth weight category
  mutate(
    percent = count / sum(count, na.rm = TRUE)
  )


## -----------------------------------------------------------------------------
births_tbl |>
  filter(
    !is.na(gest4)
  ) |>
  group_by(gest4, lowbw) |>
  summarise(
    count = n()
  ) |>
  # compute the percentage of babies in each birth weight category
  # per gestational time category
  mutate(
    percent = count / sum(count, na.rm = TRUE)
  )


## -----------------------------------------------------------------------------
age <-
  tibble(
    pid = 1:6,
    age = sample(15:25, size = 6, replace = TRUE)
  )

center <-
  tibble(
    pid = c(1, 2, 3, 4, 10),
    center = c("A", "B", "A", "B", "C")
  )

age
center


## -----------------------------------------------------------------------------
bind_rows(age, center)


## -----------------------------------------------------------------------------
# all individuals from ages are kept
left_join(age, center, by = c("pid"))
# everithing is kept
full_join(age, center, by = c("pid"))
# only the individuals present in both dataset are kept
inner_join(age, center, by = c("pid"))


## -----------------------------------------------------------------------------
inner_join(age, center, by = c("pid")) |>
  group_by(center) |>
  summarise(
    mean_age = mean(age)
  )


## -----------------------------------------------------------------------------
birth_per_ageg <- births_tbl |>
  group_by(agegrp) |>
  summarise(total_births = n())


## -----------------------------------------------------------------------------
(gg.01 <-
  ggplot(birth_per_ageg, aes(x = agegrp, y = total_births)) +
  geom_bar(stat = "identity"))


## -----------------------------------------------------------------------------
(gg.02 <-
  gg.01 +
  xlab("Women Age Group") +
  ylab("Total Births") +
  ggtitle("Number of Births per Women Age Group"))


## -----------------------------------------------------------------------------
birth_per_ageg

birth_per_ageg_wide <-
  birth_per_ageg |>
  pivot_wider(
    names_from = "agegrp", 
    values_from = "total_births"
  )

birth_per_ageg_wide


## -----------------------------------------------------------------------------
birth_per_ageg_long <-
  birth_per_ageg_wide |>
  pivot_longer(
    cols = 1:5, 
    names_to = "agegrp", 
    values_to = "total_births"
  )

birth_per_ageg_long


## -----------------------------------------------------------------------------
identical(birth_per_ageg, birth_per_ageg_long)


## -----------------------------------------------------------------------------
birth_per_ageg_long_02 <-
  birth_per_ageg_long |>
  mutate(agegrp = as.factor(agegrp))

identical(birth_per_ageg, birth_per_ageg_long_02)


## -----------------------------------------------------------------------------
# read a csv using core R
fem.csv.core <- read.csv("data/fem.csv")
# read a csv using tidyverse
fem.csv.tidy <- read_csv("data/fem.csv")
# compare
fem.csv.core
fem.csv.tidy
# table dimensions
dim(fem.csv.core)
dim(fem.csv.tidy)
# compare column types
map(fem.csv.core, class)
map(fem.csv.tidy, class)


## -----------------------------------------------------------------------------
# read a csv using core R
occoh.txt.core <- read.table("data/occoh.txt")
# read a csv using tidyverse
occoh.txt.tidy <- read_table("data/occoh.txt")
occoh.txt.tidy <- read_table("data/occoh.txt")
# compare
occoh.txt.core
occoh.txt.tidy
# table dimensions
dim(occoh.txt.core)
dim(occoh.txt.tidy)
# compare column types
map(occoh.txt.core, class)
map(occoh.txt.tidy, class)


## -----------------------------------------------------------------------------
countries <- 
  c("Estonia", "Finland", "Denmark", "United Kingdom", "France")


## -----------------------------------------------------------------------------
country_initials <- str_sub(countries, start = 1, end = 3)


## -----------------------------------------------------------------------------
countries_upper <- str_to_upper(countries)


## -----------------------------------------------------------------------------
countries_modified <- str_replace(countries, "United", "Utd")


## -----------------------------------------------------------------------------
a_positions <- str_locate_all(countries, "n")


## -----------------------------------------------------------------------------
character_counts <- str_length(countries)


## -----------------------------------------------------------------------------
# define the grade dataset
grades <-
  list(
    c1 = c(80, 85, 90),
    c2 = c(75, 70, 85, 88),
    c3 = c(90, 85, 95)
  )
# compute grades
mean_grades <- map(grades, mean)


## -----------------------------------------------------------------------------
map(grades, mean)
map_dbl(grades, mean)
map_chr(grades, mean)
map_df(grades, mean)


## -----------------------------------------------------------------------------
1:10 |> purrr::reduce(`*`)
1:10 |> purrr::accumulate(`*`)


## ----eval=FALSE---------------------------------------------------------------
## # if(!require(kableExtra)) install.packages('kableExtra')
## library(kableExtra)
## 
## births.08 <-
##   births_tbl |>
##   filter(
##     !is.na(gest4)
##   ) |>
##   group_by(gest4) |>
##   summarise(
##     N = n()
##   ) |>
##   mutate(
##     `(%)` = (N / sum(N)) |> scales::percent()
##   )
## 
## # default
## births.08
## 
## # create an html version of the table and save it on the hard drive
## births.08 |>
##   kable() |>
##   kable_styling(
##     bootstrap_options =
##       c("striped", "hover", "condensed", "responsive"),
##     full_width = FALSE
##   ) |>
##   save_kable(file = "births.08.html", self_contained = TRUE)


## ----echo=FALSE, eval=FALSE---------------------------------------------------
## # trick to create dplyr-s.rnw file.
## # this part have to be lauch manually
## dplyr_e.path <- "~/OneDrive - IARC/PROJECT/_SPE/SPE/pracs/tidyverse-e.rnw"
## dplyr_e <- readLines(dplyr_e.path)
## dplyr_s <- purrr::map_chr(dplyr_e, ~ sub("results='hide'", "", .x))
## writeLines(dplyr_s, sub("-e.rnw$", "-s.rnw", dplyr_e.path))

