
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

defaults <- list(
  admissions = list(
    index_var = "admittedat",
    time_vars = c("admittedat", "dischargedat", "dateofdeath")
  ),
  drugitems = list(
    index_var = "start",
    val_var = "dose",
    unit_var = "doseunit",
    time_vars = c("start", "stop")
  ),
  freetextitems = list(
    index_var = "measuredat",
    id_var = "value",
    time_vars = c("measuredat", "registeredat", "updatedat")
  ),
  listitems = list(
    index_var = "measuredat",
    val_var = "value",
    time_vars = c("measuredat", "registeredat", "updatedat")
  ),
  numericitems = list(
    index_var = "measuredat",
    val_var = "value",
    unit_var = "unit",
    time_vars = c("measuredat", "registeredat", "updatedat")
  ),
  procedureorderitems = list(
    index_var = "registeredat",
    val_var = "item",
    time_vars = "registeredat"
  ),
  processitems = list(
    index_var = "start",
    val_var = "item",
    time_vars = c("start", "stop")
  )
)

part <- list(
  listitems = list(col = "itemid", breaks = 1),
  numericitems = list(col = "itemid", breaks = 1:23
  )
)

tables <- Map(list, defaults = defaults)

tables[names(part)] <- Map(`[[<-`, tables[names(part)], "partitioning", part)

res <- list(
  name = "aumc_ext",
  id_cfg = list(
    patient = list(id = "patientid", position = 1L),
    icustay = list(id = "admissionid", position = 2L)
  ),
  tables = tables
)

ricu::set_config(list(res), "data-sources", config_dir)
