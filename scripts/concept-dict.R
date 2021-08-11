
root_dir <- rprojroot::find_root(".git/index")
source(file.path(root_dir, "scripts", "defaults.R"))

add_vars <- function(x) {
  vars <- Map(`[[`, list(defaults()), lapply(x, `[[`, "table"))
  Map(`[<-`, x, lapply(vars, names), vars)
}

wrap_lst <- function(...) {
  wrap_src(lapply(Map(list, ...), list))
}

wrap_src <- function(x, vars) {
  Map(
    list,
    sources = Map(list, aumc_ext = x, aumc_min = lapply(x, add_vars))
  )
}

prep_ids <- function(x) {
  lapply(lapply(x, as.integer), sort)
}

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
  bicar = c(9992, 6810),
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
  ckmb = 6824,
  esr = c(6808, 11902),
  fgn = c(6776, 9989, 10175),
  pt = 6789,
  hbco = 11690,
  hba1c = c(11812, 16166),
  temp = c(8658, 16110, 13952),
  bili_dir = 6812,
  eos = 6773,
  neut = 6786,
  bnd = c(6796, 11586),
  rbc = c(6774, 9962),
  rdw = 18952
)

num_itms <- wrap_lst(ids = prep_ids(num_itms), table = "numericitems",
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
  bun = c(9943, 6850),
  etco2 = c(6707, 8884, 8885, 9658, 12805, 12356),
  be = c(9994, 6807)
)

cbk_itms <- wrap_lst(ids = prep_ids(cbk_itms), table = "numericitems",
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
    "transform_fun(binary_op(`*`, 2.8))",
    "convert_unit(binary_op(`*`, 7.6), 'mmHg', 'None|Geen')",
    "aumc_base_excess"
  )
)

cbk_itms$be$sources$aumc_ext[[1L]][["dir_var"]] <- "tag"

cfg <- c(cbk_itms, num_itms)
cfg <- cfg[order(names(cfg))]

ricu::set_config(cfg, "concept-dict", file.path(root_dir, "config"))
