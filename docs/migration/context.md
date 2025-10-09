# Migration Playbooks Context

This directory holds hands-on modernization guides that map IBM i/COBOL functionality to contemporary platforms. Each playbook documents:

- The legacy entry point being migrated and how it behaves today.
- The target implementation (e.g., .NET, Java, serverless) with runnable code samples.
- Integration patterns that allow the remaining COBOL assets to collaborate with the new service.
- Risks, prerequisites, and testing steps discovered during the spike.

Add a subdirectory per migration slice so future teams can iterate independently without clobbering previous work.

## Reference Snapshots
- `dotnet/XacbltstConcatService/Program.cs.md` — Annotated minimal API host that returns the `FIL.LIB` concatenation via ASP.NET.
- `dotnet/XacbltstConcatService/XacbltstConcatService.csproj.md` — Explanation of the project scaffolding and .NET 8 defaults used by the host.
- `dotnet/XacbltstConcatService/appsettings.json.md` — Configuration reference covering API-key and logging defaults.
- `cobol/xacbltst/XACBLTST-CLIENT.CBL.md` — Inline-commented IBM i client wrapper that posts requests to the modern service and falls back safely.
