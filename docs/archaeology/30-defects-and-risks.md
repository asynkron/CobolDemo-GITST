# Defects, Reliability Hazards, and Maintainability Risks

## Audit boundary and method

Audit date: **2026-07-14**

Repository revision: **`012677192caa66e54fd72191bb3b2afafb8b3402`**

This is a source-level audit, not a production incident report. A **confirmed defect** below has a directly observable erroneous control or data-flow path and a credible trigger. A **confirmed risk** has a directly observable hazardous mechanism, but its incident outcome depends on runtime configuration, data, or IBM i behavior not stored here. A **supported inference** connects cited facts without claiming runtime use. An unresolved **hypothesis** names the evidence still needed before promotion.

Primary evidence is tracked source, DDS, copybook, configuration, or build metadata at the revision above. Per-member Markdown, `context.md`, `files.md`, generated `obj/` output, and graph reports are secondary navigation aids only. Line references use the revision above; the path and named paragraph/subroutine remain the durable locator if later edits move them.

No authoritative IBM i compile recipe, deployment manifest, active-member inventory, commitment-control configuration, database sample, or automated assertion harness is tracked. Faktorial semantic and Tree-sitter support is also incomplete for COBOL, RPG, CL, DDS, copybooks, and extensionless SQL members. Consequently, “confirmed” means confirmed in source for any compiled/deployed copy of the cited member; whether that copy is active is unknown. No production source or configuration was changed for this audit.

## Executive triage

| Priority | Finding | Why it matters |
| --- | --- | --- |
| Stabilize first | D-01 to D-03, contract-detail maintenance | Both `CBCONDET` source variants contain non-terminating validation, an accepted-invalid-status path, and header mutation from a detail workflow. These can block operators or corrupt the header/detail boundary if either variant is active. |
| Make the migration spike internally consistent | D-04 and D-05 | The checked-in default service rejects its companion client, while the client constructs JSON without escaping input. The legacy fallback hides the failed migration path from callers. |
| Establish transaction and error contracts | R-01, R-02, R-04 | Header/detail writes and wrapper calls expose partial-success and silent-failure behavior; repository evidence does not establish rollback or operator recovery. |
| Resolve deployment truth before remediation | H-01 to H-05 | Variant selection, commitment control, generated record layouts, referential behavior, CCSIDs, and external facilities require environment evidence. |

## Confirmed defects

### D-01 — Successful contract-detail validation never returns

| Field | Evidence |
| --- | --- |
| Category | Correctness; control flow; availability |
| Severity / confidence | **High / high** |
| Affected behavior | Selecting update in `CBCONDET` cannot leave validation after all customer, status, and representative lookups succeed. |
| Exact primary evidence | `QCBLSRC/ZBCONDET.CBL:612-688` defines `VALIDT-ROUTINE`; every failing lookup goes to `VALIDT-EXIT`, but the success path at line 687 executes `GO VALIDT-ROUTINE`. Its caller at lines 589-595 can exit the screen only after the performed paragraph returns. The duplicate program has the same back-edge at `QCBLSRC/ZBCONDETNW.CBL:610-673`, specifically line 672. |
| Trigger / preconditions | Invoke the option-2 update path with a nonzero contract and customer, status, and representative keys that all resolve. |
| Impact | The program repeatedly rereads the same records and does not return control to the screen/update path. This is an operator-visible hang and can retain job/file resources until interrupted. |
| Verification method | Compile the selected variant in an isolated library, supply fixture rows for every validation lookup, invoke option 2, and trace paragraph execution or impose a bounded timeout. Static verification is the unconditional success-edge from the last lookup back to the paragraph entry. |

### D-02 — Unknown status is treated as validation success

| Field | Evidence |
| --- | --- |
| Category | Correctness; stale/error status handling |
| Severity / confidence | **High / high** |
| Affected behavior | A missing `ORDSTS` key displays/loads an error message but leaves `WS-ERROR` blank, so the caller takes its success branch. |
| Exact primary evidence | `QCBLSRC/ZBCONDET.CBL:612-670` clears `WS-ERROR`, sets it for missing contract/customer, but the missing-status branch at lines 665-670 does not set it before `GO VALIDT-EXIT`. The caller at lines 589-595 interprets any value other than `"Y"` as success. `QCBLSRC/ZBCONDETNW.CBL:610-659` repeats the omission. |
| Trigger / preconditions | Enter or retain a status code absent from `ORDSTS`, with earlier validation checks passing. |
| Impact | Update processing may proceed with an invalid status; in the current detail programs it then reaches the wrong header mutation described by D-03. At minimum, the user is allowed out of the correction loop despite failed validation. |
| Verification method | In an isolated compiled variant, use an `ORDSTS`-absent value and trace `WS-ERROR` at `VALIDT-EXIT`; assert that the caller does not take its success branch. Static verification is the absent `MOVE "Y" TO WS-ERROR` in that failure branch compared with adjacent customer and representative branches. |

### D-03 — Contract-detail update and delete mutate `CONHDR`

| Field | Evidence |
| --- | --- |
| Category | Data integrity; wrong-record update/delete |
| Severity / confidence | **Critical / high** |
| Affected behavior | The contract-detail program reads and lists `CONDET`, but its option-2 and option-4 routines rewrite or delete the contract header rather than the selected detail. |
| Exact primary evidence | `QCBLSRC/ZBCONDET.CBL:23-28,93-96` establishes `CONDET` as the program's indexed detail file and record. Lines 490-498 iterate details for the selected contract. Yet `CHGREC-ROUTINE` reads/rewrites `CONHDR-FILE` at lines 522-555, and `DELREC-ROUTINE` reads/deletes `CONHDR-FILE` at lines 690-723. `QDDSSRC/CONHDR.PF:2-17` has a contract-only key, while `QDDSSRC/CONDET.PF:2-17` has the contract-plus-product key expected for a selected detail. `QCBLSRC/ZBCONDETNW.CBL:526-550,675-705` duplicates the header mutations. |
| Trigger / preconditions | In either compiled `CBCONDET` variant, choose update or delete for a detail row; confirm delete with F23 for the destructive path. |
| Impact | Update can copy a detail-screen shape into a header record by corresponding names; delete can remove the entire header while leaving details or failing under an external constraint. Both violate the workflow's selected-record boundary. |
| Verification method | Use an isolated library with one header and at least two details. Snapshot both files, perform each action on one detail, and compare record-level changes. The expected safety invariant is that only the selected `CONDET` key may change; current static targets are `CONHDR-FILE`. |

### D-04 — Default service configuration rejects the companion COBOL client

| Field | Evidence |
| --- | --- |
| Category | Build/configuration; authentication interoperability |
| Severity / confidence | **Medium / high** |
| Affected behavior | Running the .NET service with its checked-in default configuration requires an API-key header that its supplied COBOL client never sends. |
| Exact primary evidence | `docs/migration/dotnet/XacbltstConcatService/appsettings.json:1-4` contains a nonblank placeholder key (value intentionally not repeated). `Program.cs:21-40` returns HTTP 401 unless `X-API-Key` equals that value. `docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL:15-16,75-118` sends only content-type/accept headers and falls back on every non-200 response. |
| Trigger / preconditions | Start the service with repository defaults and point the COBOL client at it without an external configuration override. |
| Impact | Every migrated call is rejected and silently uses the legacy routine, so the supplied end-to-end migration path does not exercise the service and can appear successful only because of fallback. |
| Verification method | Start in an isolated environment with defaults, capture one client request, and assert HTTP 401 plus legacy fallback. Then supply a matching header or disable the key explicitly and assert HTTP 200; do not use a real credential. |

### D-05 — COBOL client embeds unescaped fields in JSON

| Field | Evidence |
| --- | --- |
| Category | Encoding; input serialization; injection boundary |
| Severity / confidence | **Medium / high** |
| Affected behavior | The client concatenates translated fixed-width input directly between JSON quotes, without escaping JSON metacharacters or control characters. |
| Exact primary evidence | `docs/migration/cobol/xacbltst/XACBLTST-CLIENT.CBL:75-87` calls `QDCXLATE` and then constructs the request with `STRING`, inserting both translated fields verbatim. `Program.cs:46-55` deserializes the body as JSON. No escaping routine or JSON serializer occurs on the client path. |
| Trigger / preconditions | Either ten-character input contains a quote, backslash, or translated control character. |
| Impact | The body can become invalid JSON (HTTP 400/fallback) or change JSON token boundaries. The service's length validation occurs only after parsing, so it cannot protect this boundary. |
| Verification method | Feed quoted and backslash-containing fixture values through the conversion table, capture the exact request bytes, and parse with a conforming JSON parser. Assert the parsed values equal the original fields; the current construction fails that invariant for JSON metacharacters. |

## Confirmed and high-confidence risks

| ID | Category | Severity / confidence | Affected behavior and exact evidence | Trigger and potential impact | Verification / containment evidence needed |
| --- | --- | --- | --- | --- | --- |
| R-01 | Update ordering; integrity; rerun | High / high | `QRPGSRC/PUR01.RPG:145-163` writes or updates `CONHDR` before iterating up to ten `CONDET` writes at lines 165-198. Indicator 55 is populated by each write but is not inspected in this subroutine. A bounded repository search found no `COMMIT`, `ROLLBACK`, `STRCMTCTL`, or `ENDCMTCTL` in the application COBOL/RPG/CL families. | A later detail write fails, the job ends, or a lock occurs after the header succeeds. A partial order can remain; rerunning may update some existing rows and write others, without a recorded completion boundary. | Establish file journaling and commitment-control state, then fault-inject each detail position and compare both files before/after rerun. |
| R-02 | Error handling; operational recovery | High / high | Each of `QCLSRC/ORDAUDIT00.CLP:1-6`, `ORDAUDIT01.CLP:1-6`, and `ORDAUDIT02.CLP:1-6` calls its RPG program and immediately handles all `CPF0000` with no message, resend, return code, or failure state. | Any covered escape message from the called program is consumed and the wrapper returns normally, depriving a caller/scheduler of failure evidence. | Invoke each wrapper with a controlled failing callee in a test library and inspect job log, caller message state, and scheduler result. Define the intended wrapper contract before changing it. |
| R-03 | Parent/detail integrity; recovery | Critical / medium | `QRPGLESRC/WWCONHDR.RPGLE:469-541` deletes `CONHDRR` after a confirmation flow. No dependent-detail existence check or explicit cascade is visible in that routine. `QDDSSRC/CONDET.PF:16-17` keys details by contract/product but declares no repository-visible referential constraint. | Delete a header that still has details. Outcome may be orphans, a file error, or external trigger/constraint behavior; the repository cannot distinguish these. | Inspect the live Db2 catalog for constraints/triggers and execute a rollback-protected delete fixture with dependent rows. |
| R-04 | Security; transport; observability | High / high | The migration client accepts an environment-provided base URL and posts request/response data through `SYSTOOLS.HTTPPOSTCLOB` (`XACBLTST-CLIENT.CBL:58-118`), but contains no scheme/TLS policy and exposes failure only in internal `WS-ERROR-MSG` before fallback. The checked-in API-key setting is plaintext configuration and is a placeholder, not a production secret. | An `http://` endpoint permits network observation/tampering; a bad certificate, timeout, 401, or parser failure is hidden by fallback, preventing migration-health detection. | Supply deployment config, TLS/certificate policy, secret source, and observable fallback metric/log. Capture requests only with synthetic data and credentials. |
| R-05 | Record contract; date/encoding | High / medium | `CPYBKSRC/CUSTS00.CBLINC:21-27` models four dates as `PIC X(10)`, while `QDDSSRC/CUSTS.PF:43-58` declares native DDS date fields (`L`). The repository does not contain the compile-generated format or conversion policy proving binary/text compatibility. | A program overlays or moves the handwritten copybook against a native external record without compiler-generated conversion. Dates can shift field offsets or use unexpected representation. | Generate the external record format with the actual compiler options, compare offsets/USAGE/CCSID, and round-trip boundary dates. Until then this is a contract risk, not a confirmed mismatch incident. |
| R-06 | Transaction policy; recoverability | Medium / high | `QSQLPRC/SQL_PRC_01:1-5`, `_02:1-7`, and `_03:1-5` directly update/insert/delete schema-qualified data without local handlers or an explicit transaction contract. `QSQLSRC/COUNTRYDTA.SQL:1` explicitly uses `WITH NC`. | A caller assumes rollback or retries after an ambiguous failure while operations are non-transactional or caller-controlled. Duplicate, missing, or partially applied work can result. | Record procedure deployment options, isolation/commitment behavior, caller transaction ownership, SQLSTATE propagation, and retry contract; fault-inject after execution. |
| R-07 | Variant drift; build ambiguity | High / high | `QCBLSRC/ZBCONDET.CBL:3` and `ZBCONDETNW.CBL:3` both declare `PROGRAM-ID CBCONDET` and repeat D-01 through D-03 with small representation differences. The repository has no authoritative compile/deploy manifest. | Compiling either member last changes the deployed implementation while reviews may inspect the other. Fixes can land in one copy and silently drift. | Obtain object/source provenance from active libraries, choose the authoritative source, and add a reproducible compile map or eliminate the duplicate after behavior reconciliation. |
| R-08 | Verification and build | High / high | `ASIMPLTEST/TUTR001.RPG` is mixed ad hoc source; no tracked automated IBM i assertion harness, active-object manifest, CI workflow, or authoritative IBM i compile procedure exists. | Source defects, layout drift, and environment-specific failures reach deployment without repeatable regression evidence; “build succeeded somewhere” cannot be reproduced. | Capture compile commands/options, dependency order, target libraries, fixture strategy, and assertions for destructive flows. Missing tests alone is not evidence of a runtime defect. |

## Supported inferences

| ID | Supported inference | Basis and limit |
| --- | --- | --- |
| I-01 | The contract-detail defects are copied rather than isolated edits. | Both source members declare `CBCONDET` and preserve the same control/data-flow defects, but repository evidence does not establish which copy came first or which is deployed. |
| I-02 | The migration fallback can conceal sustained service non-use. | The client falls back for missing URL, SQL/HTTP failure, non-200 status, and missing parsed output (`XACBLTST-CLIENT.CBL:38-54,101-134`). No metric or outward error contract is present, but runtime monitoring may exist outside Git. |
| I-03 | The data layer relies substantially on application-enforced integrity. | DDS files expose keys and programs sequence cross-file changes, while no repository-visible foreign-key or transaction manifest was found. External Db2 constraints, triggers, journaling, and exit programs remain unknown. |

## Unresolved hypotheses

| ID | Supporting evidence | Uncertainty and potential impact | Evidence required to confirm or reject |
| --- | --- | --- | --- |
| H-01 — Active contract-detail object contains D-01 to D-03 | Both tracked variants compile to the same program ID and are called as `CBCONDET` from `QCBLSRC/ZBCONHDR.CBL:643-646` and `ZBTRNHST.CBL:555-558`. | The active object may come from another source or neither tracked member. If active, the defects are operator/data-integrity critical. | `DSPPGMREF`/object description, source member and compile timestamp, library-list resolution, and a controlled invocation trace. |
| H-02 — Header deletion leaves orphan details | Header deletes are visible in D-03 and `WWCONHDR`; DDS shows related keys but no in-repo referential rule. | External constraints/triggers may reject or cascade. Orphans would break contract totals and detail navigation. | Db2 catalog constraints/triggers, journal evidence, and rollback-protected fixtures with dependent rows. |
| H-03 — Handwritten CUSTS copybook is physically incompatible | Date declarations differ between `CUSTS00.CBLINC` and DDS. | IBM i compiler COPY DDS conversion or usage may reconcile them; raw overlay may not. Misalignment could corrupt every later numeric field. | Actual compile listing/generated copybook, field offset/length report, CCSID, and binary record round-trip. |
| H-04 — Minimal response parser cannot return `fullName` correctly | `XACBLTST-CLIENT.CBL:120-130` repeatedly `UNSTRING`s the full response with no pointer or receiving sequence that clearly advances through JSON. | COBOL dialect/compiler behavior and actual CLOB representation were not available. Failure would force legacy fallback even after HTTP 200. | Compile listing, unit fixture containing the service's exact JSON bytes, trace of each receiving field, and boundary/whitespace variants. |
| H-05 — Encoding conversion corrupts request data | Client uses `QDCXLATE` with a named ten-byte translation table before JSON construction (`XACBLTST-CLIENT.CBL:17-19,75-85`). | Job/source CCSIDs and table behavior are not stored. Non-ASCII input may corrupt or expand; the service accepts at most ten .NET characters. | Job CCSID, source/target CCSID contract, byte traces for representative national characters, and agreed byte-versus-character length semantics. |
| H-06 — SQL procedures and `WITH NC` data load are used operationally | Direct state-changing SQL is tracked and schema-qualified. | They may be demonstrations only. If scheduled or retried, transaction ambiguity becomes an integrity risk. | Object/deployment inventory, callers, schedules, authorities, journaling, and execution history. |

## Coverage matrix

| Required category | Disposition | Evidence / ceiling |
| --- | --- | --- |
| Incorrect conditions, ranges, and control flow | **Confirmed defects** | D-01 and D-02. No additional range defect was promoted without a runnable IBM i compiler/runtime. |
| Precision and overflow | **Inspected; no confirmed defect** | Sampled paired numeric contracts: `CUSTS00.CBLINC:15,24,26,28-41` and `CUSTS.PF:30,49-99` agree on 15 digits/2 decimals for corresponding money fields. `CONHDR.PF:9` (13,2) and `CONDET.PF:9,13` (9,2 and 6,2) establish finite limits, but no arithmetic overflow trigger was proven. Compiler listings and boundary data are required. |
| Record-layout mismatch | **Confirmed risk / hypothesis** | R-05 and H-03 cover native DDS dates versus handwritten character dates. Generated external layouts are absent. |
| Stale status and missing error paths | **Confirmed defect/risk** | D-02 accepts a missing status; R-02 consumes all wrapper escape messages; D-04/R-04 hide service failure through fallback. |
| Update ordering and integrity | **Confirmed defect/risk** | D-03 targets the wrong file; R-01 sequences header before detail without visible recovery; R-03/H-02 cover parent-detail deletion. |
| Rerun and idempotency | **Confirmed risk** | R-01 and R-06: mixed update/write behavior and unstated transaction ownership make retry outcomes ambiguous. No durable idempotency key or completion marker was found in the inspected flows. |
| Encoding and date assumptions | **Confirmed defect/risk/hypothesis** | D-05, R-05, H-03, and H-05. CCSID/compiler evidence is absent. |
| Injection, credentials, and privacy | **Confirmed defect/risk** | D-05 covers JSON token injection; D-04/R-04 cover header mismatch, plaintext placeholder configuration, TLS, and masked evidence. The SQL procedures use parameters rather than dynamic SQL, so no SQL-injection claim is made. No personal values or usable secrets are reproduced here. |
| Dead code and duplicated-rule drift | **Confirmed risk** | R-07 covers two sources with the same program ID and copied defects. Commented defaults and backup/numbered variants were not called dead code because active compile selection is unknown. |
| Operational failure and recovery | **Confirmed risk** | R-01, R-02, R-03, R-04, and R-06. Job logs, journaling, commitment control, scheduler contracts, and runbooks are not tracked. |
| Build and configuration | **Confirmed defect/risk** | D-04 and R-08. The tracked solution builds only the .NET spike; the unrelated untracked root `Makefile` is outside the evidence baseline and was not adopted. |
| Tests and verification | **Known ceiling** | R-08. Test-like source is not an automated assertion harness, and missing tests do not itself prove a defect. |

## Safe checks used and verification ceiling

The audit used bounded source reads with numbered lines, paired DDS/copybook comparison, exact text search for transaction primitives and callers, `git status`, `git diff`, and the required repository-state proof. A search across `QRPGSRC`, `QRPGLESRC`, `QCBLSRC`, and `QCLSRC` found no `COMMIT`, `ROLLBACK`, `STRCMTCTL`, or `ENDCMTCTL`; this proves only absence in that tracked scope, not runtime commitment configuration. The audit file was absent at the pre-edit baseline; the completed artifact is non-empty and the proof below passes.

No tests, typechecks, IBM i compiles, .NET builds, or canonical quality commands were run in the build session. Faktorial owns canonical asynchronous verification. IBM i behavioral checks in the finding tables are verification procedures, not claims that those procedures passed. The final static proof for this artifact is:

```sh
test -s docs/archaeology/30-defects-and-risks.md
```

## Remediation and evidence acquisition order

1. Identify the deployed `CBCONDET` object and authoritative source variant before changing either copy.
2. Isolate and repair D-01 through D-03 together, with record-level fixtures and rollback protection; treating them separately can leave a still-destructive workflow.
3. Define the migration authentication, JSON serialization, TLS, fallback, and observability contract before using the spike as a replacement path.
4. Inventory constraints, triggers, journaling, commitment control, and caller transaction ownership before modifying multi-file writes or SQL procedures.
5. Generate compiler-backed record layouts and CCSID evidence before changing copybooks or native-date fields.
6. Establish a reproducible IBM i compile/deploy manifest and assertions for destructive/rerun flows; only then use runtime results to promote or reject H-01 through H-06.
