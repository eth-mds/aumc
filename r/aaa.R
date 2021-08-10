
proj_root <- function() rprojroot::find_root(".git/index")

config_dir <- file.path(proj_root(), "config")
sources <- c("mimic", "mimic_demo", "eicu", "eicu_demo", "hirid", "aumc",
             "aumc_ext", "miiv")

Sys.setenv(RICU_SRC_LOAD = paste(sources, collapse = ","),
           RICU_CONFIG_PATH = config_dir)

library(ricu)
library(assertthat)
