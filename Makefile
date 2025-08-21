# Small convenience Makefile
.PHONY: install dry-run lint

install:
	./install.sh

symlink-install:
	./install.sh --symlink

dry-run:
	./install.sh --dry-run

lint:
	# Requires shellcheck installed locally
	shellcheck install.sh standard-apps.sh || true

test:
	# Run the repository's verification scripts
	@echo "Running tests..."
	./tests/verify_prompt.sh
	./tests/verify_standard_apps.sh
	./tests/verify_install.sh
	@echo "All tests passed"
