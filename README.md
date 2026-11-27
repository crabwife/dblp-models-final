# dblp productivity models

`dblp_models/` is a notebook pipeline. Each task has `input/`, `src/`, and
`output/`, with relative symlinks connecting upstream outputs to inputs.

| Task | Purpose |
| --- | --- |
| `a_import` | Load the local source data |
| `b_prepare` | Prepare the cohorts, panels, and transitions |
| `c_fit`, `d_simulate` | Fit and simulate models, with notebooks under `src/manuscript/` and `src/supplement/` |
| `e_diagnose` | Calculate numerical diagnostics and model comparisons |
| `f_plot` | Internal figure notebooks in `src/exploratory/` write to `output/exploratory/`. `src/pnas_figures.ipynb` writes paper and SI figures to `output/pnas/`. |
| `g_report` | Export LaTeX macros, provenance, and the primary-model comparison CSV |

Install `dblp_models/requirements.txt`, put `adjusted_productivity.csv` in
`dblp_models/a_import/input/`, and run all cells in `dblp_models/run.ipynb`
from the `dblp_models/` working directory.

Supplemental fits and simulations include GRW-S (stage-specific increments)
and AR(1)-Y (year-specific coefficients). These variants are outside the model
comparison tables. The PNAS figure notebook writes separate AR(1) parameter
figures for the stagewise and annual fits.

From the repo root, `make report` refreshes the macros and comparison CSV
from the checked-in diagnostics. `make paper` and `make si` build the LaTeX
sources under `manuscript/`. Use figure paths under `f_plot/output/pnas/` and
load all generated macros from `g_report/output/results.tex`. Exploratory figures
and run logs are generated locally.

`aarc_fields/` is a separate notebook pipeline for the empirical fieldwise
lognormality comparison from Figure 1B of the Shockley draft.
Run `make aarc` from the repo root with the same Python
environment. The default source is
`~/Desktop/NSF 26-256/b_trajectorize/output/fields`, with
`data/field_trajectories/fields` in that NSF repo as a fallback. Set
`AARC_FIELDS_DIR` to the finest-level field export directory for a different
checkout. The pipeline uses the hiring-and-retention hierarchy's cleaned
taxonomy labels for the 13 target fields. It recognizes the corresponding
`General` aliases and the AARC ID 156 alias `Sociology - Articles-Focused`.
The CSV records the matched files, sample counts, and missing fields. The
figure includes fields with an estimable Q–Q correlation.

Each eligible researcher contributes one total over their last four observed
years within a field. As in the draft notebook, the window ends at zero-indexed
career age 4 or later, and the Q–Q correlation `r` uses the logs of positive
totals. The computer science point uses the AARC field export. Only aggregates
are written.

- `aarc_fields/b_diagnose/output/aarc_field_lognormality.csv`
- `aarc_fields/c_plot/output/pnas/pnas_aarc_field_lognormality.pdf` (and PNG)

### AARC raw-data pipeline

Run `make aarc-raw` from the repo root. This runs the notebooks in
`aarc_models/` in order. It links the raw rosters, rank and taxonomy tables,
articles, and conference proceedings from `~/Desktop/SHL/SHL_aarc`. Put the
original `phd_granting_institutions.csv` there. To use other locations, set
`AARC_RAW_DIR` and `AARC_INSTITUTIONS`.

The cohort follows [prep_aarc](https://github.com/crabwife/prep_aarc): the 368
employing institutions, 2011–2023 rosters, assistant/associate/full professor
ranks, departments observed in at least five years, and first appearances
as assistant professor after an observed prior census year. The roster
schema uses the earlier prep's latest-employment rule for concurrent
institutions. Field membership is determined from the retained hire-year
assistant-professor rows. A researcher may have more than one field.
`aarc_models/config.json` maps AARC IDs to the 13 cleaned field labels,
including History and both Sociology variants. The 13 fields are fixed in
advance, so the NSF taxonomy-level selection thresholds do not apply.

The trajectory CSV is
`aarc_models/c_trajectorize/output/secret_aarc_13_field_trajectories.csv`.
It uses the legacy NSF `PersonId::hire_year` convention for `dblp_id`, a
`field_id`, and career-year columns `1`–`12`. Year 1 is the inferred hire
year. Counts are deduplicated separately within articles and conference
proceedings. Zero means no matched work in a year through 2023, and blank
means that career year falls after 2023. The cohort includes faculty with no
matched works.

`aarc_models/d_eda/output/` contains the empirical summary, Q–Q points, rank
persistence, dropout bins, reentry hazards, and the fieldwise Q–Q figure.
Totals use the last four years for faculty with at least five observed
years, matching the earlier draft cutoff. Q–Q statistics use positive totals.
Rank correlations and slopes use the fixed 12-year cohort. Dropout and reentry
use all observed adjacent pairs. The pooled summaries count each person once.
