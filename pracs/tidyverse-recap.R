## prerequest ----
library(Epi)
suppressPackageStartupMessages(library(tidyverse))

data(births) 

patients.ids <- 1:500
  
patients.doc1 <-
  data.frame(
    id = sample(patients.ids, 345),
    doc.id = 1
  )

patients.doc2 <-
  data.frame(
    id = setdiff(patients.ids, patients.doc1$id)[-(1:20)],
    doc.id = 2
  )

doctors.list <-
  data.frame(
    doc.id = 1:3,
    doc.names = c('Dr Blue', 'Dr Green', 'Dr Orange')
  )

## start recap ----

## data ---
births %>% head()

patients.doc1 %>% head()
patients.doc2 %>% head()

doctors.list %>% head()

## goal ----
## find the number and mean birth weight of babies per doctor and gestation weeks categories

## build a doctors database
doctor.all <-
  patients.doc1 %>%
  bind_rows(
    patients.doc2  
  ) %>%
  left_join(
    doctors.list
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

## ungrouping matter
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
