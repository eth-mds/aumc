
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

download_src("aumc", src_data_dir("aumc_ext"))
import_src("aumc", src_data_dir("aumc_ext"))
attach_src("aumc_ext")
