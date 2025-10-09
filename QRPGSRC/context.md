# QRPGSRC Context (Fixed-Format RPG)

> 📘 **Per-member docs:** Each source member now includes a `<member>.<ext>.md` companion with dependency notes and full listings. Use these guides alongside this context during modernization.

This directory collects fixed-format RPG (RPG/400) members used for legacy batch processes, printing, and utility routines. They predate RPGLE modules in [`QRPGLESRC`](../QRPGLESRC/context.md) but still underpin several CL commands and COBOL integrations.

## Program Clusters
* **Customer/Contact Reports:** `CB903R`, `CB905R`, `CB906R`, `CB906R@BK`, `CB907R`, `CON001.RPG`, `GCNTAC1.RPG`, `GCUST1.RPG` produce listings and exports for customer and contact data, often triggered by CL programs in [`QCLSRC`](../QCLSRC/context.md).
* **Contract Fix Utilities:** `CONFIX1.RPG`, `CONFIX2.RPG`, `PROFIX1.RPG`, `PROFIX.LF` companion modules adjust contract or project data after migrations.
* **Order Entry (`OE00*.RPG`):** Legacy order entry batch routines corresponding to DDS display/printer files in [`QDDSSRC`](../QDDSSRC/context.md).
* **Generalized File Generators:** `GENFILES*.RPG` routines create/refresh working files, likely invoked before running reports.
* **Security and Profile:** `SEC1.RPG`, `SECFO.RPG`, `SECFCPY.RPG` align with the security CL utilities and `SECF` DDS definitions.
* **FAX/Email Handling:** `FAXERR*`, `FAXNOS1`, `FAXSHT1`, `SNDEMAIL.RPG` coordinate outbound communications and error reporting.
* **Miscellaneous Utilities:** `CUSCPY.RPG` (data copy), `PUR01.RPG` (procurement), `XRATE_EURO.RPG` (currency conversion), `RPG36.RPG36` (conversion sample), `NEWOPS.RPG` (operations scripts).

## Positive Findings
* Members encapsulate discrete batch/report tasks and are often triggered via CL commands, keeping entry points clear.
* Some programs have backup versions (`CB906R@BK`), indicating safe experimentation practices.

## Negative Findings / Risks
* Fixed-format RPG is hard to maintain; logic is positional and lacks modern structuring.
* Minimal inline comments make business rules difficult to extract.
* Many programs likely overlap with the more modern RPGLE equivalents, increasing maintenance burden.

## Entanglement & Migration Notes
* Programs rely on DDS record formats and file layouts defined in [`QDDSSRC`](../QDDSSRC/context.md). They are moderately coupled: many perform sequential file reads and prints without complex UI interactions.
* Least entangled modules include currency conversion (`XRATE_EURO.RPG`) and standalone generators (`GENFILES4.RPG`), which can be rewritten as external services or scripts.

### Migration Suggestions
1. **Convert to Free-Format RPGLE or SQLRPGLE:** Prioritize high-use programs (e.g., `CB906R`) to improve maintainability and integrate with new services.
2. **Externalize reporting:** Offload report generation to BI tools using data exported via [`QSQLPRC`](../QSQLPRC/context.md) procedures, reducing reliance on printer files.
3. **Document business rules:** Use the new `context.md` files as anchors for capturing logic summaries whenever code is touched, easing future refactors.
