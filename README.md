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

From the repo root, `make report` refreshes the macros and comparison CSV
from the checked-in diagnostics. `make paper` and `make si` build the LaTeX
sources under `manuscript/`. Use figure paths under `f_plot/output/pnas/` and
load all generated macros from `g_report/output/results.tex`. Exploratory figures
and run logs are generated locally.
