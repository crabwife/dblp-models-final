PYTHON ?= python3
LATEXMK ?= latexmk
.DEFAULT_GOAL := paper

.PHONY: report paper si

report:
	cd dblp_models/g_report/src && $(PYTHON) -c 'import json; from pathlib import Path; scope = {"__name__": "__main__"}; [exec(compile("".join(cell["source"]), "report.ipynb", "exec"), scope) for cell in json.loads(Path("report.ipynb").read_text())["cells"]]'

paper: report
	cd manuscript/paper && $(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error -outdir=build report_main.tex

si:
	cd manuscript/si && $(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error -outdir=build si_main.tex
