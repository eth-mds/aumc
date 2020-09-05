
aumc_weight <- new.env()

delayedAssign("patientid",
  load_concepts("weight", "aumc", verbose = FALSE, id_type = "patient"),
  assign.env = aumc_weight
)
delayedAssign("admissionid",
  load_concepts("weight", "aumc", verbose = FALSE, id_type = "icustay"),
  assign.env = aumc_weight
)

aumc_vasos <- function(x, val_var, unit_var, end_var, rel_weight,
                       rate_uom, env, ...) {

  x <- x[get(unit_var) == "mg", c(val_var, unit_var) := list(
    get(val_var) * 1000, "mcg"
  )]
  x <- x[get(rate_uom) == "uur", c(val_var, rate_uom) := list(
    get(val_var) / 60, "min"
  )]

  wgt <- get(id_var(x), envir = aumc_weight)
  res <- merge(x, wgt, all.x = TRUE)

  res <- res[!get(rel_weight), c(val_var, rel_weight) := list(
    get(val_var) / get("weight"), TRUE
  )]
  res <- res[get(rel_weight), c(unit_var) := list(
    paste0(get(unit_var), "/kg/", get(rate_uom))
  )]

  res <- res[, c("weight") := NULL]

  res
}

aumc_death <- function(x, val_var, ...) {

  idx <- index_var(x)

  x <- x[, c(val_var) := is_true(get(idx) - get(val_var) < hours(72L))]
  x
}
