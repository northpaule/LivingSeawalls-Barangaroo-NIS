# Data wrangling for Living Seawalls @ Barangaroo

# loading data
library(dplyr)
library(readxl)
watermans <- read_excel("data/lsw_watermans.xlsx")

# removing columns to ignore
nis <- watermans %>%
        select(-c('Kelp_transplant', 'Botrylloides_back', 'Styela_front', 'Styela_back', 'note', 'Diver_ID'))

# rounding styela dry weight to 1 decimal place
nis <- nis %>%
        mutate(Styela_dry_weight = round(as.numeric(Styela_dry_weight), 1))

# clean Botrylloides 
        #desired size classes: 0, XS, S, M, L, XL, XXL, NA
nis <- nis %>%
        mutate(Botrylloides_front = as.character(Botrylloides_front),
                Botrylloides_front = case_when(
                Botrylloides_front %in% c("XXXL", "XXXXL") ~ "XXL", #collapse the largest size classes
                TRUE ~ Botrylloides_front),
                Botrylloides_front = factor(
                        Botrylloides_front, levels = c("0","XS","S","M","L","XL","XXL"), #convert back to an ordered factor
                        ordered = TRUE))


# convert variables into usable factors
nis <- nis %>%
        mutate(Side = factor(Side),
                Panel_number = factor(Panel_number),
                Depth = factor(Depth,
                        levels = c("Intertidal","1.2m","3m")),
                Panel_front = factor(Panel_front),
                Sampling_period = factor(
                        Sampling_period,
                        levels = c("S1","S2","S3","S4"),
                        ordered = TRUE),
               Span = factor(Span),
               Date = as.Date(Date, format = "%d/%m/%Y"),
               Styela_actual = as.numeric(Styela_actual))

str(nis) # check

# how many panel designs
levels(nis$Panel_front)
        ## 6:Control, Kelp, Oyster, Rockpool, Sponge, Texture

# create unique identifier for each individual panel
nis <- nis %>%
        mutate(Panel_ID = interaction(
                        Span,
                        Depth,
                        Panel_number,
                        drop = TRUE))

# creating a styela subset

styela <- nis %>%
        select(Panel_ID, Panel_number, Depth, Panel_front, Sampling_period, Styela_actual, Styela_dry_weight) %>%
        rename(styela_count = Styela_actual)

