# Design Process Transcript

This document captures the complete design conversation that shaped the AI Gleanings repository architecture and principles.

## Initial Request

**User:** `/grill-with-docs` - This repo is for capturing and sharing the things I learn and the artifacts I create learning AI, including custom agents, skills, agent instructions, and settings, tools and dependencies (e.g., rtk), plugins, hooks, configuration, links, and resources. It should be a working demonstration and use its own principles--it should describe and embody its own principles, and it should have tests for any scripts and skills. It should have a good README. Help me think through how to set it up and design it

## Key Design Questions and Decisions

### 1. Repository Principles

**Question:** What exactly are the principles this repository should demonstrate?

**Decision:** Principles should center around **transparent learning** and **practical reusability**:
- Document the learning process, not just outcomes (rationale without narrative bloat)
- Make everything immediately runnable by others  
- Test all code to ensure reliability
- Use the repository's own tooling to manage itself
- Target practicing software engineers
- Embody all principles of software quality and craftsmanship

### 2. Audience and Use Case

**Question:** What does "immediately runnable" mean and how do users actually use this?

**Decision:** Treat this like a **packaged representation of best principles** rather than progressive learning tool:
- Not a tutorial, but a reference implementation
- More like sophisticated dotfiles than educational content
- Dependency management through Brewfiles
- Users will primarily **cherry-pick specific tools** and **learn patterns**
- Clone and copy approach rather than wholesale adoption

### 3. Artifact Types and Organization

**Question:** What constitutes an "artifact" worth preserving?

**Decision:** Focus on Claude Code Agent Instructions and custom skills, with agent-agnostic portability:
- Custom skills written from scratch
- Agent instructions (Claude Code specific but portable patterns)
- Settings/configuration files
- Tools and dependencies (RTK, etc.)
- Keep things simple until specific complexity requirements emerge

**Question:** How should artifacts be organized?

**Decision:** **Organize by deployment context** rather than artifact type:
```
setup/           # Brewfile, installation scripts  
config/          # Claude Code settings, global configs
skills/          # Custom skills
agents/          # Agent definitions and instructions
tools/           # Custom tooling 
examples/        # Working demonstrations
```

Later refined to:
```
.claude/         # Project's own config (demonstrates project best practices)
global-config/   # Templates for ~/.claude/ 
skills/          # Source of truth for custom skills
instructions/    # Agent instruction templates
.devcontainer/   # Exemplary devcontainer
```

### 4. Skills Directory Strategy

**Question:** Should the project's `.claude/skills/` contain all skills or just those it uses?

**Key Decision:** **Curated demonstration** - The project's `.claude/skills/` symlinks only to skills used for repository self-management:
- skill-validation (run evals, quality gates)
- documentation-generation (README, indexes)  
- quality-checks (config validation, script testing)

**Rationale:** Demonstrates intentional skill curation as a best practice rather than convenience dump.

### 5. Configuration Philosophy

**Question:** Should configuration be actual configs or exemplary templates?

**Decision:** **Exemplary templates** that demonstrate patterns without personal details. Show the 80% use case with production-ready patterns others can fork and adapt.

### 6. Agent Instructions

**Question:** What goes in instructions/ and how should they be organized?

**Decision:** **Agent-agnostic hybrid instructions** (principles + concrete examples):
- General agent instructions that aren't Claude Code specific
- Organized by use case (code-review/, project-analysis/, workflow-automation/)
- Hybrid approach: principles with concrete examples

### 7. Documentation Strategy

**Question:** How should documentation generation work?

**Decision:** **Smart updates** (Option B) - Parse existing content and update only specific parts. Preserves manual edits while keeping generated sections current.

**README Philosophy:** **Discovery-focused** - understanding the philosophy and browsing available artifacts. Five-minute success case is comprehending the approach and identifying relevant tools.

### 8. Testing Strategy

**Question:** What does "tested" mean for different artifact types?

**Decisions:**
- **Skills:** Eval suites with prompt arrays and expected outcomes
- **Scripts:** Functional tests ensuring they work as documented  
- **Configs:** Schema validation and linting
- **Instructions:** Token efficiency + design principles (progressive disclosure)

### 9. Setup and Dependencies

**Question:** How should setup work for selective adoption?

**Decision:** **Selective adoption with clear dependency trees** (Option B):
- Users primarily cherry-pick specific tools or learn patterns
- Each artifact documents its own dependencies for standalone use
- No all-or-nothing approach

### 10. Evolution Strategy

**Question:** How to handle conflicts between best practices or evolution?

**Decision:** **Current best thinking** - Repository represents current optimal approach:
- Always updated to latest best practices
- Things can be removed, not deprecated
- No historical preservation or deprecation folders
- Clean evolution without historical baggage

## Quality Gates Established

Archived artifacts must be:
- Well-designed and demonstrating best practices
- Actually useful and regularly used
- Properly tested (evals for skills, appropriate testing for other artifacts)
- Sufficiently documented for others to understand and use
- Solving real problems, not theoretical ones

## Implementation Decisions

### Directory Structure
- **Minimal structure based on actual needs** - No over-engineering
- Each directory has README explaining purpose and patterns
- Self-demonstrating through its own structure

### Skills Organization
- Skills live in `/skills/` as source of truth
- Project's `.claude/skills/` symlinks only to self-management skills
- Minimal structure per skill based on complexity

### Documentation
- CONTEXT.md captures domain language and principles
- ADRs document key architectural decisions  
- Smart documentation updates preserve manual edits
- Focus on rationale over narrative

## Key Architectural Decisions Documented

1. **ADR-0001:** Skills symlink strategy - project uses only self-management skills to demonstrate curation best practices

## Final Architecture

The repository became a **curated reference implementation** balancing:
- **Self-demonstration** (using its own tooling)
- **Selective adoption** (clear dependencies, no forced bundling)  
- **Pattern learning** (exemplary templates with rationale)
- **Quality gates** (proper testing for each artifact type)
- **Clean evolution** (current best thinking, no historical cruft)

## Implementation Order

1. Set up agent skills configuration (AGENTS.md, docs/agents/)
2. Add RTK permissions to Claude Code settings
3. Create domain context (CONTEXT.md) with principles and decisions
4. Document skills symlink strategy (first ADR)
5. Create complete directory structure with documentation
6. Add exemplary .gitignore and Brewfile
7. Create discovery-focused README demonstrating best practices

This design process demonstrates the grilling methodology: relentless questioning of each decision until reaching shared understanding, with documentation capturing both decisions and rationale.