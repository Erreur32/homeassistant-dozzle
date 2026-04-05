#!/usr/bin/env bash
# ──────────────────────────────────────────────────────────────────────────────
# Bump HA Dozzle app version across the repo (run from project root).
# Usage:   ./update_version.sh <new_version>
#          ./update_version.sh <new_version> --tag-push
#
# Updated files:
#   1. dozzle/config.yaml     - version (manifest Supervisor / store)
#   2. dozzle/Dockerfile      - ARG BUILD_VERSION (default image label / local builds)
#   3. README.md (root)       - always, if present:
#        • [release-shield] / version-vCURRENT-blue → NEW (reference links at file bottom)
#        • releases/tag/vCURRENT → vNEW
#        • `CURRENT` → `NEW` in backticks (About table: packaged app version)
#        • line "Bundled Dozzle binary" → backticks set from ARG DOZZLE_VERSION in Dockerfile
#   4. dozzle/README.md       - same badge/link patterns as (3), if those lines exist
#
# Commit message file (edit before committing):
#   5. commit-message.txt     - git commit -F commit-message.txt
#
# Options:
#   --tag-push   Après bump : commit (si fichiers modifiés), tag v<NEW>, puis
#                fetch + rebase sur origin/<branche> si besoin, push branche et tag.
#                commit-message.txt est complété avec « release: v<NEW> » si besoin.
#
# Not auto-updated (do manually):
#   - dozzle/CHANGELOG.md (release notes)
#   - ARG DOZZLE_VERSION in Dockerfile (bump upstream Dozzle binary separately; README
#     "Bundled Dozzle binary" row is synced FROM Dockerfile on each app version bump)
# ──────────────────────────────────────────────────────────────────────────────

set -e

# ── ANSI colors (disable if not a TTY) ───────────────────────────────────────
if [ -t 1 ]; then
  R="\033[0m"
  B="\033[1m"
  G="\033[32m"
  Y="\033[33m"
  C="\033[36m"
  M="\033[35m"
  RED="\033[31m"
else
  R="" B="" G="" Y="" C="" M="" RED=""
fi

# ── Repo root (script at repository root) ───────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$SCRIPT_DIR"
cd "$REPO_ROOT"

CONFIG_YAML="$REPO_ROOT/dozzle/config.yaml"
DOCKERFILE="$REPO_ROOT/dozzle/Dockerfile"
ROOT_README="$REPO_ROOT/README.md"
DOZZLE_README="$REPO_ROOT/dozzle/README.md"
COMMIT_MSG_FILE="$REPO_ROOT/commit-message.txt"

# ── Current version from dozzle/config.yaml ─────────────────────────────────
if [ ! -f "$CONFIG_YAML" ]; then
  echo -e "${RED}Error:${R} $CONFIG_YAML not found"
  exit 1
fi

CURRENT=$(grep -E '^version:' "$CONFIG_YAML" | head -1 | sed -n 's/^version:[[:space:]]*"\([^"]*\)".*/\1/p')
if [ -z "$CURRENT" ]; then
  CURRENT=$(grep -E '^version:' "$CONFIG_YAML" | head -1 | sed -n 's/^version:[[:space:]]*\([^[:space:]#]*\).*/\1/p')
fi
CURRENT=$(echo "$CURRENT" | tr -d '[:space:]')
if [ -z "$CURRENT" ]; then
  echo -e "${RED}Error:${R} could not read version from dozzle/config.yaml"
  exit 1
fi

# ── Current Dozzle upstream version (from Dockerfile) ────────────────────────
DOZZLE_CURRENT=""
if [ -f "$DOCKERFILE" ]; then
  DOZZLE_CURRENT=$(grep -E '^ARG DOZZLE_VERSION=' "$DOCKERFILE" | head -1 | sed 's/^ARG DOZZLE_VERSION=//')
fi

# ── Latest Dozzle version from GitHub API ────────────────────────────────────
DOZZLE_LATEST=""
if command -v curl >/dev/null 2>&1; then
  DOZZLE_LATEST=$(curl -sf --max-time 5 \
    "https://api.github.com/repos/amir20/dozzle/releases/latest" \
    | grep '"tag_name"' | head -1 \
    | sed 's/.*"tag_name":[[:space:]]*"\([^"]*\)".*/\1/' 2>/dev/null || true)
fi

# ── Args: new version + optional --tag-push ─────────────────────────────────
NEW=""
TAG_PUSH=""
for arg in "$@"; do
  if [ "$arg" = "--tag-push" ]; then
    TAG_PUSH="1"
  elif [ -z "$NEW" ]; then
    NEW="$arg"
  fi
done

if [ -z "$NEW" ]; then
  SUGGESTED=$(echo "$CURRENT" | awk -F. '{$NF=$NF+1; print $0}' OFS=.)
  echo ""
  echo -e "${M}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo -e "${M}${B}  HA Dozzle - current state${R}"
  echo -e "${M}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo ""
  echo -e "  ${B}App version  (config.yaml):${R}  ${C}${CURRENT}${R}  →  suggested next: ${C}${SUGGESTED}${R}"
  echo ""
  if [ -n "$DOZZLE_CURRENT" ]; then
    if [ -n "$DOZZLE_LATEST" ] && [ "$DOZZLE_LATEST" != "$DOZZLE_CURRENT" ]; then
      echo -e "  ${B}Dozzle binary (Dockerfile):${R}  ${Y}${DOZZLE_CURRENT}${R}  →  latest: ${G}${DOZZLE_LATEST}${R}  ${Y}⬆ update available${R}"
    elif [ -n "$DOZZLE_LATEST" ]; then
      echo -e "  ${B}Dozzle binary (Dockerfile):${R}  ${G}${DOZZLE_CURRENT}${R}  ${G}✓ up to date${R} (latest: ${DOZZLE_LATEST})"
    else
      echo -e "  ${B}Dozzle binary (Dockerfile):${R}  ${C}${DOZZLE_CURRENT}${R}  ${Y}(could not fetch latest - no network?)${R}"
    fi
  fi
  echo ""
  echo "  Usage: $0 <new_version> [--tag-push]"
  echo ""
  echo "  Examples:"
  echo -e "    ${C}$0 ${SUGGESTED}${R}              # bump only"
  echo -e "    ${C}$0 ${SUGGESTED} --tag-push${R}   # bump + commit + tag + push"
  echo ""
  exit 0
fi

# ── sed in-place (macOS / Linux) ────────────────────────────────────────────
sedi() {
  local file="$1"
  shift
  sed -i.bak "$@" "$file" && rm -f "${file}.bak"
}

CURRENT_ESC=$(echo "$CURRENT" | sed 's/\./\\./g')

# ═══════════════════════════════════════════════════════════════════════════
#  Version bump (skip file edits if already at NEW, unless only --tag-push)
# ═══════════════════════════════════════════════════════════════════════════

if [ "$NEW" = "$CURRENT" ] && [ -z "$TAG_PUSH" ]; then
  echo -e "${Y}Warning:${R} new version ($NEW) equals current ($CURRENT). Nothing to do."
  exit 0
fi

if [ "$NEW" != "$CURRENT" ]; then
  echo ""
  echo -e "${M}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo -e "${M}${B}  Bump HA Dozzle app: ${CURRENT} → ${NEW}${R}"
  echo -e "${M}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo ""
  echo -e "  ${B}── Version bump ──${R}"

  # 1. dozzle/config.yaml
  if [ -f "$CONFIG_YAML" ]; then
    sedi "$CONFIG_YAML" "s/^version:.*/version: \"${NEW}\"/"
    echo -e "  ${G}✓${R} dozzle/config.yaml        ${C}version: \"${NEW}\"${R}"
  else
    echo -e "  ${RED}✗${R} dozzle/config.yaml        ${RED}(missing)${R}"
  fi

  # 2. dozzle/Dockerfile - ARG BUILD_VERSION + ARG DOZZLE_VERSION if newer available
  if [ -f "$DOCKERFILE" ]; then
    sedi "$DOCKERFILE" "s/^ARG BUILD_VERSION=.*/ARG BUILD_VERSION=${NEW}/"
    echo -e "  ${G}✓${R} dozzle/Dockerfile         ${C}ARG BUILD_VERSION=${NEW}${R}"
    # Auto-update upstream Dozzle version if newer is available
    if [ -n "$DOZZLE_LATEST" ] && [ -n "$DOZZLE_CURRENT" ] && [ "$DOZZLE_LATEST" != "$DOZZLE_CURRENT" ]; then
      sedi "$DOCKERFILE" "s/^ARG DOZZLE_VERSION=.*/ARG DOZZLE_VERSION=${DOZZLE_LATEST}/"
      echo -e "  ${G}✓${R} dozzle/Dockerfile         ${C}ARG DOZZLE_VERSION: ${DOZZLE_CURRENT} → ${DOZZLE_LATEST}${R}  ${G}⬆ updated${R}"
      DOZZLE_BUMPED="1"
    elif [ -n "$DOZZLE_CURRENT" ]; then
      echo -e "  ${G}✓${R} dozzle/Dockerfile         ${C}ARG DOZZLE_VERSION=${DOZZLE_CURRENT}${R}  ${G}(up to date)${R}"
    fi
  else
    echo -e "  ${RED}✗${R} dozzle/Dockerfile         ${RED}(missing)${R}"
  fi

  # 3. README.md (root) - release badge / tag URL / About table (exact CURRENT → NEW)
  #     Reference-style shields: [release-shield]: .../version-v0.0.1-blue.svg - no grep gate
  if [ -f "$ROOT_README" ]; then
    if grep -q "version-v${CURRENT_ESC}-blue" "$ROOT_README" 2>/dev/null; then
      sedi "$ROOT_README" "s/version-v${CURRENT_ESC}-blue/version-v${NEW}-blue/g"
    fi
    if grep -q "releases/tag/v${CURRENT_ESC}" "$ROOT_README" 2>/dev/null; then
      sedi "$ROOT_README" "s|releases/tag/v${CURRENT_ESC}|releases/tag/v${NEW}|g"
    fi
    # Packaged app version (About table): `CURRENT` → `NEW` wherever that exact semver appears in backticks
    sedi "$ROOT_README" "s/\`${CURRENT_ESC}\`/\`${NEW}\`/g"
    # Bundled Dozzle binary - mirror ARG DOZZLE_VERSION from Dockerfile (first `...` on that line)
    if [ -f "$DOCKERFILE" ]; then
      DOZZLE_VER=$(grep -E '^ARG DOZZLE_VERSION=' "$DOCKERFILE" | head -1 | sed 's/^ARG DOZZLE_VERSION=//')
      if [ -n "$DOZZLE_VER" ] && grep -q 'Bundled Dozzle binary' "$ROOT_README" 2>/dev/null; then
        sedi "$ROOT_README" "/Bundled Dozzle binary/s/\`[^\`]*\`/\`${DOZZLE_VER}\`/"
      fi
    fi
    echo -e "  ${G}✓${R} README.md                 ${C}(release badge, tag URL, app + bundled versions)${R}"
  else
    echo -e "  ${Y}○${R} README.md                 ${Y}(not found)${R}"
  fi

  # 4. dozzle/README.md - same semver replacements if those strings exist
  if [ -f "$DOZZLE_README" ]; then
    if grep -q "version-v${CURRENT_ESC}-blue" "$DOZZLE_README" 2>/dev/null; then
      sedi "$DOZZLE_README" "s/version-v${CURRENT_ESC}-blue/version-v${NEW}-blue/g"
    fi
    if grep -q "releases/tag/v${CURRENT_ESC}" "$DOZZLE_README" 2>/dev/null; then
      sedi "$DOZZLE_README" "s|releases/tag/v${CURRENT_ESC}|releases/tag/v${NEW}|g"
    fi
    if grep -q "\`${CURRENT_ESC}\`" "$DOZZLE_README" 2>/dev/null; then
      sedi "$DOZZLE_README" "s/\`${CURRENT_ESC}\`/\`${NEW}\`/g"
    fi
    echo -e "  ${G}✓${R} dozzle/README.md          ${C}(checked)${R}"
  else
    echo -e "  ${Y}○${R} dozzle/README.md          ${Y}(not found)${R}"
  fi

  echo ""
  echo -e "  ${B}── commit-message.txt ──${R}"
  # Always ensure a usable commit message for -F (avoids the generic fallback)
  if [ ! -f "$COMMIT_MSG_FILE" ]; then
    if [ -n "$DOZZLE_BUMPED" ]; then
      cat > "$COMMIT_MSG_FILE" << CMEOF
release: v${NEW}

- App version ${NEW}
- Dozzle binary: ${DOZZLE_CURRENT} → ${DOZZLE_LATEST}
CMEOF
    else
      cat > "$COMMIT_MSG_FILE" << CMEOF
release: v${NEW}

- Version ${NEW}
CMEOF
    fi
    echo -e "  ${G}✓${R} commit-message.txt        ${C}(created - release: v${NEW})${R}"
  elif ! grep -qE "v${NEW}|release:.*${NEW}" "$COMMIT_MSG_FILE" 2>/dev/null; then
    {
      echo "release: v${NEW}"
      echo ""
      cat "$COMMIT_MSG_FILE"
    } > "${COMMIT_MSG_FILE}.tmp" && mv "${COMMIT_MSG_FILE}.tmp" "$COMMIT_MSG_FILE"
    echo -e "  ${G}✓${R} commit-message.txt        ${C}(release: v${NEW} prepended)${R}"
  else
    echo -e "  ${G}✓${R} commit-message.txt        ${C}(already up to date for v${NEW})${R}"
  fi

  echo ""
  echo -e "${G}${B}Done.${R} App version is now ${B}${NEW}${R}."
  echo ""
  echo -e "  ${B}── Also update manually ──${R}"
  echo -e "  ${C}  dozzle/CHANGELOG.md${R}"
  echo ""
fi

# ═══════════════════════════════════════════════════════════════════════════
#  --tag-push
# ═══════════════════════════════════════════════════════════════════════════

do_commit_tag_push() {
  local branch

  if ! command -v git >/dev/null 2>&1; then
    echo -e "${RED}Error:${R} ${C}git${R} command not found (PATH)."
    echo -e "  Install Git or open a terminal where Git is available."
    return 1
  fi

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}Error:${R} this folder is not a Git repository (no ${C}.git${R} found here)."
    echo -e "  ${Y}Common cause:${R} copy on NAS / share without history, or script run outside the clone root."
    echo -e "  ${Y}Suggestions:${R}"
    echo -e "    • ${C}git clone <url>${R} the repository then re-run the script inside the clone."
    echo -e "    • Or ${C}git init${R} at the project root, ${C}git remote add origin …${R}, then first commit."
    echo -e "  Current directory: ${C}$(pwd)${R}"
    return 1
  fi

  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
  if [ "$branch" = "HEAD" ]; then
    echo -e "${RED}Error:${R} detached HEAD - switch to a branch before pushing."
    echo -e "  Example: ${C}git checkout main${R} or ${C}git switch main${R}"
    return 1
  fi
  if [ -z "$branch" ]; then
    echo -e "${RED}Error:${R} could not read current branch (${C}git rev-parse${R})."
    return 1
  fi

  local tag_name="v${NEW}"

  # Commit message: if bumped without --tag-push and tag-push is run later, file may be missing vNEW
  if [ -f "$COMMIT_MSG_FILE" ] && ! grep -qE "v${NEW}|release:.*${NEW}" "$COMMIT_MSG_FILE" 2>/dev/null; then
    {
      echo "release: v${NEW}"
      echo ""
      cat "$COMMIT_MSG_FILE"
    } > "${COMMIT_MSG_FILE}.tmp" && mv "${COMMIT_MSG_FILE}.tmp" "$COMMIT_MSG_FILE"
    echo -e "  ${G}✓${R} commit-message.txt        ${C}(updated for v${NEW})${R}"
  fi

  if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    echo -e "  ${B}Uncommitted changes - git add / commit...${R}"
    git add -A
    if [ -f "$COMMIT_MSG_FILE" ] && grep -qE "v${NEW}|release:.*${NEW}" "$COMMIT_MSG_FILE" 2>/dev/null; then
      git commit -F "$COMMIT_MSG_FILE" || { echo -e "${RED}Commit failed.${R}"; return 1; }
      echo -e "  ${G}✓${R} Committed with ${C}commit-message.txt${R}"
    else
      git commit -m "release: v${NEW}" || { echo -e "${RED}Commit failed.${R}"; return 1; }
      echo -e "  ${G}✓${R} Committed ${C}release: v${NEW}${R}"
    fi
    echo ""
  else
    echo -e "  ${G}✓${R} Working tree clean - no new commit."
    echo ""
  fi

  if git rev-parse "$tag_name" >/dev/null 2>&1; then
    echo -e "  ${Y}⚠${R} Tag ${C}${tag_name}${R} already exists locally."
  else
    git tag -a "$tag_name" -m "Release ${tag_name}" || { echo -e "${RED}Tag failed.${R}"; return 1; }
    echo -e "  ${G}✓${R} Tag ${C}${tag_name}${R} created."
  fi

  # Sync with origin before push (avoids "fetch first" / non-fast-forward)
  if git remote get-url origin >/dev/null 2>&1; then
    echo -e "  ${B}Syncing with origin...${R}"
    git fetch origin || true
    if git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
      if ! git merge-base --is-ancestor "origin/${branch}" HEAD 2>/dev/null; then
        echo -e "  ${Y}→${R} Remote branch has new commits - ${C}git pull --rebase origin ${branch}${R}"
        git pull --rebase origin "$branch" || {
          echo -e "${RED}Rebase interrupted (conflicts?).${R} Resolve then: ${C}git rebase --continue${R}"
          return 1
        }
      fi
    fi
  fi

  echo -e "  ${B}Pushing branch ${C}${branch}${R} + tag ${C}${tag_name}${R}...${R}"
  if ! git push origin "$branch" "$tag_name"; then
    echo -e "  ${Y}→${R} Push rejected - retrying after rebase..."
    git fetch origin
    if git show-ref --verify --quiet "refs/remotes/origin/${branch}" 2>/dev/null; then
      git pull --rebase origin "$branch" || {
        echo -e "${RED}Rebase failed.${R}"
        return 1
      }
    fi
    git push origin "$branch" "$tag_name" || { echo -e "${RED}Push failed.${R}"; return 1; }
  fi
  echo -e "  ${G}✓${R} Branch + tag pushed."
  echo ""
  echo -e "  ${G}✓${R} Done."
  return 0
}

if [ -n "$TAG_PUSH" ]; then
  echo ""
  echo -e "${C}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo -e "${C}${B}  Commit, tag and push (--tag-push)${R}"
  echo -e "${C}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo ""
  do_commit_tag_push || exit 1
  exit 0
fi

# ═══════════════════════════════════════════════════════════════════════════
#  Manual next steps (no --tag-push)
# ═══════════════════════════════════════════════════════════════════════════

if [ "$NEW" != "$CURRENT" ]; then
  echo ""
  echo -e "${Y}→${R} Edit ${B}commit-message.txt${R} and ${B}dozzle/CHANGELOG.md${R} for v${NEW}."
  echo ""
  echo -e "${C}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo -e "${C}${B}  Commands (copy / paste)${R}"
  echo -e "${C}${B}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${R}"
  echo ""
  echo -e "  ${G}git add -A && git commit -F commit-message.txt${R}"
  echo ""
  echo -e "  ${G}git tag -a v${NEW} -m \"Release v${NEW}\" && git push origin main v${NEW}${R}"
  echo ""
  echo -e "  ${B}Or:${R} ${C}$0 ${NEW} --tag-push${R}"
  echo ""
fi
