# Service Mapping Readiness Checklist

For an Application Service to be worth mapping, it needs the items below. Without them the service is hollow and the dependency graph stays empty.

## Checklist per Application Service

### Identification
- [ ] Name (e.g. "Payments PROD", "HR Portal UAT")
- [ ] Parent Business Application (1:N)
- [ ] Environment (PROD / UAT / DEV / STG / TEST)
- [ ] Hosting type (On-Prem / Cloud-AWS / Cloud-Azure / Cloud-GCP / SaaS)
- [ ] Region / location (if applicable)

### Support
- [ ] Support group (assignment group for Incident/Change)
- [ ] Change approval group (if different)

### Entry point (critical for Service Mapping)
- [ ] URL / DNS name
- [ ] Load balancer VIP + path (if applicable)
- [ ] Port (80/443/other)
- [ ] Protocol (HTTPS, HTTP, other)
- [ ] Authentication method (SSO/IdP, basic, API key, none)

### Supporting infrastructure (via `svc_ci_assoc`)
- [ ] Web server(s) — hostname(s) + OS
- [ ] App server(s) / runtime(s) — hostname(s) + software stack
- [ ] DB instance(s) — hostname + DB name
- [ ] Middleware (queue, cache, search — if applicable)
- [ ] Storage (NFS, object store — if applicable)

### Integrations
- [ ] Inbound integrations (who calls this service)
- [ ] Outbound integrations (who this service calls)
- [ ] Type (REST, SOAP, file transfer, MQ, direct DB, other)
- [ ] SSO / IdP provider (Okta, ADFS, Entra ID/Azure AD, custom)

### Operations
- [ ] Monitoring link (APM/observability tool)
- [ ] Runbook / knowledge article
- [ ] Backup schedule owner
- [ ] DR tier

## Technical prerequisites for automatic discovery

- **MID Server** with credentials that can reach the entry point.
- **Entry point** registered in `cmdb_ci_endpoint` or configured in the Discovery pattern.
- **Discovery credentials** (SSH, WMI, SNMP) for the supporting servers.
- **An applicable pattern** (an out-of-the-box pattern, or a custom one for non-standard stacks).

## Output format for a readiness assessment

```
Service: <name>
Readiness: Ready / Partial / Not ready

Has:
- [what it has]

Missing:
- [what's missing, prioritized]

Top unblocker: <the highest-impact action to move it forward>
```

## Rules of thumb

1. **No reliable entry point → don't invoke Service Mapping yet.** Prioritize collecting the URL/LB first.
2. **SaaS still gets a service record.** Record the external entry point, SSO, and integrations on the service — but don't point Service Mapping discovery at a vendor URL you don't control (no credentials, no infrastructure to walk). Availability checks on external endpoints belong to monitoring tooling, not to Service Mapping.
3. **If the owner doesn't know the load balancer, escalate to the network/infrastructure team.** Service Mapping needs the correct path on the LB, not just the external DNS name.
4. **Authentication affects discovery.** If SSO enforces MFA, mapping can't authenticate — record it as a limitation and consider a HEAD-only endpoint check instead.
