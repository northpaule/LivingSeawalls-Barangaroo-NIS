# Data wrangling for Living Seawalls @ Barangaroo

# loading data
library(readxl)
watermans <- read_excel("data/lsw_watermans.xlsx")

# removing columns to ignore
clean_watermans <- watermans %>%
        select(-c('Botrylloides_back', 'Styela_back', 'note', 'Diver_ID'))

# rounding styela dry weight to 1 decimal place
clean_watermans <- clean_watermans %>%
        mutate(Styela_dry_weight = round(as.numeric(Styela_dry_weight), 1))
