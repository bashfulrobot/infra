# Cluster Bootstrap

- set kube context
- `flux bootstrap git --url=ssh://git@github.com/bashfulrobot/infra --branch=main --private-key-file=/home/dustin/.ssh/id_ed25519 --password
=xxxxxxxxxxx --path=./clusters/xxxxxxxx`

## Secrets

"Oh man, why are you putting info about secrets in a public repo?"

- Looking at the repo will tell anyone what secrets method is in play anyways
- I need to remember how to do this stuff
- The cluster is not exposed to the world

### How

- Using this guide to setp [SOPS](https://fluxcd.io/flux/guides/mozilla-sops/)
- Then referncing the values as per this [doc](https://fluxcd.io/flux/guides/helmreleases/#refer-to-values-in-secret-generated-with-kustomize-and-sops)

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
