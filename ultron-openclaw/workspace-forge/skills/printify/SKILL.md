---
name: printify
description: Create, mock up and publish print-on-demand products on Printify and its connected Etsy shop via the Printify REST API.
---

# Printify

Use the `exec` tool with `curl`. The API key is in the environment as `PRINTIFY_API_KEY`
(never print it, never write it to a file). Start every shell command with this helper:

```bash
BASE=https://api.printify.com/v1
pf() { curl -sS -H "Authorization: Bearer $PRINTIFY_API_KEY" -H "User-Agent: station-forge" \
  -H "Content-Type: application/json" "$@"; }
```

The Commander connects the Etsy shop to Printify once, in the Printify dashboard
(Manage stores -> Etsy). After that, Printify publishes to Etsy for you, so you do not
need an Etsy API key.

## Find ids (do once, save to ~/.openclaw/factory/printify-ids.md)

```bash
pf "$BASE/shops.json"                                     # -> shop_id of the Etsy store
pf "$BASE/catalog/blueprints.json"                        # -> blueprint_id (e.g. a unisex tee)
pf "$BASE/catalog/blueprints/$BP/print_providers.json"    # -> print_provider_id
pf "$BASE/catalog/blueprints/$BP/print_providers/$PP/variants.json"   # -> variant ids (size/color)
```

Pick providers with good ratings and shipping to where the shop sells. Save the
blueprint/provider/variant ids per product type so you don't look them up every time.

## Upload a design

```bash
pf -X POST "$BASE/uploads/images.json" \
  -d "{\"file_name\":\"P0001.png\",\"contents\":\"$(base64 -w0 design.png)\"}"
# or -d '{"file_name":"P0001.png","url":"https://..."}' for a public URL
# -> returns an image "id"
```

## Create the product as a draft

```bash
pf -X POST "$BASE/shops/$SHOP/products.json" -d @product.json
```

`product.json`:

```json
{
  "title": "<from listing.md>",
  "description": "<from listing.md>",
  "tags": ["tag1", "tag2"],
  "blueprint_id": 0,
  "print_provider_id": 0,
  "variants": [ { "id": 0, "price": 2799, "is_enabled": true } ],
  "print_areas": [ {
    "variant_ids": [0],
    "placeholders": [ { "position": "front",
      "images": [ { "id": "<uploaded image id>", "x": 0.5, "y": 0.5, "scale": 1, "angle": 0 } ] } ]
  } ]
}
```

Prices are in cents. The response has the product `id` and `images` (mockup URLs).

Check margin before saving: price minus Printify's production + shipping cost must leave
at least 25% after Etsy fees. If not, raise the price or tell Ultron.

## Publish to Etsy (only when Ultron says APPROVED)

```bash
pf -X POST "$BASE/shops/$SHOP/products/$PRODUCT/publish.json" -d '{
  "title": true, "description": true, "images": true, "variants": true, "tags": true,
  "keyFeatures": true, "shipping_template": true }'
```

Then `pf "$BASE/shops/$SHOP/products/$PRODUCT.json"` until `external.handle` shows the
Etsy listing URL. If publishing fails, report the exact error to Ultron.

## Orders (for Ultron's daily numbers)

```bash
pf "$BASE/shops/$SHOP/orders.json?page=1"
```

If an endpoint returns an error you don't understand, read the current Printify API docs
(developers.printify.com) before retrying. Never blindly retry a create or publish call:
first check whether the earlier call already worked.
