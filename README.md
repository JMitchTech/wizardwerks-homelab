# 🧙 Wizardwerks Enterprise Labs — Home Lab

![Wizardwerks Banner](wizard_corp_banner.png)

---

## Overview

This repository documents the **Wizardwerks Enterprise Labs home lab** — a fully functional Windows enterprise environment built from the ground up to demonstrate real-world IT infrastructure capability.

This is not a tutorial project. This is a working environment — designed, deployed, and administered the same way it would be in a production business setting. Every service configured here reflects the kind of infrastructure that keeps organizations running.

---

## Network Topology

![Wizardwerks Network Diagram](wizardwerks_network_diagram.png)

---

## Current Infrastructure

| Component | Technology | Status |
|---|---|---|
| Hypervisor | Oracle VM VirtualBox 7.2.6 | ✅ Complete |
| Domain Controller | Windows Server 2022 — AD, DNS, DHCP, GPO, WSUS | ✅ Complete |
| File Server | Windows Server 2022 — NTFS, Shared Drives, Backup | ✅ Complete |
| Endpoint Simulation | Windows 10 Workstation VM — Domain + Hybrid Entra ID Joined | ✅ Complete |
| Network Firewall | pfSense CE — Firewall, Routing | 🔄 In Progress |
| Backup & DR | Windows Server Backup — Scheduled jobs, verified restore | ✅ Complete |
| Patch Management | WSUS — Windows Server Update Services, GPO deployed | ✅ Complete |
| Help Desk | Spiceworks Cloud — Full ticket lifecycle | ✅ Complete |
| Automation | PowerShell — User provisioning scripts | ✅ Complete |
| Hybrid Identity | Microsoft Entra ID Connect — On-prem AD synced to Entra ID | ✅ Complete |
| Cloud Platform | Microsoft 365 Business Premium — Exchange Online, licensed users | ✅ Complete |
| Identity Security | Conditional Access — MFA enforced all users | ✅ Complete |
| SSO | Hybrid Entra ID Join — AzureAdJoined + DomainJoined verified | ✅ Complete |
| MDM | Intune Auto Enrollment — Blocked by VirtualBox vTPM limitation | ⚠️ Documented |
| CIS Hardening | Security baselines — DC01 and FS01 | 📋 Planned |
| Attack & Defense | Kali Linux VM — Nmap, OpenVAS, simulated attacks | 📋 Planned |
| SIEM | Microsoft Sentinel — M365 data connectors, attack detection | 📋 Planned |
| Network Segmentation | pfSense VLANs and firewall rules | 📋 Planned |
| Log Management | Splunk Free — DC01/FS01 log ingestion, dashboards | 📋 Planned |
| ITSM | ServiceNow PDI — ITSM workflows linked to lab | 📋 Planned |

---

## PowerShell Automation

Two production-grade provisioning scripts handle the full user onboarding workflow:

### `NewUser.ps1` — Single User Provisioning
- Interactive prompts with full confirmation gate before any changes are made
- AD account creation, OU placement, security group assignment
- Home directory creation with scoped NTFS permissions
- H: drive mapping via AD user profile
- Try/Catch error handling with step-level failure reporting

### `BulkProvision.ps1` — CSV Bulk Provisioning
- Reads from a structured CSV file and processes any number of users
- Full provisioning workflow applied per user in sequence
- Real-time per-user SUCCESS / FAILED output during execution
- Final summary count on completion
- **Tested:** 6-user Justice League dataset — 6/6 SUCCESS ✅

---

## Active Directory Architecture

- **Domain:** CORP.local
- **UPN Suffix:** wizardwerks.onmicrosoft.com — added, all users updated
- **Organizational Units:** HR | IT | Sales | Corp Users | Workstations
- **Security Groups:** HR_Users | IT_Users | Sales_Users
- **Group Policy:** Drive mapping, WSUS, BitLocker, and MDM enrollment GPOs deployed and verified
- **RBAC:** Department shares accessible only to corresponding security groups
- **Home Directories:** Auto-provisioned per user via PowerShell, mapped to H: drive

---

## Hybrid Identity & Cloud Integration

The lab is fully integrated with Microsoft 365 Business Premium via Entra ID Connect:

- **Entra ID Connect** running on DC01 — continuous delta sync between on-prem AD and Entra ID
- **All AD users synced** to Entra ID with @wizardwerks.onmicrosoft.com UPNs
- **Exchange Online** active — all users have cloud mailboxes
- **Conditional Access** policy enforcing MFA across all users and resources
- **Hybrid Entra ID Join** — WORKSTATION01 confirmed AzureAdJoined: YES and DomainJoined: YES
- **SSO verified** — Clarissa Dane logged into portal.microsoft.com from WORKSTATION01 with MFA

### MDM Enrollment — Engineering Finding
Intune auto-enrollment is blocked on WORKSTATION01 by a VirtualBox virtual TPM limitation (Error 0x8018002a). The GPO, Intune scope, and user licensing are all correctly configured. Enterprise hypervisors with hardware TPM passthrough (Hyper-V, VMware ESXi) or physical hardware would resolve this. Documented as an environment constraint, not a configuration error.

---

## Roadmap

| Phase | Focus | Status |
|---|---|---|
| Week 1 | M365 Integration, Conditional Access, Hybrid Identity | ✅ Complete |
| Week 2 | Intune Compliance Policies, CIS Hardening | 🔄 Next |
| Week 3 | SQL Server Express, Kali Linux, Simulated Attack & Defense | 📋 Planned |
| Week 4 | Microsoft Sentinel, RADIUS/VPN, pfSense VLANs | 📋 Planned |
| Week 5 | Splunk, ServiceNow PDI, Full Integration | 📋 Planned |

---

## Documentation

Full technical documentation is included in this repository — covering every VM, every service, every configuration decision, and every command. Written to the standard of a real enterprise IT runbook.

📄 [`Wizardwerks_TechDoc_v3.pdf`](Wizardwerks_TechDoc_v3.pdf)

---

## Network Layout

| Host | IP | Role |
|---|---|---|
| DC01 | 192.168.1.10 (static) | Domain Controller |
| FS01 | 192.168.1.30 (static) | File Server |
| pfSense | 192.168.1.1 (gateway) | Firewall / Router |
| WORKSTATION01 | DHCP from DC01 | End User Simulation |

---

## About

**James Mitchell** — Systems Administrator  
Experienced in enterprise Windows infrastructure, Active Directory, Microsoft 365, hybrid cloud identity, PowerShell automation, network administration, and IT operations. Background in military IT (U.S. Army 10th Special Forces Group), public safety, and enterprise systems administration.

Building toward a Senior IT role — one documented, tested, production-grade lab component at a time.

---

*Small operation. Enterprise results.*

