# ASIMPLTEST Context (Ad Hoc Test Source)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

`ASIMPLTEST` contains experimental source members used for testing and tutorials. `TUTR001.RPG` mixes RPG, CL, and DDS snippets in a single member, illustrating compile-order scenarios and code samples.

## Insights
* Demonstrates how a single source member might contain multiple record types when experimenting on IBM i.
* Useful for verifying overrides and CL interactions without touching production members.

## Positive Findings
* Provides a sandbox for learning without polluting production libraries.

## Negative Findings / Risks
* Mixed-language member is non-standard; compiling pieces requires manual extraction.
* No automated tests—this is purely illustrative.

## Migration Suggestions
* Break examples into dedicated members per language to support automated builds and linting.
* Consider translating these tutorials into documentation or unit tests to preserve knowledge during modernization.
