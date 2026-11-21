#!/usr/bin/env bash
# Adds the Fiverr YouTube-thumbnail department (agent CANVAS) to an existing ULTRON station.
#   cd ~/ultron-download && git pull && bash ultron-openclaw/install-fiverr.sh
# Safe to run more than once. Backs up the config, never overwrites existing files,
# and only appends the Fiverr section to Ultron's AGENTS.md if it isn't there yet.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OC="$HOME/.openclaw"
ok()   { printf '\033[32m[ok]\033[0m %s\n' "$*"; }
warn() { printf '\033[33m[!!]\033[0m %s\n' "$*"; }
step() { printf '\n\033[1m== %s\033[0m\n' "$*"; }
die()  { printf '\033[31m[stop]\033[0m %s\n' "$*"; exit 1; }
cpn()  { cp --update=none "$@" 2>/dev/null || cp -n "$@"; }

step "1/5 Checks"
command -v openclaw >/dev/null || die "openclaw not found. Run this on the OpenClaw server."
[ -d "$OC/workspace-ultron" ] || die "Ultron isn't installed yet. Run ultron-openclaw/install.sh first."
ok "Ultron station found"

step "2/5 Backup"
STAMP="$(date +%Y%m%d-%H%M%S)"
cp "$OC/openclaw.json" "$OC/openclaw.json.bak-$STAMP" && ok "config backed up to $OC/openclaw.json.bak-$STAMP"
cp "$OC/workspace-ultron/AGENTS.md" "$OC/workspace-ultron/AGENTS.md.bak-$STAMP" && ok "Ultron's AGENTS.md backed up"

step "3/5 Files"
mkdir -p "$OC/workspace-canvas" "$OC/factory/fiverr"/{research,portfolio,orders}
cpn -r "$HERE/workspace-canvas/." "$OC/workspace-canvas/"
cpn "$HERE/factory/FIVERR-THUMBNAILS.md" "$OC/factory/"
cpn "$HERE/factory/fiverr/ORDERS.md" "$HERE/factory/fiverr/LESSONS.md" "$OC/factory/fiverr/"
if grep -q 'FIVERR-DEPARTMENT' "$OC/workspace-ultron/AGENTS.md"; then ok "Ultron already has the Fiverr section"
else cat "$HERE/factory/fiverr/ULTRON-SECTION.md" >> "$OC/workspace-ultron/AGENTS.md" && ok "added section 9 (Fiverr) to Ultron's AGENTS.md"; fi
if command -v magick >/dev/null || command -v convert >/dev/null; then ok "ImageMagick found (Canvas will add crisp text itself)"
else warn "ImageMagick not installed. Optional but recommended for clean thumbnail text: sudo apt install -y imagemagick"; fi

step "4/5 Add CANVAS to the config"
PATCH="$(mktemp)"
cat > "$PATCH" <<'EOF'
{
  agents: {
    entries: {
      canvas: { name: "CANVAS", workspace: "~/.openclaw/workspace-canvas", model: "anthropic/claude-sonnet-5-5",
                identity: { name: "CANVAS", emoji: "🎨" } },
      ultron: { subagents: { allowAgents: ["nova", "forge", "pixel", "canvas"] } },
    },
  },
}
EOF
if CUR="$(openclaw config get tools.agentToAgent.allow 2>/dev/null)" && [ -n "$CUR" ]; then
  if MERGED="$(printf '%s' "$CUR" | node -e 'let s="";process.stdin.on("data",d=>s+=d).on("end",()=>{const a=JSON.parse(s);if(!Array.isArray(a)||!a.length)process.exit(1);console.log(JSON.stringify([...new Set([...a,"canvas"])]))})' 2>/dev/null)"; then
    sed -i '$d' "$PATCH"; printf '  tools: { agentToAgent: { allow: %s } },\n}\n' "$MERGED" >> "$PATCH"
    ok "will add canvas to tools.agentToAgent.allow"
  fi
fi
echo "--- dry run (nothing written yet) ---"
openclaw config patch --file "$PATCH" --dry-run || { rm -f "$PATCH"; die "dry run failed; nothing changed. Send this output to Claude."; }
openclaw config patch --file "$PATCH" || { rm -f "$PATCH"; die "patch failed; restore with: cp $OC/openclaw.json.bak-$STAMP $OC/openclaw.json"; }
rm -f "$PATCH"
ok "CANVAS added; Ultron may now spawn it"

step "5/5 Verify"
sleep 2
openclaw agents list 2>/dev/null | grep -i -A2 canvas || warn "canvas not listed yet: run 'openclaw gateway restart' then 'openclaw agents list'"

step "Done"
cat <<EOF
Next: open ULTRON in the app and send:
  "Commander here. Launch the Fiverr thumbnail department: follow Part 1 of
   FIVERR-THUMBNAILS.md. Nova does the market research, Canvas makes 12 portfolio
   thumbnails, you write GIG.md. Send me the gig text and the portfolio for approval."
Undo: cp $OC/openclaw.json.bak-$STAMP $OC/openclaw.json && cp $OC/workspace-ultron/AGENTS.md.bak-$STAMP $OC/workspace-ultron/AGENTS.md
EOF
