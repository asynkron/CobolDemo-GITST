# Archaeology Evidence Map

## Baseline and method

**Fact.** This baseline inventories commit `3a05212` as observed on 2026-07-14. `git ls-files` reports **885 tracked files**, of which **444 are Markdown**. Counts below are Git-tracked counts; they do not infer what is compiled or deployed.

**Fact.** The worktree also contained an unrelated untracked root `Makefile` and five modified tracked files under `docs/migration/dotnet/XacbltstConcatService/obj/Debug/net8.0/` before this audit was authored. They are excluded from the baseline's build-manifest claims and were not changed or adopted by this work.

The inventory method was:

1. enumerate tracked paths with `git ls-files`;
2. group primary artifacts by top-level source physical-file convention and suffix;
3. inspect representative primary members and configuration for role and interface clues;
4. reconcile secondary indexes and summaries against Git rather than treating them as exhaustive;
5. record observed Faktorial text, knowledge, codegraph, analyzer, and Tree-sitter behavior independently.

### Evidence status

- **Fact** means directly observable in a tracked path or reproducible count.
- **Inference** means a conclusion supported by facts but not explicit about chronology, intent, deployment, or ownership.
- **Unknown** means the repository cannot decide the claim; the missing evidence is stated.

Per-member Markdown, context summaries, `files.md`, generated build output, and graph reports are **secondary evidence**. Primary evidence is the source member, configuration, or manifest itself.

## Repository and file-family map

The tracked top-level totals reconcile to 885 files.

| Path family | Primary/non-Markdown inventory | Tracked total | Classification and path evidence |
| --- | ---: | ---: | --- |
| repository root | `.project`, `CobolDemo-GITST.sln` plus 4 Markdown files | 6 | IBM RDi project metadata, Visual Studio solution, repository docs/indexes |
| `.ibmi/` | 1 `.properties` | 2 | IBM i remote-build setting plus secondary context |
| `.idea/` | 2 `.gitignore`, 14 `.xml` | 17 | JetBrains/Copilot/encoding/VCS metadata plus secondary context |
| `ASIMPLTEST/` | 1 `.RPG` | 3 | mixed/ad hoc tutorial source plus companion and context |
| `CPYBKSRC/` | 4 `.CBLINC` | 9 | COBOL copybooks plus four companions and context |
| `QCBLSRC/` | 8 `.CBL` | 17 | COBOL program members plus eight companions and context |
| `QCLLESRC/` | 1 `.CLLE` | 3 | ILE CL diagnostic member plus companion and context |
| `QCLSRC/` | 36 `.CLP`, 5 `.CLLE` | 83 | OPM/ILE CL orchestration plus 41 companions and context |
| `QCMDSRC/` | 5 `.CMD` | 11 | IBM i command definitions plus companions and context |
| `QDDSSRC/` | 48 `.PF`, 85 `.LF`, 50 `.DSPF`, 7 `.PRTF`, 1 extensionless | 383 | database, access path, screen, print, and exceptional member data plus 191 companions and context |
| `QQMQRYSRC/` | 3 extensionless members | 7 | Query/400 report definitions plus companions and context |
| `QRPGLESRC/` | 83 `.RPGLE`, 8 `.SQLRPGLE`, 1 `.RPG`, 1 `.CLLE` | 187 | ILE/SQL RPG with two exceptional dialect members, companions, and context |
| `QRPGSRC/` | 47 `.RPG`, 1 `.RPG36`, 1 `.RPG38` | 99 | fixed-format RPG and older dialect samples plus companions and context |
| `QSQLPRC/` | 4 extensionless members | 9 | Db2 stored-procedure source plus companions and context |
| `QSQLSRC/` | 2 `.SQL` | 5 | SQL DDL/data source plus companions and context |
| `docs/` | 44 tracked files before this archaeology corpus | 44 | narrative, SSADM, rules, architecture, graph analysis, and migration spike; detailed below |

**Fact.** Repository-wide suffix totals include 9 `.CBL`, 49 `.RPG`, 1 `.RPG36`, 1 `.RPG38`, 83 `.RPGLE`, 8 `.SQLRPGLE`, 36 `.CLP`, 7 `.CLLE`, 5 `.CMD`, 48 `.PF`, 85 `.LF`, 50 `.DSPF`, 7 `.PRTF`, 2 `.SQL`, 4 `.CBLINC`, and 8 extensionless files. These global totals cross directory boundaries: the ninth `.CBL` is `docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL`; the 49 `.RPG` files comprise 47 in `QRPGSRC/`, `QRPGLESRC/CUSTDTL.RPG`, and `ASIMPLTEST/TUTR001.RPG`.

### Material source and operational families

- **COBOL programs — Fact:** `QCBLSRC/*.CBL` contains eight programs, including `ZBCONDET.CBL`, `ZBCUSTS.CBL`, and `XACBLTST.CBL`. `docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL` is a ninth, later migration client outside the IBM i source-physical-file directory.
- **Copybooks/includes — Fact:** `CPYBKSRC/*.CBLINC` contains four shared layouts: `CUSFL300`, `CUSGRP00`, `CUSTS00`, and `DISTS00`. COBOL `COPY` statements and DDS-generated formats imply additional compile-time layouts that are not all stored in this directory.
- **RPG dialects — Fact:** `QRPGSRC/` contains fixed-format `.RPG`, one `.RPG36`, and one `.RPG38`; `QRPGLESRC/` contains ILE `.RPGLE`, embedded-SQL `.SQLRPGLE`, and exceptional `.RPG`/`.CLLE` members. `ASIMPLTEST/TUTR001.RPG` is explicitly mixed/ad hoc evidence, not an automated test suite.
- **Control language — Fact:** `QCLSRC/` and `QCLLESRC/` contain `.CLP` and `.CLLE` orchestration. Representative commands include `OVRDBF`, `OVRPRTF`, `CALL`, `SBMJOB`, `SNDPGMMSG`, library-list operations, and queue inspection.
- **Commands — Fact:** `QCMDSRC/*.CMD` defines five operator command surfaces for order audit and transaction-history flows.
- **DDS data definitions — Fact:** `QDDSSRC/*.PF` defines physical files; `*.LF` defines logical/access-path views; `*.DSPF` defines display/subfile UI; and `*.PRTF` defines print layouts. `QDDSSRC/ORDERS` is an extensionless exceptional member and must not be lost by suffix-only enumeration.
- **Query/400 — Fact:** `QQMQRYSRC/BALANCEPRD`, `BALANCESTO`, and `ORDERS` are three extensionless query definitions.
- **SQL — Fact:** `QSQLSRC/COUNTRY.SQL` and `COUNTRYDTA.SQL` provide DDL/data evidence. Four extensionless members in `QSQLPRC/` contain procedure examples. Eight `.SQLRPGLE` members embed SQL in RPG.
- **Ad hoc tests — Fact:** `ASIMPLTEST/TUTR001.RPG` and members with test-like names such as `QRPGLESRC/TSTPGM*.SQLRPGLE`, `XRTEST1.RPGLE`, and `QDDSSRC/TSTPF*` are test clues. There is no tracked automated test project or assertion harness for the IBM i sources.

### Documentation, configuration, build, generated, and deployment evidence

- **Documentation — Fact:** before this corpus, `docs/` held 44 tracked files: 12 at its root, 2 in `docs/architecture/`, 3 in `docs/business_rules/`, and 27 in `docs/migration/`. Across the repository, 402 Markdown files are member companions and 18 are `context.md` files. The remaining Markdown covers indexes, SSADM material, business rules, architecture, and migration.
- **Source Atlas — Fact:** `files.md` maps 13 source-directory sections and top-level `.project`/solution links. It omits hidden metadata and several generated/configuration concerns, so it is a launchpad rather than a completeness proof.
- **IBM tooling configuration — Fact:** `.project` declares IBM RDi/iSeries project builder, validator, and nature. `.ibmi/.properties` sets `NullBuildStyle`; the tracked `.ibmi/context.md` statement that the directory is empty is stale secondary evidence.
- **IDE configuration — Fact:** `.idea/` has duplicated outer/nested JetBrains metadata for Copilot data migration, encodings, index layout, and VCS mapping. These files affect workspace behavior, not proven application runtime behavior.
- **Modern build surface — Fact:** `CobolDemo-GITST.sln` contains one .NET project, `docs/migration/dotnet/XacbltstConcatService/XacbltstConcatService.csproj`, targeting .NET 8 with the Web SDK. No tracked root build script or IBM i deployment manifest was found.
- **Generated artifacts — Fact:** 14 tracked files live under the .NET project's `obj/` directory. They include 3 generated `.cs` files plus NuGet/MSBuild JSON, props, targets, caches, editor config, and Rider restore metadata. Together with hand-authored `Program.cs`, the repository contains four tracked `.cs` files. Generated files are outputs/secondary evidence, not hand-authored application logic.
- **Configuration — Fact:** the .NET spike tracks `appsettings.json` and `Properties/launchSettings.json`. It contains an API-key setting and local HTTP/HTTPS launch URLs. Configuration presence does not prove any deployed instance.
- **Deployment — Unknown:** no tracked CI workflow, container manifest, package/deploy script, IBM i connection profile, or infrastructure definition proves a deployment process. RDi metadata and migration launch settings are tooling clues only.

## IBM i naming and historical layers

### Naming conventions

- **Fact:** top-level `Q*SRC` names mirror IBM i source physical files: `QCBLSRC` (COBOL), `QRPGSRC` (RPG), `QRPGLESRC` (ILE RPG), `QCLSRC`/`QCLLESRC` (CL), `QCMDSRC` (commands), `QDDSSRC` (DDS), `QSQLSRC`/`QSQLPRC` (SQL), and `QQMQRYSRC` (Query/400). Git directories represent members that would traditionally live inside those source files.
- **Fact:** `.PF`, `.LF`, `.DSPF`, and `.PRTF` distinguish physical database files, logical/access-path files, display files, and printer files. Names such as `CUSTS`/`CUSTSL1`, `CONHDR`/`CONHDRL1`, and `TRNHST`/`TRNHSTL*` show base-to-logical families.
- **Fact:** `WW*` RPGLE members and `W*D` display files repeatedly pair work-with/interactive programs with screen definitions, for example `WWCONDET.RPGLE` and `WCONDETD.DSPF`.
- **Inference:** `WW` means “work with” and `ZB` marks one COBOL application namespace; repeated usage supports these readings, but no tracked naming standard expands them formally.
- **Inference:** `ZAUD*` identifies audit programs; `*D` frequently denotes a display definition and `*L<n>` a logical access path. Exceptions exist, so prefixes/suffixes are navigation heuristics, not type guarantees.
- **Fact:** suffixes such as `BK`, `_0`, `_1`, `_2`, `NW`, and names such as `CB906R@BK` distinguish apparent backups or variants.
- **Unknown:** which variants are authoritative, compiled, or active in any environment cannot be decided from names alone.

### Layering model

1. **Fact — data and terminal layer:** DDS physical/logical members define records and access paths; display/printer DDS defines 5250 screens, subfiles, and spool layouts used by program members.
2. **Fact — procedural application layer:** fixed-format RPG, COBOL, and copybooks consume those record formats. Indicator-heavy UI/file operations are visible in the source.
3. **Fact — operational layer:** CL/CLLE and CMD members apply overrides, manipulate library lists, call programs, submit jobs, send messages, and direct print output.
4. **Fact — incremental IBM i modernization:** RPGLE, SQLRPGLE, SQL DDL, and SQL procedures coexist with the earlier DDS/fixed-format families.
5. **Fact — external-service experiment:** the migration corpus adds an ASP.NET Core .NET 8 service at `/api/v1/concat` and a COBOL client using Db2 `SYSTOOLS.HTTPPOSTCLOB`.
6. **Inference — chronology:** the technology generations and variant names suggest accretion rather than a single redesign, but Git history and source text do not establish original production dates or rollout order for most IBM i members.

## External interfaces and operational clues

These are **interface clues**, not deployment assertions:

- **Fact:** `QCLSRC/CUSMNU.CLP` inspects `QSYSOPR`, submitted jobs, and output queues; `XASYSOPR.CLP` sends an operator message.
- **Fact:** `QCLSRC/DLYFAXSHT.CLP` uses `SBMJOB` with job description `FAXJOBD`; `FXS1C.CLP`, `FAXSHT.CLP`, `WKCUSL.CLP`, and security utilities route print output to `FAXSTARPRT` or other out queues.
- **Fact:** CL members use hard-coded or parameterized libraries, library lists, database/printer overrides, message files, and program queues.
- **Fact:** `QRPGLESRC/CNTCMAINT.RPGLE` calls `SNDEMAIL`; `QRPGSRC/SNDEMAIL.RPG` is not present, while an RPGLE member of that name is tracked. Call binding and the actual mail transport remain unresolved.
- **Fact:** Query/400 members describe report-facing joins/selections, while SQL procedures and SQLRPGLE are database-callable interface candidates.
- **Fact:** `docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL` constructs `/api/v1/concat` and invokes `SYSTOOLS.HTTPPOSTCLOB`; `Program.cs` implements the route with JSON/CSV inputs and optional API-key middleware.
- **Unknown:** the referenced libraries, job descriptions, message files, queues, FAX*STAR installation, mail utility, Db2 HTTP support, and HTTP service are not proven to exist or be configured outside this repository.

## Faktorial and local-analysis coverage

The following are facts about the probes performed during the 2026-07-14 investigation, not guarantees about every future tool version:

| Probe | Observed result | Coverage consequence |
| --- | --- | --- |
| Repository text search | Found COBOL `COPY` and cross-document text occurrences; enrichment timed out before knowledge/codegraph completion in the sampled request | Text retrieval works, but enrichment absence is not negative dependency evidence |
| Knowledge search | Search for the repository phrase returned no results | The knowledge corpus did not provide an independent inventory for this repository phrase |
| Codegraph: C# | Returned full symbols in the sampled .NET source | Useful semantic navigation for the migration service |
| Codegraph: RPG/CL/DDS/SQL | Returned coarse line-1 module/file nodes; tested RPG/CL nodes had zero internal references | Classification is not dependency resolution; read source/text evidence |
| Codegraph exact lookup | No nodes for COBOL `ZBCONDET`, copybook `CUSTS00`, Query/400 `ORDERS`, or Python `build_graph` | These families/symbols are unindexed in the tested graph |
| Python analyzer | Reported missing `pyright-langserver` | No analyzer-backed Python symbol result was available |
| Tree-sitter | Accepted C# (609 matches in the sampled file); rejected `cobol`, `rpg`, `dds`, `cl`, `sql`, and `python` as unsupported language values | Structural proofs are unavailable for the rejected languages on this surface |

**Fact.** Filename/module visibility must not be described as semantic coverage. In particular, extensionless Query/400/procedure members, `.CBLINC`, COBOL, and coarse IBM i nodes can be omitted or misrepresented by suffix- or parser-dependent tools.

### Local clustering helper ceiling

`docs/graph_clustering_analysis.py` is useful **heuristic secondary evidence** only:

- it enumerates nine configured directories but omits `CPYBKSRC`, `QQMQRYSRC`, and `ASIMPLTEST`;
- its allowed suffixes omit `.CBLINC`, `.PRTF`, `.RPG36`, `.RPG38`, and all extensionless members;
- its dependency extraction is regex-based and limited to selected `CALL`, `COPY`, and `INCLUDE` forms;
- module names are collapsed to the filename stem, and an edge does not prove runtime reachability or deployment;
- therefore its Louvain/greedy communities and `graph_clustering_analysis.md` cannot prove complete repository dependencies.

## Glossary seed

| Term | Evidence-led meaning |
| --- | --- |
| IBM i source physical file / member | Traditional container/member organization represented here as a `Q*SRC` directory and individual files |
| DDS | IBM i Data Description Specifications used for database, display, and printer objects |
| PF / LF | Physical file data definition / logical file access path or view |
| DSPF / PRTF | Display-file (5250 UI/subfile) / printer-file (spool layout) definition |
| OPM / ILE | Original Program Model / Integrated Language Environment; `.CLP` versus `.CLLE` and fixed RPG versus RPGLE are repository clues, not complete compile metadata |
| RPG / RPGLE / SQLRPGLE | fixed/older RPG, ILE RPG, and ILE RPG with embedded SQL source families |
| CLP / CLLE | Control Language program and ILE CL source members used for orchestration |
| copybook / DDS-generated format | included record layout; tracked `.CBLINC` files cover some layouts, while compiled DDS may generate others outside Git |
| subfile / indicator | IBM i display-list construct / positional state or I/O flag used heavily by DDS-driven programs |
| library list / override | IBM i name-resolution path / job-scoped redirection such as `OVRDBF` or `OVRPRTF` |
| spool / out queue | generated print output and its routing destination, including repository references to `PRT02`, `PRT04`, and `FAXSTARPRT` |
| Query/400 | IBM i query/report definitions stored extensionless in `QQMQRYSRC/` |
| `WW*`, `ZB*`, `ZAUD*` | inferred work-with, COBOL application, and audit naming families; no formal expansion is tracked |
| `*D`, `*L<n>`, `BK`/`NW` | common display, logical-file, and apparent backup/new variant suffixes; exceptions and active-version status remain unknown |

## Unknowns register

1. Which programs, variants, commands, files, and queries are compiled and active in each IBM i environment?
2. What are the authoritative build order, compile options, target libraries, source member types, and deployment procedure?
3. Which external libraries, programs, message files, job descriptions, printers/out queues, FAX*STAR components, and mail facilities exist?
4. Which DDS-generated copybooks/formats are produced outside Git, and are the four tracked `.CBLINC` layouts synchronized with them?
5. Are `BK`, `NW`, numbered, and underscore variants backups, experiments, or deployed alternatives?
6. Which Query/400 definitions and stored procedures are used, and by whom?
7. Are the .NET service and COBOL HTTP client demonstrations only, or deployed integrations? What owns secrets, TLS, and endpoint configuration?
8. What character encodings and source CCSIDs apply? Some source text contains non-UTF-8-looking characters, while IDE encoding metadata is secondary evidence.
9. Are tracked `obj/` outputs intentionally versioned, and what process refreshes them?
10. What behavior constitutes acceptance for the IBM i flows? Test-like members exist, but no automated harness or runtime traces are tracked.

## Coverage ledger

“Enumerated” means every tracked path in the bounded family was counted; “sampled” means representative primary members were read for role/interface evidence.

| Family/layer | Repository paths and inventory basis | Representative primary evidence | Evidence status | Faktorial/search status | Documentation coverage | Remaining gap |
| --- | --- | --- | --- | --- | --- | --- |
| COBOL application | `QCBLSRC/`: 8 `.CBL`, enumerated | `ZBCONDET.CBL`, `ZBCUSTS.CBL`, `XACBLTST.CBL` | Fact; sampled behavior | Text-visible; exact `ZBCONDET` codegraph miss; Tree-sitter unsupported | context + per-member companions | compile/deploy/runtime use |
| COBOL HTTP migration | `docs/migration/cobol/xacbltst/`: 1 `.CBL`, enumerated | `XACBLTST-CLIENT.CBL` | Fact | text-visible; legacy structural coverage unavailable | migration README + companion | deployed endpoint and Db2 HTTP availability |
| Copybooks/includes | `CPYBKSRC/`: 4 `.CBLINC`, enumerated | `CUSTS00.CBLINC`, `CUSFL300.CBLINC` | Fact | text-visible; exact `CUSTS00` codegraph miss; Tree-sitter unsupported | context + companions | generated layouts and drift |
| Fixed/old RPG | `QRPGSRC/`: 47 `.RPG`, 1 `.RPG36`, 1 `.RPG38`, enumerated | `OE001.RPG`, `XRATE_EURO.RPG`, `RPG36.RPG36`, `DEALENT.RPG38` | Fact; sampled behavior | coarse file nodes, tested references empty; Tree-sitter unsupported | context + companions | active variants and call graph |
| ILE/SQL RPG | `QRPGLESRC/`: 83 `.RPGLE`, 8 `.SQLRPGLE`, plus 1 `.RPG`/1 `.CLLE`, enumerated | `WWCONDET.RPGLE`, `CONCATPGM.SQLRPGLE`, `CL03.CLLE` | Fact; sampled behavior | coarse nodes, no reliable tested internal references; Tree-sitter unsupported | context + companions | compile bindings/runtime entry points |
| CL orchestration | `QCLSRC/` 36 `.CLP` + 5 `.CLLE`; `QCLLESRC/` 1 `.CLLE`, enumerated | `CUSMNU.CLP`, `DLYFAXSHT.CLP`, `XASYSOPR.CLP`, `TESTWIMX.CLLE` | Fact; sampled behavior | coarse nodes, tested references empty; Tree-sitter unsupported | contexts + companions | external objects and schedules |
| Command surfaces | `QCMDSRC/`: 5 `.CMD`, enumerated | `ORDERAUDIT.CMD`, `TRNHSTCMD.CMD` | Fact | coarse/unsupported semantic coverage | context + companions | command-to-program binding and use |
| DDS database/access | `QDDSSRC/`: 48 `.PF`, 85 `.LF`, 1 extensionless, enumerated | `CUSTS.PF`, `CUSTSL1.LF`, `ORDERS` | Fact; sampled behavior | coarse nodes; Tree-sitter unsupported; extensionless risk | context + companions | actual data, keys/index use, exceptional member type |
| DDS UI/print | `QDDSSRC/`: 50 `.DSPF`, 7 `.PRTF`, enumerated | `WCONDETD.DSPF`, `WCUSTSD.DSPF`, `WCUSTRP.PRTF` | Fact; sampled behavior | coarse nodes; Tree-sitter unsupported; `.PRTF` omitted locally | context + companions | indicator contracts and spool environment |
| Query/400 | `QQMQRYSRC/`: 3 extensionless, enumerated | `ORDERS`, `BALANCEPRD`, `BALANCESTO` | Fact | exact `ORDERS` codegraph miss; unsupported structurally; omitted locally | context + companions | execution parameters, consumers, schedules |
| SQL DDL/data | `QSQLSRC/`: 2 `.SQL`, enumerated | `COUNTRY.SQL`, `COUNTRYDTA.SQL` | Fact | coarse/unsupported structural coverage | context + companions | target schema and deployment |
| SQL procedures | `QSQLPRC/`: 4 extensionless, enumerated | `CONCATSTR`, `SQL_PRC_01` | Fact; sampled behavior | extensionless/unindexed risk; Tree-sitter unsupported | context + companions | deployed definitions and callers |
| Ad hoc/test clues | `ASIMPLTEST/TUTR001.RPG`; `TST*`, `XRTEST1`, and `*TSTPF*` names, enumerated by path/name | `TUTR001.RPG`, `TSTPGM1.SQLRPGLE`, `TSTPF1.PF` | Fact for files; unknown as tests | legacy semantic coverage incomplete | context + companions | executable harness, assertions, expected results |
| IBM/RDi configuration | `.project`, `.ibmi/.properties`, enumerated | RDi builder/nature; `NullBuildStyle` | Fact | text-visible; not application semantics | contexts are secondary and partly stale | connection/build profiles and compile pipeline |
| IDE configuration | `.idea/`: 16 non-Markdown metadata files, enumerated | `encodings.xml`, `vcs.xml`, Copilot migration XML | Fact | text-visible/config only | `.idea/context.md` | which metadata is required |
| .NET service/build | solution + `.csproj`, `Program.cs`, app/launch JSON, enumerated | route `/api/v1/concat`, .NET 8 Web SDK | Fact | full sampled C# symbols; C# Tree-sitter accepted | migration docs + companions | deployment, secrets, runtime ownership |
| Generated .NET output | service `obj/`: 14 tracked files, enumerated | generated assembly/global-usings files, NuGet assets | Fact; secondary evidence | C# parser may see generated symbols | no dedicated ownership rule | why tracked and refresh policy |
| Documentation | 444 Markdown repository-wide at baseline, enumerated | SSADM `01`-`06`, `architecture/overview.md`, business rules, contexts, companions | Fact for presence; claims require source validation | repository search works; knowledge phrase miss | extensive but uneven | freshness and unsupported assertions |
| Graph analysis | `docs/graph_clustering_analysis.py` + report, enumerated and read | configured directories/suffixes and regex patterns | Fact about heuristic; inference in communities | Python analyzer missing; exact symbol miss; Python Tree-sitter rejected | report documents output | omitted families/suffixes and runtime reachability |
| Deployment/infrastructure | no tracked CI/IaC/container/deploy script; untracked `Makefile` excluded | `.project`, launch settings are only clues | Unknown | not applicable | migration narrative only | authoritative build/deploy evidence |
| External interfaces | references across CL/RPG/COBOL/migration sources, sampled | `QSYSOPR`, `SBMJOB`, `FAXSTARPRT`, `SNDEMAIL`, `HTTPPOSTCLOB` | Fact for references; unknown for availability | text search only is reliable across all families | interface/migration docs provide secondary context | environment inventory and runtime traces |

## Baseline conclusion

**Fact.** Every tracked top-level family and every observed suffix/extensionless family is represented in this map. **Inference.** The repository shows a DDS-centered IBM i application accumulated across fixed RPG/COBOL, CL orchestration, ILE/SQL additions, and a later HTTP/.NET experiment. **Unknown.** Build/deployment truth and production reachability require IBM i environment evidence, external dependency inventories, and runtime traces; neither documentation volume nor current semantic indexing can supply them.
