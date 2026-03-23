# TBD Homepage

MVP website project for TBD.

This project will replace the current ConfigMap-based holding page with a proper image-based static site deployment for k3s / ArgoCD.

## Current status

Scaffolding / generation phase.

Next step:
- generate the actual site, Dockerfile, and Kubernetes manifests with Claude Code

## Deployment target

- private registry: `registry.tbd:5000`
- target image: `registry.tbd:5000/tbd-homepage:latest`

## Notes

- website content should live inside the container image
- avoid ConfigMap-based static site content
- preserve the current namespace / service / ingress shape where possible
