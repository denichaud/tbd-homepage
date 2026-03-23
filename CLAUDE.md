# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this project is

A static website for TBD (strategic consulting) served by nginx, packaged as a Docker image, and deployed to a private k3s cluster via ArgoCD. Content lives inside the container image — not in a ConfigMap.

## Build and deploy

```bash
# Build the Docker image
docker build -t registry.tbd:5000/tbd-homepage:latest .

# Push to the private registry
docker push registry.tbd:5000/tbd-homepage:latest

# Force ArgoCD to re-pull the image (imagePullPolicy: Always)
kubectl rollout restart deployment/website -n website

# Or trigger via ArgoCD sync
argocd app sync website
```

## Project structure

```
index.html        # Homepage (/)
qr.html           # Mobile contact/name-card page (/qr)
styles.css        # Shared CSS design system
nginx.conf        # Custom nginx config — handles /qr → qr.html routing
Dockerfile        # Builds nginx:alpine image with site content
.dockerignore
deployment.yaml   # Local k8s manifest reference (see note below)
ingress.yaml
service.yaml
```

## Two sets of k8s manifests — important distinction

- **`/Users/stacy/development/tbd-infra/k8s/website/`** — the **authoritative** manifests managed by ArgoCD. These use `namespace: website` and `app: website`. Changes here trigger real deployments.
- **`deployment.yaml` / `ingress.yaml` / `service.yaml` in this repo** — reference copies kept here for context. Do not apply these directly; update tbd-infra instead.

The infra manifests use `name: website` (not `tbd-homepage`) throughout. The Deployment in tbd-infra currently references `nginx:alpine` with a ConfigMap volume — that needs to be updated to `registry.tbd:5000/tbd-homepage:latest` as the migration from ConfigMap-based content is completed.

## nginx routing

The `/qr` URL maps to `qr.html`. This requires a custom `nginx.conf` — the default nginx config won't find `qr.html` from the path `/qr`. The `nginx.conf` in this repo is copied into the image and handles this:

```nginx
location = /qr {
    try_files /qr.html =404;
}
```

## Infrastructure context

- Private registry: `registry.tbd:5000` (resolves via internal DNS at `10.80.80.20`)
- k3s is configured to pull from `registry.tbd:5000` without TLS verification
- `imagePullPolicy: Always` ensures the latest tag is re-pulled on pod restart
- Ingress serves `tbd.to` and `www.tbd.to` with TLS via cert-manager (`cloudflare-issuer`)
- Namespace: `website`

## Design system

CSS custom properties in `styles.css` define the design tokens (warm off-white palette: `--bg: #F6F4F0`, `--accent: #7C5C3E`). Both pages import this shared stylesheet. The `/qr` page is self-contained enough that it can diverge from `styles.css` if needed for the card layout.

## Content source

Business positioning and messaging are based on `/Users/stacy/Library/CloudStorage/Dropbox/DROPBOX Documents/2026/tbd/docs/# Reworked Company Mission Statement, v2.md`.

WhatsApp contact: `+819054055632` → link format: `https://wa.me/819054055632`
