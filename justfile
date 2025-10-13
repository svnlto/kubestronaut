# Kubestronaut training helper commands

# List available commands
default:
    @just --list

# Validate an exercise (e.g., just validate basic-cronjob)
validate exercise:
    claude -p "/validate-exercise {{exercise}}"

# Create single-node kind cluster (KCNA/KCSA/CKAD)
cluster-single:
    kind create cluster --config=configs/cluster/kind-single-node.yaml

# Create multi-node kind cluster (CKA/CKS)
cluster-multi:
    kind create cluster --config=configs/cluster/kind-multi-node.yaml

# Delete single-node cluster
delete-single:
    kind delete cluster --name kubestronaut-single

# Delete multi-node cluster
delete-multi:
    kind delete cluster --name kubestronaut-multi

# Show current cluster info
cluster-info:
    @echo "Current context:"
    @kubectl config current-context
    @echo "\nNodes:"
    @kubectl get nodes
    @echo "\nNamespaces:"
    @kubectl get namespaces

# Switch to training mode
training-mode:
    claude -p "/output-style training-mode"

# Switch to exam mode (strict, no hints)
exam-mode:
    claude -p "/output-style exam-mode"

# Generate exercises for a topic (e.g., just generate "CKAD pods exercises")
generate topic:
    claude -p "{{topic}}"

# Run markdownlint
lint:
    npx markdownlint-cli2 'README.md' 'exercises/**/*.md' '.claude/**/*.md' --fix

# Clean up all kind clusters
clean-clusters:
    -kind delete cluster --name kubestronaut-single
    -kind delete cluster --name kubestronaut-multi

# Show git status
status:
    git status --short

# Quick commit and push
commit message:
    git add -A
    git commit -m "{{message}}"
    git push origin main
