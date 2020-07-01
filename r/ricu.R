
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
    id_col <- id_hint
  } else {
    id_col <- "admissionid"
  }

  if (!id_col %in% cols) {
    cols <- c(id_col, cols)
  }

  time_vars <- intersect(time_vars, cols)

  dat <- load_src(x, {{ rows }}, cols)

  if (!identical(id_hint, id_col)) {
    dat <- merge(dat, id_map(x, id_hint, id_col), by = id_col)
  }

  if (length(time_vars)) {

    if (!identical(id_col, "patientid")) {

      dat <- merge(dat, id_origin(x, id_col, "time_origin"), by = id_col)
      on.exit(rm_cols(dat, "time_origin", by_ref = TRUE))

      dat <- dat[, c(time_vars) := lapply(.SD, `-`, get("time_origin")),
                 .SDcols = time_vars]
    }

    dat <- dat[, c(time_vars) := lapply(.SD, ms_as_min), .SDcols = time_vars]
  }

  as_id_tbl(dat, id_vars = id_hint, by_ref = TRUE)
}

.S3method("load_difftime", "aumc_tbl", load_aumc)

aumc_windows <- function(x) {

  cfg <- sort(as_id_cfg(x), decreasing = TRUE)

  ids <- vctrs::field(cfg, "id")
  sta <- vctrs::field(cfg, "start")
  end <- vctrs::field(cfg, "end")

  tbl <- as_src_tbl(x, unique(vctrs::field(cfg, "table")))
  mis <- setdiff(sta, colnames(tbl))

  assert_that(length(mis) >= 1L)

  res <- tbl[, c(ids, intersect(sta, colnames(tbl)), end)]

  if (length(mis) > 0L) {
    res[, c(mis) := 0L]
  }

  res <- res[, c(sta, end) := lapply(.SD, ms_as_min), .SDcols = c(sta, end)]

  res <- data.table::setcolorder(res, c(ids, sta, end))
  res <- rename_cols(res, c(ids, paste0(ids, "_start"),
                                 paste0(ids, "_end")), by_ref = TRUE)

  as_id_tbl(res, ids[2L], by_ref = TRUE)
}

.S3method("id_win_helper", "aumc_env", aumc_windows)
