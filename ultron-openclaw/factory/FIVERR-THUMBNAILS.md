# FIVERR DEPARTMENT — YouTube thumbnails

ULTRON runs this department. CANVAS designs. NOVA researches. The **Commander** is the only
one who touches fiverr.com: he creates the gig, reads orders, messages buyers and clicks
Deliver. Fiverr has no official seller API, and it permanently bans accounts that use bots or
scripts to message buyers, so no agent ever logs into Fiverr, clicks around it, or messages a
buyer directly. Agents prepare everything; the Commander sends it.

Work folder: `~/.openclaw/factory/fiverr/`

```
fiverr/
  GIG.md              # the live gig text, packages, prices, requirements (Ultron owns)
  ORDERS.md           # one row per order (Ultron owns)
  research/           # Nova's market research
  portfolio/          # Canvas's sample thumbnails for the gig gallery
  orders/<FV0001>/    # brief.md, buyer files, concepts, final.png, delivery.md
```

## Part 1 — Launch (one time)

1. **Market research (Nova)** → `research/market.md`. Look at the top 20 Fiverr gigs for
   "youtube thumbnail" and 2-3 narrower searches (e.g. travel vlog, gaming, finance,
   podcast, faceless channels). Record: price of each package, delivery time, revisions,
   review counts, what their galleries look like, and gaps (niches with demand but weak
   galleries). Recommend ONE niche to lead with, plus the general gig.
2. **Gig draft (Ultron)** → `GIG.md`, for the Commander to paste into Fiverr:
   - Title (Fiverr format "I will …", main keyword early), category, 5 search tags.
   - 3 packages. Starting point for a new seller with zero reviews (adjust with Nova's data):
     Basic $15 — 1 thumbnail, 2 revisions, 24h · Standard $25 — 1 thumbnail + 2 extra
     concepts to choose from, unlimited revisions, 24h · Premium $60 — 3 thumbnails for
     3 videos, unlimited revisions, 48h. Raise prices after the first 10 five-star reviews.
   - Description, FAQ, and **buyer requirements** (the questions Fiverr asks at checkout):
     video title, channel link, the main text for the thumbnail (or "you choose"), a clear
     photo of their face if they want it in the thumbnail, 1-3 thumbnails they like, colors
     or style to avoid, and "Is it OK if AI tools are used in making your thumbnail?"
3. **Portfolio (Canvas)** → 12 sample thumbnails in `portfolio/`, covering the lead niche
   and 3-4 others. Use made-up channels and topics. No real people, celebrities, brands or
   logos. These go in the gig gallery, so they must be the best work on the station.
4. Send the Commander GIG.md + the portfolio as one message. He creates the gig.

## Part 2 — Every order

1. **Commander → Ultron:** he forwards the order: paste of the requirements, attached buyer
   photos, the order number, package and due time. If an order email or message arrives
   anywhere you can read, remind him to send it, but never act on Fiverr yourself.
2. **Ultron:** give it the next id (FV0001…), add a row to ORDERS.md, save files to
   `orders/<id>/`, write `brief.md`, and spawn Canvas with the brief. If the buyer said no
   AI, stop and tell the Commander: we can't take that order.
3. **Canvas:** delivers concepts to `orders/<id>/` (see Canvas's AGENTS.md). Ultron checks
   them against the brief and the quality bar below, then sends the Commander the images +
   `delivery.md` (a short, friendly delivery message he can paste).
4. **Commander** delivers on Fiverr. He tells Ultron "delivered FVxxxx" → status DELIVERED.
5. **Revisions:** the Commander pastes the buyer's feedback → Ultron sends it to Canvas →
   same loop. Track the revision count against the package.
6. **Completed:** when Fiverr marks it complete, record the price and the payout
   (price minus Fiverr's 20% fee) in ORDERS.md. Ask the Commander for the buyer's review text
   and add what we learned to `fiverr/LESSONS.md`.

## Quality bar (every thumbnail, checked before the Commander sees it)

- 1280x720 px, 16:9, JPG or PNG under 2 MB (YouTube's thumbnail limit).
- Readable at phone size: shrink it to 320x180 and check the text and face still read.
- 3-5 words of text max, spelled exactly as the buyer wrote it.
- One clear focal point: a face with a strong emotion or one bold object. High contrast.
- Matches the buyer's video and doesn't promise something the video doesn't deliver
  (YouTube removes misleading or sexual/violent thumbnails, and the buyer gets the strike).

## Deadlines (late orders hurt the gig's ranking)

In every War Room and evening check, read ORDERS.md. Any order due within 12 hours that
isn't ready → tell the Commander at once. Fiverr deadlines beat every Etsy task.

## Rules

- Only use faces the buyer supplied (their own) — never a celebrity, another YouTuber, or a
  real person's likeness the buyer didn't provide. No brand logos unless it's the buyer's.
- Every order gets new, custom work. Never reuse a previous buyer's thumbnail or deliver the
  same image twice (Fiverr's AI rules).
- Buyer files and channel info stay in `orders/<id>/` and are never used for anything else.
- Agents never write to buyers or log into Fiverr. Drafts only.
