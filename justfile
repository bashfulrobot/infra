# Docs
# ---- https://github.com/casey/just
# ---- https://stackabuse.com/how-to-change-the-output-color-of-echo-in-linux/
# ---- https://cheatography.com/linux-china/cheat-sheets/justfile/
# load a .env file if in the directory
set dotenv-load
# Ignore recipe lines beginning with #.
set ignore-comments
# Search justfile in parent directory if the first recipe on the command line is not found.
set fallback
# Set the shell to bash
set shell := ["bash", "-cu"]

# "_" hides the recipie from listings
_default:
    @just --list --unsorted --list-prefix ····

# Force a flux reconciliation
flux-recocile:
    @flux reconcile -n flux-system kustomization flux-system
# Force a sysdig agent reconciliation
sysdig-reconcile:
    @flux reconcile helmrelease flux-sysdig-helm-release -n sysdig-agent
# Display the events for the flux-system
flux-events:
    @kubectl events -n flux-system --for kustomization/flux-system
# Create a sealed secret - IE: just create-sealed-secret sysdig-access-key sysdig-agent access-key 1234567890
create-sealed-secret NAME NAMESPACE SECRET SECRET-VALUE:
    kubectl create secret generic {{NAME}} --from-literal={{SECRET}}={{SECRET-VALUE}} -n {{NAMESPACE}} -o yaml --dry-run=client | kubeseal --controller-namespace=sealed-secrets -n {{NAMESPACE}} --scope namespace-wide -o yaml > {{NAME}}-sealed.yaml
# export the sealed secret public key
export-sealed-secret-pubkey:
    @kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets > pub-sealed-secrets.pem
# show Bootstrap command - run under bash
bootstrap-flux-cluster:
    @echo "Token expires in 2025"
    @echo "export GITHUB_TOKEN=<gh-token> && flux bootstrap github --token-auth --owner=bashfulrobot --repository=infra --branch=main --path=clusters/darkstar --personal"
