# MAR-1102 Backup Verification Report

## Archive
- Path: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9/backups/marketgrid-full-backup-20260523-211051.zip`
- Created (America/New_York): `2026-05-23 21:11:25 -0400`
- Size (bytes): `357220833`
- SHA-256: `62f8707b17588b4f59bf601e1997e3a68366eab79452637d08c3f8308d119f04`

## Scope Included
Zip source root: `/var/home/trza/.paperclip/instances/default/companies/b568a7ad-ff59-4585-9d7b-0f7d1d8311e9`

Top-level directories included from source root:
- `agents`
- `codex-home`
- `docs`
- `hyperagent`
- `marketgrid-core-systems`
- `payload-test`
- `place-intelligence-framework`
- `projects`
- `salisbury-restaurant-slice`
- `towson-restaurant-slice`

Exclusion applied during archive creation:
- `*/backups/*` (prevents recursive self-inclusion)

## Source Footprint Snapshot
- `agents`: `76K`
- `codex-home`: `302M`
- `docs`: `708K`
- `hyperagent`: `1.4M`
- `marketgrid-core-systems`: `88K`
- `payload-test`: `11M`
- `place-intelligence-framework`: `188K`
- `projects`: `0`
- `salisbury-restaurant-slice`: `1.3M`
- `towson-restaurant-slice`: `224K`

## Verification Evidence
- Integrity test: `zip -T <archive>` returned `OK`
- Readability test: `unzip -Z -1 <archive> | wc -l` returned `7727` entries

## Risks / Omissions
- No detected omissions for the company root scope above.
- Backup excludes only existing `backups` content by design to avoid nesting archives.
