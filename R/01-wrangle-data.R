# load packages
source(here::here("R/00-package-loading.R"))

#read in data
raw_data <- read_csv(here("data", "raw-data", "exam1.csv"))

proc_data <- rename_with(raw_data, to_snake_case)

write.csv(proc_data, file="data/processed-data/processed_data.csv")

dist <- proc_data$distance_km
err <- proc_data$error_m

save(dist, err, file="data/processed-data/my-data.rda")
