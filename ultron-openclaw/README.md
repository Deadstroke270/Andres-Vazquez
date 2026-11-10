# ULTRON for OpenClaw — autonomous print-on-demand clothing station

A four-agent OpenClaw setup modeled on androoAGI's "minion station": **ULTRON** (manager,
Claude Opus 5.5) runs **NOVA** (research), **FORGE** (design + Printify + Etsy) and
**PIXEL** (TikTok slideshows). It sells original apparel designs on Etsy, printed and
shipped by Printify.

## What androoAGI actually runs (research summary)

Sources: transcripts of 6 of his TikToks (Apr-Oct 2026, 37K-1.7M views each) and the
public source code of his app, StarNet (github.com/androoAGI/starnet, MIT license).

- **Ultron = manager agent.** It sits in the center of the station and its only job is
  keeping the other agents working. In June 2026 he said Ultron was a Hermes agent on
  GPT-5.5. Ultron's actual prompt is not public; it lives in his own workspace, not
  the StarNet repo.
- **The Etsy recipe (his "How to start your own autonomous Etsy store" video):**
  1. **Nova (research)** studies Etsy all day: best-selling products and young shops with
     lots of sales.
  2. **Forge (factory)** designs with an image model (Nano Banana Pro at first, later GPT
     Image 2) and puts designs on Printify (and Printful) templates. Printify prints and
     ships each Etsy order.
  3. **Pixel (media)** turns Forge's clean, model-free mockups into TikTok slideshows.
  4. **Approve/reject training loop.** He rated "a few hundred" of Forge's designs over
     2-3 days until he trusted Forge to publish on its own. He calls this the key step.
  5. Other parts: a daily and weekly "War Room" review of what's working, an Archives
     memory of every piece of feedback, and a Treasury that tracks costs.
- **His claimed results:** about $2K after the first few weeks (April), $16K across 3
  stores (June), $29K by late August, and later about 5 stores, including candles. These
  are his numbers and can't be verified.
- **Cost he quotes:** about $400/month in AI subscriptions, plus a $30 Etsy seller account
  and a $20/month image-model plan.

## One deliberate difference: designs are original, not copies

In his videos he says Nova finds best-sellers and the agents "copy those designs" and
"replicate them in a slightly different way". This package **does not do that**:
- Copying another seller's artwork, or making a near-copy, is copyright infringement and
  breaks Etsy's IP policy. Etsy removes listings when it gets complaints and suspends
  shops that keep getting them, which can freeze payouts.
- An autonomous agent can list dozens of products a day, so one bad habit multiplies
  fast.

So here Nova copies **demand** (niches, audiences, occasions, product types, keywords,
price points), and Forge invents the design, then runs a trademark and look-alike check
before anything gets listed. Everything else follows his setup.

## Files

```
ultron-openclaw/
  ULTRON_PROMPT.md          # Ultron's whole prompt in one file (SOUL + AGENTS), for pasting anywhere
  openclaw.json5.example    # agents, models, bindings to merge into ~/.openclaw/openclaw.json
  automations.sh            # morning War Room, evening check, weekly review
  workspace-ultron/         # SOUL.md, IDENTITY.md, USER.md (fill in!), AGENTS.md
  workspace-nova/           # SOUL.md, AGENTS.md
  workspace-forge/          # SOUL.md, AGENTS.md, skills/printify/SKILL.md
  workspace-pixel/          # SOUL.md, AGENTS.md
  factory/                  # shared ledger / feedback / style files, copied to ~/.openclaw/factory
```

## Setup

**Quick install** (on the machine running OpenClaw):

```bash
cd ~/ultron-download && git pull && bash ultron-openclaw/install.sh
```

It backs up your config, copies files without overwriting anything, asks for missing keys,
adds the four agents (no bindings, so your existing agents keep their channels), and
schedules the automations. The manual steps below do the same thing by hand.

1. **Accounts**
   - Etsy seller account; set up shop basics: payments, shipping profile, return policy.
   - Printify account. Connect the Etsy shop: Printify dashboard -> Manage stores -> Etsy.
     Create a Printify API token (Account -> Connections). In Etsy, list Printify as
     your production partner.
   - Anthropic API key (Opus 5.5 / Sonnet 5.5) and an image-model key (OpenAI for
     `gpt-image-2`, or Gemini for Nano Banana Pro).
2. **Copy the files**
   ```bash
   cp -r workspace-ultron workspace-nova workspace-forge workspace-pixel ~/.openclaw/
   mkdir -p ~/.openclaw/factory && cp factory/*.md ~/.openclaw/factory/
   ```
3. **Fill in `~/.openclaw/workspace-ultron/USER.md`** (niche, styles, budget, time zone).
   Ultron is only as good as this file.
4. **Config:** merge `openclaw.json5.example` into `~/.openclaw/openclaw.json`
   (or create each agent with `openclaw agents add <id> --workspace <dir> --model <id>`).
   Store `PRINTIFY_API_KEY` with OpenClaw's secrets, not in a file. Then:
   ```bash
   openclaw agents list --bindings
   openclaw skills list --agent forge     # should show "printify"
   ```
5. **Schedule:** edit the time zone and channel at the top of `automations.sh`, then
   `bash automations.sh`.
6. **First run:** message Ultron: *"Commander here. Run the first War Room: have Nova
   research my niche and give me 10 briefs, then have Forge make the first approval batch."*

## Running it (the way he did)

- **Week 1 = training.** Answer every approval batch with reasons ("reject 2, font
  unreadable"). Aim for about 200 verdicts. Ultron turns them into `STYLE.md`.
- **Phase 2** (Forge publishes on its own, max 5 products/day) unlocks only when you
  say yes, after 80%+ of the last 50 designs were approved.
- **You stay in charge of:** posting TikToks (Pixel drafts them), customer messages
  (Ultron drafts them), ad spend, and starting new stores or product types.
- **Costs:** Opus 5.5 for Ultron and Sonnet 5.5 for the crew keep API costs down.
  Switch the crew to Opus in the config if quality matters more than cost. Etsy also
  charges a fee per listing, and the 5/day cap keeps that in check.
