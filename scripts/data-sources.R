
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

info <- list(
  admissions = list(
    patientid = list(spec = "col_integer"),
    admissionid = list(spec = "col_integer"),
    admissioncount = list(spec = "col_integer"),
    location = list(spec = "col_character"),
    urgency = list(spec = "col_logical"),
    origin = list(spec = "col_character"),
    admittedat = list(spec = "col_double"),
    admissionyeargroup = list(spec = "col_character"),
    dischargedat = list(spec = "col_double"),
    lengthofstay = list(spec = "col_integer"),
    destination = list(spec = "col_character"),
    gender = list(spec = "col_character"),
    agegroup = list(spec = "col_character"),
    dateofdeath = list(spec = "col_double"),
    weightgroup = list(spec = "col_character"),
    weightsource = list(spec = "col_character"),
    specialty = list(spec = "col_character")
  ),
  drugitems = list(
    admissionid = list(spec = "col_integer"),
    orderid = list(spec = "col_integer"),
    ordercategoryid = list(spec = "col_integer"),
    ordercategory = list(spec = "col_character"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    isadditive = list(spec = "col_logical"),
    isconditional = list(spec = "col_logical"),
    rate = list(spec = "col_double"),
    rateunit = list(spec = "col_character"),
    rateunitid = list(spec = "col_integer"),
    ratetimeunitid = list(spec = "col_integer"),
    doserateperkg = list(spec = "col_logical"),
    dose = list(spec = "col_double"),
    doseunit = list(spec = "col_character"),
    doserateunit = list(spec = "col_character"),
    doseunitid = list(spec = "col_integer"),
    doserateunitid = list(spec = "col_integer"),
    administered = list(spec = "col_double"),
    administeredunit = list(spec = "col_character"),
    administeredunitid = list(spec = "col_integer"),
    action = list(spec = "col_character"),
    start = list(spec = "col_double"),
    stop = list(spec = "col_double"),
    duration = list(spec = "col_integer"),
    solutionitemid = list(spec = "col_integer"),
    solutionitem = list(spec = "col_character"),
    solutionadministered = list(spec = "col_double"),
    solutionadministeredunit = list(spec = "col_character"),
    fluidin = list(spec = "col_double"),
    iscontinuous = list(spec = "col_logical")
  ),
  freetextitems = list(
    admissionid = list(spec = "col_integer"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    value = list(spec = "col_character"),
    comment = list(spec = "col_character"),
    measuredat = list(spec = "col_double"),
    registeredat = list(spec = "col_double"),
    registeredby = list(spec = "col_character"),
    updatedat = list(spec = "col_double"),
    updatedby = list(spec = "col_character"),
    islabresult = list(spec = "col_logical")
  ),
  listitems = list(
    admissionid = list(spec = "col_integer"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    valueid = list(spec = "col_integer"),
    value = list(spec = "col_character"),
    measuredat = list(spec = "col_double"),
    registeredat = list(spec = "col_double"),
    registeredby = list(spec = "col_character"),
    updatedat = list(spec = "col_double"),
    updatedby = list(spec = "col_character"),
    islabresult = list(spec = "col_logical")
  ),
  numericitems = list(
    admissionid = list(spec = "col_integer"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    tag = list(spec = "col_character"),
    value = list(spec = "col_double"),
    unitid = list(spec = "col_integer"),
    unit = list(spec = "col_character"),
    comment = list(spec = "col_character"),
    measuredat = list(spec = "col_double"),
    registeredat = list(spec = "col_double"),
    registeredby = list(spec = "col_character"),
    updatedat = list(spec = "col_double"),
    updatedby = list(spec = "col_character"),
    islabresult = list(spec = "col_logical"),
    fluidout = list(spec = "col_double")
  ),
  procedureorderitems = list(
    admissionid = list(spec = "col_integer"),
    orderid = list(spec = "col_integer"),
    ordercategoryid = list(spec = "col_integer"),
    ordercategoryname = list(spec = "col_character"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    registeredat = list(spec = "col_double"),
    registeredby = list(spec = "col_character")
  ),
  processitems = list(
    admissionid = list(spec = "col_integer"),
    itemid = list(spec = "col_integer"),
    item = list(spec = "col_character"),
    start = list(spec = "col_double"),
    stop = list(spec = "col_double"),
    duration = list(spec = "col_integer")
  )
)

tables <- names(info)

cols <- lapply(info, function(tbl) {
  Map(function(name, spec) c(list(name = name, col = name), spec),
      names(tbl), tbl, USE.NAMES = FALSE)
})

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

n_row <- list(
  admissions = 23106L,
  drugitems = 4907269L,
  freetextitems = 651248L,
  listitems = 30744065L,
  numericitems = 977625612L,
  procedureorderitems = 2188626L,
  processitems = 256715L
)

part <- list(
  listitems = list(col = "itemid", breaks = 12290L),
  numericitems = list(col = "itemid", breaks = c(
     6641L,  6642L,  6643L,  6664L,  6666L,  6667L,  6669L,  6672L,  6673L,
     6675L,  6707L,  6709L,  8874L, 12270L, 12275L, 12278L, 12281L, 12286L,
    12303L, 12561L, 12576L, 12804L, 14841L)
  )
)

tables <- Map(list, name = tables, files = paste0(tables, ".csv"),
               defaults = defaults[tables], num_rows = n_row[tables],
               cols = cols[tables])

tables[names(part)] <- Map(`[[<-`, tables[names(part)], "partitioning", part)

res <- list(
  name = "aumc",
  url = "https://www.amsterdammedicaldatascience.nl",
  id_cfg = list(
    patient = list(id = "patientid", position = 1L, end = "dateofdeath",
                   table = "admissions"),
    icustay = list(id = "admissionid", position = 2L, start = "admittedat",
                   end = "dischargedat", table = "admissions")
  ),
  tables = unname(tables)
)

ricu::set_config(list(res), "data-sources", config_dir())
