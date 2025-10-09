# Program.cs — Minimal API Host

## Overview
This entry point boots the ASP.NET Core minimal API that replaces the `XACBLTST` COBOL utility with an HTTP endpoint. It trims the
file and library names provided by legacy callers, enforces an optional API key, and returns the concatenated `FIL.LIB` value in
JSON so downstream jobs can consume the modernized result without rewriting their orchestration code.

## Dependencies
### Incoming
- HTTP clients modernizing the COBOL job flow, such as the sample wrapper in
  [`docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL.md`](../../cobol/xacbltst/XACBLTST-CLIENT.CBL.md).
- Automation or schedulers that execute `dotnet run` against the project defined in
  [`XacbltstConcatService.csproj`](XacbltstConcatService.csproj.md).

### Outgoing
- `Microsoft.AspNetCore.*` hosting infrastructure (`WebApplication`, `RouteOptions`, `StatusCodes`) to configure routing and
  respond to HTTP requests.
- `System.Net.Mime.MediaTypeNames` to describe the JSON content returned to callers.
- Configuration binding supplied by `Microsoft.Extensions.Configuration` for retrieving the `Xacbltst:ApiKey` secret.
- The local helper type `CsvConcatRequestParser` inside the same file for parsing CSV payloads from clients that cannot emit JSON.

## Structure and Key Blocks

### Host bootstrapping
```csharp
var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<RouteOptions>(options =>
{
    options.LowercaseUrls = true;
});

builder.Services.AddLogging();
var app = builder.Build();
var requiredApiKey = app.Configuration["Xacbltst:ApiKey"];
```
The builder enables lowercase routing so IBM i callers see consistent URLs, wires basic logging to mirror job logs, and grabs the
optional API key from configuration once so every request can reuse it.

### API key enforcement middleware
```csharp
app.Use(async (context, next) =>
{
    if (string.IsNullOrWhiteSpace(requiredApiKey))
    {
        await next();
        return;
    }

    if (!context.Request.Headers.TryGetValue("X-API-Key", out var provided) ||
        !string.Equals(provided, requiredApiKey, StringComparison.Ordinal))
    {
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        await context.Response.WriteAsJsonAsync(new { error = "API key is missing or invalid." });
        return;
    }

    await next();
});
```
The inline middleware short-circuits unauthenticated calls unless the shared secret matches, preserving the guarded behaviour of
the original COBOL batch job while still allowing the key to be disabled via configuration.

### Concatenation endpoint
```csharp
app.MapPost("/api/v1/concat", async (HttpRequest request) =>
{
    var format = request.Query["format"].ToString();

    ConcatRequest payload;
    if (string.Equals(format, "csv", StringComparison.OrdinalIgnoreCase))
    {
        payload = await CsvConcatRequestParser.ParseAsync(request);
    }
    else
    {
        payload = await request.ReadFromJsonAsync<ConcatRequest>()
                   ?? throw new BadHttpRequestException("Body is required", StatusCodes.Status400BadRequest);
    }

    if (!IsFieldValid(payload.FileName) || !IsFieldValid(payload.Library))
    {
        throw new BadHttpRequestException("fileName and library must be at least 1 and at most 10 characters.",
            StatusCodes.Status400BadRequest);
    }

    var result = new ConcatResponse($"{payload.FileName.TrimEnd()}.{payload.Library.TrimEnd()}");
    return Results.Json(result, statusCode: StatusCodes.Status200OK, contentType: MediaTypeNames.Application.Json);
})
.WithName("Concat")
.Produces<ConcatResponse>(StatusCodes.Status200OK)
.ProducesValidationProblem(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized, typeof(object))
.WithOpenApi(operation =>
{
    operation.Summary = "Concatenate file and library name";
    operation.Description = "Returns FIL.LIB with trailing spaces removed.";
    return operation;
});
```
The endpoint accepts either JSON or CSV payloads, validates that both fields are within the ten-character limits imposed on IBM i
identifiers, concatenates them with trimming, and responds with typed OpenAPI metadata for discoverability.

### Helper utilities
```csharp
static bool IsFieldValid(string? value) =>
    !string.IsNullOrWhiteSpace(value) && value.Length <= 10;

internal sealed record ConcatRequest(string FileName, string Library);
internal sealed record ConcatResponse(string FullName);
```
Simple validation and record definitions keep the endpoint logic terse, while using records preserves the immutable contract that
the COBOL caller expects.

### CSV parser support
```csharp
internal static class CsvConcatRequestParser
{
    public static async Task<ConcatRequest> ParseAsync(HttpRequest request)
    {
        using var reader = new StreamReader(request.Body, leaveOpen: false);
        var content = await reader.ReadToEndAsync();
        if (string.IsNullOrWhiteSpace(content))
        {
            throw new BadHttpRequestException("CSV payload is empty.", StatusCodes.Status400BadRequest);
        }

        var parts = content.Split(',', StringSplitOptions.TrimEntries);
        if (parts.Length != 2)
        {
            throw new BadHttpRequestException("CSV payload must contain fileName,library.",
                StatusCodes.Status400BadRequest);
        }

        return new ConcatRequest(parts[0], parts[1]);
    }
}
```
This helper isolates the CSV parsing path so the endpoint can remain focused on validation and response composition while still
supporting legacy jobs that only emit comma-delimited payloads.

## Full Source
```csharp
// Configure the web host with consistent, lowercase routes so COBOL
// consumers can rely on predictable URIs when invoking the service.
var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<RouteOptions>(options =>
{
    options.LowercaseUrls = true;
});

// Logging is retained to mirror IBM i job logs when diagnosing
// integration issues between the host and the modern endpoint.
builder.Services.AddLogging();

var app = builder.Build();
var requiredApiKey = app.Configuration["Xacbltst:ApiKey"];

// Lightweight middleware enforces the shared secret that callers
// must supply, matching the operational controls on the IBM i side.
app.Use(async (context, next) =>
{
    if (string.IsNullOrWhiteSpace(requiredApiKey))
    {
        await next();
        return;
    }

    if (!context.Request.Headers.TryGetValue("X-API-Key", out var provided) ||
        !string.Equals(provided, requiredApiKey, StringComparison.Ordinal))
    {
        context.Response.StatusCode = StatusCodes.Status401Unauthorized;
        await context.Response.WriteAsJsonAsync(new { error = "API key is missing or invalid." });
        return;
    }

    await next();
});

// The concat endpoint accepts JSON by default, with a CSV option that
// mirrors the fixed-field payloads often produced by COBOL programs.
app.MapPost("/api/v1/concat", async (HttpRequest request) =>
{
    var format = request.Query["format"].ToString();

    ConcatRequest payload;
    if (string.Equals(format, "csv", StringComparison.OrdinalIgnoreCase))
    {
        payload = await CsvConcatRequestParser.ParseAsync(request);
    }
    else
    {
        payload = await request.ReadFromJsonAsync<ConcatRequest>()
                   ?? throw new BadHttpRequestException("Body is required", StatusCodes.Status400BadRequest);
    }

    if (!IsFieldValid(payload.FileName) || !IsFieldValid(payload.Library))
    {
        throw new BadHttpRequestException("fileName and library must be at least 1 and at most 10 characters.",
            StatusCodes.Status400BadRequest);
    }

    var result = new ConcatResponse($"{payload.FileName.TrimEnd()}.{payload.Library.TrimEnd()}");
    return Results.Json(result, statusCode: StatusCodes.Status200OK, contentType: MediaTypeNames.Application.Json);
})
.WithName("Concat")
.Produces<ConcatResponse>(StatusCodes.Status200OK)
.ProducesValidationProblem(StatusCodes.Status400BadRequest)
.Produces(StatusCodes.Status401Unauthorized, typeof(object))
.WithOpenApi(operation =>
{
    operation.Summary = "Concatenate file and library name";
    operation.Description = "Returns FIL.LIB with trailing spaces removed.";
    return operation;
});

app.Run();

static bool IsFieldValid(string? value) =>
    !string.IsNullOrWhiteSpace(value) && value.Length <= 10;

internal sealed record ConcatRequest(string FileName, string Library);
internal sealed record ConcatResponse(string FullName);

// Dedicated CSV parser keeps minimal API handlers concise while
// supporting clients that cannot emit JSON directly from COBOL.
internal static class CsvConcatRequestParser
{
    public static async Task<ConcatRequest> ParseAsync(HttpRequest request)
    {
        using var reader = new StreamReader(request.Body, leaveOpen: false);
        var content = await reader.ReadToEndAsync();
        if (string.IsNullOrWhiteSpace(content))
        {
            throw new BadHttpRequestException("CSV payload is empty.", StatusCodes.Status400BadRequest);
        }

        var parts = content.Split(',', StringSplitOptions.TrimEntries);
        if (parts.Length != 2)
        {
            throw new BadHttpRequestException("CSV payload must contain fileName,library.",
                StatusCodes.Status400BadRequest);
        }

        return new ConcatRequest(parts[0], parts[1]);
    }
}
```
