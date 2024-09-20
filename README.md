# Cluster Bootstrap

- set kube context
- `flux bootstrap git --url=ssh://git@github.com/bashfulrobot/infra --branch=main --private-key-file=/home/dustin/.ssh/id_ed25519 --password
=xxxxxxxxxxx --path=./clusters/xxxxxxxx`

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
