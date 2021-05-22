library(tidytuesdayR)
library(data.table)
# Data Prep ---------------------------------------------------------------
# Read the data
tidy.week <- '2021-02-23'
tt_data <- tt_load(tidy.week) 
y <- data.table(tt_data$employed)

y[grepl('Manage-ment', minor_occupation, fixed = TRUE), 
  minor_occupation := "Management, business, and financial operations occupations"]

z <- y[race_gender %in% c('Men', 'Women'),
       .(N = sum(employ_n, na.rm = TRUE)),
       by = .(year, occ = minor_occupation, gender = race_gender)]

z <- y[race_gender %in% c('Men', 'Women'), .(gender = race_gender, occ = minor_occupation, employ_n, year)]

z <- z[!is.na(employ_n)]

write.csv(z, 'cleaned.csv', row.names = FALSE)

