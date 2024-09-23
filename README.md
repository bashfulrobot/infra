# Cluster Bootstrap

## How to create the PAT

- [Flux Docs on Bootstrapping](https://fluxcd.io/flux/installation/bootstrap/github/#github-organization)
- [Clarification Issue](https://github.com/fluxcd/flux2/issues/4412)

- set kube context
- `export GITHUB_TOKEN=<gh-token>`
- `flux bootstrap github --token-auth --owner=bashfulrobot --repository=infra --branch=main --path=clusters/darkstar --personal`

## Secrets

"Oh man, why are you putting info about secrets in a public repo?"

- Looking at the repo will tell anyone what secrets method is in play anyways
- I need to remember how to do this stuff
- The cluster is not exposed to the world

### How

- Using this guide to setp [sealed secrets](https://fluxcd.io/flux/guides/sealed-secrets/)

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
