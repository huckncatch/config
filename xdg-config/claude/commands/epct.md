# Explore-Plan-Code-Test Framework

Execute a structured development workflow for: $ARGUMENTS

## Phase 1: Explore

Before writing any code, analyze the existing codebase:

1. **Search for related patterns** - Find similar implementations in the codebase
2. **Identify dependencies** - What modules, services, or types will this interact with?
3. **Check for constraints** - Are there architectural rules or patterns to follow?
4. **Document findings** - List what you discovered before proceeding

**Deliverable:** Summary of exploration findings with file paths and relevant code snippets.

## Phase 2: Plan

Propose a detailed implementation approach:

1. **Break down the task** - List specific steps in order
2. **Identify files to create/modify** - With full paths
3. **Define data structures** - Types, protocols, or models needed
4. **List edge cases** - What could go wrong?
5. **Estimate complexity** - Simple/Medium/Complex

**Deliverable:** Step-by-step plan with:

- Files to create or modify
- Proposed architecture/patterns
- Potential risks or blockers
- Testing strategy

**PAUSE HERE** - Wait for user approval before proceeding to Phase 3.

## Phase 3: Code

Implement following project standards:

1. **Follow CLAUDE.md guidelines** - Use patterns defined in project/global CLAUDE.md
2. **Write clean, maintainable code** - Single responsibility, descriptive names
3. **Include error handling** - No silent failures, custom error types
4. **Add documentation** - Doc comments for public APIs
5. **Create incrementally** - One logical piece at a time

**Requirements:**

- Code must compile without warnings
- Follow Swift 6 concurrency patterns (if iOS project)
- Use @Observable for ViewModels (if SwiftUI)
- No force unwrapping

## Phase 4: Test

Verify the implementation:

1. **Write unit tests** - Cover business logic and edge cases
2. **Run existing tests** - Ensure nothing broke
3. **Verify edge cases** - Test the scenarios identified in Phase 2
4. **Update documentation** - CLAUDE.md, README, or inline docs as needed

**Deliverable:**

- All tests passing
- Coverage on new code >80%
- Documentation updated

## Output Format

For each phase, provide:

- Clear section header
- Findings or deliverables
- Any blockers or questions
- Next steps

If the task is too large for one session, create a FEATURE_*.md document to preserve progress for continuation.
