## Intro to R Basics: Lecture 1

## Table of Contents

#1. Load Example Internal Data
#2. Load Packages
#3. Exploratory Analysis
#4. Basic Data Visualization
#5. Load Example CSV File
#6. Advanced Data Visualization
#7. Basic Statistical Tests


############## 1. Load Example Internal Data

## Load EX Internal Data

# Print the first six rows
head(iris)

# Print the last six rows
tail(iris)

# Print the column names
colnames(iris)

# Print function
print(iris)

# Set the "Randomness"
set.seed(1292025)


############# 2. Load Packages


## Load Packages

## Install a new package
install.packages("tidyverse")
library(tidyverse) # Package that give lots of new mathematical functions
library(ggplot2) # Package for advanced data visualization
library(MetBrewer) # Package for a better color pallete
library(patchwork) # Package for combining ggplots
library(infer) # Package for greater stats
library(ggpubr) # Package for publication ready figures
library(corrplot) # Package for creating correlation matrix visualizations
library(janitor) # Package for cleaning up data
library(skimr) # Package for quick data summaries


############# 3. Exploratory Data Analysis


## Base R Exploration

# Structure of Dataset
str(iris)

# Dimensions of Dataset
dim(iris)

# Get Unique Values in Data
unique(iris$Species)

####------------------- Data Cleaning
is.na(iris) # Looks for na values within your data, does not DO ANYTHING with them

clean_names(iris) # Make names all the same case

get_dupes(iris) # ID duplicate data

test <- distinct(iris) # Select only unique values, removing data
test

tabyl(is.na(iris$Petal.Length)) # ID na values in a column

####------------------- Basic Descriptive Numerical Exploration

# Mean, Median, SD, Variance, Min/Max, Quantile
mean(iris$Petal.Length) # mean
median(iris$Petal.Length) # median 
sd(iris$Petal.Length) # standard deviation
var(iris$Petal.Length) # variance
range(iris$Petal.Length) # min/max
quantile(iris$Petal.Length) # percentiles (q1, q3, etc.)

# Basic Stat Summary of Dataset
summary(iris)

cor(iris[, 1:4]) # Correlation matrix, how variables are related, by strength and direction
cov(iris[, 1:4]) # Covariance matrix, how variables change together, one up one down = negative
# NOTE: 1:4 is the index of the columns we want to analyze

####-------------------- Basic Categorical Exploration
table(iris$Species) # Counts factor levels
prop.table(table(iris$Species)) # Proportions of data table

####-------------------- Advanced Data Exploration
skim(iris) # Faster, more comprehensive data exploration


################## 4. Basic Data Visualizations

# Basic plot comand structure
plot(x, y, type = "b", main = "Example Plot", xlab = "X values", ylab = "Y values", col = "blue", pch = 16)
## NOTE: By altering the TYPE you will change the look of the plot

# Base Sepal Width x Sepal Length
plot(iris$Sepal.Width, iris$Sepal.Length)

## Histogram
plot(iris$Sepal.Width, iris$Sepal.Length, type = "h", main = "Line Plot", xlab = "X values", ylab = "Y values", col = "blue", lwd = 2)

## Bar Plot
barplot(iris$Sepal.Width, iris$Sepal.Length, main = "Bar Plot", xlab = "Categories", ylab = "Values", col = "lightblue")

## Box Plot
boxplot(iris, main = "Box Plot", xlab = "Groups", ylab = "Values", col = c("lightgreen", "lightcoral"))

##################### 5. Load Example CSV
crops <- read.csv("Data/crop_yield_data.csv")
head(crops)


### Exploratory Data Analysis: What do YOU want to know?
skim(crops)

glm(rainfall_mm~crop_yield, data=crops)

##################### 6. Advanced Data Visualization
## Here we will be using ggplot2, the best in my opinion package for data viz in R

## Basic Syntax
ggplot(data, aes(x = x, y = y)) + 
  geom_point(color = "blue") + 
  ggtitle("Customized Plot") + 
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 12))


## Scatter Plot
ggplot(crops, aes(x = rainfall_mm, y = crop_yield)) + 
  geom_point(color = "green") + 
  ggtitle("Crop Yield x Rainfall") + 
  xlab("Rainfall (mm)") + 
  ylab("Crop Yield") +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 12))


## Line Graph
ggplot(data, aes(x = x, y = y)) + 
  geom_line(color = "red", size = 1) + 
  ggtitle("Line Plot") + 
  xlab("X values") + 
  ylab("Y values")

## Bar Graph
ggplot(data, aes(x = categories, y = values)) + 
  geom_bar(stat = "identity", fill = "skyblue") + 
  ggtitle("Bar Plot") + 
  xlab("Categories") + 
  ylab("Values")

## Box Plot
ggplot(iris, aes(x = Species, y = Petal.Length, fill=Species)) + 
  geom_boxplot(color = "black") + 
  ggtitle("Box Plot") + 
  xlab("Group") + 
  ylab("Value") +
  theme_minimal() +
  scale_fill_manual(values = c("#0B0033", "#370031", "#832232")) +
  theme(plot.title = element_text(hjust = 0.5), axis.title = element_text(size = 12))

## Histogram
ggplot(data, aes(x = value)) + 
  geom_histogram(binwidth = 0.5, fill = "lightblue", color = "black") + 
  ggtitle("Histogram") + 
  xlab("Values") + 
  ylab("Frequency")

## Density Plot
ggplot(data, aes(x = value)) + 
  geom_density(fill = "lightgreen", color = "black") + 
  ggtitle("Density Plot") + 
  xlab("Values") + 
  ylab("Density")



##################### 7. Basic Statistical Test





##--------- Using infer for data simulation

### Testing if mean speal length differs significantly from 5.8 mean population mean
##### Does OUR DATA differ from a STANDARD DATA value
iris %>%
  specify(response = Sepal.Length) %>%
  hypothesize(null = "point", mu = 5.8) %>% ## mu = hypothetical population mean
  generate(reps = 1000, type = "bootstrap") %>%
  calculate(stat = "mean") %>%
  visualize() +
  shade_p_value(obs_stat = mean(iris$Sepal.Length), direction = "two-sided")
##### Red bar is OBSERVED sample mean, if red bar falls on extremes, it is UNLIKELY under null hypothesis
#### Green FAILS and is not significant, RED represents where p-value is significantly different

### Permutation Test Against Two Groups
### Does sepal width differ between two species groups, difference in means
#### NULL = there is NO difference
iris %>%
  filter(Species %in% c("setosa", "versicolor")) %>%
  mutate(Species = factor(Species)) %>%
  specify(response = Sepal.Width, explanatory = Species) %>%
  hypothesize(null = "independence") %>%
  generate(reps = 1000, type = "permute") %>%
  calculate(stat = "diff in means", order = c("setosa", "versicolor")) %>%
  visualize() +
  shade_p_value(obs_stat = mean(iris$Sepal.Width[iris$Species == "setosa"]) - 
                  mean(iris$Sepal.Width[iris$Species == "versicolor"]),
                direction = "two-sided")
#### Green = Common result under this hypothesis, Red bar away from value, suggests there may be a difference somehwere


