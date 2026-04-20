# AWDataStructures — AI Agent Instructions

## Context file
`.github/CONTEXT.md` is the authoritative project-state document for
AI-assisted development. **Always read it before making any changes.**

## After every session that makes code changes

Before ending the conversation, the AI must:

1. Update `.github/CONTEXT.md`:
   - Latest commit hash + message
   - Updated test counts per suite
   - Any new/changed types, APIs, or invariants
   - Updated commit history block

2. Update `.github/instructions/awdatastructures.instructions.md` if
   architecture, conventions, or key file descriptions changed.

3. Commit both files together — never separately:
   ```bash
   git add .github/CONTEXT.md .github/instructions/awdatastructures.instructions.md
   git commit -m "docs(context): update session state"
   git push origin master
   ```

## Build / test quick reference
```bash
cd ~/Desktop/asafw/AWDataStructures
swift build
swift test
```

All 37 tests must pass after any change. Run `swift test` to verify.
