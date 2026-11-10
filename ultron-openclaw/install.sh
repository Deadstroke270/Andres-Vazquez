#!/usr/bin/env bash
# One-shot installer for the ULTRON station. Run on the machine where OpenClaw runs:
#   cd ~/ultron-download && git pull && bash ultron-openclaw/install.sh
#
# Safe by design:
#   - backs up ~/.openclaw/openclaw.json first
#   - never overwrites existing workspace or factory files (cp -n)
#   - adds ONLY the four new agents; does not touch your existing agents, bindings or channels
#   - shows a dry run of the config change before applying it
#   - asks for missing API keys with hidden input and stores them in ~/.openclaw/.env
set -uo pipefail

TZ_NAME="${TZ_NAME:-America/Los_Angeles}"   # override: TZ_NAME=America/Chicago bash install.sh
CHANNEL="${CHANNEL:-telegram}"              # where Ultron's reports go
# NO_RESTART=1 skips the gateway restart (use when an OpenClaw agent runs this script itself).
# Safe to run again: every step skips work that is already done.
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OC="$HOME/.openclaw"
ENVF="$OC/.env"
AGENTS=(ultron nova forge pixel)
ok()   { printf '\033[32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[!!]\033[0m %s\n' "$*"; }
step() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
cpn()  { cp --update=none "$@" 2>/dev/null || cp -n "$@"; }  # copy without overwriting
die()  { printf '\033[31m[stop]\033[0m %s\n' "$*"; exit 1; }

step "1/7 Checks"
command -v openclaw >/dev/null || die "openclaw command not found on this machine. Run this where OpenClaw is installed."
[ -d "$OC" ] || die "$OC does not exist. Is OpenClaw set up for this user?"
ok "openclaw found: $(openclaw --version 2>/dev/null | head -1)"

step "2/7 Backup"
STAMP="$(date +%Y%m%d-%H%M%S)"
if [ -f "$OC/openclaw.json" ]; then
  cp "$OC/openclaw.json" "$OC/openclaw.json.bak-$STAMP" && ok "config backed up to $OC/openclaw.json.bak-$STAMP"
else
  warn "no $OC/openclaw.json found (OpenClaw may keep config elsewhere); continuing"
fi

step "3/7 Copy workspaces and factory files (never overwrites)"
for a in "${AGENTS[@]}"; do
  if [ -d "$OC/workspace-$a" ]; then warn "workspace-$a already exists: only adding files that are missing"; fi
  mkdir -p "$OC/workspace-$a"
  cpn -r "$HERE/workspace-$a/." "$OC/workspace-$a/"
done
mkdir -p "$OC/factory"
cpn "$HERE"/factory/*.md "$OC/factory/"
# Set the time zone in Ultron's USER.md only if it still has the template default.
sed -i.orig "s#America/Chicago  <!-- change to yours -->#$TZ_NAME  <!-- change to yours -->#" "$OC/workspace-ultron/USER.md" && rm -f "$OC/workspace-ultron/USER.md.orig"
ok "files copied to $OC"

step "4/7 API keys (stored in $ENVF, values never printed)"
touch "$ENVF" && chmod 600 "$ENVF"
has_key() { grep -q "^$1=." "$ENVF" 2>/dev/null || [ -n "${!1:-}" ]; }
if has_key PRINTIFY_API_KEY; then ok "PRINTIFY_API_KEY already set"
else
  printf 'Paste your Printify API token (Printify > Account > Connections), then Enter.\nLeave empty to skip for now: '
  read -rs KEY; echo
  if [ -n "$KEY" ]; then printf 'PRINTIFY_API_KEY=%s\n' "$KEY" >> "$ENVF"; ok "PRINTIFY_API_KEY saved"; else warn "skipped: Forge can't create products until you add PRINTIFY_API_KEY to $ENVF"; fi
  unset KEY
fi
IMG_PATCH=""
if has_key OPENAI_API_KEY; then
  ok "OPENAI_API_KEY found (image model: openai/gpt-image-2)"
  if ! openclaw config get agents.defaults.mediaModels.image >/dev/null 2>&1; then
    IMG_PATCH='defaults: { mediaModels: { image: { primary: "openai/gpt-image-2", timeoutMs: 180000 } } },'
  else ok "you already have an image model configured; keeping it"; fi
elif has_key GEMINI_API_KEY; then
  ok "GEMINI_API_KEY found; keeping your current image model settings"
else
  warn "no OPENAI_API_KEY or GEMINI_API_KEY found. If your OpenClaw already makes images (e.g. ChatGPT sign-in), ignore this; otherwise add one to $ENVF"
fi

step "5/7 Add the four agents to the config"
PATCH="$(mktemp)"
cat > "$PATCH" <<EOF
{
  agents: {
    $IMG_PATCH
    entries: {
      ultron: { name: "ULTRON", workspace: "~/.openclaw/workspace-ultron", model: "anthropic/claude-opus-5-5",
                thinkingDefault: "high", identity: { name: "ULTRON", emoji: "🤖" },
                subagents: { allowAgents: ["nova", "forge", "pixel"] } },
      nova:  { name: "NOVA",  workspace: "~/.openclaw/workspace-nova",  model: "anthropic/claude-sonnet-5-5", identity: { name: "NOVA",  emoji: "🔭" } },
      forge: { name: "FORGE", workspace: "~/.openclaw/workspace-forge", model: "anthropic/claude-sonnet-5-5", identity: { name: "FORGE", emoji: "🏭" } },
      pixel: { name: "PIXEL", workspace: "~/.openclaw/workspace-pixel", model: "anthropic/claude-sonnet-5-5", identity: { name: "PIXEL", emoji: "📱" } },
    },
  },
}
EOF
# If you restrict agent-to-agent access with an allow list, add the four ids to it (arrays replace, so merge here).
if CUR="$(openclaw config get tools.agentToAgent.allow 2>/dev/null)" && [ -n "$CUR" ]; then
  if MERGED="$(printf '%s' "$CUR" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const a=JSON.parse(s);if(!Array.isArray(a))process.exit(1);const add=["ultron","nova","forge","pixel"];if(a.length===0){process.exit(2)}console.log(JSON.stringify([...new Set([...a,...add])]))})' 2>/dev/null)"; then
    sed -i '$d' "$PATCH"; printf '  tools: { agentToAgent: { allow: %s } },\n}\n' "$MERGED" >> "$PATCH"
    ok "will add the four agents to your existing tools.agentToAgent.allow list"
  else
    warn "couldn't read tools.agentToAgent.allow automatically; if Ultron can't reach the crew, add ultron/nova/forge/pixel to it"
  fi
fi
echo "--- dry run (nothing written yet) ---"
openclaw config patch --file "$PATCH" --dry-run || { rm -f "$PATCH"; die "dry run failed; config unchanged. Send this output to Claude."; }
openclaw config patch --file "$PATCH" || { rm -f "$PATCH"; die "patch failed; restore with: cp $OC/openclaw.json.bak-$STAMP $OC/openclaw.json"; }
rm -f "$PATCH"
ok "agents added (your existing agents, bindings and channels were not changed)"

step "6/7 Load the new agents"
if openclaw agents list 2>/dev/null | grep -qi ultron; then ok "gateway already sees ultron"
elif [ -n "${NO_RESTART:-}" ]; then
  warn "NO_RESTART is set: not restarting. Run 'openclaw gateway restart', then run this script again to finish scheduling"
else
  warn "restarting the OpenClaw gateway so it loads the new agents (running chats pause for a few seconds)"
  openclaw gateway restart || warn "restart failed: run 'openclaw gateway restart' yourself"
  sleep 5
fi
openclaw agents list 2>/dev/null | grep -i -E 'ultron|nova|forge|pixel' || warn "new agents not listed yet; run: openclaw agents list"
openclaw skills list --agent forge 2>/dev/null | grep -qi printify && ok "forge has the printify skill" || warn "printify skill not listed for forge yet (start a new forge session or restart the gateway)"

step "7/7 Schedule Ultron's War Room (skips jobs that already exist)"
EXISTING="$(openclaw automations list --all 2>/dev/null || true)"
add_job() { # name cron message [extra flags...]
  local name="$1" cron="$2" msg="$3"; shift 3
  if grep -qF "$name" <<<"$EXISTING"; then ok "'$name' already exists"; return; fi
  openclaw automations add --name "$name" --cron "$cron" --tz "$TZ_NAME" --session isolated --agent ultron --message "$msg" "$@" \
    && ok "added '$name'" || warn "could not add '$name' (see error above)"
}
add_job "Ultron War Room (morning)" "7 8 * * *" \
  "Morning War Room. Follow AGENTS.md section 6: read the ledger, pull orders, plan today, spawn crew jobs within the limits, write today's report and send me the morning report (with the approval batch if we're in Phase 1)." \
  --announce --channel "$CHANNEL" --delivery-target owner
add_job "Ultron evening check" "13 19 * * *" \
  "Evening check. Follow AGENTS.md section 6: chase unfinished crew jobs, update the ledger, queue tomorrow's approval batch. Only message me if something needs me."
add_job "Ultron weekly review" "21 10 * * 0" \
  "Weekly review. Follow AGENTS.md section 6: what sold, what didn't, best niches, approval trend, spend vs budget, and one proposed experiment for next week. Ask before starting anything new." \
  --thinking high --announce --channel "$CHANNEL" --delivery-target owner

step "Done"
cat <<EOF
Next:
  1. Edit Ultron's profile:   nano $OC/workspace-ultron/USER.md   (niche, styles, budget)
  2. In Printify: Manage stores -> connect your Etsy shop.
  3. Open the OpenClaw app, pick ULTRON in the sidebar, and send:
     "Commander here. Run the first War Room: have Nova research my niche and give me
      10 briefs, then have Forge make the first approval batch."
Undo everything: cp $OC/openclaw.json.bak-$STAMP $OC/openclaw.json && openclaw gateway restart
EOF
