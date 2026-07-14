# Operations and Recovery Evidence Map

## Purpose and safety boundary

This document maps what the repository proves about building, configuring, executing, scheduling, observing, backing up, rerunning, and recovering the system. It is an evidence-acquisition and go/no-go guide, **not** a production runbook. No command below should be copied into a live environment from this document.

Evidence labels follow the suite convention: **Fact** is directly visible in a tracked primary path; **Inference** is bounded interpretation; **Unknown** requires named environment evidence. A source-visible `CALL`, `SBMJOB`, override, delete, or update proves only that source requests the action. It does not prove the target exists, the caller has authority, the action is scheduled, or recovery is safe.

Privacy boundary: use synthetic fixtures or approved masked aggregates. Do not capture customer/contact rows, bank/tax fields, free-text comments, usable credentials, unmasked spool content, or production HTTP payloads in repository artifacts.

## Operator go/no-go boundary

Proceed only in an isolated library or approved environment when all applicable items are known: active source/object provenance, target library list, compile options and dependency order, authorities, data/queue overrides, commitment and journaling state, backup/restore point, expected messages/job status, containment owner, and rollback decision. Stop when any required item is Unknown or when source and live object metadata disagree.

The following are always stop conditions:

- executing `ORDAUDIT*`, contract/header/detail deletes, direct SQL mutations, fax/letter submission, or reruns against production without an owner-approved transaction and recovery contract;
- treating a successful `SBMJOB`, `CALL`, or spool creation as successful business delivery;
- selecting a `BK`, `NW`, numbered, COBOL, or RPGLE variant by filename rather than object provenance;
- restoring data without an approved scope, dependency map, journal position, and post-restore reconciliation;
- collecting personal or commercial row values when schema, counts, masked aggregates, or synthetic fixtures answer the question.

## Operational map

| Capability | Repository-confirmed mechanism | Required prerequisites | Observable success / failure signals | Safe boundary and explicit gaps |
| --- | --- | --- | --- | --- |
| Build | `.project` declares IBM RDi/iSeries builder and validator; `.ibmi/.properties` selects `NullBuildStyle`. The solution contains a .NET 8 migration project. Root `Makefile` validates archaeology docs. | Authoritative member types, compile commands/options, dependency order, target libraries, bind steps, generated DDS layouts, and object ownership. | Compiler listings, diagnostics, object level identifiers, source member/timestamp, and reproducible build log. | **Unknown:** there is no IBM i compile recipe. Do not infer one from directory order. The Makefile is not an application build. |
| Configuration | CL uses explicit libraries, `*LIBL`, `OVRDBF`, `OVRPRTF`, job queues/descriptions, message files, environment variables, and output queues. | Approved library list, override map, authority report, job description/queue definitions, message files, device/out-queue ownership, secret and TLS source. | Job attributes, resolved objects, override list, authority failures, CPF/SQL messages, and configuration checksum/version. | **Unknown:** active libraries and external objects. Capture configuration read-only before changing it. Never copy the placeholder API key into evidence. |
| Interactive execution | `CUSMNU.CLP` exposes menu calls and operational views; RPGLE/COBOL maintenance uses DDS screens and files. CMD members expose audit/history prompts. | Proven menu/command binding, active object variant, display/message files, target data library, user authority, synthetic fixture, and expected state transition. | Screen messages, job log, program return/escape message, and before/after fixture keys. | Source does not prove which COBOL/RPGLE route is active. D-01 to D-03 make `CBCONDET` unsafe until provenance and isolated verification exist. |
| Batch execution | `ORDAUDIT00/01/02.CLP` call matching RPGLE programs; fax/letter CL calls or submits RPG programs. | Named owner, isolated data, intended step order, transaction/commitment policy, idempotency/restart rule, job attributes, and containment/rollback point. | Job status/log, escape messages, changed-row counts by synthetic key, queue/spool status, and reconciliation totals. | `MONMSG CPF0000` in audit wrappers can hide failure (R-02). Do not execute the three steps as a guessed sequence. |
| Scheduling | `DLYFAXSHT.CLP` contains `SBMJOB ... JOBD(FAXJOBD) SCDTIME(200000)`; `FXS1C.CLP` submits to `QPGMR`. | Scheduler export, time zone/calendar, job description and queue definitions, parameter source, concurrency rule, owner, and missed/duplicate-run policy. | Scheduler event, submitted job ID, start/end status, job log, and downstream acknowledgement. | **Unknown:** source does not prove an active scheduler or that 20:00 is an approved production schedule. |
| Observation | `CUSMNU.CLP` exposes submitted jobs, `QSYSOPR`, writer, and output-queue views; programs send messages and create spool output. | Monitoring owner, message severity/retention, job correlation ID, queue thresholds, privacy-safe log/spool handling, and escalation route. | Escape/diagnostic messages, job status, queue depth, writer state, spool status, HTTP status, fallback count, and reconciliation metrics. | Broad message handling and migration fallback can hide failures. A queued spool file is not delivery acknowledgement. |
| Backup | Repository evidence identifies stateful PF families and temporary/spool artifacts but contains no backup commands or policy. | Data/object inventory, journal receivers, consistency group, retention/encryption policy, authorities, RPO/RTO, external-service and spool scope, and privacy approval. | Backup product/job completion, saved-object inventory, receiver continuity, immutable copy evidence, and restore-test record. | **Unknown:** no repository-backed backup policy exists. Do not invent save commands or assume all related files are captured atomically. |
| Rerun | `PUR01` mixes header update/write with multiple detail writes; audit programs mutate shared store/detail/balance data; SQL procedures change data. | Completion marker or reconciliation query, idempotency contract, transaction boundary, input identity, prior job/journal evidence, duplicate policy, and rollback owner. | Before/after counts and totals, duplicate-key/lock messages, completion state, and unchanged unrelated fixture rows. | R-01 and R-06 make blind rerun unsafe. Stop on ambiguous prior completion or missing journal/commit evidence. |
| Recovery | Source exposes independent header/detail deletes, direct mutations, temporary-file cleanup, and external queue handoffs. | Incident scope, active-object map, dependency graph, journal/constraint state, approved restore point, containment plan, privacy owner, and validated reconciliation. | Restored object/data identity, referential and financial reconciliation, job/message state, queue/spool disposition, and owner sign-off. | **Unknown:** there is no restore procedure, cascade contract, or proven transaction boundary. Recovery must be designed and rehearsed outside production before use. |

## Flow-specific preparation and containment

### Contract/order maintenance

- **Fact:** `WWCUSTS`/`WWCONHDR`/`WWCONDET` and `CBCUSTS`/`CBCONHDR`/`CBCONDET` are parallel source families over `CUSTS`, `CONHDR`, and `CONDET`.
- Before execution, resolve the called object, source member, library, generated DDS layouts, constraints/triggers, and commitment state.
- Success means only the intended synthetic key changed and header/detail reconciliation holds. Failure includes timeouts, unexpected header mutation, orphan detail, suppressed messages, or changes outside the fixture.
- Stop until D-01 through D-03 and H-01/H-02 are adjudicated for the active object.

### Order-audit mutation set

- **Fact:** `ORDAUDIT1`/`2` create or change store/detail/balance state; `ORDAUDIT0` changes it back in a different way. Their wrappers consume `CPF0000` without propagating status.
- Required evidence is an owner-approved intended sequence, isolated fixture, exact touched keys, commitment/journal behavior, restart semantics, and reconciliation query.
- Never infer that `00` is rollback for `01`/`02`, or that repeated execution is safe, from names alone.

### Fax, letter, and spool flows

- **Fact:** `DLYFAXSHT.CLP`, `FXS1C.CLP`, `FAXSHT.CLP`, and `WKCUSL.CLP` use `SBMJOB`, source/database overrides, temporary `QLETSRC`, `QSYSPRT`, `PRT02`/`PRT04`, and `FAXSTARPRT`.
- Validate source-member ownership, temporary-object cleanup, queue authority, secure-spool behavior, recipient derivation, external acknowledgement, retention, and duplicate-send prevention with synthetic recipients.
- Messages such as “queued” or “printed” are local program statements, not proof of external receipt.

### HTTP migration path

- **Fact:** the COBOL client calls Db2 HTTP and falls back to `XACBLTST`; the service optionally enforces `X-API-Key`. D-04 and D-05 show the checked-in client/service contract is not safe as a production cutover.
- Require TLS/certificate policy, secret provisioning, escaped serialization, timeout/retry ownership, synthetic tracing, and observable fallback before enabling a deployed path.
- Stop on silent fallback, plaintext transport, real customer payload capture, or disagreement between client and service authentication.

## Ownership and impact matrix

Named people and teams are **Unknown** because the repository records no authoritative ownership directory.

| Role | Accountable evidence and decisions | Impact if unresolved | Current named owner |
| --- | --- | --- | --- |
| Application maintenance | Active source variants, compile map, program signatures, defect repairs, characterization fixtures | Wrong member can be compiled or destructive source paths can remain active | Unknown |
| IBM i operations | Libraries, authorities, overrides, jobs/queues, journaling, backup, restore, job logs | Builds/runs cannot be reproduced; rerun or recovery can worsen an incident | Unknown |
| Data and privacy | Classification, masked profiles, retention/deletion, export/spool handling | Customer, contact, banking, tax, and commercial data may be exposed or mishandled | Unknown |
| Security and network | HTTP/TLS, secrets, Db2 HTTP, FAX/mail boundaries, service access | Silent fallback, interception, unauthorized access, or unusable integration | Unknown |
| Service owner | Business acceptance, schedules, RPO/RTO, escalation, reconciliation and delivery acknowledgement | Technical success may not equal business completion | Unknown |
| Modernization lead | Phase gates, dependency order, duplicated implementations, target contracts | Investment may decouple the wrong behavior or encode unknown rules | Unknown |

## Evidence capture template

For each approved operational exercise, record: environment and date; owner/approver; object/source/library identity; synthetic or masked input class; preconditions; exact bounded action; expected signals; actual signals; changed keys/counts; containment/rollback decision; sensitive-data handling; and links to retained job/compiler/restore evidence. Do not commit raw production logs, spool files, credentials, or row samples.
