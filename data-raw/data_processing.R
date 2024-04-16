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


# create dictionariy ------------------------------------------------------

library(tibble)

get_variable_info <- function(data, directory = "", file_name = "") {
  total_variables <- sum(sapply(data, function(df) length(names(df))))

  variable_info <- tibble(
    directory = character(total_variables),
    file_name = character(total_variables),
    variable_name = character(total_variables),
    variable_type = character(total_variables),
    description = character(total_variables)
  )

  index <- 1

  for (i in seq_along(data)) {
    dataframe <- data[[i]]
    variable_names <- names(dataframe)
    variable_types <- sapply(dataframe, typeof)

    num_variables <- length(variable_names)
    variable_info$variable_name[index:(index + num_variables - 1)] <- variable_names
    variable_info$variable_type[index:(index + num_variables - 1)] <- variable_types
    variable_info$file_name[index:(index + num_variables - 1)] <- rep(file_name[i], num_variables)
    variable_info$directory[index:(index + num_variables - 1)] <- rep(directory[i], num_variables)

    index <- index + num_variables
  }

  return(variable_info)
}


# Specify values for directory and file_name
directories <- c("data/")
file_names <- c("malirrm.rda")

dictionary <- get_variable_info(data = list(malirrm),
                                directory = directories,
                                file_name = file_names)
dictionary |>
  write_csv("data-raw/dictionary.csv")

dictionary |>
  openxlsx::write.xlsx("data-raw/dictionary.xlsx")


# generate roxygen docs ---------------------------------------------------

openwashdata::generate_roxygen_docs("data-raw/dictionary.csv",
                                    "r/malirrm.R",
                                    df_name = "malirrm")
