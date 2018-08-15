REQUIREMENT = requirements.txt

VER  = $(word 2, $(shell python --version 2>&1))
SRC  = app.py app_test.py
PY36 = $(shell expr $(VER) \>= 3.6)

.PHONY: build deps test
build: html

%:
	cd docs && make $@

test: clean build
	pycodestyle $(SRC)
	pydocstyle $(SRC)
	bandit $(SRC)
	coverage run app_test.py && coverage report --fail-under=90 -m $(SRC)
ifeq ($(PY36), 1)
	black --quiet --diff --check --line-length 79 $(SRC)
endif

deps:
ifeq ($(PY36), 1)
	pip -q install black==18.6b4
endif
