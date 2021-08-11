
<!-- README.md is generated from README.Rmd. Please edit that file -->

-----

**With release of `ricu` version 0.2.0, this repository has become
obsolete and only serves for illustration purposes on how to set up a
new data source with `ricu`.**

-----

Setting up and using [`ricu`](https://cran.r-project.org/package=ricu)
to access the publicly available ICU database
[AmsterdamUMCdb](https://github.com/AmsterdamUMC/AmsterdamUMCdb) of
[Amsterdam UMC](https://www.amsterdamumc.nl).

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
#> [32m✔[39m mimic_demo: 25 of 25 tables available
#> [32m✔[39m eicu_demo: 31 of 31 tables available
#> [32m✔[39m aumc: 7 of 7 tables available
#> [32m✔[39m aumc_ext: 7 of 7 tables available
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
do for setting up a new data source manually). Upon successful set-up,
data can be loaded as:

``` r
aumc_ext$processitems
```

<PRE class="fansi fansi-output"><CODE>#&gt; <span style='color: #555555;'># &lt;src_tbl&gt;:  [256,715 ✖ 6]</span>
#&gt; <span style='color: #555555;'># ID options: patientid (patient) &lt; admissionid (icustay)</span>
#&gt; <span style='color: #555555;'># Defaults:   `start` (index), `item` (val)</span>
#&gt; <span style='color: #555555;'># Time vars:  `start`, `stop`</span>
#&gt;         admissionid itemid item                    start      stop duration
#&gt;               <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;chr&gt;</span>                   <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>    <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span>
#&gt;       <span style='color: #555555;'>1</span>           0   <span style='text-decoration: underline;'>9</span>159 Arterielijn Radialis 20<span style='text-decoration: underline;'>520</span>000 148<span style='text-decoration: underline;'>800</span>000     <span style='text-decoration: underline;'>2</span>138
#&gt;       <span style='color: #555555;'>2</span>           0   <span style='text-decoration: underline;'>9</span>166 Trilumen Jugularis   20<span style='text-decoration: underline;'>520</span>000 148<span style='text-decoration: underline;'>800</span>000     <span style='text-decoration: underline;'>2</span>138
#&gt;       <span style='color: #555555;'>3</span>           0   <span style='text-decoration: underline;'>9</span>174 Swan Ganz Jugularis  20<span style='text-decoration: underline;'>520</span>000 139<span style='text-decoration: underline;'>020</span>000     <span style='text-decoration: underline;'>1</span>975
#&gt;       <span style='color: #555555;'>4</span>           0   <span style='text-decoration: underline;'>9</span>328 Beademen             20<span style='text-decoration: underline;'>520</span>000  69<span style='text-decoration: underline;'>120</span>000      810
#&gt;       <span style='color: #555555;'>5</span>           0   <span style='text-decoration: underline;'>9</span>399 Wonddrain 1          20<span style='text-decoration: underline;'>520</span>000  94<span style='text-decoration: underline;'>320</span>000     <span style='text-decoration: underline;'>1</span>230
#&gt;       <span style='color: #555555;'>…</span>
#&gt; <span style='color: #555555;'>256,711</span>       <span style='text-decoration: underline;'>23</span>551   <span style='text-decoration: underline;'>9</span>422 Perifeer infuus       3<span style='text-decoration: underline;'>900</span>000 165<span style='text-decoration: underline;'>660</span>000     <span style='text-decoration: underline;'>2</span>696
#&gt; <span style='color: #555555;'>256,712</span>       <span style='text-decoration: underline;'>23</span>551  <span style='text-decoration: underline;'>12</span>634 Tube                  3<span style='text-decoration: underline;'>900</span>000 165<span style='text-decoration: underline;'>660</span>000     <span style='text-decoration: underline;'>2</span>696
#&gt; <span style='color: #555555;'>256,713</span>       <span style='text-decoration: underline;'>23</span>551  <span style='text-decoration: underline;'>13</span>009 Parenchymdrain        3<span style='text-decoration: underline;'>960</span>000 165<span style='text-decoration: underline;'>660</span>000     <span style='text-decoration: underline;'>2</span>695
#&gt; <span style='color: #555555;'>256,714</span>       <span style='text-decoration: underline;'>23</span>552   <span style='text-decoration: underline;'>9</span>422 Perifeer infuus         <span style='text-decoration: underline;'>60</span>000  64<span style='text-decoration: underline;'>980</span>000     <span style='text-decoration: underline;'>1</span>082
#&gt; <span style='color: #555555;'>256,715</span>       <span style='text-decoration: underline;'>23</span>552   <span style='text-decoration: underline;'>9</span>422 Perifeer infuus         <span style='text-decoration: underline;'>60</span>000  73<span style='text-decoration: underline;'>320</span>000     <span style='text-decoration: underline;'>1</span>221
#&gt; <span style='color: #555555;'># … with 256,705 more rows</span>
</CODE></PRE>

``` r

load_ts(aumc_ext$processitems, itemid == 9159, id_var = "patientid")
load_ts(aumc_ext$processitems, itemid == 9159, id_var = "admissionid")

gluc <- concept("gluc", unit = "mmol/l",
  item("aumc_ext", "numericitems", "itemid", list(c(9947L, 6833L, 9557L)))
)

load_concepts(gluc, id_type = "patient", verbose = FALSE)
```

<PRE class="fansi fansi-output"><CODE>#&gt; <span style='color: #555555;'># A `ts_tbl`: 587,791 ✖ 3</span>
#&gt; <span style='color: #555555;'># Id var:     `patientid`</span>
#&gt; <span style='color: #555555;'># Units:      `gluc` [mmol/l]</span>
#&gt; <span style='color: #555555;'># Index var:  `measuredat` (1 hours)</span>
#&gt;         patientid measuredat  gluc
#&gt;             <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;drtn&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>
#&gt;       <span style='color: #555555;'>1</span>         0 -271 hours  6.40
#&gt;       <span style='color: #555555;'>2</span>         0 -249 hours  7
#&gt;       <span style='color: #555555;'>3</span>         0    5 hours 11.4
#&gt;       <span style='color: #555555;'>4</span>         0    6 hours 10.7
#&gt;       <span style='color: #555555;'>5</span>         0    9 hours  9.60
#&gt;       <span style='color: #555555;'>…</span>
#&gt; <span style='color: #555555;'>587,787</span>     <span style='text-decoration: underline;'>20</span>325   38 hours  5.30
#&gt; <span style='color: #555555;'>587,788</span>     <span style='text-decoration: underline;'>20</span>325   39 hours  6.40
#&gt; <span style='color: #555555;'>587,789</span>     <span style='text-decoration: underline;'>20</span>325   41 hours  5.70
#&gt; <span style='color: #555555;'>587,790</span>     <span style='text-decoration: underline;'>20</span>325   42 hours  5.40
#&gt; <span style='color: #555555;'>587,791</span>     <span style='text-decoration: underline;'>20</span>326   13 hours  4.40
#&gt; <span style='color: #555555;'># … with 587,781 more rows</span>
</CODE></PRE>

``` r
load_concepts(gluc, id_type = "icustay", verbose = FALSE)
```

<PRE class="fansi fansi-output"><CODE>#&gt; <span style='color: #555555;'># A `ts_tbl`: 771,720 ✖ 3</span>
#&gt; <span style='color: #555555;'># Id var:     `admissionid`</span>
#&gt; <span style='color: #555555;'># Units:      `gluc` [mmol/l]</span>
#&gt; <span style='color: #555555;'># Index var:  `measuredat` (1 hours)</span>
#&gt;         admissionid measuredat  gluc
#&gt;               <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;drtn&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>
#&gt;       <span style='color: #555555;'>1</span>           0 -271 hours  6.40
#&gt;       <span style='color: #555555;'>2</span>           0 -249 hours  7
#&gt;       <span style='color: #555555;'>3</span>           0    5 hours 11.4
#&gt;       <span style='color: #555555;'>4</span>           0    6 hours 10.7
#&gt;       <span style='color: #555555;'>5</span>           0    9 hours  9.60
#&gt;       <span style='color: #555555;'>…</span>
#&gt; <span style='color: #555555;'>771,716</span>       <span style='text-decoration: underline;'>23</span>551   38 hours  5.30
#&gt; <span style='color: #555555;'>771,717</span>       <span style='text-decoration: underline;'>23</span>551   39 hours  6.40
#&gt; <span style='color: #555555;'>771,718</span>       <span style='text-decoration: underline;'>23</span>551   41 hours  5.70
#&gt; <span style='color: #555555;'>771,719</span>       <span style='text-decoration: underline;'>23</span>551   42 hours  5.40
#&gt; <span style='color: #555555;'>771,720</span>       <span style='text-decoration: underline;'>23</span>552   13 hours  4.40
#&gt; <span style='color: #555555;'># … with 771,710 more rows</span>
</CODE></PRE>

``` r

head(concept_availability(), n = 10)
#>          aumc aumc_ext eicu_demo mimic_demo
#> abx      TRUE    FALSE      TRUE       TRUE
#> adh_rate TRUE    FALSE      TRUE       TRUE
#> adm      TRUE    FALSE      TRUE       TRUE
#> age      TRUE    FALSE      TRUE       TRUE
#> alb      TRUE     TRUE      TRUE       TRUE
#> alp      TRUE     TRUE      TRUE       TRUE
#> alt      TRUE     TRUE      TRUE       TRUE
#> ast      TRUE     TRUE      TRUE       TRUE
#> basos    TRUE     TRUE      TRUE       TRUE
#> be       TRUE     TRUE      TRUE       TRUE

load_concepts(c("glu", "alb"), "aumc_ext", verbose = FALSE)
```

<PRE class="fansi fansi-output"><CODE>#&gt; <span style='color: #555555;'># A `ts_tbl`: 780,378 ✖ 4</span>
#&gt; <span style='color: #555555;'># Id var:     `admissionid`</span>
#&gt; <span style='color: #555555;'># Units:      `glu` [mg/dL], `alb` [g/dL]</span>
#&gt; <span style='color: #555555;'># Index var:  `measuredat` (1 hours)</span>
#&gt;         admissionid measuredat   glu   alb
#&gt;               <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;drtn&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>
#&gt;       <span style='color: #555555;'>1</span>           0 -271 hours 115.   <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>2</span>           0 -249 hours 126.   <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>3</span>           0    5 hours 205.   <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>4</span>           0    6 hours 193.    2.2
#&gt;       <span style='color: #555555;'>5</span>           0    9 hours 173.   <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>…</span>
#&gt; <span style='color: #555555;'>780,374</span>       <span style='text-decoration: underline;'>23</span>551   38 hours  95.5   2
#&gt; <span style='color: #555555;'>780,375</span>       <span style='text-decoration: underline;'>23</span>551   39 hours 115.   <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>780,376</span>       <span style='text-decoration: underline;'>23</span>551   41 hours 103.   <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>780,377</span>       <span style='text-decoration: underline;'>23</span>551   42 hours  97.3  <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>780,378</span>       <span style='text-decoration: underline;'>23</span>552   13 hours  79.3  <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'># … with 780,368 more rows</span>
</CODE></PRE>

``` r
load_concepts(c("alb", "weight"), "aumc_ext", verbose = FALSE)
```

<PRE class="fansi fansi-output"><CODE>#&gt; <span style='color: #555555;'># A `ts_tbl`: 106,139 ✖ 4</span>
#&gt; <span style='color: #555555;'># Id var:     `admissionid`</span>
#&gt; <span style='color: #555555;'># Units:      `alb` [g/dL], `weight` [kg]</span>
#&gt; <span style='color: #555555;'># Index var:  `measuredat` (1 hours)</span>
#&gt;         admissionid measuredat   alb weight
#&gt;               <span style='color: #555555; font-style: italic;'>&lt;int&gt;</span> <span style='color: #555555; font-style: italic;'>&lt;drtn&gt;</span>     <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>  <span style='color: #555555; font-style: italic;'>&lt;dbl&gt;</span>
#&gt;       <span style='color: #555555;'>1</span>           0  6 hours     2.2     <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>2</span>           1  0 hours     2.9     <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>3</span>           2  0 hours     2.8     <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>4</span>           3  2 hours     2.8     <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>5</span>           4 41 hours     2.5     <span style='color: #BB0000;'>NA</span>
#&gt;       <span style='color: #555555;'>…</span>
#&gt; <span style='color: #555555;'>106,135</span>       <span style='text-decoration: underline;'>23</span>549  9 hours     2.6     <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>106,136</span>       <span style='text-decoration: underline;'>23</span>550  2 hours     2.2     <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>106,137</span>       <span style='text-decoration: underline;'>23</span>551  1 hours     2.6     <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>106,138</span>       <span style='text-decoration: underline;'>23</span>551 14 hours     2.3     <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'>106,139</span>       <span style='text-decoration: underline;'>23</span>551 38 hours     2       <span style='color: #BB0000;'>NA</span>
#&gt; <span style='color: #555555;'># … with 106,129 more rows</span>
</CODE></PRE>
