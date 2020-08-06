
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

wrap_list <- function(x, ...) {
  x <- lapply(x, as.integer)
  x <- Map(list, ids = x, ...)
  x <- lapply(x, list)
  x <- Map(list, aumc = x)
  x <- Map(list, sources = x)
}

num_itms <- list(
  creatinine = c(9941, 6836, 14216),
  urea_nitrogen = c(9943, 6850),
  hemoglobin = c(9960, 6778, 10286, 19703, 9553),
  hematocrit = c(11423, 11545, 6777),
  platelet_count = c(9964, 6797, 10409, 14252),
  white_blood_cells = c(9965, 6779),
  sodium = c(9924, 6840, 9555, 10284),
  potassium = c(9927, 9556, 6835, 10285),
  magnesium = c(9952, 6839),
  c_reactive_protein = c(10079, 6825),
  phosphate = c(9935, 6828),
  creatine_kinase = c(11998, 6822),
  albumin = c(9937, 6801),
  alanine_aminotransferase = c(11978, 6800),
  asparate_aminotransferase = c(11990, 6806),
  lactate = c(10053, 6837, 9580),
  alkaline_phosphatase = c(11984, 6803),
  bilirubin_total = c(9945, 6813),
  calcium = c(9933, 6817),
  calcium_ionized = c(10267, 6815, 9560, 8915, 9561),
  ph = c(12310, 6848),
  pa_co2 = c(6846, 9990, 21213),
  pa_o2 = c(7433, 9996, 21214),
  base_excess = c(9994, 6807),
  bicarbonate = c(9992, 6810),
  anion_gap = c(9559, 8492),
  glucose = c(9947, 6833, 9557),
  o2_saturation = c(12311, 8903),
  fi_o2 = 12279, chloride = 9930,
  mcv = 9968,
  mch = 11679,
  mchc = 18666,
  lymphocytes = 14258,
  inr_pt = 11893,
  ptt = 17982,
  basophils = 14256,
  troponin_t = 10407,
  methemoglobin = 11692,
  heart_rate = 6640,
  o2_saturation = 6709,
  respiratory_rate = c(8874, 12266),
  systolic_bp = 6641,
  mean_bp = 6642,
  diastolic_bp = 6643,
  urine_out = 8794,
  gcs_total = 6732,
  gcs_eye = 13077,
  gcs_verbal = 13066,
  gcs_motor = 13072
)

num_itms <- wrap_list(num_itms, table = "numericitems", sub_var = "itemid")

drg_itms <- list(
  norepinephrine = 8676,
  dopamine = 6983,
  insulin = c(6929, 4218, 2663),
  dobutamine = 1442
)

drg_itms <- wrap_list(drg_itms, table = "drugitems", sub_var = "itemid")

cfg <- c(num_itms, drg_itms)
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
