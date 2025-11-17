# Load packages
library(tidyverse) 
library(naniar)    

# Load cleaned data 

source("01-load-and-clean.R")

# Visualize Missing Data 
# Create a heatmap of which values are missing (NA)
gg_miss_upset(sepsis_clean)

# Analyze Numeric Predictors

# standard ggplot 
sepsis_long <- sepsis_clean |>
  select(where(is.numeric)) |>  # Keep only numeric columns
  pivot_longer(
    cols = everything(),       # Pivot all of them
    names_to = "variable",     # Store the old column name
    values_to = "value"        
  )

# histograms (a "facet" plot)
sepsis_long |>
  ggplot(aes(x = value)) +
  geom_histogram(bins = 30, fill = "steelblue", color = "black") +
  facet_wrap(~ variable, scales = "free") +
  labs(
    title = "Distribution of Numeric Predictors",
    x = "Value",
    y = "Count"
    
  )


#  Analyze Predictors vs. Target  (boxplot).

sepsis_clean |>
  ggplot(aes(x = Sepssis, y = Age, fill = Sepssis)) +
  geom_boxplot() +
  labs(
    title = "Age Distribution by Sepsis Outcome",
    x = "Sepsis Diagnosis",
    y = "Age"
  )


#Analyze ALL Predictors vs. Target 
# EDA Plot


# add Sepssis back to our "long" data
sepsis_long_with_target <- sepsis_clean |>
  select(where(is.numeric), Sepssis) |> # Keep numerics AND Sepssis
  pivot_longer(
    cols = -Sepssis, # Pivot all columns EXCEPT Sepssis
    names_to = "variable",
    values_to = "value"
  )

#  grid of boxplots
sepsis_long_with_target |>
  ggplot(aes(x = Sepssis, y = value, fill = Sepssis)) +
  geom_boxplot() +
  facet_wrap(~ variable, scales = "free_y") +
  labs(
    title = "Predictor Distributions by Sepsis Outcome",
    x = "Sepsis Diagnosis",
    y = "Predictor Value"
  ) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # Tidy up x-axis labels

