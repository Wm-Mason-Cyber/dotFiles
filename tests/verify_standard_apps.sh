#!/usr/bin/env bash
set -euo pipefail

# Verify standard-apps script parses and can list packages
bash -n ./standard-apps.sh

output=$(bash ./standard-apps.sh list)
if [ -z "$output" ]; then
  echo "standard-apps.sh list returned empty output" >&2
  exit 2
fi

echo "standard-apps.sh list OK"
exit 0
