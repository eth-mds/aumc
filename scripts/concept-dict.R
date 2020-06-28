
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

cfg <- list(
  heart_rate = list(
    sources = list(
      aumc = list(
        list(ids = 6640L, table = "numericitems", sub_var = "itemid")
      )
    )
  ),
  new_hr = list(
    unit = c("bpm", "/min"),
    min = 0,
    max = 300,
    sources = list(
      mimic = list(
        list(ids = c(211L, 220045L), table = "chartevents", sub_var = "itemid",
             callback = "test_callback")
      ),
      eicu = list(
        list(table = "vitalperiodic", itm_vars = "heartrate",
             class = "col_itm")
      ),
      hirid = list(
        list(ids = 200L, table = "observations", sub_var = "variableid")
      ),
      aumc = list(
        list(ids = 6640L, table = "numericitems", sub_var = "itemid")
      )
    )
  )
)

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
