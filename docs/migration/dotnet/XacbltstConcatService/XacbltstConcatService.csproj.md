# XacbltstConcatService.csproj — Project Definition

## Overview
This SDK-style project file targets .NET 8 and enables implicit usings and nullable reference types so the minimal API can stay
concise while maintaining modern safety defaults. Keeping the configuration minimal mirrors the lightweight nature of the original
COBOL utility while providing enough infrastructure for production hosting.

## Dependencies
### Incoming
- Referenced by CLI and IDE tooling when running `dotnet restore`/`dotnet run` as described in
  [`README.md`](README.md).
- Loaded by the COBOL integration tests through the sample host in [`Program.cs`](Program.cs.md).

### Outgoing
- `Microsoft.NET.Sdk.Web` delivers ASP.NET Core assemblies used by the minimal API and configures the build for web hosting.
- SDK defaults pull in `Microsoft.AspNetCore.App` shared framework, which includes routing, configuration, and HTTP abstractions
  consumed in `Program.cs`.

## Structure
### Core properties
```xml
<PropertyGroup>
  <TargetFramework>net8.0</TargetFramework>
  <Nullable>enable</Nullable>
  <ImplicitUsings>enable</ImplicitUsings>
</PropertyGroup>
```
The project builds against the LTS .NET 8 runtime and enables nullable reference type analysis plus implicit global usings. Those
settings reduce boilerplate in the minimal API while surfacing potential null-safety issues during compilation.

## Full Source
```xml
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```
