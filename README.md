# sepsis-classification-project
A project written in R to predict sepsis from patient clinical data.
# Sepsis Prediction using Logistic Regression

# Project Overview
This project analyzes clinical data to predict whether a patient will develop sepsis. We used R and the `tidymodels` framework to build a Logistic Regression classifier.

# The Data
* Source: Sepsis Survival Minimal Clinical Records (Kaggle)
* Sample Size: 599 patients
* Features: Age, Blood Pressure, Glucose (PL), BMI, etc.

# Key Findings (EDA)
* Imbalance:The dataset is imbalanced (approx. 65% Negative, 35% Positive).
* Missing Data:'Skin Thickness' (SK) and 'Test Serum' (TS) had significant missing values.
* Top Predictors:Age and Plasma Glucose (PL) showed the strongest separation between groups.

## Methodology
1. Preprocessing:
    * Imputed missing values using the median.
    * Log-transformed right-skewed variables (Age, TS).
    * Normalized all numeric predictors.
    * Downsampled the majority class to handle imbalance.
2. Model: Logistic Regression (GLM).

#Results
* Accuracy: 74%
* Sepsis Detection Rate (Recall): 77% (40/52 cases correctly identified)
* Healthy Detection Rate (Specificity): 72%

# Conclusion
The model is effective at identifying sepsis risk (77% recall), validating that Age and Glucose are critical indicators. 
Future work could improve performance using identifying non-linear relationships (e.g., Random Forest).
