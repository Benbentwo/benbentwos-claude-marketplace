---
name: init-docs
description: Create FEATURES.md and CHANGELOG.md files with project-aware content by analyzing the existing codebase
allowed-tools:
  - Read
  - Write
  - Glob
  - Grep
  - Bash
---

# Initialize Project Documentation

Create FEATURES.md and CHANGELOG.md files populated with content discovered from analyzing the project.

## Process

1. **Check for existing documentation**
   - Look for `docs/FEATURES.md`, `FEATURES.md`, `docs/CHANGELOG.md`, `CHANGELOG.md`
   - If files exist, ask user whether to overwrite or merge

2. **Determine documentation location**
   - If `docs/` directory exists, create files there
   - Otherwise, create at project root
   - Inform user of chosen location

3. **Analyze the project**
   - Examine project structure to understand what it is (game, library, tool, etc.)
   - Look for existing README, package.json, or other metadata
   - Identify major features by exploring key directories
   - Check git history for recent significant changes

4. **Create FEATURES.md**
   - Start with project name and brief description
   - Organize discovered features into logical categories
   - Write from end-user perspective
   - Use the style most appropriate for the project type

   Example structure:
   ```markdown
   # [Project Name] Features

   ## [Category 1]
   - **Feature Name**: Description of what users can do

   ## [Category 2]
   - **Feature Name**: Description of what users can do
   ```

5. **Create CHANGELOG.md**
   - Use Keep a Changelog format
   - Add `[Unreleased]` section for future changes
   - If git history is available, populate recent versions
   - Include project version if detectable

   Example structure:
   ```markdown
   # Changelog

   All notable changes to this project will be documented in this file.

   The format is based on [Keep a Changelog](https://keepachangelog.com/).

   ## [Unreleased]

   ## [X.Y.Z] - YYYY-MM-DD
   ### Added
   - Initial documented features
   ```

6. **Report results**
   - Show files created and their locations
   - Summarize discovered features
   - Suggest reviewing and refining the generated content

## Notes

- Generated content is a starting point—encourage user to review and refine
- For large projects, focus on major user-facing features
- Match documentation style to project conventions (formal vs casual)
- If project type is unclear, ask user for guidance
