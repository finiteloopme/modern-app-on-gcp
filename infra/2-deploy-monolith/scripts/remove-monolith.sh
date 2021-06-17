#!/bin/bash
export PROJECT_ID=${1}
export ZONE=${2}
cd bank-of-anthos/src/ledgermonolith
./scripts/teardown-monolith.sh