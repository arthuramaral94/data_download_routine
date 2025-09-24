##Download single data

# Load required library
if (!require("httr")) install.packages("httr", dependencies = TRUE)
library(httr)

# Define the file containing links
links_file <- "CHIRPS_2006.txt"

# Read the links from the file
links <- readLines(links_file)

# Create a directory to save downloaded files
dir.create("chirps_data_2006", showWarnings = FALSE)

# Function to download files
download_files <- function(url) {
  filename <- paste0("chirps_data_2006/", basename(url))
  if (!file.exists(filename)) {
    tryCatch({
      cat("Downloading:", url, "\n")
      GET(url, write_disk(filename, overwrite = TRUE))
    }, error = function(e) {
      cat("Error downloading:", url, "\n")
    })
  } else {
    cat("File already exists:", filename, "\n")
  }
}

# Loop through each link and download the file
sapply(links, download_files)

cat("Download completed.\n")

## ----------------------------------------------------------------------------

## Download multiple datas

# Load required library
if (!require("httr")) install.packages("httr", dependencies = TRUE)
library(httr)

# Define the file containing links for 2006
links_file <- "CHIRPS_2007.txt"

# Read the links from the file
links <- readLines(links_file)

# Identify the base year and target years
base_year <- 2007
target_years <- 2007:2024  # Years for which we need to modify links and download data

# Function to modify links for a given year
modify_links <- function(links, old_year, new_year) {
  updated_links <- gsub(paste0("/", old_year, "/"), paste0("/", new_year, "/"), links)
  updated_links <- gsub(paste0("\\.", old_year, "\\."), paste0(".", new_year, "."), updated_links)
  return(updated_links)
}

# Function to download files
download_files <- function(url, year) {
  folder <- paste0("chirps_data_", year)
  dir.create(folder, showWarnings = FALSE)  # Create folder for each year
  
  filename <- file.path(folder, basename(url))
  
  if (!file.exists(filename)) {
    tryCatch({
      cat("Downloading:", url, "\n")
      GET(url, write_disk(filename, overwrite = TRUE))
    }, error = function(e) {
      cat("Error downloading:", url, "\n")
    })
  } else {
    cat("File already exists:", filename, "\n")
  }
}

# Loop through each target year, modify links, and download data
for (year in target_years) {
  cat("Processing year:", year, "\n")
  
  # Modify links for the current year
  updated_links <- modify_links(links, base_year, year)
  
  # Download each file
  sapply(updated_links, download_files, year = year)
}

cat("Download completed for all years.\n")
