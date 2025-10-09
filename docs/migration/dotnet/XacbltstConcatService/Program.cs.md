# Program.cs Modernization Snapshot

This minimal API host fronts the modernized concatenation service that replaces the legacy `XACBLTST` COBOL utility. The endpoint trims and combines the file and library names so IBM i callers can offload string handling to ASP.NET while receiving the same shape of response. The API key filter keeps the service from being invoked without coordination, preserving the guarded behavior of the original batch job.

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

The host is required so the new service can be deployed next to existing IBM i workloads, yet keep the callable contract stable. Documenting it here makes the migration playbook actionable for teams replicating the pattern.
