
r_dir <- file.path(rprojroot::find_root(".git/index"), "r")
invisible(lapply(list.files(r_dir, full.names = TRUE), source))

load_ts(aumc_ext$admissions, id_var = "patientid")
load_ts(aumc_ext$admissions, id_var = "admissionid")

load_ts(aumc_ext$processitems, itemid == 9159, id_var = "patientid")
load_ts(aumc_ext$processitems, itemid == 9159, id_var = "admissionid")

gluc <- concept("glucose", unit = "mmol/l",
  item("aumc_ext", "numericitems", "itemid", list(c(9947L, 6833L, 9557L)))
)

load_concepts(gluc, id_type = "patient")
load_concepts(gluc, id_type = "icustay")

concept_availability()

load_concepts(c("glu", "alb"), "aumc_ext")
load_concepts(c("alb", "weight"), "aumc_ext")
