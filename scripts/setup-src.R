
Sys.setenv(
  RICU_CONFIG_PATH = file.path(rprojroot::find_root(".git/index"), "config")
)

library(ricu)

ext_dir <- src_data_dir("aumc_ext")

download_src("aumc", ext_dir)
import_src("aumc", ext_dir)
attach_src("aumc_ext")

file.symlink(ext_dir, src_data_dir("aumc_min"))
