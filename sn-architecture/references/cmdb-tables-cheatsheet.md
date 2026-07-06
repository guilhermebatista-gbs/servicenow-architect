# CMDB Tables Cheatsheet — which table is the right home

> **Principle:** CSDM assigns a CI to a table by its **nature**, not by how it happens to be used. "What the business does" → Capability. "What the company offers users" → Business Application. "Where it concretely runs" → Application Service. "What bricks it's built from" → an infrastructure CI.

## Core metamodel tables

| Table | Use it for | Do **not** use it for |
|---|---|---|
| `cmdb_ci_business_capability` | A business capability (e.g. Payments, Content Management, Portfolio Management) | An application or a tool |
| `cmdb_ci_business_app` | A logical, end-user-facing solution with an owner and lifecycle, used in planning | An internal module with no owner of its own; a background SaaS not directly consumed by the business |
| `cmdb_ci_service_auto` | **Application Service** — the base class. OOB home for manually created/maintained application services (PROD/UAT/DEV of a BA) with entry point, servers, DBs | A proxy for a BA; a "catch-all" multi-environment service |
| `cmdb_ci_service_discovered` | **Mapped Application Service** (extends `_auto`) — services created/maintained by Service Mapping top-down discovery. Note: per CSDM 3.0-era guidance many orgs also standardized *manual* application services here (the name predates CSDM) — legitimate, but current guidance discourages manual maintenance on this class | A second, parallel home when your org already standardized on another class |
| `cmdb_ci_service_calculated` | **Calculated Application Service** (extends `_discovered`) — populated dynamically (tags / CMDB relationships) | Manually curated services |

> **Which Application Service class?** All three extend `cmdb_ci_service`, and instances differ in which one they standardized on. Check what your instance already uses (`cmdb_ci_service_auto.list` vs `cmdb_ci_service_discovered.list`) and stay consistent with it — consistency beats purism here. What is *always* wrong: mixing environments in one service, or using any of these as a proxy for the Business Application.

## Infrastructure CIs

| Table | Covers | Populated by |
|---|---|---|
| `cmdb_ci_server` (parent) | Any server | Discovery |
| `cmdb_ci_win_server` | Windows Server | Discovery |
| `cmdb_ci_linux_server` | Linux Server | Discovery |
| `cmdb_ci_aix_server`, `cmdb_ci_solaris_server` | Unix | Discovery |
| `cmdb_ci_vm_instance`, `cmdb_ci_vmware_instance`, `cmdb_ci_cloud_*` | Virtualization / Cloud | Discovery / Cloud Discovery |
| `cmdb_ci_db_instance` (parent) | Any DB instance | Discovery |
| `cmdb_ci_db_mssql_instance` | SQL Server | Discovery |
| `cmdb_ci_db_oracle_instance` | Oracle | Discovery |
| `cmdb_ci_appl_*` | Specific runtimes/middleware (Tomcat, IIS, WebLogic, Java, .NET) | Discovery / Service Mapping |

## Software / Product Models

| Table | Covers | Critical note |
|---|---|---|
| `cmdb_software_product_model` | A Product Model — "Windows Server 2022", "SQL Server 2019", "Java 8" | **Auto-created by SAM.** Do NOT use as the home of a Business Application. Do NOT create manually as a BA substitute. |
| `cmdb_sam_sw_install` | A software install found on a server | Populated by SAM. Feeds TPM. |
| Software product lifecycle table | End-of-Support / End-of-Life dates per product+version | Source for the TPM lifecycle |

## TPM / TRM (Technology Portfolio / Reference Model)

| Table | Covers | Populated by |
|---|---|---|
| TPM technology-lifecycle table | Discovered technology — app + server + software + version + EoS/EoL | A scheduled "populate TPM" job |
| TRM standards-product table | An approved/unapproved technology | Maintained manually by the EA team |
| (EA Workspace — Technical Debts) | Level 1 and Level 2 debts | A scheduled "populate TRM debts" job |

> The exact TPM/TRM class names are often scoped-app tables that vary between instances. Confirm in the dictionary; do not copy a name from another environment.

## Associations

| Table | Covers | Note |
|---|---|---|
| `svc_ci_assoc` | Application Service ↔ CI | Populated by Service Mapping (auto) or manually. **With no rows here, the service is hollow** and never appears in the dependency graph. |
| `cmdb_rel_ci` (fallback) | Any CI↔CI relationship outside the service map | Use when `svc_ci_assoc` doesn't apply (e.g. a direct CI↔CI link with no service in between). |

## Other tables you'll meet

| Table | Covers |
|---|---|
| `cmdb_ci_hardware` | Physical hardware as a **CI** (parent of `cmdb_ci_computer` → `cmdb_ci_server`) — the operational side |
| `alm_hardware` | The hardware **asset** record (financial/lifecycle side, 1:1 with the CI) — this is what HAM manages |
| `cmdb_ci_ip_network` | Networks |
| `cmdb_ci_load_balancer` | Load balancers — essential for Service Mapping entry points |
| `cmdb_ci_endpoint` | Endpoints (URL, DNS, IP:port) used as an entry point |
| IdP / SSO provider | No universal OOB class — often modeled as a custom class, an `cmdb_ci_appl_*` subclass, or just relationships to the IdP's own CIs. Verify in the instance dictionary before naming a table |

## Quick "which table?" heuristic

1. A business capability? → `cmdb_ci_business_capability`
2. An application the business "buys and uses"? → `cmdb_ci_business_app`
3. A specific environment of that application (PROD/UAT)? → an Application Service class: `cmdb_ci_service_auto` OOB for manual; `cmdb_ci_service_discovered` if Service Mapping populates it or your org standardized there (see the note above)
4. A piece of infrastructure (server, DB, middleware)? → the matching `cmdb_ci_*` subclass
5. Software installed on a server? → `cmdb_sam_sw_install` (SAM) — or the legacy `cmdb_software_instance` on pre-SAM instances (do not create a BA!)
6. A product/version as a catalog abstraction? → `cmdb_software_product_model`
7. A technology approved by the EA team? → the TRM standards-product table

If unsure of the exact infrastructure subclass, flag it: "verify the subclass in the instance dictionary — it can vary if the class model was customized."
