export PATH := $(PWD)/.venv/bin:$(PATH)
export VIRTUAL_ENV := $(PWD)/.venv
export PROJECT_NAME := cachecall
export PYTHONPATH := ${PROJECT_NAME}

COLOR="\033[36m%-30s\033[0m %s\n"

.PHONY: deploy .env .venv
.DEFAULT_GOAL := help

.env:
	@echo 'PYTHONPATH="$(PROJECT_NAME)"' > .env

.venv:
	@python3.8 -m venv $(VIRTUAL_ENV)
	pip install --upgrade pip

.rm-venv:
	@if [ -d $(VIRTUAL_ENV) ]; then rm -rf $(VIRTUAL_ENV); fi

.install-hook:
	@echo "make lint" > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit

install-dev: .venv .env .install-hook ## Create .venv and install dev dependencies.
	pip install --upgrade pip
	@if [ -f requirements-dev.txt ]; then pip install -r requirements-dev.txt; fi

reinstall-dev: .rm-venv install-dev ## Remove .venv if exists, create a new .venv and install dev dependencies.

clean: ## Clean all caches file.
	@rm -rf dependencies .pytest_cache .coverage .aws-sam
	@find $(PROJECT_PATH) -name __pycache__ | xargs rm -rf
	@find tests -name __pycache__ | xargs rm -rf

lint: ## Apply lintings to ensure code quality.
	black --line-length=100 --target-version=py38 --check .
	flake8 --max-line-length=150 --ignore=E402,W503 --exclude .venv

format: ## Format code based in PEP8.
	black --line-length=100 --target-version=py38 .

coverage: ## Test code and check coverage from tests.
	@pytest --cov-config=.coveragerc --cov=$(PROJECT_NAME) tests/ --cov-fail-under=90

test:  ## Execute all unity tests.
	@pytest -v

tests: test  ## Execute all unity tests.

testp: ## Execute all tests in parallel
	@echo "Run pytest xdist..."
	@pytest -n 4
	@echo "Run pytest parallel..."
	@pytest --workers auto

testsp: testp ## Execute all tests in parallel

help: ## Show documentation.
	@for makefile_file in $(MAKEFILE_LIST); do \
		grep -E '^[a-zA-Z_-]+:.*?##' $$makefile_file | sort | awk 'BEGIN {FS = ":.*?##"}; {printf ${COLOR}, $$1, $$2}'; \
	done
