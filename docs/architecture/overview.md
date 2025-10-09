# Architectural Overview

## Purpose and Scope
This document provides a comprehensive architectural overview of the CobolDemo CRM and order management system. It consolidates the structural, behavioral, and data perspectives captured throughout the SSADM documentation into a single view. The goal is to highlight what works well, expose architectural risks, and map the modernization opportunities that future teams can pursue.

## System Context
```mermaid
flowchart LR
    Customer((Customer))
    SalesClerk((Sales Clerk))
    CRM["CRM/Order Entry (IBM i)"]
    Finance((Finance Systems))
    Logistics((Logistics / Warehouse))
    Analytics((Analytics Platform))

    Customer -- phone/email --> SalesClerk
    SalesClerk -- orders/updates --> CRM
    CRM -- invoices/postings --> Finance
    CRM -- pick tickets/ship notices --> Logistics
    CRM -- nightly extracts --> Analytics
    %% Draw attention to the IBM i hub and human touchpoints.
    style CRM fill:#7B3B7B
    style SalesClerk fill:#3A6EA5
    style Customer fill:#2E8B57
    style Finance fill:#2B6777
    style Logistics fill:#3B6B6B
    style Analytics fill:#CC7722
```

### Strengths
- Clear separation between human actors and the IBM i core, reducing integration surface area.
- Finance and logistics integrations are handled through asynchronous batch jobs, lowering coupling.
- External analytics receives denormalized extracts, minimizing reporting load on the transactional database.

### Pain Points
- CRM remains a monolith with tightly bound COBOL modules and shared files, limiting independent deployment.
- Integrations depend on flat-file transfers without end-to-end monitoring, increasing operational risk.
- No direct customer self-service channel, forcing all interactions through sales clerks.

## Layered Architecture
```mermaid
flowchart TB
    UI["5250 UI / CL Menus"]
    App["COBOL Business Logic (QCBLSRC)"]
    Data["DB2 for i Physical Files (QDDSSRC)"]
    Batch["CL/RPG Batch Orchestration"]

    UI --> App
    App --> Data
    Batch --> App
    Batch --> Data
    %% Showcase each architectural layer distinctly.
    style UI fill:#3A6EA5
    style App fill:#7B3B7B
    style Data fill:#2B6777
    style Batch fill:#CC7722
```

**Positive Observations**
- Presentation logic is isolated within CL menus and 5250 screens, keeping COBOL programs focused on business rules.
- DB2 physical files are shared through well-understood DDS definitions, enabling consistent data validation.
- Batch orchestration provides a hook for nightly reconciliation and integration feeds.

**Areas of Concern**
- Batch orchestration triggers business programs via command-line interfaces, making dependency management implicit.
- DDS-defined schema lacks modern referential constraints, permitting data anomalies when jobs fail mid-flight.
- Presentation tier offers limited extensibility for modern UX requirements.

## Data Flow Diagrams

### Level 0 DFD
```mermaid
flowchart LR
    subgraph External Actors
        Customer
        FinanceSys[Finance]
        LogisticsSys[Logistics]
    end

    CRMSystem["CRM Core"]

    Customer -- order request --> CRMSystem
    CRMSystem -- confirmation --> Customer
    CRMSystem -- invoice batch --> FinanceSys
    CRMSystem -- shipment notice --> LogisticsSys
    %% Emphasize the CRM core and external boundaries.
    style CRMSystem fill:#7B3B7B
    style Customer fill:#2E8B57
    style FinanceSys fill:#2B6777
    style LogisticsSys fill:#3B6B6B
```

### Level 1 DFD – Order Lifecycle
```mermaid
flowchart TB
    subgraph CRM
        Entry["Order Entry (ZBCONHDR)"]
        Validation["Line Validation (ZBCONDET)"]
        CustomerFile["Customer Maintenance (ZBCUSTS)"]
        Fulfillment["Fulfillment Prep"]
        Billing["Billing Export"]
    end

    SalesClerk --> Entry
    Entry --> Validation
    Validation --> Fulfillment
    Fulfillment --> Billing
    Billing --> Finance
    Fulfillment --> Logistics
    CustomerFile --> Entry
    CustomerFile --> Validation
    %% Highlight handoffs across the order lifecycle.
    style Entry fill:#7B3B7B
    style Validation fill:#3A6EA5
    style CustomerFile fill:#2B6777
    style Fulfillment fill:#CC7722
    style Billing fill:#B23A48
```

## Module Interaction Overview
```mermaid
sequenceDiagram
    participant Clerk as Sales Clerk
    participant Entry as ZBCONHDR
    participant Lines as ZBCONDET
    participant Cust as ZBCUSTS
    participant Batch as CL Batch Jobs
    participant Finance as Finance

    %% Use light overlays to spotlight interactive vs. batch-driven exchanges.
    rect rgba(123,59,123,0.1)
    Clerk->>Entry: Create/Amend order header
    Entry->>Cust: Retrieve customer status
    Entry->>Lines: Initialize line validation
    Lines->>Cust: Check credit and terms
    Lines->>Entry: Update header totals
    end
    rect rgba(178,58,72,0.1)
    Batch-->>Lines: Nightly repricing
    Batch-->>Finance: Post invoice file
    end
```

### Highlights
- Header, detail, and customer modules communicate synchronously during interactive sessions, sharing in-memory state via parameter lists.
- Batch jobs call the same modules using command wrappers, promoting reuse of business rules.

### Risks
- Parameter passing relies on positional fields; errors are hard to detect without automated tests.
- COBOL programs share global files, so one failing job may lock others out.

## Entity Relationship Diagram
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ ORDERLINE : contains
    CUSTOMER ||--o{ ADDRESS : uses
    PRODUCT ||--o{ ORDERLINE : fulfills
    PRODUCT ||--o{ PRICE : references
    ORDER ||--o{ PAYMENT : settles
    %% Color the anchor entities for rapid scanning.
    style CUSTOMER fill:#7B3B7B
    style ORDER fill:#3A6EA5
    style ORDERLINE fill:#CC7722
    style PRODUCT fill:#2B6777
    style PAYMENT fill:#B23A48
```

**Strengths**
- Core entities (Customer, Order, Order Line) follow standard CRM patterns, easing data warehousing.
- Product and Price separation allows for future catalog integration.

**Weaknesses**
- Missing referential integrity enforcement at the database level.
- Payment records are loosely coupled to orders, making reconciliation scripts necessary.

## Technical Debt Inventory
- **Implicit Data Contracts:** Flat-file exchanges with finance/logistics lack schema versioning. Consider migrating to APIs or at least adding validation steps.
- **Batch Coupling:** Business logic executed via CL commands complicates dependency tracing; introducing a scheduler metadata catalog would improve observability.
- **Testing Gap:** Manual testing dominates. Establishing automated regression tests around ZBCONHDR and ZBCONDET would de-risk modernization.
- **Modernization Opportunity:** Encapsulate COBOL modules behind service APIs to expose self-service functionality without rewriting the core immediately.

## Recommended Next Steps
1. Introduce referential constraints and audit triggers in DB2 to safeguard key relationships.
2. Wrap nightly batch exports in monitored jobs with retry logic and alerting.
3. Pilot an API façade that reuses existing COBOL programs via stored procedures to enable external integrations.
4. Develop a customer portal prototype that consumes the new API layer, reducing manual load on sales clerks.
5. Document configuration and deployment steps for batch jobs to streamline operations handoffs.

