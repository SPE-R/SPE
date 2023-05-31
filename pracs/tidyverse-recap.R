## prerequest ----
library(Epi)
suppressPackageStartupMessages(library(dplyr))

data(births) 

doctor.1 <-
  data.frame(
    id = sample(1:500, 345),
    doc.id = 1
  )

doctor.2 <-
  data.frame(
    id = setdiff(1:500, doctor.1$id)[-(1:20)],
    doc.id = 2
  )

doctors.ids <-
  data.frame(
    doc.id = 1:3,
    doc.names = c('Dr Blue', 'Dr Green', 'Dr Orange')
  )

## start recap ----

## data ---
births %>% head()

doctor.1 %>% head()
doctor.2 %>% head()

doctors.ids %>% head()

## goal ----
## find the number and mean birth weight of babies per doctor and gestation weeks categories

## build a doctors database
doctor.all <-
  doctor.1 %>%
  bind_rows(
    doctor.2  
  ) %>%
  left_join(
    doctors.ids
  )

## build births-doc database
births.02 <-
  births %>%
  mutate(
    ## creating a new variable gest4
    gest4 = cut(gestwks, breaks = c(20, 35, 37, 39, 45), right = FALSE)
  ) %>%
  left_join(
    doctor.all
  ) 


## compute the mean birth weight per doctor and gestation time category
(
births.03  <-
  births.02 %>%
    group_by(
      doc.names,
      gest4
    ) %>%
    summarise(
      n = n(),
      mean.bweight = mean(bweight)
    ) 
)

## grouping order matter
births.03 %>% 
  mutate(
    n.tot = sum(n),
    percent = n/n.tot * 100
  )

births.03 %>%
  ungroup() %>%
  mutate(
    n.tot = sum(n),
    percent = n/n.tot * 100
  )
