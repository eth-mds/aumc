
<!-- README.md is generated from README.Rmd. Please edit that file -->

Setting up and using [`ricu`](https://cran.r-project.org/package=ricu)
to access the publicly available ICU database
[AmsterdamUMCdb](https://github.com/AmsterdamUMC/AmsterdamUMCdb) of
[Amsterdam UMC](https://www.amsterdamumc.nl).

-----

**With release of `ricu` version 0.2.0, this repository has become
obsolete and only serves for illustration purposes on how to set up a
new data source with `ricu`.**

-----

In order to use the AmsterdamUMCdb as `ricu`-external dataset
`aumc_ext`, some configuration is necessary to be set up before loading
`ricu`. A configuration file `data-sources.json` provides the necessary
info on the involved tables and `concept-dict.json` is required for
loading `ricu` clinical concepts from the new dataset. Finally some
dataset-specific implementations of certain S3 generic functions
exported from `ricu` are required (see `r/ricu.R`) as might be some
callback functions used in concept specification (see `r/callback.R`).

## Configuring ricu

Several environment variables can be set for `ricu` to facilitate the
integration of `aumc_ext`:

  - `RICU_DATA_PATH`: (optionally) point this to a directory containing
    a folder `aumc_ext` which holds the AmsterdamUMCdb data
  - `RICU_CONFIG_PATH`: point this to the `./config` directory of this
    project
  - `RICU_SRC_LOAD`: Comma separated list of data sources to
    automatically load when attaching `ricu`
    (e.g. `mimic,mimic_demo,aumc_ext`)

For now, we leave `RICU_DATA_PATH` at default and set the other
environment variables accordingly before loading `ricu`

``` r
sources <- c("mimic_demo", "eicu_demo", "aumc", "aumc_ext")

Sys.setenv(RICU_SRC_LOAD = paste(sources, collapse = ","),
           RICU_CONFIG_PATH = "config")

library(ricu)
#> 
#> ── ricu 0.4.1.9000 ─────────────────────────────────────────────────────────────────────────────────
#> 
#> The following data sources are configured to be attached:
#> (the environment variable `RICU_SRC_LOAD` controls this)
#> 
#> ✔ mimic_demo: 25 of 25 tables available
#> ✔ eicu_demo: 31 of 31 tables available
#> ✔ aumc: 7 of 7 tables available
#> ✔ aumc_ext: 7 of 7 tables available
#> 
#> ────────────────────────────────────────────────────────────────────────────────────────────────────

for (file in file.path("r", c("ricu.R", "callback.R"))) {
  source(file)
}
```

As `aumc` is already fully supported by `ricu`, all configuration in
this repo has been renamed to set up the AmsterdamUMCdb data as external
dataset `aumc_ext`.

## Set-up

In order to download and set up the data as `aumc_ext`, but using `ricu`
functionality for downloading and importing `aumc`, run:

``` r
download_src("aumc", src_data_dir("aumc_ext"))
import_src("aumc", src_data_dir("aumc_ext"))
attach_src("aumc_ext")
```

This mimics manual download and conversion to `.fst` files (as one might
do for setting up a new data source manually) and mimimizes the amount
of configuration information during set-up (compare `aumc_ext` of
`data-sources.json` provided by this repo with `aumc` of the `ricu`
provided `data-sources.json`.)

## Load data

Upon successful set-up, data can be loaded as:

``` r
aumc_ext$processitems
#> # <src_tbl>:  [256,715 ✖ 6]
#> # ID options: patientid (patient) < admissionid (icustay)
#> # Defaults:   `start` (index), `item` (val)
#> # Time vars:  `start`, `stop`
#>         admissionid itemid item                    start      stop duration
#>               <int>  <int> <chr>                   <dbl>     <dbl>    <int>
#>       1           0   9159 Arterielijn Radialis 20520000 148800000     2138
#>       2           0   9166 Trilumen Jugularis   20520000 148800000     2138
#>       3           0   9174 Swan Ganz Jugularis  20520000 139020000     1975
#>       4           0   9328 Beademen             20520000  69120000      810
#>       5           0   9399 Wonddrain 1          20520000  94320000     1230
#>       …
#> 256,711       23551   9422 Perifeer infuus       3900000 165660000     2696
#> 256,712       23551  12634 Tube                  3900000 165660000     2696
#> 256,713       23551  13009 Parenchymdrain        3960000 165660000     2695
#> 256,714       23552   9422 Perifeer infuus         60000  64980000     1082
#> 256,715       23552   9422 Perifeer infuus         60000  73320000     1221
#> # … with 256,705 more rows

load_ts(aumc_ext$processitems, itemid == 9159, id_var = "patientid")
load_ts(aumc_ext$processitems, itemid == 9159, id_var = "admissionid")

gluc <- concept("gluc", unit = "mmol/l",
  item("aumc_ext", "numericitems", "itemid", list(c(9947L, 6833L, 9557L)))
)

load_concepts(gluc, id_type = "patient", verbose = FALSE)
#> # A `ts_tbl`: 587,791 ✖ 3
#> # Id var:     `patientid`
#> # Units:      `gluc` [mmol/l]
#> # Index var:  `measuredat` (1 hours)
#>         patientid measuredat  gluc
#>             <int> <drtn>     <dbl>
#>       1         0 -271 hours  6.40
#>       2         0 -249 hours  7
#>       3         0    5 hours 11.4
#>       4         0    6 hours 10.7
#>       5         0    9 hours  9.60
#>       …
#> 587,787     20325   38 hours  5.30
#> 587,788     20325   39 hours  6.40
#> 587,789     20325   41 hours  5.70
#> 587,790     20325   42 hours  5.40
#> 587,791     20326   13 hours  4.40
#> # … with 587,781 more rows
load_concepts(gluc, id_type = "icustay", verbose = FALSE)
#> # A `ts_tbl`: 771,720 ✖ 3
#> # Id var:     `admissionid`
#> # Units:      `gluc` [mmol/l]
#> # Index var:  `measuredat` (1 hours)
#>         admissionid measuredat  gluc
#>               <int> <drtn>     <dbl>
#>       1           0 -271 hours  6.40
#>       2           0 -249 hours  7
#>       3           0    5 hours 11.4
#>       4           0    6 hours 10.7
#>       5           0    9 hours  9.60
#>       …
#> 771,716       23551   38 hours  5.30
#> 771,717       23551   39 hours  6.40
#> 771,718       23551   41 hours  5.70
#> 771,719       23551   42 hours  5.40
#> 771,720       23552   13 hours  4.40
#> # … with 771,710 more rows

concept_availability(concepts = c("glu", "alb", "weight"))
#>        aumc aumc_ext eicu_demo mimic_demo
#> glu    TRUE     TRUE      TRUE       TRUE
#> alb    TRUE     TRUE      TRUE       TRUE
#> weight TRUE    FALSE      TRUE       TRUE

load_concepts(c("glu", "alb"), "aumc_ext", verbose = FALSE)
#> # A `ts_tbl`: 780,378 ✖ 4
#> # Id var:     `admissionid`
#> # Units:      `glu` [mg/dL], `alb` [g/dL]
#> # Index var:  `measuredat` (1 hours)
#>         admissionid measuredat   glu   alb
#>               <int> <drtn>     <dbl> <dbl>
#>       1           0 -271 hours 115.   NA
#>       2           0 -249 hours 126.   NA
#>       3           0    5 hours 205.   NA
#>       4           0    6 hours 193.    2.2
#>       5           0    9 hours 173.   NA
#>       …
#> 780,374       23551   38 hours  95.5   2
#> 780,375       23551   39 hours 115.   NA
#> 780,376       23551   41 hours 103.   NA
#> 780,377       23551   42 hours  97.3  NA
#> 780,378       23552   13 hours  79.3  NA
#> # … with 780,368 more rows
load_concepts(c("alb", "weight"), "aumc_ext", verbose = FALSE)
#> # A `ts_tbl`: 106,139 ✖ 4
#> # Id var:     `admissionid`
#> # Units:      `alb` [g/dL], `weight` [kg]
#> # Index var:  `measuredat` (1 hours)
#>         admissionid measuredat   alb weight
#>               <int> <drtn>     <dbl>  <dbl>
#>       1           0  6 hours     2.2     NA
#>       2           1  0 hours     2.9     NA
#>       3           2  0 hours     2.8     NA
#>       4           3  2 hours     2.8     NA
#>       5           4 41 hours     2.5     NA
#>       …
#> 106,135       23549  9 hours     2.6     NA
#> 106,136       23550  2 hours     2.2     NA
#> 106,137       23551  1 hours     2.6     NA
#> 106,138       23551 14 hours     2.3     NA
#> 106,139       23551 38 hours     2       NA
#> # … with 106,129 more rows
```
