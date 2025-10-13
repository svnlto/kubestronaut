# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Kubestronaut training repository for practicing all five Kubernetes certifications
(KCNA, KCSA, CKAD, CKA, CKS). The repository uses specialized tutor agents to generate exercises
and custom validation commands to check solutions.

## Development Environment

### Setup

```bash
# Enter Nix development environment (recommended)
nix develop

# Or install manually: kubectl, kind, helm, k9s, trivy, jq, yq, just
```

### Cluster Management

**Single-node cluster** (KCNA/KCSA/CKAD):

```bash
kind create cluster --config=configs/cluster/kind-single-node.yaml
kind delete cluster --name kubestronaut-single
```

**Multi-node cluster** (CKA/CKS):

```bash
kind create cluster --config=configs/cluster/kind-multi-node.yaml
kind delete cluster --name kubestronaut-multi
```

### Quick Commands

```bash
# Validate an exercise
just validate <exercise-name>

# List all justfile commands
just --list
```

## Architecture

### Exercise Structure

Exercises follow a strict format and are organized by certification:

```text
exercises/
├── ckad/    # Application developer exercises
├── cka/     # Administrator exercises
├── cks/     # Security specialist exercises
├── kcna/    # Cloud native fundamentals
└── kcsa/    # Security fundamentals
```

Each exercise directory contains:

- `README.md` - Overview, quick reference, exam tips
- `0X-exercise-name.md` - Individual exercises with task, hints, verification

### Exercise File Format

```markdown
# Exercise N: Title (★☆☆/★★☆/★★★)
Time: X-Y minutes

## Task
- Requirement 1
- Requirement 2

## Hint
[1-2 helpful hints]

## Verification
- Check step 1
- Check step 2
**Useful commands:** `kubectl ...`
```

### Custom Agents

Five specialized tutor agents create exercises (invoked automatically when user mentions topics):

- **ckad-tutor** - CKAD exercises (pods, deployments, services, jobs, etc.)
- **cka-tutor** - CKA exercises (cluster admin, troubleshooting)
- **cks-tutor** - CKS exercises (security, hardening)
- **kcna-tutor** - KCNA exercises (cloud native fundamentals)
- **kcsa-tutor** - KCSA exercises (security fundamentals)

Agents use Write/Edit/Read/Glob/Bash tools to create exercise files following the exact format.

### Output Styles (Practice Modes)

Two practice modes via `/output-style`:

1. **Training Mode** (default) - Provides hints, time estimates, fix commands
2. **Exam Mode** - Only reports pass/fail, no assistance (exam simulation)

### Custom Commands

- `/validate-exercise <name>` - Validates completed exercises by checking Kubernetes resources against requirements

## Working with Exercises

### Creating Exercises

Tutor agents are invoked automatically when users mention certification topics:

- "Create CKAD exercises for multi-container pods"
- "Generate CKA troubleshooting exercises"

Agents will:

1. Create exercise files in `exercises/{cert}/{topic}/0X-name.md`
2. Update or create `README.md` in the topic directory
3. Follow strict formatting (difficulty, time, task, hint, verification)
4. Use sequential numbering (01, 02, 03...)

### Validating Exercises

The `/validate-exercise` command:

1. Searches for exercise file by name pattern in `exercises/`
2. Reads exercise requirements from "## Task" section
3. Runs kubectl commands to verify resources exist and match specs
4. Reports status with specific pass/fail for each requirement
5. Provides fix commands (Training Mode) or only actual vs expected (Exam Mode)

### Solutions Directory

`solutions/` is gitignored. Users work on exercises and save their solutions here for reference.

## Important Rules

### Training Mode Behavior

When in Training Mode (default), responses must:

- Show kubectl commands immediately
- Prefer imperative commands over YAML
- Include time estimates (2-3 min, 5-7 min, 8-12 min)
- Provide verification steps
- Be concise (bullet points, short sentences)
- Never use TodoWrite tool for exam practice
- Suggest shortcuts (--dry-run=client -o yaml, -o wide, aliases)

### Exam Mode Behavior

When in Exam Mode:

- Report only pass/fail status
- Show actual vs expected values
- No hints, no fix commands, no explanations
- Simulate real exam conditions

### Exercise Creation Standards

When creating exercises:

- Always use Write tool to create files (don't just show examples)
- Check existing structure with Glob/Read first
- Number exercises sequentially (01, 02, 03...)
- Match difficulty to time (★☆☆: 3-5min, ★★☆: 5-8min, ★★★: 8-12min)
- Include realistic verification steps with specific kubectl commands
- Focus on exam patterns and time pressure

## Permissions

Pre-approved kubectl commands that don't require user confirmation:

- `kubectl config`
- `kubectl describe`
- `kubectl get`
- `kubectl logs`

Other kubectl commands (create, delete, apply, etc.) require user approval.
