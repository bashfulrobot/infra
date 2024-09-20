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

- Using this guide to setp [sealed secrets](https://fluxcd.io/flux/guides/sealed-secrets/)

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
