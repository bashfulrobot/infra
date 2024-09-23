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
recocile-flux:
    @flux reconcile -n flux-system kustomization flux-system
# Display the events for the flux-system
flux-events:
    @kubectl events -n flux-system --for kustomization/flux-system
# Create a sealed secret - Args: NAME NAMESPACE SECRET SECRET-VALUE
create-sealed-secret NAME NAMESPACE SECRET SECRET-VALUE:
    kubectl create secret generic {{NAME}} --from-literal={{SECRET}}={{SECRET-VALUE}} -n {{NAMESPACE}} -o yaml --dry-run=client | kubeseal --controller-namespace=flux-system -n {{NAMESPACE}} --scope namespace-wide -o yaml > {{NAME}}-sealed.yaml
# Bootstrap a flux cluster - Args: CLUSTER_NAME SSH_KEY_PW
bootstrap-flux-cluster CLUSTER_NAME SSH_KEY_PW:
    @flux bootstrap git --url=ssh://git@github.com/bashfulrobot/infra --branch=main --private-key-file=/home/dustin/.ssh/id_ed25519 --password={{SSH_KEY_PW}} --path=./clusters/{{CLUSTER_NAME}}