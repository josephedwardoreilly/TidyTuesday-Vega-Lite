library(tidytuesdayR)
library(ggplot2)
library(data.table)
library(ggtext)
library(ggstream)
# Data Prep ---------------------------------------------------------------
# Read the data
tidy.week <- '2021-05-04'
tt_data <- tt_load(tidy.week) 
x <- data.table(tt_data$water)

x[country_name == 'Swaziland', country_name := 'Eswatini']
x[country_name == 'Congo - Kinshasa', country_name := 'Democratic Republic of the Congo']
x[country_name == 'Congo - Brazzaville', country_name := 'Republic of the Congo']


wt <- data.table(geofacet::africa_countries_grid1)

x[, report_date :=as.Date(report_date, format('%m/%d/%Y'))]
x[, y := format(report_date, '%Y')]
x <- x[y > 2009 & y < 2022]

z <- x[, .N, by = .(name = country_name)]

y <- merge(wt, z, by = 'name', all.x = TRUE)[is.na(N), N := 0]
# need a nominal coordinate system for vega to play nicely
y[, row := LETTERS[row]]
y[, col := LETTERS[col]]

write.csv(y, 'cleaned.csv', row.names = FALSE)

