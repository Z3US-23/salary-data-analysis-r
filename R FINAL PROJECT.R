concatenated_data <- rbind(Data_2020_xlsx, Data_2021_xlsx, Data_2022_xlsx, Data_2023_xlsx)
library(tidyverse)

# Calculate missing percentages
missing_percentage <- concatenated_data%>%
  summarise(across(everything(), ~sum(is.na(.)) / n() * 100)) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Percentage")

print(missing_percentage)

# Also check total rows
cat("Total rows in combined data:", nrow(concatenated_data), "\n")
cat("Total columns:", ncol(concatenated_data), "\n")
# Five-value summary function
five_value_summary <- function(data) {
  numerical_data <- data %>% select(where(is.numeric))
  
  summary_table <- data.frame(
    Variable = names(numerical_data),
    Min = sapply(numerical_data, min, na.rm = TRUE),
    Max = sapply(numerical_data, max, na.rm = TRUE),
    Mean = sapply(numerical_data, mean, na.rm = TRUE),
    Median = sapply(numerical_data, median, na.rm = TRUE),
    SD = sapply(numerical_data, sd, na.rm = TRUE)
  )
  
  rownames(summary_table) <- NULL
  return(summary_table)
}

# Use the function
summary_stats <- five_value_summary(concatenated_data)
print(summary_stats)
# Check column names
colnames(concatenated_data)

# Check data structure
str(concatenated_data)
# Load required libraries
library(tidyverse)
library(knitr)
library(kableExtra)

# 1. SAVE YOUR COMBINED DATA
write.csv(concatenated_data, "combined_salaries_data.csv", row.names = FALSE)

# 2. MISSING DATA ANALYSIS
missing_percentage <- concatenated_data %>%
  summarise(across(everything(), ~sum(is.na(.)) / n() * 100)) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Percentage")

print("Missing Data:")
print(missing_percentage)

# Handle missing data (remove rows with NA)
combined_data_clean <- na.omit(concatenated_data)

# 3. OUTLIER DETECTION
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  lower_bound <- Q1 - 1.5 * IQR
  upper_bound <- Q3 + 1.5 * IQR
  outliers <- x < lower_bound | x > upper_bound
  return(outliers)
}

numerical_cols <- combined_data_clean %>% select(where(is.numeric))
outlier_summary <- sapply(numerical_cols, function(col) {
  sum(detect_outliers(col), na.rm = TRUE)
})

print("Outliers:")
print(outlier_summary)

# 4. FIVE-VALUE SUMMARY
five_value_summary <- function(data) {
  numerical_data <- data %>% select(where(is.numeric))
  
  summary_table <- data.frame(
    Variable = names(numerical_data),
    Min = sapply(numerical_data, min, na.rm = TRUE),
    Max = sapply(numerical_data, max, na.rm = TRUE),
    Mean = sapply(numerical_data, mean, na.rm = TRUE),
    Median = sapply(numerical_data, median, na.rm = TRUE),
    SD = sapply(numerical_data, sd, na.rm = TRUE)
  )
  
  rownames(summary_table) <- NULL
  return(summary_table)
}

summary_stats <- five_value_summary(combined_data_clean)
print("Five-Value Summary:")
print(summary_stats)
write.csv(concatenated_data, "combined_salaries_data.csv", row.names = FALSE)





library(tidyverse)

# 1. Missing Data
missing_percentage <- concatenated_data %>%
  summarise(across(everything(), ~sum(is.na(.)) / n() * 100)) %>%
  pivot_longer(everything(), names_to = "Variable", values_to = "Missing_Percentage")

print(missing_percentage)

# 2. Clean data
combined_data_clean <- na.omit(concatenated_data)

# 3. Outliers
detect_outliers <- function(x) {
  Q1 <- quantile(x, 0.25, na.rm = TRUE)
  Q3 <- quantile(x, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  outliers <- x < (Q1 - 1.5*IQR) | x > (Q3 + 1.5*IQR)
  return(sum(outliers, na.rm = TRUE))
}

numerical_cols <- combined_data_clean %>% select(where(is.numeric))
outlier_counts <- sapply(numerical_cols, detect_outliers)
print(outlier_counts)

# 4. Five-value summary
five_value_summary <- function(data) {
  numerical_data <- data %>% select(where(is.numeric))
  
  summary_table <- data.frame(
    Variable = names(numerical_data),
    Min = sapply(numerical_data, min, na.rm = TRUE),
    Max = sapply(numerical_data, max, na.rm = TRUE),
    Mean = sapply(numerical_data, mean, na.rm = TRUE),
    Median = sapply(numerical_data, median, na.rm = TRUE),
    SD = sapply(numerical_data, sd, na.rm = TRUE)
  )
  
  return(summary_table)
}

summary_stats <- five_value_summary(combined_data_clean)
print(summary_stats)
installed.packages(TinyTex)
install.packages("flexdashboard")

