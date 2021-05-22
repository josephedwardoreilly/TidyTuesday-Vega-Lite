library(tidytuesdayR)
library(data.table)

departures <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-04-27/departures.csv')

setDT(departures)

# A really rough sanity check clean
x <- departures[fyear_gone < 2022,
                .(coname,fyear,departure_code,fyear_gone, fyear_gone)]


x[departure_code == 1, departure := 'Death']
x[departure_code == 2, departure := 'Illness']
x[departure_code == 3, departure := 'Dismissed - Performance']
x[departure_code == 4, departure := 'Dismissed - Legal Reasons']
x[departure_code == 5, departure := 'Retired']
x[departure_code == 6, departure := 'Pursued New Venture']
x[is.na(departure_code) | departure_code %in% c(7, 8, 9),
  departure := 'CEO Pursued New Venture']



# Remove NA's, sum departures by year
# Drop dodgy looking years
x <- x[!is.na(fyear_gone) & fyear_gone > 2000 & fyear_gone < 2020,
       .N,
       by = .(year = fyear_gone, departure)]

# Save to disk
write.csv(x[order(year)], file = 'cleaned.csv',row.names = FALSE)
