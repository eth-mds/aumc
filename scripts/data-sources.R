
root_dir <- rprojroot::find_root(".git/index")
source(file.path(root_dir, "scripts", "defaults.R"))

part <- list(
  listitems = list(col = "", breaks = 1),
  numericitems = list(col = "", breaks = 1:23
  )
)

tables <- Map(list, defaults = defaults())

tables[names(part)] <- Map(`[[<-`, tables[names(part)], "partitioning", part)

res <- list(
  list(
    name = "aumc_ext",
    id_cfg = list(
      patient = list(id = "patientid", position = 1L),
      icustay = list(id = "admissionid", position = 2L)
    ),
    tables = tables
  ),
  list(
    name = "aumc_min",
    id_cfg = list(
      icustay = "admissionid"
    ),
    tables = lapply(tables, `[`, -1L)
  )
)

ricu::set_config(res, "data-sources", file.path(root_dir, "config"))
