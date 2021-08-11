
ms_as_min <- function(x) as.difftime(as.integer(x / 6e4), units = "mins")

if (base::getRversion() < "4.0.0") {

  .S3method <- function(generic, class, method) {

    if(missing(method)) {
      method <- paste(generic, class, sep = ".")
    }

    method <- match.fun(method)

    registerS3method(generic, class, method, envir = parent.frame())

    invisible(NULL)
  }
}

load_aumc <- function(x, rows, cols = colnames(x), id_hint = id_vars(x),
                      time_vars = ricu::time_vars(x), ...) {

  if (id_hint %in% colnames(x)) {
    id_sel <- id_hint
  } else {
    id_opt <- id_var_opts(sort(as_id_cfg(x), decreasing = TRUE))
    id_sel <- intersect(id_opt, colnames(x))[1L]
  }

  stopifnot(is.character(id_sel), length(id_sel) == 1L)

  if (!id_sel %in% cols) {
    cols <- c(id_sel, cols)
  }

  time_vars <- intersect(time_vars, cols)

  dat <- load_src(x, {{ rows }}, cols)
  dat <- dat[, c(time_vars) := lapply(.SD, ms_as_min), .SDcols = time_vars]

  as_id_tbl(dat, id_vars = id_sel, by_ref = TRUE)
}

.S3method("load_difftime", "aumc_ext_tbl", load_aumc)
.S3method("load_difftime", "aumc_min_tbl", load_aumc)

aumc_windows <- function(x) {

  ids <- c("admissionid", "patientid")
  sta <- c("admittedat", "firstadmittedat")
  end <- c("dischargedat", "dateofdeath")

  tbl <- as_src_tbl(x, "admissions")

  res <- tbl[, c(ids, sta[1L], end)]
  res <- res[, c(sta[2L]) := 0L]
  res <- res[, c(sta, end) := lapply(.SD, ms_as_min), .SDcols = c(sta, end)]

  res <- data.table::setcolorder(res, c(ids, sta, end))
  res <- rename_cols(res, c(ids, paste0(ids, "_start"),
                                 paste0(ids, "_end")), by_ref = TRUE)

  as_id_tbl(res, ids[2L], by_ref = TRUE)
}

.S3method("id_win_helper", "aumc_ext_env", aumc_windows)
