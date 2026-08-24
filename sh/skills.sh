#!/usr/bin/env bash

. sh/utils.sh

# Skill repository definitions
belsrc_skills=(
  "engineering-council"
  "human-english"
  "socratic-tutor"
  "ticket-creator"
)

hypergiant_skills=(
  "accelint-archive-synthesis"
  "accelint-architecture-doc"
  "accelint-onboard-agents"
  "accelint-onboard-openspec"
  "accelint-qrspi-apply"
  "accelint-qrspi-archive"
  "accelint-qrspi-propose"
  "accelint-readme-writer"
  "constraints-extractor"
  "epistemic-mapper"
  "jargon-extractor"
)

# Install a batch of skills from a single repository via npx
# Installs for both Codex and Claude Code harnesses
install_skill_group() {
  local repo_url=$1
  local group_name=$2
  shift 2
  local skills=("$@")
  local args=()

  if [[ ${#skills[@]} -eq 0 ]]; then
    warn "No skills configured for $group_name"
    return 0
  fi

  info "Installing $group_name skills:"
  for skill in "${skills[@]}"; do
    info "  - $skill"
  done

  for skill in "${skills[@]}"; do
    args+=(--skill "$skill")
  done

  # npx skills handles directory creation and checks for existing installations
  # -a flag specifies multiple agents (claude-code, codex)
  if npx skills add "$repo_url" -g -y "${args[@]}" -a universal -a claude-code -a codex > /dev/null; then
    success "$group_name skills installed"
    return 0
  else
    warn "$group_name skills installation may have failed"
    return 1
  fi
}

# Install skills from belsrc repository
install_belsrc_skills() {
  local repo_url="https://github.com/belsrc/skills"

  install_skill_group "$repo_url" "belsrc" "${belsrc_skills[@]}"
}

# Install skills from Hypergiant repository
install_hypergiant_skills() {
  local repo_url="https://github.com/gohypergiant/agent-skills"

  install_skill_group "$repo_url" "hypergiant" "${hypergiant_skills[@]}"
}

# Main skill installation orchestrator
install_skills() {
  install_belsrc_skills
  install_hypergiant_skills
}
