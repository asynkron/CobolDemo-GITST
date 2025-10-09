# appsettings.json — Configuration Defaults

## Overview
The configuration seeds sensible defaults for local development: it defines the shared API key used by COBOL callers and tunes
logging verbosity so ASP.NET Core diagnostics match IBM i operational expectations. Deployments can override these values via
environment variables or user secrets without editing the file.

## Dependencies
### Incoming
- Loaded automatically by `WebApplication.CreateBuilder` in [`Program.cs`](Program.cs.md) to hydrate the configuration system.
- Referenced by developers following the quick-start steps in [`README.md`](README.md) when adjusting secrets or log levels.

### Outgoing
- Supplies the `Xacbltst:ApiKey` value consumed by the API-key middleware in `Program.cs`.
- Provides logging level defaults that flow into `Microsoft.Extensions.Logging` via the standard configuration providers.

## Structure
### API key section
```json
"Xacbltst": {
  "ApiKey": "change-me"
}
```
The nested section mirrors how `Program.cs` looks up `Xacbltst:ApiKey`. The placeholder encourages teams to replace it with a real
secret through environment configuration.

### Logging defaults
```json
"Logging": {
  "LogLevel": {
    "Default": "Information",
    "Microsoft.AspNetCore": "Warning"
  }
}
```
Retaining the default informational logging keeps parity with IBM i job logs, while elevating ASP.NET Core infrastructure logs to
`Warning` prevents noise during migrations.

## Full Source
```json
{
  "Xacbltst": {
    "ApiKey": "change-me"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  }
}
```
