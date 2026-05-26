# MAR-1131 Towson, MD Geohub Build Test Difference Report

Date: 2026-05-24
Owner: CTO
Status: Delivered

## Objective
Run one bounded Towson, MD geohub build/test slice and report differences versus the prior baseline used in this thread.

## Baseline and Fresh Build
- Baseline reference artifact: `output/mar170_towson_launch_slice/towson_launch_slice_route_manifest.json`
- Fresh MAR-1131 build artifact: `output/mar1131_towson_geohub_build_test/towson_launch_slice_route_manifest.json`
- Input-aligned parity artifact: `output/mar1131_towson_geohub_build_test_baseline_url/towson_launch_slice_route_manifest.json`

## Commands Executed
```bash
python3 src/build_towson_launch_slice_routes.py \
  --output-dir output/mar1131_towson_geohub_build_test \
  --base-url https://example.com \
  --listings-data data/pilot/towson_launch_slice_sample_listings.json

python3 src/validate_towson_site_outline_contract.py \
  --input output/mar1131_towson_geohub_build_test/towson_launch_slice_route_manifest.json \
  --output output/mar1131_towson_geohub_build_test/mar1131_contract_validation.json \
  --contract-version towson-outline-v1

diff -u \
  output/mar170_towson_launch_slice/towson_launch_slice_route_manifest.json \
  output/mar1131_towson_geohub_build_test/towson_launch_slice_route_manifest.json \
  > output/mar1131_towson_geohub_build_test/mar1131_manifest.diff || true

python3 src/build_towson_launch_slice_routes.py \
  --output-dir output/mar1131_towson_geohub_build_test_baseline_url \
  --base-url https://pilot.maryland.example \
  --listings-data data/pilot/towson_launch_slice_sample_listings.json

diff -u \
  output/mar170_towson_launch_slice/towson_launch_slice_route_manifest.json \
  output/mar1131_towson_geohub_build_test_baseline_url/towson_launch_slice_route_manifest.json \
  > output/mar1131_towson_geohub_build_test_baseline_url/mar1131_manifest.diff || true
```

## Verification Results
- Build command result: `status=ok`
- Fresh build service counts:
  - `mold-remediation: 2`
  - `auto-glass: 2`
  - `mobile-notary: 2`
- Contract validator result (`output/mar1131_towson_geohub_build_test/mar1131_contract_validation.json`):
  - `ok=true`
  - `route_count=4`
  - `unique_paths=4`

## Difference Summary
- Manifest diff output file: `output/mar1131_towson_geohub_build_test/mar1131_manifest.diff`
- Observed delta in first run: manifest content changed only in `base_url` and `canonical_url` values because the run used `--base-url https://example.com`.
- Structural route shape, route set, and counts remained unchanged.
- Input-aligned parity diff file: `output/mar1131_towson_geohub_build_test_baseline_url/mar1131_manifest.diff`
- Input-aligned parity result: **0-byte diff (no content differences)** when fresh run uses baseline URL `https://pilot.maryland.example`.

## Artifact Paths Produced
- `output/mar1131_towson_geohub_build_test/towson_launch_slice_route_manifest.json`
- `output/mar1131_towson_geohub_build_test/towson_launch_slice_sample_listings.json`
- `output/mar1131_towson_geohub_build_test/preview/index.html`
- `output/mar1131_towson_geohub_build_test/mar1131_contract_validation.json`
- `output/mar1131_towson_geohub_build_test/mar1131_manifest.diff`
- `output/mar1131_towson_geohub_build_test_baseline_url/towson_launch_slice_route_manifest.json`
- `output/mar1131_towson_geohub_build_test_baseline_url/mar1131_manifest.diff`

## Shared Checkout Artifact Location
- `docs/projects/marketgrid/mar-1131-towson-md-geohub-build-test-difference-report.md`
