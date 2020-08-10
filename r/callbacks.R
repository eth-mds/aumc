
apply_map <- function(x, col, map) {
  data.table::set(x, j = col, value = map[x[[col]]])
}

aumc_age <- function(x, val_var, ...) {
  apply_map(x, val_var,
    c(`18-39` = 30, `40-49` = 45, `50-59` = 55, `60-69` = 65,
      `70-79` = 75, `80+` = 90)
  )
}

aumc_weight <- function(x, val_var, ...) {
  apply_map(x, val_var,
    c(`59-`   = 50, `60-69`   = 65, `70-79` = 75, `80-89` = 85,
      `90-99` = 95, `100-109` = 105, `110+`  = 120)
  )
}

aumc_sex <- function(x, val_var, ...) {
  apply_map(x, val_var, c(Vrouw = "Female", Man = "Male"))
}

multiply_by <- function(factor) {
  factor <- force(factor)
  function(x, val_var, ...) {
    data.table::set(x, j = val_var, value = x[[val_var]] * factor)
  }
}

multiply_aumc_albu <- multiply_by(0.1)
multiply_aumc_bili <- multiply_by(0.058467)
multiply_aumc_calc <- multiply_by(4.008)
multiply_aumc_crea <- multiply_by(0.011309)
multiply_aumc_gluc <- multiply_by(18.016)
multiply_aumc_hemo <- multiply_by(1.611344)
multiply_aumc_magn <- multiply_by(2.431)
multiply_aumc_mchc <- multiply_by(1.611344)
multiply_aumc_mch  <- multiply_by(0.016114)
multiply_aumc_phos <- multiply_by(3.097521)
multiply_aumc_urea <- multiply_by(2.8)
