PYTHON ?= python3
LATEXMK ?= latexmk
.DEFAULT_GOAL := paper

.PHONY: report paper

report:
	cd dblp_models/g_report/src && $(PYTHON) -c 'import json; from pathlib import Path; scope = {"__name__": "__main__"}; [exec(compile("".join(cell["source"]), "report.ipynb", "exec"), scope) for cell in json.loads(Path("report.ipynb").read_text())["cells"]]'

paper: report
	cd manuscript && $(LATEXMK) -pdf -interaction=nonstopmode -halt-on-error -outdir=build main.tex
