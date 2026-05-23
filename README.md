# TBD Homepage

Static website for TBD (strategic consulting). Served by nginx, packaged as a Docker image, deployed to a private k3s cluster via ArgoCD.

## Status

**Live.** Content lives inside the container image — not in a ConfigMap.

## What's been built

- `index.html` — homepage (`/`) with 2026 design refresh: serif typography, bento grid layout
- `qr.html` — mobile contact / name-card page (`/qr`)
- `styles.css` — shared CSS design system (warm off-white palette, CSS custom properties)
- `logo.svg` / `logo-light.svg` — dual logos for dark/light mode
- `nginx.conf` — custom config handling `/qr` → `qr.html` routing
- `Dockerfile` — nginx:alpine image with all site content baked in
- `deployment.yaml` / `ingress.yaml` / `service.yaml` — reference k8s manifests (authoritative copies live in `tbd-infra`)

### Dark / light mode toggle

Pill-style slider toggle fixed to the top-right of the nav. Persists via `localStorage`, respects `prefers-color-scheme` on first visit. Dark mode swaps `logo.svg` → `logo-light.svg` automatically.

## Deployment

```bash
# Build
docker build -t registry.tbd:5000/tbd-homepage:latest .

# Push to private registry
docker push registry.tbd:5000/tbd-homepage:latest

# Restart pods (imagePullPolicy: Always re-pulls latest)
kubectl rollout restart deployment/website -n website
```

Ingress serves `tbd.to` and `www.tbd.to` with TLS via cert-manager (`cloudflare-issuer`).

## Infrastructure

| Thing | Value |
|---|---|
| Registry | `registry.tbd:5000` (internal DNS `10.80.80.20`) |
| Namespace | `website` |
| ArgoCD app | `website` |
| Authoritative k8s manifests | `/Users/stacy/development/tbd-infra/k8s/website/` |

> The infra manifests use `name: website` (not `tbd-homepage`). The `deployment.yaml` / `ingress.yaml` / `service.yaml` in this repo are reference copies — do not apply them directly.

## Next steps

### Migrate registry to GitHub Container Registry (GHCR)

Replace the private registry with GHCR so the image can be pulled without VPN / internal DNS dependency.

1. Add GitHub Actions workflow to build and push on merge to `main`:
   ```
   ghcr.io/denichaud/tbd-homepage:latest
   ```
2. Create a GHCR pull secret in the `website` namespace
3. Update `tbd-infra` deployment manifest to reference the GHCR image
4. Remove `registry.tbd:5000` references from k3s `registries.yaml` once migration is confirmed
