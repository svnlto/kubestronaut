# Solutions

Store your solution implementations here for reference during training.

This directory is tracked but all YAML/YML files are gitignored, so your solutions stay local.

## Structure

Mirror the exercises structure:

```text
solutions/
├── ckad/
│   ├── cronjobs/
│   │   ├── 01-basic-cronjob.yaml
│   │   └── ...
│   ├── pods/
│   └── ...
├── cka/
├── cks/
├── kcna/
└── kcsa/
```

## Usage

After completing an exercise and validating it successfully, save your working solution here:

```bash
# Copy your working solution
cp my-cronjob.yaml solutions/ckad/cronjobs/01-basic-cronjob.yaml
```

This creates a personal reference library of working implementations for future review.
