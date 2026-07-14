REQUIRED_ARCHAEOLOGY_DOCS := \
	docs/archaeology/README.md \
	docs/archaeology/00-evidence-map.md \
	docs/archaeology/10-architecture-and-flows.md \
	docs/archaeology/20-domain-and-data.md \
	docs/archaeology/30-defects-and-risks.md

.PHONY: quality

# Verify the tracked archaeology documentation without compiling IBM i sources.
quality:
	@missing=0; \
	for file in $(REQUIRED_ARCHAEOLOGY_DOCS); do \
		if [ ! -f "$$file" ]; then \
			printf 'Missing required archaeology document: %s\n' "$$file" >&2; \
			missing=1; \
		fi; \
	done; \
	[ "$$missing" -eq 0 ]
	@# An exact two-space Markdown hard break is content, not a whitespace defect.
	@git ls-files -z -- '*.md' Makefile | \
		xargs -0 awk ' \
			/[[:blank:]]+$$/ && $$0 !~ /[^[:blank:]]  $$/ { \
				printf "%s:%d:%s\n", FILENAME, FNR, $$0; \
				found = 1; \
			} \
			END { exit found }' || { \
			status=$$?; \
			printf '%s\n' 'Trailing whitespace found in tracked Markdown or Makefile.' >&2; \
			exit "$$status"; \
		}
