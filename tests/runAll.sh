#!/bin/bash
source ./common.sh
# List of test scripts to run
TEST_SCRIPTS=(
  "./module-tofu.test.sh"
  # "./examples-tofu.test.sh" Skipped due to disks bug
  "./tofu-fmt.test.sh"
  "./local-module-check.test.sh" # This one should always be last
)

# Array to hold exit codes
EXIT_CODES=()

warn "Skipping examples test due to disks bug"
# Run each script and capture exit code
for script in "${TEST_SCRIPTS[@]}"; do
  bash -c "$script"
  EXIT_CODES+=($?)  # store exit code
  echo ""
done
# Check if any failed
FAILED=()
for i in "${!TEST_SCRIPTS[@]}"; do
  if [ "${EXIT_CODES[i]}" -ne 0 ]; then
    FAILED+=("${TEST_SCRIPTS[i]}")
  fi
done

if [ "${#FAILED[@]}" -ne 0 ]; then
  error "The following scripts failed:" noexit
  for f in "${FAILED[@]}"; do
    error "  - $f" noexit
  done
  exit 1
fi

success "All scripts passed"
