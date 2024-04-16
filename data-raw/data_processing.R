library(tidyverse)
library(janitor)

# import data -------------------------------------------------------------

data_in <- readxl::read_xlsx("data-raw/MLI-I-REACH-I-ABA-I-Base-de-Donnees-I-Medina-Coura-Chateau-Sosso-Koira-.xlsx",
                             sheet = "raw") %>%
  select(1:10) %>%
  clean_names()

malirrm <- data_in

# export data -------------------------------------------------------------

usethis::use_data(malirrm, overwrite = TRUE)

# prepare dataset export files --------------------------------------------

fs::dir_create(here::here("inst", "extdata"))
write_csv(malirrm, here::here("inst", "extdata", "malirrm.csv"))
openxlsx::write.xlsx(malirrm, here::here("inst", "extdata", "malirrm.xlsx"))
