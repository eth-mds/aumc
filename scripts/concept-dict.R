
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

wrap_list <- function(...) {
  x <- Map(list, ...)
  x <- lapply(x, list)
  x <- Map(list, aumc = x)
  Map(list, sources = x)
}

prep_ids <- function(x) lapply(lapply(x, as.integer), sort)

strip_ws <- function(x) gsub("\\s+", " ", x)

num_itms <- list(
  hct = c(11423, 11545, 6777),
  plt = c(9964, 6797, 10409, 14252),
  wbc = c(9965, 6779),
  na = c(9924, 6840, 9555, 10284),
  k = c(9927, 9556, 6835, 10285),
  crp = c(10079, 6825),
  ck = c(11998, 6822),
  alt = c(11978, 6800),
  ast = c(11990, 6806),
  lact = c(10053, 6837, 9580),
  alp = c(11984, 6803),
  cai = c(10267, 6815, 9560, 8915, 9561),
  ph = c(12310, 6848),
  pco2 = c(6846, 9990, 21213),
  po2 = c(7433, 9996, 21214),
  be = c(9994, 6807),
  bicar = c(9992, 6810),
# anion_gap = c(9559, 8492),
  o2sat = c(6709, 12311, 8903),
  fio2 = 12279,
  cl = 9930,
  mcv = 9968,
  lymph = 14258,
  inr_pt = 11893,
  ptt = 17982,
  basos = 14256,
  tnt = 10407,
  methb = 11692,
  hr = 6640,
  resp = c(8874, 12266),
  sbp = 6641,
  map = 6642,
  dbp = 6643,
  urine = 8794,
  tgcs = 6732,
  egcs = 13077,
  vgcs = 13066,
  mgcs = 13072
)

num_itms <- wrap_list(ids = prep_ids(num_itms), table = "numericitems",
                      sub_var = "itemid")

cbk_itms <- list(
  alb = c(9937, 6801),
  bili = c(9945, 6813),
  ca = c(9933, 6817),
  crea = c(9941, 6836, 14216),
  glu = c(9947, 6833, 9557),
  hgb = c(9960, 6778, 10286, 19703, 9553),
  mg = c(9952, 6839),
  mchc = 18666,
  mch = 11679,
  phos = c(9935, 6828),
  bun = c(9943, 6850)
)

cbk_itms <- wrap_list(ids = prep_ids(cbk_itms), table = "numericitems",
  sub_var = "itemid", callback = c(
    "transform_fun(binary_op(`*`, 0.1))",
    "transform_fun(binary_op(`*`, 0.058467))",
    "transform_fun(binary_op(`*`, 4.008))",
    "transform_fun(binary_op(`*`, 0.011309))",
    "transform_fun(binary_op(`*`, 18.016))",
    "transform_fun(binary_op(`*`, 1.611344))",
    "transform_fun(binary_op(`*`, 2.431))",
    "transform_fun(binary_op(`*`, 1.611344))",
    "transform_fun(binary_op(`*`, 0.016114))",
    "transform_fun(binary_op(`*`, 3.097521))",
    "transform_fun(binary_op(`*`, 2.8))"
  )
)

drg_itms <- list(
  norepi = 8676,
  dopa = 6983,
  ins = c(6929, 4218, 2663),
  dobu = 1442
)

drg_itms <- wrap_list(ids = prep_ids(drg_itms), table = "drugitems",
                      sub_var = "itemid")

dem_itms <- wrap_list(table = "admissions",
  itm_vars = c("agegroup", "weightgroup", "gender"),
  callback = strip_ws(
    c("apply_map(c(`18-39` = 30, `40-49`   = 45, `50-59` = 55, `60-69` = 65,
                   `70-79` = 75, `80+`     = 90))",
      "apply_map(c(`59-`   = 50, `60-69`   = 65, `70-79` = 75, `80-89` = 85,
                  `90-99`  = 95, `100-109` = 105, `110+` = 120))",
      "apply_map(c(Vrouw   = 'Female', Man = 'Male'))"
    )
  ),
  class = "col_itm"
)

cfg <- c(cbk_itms, num_itms, drg_itms, dem_itms)
cfg <- cfg[order(names(cfg))]

cfg <- lapply(cfg, function(x) {

  if ("sources" %in% names(x)) {

    if ("mimic" %in% names(x[["sources"]]))
      x[["sources"]] <- c(x[["sources"]],
                          mimic_demo = list(x[["sources"]][["mimic"]]))

    if ("eicu" %in% names(x[["sources"]]))
      x[["sources"]] <- c(x[["sources"]],
                          eicu_demo = list(x[["sources"]][["eicu"]]))

    x[["sources"]] <- x[["sources"]][order(names(x[["sources"]]))]
  }

  x
})

ricu::set_config(cfg, "concept-dict", config_dir)
