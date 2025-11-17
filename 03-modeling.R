# Load our toolboxes
library(tidyverse)
library(tidymodels) 

# Load cleaned Data 
source("01-load-and-clean.R")

# Data Splitting 
set.seed(1)

# Create the data split object
# 75% in training and 25% in testing.
sepsis_split <- initial_split(sepsis_clean, prop = 0.75, strata = Sepssis)

# Extract the training and testing data from the split
sepsis_train <- training(sepsis_split)
sepsis_test <- testing(sepsis_split)

# Check the results
print("Training Data Count")
sepsis_train |> count(Sepssis)

print("Testing Data Count")
sepsis_test |> count(Sepssis)


# the Pre-processing Recipe 
# fixing NAs, skew, and imbalance.

# Define which variables were skewed (from our EDA)
skewed_vars <- c("PRG", "SK", "TS", "BD2", "Age")

sepsis_recipe <- recipe(Sepssis ~ ., data = sepsis_train) |>
  
# Step 1: Imputation
# Fix NAs by filling with the median from the training data
step_impute_median(all_numeric_predictors()) |>
  
# Step 2: Transformation
# Fix right-skew by taking the log (plus 1, to avoid log(0))
step_log(all_of(skewed_vars), offset = 1) |>
  
# Step 3: Scaling
# Center and scale all predictors to have mean=0, sd=1
step_normalize(all_numeric_predictors()) |>
  
# Step 4: Handle Imbalance
# Downsample the majority class ("Negative") to match the
# minority class ("Positive").
# This requires the 'themis' package.
themis::step_downsample(Sepssis)

# Print the recipe to check it
print(sepsis_recipe)


# the model & Workflow
# Logistic Regression.
lr_model <- logistic_reg() |>
  set_engine("glm")

# the workflow
sepsis_workflow <- workflow() |>
  add_recipe(sepsis_recipe) |>
  add_model(lr_model)

# Print the workflow
print(sepsis_workflow)


# Train the Model 
sepsis_fit <- fit(sepsis_workflow, data = sepsis_train)

# Print the fitted model
print(sepsis_fit)


# evaluate the Model on the TEST data ---
sepsis_predictions <- predict(sepsis_fit, new_data = sepsis_test)

sepsis_results <- sepsis_test |>
  select(Sepssis) |> # Get the "truth" column
  bind_cols(sepsis_predictions) # Bind it with the "prediction" column

# Result
print("Confusion Matrix")
conf_mat(sepsis_results, truth = Sepssis, estimate = .pred_class)

# the key metrics
metrics <- metric_set(accuracy, sensitivity, specificity)
print("key Metrics")
sepsis_results |>
  metrics(truth = Sepssis, estimate = .pred_class)