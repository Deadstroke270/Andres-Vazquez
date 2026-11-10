#!/usr/bin/env bash
# Ultron's daily and weekly rhythm as OpenClaw automations (OpenClaw's old "heartbeat"
# feature was replaced by automations; `openclaw cron` is an alias of `openclaw automations`).
# Edit TZ, CHANNEL and TO, then run once:  bash automations.sh
set -euo pipefail

TZ_NAME="America/Chicago"      # your time zone
CHANNEL="telegram"             # where Ultron reports
TO="owner"                     # your chat id, or keep "owner" if your channel supports it

openclaw automations add \
  --name "War Room (morning)" \
  --cron "7 8 * * *" --tz "$TZ_NAME" \
  --session isolated --agent ultron \
  --message "Morning War Room. Follow AGENTS.md section 6: read the ledger, pull orders, plan today, spawn crew jobs within the limits, write today's report and send me the morning report (with the approval batch if we're in Phase 1)." \
  --announce --channel "$CHANNEL" --delivery-target "$TO"

openclaw automations add \
  --name "Evening check" \
  --cron "13 19 * * *" --tz "$TZ_NAME" \
  --session isolated --agent ultron \
  --message "Evening check. Follow AGENTS.md section 6: chase unfinished crew jobs, update the ledger, queue tomorrow's approval batch. Only message me if something needs me."

openclaw automations add \
  --name "Weekly review" \
  --cron "21 10 * * 0" --tz "$TZ_NAME" \
  --session isolated --agent ultron --thinking high \
  --message "Weekly review. Follow AGENTS.md section 6: what sold, what didn't, best niches, approval trend, spend vs budget, and one proposed experiment for next week. Ask before starting anything new." \
  --announce --channel "$CHANNEL" --delivery-target "$TO"

openclaw automations list
