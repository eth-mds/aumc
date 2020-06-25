
library(ricu)

check_col <- function(nme, cols, sort = NULL) {

  tbl <- aumc[[nme]]

  typ <- rep("-", ncol(tbl))
  typ[match(cols, colnames(tbl))] <- "c"

  if (!is.null(sort)) {
    typ[match(sort, colnames(tbl))] <- "i"
  }

  callback <- function(x, pos, ...) {
    for (col in cols) {
      x[[col]] <- bit64::as.integer64(x[[col]])
    }
    x
  }

  callback <- readr::DataFrameCallback$new(callback)

  ori <- readr::read_csv_chunked(
    paste0("/Users/nbennett/Polybox/nbennett/aumc-data/", nme, ".csv"),
    callback, 10 ^ 7, col_types = paste0(typ, collapse = "")
  )

  if (!is.null(sort)) {
    ori <- ori[order(ori[[sort]]), ]
  }

  vapply(cols, function(col) {
    dif <- as.integer(bit64::as.integer64(tbl[[col]]) - ori[[col]])
    max(abs(dif), na.rm = TRUE)
  }, integer(1L))
}

import_src("aumc")
attach_src("aumc")

check_col("admissions", c("admittedat", "dischargedat", "dateofdeath"))

check_col("drugitems", c("start", "stop"))

check_col("freetextitems", c("measuredat", "registeredat", "updatedat"))

check_col("listitems", c("measuredat", "registeredat", "updatedat"), "itemid")

check_col("numericitems", c("measuredat", "registeredat", "updatedat"),
          "itemid")

check_col("processitems", c("start", "stop"))
