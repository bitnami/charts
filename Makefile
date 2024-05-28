SHELL = /bin/bash

default: help

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: new_chart
.ONESHELL:
new_chart:  ## Creates new chart from template
	@command -v docker >/dev/null || { echo "please install 'docker' and ensure on PATH"; exit 1; }
	@read -r -p 'Chart name (e.g. my-chart): ' chart_name; \
	docker run --rm -v ${PWD}:/src -w /src ubuntu /usr/bin/bash ./template/new_chart.sh $$chart_name;

.PHONY: render_template
.ONESHELL:
render_template:  ## Render template created with 'new_template' and values from its placeholders.yaml
	@command -v docker >/dev/null || { echo "please install 'docker' and ensure on PATH"; exit 1; }
	@read -r -p 'Chart name (e.g. my-chart): ' chart_name; \
	docker run --rm -v ${PWD}:/src -w /src ubuntu /usr/bin/bash ./template/replace-placeholders.sh $$chart_name;

.PHONY: recreate_chart
.ONESHELL:
recreate_chart:  ## Removes existing chart, then recreates chart from template then renders with previous placeholders.yaml. Warning: all other changes will be lost.
	@command -v docker >/dev/null || { echo "please install 'docker' and ensure on PATH"; exit 1; }
	@read -r -p 'Chart name (e.g. my-chart): ' chart_name; \
	mkdir -p tmp/$$chart_name; \
	cp draft/$$chart_name/placeholders.yaml ./tmp/$$chart_name/placeholders.yaml; \
	rm -r draft/$$chart_name; \
	docker run --rm -v ${PWD}:/src -w /src ubuntu /usr/bin/bash ./template/new_chart.sh $$chart_name; \
	cp ./tmp/$$chart_name/placeholders.yaml draft/$$chart_name/placeholders.yaml; \
	rm -r ./tmp/$$chart_name/placeholders.yaml; \
	docker run --rm -v ${PWD}:/src -w /src ubuntu /usr/bin/bash ./template/replace-placeholders.sh $$chart_name; \	
