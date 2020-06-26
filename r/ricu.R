
load_aumc <- function(x, rows, cols = colnames(x), id_hint = id_vars(x),
                      time_vars = ricu::time_vars(x), ...) {

  as_difftim <- function(x) as.difftime(as.integer(x / 6e4), units = "mins")

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
    dat <- merge(dat, aumc_map(c(id_hint, id_col)), by = id_col)
  }

  if (length(time_vars)) {

    if (!identical(id_col, "patientid")) {

      dat <- merge(dat, aumc_map(c(id_col, "admittedat")), by = id_col)
      on.exit(rm_cols(dat, "time_origin", by_ref = TRUE))

      dat <- dat[, c(time_vars) := lapply(.SD, `-`, get("time_origin")),
                 .SDcols = time_vars]
    }

    dat <- dat[, c(time_vars) := lapply(.SD, as_difftim), .SDcols = time_vars]
  }

  as_id_tbl(dat, id_vars = id_hint, by_ref = TRUE)
}

aumc_map <- memoise::memoise(

  function(cols = c("patientid", "admissionid", "admittedat")) {

    tbl <- as_src_tbl("admissions", "aumc")

    rename_cols(tbl[, cols], "time_origin", "admittedat", skip_absent = TRUE,
                by_ref = TRUE)
  }
)

.S3method("load_difftime", "aumc_tbl", load_aumc)
