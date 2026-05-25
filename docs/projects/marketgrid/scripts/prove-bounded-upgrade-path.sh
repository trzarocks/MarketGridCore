#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../../../" && pwd)"
cd "$ROOT_DIR"

SAMPLE_DIR="docs/projects/marketgrid/samples/MAR-1136"

supported_contract_version() {
  case "$1" in
    v1.0|v1.1) return 0 ;;
    *) return 1 ;;
  esac
}

assert_supported() {
  local file="$1"
  local label="$2"
  local version
  version="$(jq -r '.contract_version // empty' "$file")"

  if [[ -z "$version" ]]; then
    echo "${label}: MISSING_CONTRACT_VERSION -> $file"
    return 1
  fi

  if supported_contract_version "$version"; then
    echo "${label}: SUPPORTED ($version) -> $file"
  else
    echo "${label}: UNSUPPORTED ($version) -> $file"
    return 1
  fi
}

assert_unsupported() {
  local file="$1"
  local label="$2"
  local version
  version="$(jq -r '.contract_version // empty' "$file")"

  if [[ -z "$version" ]]; then
    echo "${label}: MISSING_CONTRACT_VERSION -> $file"
    return 1
  fi

  if supported_contract_version "$version"; then
    echo "${label}: EXPECTED_UNSUPPORTED_BUT_SUPPORTED ($version) -> $file"
    return 1
  else
    echo "${label}: REJECTED_AS_EXPECTED ($version) -> $file"
  fi
}

echo "CHECK1: geohub packet samples accept bounded upgrade window"
assert_supported "$SAMPLE_DIR/geohub-packet-v1.0.sample.json" "geohub_v1_0"
assert_supported "$SAMPLE_DIR/geohub-packet-v1.1.sample.json" "geohub_v1_1"

echo "CHECK2: enrichment samples accept bounded upgrade window"
assert_supported "$SAMPLE_DIR/enrichment-v1.0.sample.json" "enrichment_v1_0"
assert_supported "$SAMPLE_DIR/enrichment-v1.1.sample.json" "enrichment_v1_1"

echo "CHECK3: out-of-window versions are rejected"
assert_unsupported "$SAMPLE_DIR/geohub-packet-v2.0.sample.json" "geohub_v2_0"
assert_unsupported "$SAMPLE_DIR/enrichment-v2.0.sample.json" "enrichment_v2_0"
assert_unsupported "$SAMPLE_DIR/geohub-packet-v0.9.sample.json" "geohub_v0_9"
assert_unsupported "$SAMPLE_DIR/enrichment-v0.9.sample.json" "enrichment_v0_9"

echo "CHECK4: required version metadata still enforced in active packet corpus"
for f in $(find docs/projects/marketgrid/packets -type f -name '*.json' | sort); do
  jq -e 'has("contract_version") and has("artifact_revision")' "$f" >/dev/null
done
echo "CHECK4_OK"

echo "CHECK5: required version metadata still enforced in enrichment contract example"
rg -q '"contract_version"' docs/enrichment/restaurant-listing-enrichment-contract.md
rg -q '"artifact_revision"' docs/enrichment/restaurant-listing-enrichment-contract.md
echo "CHECK5_OK"

echo "BOUND_UPGRADE_PROOF_OK"
