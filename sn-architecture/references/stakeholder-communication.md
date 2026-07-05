# Stakeholder Communication — email, agenda, checklist templates

Base tone: short, direct, actionable, polite. Application and infrastructure owners are busy — respect their time. Prefer asynchronous writing (an email with a numbered list) before asking for a meeting. Reserve a 30-minute call for when async doesn't work. Fill the placeholders in `<...>` and delete this line.

## 1. Short email asking for information (async)

Use when you need an owner or vendor to send environment, server, DB, or URL details.

```
Subject: [CMDB/APM] <App Name> — quick info on environments & infrastructure

Hi <first name>,

I'm helping the Enterprise Architecture team map <App Name> in ServiceNow (CMDB + APM).
To keep this quick, could you confirm in writing:

1. Environments in use (PROD / UAT / DEV / other)
2. Hosting model per environment (On-Prem / AWS / Azure / GCP / SaaS)
3. Servers and databases per environment (hostname + OS + DB instance name)
4. Entry point per environment (URL / load balancer path)
5. SSO / IdP provider and key integrations

If writing it all up is too much, I can run a focused 30-minute call — let me know.

Thanks
```

### SaaS-vendor variant

```
Subject: [CMDB/APM] <App Name> — quick SaaS intake

Hi <first name>,

For our ServiceNow CMDB mapping, since <App Name> is SaaS, we just need:

1. Production URL (and any UAT/test URL)
2. SSO method (Okta / ADFS / Entra ID / other)
3. Integrations with our systems (APIs, data feeds)
4. Confirmation that there are no internally hosted servers or databases involved
5. Vendor support contact in case of an incident

Thanks
```

## 2. 30-minute meeting agenda

Use when async collection stalled or there's structural ambiguity.

```
Subject: [CMDB/APM] 30-min mapping session — <App Name>

Hi <name(s)>,

Proposing a focused 30-minute session to wrap up the CMDB mapping for <App Name>.

Agenda (15 + 10 + 5):
- 0–15 min: Environments, hosting, entry points (URL/LB)
  → goal: list PROD/UAT/DEV with each URL and hosting model
- 15–25 min: Servers and databases per environment
  → goal: hostname + OS + DB instance name per env
- 25–30 min: Integrations, SSO, support group
  → goal: confirm ownership and the integration map

I'll bring a draft mapping sheet. Please forward to anyone on your team who has the infra details.

Proposed slots: <2–3 time options>

Thanks
```

## 3. Per-application intake checklist

Attach to a request email or use when opening an application record in your mapping sheet.

```
## <App Name> — CMDB mapping checklist

Ownership
- [ ] Business owner (name + team)
- [ ] IT application owner (name + team)
- [ ] Support group (for Incidents/Changes)

Application model
- [ ] Classification (Business App / Tool / Software / Dependency)
- [ ] Business Capability it supports (parent)
- [ ] Lifecycle status (Invest / Sustain / Retire)
- [ ] Deployment model (On-Prem / Cloud / SaaS / Hybrid)

Environments (one block per env — PROD/UAT/DEV)
- [ ] Environment name
- [ ] Hosting type (On-Prem / AWS / Azure / GCP / SaaS)
- [ ] Entry point URL / LB path
- [ ] SSO / IdP provider
- [ ] Servers (hostname + OS)
- [ ] Databases (hostname + DB name)
- [ ] Support group
- [ ] Monitoring link

Integrations
- [ ] Inbound (who calls this app)
- [ ] Outbound (who this app calls)
- [ ] Type (REST / SOAP / File / MQ / direct DB)

Tech stack (for Technical-Debt detection)
- [ ] OS versions
- [ ] DB engine + version
- [ ] Middleware / runtimes (Java, .NET, Node, etc.)

Other
- [ ] Runbook / knowledge article
- [ ] DR tier / criticality
- [ ] Known issues or upcoming changes
```

## 4. Escalation note (ambiguous classification)

```
Subject: [CMDB/APM] need a decision on <App Name> classification

Hi <decision-maker>,

Quick ask — on <App Name>, I'm torn between modeling it as:
(A) <option A — e.g. Business Application (SaaS)>
(B) <option B — e.g. Dependency of <parent BA>>

Context:
- <1-line note on ownership/lifecycle>
- <1-line note on usage in Demand/Enhancement>

I'm leaning <A or B> because <one-line rationale>. Can we go with that, or would you like to weigh in?

Thanks
```

## Tone rules

- Keep it short; always offer an alternative (email **or** call).
- Don't use ServiceNow jargon with an external vendor; it's fine with internal stakeholders who already live in APM/CMDB.
- Keep deadlines soft — "if you have 10 minutes this week" rather than "by Friday."
- Never include real personal names, emails, or organization-identifying details in a reusable template — fill them in per use.
