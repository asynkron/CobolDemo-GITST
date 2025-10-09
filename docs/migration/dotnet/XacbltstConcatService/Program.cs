using System;
using System.IO;
using System.Threading.Tasks;
using System.Net.Mime;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

var builder = WebApplication.CreateBuilder(args);

builder.Services.Configure<RouteOptions>(options =>
{
    options.LowercaseUrls = true;
});

builder.Services.AddLogging();

var app = builder.Build();

var requiredApiKey = app.Configuration["Xacbltst:ApiKey"];

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
