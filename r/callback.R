
aumc_rate <- function(x, val_var, unit_var, rel_weight, rate_uom, env, ...) {

  mg_to_mcg <- convert_unit(binary_op(`*`, 1000), "mcg", "mg")
  hr_to_min <- convert_unit(binary_op(`/`, 60),   "min", "uur")

  res <- rm_na(x, c(unit_var, rate_uom), "any")
  res <- mg_to_mcg(res, val_var, unit_var)
  res <- hr_to_min(res, val_var, rate_uom)

  res <- add_weight(res, env, "weight")

  res <- res[!get(rel_weight), c(val_var) := get(val_var) / get("weight")]
  res <- res[get(unit_var) == "\u00b5g", c(unit_var) := "mcg"]
  res <- res[, c(unit_var) := paste(
    get(unit_var), get(rate_uom), sep = "/kg/"
  )]

  res
}

aumc_dur <- function(x, val_var, stop_var, grp_var, ...) {
  calc_dur(x, val_var, index_var(x), stop_var, grp_var)
}

aumc_death <- function(x, val_var, ...) {

  idx <- index_var(x)

  x <- x[, c(val_var) := is_true(get(idx) - get(val_var) < hours(72L))]
  x
}

aumc_base_excess <- function(x, val_var, dir_var, ...) {
  x <- x[get(dir_var) == "-", c(val_var) := -1L * get(val_var)]
  x
}

aumc_rass_transform <- function(x) as.integer(substr(x, 1L, 2L))
