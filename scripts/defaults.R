
defaults <- function() {
  list(
    admissions = list(
      index_var = "admittedat",
      time_vars = c("admittedat", "dischargedat", "dateofdeath")
    ),
    drugitems = list(
      index_var = "start",
      val_var = "dose",
      unit_var = "doseunit",
      time_vars = c("start", "stop")
    ),
    freetextitems = list(
      index_var = "measuredat",
      id_var = "value",
      time_vars = c("measuredat", "registeredat", "updatedat")
    ),
    listitems = list(
      index_var = "measuredat",
      val_var = "value",
      time_vars = c("measuredat", "registeredat", "updatedat")
    ),
    numericitems = list(
      index_var = "measuredat",
      val_var = "value",
      unit_var = "unit",
      time_vars = c("measuredat", "registeredat", "updatedat")
    ),
    procedureorderitems = list(
      index_var = "registeredat",
      val_var = "item",
      time_vars = "registeredat"
    ),
    processitems = list(
      index_var = "start",
      val_var = "item",
      time_vars = c("start", "stop")
    )
  )
}
