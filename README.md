# DBLP productivity models

The notebook pipeline lives in `dblp_models/`. All code notebooks use code cells only; seed 63; 10,000 simulations per model; model years 0–20; offset 0.49. Model fitting and simulation definitions are unchanged by the diagnostic extension.

## Run

Install `dblp_models/requirements.txt`, place the original CSV at `dblp_models/a_import/input/adjusted_productivity.csv`, and open Jupyter in `dblp_models/`. Run All in `run.ipynb`. This runs every task in sequence, using a separate IPython process per notebook, and stops on error. The driver recreates ignored input/output directories and relative symlinks on fresh checkouts. Source and prepared data, simulation arrays, and scholar IDs stay local; parameters, statistics, figures and notebooks are tracked.

| Task | Purpose |
|---|---|
| a_import | Import attached CSV; source contract and checksum |
| b_prepare | Legacy DBLP cohort, panel and adjacent-year transitions |
| c_fit | ARW4, pooled Lognormal GRW, AR(1)-S, productivity-dependent Hurdle-AR(1)-S, AR(6,6), SE-Hurdle-S |
| d_simulate | Matching seed-63 simulations |
| e_diagnose | `diagnose.ipynb`, `historic.ipynb`, then `model_comparison.ipynb`: diagnostic tables |
| f_plot | Numbered historic figure notebooks followed by `plot.ipynb` |

Every task has input/output/src. Input links point to the preceding task output; dependency links carry the panel and parameter tables forward through that chain. Source columns include `dblp`, `phd_year`, `year`, `CareerAge`, `pubs_adj`. The legacy cohort uses phd_year ≥1980, CareerAge 1–21, the observed age-5 productivity filter, and terminal source-row removal. `age = CareerAge - 1`. The supplied CSV gives 2,086 scholars and 510 complete careers. Missing follow-up is never treated as zero.

## Historic diagnostics

| Notebook | Tables / figures |
|---|---|
| e_diagnose/src/historic.ipynb | Raw and offset-log annual/increment means, medians, variances, SDs, skewness and excess kurtosis; pooled/stagewise increment fits; ECDF knots; distribution distances; windowed QQ; career statistics; dropout and history profiles |
| f_plot/src/01_moments.ipynb | Count and increment moment panels, raw/log, with all models and with GRW omitted from the view |
| f_plot/src/02_cdfs.ipynb | Empirical ECDF/simulated CDF overlays and per-model comparisons: selected annual years, pooled annual output, stage totals, cumulative through 5, last four, whole career, generated common years, career SD, zero-year count, year of maximum; pooled/stagewise increment CDFs |
| f_plot/src/03_distribution_fits.ipynb | Pooled/stagewise raw-increment Laplace and log-increment Normal fit statistics/histograms; QQ by window; QQ correlation heatmap; log2 career-total Normal histograms |
| f_plot/src/04_career_diagnostics.ipynb | Initialization and Exponential reference; rounded annual-output PMF; zero-year survival; early-total violin; seed-63 representative trajectories |
| f_plot/src/05_memory_dropout.ipynb | Productivity-dependent dropout using shared empirical bins; conditional history profiles near current productivity 0, 5 and 10 |
| f_plot/src/plot.ipynb | Core diagnostics and the requested three-panel Spearman rank-mixing curves, annual and cumulative separately |

`SELECTED` in each figure notebook controls its model view. GRW-excluded moment figures are additional views; full-model tables and figures remain available. Figure exports are PNG/PDF; notebook figure outputs are cleared before commit to avoid duplicating the images.

## Rank mixing

Annual productivity ranks are the primary curves: Spearman(R_t,R_0), Spearman(R_t,R_(t−3)), and Spearman(R_t,R_(t−5)). Use years t=0–20, t=3–20 and t=5–20 respectively, retaining observed zero ties with average ranks. The empirical comparison uses the same fixed complete-career cohort for every t and model. Tables include n and reference year. Cumulative-productivity ranks are exported and plotted separately; they are not substituted for annual ranks.

AR(6,6) jointly resamples the first six empirical years and starts generating at year 6. Shading marks the prefix. `rank_mixing.csv` marks whether both compared years are generated. Year-0 comparisons for AR(6,6) always condition on an empirical starting rank. Full-career/stage/pooled diagnostics include the prefix; a common generated-years 6–20 total is also available. All diagnostics are in-sample generative checks, not held-out prediction scores.

## Restored SE-Hurdle-S

`c_fit/src/06_se_hurdle_s.ipynb` restores the stage-specific SE-Hurdle-S from `spaarw_followup/self_exciting/src/SE_Hurdle_S_notebook.ipynb` at commit `3b3e9e36fcb06380cbd545c413db609d9f7eb3ba`. Activity uses log1p(previous output), previous activity, and normalized exponential history; positive log-intensity uses log1p(previous output), a restart indicator, and the same history. History excludes the immediately preceding observation, which enters separately. History coefficients are constrained nonnegative; positive residuals are Normal. The original numerical log-intensity guard [-30, 30] is retained.

The fit uses the 510 complete careers, matching the original SE workflow's complete-career design, without imputing missing years. Other models retain their available-observation fits. This difference is explicit in `fit_support.csv` and `model_comparison.csv`; these are descriptive comparisons, not a controlled same-training-cohort ablation. Five scholar-level folds select rho over the original 51-point grid from 0 to .98. The selected grid minimum is a tuning score, not an independent held-out score. No original bootstrap uncertainty estimates are transferred to this cohort.

`d_simulate/src/06_se_hurdle_s.ipynb` resamples complete-cohort year-0 values and generates years 1–20 with seed 63 and 10,000 careers. The legacy standalone notebook used seed 65 for its final simulation; the restored pipeline follows this project's seed-63 convention. SE-Hurdle-S receives no six-year empirical prefix. Its equations and trajectories were checked against the original functions at the same seed (agreement within numerical precision).

All existing diagnostics and figures include `se_hurdle_s`. Seven-source panels expand to retain every source. `e_diagnose/src/model_comparison.ipynb` exports `model_comparison.csv`, including terminal annual rank correlations, rank-curve RMSE over years 11–20, career and generated-years totals and Gini, final inactivity, and generated-years KS distance. AR(6,6)'s lag-3 and lag-5 comparisons over this late window use fully generated pairs; its age-0 comparisons remain prefix-conditioned.

The restored run selects rho = .6664 (half-life 1.71 years). SE-Hurdle-S gives mean career total 151.49 vs 153.00 empirically, final zero fraction .1434 vs .1412, and year-20 lag-5 rank correlation .5530 vs .5827. These are current-cohort results; earlier reported numeric scores should not be substituted for them.

## Statistical conventions

Count and increment logs use ln(q+0.49); the hurdle model's separate positive-intensity fit is unchanged. Moment variance/SD use ddof=0; skewness and excess kurtosis use bias corrections. Distribution and cross-career comparisons use complete empirical careers, with available-case empirical count/increment tables separately labelled. Dropout/history profiles use available observed adjacent years. Initialization additionally displays all observed initial years.

CDF figures use every finite observation through seaborn.ecdfplot. Exported CDF tables contain up to 401 quantile knots plus zero/endpoints, with exact left and right empirical probabilities at those knots. They are compact summary curves, not raw trajectory exports. Distances use full observations. Two-sample KS D and Wasserstein are descriptive, with no fitted-parameter KS p-values. QQ tables give R and R² using every positive total's log2 value; figures retain up to 401 ordered points, standardized with ddof=1. Standard windows include 0, 1–4, 5–7, 8–20, through-5, 17–20, whole career, and generated-common 6–20. Historical last-four-observed empirical totals are labelled separately from complete-cohort years 17–20.

Increment stages refer to transition starts: 0, 1–4, 5–7, 8–19, plus pooled 0–19. Raw increments get descriptive Laplace fits; offset-log increments get Normal fits. Histogram figures display the central 99% (initialization 99.5%); densities use full N rather than renormalizing the cropped mass. Fit statistics always use the full sample. CDFs show full tails, including zero. Raw moment/trajectory plots use symlog when needed to keep GRW visible without truncating it. The rounded annual-output PMF explicitly labels its last bin 20+; zero-year survival is P(count ≥ k). First maximum wins ties. Conditional history uses ±0.5 neighborhoods, widening to up to 2,500 nearest cases only when fewer than 400 are available; bounds and widening flags are saved.

## Provenance

Historic diagnostics adapted from `crabwife/spaarw_followup` commit `3b3e9e36fcb06380cbd545c413db609d9f7eb3ba`, plot notebooks 02–06. Existing DBLP model definitions derive from that repository and `crabwife/nsf_eda` commit `9c6728e3f77feecb27dce34e9550f3f0599772eb` (k_legacy Lognormal GRW and AR(6,6)). No AARC data or code path is introduced.
