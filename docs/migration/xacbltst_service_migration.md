# XACBLTST Concatenation Service Migration Guide

This playbook walks through extracting the simple `XACBLTST` COBOL subroutine into an ASP.NET Core minimal API while keeping the remainder of the IBM i application intact. The goal is to establish an end-to-end integration pattern that future, more complex programs can reuse.

---

## 1. Why XACBLTST?

`XACBLTST` concatenates a 10-byte file name and 10-byte library name into a 21-byte `FIL.LIB` string. It has no database dependencies, uses positional parameters, and is already invoked as a subroutine. That makes it a low-risk candidate for a first externalization pilot.

Key benefits of starting here:

- **Isolated logic:** No DDS, display files, or copybook side effects.
- **Deterministic behavior:** Easy to regression test through inputs/outputs.
- **Gateway pattern:** Demonstrates how to expose reusable utility functions as HTTP APIs before attempting transaction-heavy modules.

---

## 2. Target Architecture

```mermaid
flowchart LR
    COBOL[COBOL caller<br/> (e.g., ZBCONDET)] -->|HTTP POST JSON/CSV| API[ASP.NET Core Minimal API]
    API -->|Business logic| Service[Concat Service]
    Service -->|Response payload| COBOL
```

- **Transport:** HTTPS using IBM i's Db2 for i built-in HTTP functions (`SYSTOOLS.HTTPPOSTCLOB`).
- **Payload format:** JSON by default for schema clarity; CSV supported for compatibility with existing flat-file tooling.
- **Hosting:** ASP.NET Core 8.0 minimal API deployed on Windows or Linux with TLS.
- **Auth (optional):** API key header checked by the middleware stub in the sample project.

---

## 3. Step-by-Step Extraction Plan

1. **Inventory current usage** – Locate programs that `CALL 'XACBLTST'` and confirm parameters are always 10/10/21 characters.
2. **Design request/response contracts** – Agree on JSON schema (see [Payloads](#5-data-formats)) and capture in OpenAPI.
3. **Build ASP.NET Core service** – Use the provided sample in [`docs/migration/dotnet/XacbltstConcatService`](dotnet/XacbltstConcatService) as the seed.
4. **Provision infrastructure** – Stand up an IIS/Kestrel instance or Azure App Service; configure TLS and firewall rules to allow outbound IBM i calls.
5. **Secure the endpoint** – Configure API key or mutual TLS. Update COBOL caller to send required headers.
6. **Update COBOL code** – Replace direct `CALL 'XACBLTST'` with wrapper routine shown in [`docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL`](cobol/xacbltst/XACBLTST-CLIENT.CBL).
7. **Regression test** – Execute unit tests in .NET, then run IBM i integration job to validate identical results.
8. **Cutover** – Switch production jobs to use the external call, leaving the old program available for rollback.

---

## 4. Payload Negotiation and Versioning

| Concern | Recommendation |
| --- | --- |
| Schema evolution | Version the URL (`/api/v1/concat`) and keep response shape backward compatible. |
| Character encoding | Use UTF-8 everywhere; convert EBCDIC strings via `ICONV`/`QDCXLATE` before HTTP call. |
| Error reporting | Map HTTP status codes to COBOL return codes. The sample COBOL wrapper captures JSON error payloads to `WS-ERROR-MSG`. |

---

## 5. Data Formats

### JSON (preferred)
- Self-describing field names.
- Allows future expansion (e.g., trimming options, separators).
- Works natively with ASP.NET model binding.
- Sample request:
  ```json
  {
    "fileName": "ORDERS    ",
    "library": "PRODLIB   "
  }
  ```
- Sample response:
  ```json
  {
    "fullName": "ORDERS.PRODLIB"
  }
  ```

### CSV (fallback)
- Use when intermediary tooling or exit programs demand flat text.
- Sample payload: `ORDERS    ,PRODLIB   ` (10 + comma + 10 chars).
- In the API project, see `CsvConcatRequestParser` for how to parse it.

### Binary/packed
- Not recommended for HTTP; rely on JSON/CSV and let COBOL handle conversions.

---

## 6. Files to Touch in the Legacy System

| File | Change |
| --- | --- |
| `QCBLSRC/XACBLTST.CBL` | Keep untouched initially for rollback; optionally wrap logic to call external API when environment flag is set. |
| `QCBLSRC/` callers (e.g., `ZBCONDET.CBL`) | Replace `CALL 'XACBLTST'` with `CALL 'XACBLTSTWS'` (new wrapper). |
| `docs/context.md` | Document the new migration assets (done in this change). |
| `docs/migration/**` | New guidance, sample COBOL wrapper, and ASP.NET project scaffolding. |

All other programs remain unchanged for the first iteration.

---

## 7. Risks & Mitigations

- **Network latency:** Introduce retry/backoff in the COBOL wrapper; keep old program as fallback path.
- **Character set mismatches:** Always translate between EBCDIC and UTF-8 using `QDCXLATE` or `ICONV`. Documented in the wrapper example.
- **Operational complexity:** Ensure monitoring and logging for the new API. Sample uses Serilog console logging.
- **Security posture:** Outbound HTTPS requires certificates in the IBM i Digital Certificate Manager. Coordinate with security team early.

---

## 8. Next Steps After Pilot

- Automate OpenAPI contract testing using Postman/Newman.
- Containerize the ASP.NET service for consistent deployment.
- Extend the pattern to stateless copybook logic (e.g., currency formatting) before tackling database-heavy programs.

