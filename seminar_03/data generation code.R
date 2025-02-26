set.seed(123)  # For reproducibility

# Number of students
n <- 200

# Generate continuous variables
sleep_hours <- rnorm(n, mean = 7, sd = 1.5)  # Average sleep per night (hours)
stress_score <- 25 - 3 * sleep_hours + rnorm(n, mean = 0, sd = 5)  # Stress inversely related to sleep
gpa <- 65 + 1 * sleep_hours - 0.3 * stress_score + rnorm(n, mean = 0, sd = 15)  # GPA influenced by sleep and stress

# Generate categorical variables
majors <- c("Psychology", "Engineering", "Humanities", "Biology", "Business")
chronotypes <- c("Morning Person", "Night Owl", "Intermediate")
academic_major <- sample(majors, n, replace = TRUE)
sleep_chronotype <- sample(chronotypes, n, replace = TRUE)


# Adjust GPA and Stress based on chronotype
stress_score <- ifelse(sleep_chronotype == "Morning Person", stress_score + 3, 
                       ifelse(sleep_chronotype == "Night Owl", stress_score - 3, stress_score))
gpa <- ifelse(sleep_chronotype == "Morning Person", gpa + 10, 
              ifelse(sleep_chronotype == "Night Owl", gpa - 10, gpa))
gpa <- ifelse(sleep_chronotype == "Night Owl", 65 + 2 * sleep_hours - 0.3 * stress_score + rnorm(n, mean = 0, sd = 15), gpa)

# Convert to a data frame
my_data <- data.frame(
  Sleep_Hours = sleep_hours,
  Stress_Score = stress_score,
  GPA = gpa,
  Academic_Major = academic_major,
  Sleep_Chronotype = sleep_chronotype
)

# Display summary of the dataset
summary(my_data)

