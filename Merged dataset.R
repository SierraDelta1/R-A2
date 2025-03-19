# Load necessary libraries
library(dplyr)
library(tidyr)
library(readr)

# Read the datasets
urban_rural <- read_csv("/Users/saikattiyashas/Library/CloudStorage/OneDrive-NationalUniversityofIreland,Galway/Subjects Sem 2/Applied Analytics/A2/A2Git/urban-and-rural-population_updated.csv")
gdp_data <- read_csv("/Users/saikattiyashas/Library/CloudStorage/OneDrive-NationalUniversityofIreland,Galway/Subjects Sem 2/Applied Analytics/A2/A2Git/GDP_per_capita_data_updated.csv")
pop_density <- read_csv("/Users/saikattiyashas/Library/CloudStorage/OneDrive-NationalUniversityofIreland,Galway/Subjects Sem 2/Applied Analytics/A2/A2Git/Population_Density.csv")

# Convert GDP data from wide to long format
gdp_long <- gdp_data %>%
  pivot_longer(cols = starts_with("19"):starts_with("20"), 
               names_to = "Year", 
               values_to = "GDP_per_capita") %>%
  mutate(Year = as.integer(Year)) %>%
  select(Country_Name, Country_Code, Year, GDP_per_capita)

# Convert Population Density data from wide to long format
pop_density_long <- pop_density %>%
  pivot_longer(cols = starts_with("19"):starts_with("20"), 
               names_to = "Year", 
               values_to = "Population_Density") %>%
  mutate(Year = as.integer(Year)) %>%
  select(Country_Name, Country_Code, Year, Population_Density)

# Merge datasets using dplyr
merged_data <- urban_rural %>%
  left_join(gdp_long, by = c("Country_Code", "Year")) %>%
  left_join(pop_density_long, by = c("Country_Code", "Year")) %>%
  select(Country_Name = Country_Name.x, Country_Code, Year, 
         Urban_population, Rural_population, GDP_per_capita, Population_Density)

# View the first few rows
head(merged_data)

# Save the merged dataset
write_csv(merged_data, "merged_dataset.csv")
