---
description: List all feature context documents
allowed-tools: Read, Glob
---

List all feature context documents and their current state.

1. **Check for `docs/context/INDEX.md`**:
   - If it exists, read it and display the contents
   - Verify it is accurate by scanning `docs/context/` for all `.md` files (excluding INDEX.md)

2. **If INDEX.md does not exist or is outdated**:
   - Scan `docs/context/` for all `.md` files (excluding INDEX.md)
   - For each file, extract YAML frontmatter fields: title, created, updated, related_prd
   - Build a table sorted by most recently updated first

3. **Display as a formatted table**:

   ```
   | Feature | Created | Updated | Related PRD |
   |---------|---------|---------|-------------|
   ```

4. **Show summary**: Total count of context documents and how many have related PRDs linked.

5. **If no context documents exist**: Inform the user and suggest using `/context <feature-name>` to create one.
