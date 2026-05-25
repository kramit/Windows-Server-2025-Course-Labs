# Windows Server 2025 Course Labs

A comprehensive collection of **17 hands-on, beginner-friendly labs** for the Windows Server 2025 instructor-led training course. Each lab provides step-by-step guidance with no assumptions about prior knowledge.

## Overview

This repository contains all practical labs for the **3-day Windows Server 2025 professional training program**. Labs are designed for IT professionals with basic Windows knowledge who are new to Windows Server administration.

## Lab Contents

| # | Lab Title | Chapter | Topics |
|---|-----------|---------|--------|
| 01 | Exploring Windows Server Interface and Basic Configuration | 1 | Server Manager, System Information, Control Panel, Task Manager |
| 02 | Using Remote Administration Tools and PowerShell | 2 | Multi-server management, PowerShell remoting, Server Manager |
| 03 | Mastering Microsoft Management Console and MMC Snap-ins | 3 | Custom MMC consoles, Event Viewer, Device Manager, Services |
| 04 | PowerShell Command-Line Administration | 4 | Cmdlets, piping, filtering, services, processes, system info |
| 05 | Installing Server Roles and Managing Firewall | 5 | Web Server (IIS) role, firewall rules, port management |
| 06 | Post-Installation Server Configuration and Security Hardening | 6 | Server naming, network config, time sync, Windows Update, firewall |
| 07 | Creating and Managing Active Directory Users and Groups | 7 | User creation, group management, organizational units, AD properties |
| 08 | Managing Disks, Volumes, and NTFS Permissions | 8 | Disk management, volume creation, NTFS permissions, file security |
| 09 | Installing OpenSSH and Configuring Secure Remote Access | 9 | OpenSSH installation, SSH keys, secure remote connections |
| 10 | Creating File Shares and Managing Share Permissions | 10 | Network shares, share permissions, NTFS permissions, access control |
| 11 | Monitoring Server Performance and Resource Usage | 11 | Task Manager, Performance Monitor, Resource Monitor, baselines |
| 12 | Understanding Windows Server Licensing and Activation | 12 | License status, editions, licensing models, compliance |
| 13 | Connecting Windows Server to Azure Arc | 13 | Azure Arc enrollment, agent installation, cloud management |
| 14 | Understanding Patching and Update Management | 14 | Windows Update, patch strategies, Hotpatch, best practices |
| 15 | Installing Hyper-V and Creating Virtual Machines | 15 | Hyper-V role, VM creation, virtual networking, storage |
| 16 | Configuring Local Administrator Password Solution (LAPS) | 16 | LAPS installation, configuration, password management |
| 17 | Configuring Network Settings and TCP/IP | 17 | Static IP, DNS, network troubleshooting, connectivity |

## Lab Environment

All labs use a standard four-machine environment:

- **LON-DC1** — Windows Server 2025 Domain Controller (AD DS, DNS, Group Policy)
- **LON-SVR1** — Windows Server 2025 Member Server (primary lab machine)
- **CLIENT1** — Windows 11 Enterprise (for testing)
- **LON-SVR2** — Windows Server 2025 (for advanced labs)
- **Domain**: `contoso.com`

**Exception**: Lab 13 (Azure Arc) requires a student Azure subscription for cloud-based portions.

## Lab Format

Each lab follows a consistent structure:

1. **Summary** — Overview of lab objectives
2. **Prerequisites** — Required prior knowledge and access
3. **Exercises** — Organized into logical sections
4. **Tasks** — Step-by-step procedures within each exercise
5. **Callouts** — Important notes, warnings, and success indicators
6. **Verification** — Confirmation that objectives are met

### Design Principles

✅ **Click-by-click instructions** — Every step is explicit and detailed  
✅ **Beginner-friendly** — No assumptions about prior knowledge  
✅ **Real-world scenarios** — Practical situations professionals encounter  
✅ **Multiple approaches** — Uses GUI, PowerShell, and Settings tools  
✅ **Verification steps** — Each task includes confirmation  
✅ **Success blocks** — Clear outcome descriptions  

## How to Use These Labs

### For Instructors

1. Review the lab before teaching to prepare
2. Follow the step-by-step procedures with students
3. Pause at verification steps to confirm understanding
4. Encourage students to explore beyond the steps
5. Use knowledge check questions at end of each section

### For Students

1. Read the lab summary to understand objectives
2. Verify prerequisites are met before starting
3. Follow each step carefully and exactly
4. Do not skip steps (each builds on previous work)
5. Verify your work at each checkpoint
6. Ask instructor for clarification if stuck

## Key Features

- **No prior experience required** — Suitable for anyone with basic Windows knowledge
- **Hands-on practice** — Learn by doing, not just reading
- **Real tools** — Uses industry-standard administration tools
- **Documented procedures** — Every click is documented
- **Consistent formatting** — Easy to follow and navigate
- **Cross-referenced** — Labs build on each other

## Topics Covered

### Administration Tools
- Server Manager, MMC, Windows Terminal, PowerShell
- Event Viewer, Device Manager, Disk Management
- Active Directory Users and Computers

### Core Services
- Active Directory Domain Services
- DNS, DHCP, Network configuration
- File sharing and permissions
- Web Server (IIS)

### Security
- Firewall configuration
- NTFS and Share permissions
- OpenSSH and secure remote access
- Windows Defender, LAPS
- Security hardening

### Operations
- Performance monitoring and troubleshooting
- Windows Update and patch management
- Hyper-V virtualization
- Azure Arc cloud management
- Licensing and compliance

## Prerequisites for Labs

- Windows Server 2025 member server (LON-SVR1)
- Domain access (contoso.com)
- Administrator credentials
- Lab environment (virtual machines provided by instructor)
- For Lab 13: Azure subscription with student account

## Formatting Standards

All labs follow the **LabStyleGuide.md** standards:

- Markdown format (.md files)
- Consistent callout syntax (secondary, warning, danger, success)
- Numbered steps with checkboxes
- Bold for UI labels and controls
- Code blocks with language syntax highlighting
- Fenced callouts for important information

## Feedback and Improvements

These labs are designed to be comprehensive and clear. If you find:

- Unclear steps
- Missing information
- Outdated procedures
- Typos or formatting issues

Please report them so labs can be improved for future learners.

## Related Resources

- **CLAUDE.md** — Project context and architecture guidelines
- **Agent Course Build Instructions.md** — Content generation standards
- **LabStyleGuide.md** — Formatting and structure requirements
- **Windows Server 2025 Course Outline.md** — Complete course structure

## License

These course materials are part of the Windows Server 2025 professional training program.

---

**Last Updated**: April 2026  
**Version**: 1.0  
**Total Labs**: 17  
**Estimated Duration**: 17-20 hours (1-2 hours per lab)

For instructor resources and slide decks, see the main course directory.
