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
