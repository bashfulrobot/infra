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
just export-sealed-secret-pubkey
just create-sealed-secret sysdig-access-key sysdig-agent access-key xxxxxxxxxxxx
mv pub-sealed-secrets.pem kubeseal/clustername
mv sysdig-access-key-sealed.yaml apps/clustername/sysdig-agent
```

- add/update the content from `sysdig-access-key-sealed.yaml` to `apps/clustername/sysdig-agent/sealed-secret.yaml`
- add the annotations to the `template` section (if not there)
- edit or create `apps/clustername/sysdig-agent/kustomization.yaml`:

```yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
metadata:
  name: sysdig-agent
  namespace: sysdig-agent
resources:
  - ../base/sysdig-agent
  - ./sysdig-access-key-sealed.yaml
patches:
  - path: sysdig-agent.yaml
    target:
      kind: HelmRelease
```

- Re-enable the sysdig agent

### How

- Using this guide to setp [sealed secrets](https://fluxcd.io/flux/guides/sealed-secrets/)

## Sysdig Agent

### Get Chart Version

- Look for the `sysdig-deploy` chart version in releases on the [GitHub repo](https://github.com/sysdiglabs/charts/releases).
