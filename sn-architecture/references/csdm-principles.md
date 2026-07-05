# CSDM Principles — the working subset

The Common Service Data Model (CSDM) is ServiceNow's prescribed way to structure the CMDB so that every product (ITSM, ITOM, SPM/APM, SecOps, etc.) reads and writes the same data consistently. This file condenses the principles you actually apply during modeling. For the full, authoritative treatment, refer to the official ServiceNow CSDM white paper and product documentation for the release you are on.

## The four CSDM domains

1. **Foundation** — the business scaffolding: value streams, business processes, contracts, products, CMDB groups, software bill of materials. Rarely touched early.
2. **Design** — what exists conceptually: **Business Capabilities**, **Business Applications**, Information Objects. "What we have, in the abstract."
3. **Build** — what things are made of: software and hardware **Product Models**. "What we build with."
4. **Manage** — what actually operates day to day: **Service Offerings**, **Application Services / Service Instances**, Technical Services. "What runs in production."

For most CMDB/APM work the action is in **Design** (Capabilities and Business Applications) and **Manage** (Application Services).

## Key principles (and why they matter)

### P1. The Application Service is where operations happen

An Application Service (frequently instantiated per environment as a "Service Instance"):

- represents a concrete, observable deployment;
- carries relationships to real infrastructure (servers, databases, middleware);
- can have its own lifecycle (operational, up/down, monitored, retired);
- is the target of Incident, Change, Problem, Request, and Service Mapping.

Practical test: if something has no separate PROD/UAT/DEV, it is under-modeled. If an Incident points at a Business Application instead of an Application Service, it is mis-modeled.

### P2. The Business Application is abstract

A Business Application:

- has no IP address, no hostname, no up/down state;
- has a **business lifecycle** (Invest / Sustain / Retire) — its planned disposition;
- carries the portfolio, the cost, and the ownership;
- links to a Business Capability (the "what for").

It is the input to demand, enhancement, portfolio (SPM/APM) and EA work. It never appears on an Incident.

### P3. Capability before Application

A Business Capability describes **what the business does**. An Application describes **how** that "what" is delivered. One Capability can be supported by several Business Applications; one Business Application typically delivers several Capabilities. If the Capability doesn't exist yet, create it first — foundations before services.

### P4. The Product Model is the truth about physical software

Concrete software (a specific OS build, a database engine version, a runtime) lives as a **Product Model**, normally auto-created by Software Asset Management (SAM). The Product Model connects to lifecycle data (end-of-support / end-of-life) and to the TRM (approved or not). **Never confuse a Product Model with a Business Application** — that confusion is the classic root cause of a broken CMDB.

### P5. Lifecycle everywhere

Every CSDM entity — Capability, Business Application, Application Service, Product, Contract — carries a lifecycle. That is what makes Technical Debt and planned-disposition reporting possible.

### P6. Technical Debt = TPM − TRM

Technical Debt is **derived, not entered by hand**:

- **Level 1** — a discovered technology (TPM) that does **not exist** in the TRM catalog.
- **Level 2** — a technology that is in the TRM, but the **version is unapproved** or its **lifecycle has expired**.

A scheduled job compares the discovered portfolio (TPM) against the reference model (TRM) and writes the debt records.

## How to sequence a CSDM rollout (typical maturity path)

1. **Foundations** — learn/define the taxonomy, add missing Capabilities, fix metadata, add missing Business Applications.
2. **Classify** — Business Application vs Tool vs Software; move records off the wrong class; update impacted modules (Demand, Enhancement).
3. **Normalize** — create Application Services per environment, transfer CIs off Product Models, recertify Capabilities and Business Applications, set planned disposition, start monitoring Technical Debt.
4. **Sustain / Accelerate** — continuous recertification, debt management, business-as-usual, and later domains such as Information Objects.

## When to cite CSDM in a discussion

- On an ambiguous classification — cite the principle (P1, P2, P4).
- When an owner resists a change — external authority (the model) helps.
- In modeling reviews — it aligns everyone's vocabulary. Suggested phrasing: "CSDM, [domain] domain, principle: [name]."
