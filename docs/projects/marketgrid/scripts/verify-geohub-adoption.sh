#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../../../" && pwd)"
cd "$ROOT_DIR"

TARGETS=(
  "docs/projects/marketgrid/packets/MAR-1124"
  "docs/projects/marketgrid/packets/MAR-1130"
)
REGISTRY_PATH="docs/projects/marketgrid/working-document-registry.json"

echo "CHECK0: working-document registry version metadata"
jq -e '
  .standard_version
  and .schema_version
  and .artifact_revision
  and .updated_at
  and .authority
  and .documents
' "$REGISTRY_PATH" >/dev/null

jq -e '
  .documents
  | to_entries
  | all(
      .value.path
      and .value.standard_version
      and .value.schema_version
      and .value.artifact_revision
      and .value.upgrade_state
      and .value.promotion_state
      and .value.owner_role
      and .value.last_issue
      and .value.updated_at
    )
' "$REGISTRY_PATH" >/dev/null
echo "CHECK0_OK"

echo "CHECK1: canonical outcomes only"
if rg -n "outcome:" -S "${TARGETS[@]}" \
  | rg -v "outcome:(pass_generation_ready|pass_with_waivers_generation_ready|pass_research_grade|fail)"; then
  echo "NON_CANONICAL_OUTCOME_FOUND"
  exit 1
fi
echo "CHECK1_OK"

echo "CHECK2: validate outcome -> transition mapping"
JSON_FILES=()
while IFS= read -r file; do
  JSON_FILES+=("$file")
done < <(find "${TARGETS[@]}" -type f -name '*.json' | sort)

echo "CHECK1B: packet version metadata present"
for f in "${JSON_FILES[@]}"; do
  jq -e 'has("contract_version") and has("artifact_revision")' "$f" >/dev/null
done
echo "CHECK1B_OK"

echo "CHECK1C: canonical packet path coherence (issue/batch/stage)"
for f in "${JSON_FILES[@]}"; do
  rel="${f#docs/projects/marketgrid/packets/}"
  issue_dir="${rel%%/*}"
  rest="${rel#*/}"
  batch_dir="${rest%%/*}"
  file_name="${f##*/}"

  packet_issue="$(jq -r '.issue // empty' "$f")"
  packet_batch="$(jq -r '.batch_id // empty' "$f")"
  packet_stage="$(jq -r '.stage // empty' "$f")"

  if [[ -z "$packet_issue" || -z "$packet_batch" || -z "$packet_stage" ]]; then
    echo "CHECK1C_MISSING_CORE_FIELDS -> $f"
    exit 1
  fi

  if [[ "$packet_issue" != "$issue_dir" ]]; then
    echo "CHECK1C_ISSUE_PATH_MISMATCH -> $f (packet:$packet_issue path:$issue_dir)"
    exit 1
  fi

  if [[ "$packet_batch" != "$batch_dir" ]]; then
    echo "CHECK1C_BATCH_PATH_MISMATCH -> $f (packet:$packet_batch path:$batch_dir)"
    exit 1
  fi

  if [[ ! "$file_name" =~ ^${packet_stage}(\-[a-z0-9_]+)?\.packet\.json$ ]]; then
    echo "CHECK1C_STAGE_FILE_MISMATCH -> $f (packet stage:$packet_stage)"
    exit 1
  fi
done
echo "CHECK1C_OK"

CHECK2_ROWS="$(
  jq -r '
    def expected_transition($outcome):
      if $outcome == "outcome:pass_generation_ready" then "transition:validate:pass_generation_ready->generate"
      elif $outcome == "outcome:pass_with_waivers_generation_ready" then "transition:validate:pass_with_waivers_generation_ready->generate"
      elif $outcome == "outcome:pass_research_grade" then "transition:validate:pass_research_grade->done"
      elif $outcome == "outcome:fail" then "transition:validate:fail->enrich"
      else null
      end;

    select(.stage == "validate")
    | (.quality_gate.reason_codes // []) as $codes
    | ($codes[]? | select(startswith("outcome:"))) as $outcome
    | ($codes[]? | select(startswith("transition:validate:"))) as $transition
    | (expected_transition($outcome)) as $expected
    | [
        .issue,
        .batch_id,
        $outcome,
        $transition,
        $expected,
        (if $expected == null then "INVALID_OUTCOME"
         elif $transition == null then "MISSING_TRANSITION"
         elif $transition != $expected then "INVALID_MAPPING"
         else "OK" end)
      ] | @tsv
  ' "${JSON_FILES[@]}"
)"

echo "$CHECK2_ROWS"

if echo "$CHECK2_ROWS" | rg -q $'\t(INVALID_OUTCOME|MISSING_TRANSITION|INVALID_MAPPING)$'; then
  echo "CHECK2_INVALID_MAPPING_FOUND"
  exit 1
fi
echo "CHECK2_OK"

echo "CHECK3: required backward transitions present"
rg -n "transition:validate:fail->enrich|transition:generate:qa_fail->validate" -S "${TARGETS[@]}"
echo "CHECK3_OK"

echo "CHECK4: generation-eligible validate packets include geohub prerequisite evidence"
CHECK4_ROWS="$(
  jq -r '
    def has_generate_transition($codes):
      ($codes | index("transition:validate:pass_generation_ready->generate")) != null
      or ($codes | index("transition:validate:pass_with_waivers_generation_ready->generate")) != null;

    def has_geohub_skill_ref($refs):
      any(
        $refs[];
        test("skills/5185d615-76d8-4951-99a1-a25ca749f89e")
        and test("Build Geohub Intelligence Packet")
        and test("build-geohub-intelligence-packet")
      );

    def has_geohub_approval_ref($refs):
      any(
        $refs[];
        test("geohub packet approval:(pass_research_grade|pass_with_waivers_generation_ready|pass_generation_ready)")
      );

    select(.stage == "validate")
    | (.quality_gate.reason_codes // []) as $codes
    | (.input_refs // []) as $refs
    | (has_generate_transition($codes)) as $eligible
    | (has_geohub_skill_ref($refs)) as $skill_ok
    | (has_geohub_approval_ref($refs)) as $approval_ok
    | [
        .issue,
        .batch_id,
        (if $eligible then "generation_eligible" else "not_generation_eligible" end),
        (if $skill_ok then "skill_ref_ok" else "skill_ref_missing" end),
        (if $approval_ok then "approval_ref_ok" else "approval_ref_missing" end),
        (if ($eligible and (($skill_ok | not) or ($approval_ok | not)))
         then "MISSING_GEOHUB_PREREQ"
         else "OK" end)
      ] | @tsv
  ' "${JSON_FILES[@]}"
)"

echo "$CHECK4_ROWS"

if echo "$CHECK4_ROWS" | rg -q $'\tMISSING_GEOHUB_PREREQ$'; then
  echo "CHECK4_MISSING_GEOHUB_PREREQ_FOUND"
  exit 1
fi
echo "CHECK4_OK"
