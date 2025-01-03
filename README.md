# Cluster Bootstrap

## How to create the PAT

- [Flux Docs on Bootstrapping](https://fluxcd.io/flux/installation/bootstrap/github/#github-organization)
- [Clarification Issue](https://github.com/fluxcd/flux2/issues/4412)

## Install

- set kube context
- disable sysdig agent (or apps that need sealed secrets)
- `export GITHUB_TOKEN=<gh-token>`
- `flux bootstrap github --token-auth --owner=bashfulrobot --repository=infra --branch=main --path=clusters/darkstar --personal`
- check for sealed secrets errors:
    - `kubectl get namespace sealed-secrets`
    - `kubectl get helmrepository sealed-secrets -n sealed-secrets`
    - `kubectl get helmrelease sealed-secrets -n sealed-secrets`
    - `kubectl get deployment sealed-secrets-controller -n sealed-secrets`
    - `kubectl get crd sealedsecrets.bitnami.com`
    - `kubectl logs -l app.kubernetes.io/name=sealed-secrets-controller -n sealed-secrets` (Confirm)
    - `kubectl get events -n sealed-secrets --sort-by='.lastTimestamp'`
- check for overall errors:
    - `flux logs`
    - `flux events`
    - `kubectl get kustomizations -A`
    - `kubectl get helmreleases -A`
    - `kubectl get gitrepositories -A`
    - `kubectl events -n flux-system --for kustomization/flux-system`

## Upgrade Flux

- essentially the same commands as installation
- Upgrade [doc](https://fluxcd.io/flux/installation/upgrade/)

## Secrets

"Oh man, why are you putting info about secrets in a public repo?"

- Looking at the repo will tell anyone what secrets method is in play anyways
- I need to remember how to do this stuff
- The cluster is not exposed to the world

```shell
cd kubeseal/clustername
kubeseal --fetch-cert \
--controller-name=sealed-secrets-controller \
--controller-namespace=sealed-secrets \
> pub-sealed-secrets.pem
```

```shell
kubectl -n default create secret generic sysdig-access-key \
--from-literal=sysdig-access-key=[AGENT-KEY] \
--dry-run=client \
-o yaml > sysdig-access-key.yaml
kubeseal --format=yaml --cert=pub-sealed-secrets.pem \
< sysdig-access-key.yaml > sysdig-access-key-sealed.yaml
```

- add/update the content from `sysdig-access-key-sealed.yaml` to `apps/base/sysdig-agent/sysdig-agent.yaml`
- add the annotations to the `template` section

```yaml
template:
    metadata:
      annotations:
        sealedsecrets.bitnami.com/namespace-wide: "true"
      creationTimestamp: null
      name: sysdig-access-key
      namespace: sysdig-agent
```

- delete `kubeseal/darkstar/sysdig-access-key-sealed.yaml` and `kubeseal/darkstar/sysdig-access-key.yaml`
    - DO NOT CHECK INTO GIT
- Re-enable the sysdig agent

### How

- Using this guide to setp [sealed secrets](https://fluxcd.io/flux/guides/sealed-secrets/)

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
