# TBD Homepage

Source for [tbd.to](https://tbd.to) — the website for TBD, a strategic consulting practice working on strategy, automation, and practical AI.

It's a static site: hand-written HTML and CSS, no build step, no framework, no JavaScript beyond a small theme toggle. nginx serves it from a container image.

## Pages

| Path | File | What it is |
|---|---|---|
| `/` | `index.html` | Homepage — serif typography, bento grid layout |
| `/qr` | `qr.html` | Mobile contact / name-card page, linked from a QR code |

## Repository layout

```
index.html        Homepage
qr.html           Contact / name-card page
styles.css        Shared design system (CSS custom properties)
logo.svg          Logo for light mode
logo-light.svg    Logo for dark mode
nginx.conf        nginx config — maps /qr to qr.html
Dockerfile        nginx:alpine image with the site baked in
deployment.yaml   Reference Kubernetes manifests (see Deployment)
ingress.yaml
service.yaml
.github/workflows/build.yml
```

## Design system

`styles.css` defines the design tokens as CSS custom properties — a warm off-white palette built on `--bg: #F6F4F0` and `--accent: #7C5C3E`. Both pages import the same stylesheet.

### Dark / light mode

A pill-style slider toggle sits at the top right of the nav. It respects `prefers-color-scheme` on first visit, then persists the choice in `localStorage`. Switching to dark mode swaps `logo.svg` for `logo-light.svg`.

## Running it locally

No toolchain required — open `index.html` in a browser to preview.

To exercise the real nginx routing (`/qr` in particular, which the file:// protocol can't reproduce):

```bash
docker build -t tbd-homepage .
docker run --rm -p 8080:80 tbd-homepage
```

Then visit <http://localhost:8080> and <http://localhost:8080/qr>.

## Build and publish

Pushing to `main` builds the image and publishes it to the GitHub Container Registry via `.github/workflows/build.yml`:

```
ghcr.io/denichaud/tbd-homepage:latest
```

## Deployment

The site runs on Kubernetes, deployed continuously from the published image, with TLS certificates issued by cert-manager.

The `deployment.yaml`, `ingress.yaml`, and `service.yaml` files in this repository are **reference copies for context only**. The manifests that actually run are maintained in a separate private repository, so editing these files here has no effect on the live site.

## A note on reuse

The code is public so the implementation can be read, borrowed from, and learned from. The TBD name, logo, and written content are not — please don't reuse the branding or copy.
