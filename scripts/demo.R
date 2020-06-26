
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

load_ts(aumc$admissions, id_var = "patientid")
load_ts(aumc$admissions, id_var = "admissionid")

gluc <- concept("glucose", unit = "mmol/l",
  item("aumc", "numericitems", "itemid", list(c(9947L, 6833L, 9557L)))
)

load_concepts(gluc, id_type = "patient")
load_concepts(gluc, id_type = "icustay")
