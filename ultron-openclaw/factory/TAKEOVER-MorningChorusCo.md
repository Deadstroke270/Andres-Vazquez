# OPERATION: MorningChorusCo takeover

ULTRON now runs the MorningChorusCo Etsy shop. GOKU no longer publishes to it.
Goal: more visits, a higher conversion rate and more orders, week over week, without
risking the shop. Work folder: `~/.openclaw/factory/morningchorusco/`.

Timing: it is peak holiday season. Etsy's US holiday shipping cutoffs are mid-December, and
new or edited listings need about 1-2 weeks to settle in search. Speed matters, but no change
goes live without the Commander's yes until Phase 2 of AGENTS.md section 4 is unlocked.

## Phase 0 — Handover (day 1)

1. Find Goku's workspace (`openclaw agents list` shows its path) and read everything about
   MorningChorusCo: memory files, notes, product lists, what was tried, what sold, open items
   (the puzzle listing waiting for approval, the Pinterest pin pack, the Etsy Ads unlock
   around Nov 21, the TikTok username change around Nov 18).
2. With the `printify` skill (via Forge): find MorningChorusCo's `shop_id`, save it to
   `factory/printify-ids.md`, and pull every product (published and draft) and all orders.
3. Ask the Commander for the Etsy exports Printify can't give you. They're in Etsy Shop
   Manager → Settings → Options → Download Data (Orders CSV + Listings CSV), plus a screenshot
   of Stats for the last 30 days (visits, views, conversion rate, traffic sources, top search
   terms). The Commander attaches them in your chat; save them to `morningchorusco/etsy-export/`.
4. Write `morningchorusco/HANDOVER.md`: what the shop sells, listing count, sales to date,
   what worked, what didn't, open items.

## Phase 1 — Audit (days 1-2). Change nothing yet.

Write `morningchorusco/AUDIT.md` with real numbers:

- **Funnel:** visits → listing views → favorites → orders, and the conversion rate.
  - Few visits = a search/traffic problem (titles, tags, categories, listing count, offsite traffic).
  - Visits but few orders = a listing problem (first photo, price, shipping, reviews, description).
- **Per listing:** age, views, favorites, sales, price, Printify cost + shipping, margin.
- **Search check per listing:** title starts with the phrase a buyer types; all 13 tags used,
  no repeats of the title words wasted; attributes, category, colors and occasion filled in.
- **Photos:** a clear thumbnail at small size; 5-10 photos; a lifestyle mockup; size chart and
  color chart for apparel.
- **Shop trust:** banner, logo, About section, policies, FAQ, announcement, review count,
  processing time, free US shipping (or price that absorbs shipping).
- **Competitors (via Nova):** the top 10 listings for the shop's main search terms. Compare
  price, photo style, title patterns and review counts. Study, never copy (AGENTS.md section 5).

Send the Commander a one-page summary: the 5 fixes most likely to raise sales, ranked, each
with the number that justifies it. Wait for a yes.

## Phase 2 — Fix what exists (after the Commander's yes)

- **Never delete a listing that has sales, reviews or favorites.** Improve it: its history
  helps it rank. Deactivate (not delete) listings with zero sales and very few views after
  60+ days, only with the Commander's yes.
- Rewrite titles, tags and descriptions; make better first photos; fix prices and shipping;
  finish the shop page.
- Printify-made listings: update the product in Printify and re-publish (the `printify`
  skill), which syncs the change to Etsy. Listings not made through Printify: write the new
  copy in `morningchorusco/edits/<listing>.md` for the Commander to paste.
- Max 10 edited listings per day. Log every change with before/after in LEDGER.md so the
  effect can be measured.

## Phase 3 — Grow (from week 1)

1. **Holiday sprint first:** gift-focused designs in the shop's niche (Christmas, Secret
   Santa, stocking stuffers, gifts for specific people), through the normal pipeline.
   Up to 5 new listings a day.
2. **Traffic:** Pixel makes TikTok slideshow drafts for the best listings; continue Goku's
   Pinterest pin work if it was producing visits.
3. **Etsy Ads:** when they unlock, propose a small daily test budget on the 3 best-converting
   listings. Spend nothing without the Commander's yes.

## Measuring

The weekly review adds a MorningChorusCo section: visits, conversion rate, orders, revenue,
best and worst 5 listings, and what changed that week. Report the real trend. Never promise
or claim results the numbers don't show.

## Rules

Everything in AGENTS.md applies, especially section 5. If any Goku job still touches
MorningChorusCo, tell the Commander right away.
