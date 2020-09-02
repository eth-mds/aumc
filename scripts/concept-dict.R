
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

wrap_lst <- function(...) wrap_src(lapply(Map(list, ...), list))
wrap_src <- function(x) Map(list, sources = Map(list, aumc = x))

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
  urine = 8794
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
  bun = c(9943, 6850)
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
    "transform_fun(binary_op(`*`, 2.8))"
  )
)

drg_itms <- list(
  norepi = 7229,
  epi = 6818,
  dopa = 7179,
  dobu = 7178
)

drg_itms <- wrap_lst(ids = prep_ids(drg_itms), table = "drugitems",
                      sub_var = "itemid", end_var = "stop",
                      rel_weight = "doserateperkg", rate_uom = "doserateunit",
                      callback = "aumc_vasos")

gcs_itms <- wrap_src(
  list(
    egcs = Map(list, ids = c(6732L, 13077L), table = rep("listitems", 2L),
      sub_var = rep("itemid", 2L),
      callback = strip_ws(c(
        "apply_map(
          c(`Geen reactie`               = 1,
            `Reactie op pijnprikkel`     = 2,
            `Reactie op verbale prikkel` = 3,
            `Spontane reactie`           = 4)
        )",
        "apply_map(
          c(`Niet`                       = 1,
            `Op pijn`                    = 2,
            `Op aanspreken`              = 3,
            `Spontaan`                   = 4)
        )"
      ))
    ),
    mgcs = Map(list, ids = c(6734L, 13072L), table = rep("listitems", 2L),
      sub_var = rep("itemid", 2L),
      callback = strip_ws(c(
        "apply_map(
          c(`Geen reactie`                         = 1,
            `Strekken`                             = 2,
            `Decortatie reflex (abnormaal buigen)` = 3,
            `Spastische reactie (terugtrekken)`    = 4,
            `Localiseert pijn`                     = 5,
            `Volgt verbale commando's op`          = 6)
        )",
        "apply_map(
          c(`Geen reactie`                         = 1,
            `Strekken op pijn`                     = 2,
            `Abnormaal buigen bij pijn`            = 3,
            `Terugtrekken bij pijn`                = 4,
            `Localiseren pijn`                     = 5,
            `Voert opdrachten uit`                 = 6)
        )"
      ))
    ),
    vgcs = Map(list, ids = c(6735L, 13066L), table = rep("listitems", 2L),
      sub_var = rep("itemid", 2L),
      callback = strip_ws(c(
        "apply_map(
          c(`Geen reactie (geen zichtbare poging tot praten)` = 1,
            `Onbegrijpelijke geluiden`                        = 2,
            `Onduidelijke woorden (pogingen tot communicatie,
             maar onduidelijk)`                               = 3,
            `Verwarde conversatie`                            = 4,
            `Helder en adequaat (communicatie mogelijk)`      = 5)
        )",
        "apply_map(
          c(`Geen geluid`            = 1,
            `Onverstaanbare woorden` = 2,
            `Onjuiste woorden`       = 3,
            `Verwarde taal`          = 4,
            `Georiënteerd`           = 5)
        )"
      ))
    ),
    trach = list(
      list(ids = 6735L, table = "listitems", sub_var = "itemid",
           callback = "transform_fun(comp_na(`==`, 'Geïntubeerd'))")
    )
  )
)

dem_itms <- wrap_lst(
  val_var = c(age = "agegroup", weight = "weightgroup", sex = "gender"),
  table = "admissions",
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

cfg <- wrap_src(
  list(
    vent_start = list(
      list(ids = 9328L, sub_var = "itemid", table = "processitems",
           callback = "transform_fun(set_true)")
    ),
    vent_end = list(
      list(ids = 9328L, sub_var = "itemid", index_var = "stop",
           table = "processitems", callback = "transform_fun(set_true)")
    ),
    ins = list(
      list(ids = c(6929, 4218, 2663), sub_var = "itemid",
           table = "drugitems")
    ),
    abx = list(
      list(ids = c(
            2L,    13L,    19L,    24L,    28L,    29L,    57L,    59L,
           82L,   103L,   240L,   247L,   333L,  1133L,  1199L,  1300L,
         1371L,  1795L,  2284L,  2834L,  3237L,  3741L,  5576L,  6834L,
         6847L,  6871L,  6919L,  6948L,  6953L,  6958L,  7044L,  7064L,
         7185L,  7187L,  7208L,  7227L,  7235L,  8064L,  8394L,  8942L,
         9029L,  9030L,  9052L,  9070L,  9117L,  9128L,  9133L,  9142L,
         9151L,  9152L, 12262L, 12389L, 12398L, 12956L, 12997L, 13057L,
        13094L, 13102L, 15591L, 18860L, 19137L, 19773L, 20563L, 23166L,
        24241L, 25776L, 27617L, 29321L), table = "drugitems",
      sub_var = "itemid", callback = "transform_fun(set_true)")
    ),
    death = list(
      list(val_var = "dateofdeath", table = "admissions",
           callback = "transform_fun(Negate(is.na))", class = "col_itm")
    )
  )
)

cfg <- c(cbk_itms, num_itms, drg_itms, dem_itms, gcs_itms, cfg)
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
