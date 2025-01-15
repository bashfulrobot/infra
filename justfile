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
flux-reconcile:
    @flux reconcile source git flux-system -n flux-system
flux-kustomization-reconcile:
    @flux suspend kustomization --all
    @flux resume kustomization --all
# Force full reconciliation of the flux and kustomizations
force-reconcile:
    @flux reconcile kustomization flux-system --with-source
    @flux reconcile source git flux-system -n flux-system
    @flux suspend kustomization --all
    @flux resume kustomization --all
    @just flux-status
# Display the status of Flux
flux-status:
    @echo "Reconciliation complete"
    @echo "Getting Flux and Kustomization status"
    @kubectl events -n flux-system --for kustomization/flux-system
    @echo "----------"
    @kubectl get kustomizations -A
    @echo "----------"
# Display Flux events
flux-events:
    @flux events --types Warning -A
# Create a sealed secret - IE: just create-sealed-secret sysdig-access-key sysdig-agent access-key 1234567890
create-sealed-secret NAME NAMESPACE SECRET SECRET-VALUE:
    kubectl create secret generic {{NAME}} --from-literal={{SECRET}}={{SECRET-VALUE}} -n {{NAMESPACE}} -o yaml --dry-run=client | kubeseal --controller-namespace=sealed-secrets -n {{NAMESPACE}} --scope namespace-wide -o yaml > {{NAME}}-sealed.yaml
# export the sealed secret public key
export-sealed-secret-pubkey:
    @kubeseal --fetch-cert --controller-name=sealed-secrets-controller --controller-namespace=sealed-secrets > pub-sealed-secrets.pem
# Expose k8s dashbaord temporarily
expose-k8s-dashboard:
    @kubectl port-forward deployments/kubernetes-dashboard-web 8000:8000 -n kubernetes-dashboard
# show Bootstrap command - run under bash
bootstrap-flux-cluster:
    @echo "Token expires in 2025"
    @echo "export GITHUB_TOKEN=<gh-token> && flux bootstrap github --token-auth --owner=bashfulrobot --repository=infra --branch=main --path=clusters/darkstar --personal"
