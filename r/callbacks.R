
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
