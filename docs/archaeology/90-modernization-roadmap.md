# Risk- and Dependency-Ordered Rescue Roadmap

## Strategy

Modernization starts by making the current system observable, reproducible, and safe enough to change. File age, language, and source count do not determine priority. The controlling dependencies are active-object truth, record contracts, destructive-flow characterization, recovery evidence, and business acceptance.

This roadmap does not recommend a rewrite. Replacement becomes a decision option only after measured behavior, ownership, migration boundaries, and operating cost are known. Each phase can stop without committing the organization to the next architecture.

## Roadmap

| Phase | Prerequisites | Deliverables and evidence | Risk reduced | Exit criteria | Stop conditions |
| --- | --- | --- | --- | --- | --- |
| 0. Assign ownership and protect evidence | Sponsor authorizes read-only discovery and privacy-safe handling | Named application, IBM i operations, data/privacy, security/network, service, and modernization owners; evidence repository; masking/retention rules; incident escalation | Unowned decisions, unsafe evidence capture, unsupported compliance claims | Every later gate has an accountable approver and approved evidence-handling path | Stop if production access or personal-data capture lacks authority |
| 1. Resolve runtime and build truth | Phase 0; read-only IBM i access | Active object/source/library inventory; command/menu/caller map; compiler listings/options; DDS-generated layouts; bind/object references; scheduler/job/queue/override export; tracked reproducible compile manifest | R-07, R-08, H-01, active-variant and build ambiguity | One representative environment can reproduce objects with traceable source and no filename-based selection | Stop on unexplained object/source mismatch or missing target-library authority |
| 2. Establish characterization and data-safety seams | Phase 1 object and layout truth | Isolated libraries; synthetic fixtures; record-level snapshots; masked aggregate profiles; tests for D-01-D-05, R-01-R-06, report calculations, statuses, encoding, constraints, and fallback; privacy review | Regression blindness, layout/CCSID uncertainty, unsafe production experimentation | Critical flows have repeatable expected outcomes and no real customer values in fixtures | Stop if isolation, rollback, generated formats, or acceptance rules are absent |
| 3. Verify and stabilize confirmed defects | Phase 2 fixtures and active-object proof | Adjudicate D-01-D-05 against active objects; repair D-01-D-03 as one contract-detail boundary; align HTTP auth/serialization; define wrapper failure propagation; capture before/after evidence | Operator hangs, wrong-file mutation, invalid status acceptance, unusable/unsafe migration client | D findings pass characterization; source and deployed objects agree; no confirmed defect is promoted to incident without evidence | Stop if only one duplicate variant is changed or runtime reachability remains unresolved |
| 4. Define transaction, observability, and recovery contracts | Stabilized critical paths; operations owner | Commitment/journal inventory; caller transaction ownership; idempotency/restart rules; correlated job/message/fallback telemetry; backup scope; restore rehearsal; RPO/RTO and reconciliation runbooks | R-01-R-04, R-06, silent partial success, blind rerun/recovery | Fault injection yields visible failure; approved rerun decision; restore exercise meets reconciliation and privacy criteria | Stop production rerun/cutover if prior completion, journal position, or delivery acknowledgement is ambiguous |
| 5. Decouple domain and orchestration boundaries | Phases 1-4; stable characterization | Canonical contract/customer/inventory/transaction schemas; generated-layout adapters; explicit service interfaces; scheduler/orchestration wrappers with status contracts; duplicate-variant retirement plan | DDS/generated coupling, shared-data ambiguity, message/queue hiding, variant drift | Each seam preserves characterized behavior, has one owner, and can roll back independently | Stop if a seam encodes unknown cascade, status, monetary, CCSID, or retry policy |
| 6. Incrementally modernize proven seams | Measured service levels and phase-5 contracts | Small replacements behind observable adapters; parallel comparison; migration/rollback plan; cost, reliability, security, and operability measures | Technology constraints without discarding proven behavior | Each increment improves agreed measures and can be reversed without data loss | Stop or revert on reconciliation drift, fallback growth, operational burden, or weaker controls |
| 7. Reassess end state | Evidence from incremental delivery | Option analysis: retain, refactor, replatform, replace components, or—only with evidence—broader rewrite; dependency/cost/risk model and decommission controls | Evidence-free strategic commitment | Decision is supported by measured outcomes, ownership, migration completeness, archive/retention, and recovery capability | Do not select a rewrite because of language age, file count, or documentation volume |

## Finding-to-phase traceability

| Evidence set | First controlling phase | Required disposition |
| --- | --- | --- |
| D-01 to D-03 | 1-3 | Prove active `CBCONDET`; characterize and repair validation/update/delete together |
| D-04 and D-05 | 2-3 | Align authentication and serializer contract; expose fallback; use synthetic transport fixtures |
| R-01 to R-03 | 2-4 | Establish transaction, referential, failure propagation, rerun, and recovery behavior |
| R-04 | 0, 2-4 | Assign security/service ownership; prove TLS, secrets, telemetry, and delivery/fallback semantics |
| R-05 and H-03/H-05 | 1-2 | Generate compiler-backed layouts and CCSID byte/character contracts before schema/API design |
| R-06 and H-06 | 1, 2, 4 | Prove deployment/callers and caller-owned transaction/retry behavior for SQL mutations |
| R-07 and H-01 | 1, 3, 5 | Resolve object provenance, repair all active copies, then retire duplicate authority |
| R-08 | 1-4 | Make compile, characterization, quality, and recovery evidence reproducible |
| H-02 and H-04 | 2-4 | Resolve constraints/cascades and response parsing before deletion recovery or HTTP cutover |

## Highest-value next investigations

1. **Active `CBCONDET` provenance:** obtain object description, source member/timestamp, library resolution, and caller references. This gates safe work on D-01 through D-03 and R-07.
2. **Generated record and CCSID contracts:** capture compile listings, DDS-generated layouts, field offsets/level identifiers, and byte traces for `CUSTS`, `CUSFL3`, `CONDET(NW)`, and the HTTP client. This gates test fixtures and service schemas.
3. **Transaction and referential inventory:** inspect constraints, triggers, commitment control, journals, and caller ownership for `CONHDR`/`CONDET`, `PUR01`, `ORDAUDIT*`, and SQL procedures. This gates repair, rerun, and recovery.
4. **Scheduler and operations export:** identify active jobs, job descriptions/queues, overrides, message handling, spool destinations, and owners. This turns source clues into an actual operating model.
5. **Privacy-safe characterization harness:** build synthetic contract/customer/inventory and HTTP fixtures with record-level comparisons, masked aggregate-only profiling, and fault injection. This supplies the proof surface for stabilization.
6. **Backup and restore exercise:** establish scope, receiver continuity, RPO/RTO, dependencies, and reconciliation in a non-production environment before publishing a recovery runbook.
7. **Business rule confirmation:** have service/data owners adjudicate statuses, monetary reconciliation, cascade behavior, delivery acknowledgement, and acceptance outcomes using source evidence plus masked aggregates.

## Investment guardrails

- Fund evidence that unlocks several risks before isolated technology replacement.
- Repair confirmed destructive behavior before extracting it into a new service.
- Require a rollback path and observable comparison for every modernization increment.
- Preserve stable D/R/H identifiers until evidence explicitly closes or supersedes them.
- Treat generated documentation and graph output as navigation; base contracts on primary source plus compile/runtime proof.
- Revisit this roadmap when a phase produces contradictory evidence. Dependency order is evidence-driven, not a fixed multi-year program.
