# XacbltstConcatService (ASP.NET Core sample)

This minimal API exposes the concatenation logic formerly handled by the `XACBLTST` COBOL program. It supports both JSON and CSV payloads and implements simple API-key authentication.

## Running locally

```bash
cd docs/migration/dotnet/XacbltstConcatService
dotnet restore
dotnet run
```

The service listens on `https://localhost:7123` by default. Update `appsettings.json` or environment variables to change the URL and API key.

## API surface

- `POST /api/v1/concat`
  - Headers: `X-API-Key: <token>` (optional but recommended).
  - `Content-Type: application/json` with body `{ "fileName": "ORDERS    ", "library": "PRODLIB   " }`.
  - Response: `200 OK` and `{ "fullName": "ORDERS.PRODLIB" }`.
- `POST /api/v1/concat?format=csv`
  - Accepts `text/csv` payload (`ORDERS    ,PRODLIB   `) and responds with the same JSON structure.

See `Program.cs` for the implementation details.
