# TPM / TRM / Technical Debt

## What each thing is

### TPM — Technology Portfolio Management
"What is actually in use."

- An inventory of technologies (software + hardware) discovered in use.
- Data sources: Discovery, Service Mapping, SAM, HAM.
- Linked to Application Services and Business Applications.
- Computes risk from lifecycle (EoS / EoL dates).

### TRM — Technology Reference Model
"What is allowed to be used."

- Defines approved and unapproved technologies.
- Holds standards, categories, and lifecycle guidance.
- The basis for governance and compliance.
- Compared against TPM to generate debt.

### Technical Debt
"The gap between reality and the standard."

- **Level 1** — a discovered technology (TPM) that does **not exist** in the TRM catalog.
- **Level 2** — a technology that exists in the TRM but the **specific version is unapproved**, or the **lifecycle has already expired**.

## Data flow (typical scheduled jobs)

```
1. Discovery (continuous)        → populates servers, DBs in the CMDB
2. SAM (continuous)              → populates software installs + product lifecycle
3. TPM discovery job (scheduled) → reads service↔CI associations + software installs + lifecycle
                                   → writes the TPM technology-lifecycle records
4. TPM risk job (scheduled)      → computes a risk score per technology / BA
5. TRM job (scheduled)           → compares TPM against the TRM standards products
                                   → writes Technical Debts into the EA Workspace
```

## Where the debt shows up

- EA Workspace → Technology Portfolio module.
- Dedicated dashboards (if configured).
- Drill-down by Business Application → the list of debts for that application.

## Worked examples (generic)

### "Unapproved" example
- BA: an analytics suite
- Service: analytics suite (PROD)
- CI: Windows Server, an older SQL Server version
- TPM lifecycle: that SQL Server version is past End-of-Support
- TRM: SQL Server is in the catalog, but this version is unapproved
- **Result: Technical Debt Level 2** (unapproved version / expired lifecycle)

### "Approved" example
- BA: a messaging platform
- Service: messaging platform (PROD)
- CI: Windows Server (a supported build)
- TPM lifecycle: the OS build is within its support window
- TRM: that OS build is approved
- **Result: no technical debt**

## Prerequisites for TPM/TRM to work well

1. Application Services exist and are related to infrastructure via `svc_ci_assoc`.
2. SAM is discovering software and assigning product + version correctly.
3. The TRM catalog is populated with the organization's approved products.
4. The TPM/TRM jobs are scheduled and running.

If any of these is missing, the Technical-Debt analysis is incomplete.

## Response format when asked about Technical Debt

```
Technical Debt on [BA/Service]: [summary]
Level: 1 or 2
Cause:
- [technology X version Y]
- [lifecycle: EoS YYYY-MM-DD]

Remediation options:
1. [upgrade to approved version Z]
2. [replace with a TRM-approved alternative: W]
3. [accept the risk + record an exception in the TRM]

Owner to route to: [app owner + EA team]
```

## Link to planned disposition

Technical Debt feeds planned-disposition decisions on the Business Application:
- **Invest** — approved technology, healthy lifecycle, growing use.
- **Sustain** — fine for now, watch the End-of-Support date.
- **Retire** — high debt + no upgrade path → a retirement candidate.
