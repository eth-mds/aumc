
# aumc

Using `ricu` to access the publicly available ICU database [AmsterdamUMCdb](https://github.com/AmsterdamUMC/AmsterdamUMCdb) of [Amsterdam UMC](https://www.amsterdamumc.nl).

# Configuring ricu

Several environment variables can be set for `ricu` to facilitate the integration of `aumc`:

* `RICU_DATA_PATH`: point this to a directory containing a folder `aumc` which holds the AmsterdamUMCdb data
* `RICU_CONFIG_PATH`: point this to the `./config` directory of this project
* `RICU_SRC_LOAD`: Comma separated list of data sources to automatically load when attaching `ricu` (e.g. `mimic,mimic_demo,aumc`)
