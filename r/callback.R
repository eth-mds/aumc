
aumc_base_excess <- function(x, val_var, dir_var, ...) {
  x <- x[get(dir_var) == "-", c(val_var) := -1L * get(val_var)]
  x
}
