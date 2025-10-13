# Kubestronaut training helper commands

# List available commands
default:
    @just --list

# Validate an exercise (e.g., just validate basic-cronjob)
validate exercise:
    @echo "Validating exercise: {{exercise}}"
    @claude -p "/validate-exercise {{exercise}}"
