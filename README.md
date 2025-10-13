# Kubestronaut Training

Training repository for achieving Kubestronaut status through hands-on practice exercises.

## What is Kubestronaut?

Kubestronaut is the highest level of Kubernetes certification achievement, awarded to individuals who
have earned all five Kubernetes certifications from the Cloud Native Computing Foundation (CNCF)
and The Linux Foundation.

## Certification Path

Complete all five certifications in this recommended order:

1. **KCNA** - Kubernetes and Cloud Native Associate (foundational)
2. **KCSA** - Kubernetes and Cloud Native Security Associate (foundational)
3. **CKAD** - Certified Kubernetes Application Developer (performance-based)
4. **CKA** - Certified Kubernetes Administrator (performance-based)
5. **CKS** - Certified Kubernetes Security Specialist (performance-based, requires CKA)

## Structure

- `exercises/` - Practice exercises organized by exam
  - `kcna/` - Cloud native fundamentals
  - `kcsa/` - Security fundamentals
  - `cka/` - Cluster administration
  - `ckad/` - Application development
  - `cks/` - Advanced security
- `solutions/` - Your working solutions for reference (gitignored)
- `configs/cluster/` - Kubernetes cluster configurations
  - `kind-single-node.yaml` - Fast single-node setup (KCNA/KCSA/CKAD)
  - `kind-multi-node.yaml` - Multi-node setup (CKA/CKS)
- `.claude/` - Claude Code configuration
  - `agents/` - Specialized tutors (kcna-tutor, kcsa-tutor, cka-tutor, ckad-tutor, cks-tutor)
  - `commands/` - Custom slash commands (validate-exercise)
  - `output-styles/` - Training and Exam modes

## Usage

Each exercise includes:

- Task requirements
- Verification steps
- Time estimates

Validate completed exercises using:

```bash
/validate-exercise <exercise-name>
```

## Claude Code Setup

### Output Styles

Switch between two practice modes:

- **Training Mode** (`/output-style training-mode`)
  - Provides hints and fix commands
  - Shows time estimates and debugging steps
  - Best for learning and initial practice

- **Exam Mode** (`/output-style exam-mode`)
  - No hints or help provided
  - Only reports pass/fail with actual vs expected values
  - Simulates real certification exam conditions

### Certification Tutors

Specialized agents for creating exercises. Invoke by mentioning the topic:

```text
"Create CKAD exercises for multi-container pods"
"Generate CKA troubleshooting exercises"
"Create a CKS network policy exercise"
```

Agents available:

- **KCNA Tutor** - Cloud native fundamentals exercises
- **KCSA Tutor** - Security fundamentals exercises
- **CKA Tutor** - Cluster administration exercises
- **CKAD Tutor** - Application development exercises
- **CKS Tutor** - Advanced security exercises

## Prerequisites

- Docker or Podman
- kubectl
- kind (included in Nix flake)

Using Nix:

```bash
nix develop
```

Or install manually: kubectl, kind, helm, k9s, trivy, etcdctl

## Environment

### Cluster Setup

Choose the appropriate cluster for your certification level:

**Single-node (KCNA/KCSA/CKAD)**:

```bash
kind create cluster --config=configs/cluster/kind-single-node.yaml
```

**Multi-node (CKA/CKS)**:

```bash
kind create cluster --config=configs/cluster/kind-multi-node.yaml
```

Delete cluster when done:

```bash
kind delete cluster --name kubestronaut-single
# or
kind delete cluster --name kubestronaut-multi
```

## Getting Started

1. **Setup environment**:

   ```bash
   nix develop  # or install tools manually
   kind create cluster --config=configs/cluster/kind-single-node.yaml
   ```

2. **Generate exercises**: Ask a tutor to create exercises for your target certification

3. **Practice with Training Mode**: Get hints and guidance while learning

4. **Test with Exam Mode**: Validate without assistance under exam conditions

## Workflow

1. Use a certification tutor agent to create exercises for a topic
2. Start in **Training Mode** for initial practice with hints
3. Complete exercises and validate with `/validate-exercise`
4. Switch to **Exam Mode** for realistic exam simulation
5. Retry exercises without assistance to build confidence

## Notes

- Performance-based exams (CKA, CKAD, CKS) require hands-on Kubernetes cluster access
- Focus on imperative commands and speed for exam efficiency
- Time pressure is critical - practice completing tasks quickly
- Exam environment allows access to kubernetes.io/docs only
- Reference solutions not provided - learn by validation feedback
