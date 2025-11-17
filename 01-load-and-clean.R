#Packages
library(tidyverse)
library(readxl)


# Load data
sepsis_data <- read_excel("data/sepsis.xlsx")

# Data Cleaning 
# Identify columns where 0 is an impossible value
# The "predictors"
predictors_to_fix <- c("PL", "PR", "SK", "TS", "M11", "BD2")

sepsis_clean <- sepsis_data |>
  
  # Step 1: Remove the ID column (no predictive value)
  select(-ID) |>
  
  # replace 0 with NA in all specified columns.
  mutate(
    across(all_of(predictors_to_fix), ~ na_if(., 0))
  ) |>
  
  # Step 3: Fix categorical variables (convert to Factor)
  mutate(
    Insurance = as.factor(Insurance),
    Sepssis = as.factor(Sepssis)
  )


print("--- Glimpse of Cleaned Data ---")
glimpse(sepsis_clean)

print("--- Summary of Cleaned Data ---")
summary(sepsis_clean)