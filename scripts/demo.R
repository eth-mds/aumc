
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

load_ts(aumc$admissions, id_var = "patientid")
load_ts(aumc$admissions, id_var = "admissionid")

gluc <- concept("glucose", unit = "mmol/l",
  item("aumc", "numericitems", "itemid", list(c(9947L, 6833L, 9557L)))
)

load_concepts(gluc, id_type = "patient")
load_concepts(gluc, id_type = "icustay")

load_concepts("glucose", "mimic_demo")
load_concepts("glucose", "aumc")

unique_fun <- function(...) !duplicated(data.table::setDT(list(...)))

d_items <- subset(
  aumc$numericitems, .env$unique_fun(.data$itemid, .data$item, .data$unit),
  c("itemid", "item", "unit"), part_safe = TRUE
)

load_concepts(c("age", "weight", "sex"), "aumc")
