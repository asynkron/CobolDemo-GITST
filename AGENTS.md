# Agent Instructions

1. **Start with `context.md`:** Every directory now includes a `context.md` that summarizes its purpose, key assets, dependencies, and modernization tips. Read the most specific `context.md` files before editing code so you understand how pieces fit together.
2. **Keep context up to date:** Whenever you modify or add code in a directory, update that directory's `context.md` (and any relevant parent contexts) to reflect the change. Treat the context files as the living index for this codebase.
3. **Respect existing structures:** Source members follow IBM i naming conventions (COBOL in `QCBLSRC`, RPGLE in `QRPGLESRC`, DDS in `QDDSSRC`, etc.). Preserve these conventions unless explicitly modernizing them.
4. **Document modernization insights:** If you discover new migration paths or architectural insights, capture them in the appropriate `context.md` so future agents can build on your findings.
