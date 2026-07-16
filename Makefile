REQUIRED_ARCHAEOLOGY_DOCS := \
	docs/archaeology/README.md \
	docs/archaeology/00-evidence-map.md \
	docs/archaeology/10-architecture-and-flows.md \
	docs/archaeology/20-domain-and-data.md \
	docs/archaeology/30-defects-and-risks.md \
	docs/archaeology/40-operations-and-recovery.md \
	docs/archaeology/90-modernization-roadmap.md

.PHONY: quality quality-evidence-contract archaeology-links archaeology-mermaid

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
	@$(MAKE) --no-print-directory quality-evidence-contract
	@$(MAKE) --no-print-directory archaeology-links
	@$(MAKE) --no-print-directory archaeology-mermaid

quality-evidence-contract:
	@python3 -m unittest discover -s scripts -p 'test_quality_evidence.py'

archaeology-links:
	@python3 docs/archaeology/check_docs.py links

archaeology-mermaid:
	@python3 docs/archaeology/check_docs.py mermaid
