# ============================================================
# FUNDAMENTALS OF R PROGRAMMING & PRACTICAL WORKFLOWS
# FOR FISHERIES DATA
# Training: Stock Assessment of Finfish
# ============================================================

# ============================================================
# 1. START WITH A CLEAN R PROJECT
# ============================================================
# In RStudio:
# File -> New Project -> New Directory
# Create a project such as: R_training


# setwd() sets the working directory in R.
# It tells R where to look for and save files.
setwd("~/Documents/Training/Stock assessment") 

# Install once, if required:
#install.packages("tidyverse")
#install.packages(c("tidyverse", "janitor"))

# Load packages at the beginning of each session:
library(tidyverse)
library(dplyr)
library(janitor)
library(writexl)
# ============================================================
# 2. R BASICS: OBJECTS, VECTORS, FUNCTIONS
# ============================================================
# Create an object called 'x' and assign the value 10 to it
x <- 10
# Create another object called 'y' and assign the value 20
y <- 20

# then try addition, multiplication and division
x + y
x * y
x / y

##CREATING A VECTOR
# c() means "combine".
# It combines several values into a single vector.
#
# Here, we are creating a vector of fish lengths in cm.
lengths <- c(32, 35, 38, 40, 42, 45)
#lengths is the object name, <- means assign, c() means combine, and 
#the numbers are the values being stored.

# Display the values stored in 'lengths'
lengths

mean(lengths)
median(lengths)
min(lengths)
max(lengths)
sd(lengths)

# Text/character values must be written inside quotation marks.
species <- c("Skipjack", "Yellowfin", "Kawakawa")
species

# Logical values
#R checks every value and returns TRUE or FALSE.
lengths > 40
# "Select only the fish whose length is greater than 40 cm."
lengths[lengths > 40]

# na.rm = TRUE means:
# "Remove missing values (NA) before calculating."
#
mean(lengths, na.rm = TRUE)


# ============================================================
# 3. DATA FRAMES: THE MOST IMPORTANT R OBJECT FOR FISHERIES
# ============================================================

# A data frame is a table in R.
# It consists of rows and columns.
#
# In fisheries, a data frame can represent:
#   - Fish biological measurements
#   - Catch and effort data
#   - Length-frequency data
#   - Vessel observations
#   - Environmental observations
#
# Each COLUMN represents a variable.
# Each ROW represents one observation.

fish <- data.frame(
  
  # Species name for each fish
  Species = c("Skipjack", "Skipjack", "Yellowfin", "Yellowfin"),
  
  # Fish length in centimetres
  Length_cm = c(45, 52, 61, 68),
  
  # Fish weight in grams
  Weight_g = c(1200, 1900, 3200, 4100)
)

# Display the complete data frame
fish

# 3.1 INSPECTING A DATA FRAME
# str() shows the structure of the data.
# It tells us:
#   - number of observations (rows)
#   - number of variables (columns)
#   - variable names
#   - data type of each variable
str(fish)


# head() displays the first 6 rows by default.
# Useful when the dataset is large and we want a quick look.
head(fish)


# summary() provides a basic statistical summary.
# For numeric variables, it shows:
#   Minimum, 1st Quartile, Median,
#   Mean, 3rd Quartile and Maximum.
#
# For character variables, it provides basic information.
summary(fish)


# names() displays the names of all columns.
names(fish)

# The $ operator is a simple way to access a column.
#
# Here we extract the Length_cm column.
fish$Length_cm

# Access columns in the data
fish$Length_cm
#OR
fish[["Length_cm"]]

# Basic calculations
mean(fish$Length_cm)
mean(fish$Weight_g)

# ============================================================
# 4. IMPORT A CSV
# ============================================================
# CSV = Comma-Separated Values.
#
# CSV is one of the most commonly used formats for
# storing and sharing data.
#
# A CSV file can be opened in:
#   - Excel
#   - R
#   - Python
#   - other statistical software
#
# In R, we use read_csv() to import a CSV file.

# catch = name of the R object
# read_csv() = function used to import the CSV file
# "dummy_fisheries_catch_effort.csv" = file name
catch <- read_csv("dummy_fisheries_catch_effort.csv")
# IMPORTANT:
# File and folder names must be written correctly.
# R is case-sensitive in many environments.
#
# Example:
# "dummy_fisheries_catch_effort.csv"
# and
# "dummy_fisheries_Catch_effort.csv"
# may be treated as different file names.

# Inspect
head(catch)
glimpse(catch)
summary(catch)

#Similarly import
# Import the length-weight dataset
# 'lw' stands for length-weight.
lw <- read_csv("dummy_length_weight.csv")
view(lw)
# Import the environmental dataset
# 'env' stands for environmental data.
#env <- read_csv("dummy_environment.csv")

# ============================================================
# 5. BASIC DATA CHECKING
# ============================================================
# Before analysing fisheries data, ALWAYS check the dataset.
#
# Basic questions we should ask:
#   1. What are the variables?
#   2. How many observations and variables are there?
#   3. What categories are present?
#   4. Are there missing values?
#   5. Are there duplicate observations?
#   6. Are there unusual or impossible values?
#
# Remember:
# IMPORT -> CHECK -> CLEAN -> ANALYSE

# names() displays the names of all columns.
#
# This helps us understand what variables are available
# and check whether the column names are correct.
names(catch)

# dim() gives the dimensions of the dataset:
# number of rows followed by number of columns.
#
# Example:
# 192 7
# means 192 observations and 7 variables.
dim(catch)

# nrow() gives only the number of rows/observations.
nrow(catch)


# ncol() gives only the number of columns/variables.
ncol(catch)

# unique() shows all different values present in a variable.
#
# Here we check which islands are represented in the dataset.
unique(catch$Island)

# Check which fishing gears are represented.
unique(catch$Gear)
# This is useful for identifying:
#   - unexpected spelling
#   - unexpected categories
#   - missing categories
#   - inconsistent naming
#
# For example:
# "Pole-and-line" and "Pole and line"
# could represent the same gear but would be treated
# as two different categories by R.

# Missing values
colSums(is.na(catch))
# If a column contains NA values, investigate WHY
# the observations are missing before deciding what to do.
#   
# IMPORTANT:
# Do not automatically delete missing observations.

# Duplicate rows
sum(duplicated(catch))

# Check impossible/strange values
summary(catch$Catch_kg)
summary(catch$Effort_trips)
# Fisheries example:
# Catch should not normally be negative.
# Effort should not normally be negative or zero
# if CPUE is going to be calculated as Catch / Effort.
#
# However, the definition of "impossible" depends on
# the sampling design and the actual fisheries data.
 
# ============================================================
# 6. DATA MANIPULATION WITH dplyr
# ============================================================
# dplyr is a package within the tidyverse.
# It provides simple functions for manipulating data frames.
#
# The four functions we will learn first are:
#
# filter()  -> select rows/observations
# select()  -> select columns/variables
# arrange() -> sort rows
# rename()  -> change column names
#
# These functions are extremely useful when working with
# fisheries datasets.

# filter() = select rows
catch_kavaratti <- catch %>%
  filter(Island == "Kavaratti")

catch_pl <- catch %>%
  filter(Gear == "Pole-and-line")

# Multiple conditions
catch_kav_pl <- catch %>%
  filter(Island == "Kavaratti",
         Gear == "Pole-and-line")

# select() = select columns
catch_small <- catch %>%
  select(Year, Month, Island, Gear, Effort_trips, Catch_kg)

# arrange() = sort rows
catch %>%
  arrange(desc(Catch_kg))

# rename()
catch %>%
  rename(
    Effort = Effort_trips,
    Catch = Catch_kg,
  )

# ============================================================
# 7. CREATE NEW VARIABLES WITH mutate()
# ============================================================
# mutate() is used to CREATE new variables (columns)
# or MODIFY existing variables in a data frame.
#
# Fisheries examples of variables we may create:
#   - CPUE
#   - fishing season
#   - length class
#   - age group
#   - log-transformed length/weight
#   - effort per fishing day
#
# General structure:
#
# data <- data %>%
#   mutate(
#     new_variable = calculation
#   )


# ##CPUE = catch / effort
#
# A simple CPUE calculation:
#
#             Catch
# CPUE =  -------------
#             Effort
#
# Here:
# Catch_kg     = catch in kg
# Effort_trips = number of fishing trips

catch <- catch %>%
  mutate(
    CPUE_kg_trip = Catch_kg / Effort_trips
  )
# A new column called CPUE_kg_trip has now been added
# to the 'catch' dataset.
head(catch)

# IMPORTANT:
# mutate() does not automatically change the original object.
#
# Because we used:
# catch <- catch %>%
# the updated dataset is saved back into the object 'catch'.

### Create date
# Our dataset currently has Year and Month as separate variables.
#
# For time-series analysis and plotting, it is often useful
# to create a single Date variable.
catch <- catch %>%
  mutate(
    Date = as.Date(
      paste(Year, Month, "01", sep = "-")
    )
  )
# paste() combines Year, Month and "01" into text.
#
# For example:
#
# Year = 2024
# Month = 6
#
# becomes:
#
# "2024-6-01"
#
# sep = "-" tells R to put a hyphen between the values.
#
# as.Date() converts the resulting text into an R Date object.


# Season
# We can create a categorical variable called 'Season'
# based on the month of observation.
#
# For this fisheries dataset, we define:
#
# Pre-monsoon  = February to May
# Monsoon      = June to September
# Post-monsoon = October to January
#
catch <- catch %>%
  mutate(
    Season = case_when(
      
      # February to May
      Month %in% c(2, 3, 4, 5) ~ "Pre-monsoon",
      
      # June to September
      Month %in% c(6, 7, 8, 9) ~ "Monsoon",
      
      # October to January
      Month %in% c(10, 11, 12, 1) ~ "Post-monsoon"
    )
  )
table(catch$Season)

view(catch)
# ============================================================
# 8. GROUP_BY + SUMMARISE
# THE CORE FISHERIES DATA WORKFLOW
# ============================================================
# group_by() tells R:
# "Group the observations according to this variable."
#
# summarise() then calculates a summary statistic
# for each group.
#
# Together, they are extremely useful for fisheries data.
#
# Examples:
#   Catch by island/landing center
#   Catch by gear
#   CPUE by year
#   CPUE by island and gear
#   Length statistics by species
#
# General structure:
#
# data %>%
#   group_by(variable) %>%
#   summarise(summary = calculation)

#### Overall catch
# First, let's calculate overall catch and mean CPUE.
#
# There is NO group_by() here.
# Therefore, R treats the entire dataset as one group.
catch %>%
  summarise(
    Total_catch_kg = sum(Catch_kg),
    Mean_CPUE = mean(CPUE_kg_trip)
  )

# Catch by island
# Now we want to compare the fisheries among islands.
#
# group_by(Island) tells R to create a separate group
# for each island.
catch_by_island <- catch %>%
  group_by(Island) %>%
  summarise(
    Total_catch_kg = sum(Catch_kg),
    Total_effort = sum(Effort_trips),
    Mean_CPUE = mean(CPUE_kg_trip),
    .groups = "drop"
  )

catch_by_island

# Catch by gear
catch_by_gear <- catch %>%
  group_by(Gear) %>%
  summarise(
    Total_catch_kg = sum(Catch_kg),
    Total_effort = sum(Effort_trips),
    Mean_CPUE = mean(CPUE_kg_trip),
    .groups = "drop"
  )

catch_by_gear

# Catch by year and gear
annual <- catch %>%
  group_by(Year, Gear) %>%
  summarise(
    Catch_kg = sum(Catch_kg),
    Effort = sum(Effort_trips),
    CPUE = Catch_kg / Effort,
    .groups = "drop"
  )

annual

# ============================================================
# 9. TABLES / FREQUENCY DISTRIBUTION
# ============================================================

# Number of observations by island
table(catch$Island)

# Length-frequency data
table(lw$Island)

# ============================================================
# 10. LENGTH-FREQUENCY ANALYSIS
# ============================================================
# Length-frequency analysis describes the size composition
# of sampled fish.
#
# In fisheries, length-frequency data can be used to examine:
#   - size structure of the catch
#   - dominant size groups
#   - recruitment patterns
#   - changes in size composition
#   - inputs for length-based stock assessment methods
#
# Each row in our 'lw' dataset represents one sampled fish.

# Inspect length data
str(lw)
summary(lw$Length_cm)
head(lw)


##### Create 2-cm length classes
# Individual fish may have many different measured lengths.
#
# For length-frequency analysis, we usually group individual
# lengths into length classes.
#
# Here we are creating 2-cm length classes.
#
# Example:
# 41.2 cm -> 40 cm class
# 42.7 cm -> 42 cm class
# 45.1 cm -> 44 cm class
#
# floor() rounds a value DOWN to the nearest integer.
#
# floor(Length_cm / 2) * 2
#
# creates intervals of approximately 2 cm.
lw <- lw %>%
  mutate(
    Length_class = floor(Length_cm / 2) * 2
  )
head(lw)
view(lw)
# count() counts the number of observations
# in each category.
#
# Here we count how many fish occur in each length class.
#
# 'N' is the name we give to the count column.  
length_frequency <- lw %>%
  count(Length_class, name = "N")

length_frequency


# By island
lf_island <- lw %>%
  count(Island, Length_class, name = "N")
#
#save as csv
write_csv(lf_island, "length_frequency_by_island.csv")
#
#save as xlsx
write_xlsx(
  lf_island,
  "length_frequency_by_island.xlsx"
)
####PLOT ISLAND WISE L-F
# Plot length-frequency distribution by island
#
# geom_col() creates bars using the frequency values
# already calculated in lf_island.
#
# facet_wrap(~ Island) creates a separate panel for each island.
# This allows us to compare the size structure among islands.
#
# x-axis = Length class (cm)
# y-axis = Frequency, or number of fish (N)

ggplot(lf_island, aes(x = Length_class, y = N)) +
  geom_col(width = 2) +
  facet_wrap(~ Island, ncol = 2) +
  labs(
    title = "Length-Frequency Distribution by Island",
    x = "Length (cm)",
    y = "Frequency (N)"
  ) +
  theme_minimal()

###SAVE PLOT
# ggsave() saves a ggplot object to a file.
# filename = name of the output file
# plot = p1 specifies which plot to save
# width and height specify the figure size
# units = "in" means the dimensions are in inches
# dpi = 300 gives publication-quality resolution
ggsave(
  "length_frequency_by_island.jpg",
  plot = p1,
  width = 8, height = 6,
  units = "in",
  dpi = 300
)
# ============================================================
# 11. LENGTH-WEIGHT RELATIONSHIP
# W = aL^b
# log(W) = log(a) + b log(L)
# ============================================================
# The length-weight relationship describes how fish weight
# changes with increasing body length.
#
# The standard equation is:
#
# W = aL^b
#
# W = Weight of the fish
# L = Length of the fish
# a = Intercept or scaling coefficient
# b = Slope or allometric coefficient
#
# Interpretation of b:
# b = 3  -> Isometric growth
# b < 3  -> Negative allometric growth
# b > 3  -> Positive allometric growth
#
# We use log transformation to convert the power relationship
# into a linear relationship:
#
# log(W) = log(a) + b log(L)
#
# Therefore, when we fit a linear regression:
#   log(W) = intercept + slope × log(L)
#
# the slope gives the value of b.

# Plot raw relationship
ggplot(lw, aes(x = Length_cm, y = Weight_g)) +
  geom_point(alpha = 0.5) +
  labs(
    x = "Length (cm)",
    y = "Weight (g)",
    title = "Length-weight relationship"
  ) +
  theme_minimal()
# Each point represents one sampled fish.


# Linear model on log-transformed data
# lm() fits a linear regression model.

lw_model <- lm(
  log10(Weight_g) ~ log10(Length_cm),
  data = lw
)

summary(lw_model)

# Extract coefficients
coef(lw_model)

# b is the slope
b <- coef(lw_model)[2]

# a = 10^(intercept) because log10 was used
a <- 10^(coef(lw_model)[1])

a
b

# 95% confidence interval for b
b_CI <- confint(
  lw_model,
  "log10(Length_cm)",
  level = 0.95
)

b_CI

# Calculate R-squared
r2 <- summary(lw_model)$r.squared


# Add fitted relationship to plot
ggplot(lw, aes(Length_cm, Weight_g)) +
  geom_point(alpha = 0.45) +
  stat_smooth(method = "lm", formula = y ~ x,
              se = FALSE) +
  scale_y_log10() +
  scale_x_log10() +
  labs(
    title = "Log-log length-weight relationship",
    x = "Length (cm), log scale",
    y = "Weight (g), log scale"
  ) +
  annotate(
    "text",
    x = 30,
    y = 7000,
    label = "W == 0.0092 * L^3.11\nR^2 == 0.9374",
    parse = TRUE,
    hjust = 0,
    size = 5
  ) +
  annotate(
    "text",
    x = 30, y = 5000,
    label = "R^2 == 0.9374",
    parse = TRUE,
    hjust = 0,
    size = 5
  ) +
  theme_minimal()

head(lw)
# ============================================================
# 12. VISUALISE CPUE
# ============================================================

# Monthly CPUE by gear
monthly_cpue <- catch %>%
  group_by(Date, Gear) %>%
  summarise(
    CPUE = sum(Catch_kg) / sum(Effort_trips),
    .groups = "drop"
  )

ggplot(monthly_cpue, aes(Date, CPUE, colour = Gear)) +
  geom_line(linewidth = 1) +
  geom_point() +
  labs(
    x = "Month",
    y = "CPUE (kg/trip)",
    title = "Monthly CPUE"
  ) +
  theme_minimal()

# ============================================================
# 13. CATCH BY ISLAND
# ============================================================

ggplot(catch_by_island,
       aes(x = reorder(Island, Total_catch_kg),
           y = Total_catch_kg)) +
  geom_col() +
  coord_flip() +
  labs(
    x = "Island",
    y = "Total catch (kg)",
    title = "Total catch by island"
  ) +
  theme_minimal()



# ============================================================
# 14. HANDLE MISSING VALUES
# ============================================================
# Missing values are represented by NA in R.
#
# In fisheries datasets, missing values can occur because:
#   - a measurement was not recorded
#   - a fish was not weighed
#   - equipment failed
#   - sampling was incomplete
#   - data entry was missed
#
# Always identify and understand missing values before
# starting the analysis.

# Create an example missing value
test <- lw
head(test)
test$Weight_g[1:5] <- NA

sum(is.na(test$Weight_g))

na.omit(test)

# NEVER silently delete missing data.
# First ask why the values are missing.

# ============================================================
# 15. EXPORT RESULTS
# ============================================================

write_csv(catch_by_island, "catch_summary_by_island.csv")
write_csv(annual, "annual_catch_cpue.csv")
write_csv(length_frequency, "length_frequency.csv")

ggsave(
  "monthly_cpue.png",
  width = 8,
  height = 5,
  dpi = 300
)

