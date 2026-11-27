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
