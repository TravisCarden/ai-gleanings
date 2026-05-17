# Project Skills Directory

This directory contains symlinks to skills that this repository uses for self-management.

## Philosophy

Rather than linking to all available skills, this directory demonstrates **intentional skill curation** - only linking to skills that the project actually needs for its own maintenance.

## Current Skills

This repository uses these skills for self-management:

- `skill-validation` - Run evals and quality gates for archived skills
- `documentation-generation` - Generate README sections and skill indexes
- `quality-checks` - Validate configs and test setup scripts

## Adding Skills

Skills are added here only when the repository itself needs them for maintenance tasks. All skills source of truth lives in `../skills/`.

To add a skill for project use:
```bash
ln -s ../skills/skill-name .claude/skills/skill-name
```
