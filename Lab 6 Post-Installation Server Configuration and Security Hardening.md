# Practice Lab 0601: Post-Installation Server Configuration and Security Hardening

## Summary

::: secondary
In this lab, you will perform post-installation checks and basic hardening tasks on **LON-SVR1**, a Windows Server 2025 member server in the **contoso.com** domain. You will use graphical administration tools first, then use focused PowerShell commands to validate the configuration.

The lab connects setup decisions to operational readiness. You will verify the server identity, installation option, network configuration, time synchronization, update posture, firewall state, remote management settings, installed roles, service exposure, local security policy, Secured-core readiness, and event logs.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Administrator access to **LON-SVR1**
- Access to **LON-SVR2** for one server-to-server validation task
- Basic familiarity with Server Manager, Windows Settings, Event Viewer, Services, and Windows PowerShell
:::

::: warning
**Important**: This lab is designed for the course lab environment. Do not rename servers, change domain membership, remove roles, or change IP addressing unless the step explicitly tells you to do so or your instructor directs you.
:::

## Exercise 1: Connect to LON-SVR1 and Capture the Starting State
   
::: secondary
**Scenario**

Before you harden a server, you need to know what system you are administering and what state it is currently in. You will connect through the lab platform and review the Server Manager dashboard.
:::

### Task 1: Connect to LON-SVR1

1. [ ] In the lab platform, select **HOME**.
2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.
3. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.
4. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.
5. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.
6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SVR1 through the lab platform.
:::

### Task 2: Open Server Manager and Review the Dashboard

1. [ ] If **Server Manager** is already open, bring it to the front.
2. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.
3. [ ] In the left navigation pane, select **Dashboard**.
4. [ ] Review the **Welcome to Server Manager** section.
5. [ ] Review the **Roles and Server Groups** section.
6. [ ] Notice whether **IIS** or **Web Server (IIS)** appears from Lab 0501.
7. [ ] Review whether any dashboard tiles show red warning indicators.

::: warning
**Note**: A warning indicator does not always mean the server is broken. Administrators review the message, event source, and context before deciding what action is required.
:::

::: success
**Results**: After completing this task, you have reviewed the server's starting state before making or validating changes.
:::

## Exercise 2: Verify Server Identity, Domain Membership, and Installation Option

::: secondary
**Scenario**

Initial setup decisions affect every later administration task. You will confirm that you are working on the correct server, that it belongs to the expected domain, and that it is running the Desktop Experience installation option used in this lab.
:::

### Task 1: Verify the Computer Name and Domain

1. [ ] In **Server Manager**, select **Local Server**.
2. [ ] In the **Properties** pane, find **Computer name**.
3. [ ] Verify that **Computer name** shows **LON-SVR1**.
4. [ ] In the same **Properties** pane, find **Domain**.
5. [ ] Verify that **Domain** shows **contoso.com**.
6. [ ] Select the **Computer name** value.
7. [ ] In **System Properties**, review the **Computer Name** tab.
8. [ ] Verify that **Full computer name** shows **LON-SVR1.contoso.com**.
9. [ ] Select **Cancel** to close **System Properties** without making changes.

::: warning
**Note**: Renaming a server or changing domain membership can interrupt authentication, management access, certificates, application settings, and scripts. In this lab, you are verifying identity only.
:::

::: success
**Results**: After completing this task, you have verified the server name and domain membership.
:::

### Task 2: Review the Windows Server Edition and Desktop Experience

1. [ ] Select **Start**.
2. [ ] Type **About your PC**.
3. [ ] Select **About your PC** from the search results.
4. [ ] In **Settings** > **System** > **About**, review **Windows specifications**.
5. [ ] Verify that the server is running a Windows Server 2025 edition.
6. [ ] Review the desktop shell, taskbar, Settings app, File Explorer, and Server Manager.
7. [ ] Record in your lab notes that **LON-SVR1** is using **Server with Desktop Experience**.

::: warning
**Note**: **Server with Desktop Experience** and **Server Core** are installation options selected during setup. Switching between them requires a clean installation, so administrators should choose the option deliberately.
:::

::: success
**Results**: After completing this task, you have connected the local GUI environment to the Windows Server setup choice.
:::

### Task 3: Validate Identity and Installation Details with PowerShell

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] In the search results, right-click **Windows PowerShell**.
4. [ ] Select **Run as administrator**.
5. [ ] If a **User Account Control** prompt appears, select **Yes**.
6. [ ] Run the following command:

```powershell
Get-ComputerInfo | Select-Object CsName, CsDomain, WindowsProductName, OsName, OsVersion
```

7. [ ] Verify that **CsName** shows **LON-SVR1**.
8. [ ] Verify that **CsDomain** shows **contoso.com**.
9. [ ] Run the following command:

```powershell
Get-Process explorer -ErrorAction SilentlyContinue | Select-Object ProcessName, Id
```

10. [ ] Verify that an **explorer** process is listed. This confirms that the graphical shell is running.

::: success
**Results**: After completing this task, you have validated server identity and the local graphical shell by using PowerShell.
:::

## Exercise 3: Verify Network Configuration and Domain Connectivity

::: secondary
**Scenario**

Post-installation checks must confirm that the server can communicate with the domain and other lab servers. You will review the network adapter in the GUI, then validate DNS and server-to-server communication.
:::

### Task 1: Review the Network Adapter in Server Manager

1. [ ] In **Server Manager**, select **Local Server**.
2. [ ] In the **Properties** pane, find the **Ethernet** value.
3. [ ] Select the **Ethernet** value.
4. [ ] In **Network Connections**, locate the active network adapter.
5. [ ] Verify that the adapter status shows **Enabled**.
6. [ ] Double-click the active adapter.
7. [ ] In the **Ethernet Status** window, review **IPv4 Connectivity**.
8. [ ] Select **Details...**.
9. [ ] In **Network Connection Details**, review:
   - **IPv4 Address**
   - **IPv4 Subnet Mask**
   - **IPv4 Default Gateway**
   - **IPv4 DNS Server**
10. [ ] Verify that a DNS server is listed.
11. [ ] Select **Close** to close **Network Connection Details**.
12. [ ] Select **Close** to close **Ethernet Status**.

::: warning
**Note**: In a domain environment, DNS configuration is critical. If a server uses the wrong DNS server, domain sign-in, Group Policy, name resolution, and management tools can fail.
:::

::: success
**Results**: After completing this task, you have reviewed the network adapter and confirmed that it has IPv4 and DNS settings.
:::

### Task 2: Validate DNS and Connectivity from LON-SVR1

1. [ ] Return to the elevated **Windows PowerShell** window.
2. [ ] Run the following command:

```powershell
ipconfig /all
```

3. [ ] Review the active adapter and confirm that DNS server information is listed.
4. [ ] Run the following command:

```powershell
Resolve-DnsName LON-DC1.contoso.com
```

5. [ ] Verify that the command returns an IP address for **LON-DC1.contoso.com**.
6. [ ] Run the following command:

```powershell
Test-Connection LON-DC1 -Count 2
```

7. [ ] Verify that the replies show successful connectivity to **LON-DC1**.

::: success
**Results**: After completing this task, you have validated DNS resolution and basic connectivity to the domain controller.
:::

### Task 3: Validate Server-to-Server Connectivity from LON-SVR2

1. [ ] In the lab platform, select **HOME**.
2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.
3. [ ] Use the **Username** and **Password** values shown for **LON-SVR2** on the **HOME** tab.
4. [ ] In the **Tools** section, turn on **Enhanced mode**.
5. [ ] Wait for the Windows Server desktop to appear.
6. [ ] Select **Start**.
7. [ ] Type **PowerShell**.
8. [ ] Select **Windows PowerShell** from the search results.
9. [ ] Run the following command:

```powershell
Resolve-DnsName LON-SVR1.contoso.com
```

10. [ ] Verify that DNS returns an IP address for **LON-SVR1.contoso.com**.
11. [ ] Run the following command:

```powershell
Test-NetConnection LON-SVR1 -Port 5985
```

12. [ ] Review the **TcpTestSucceeded** result.

::: warning
**Note**: TCP port `5985` is used by Windows Remote Management over HTTP. If **TcpTestSucceeded** is **True**, LON-SVR2 can reach the WinRM listener on LON-SVR1. If it is **False**, record the result and continue; later exercises review remote management and firewall posture.
:::

::: success
**Results**: After completing this task, you have tested name resolution and remote management connectivity from a second server.
:::

13. [ ] In the lab platform, return to **LON-SVR1** before continuing.

## Exercise 4: Verify Time, Time Zone, and Update Readiness

::: secondary
**Scenario**

Accurate time and current updates are security fundamentals. Domain authentication, Kerberos tickets, event logs, certificates, and patch compliance all depend on these settings.
:::

### Task 1: Review the Time Zone in Server Manager

1. [ ] On **LON-SVR1**, open **Server Manager**.
2. [ ] Select **Local Server**.
3. [ ] In the **Properties** pane, find **Time zone**.
4. [ ] Verify that the time zone is appropriate for the lab environment.
5. [ ] Select the **Time zone** value.
6. [ ] In **Date and Time**, review the current date, time, and time zone.
7. [ ] If your instructor tells you to change the time zone, select **Change time zone...**, choose the correct time zone, and select **OK**.
8. [ ] Select **Cancel** or **OK** to close **Date and Time**.

::: warning
**Note**: Incorrect time can cause sign-in failures and misleading event logs. In production, time configuration should follow the organization's time synchronization design.
:::

::: success
**Results**: After completing this task, you have verified the visible time and time zone configuration.
:::

### Task 2: Validate Time Synchronization

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
w32tm /query /status
```

2. [ ] Review the output.
3. [ ] Find **Source** and record the time source in your lab notes.
4. [ ] Find **Stratum** and verify that the server is not reporting `0`.
5. [ ] Run the following command:

```powershell
w32tm /query /configuration
```

6. [ ] Review the configuration, including the time provider information.

::: success
**Results**: After completing this task, you have validated the server's time synchronization status.
:::

### Task 3: Review Windows Update Status

1. [ ] Select **Start**.
2. [ ] Select **Settings**.
3. [ ] In **Settings**, select **Windows Update**.
4. [ ] Review the update status, including **Last checked** and any pending restart message.
5. [ ] Select **Check for updates** if your instructor tells you to do so.
6. [ ] If updates are offered, follow your instructor's guidance before installing or restarting.

::: warning
**Note**: Installing updates is an important hardening activity, but it can restart the server. In production, administrators use maintenance windows and change approval for update installation.
:::

::: success
**Results**: After completing this task, you have reviewed the server's update readiness.
:::

### Task 4: Validate Installed Updates with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10 HotFixID, Description, InstalledOn
```

2. [ ] Review the most recent installed updates.
3. [ ] Run the following command:

```powershell
Get-ComputerInfo | Select-Object WindowsProductName, OsVersion, OsHardwareAbstractionLayer
```

4. [ ] Record the operating system version information in your lab notes.

::: success
**Results**: After completing this task, you have collected update and version evidence that can be used in a change record.
:::

## Exercise 5: Review Remote Management and SConfig

::: secondary
**Scenario**

Windows Server administration is usually remote-first. Even when a server has Desktop Experience, administrators should understand the remote management setting and the text-based **SConfig** tool used heavily with Server Core.
:::

### Task 1: Review Remote Management in Server Manager

1. [ ] In **Server Manager**, select **Local Server**.
2. [ ] In the **Properties** pane, find **Remote management**.
3. [ ] Verify whether it shows **Enabled**.
4. [ ] Select the **Remote management** value.
5. [ ] In **Configure Remote Management**, review the setting for remote management.
6. [ ] Do not change the setting unless your instructor tells you to.
7. [ ] Select **Cancel**.

::: warning
**Note**: Remote management is useful, but it should be paired with appropriate firewall rules, authentication, administrative access control, and logging.
:::

::: success
**Results**: After completing this task, you have reviewed the Server Manager remote management setting.
:::

### Task 2: Review the WinRM Service

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Services**.
3. [ ] In the **Services** console, select any service in the list.
4. [ ] Type **Windows Remote Management** to move near that service.
5. [ ] Select **Windows Remote Management (WS-Management)**.
6. [ ] Review the **Status** and **Startup Type** columns.
7. [ ] Double-click **Windows Remote Management (WS-Management)**.
8. [ ] On the **General** tab, review:
   - **Service name**: `WinRM`
   - **Display name**: **Windows Remote Management (WS-Management)**
   - **Startup type**
   - **Service status**
9. [ ] Select **Cancel** to close the properties window without making changes.

::: success
**Results**: After completing this task, you have reviewed the service that supports Windows Remote Management.
:::

### Task 3: Compare the GUI with SConfig

1. [ ] Return to elevated **Windows PowerShell**.
2. [ ] Run the following command:

```powershell
sconfig
```

3. [ ] When **Server Configuration** opens, review the menu options.
4. [ ] Identify options related to:
   - **Domain/Workgroup**
   - **Computer Name**
   - **Remote Management**
   - **Windows Update Settings**
   - **Network Settings**
   - **Date and Time**
5. [ ] Do not make changes in SConfig.
6. [ ] Enter the menu option that exits SConfig.
7. [ ] Return to PowerShell.

::: warning
**Note**: SConfig is especially important on Server Core because Server Core does not include the full local desktop shell. In this lab, you are using it to compare first-configuration workflows.
:::

::: success
**Results**: After completing this task, you have reviewed SConfig as a first-configuration tool.
:::

### Task 4: Validate WinRM with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-Service WinRM | Select-Object Name, DisplayName, Status, StartType
```

2. [ ] Review the WinRM service state.
3. [ ] Run the following command:

```powershell
Get-NetFirewallRule -DisplayGroup "Windows Remote Management" | Select-Object DisplayName, Enabled, Profile
```

4. [ ] Review the firewall rules that support Windows Remote Management.

::: success
**Results**: After completing this task, you have connected the remote management service state to its firewall rules.
:::

## Exercise 6: Review Windows Defender Firewall and Management Exposure

::: secondary
**Scenario**

Hardening does not mean turning off management. It means allowing required access and reducing unnecessary exposure. You will review firewall profiles and management-related inbound rules.
:::

### Task 1: Open Windows Defender Firewall with Advanced Security

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Windows Defender Firewall with Advanced Security**.
3. [ ] In the left pane, select **Windows Defender Firewall with Advanced Security on Local Computer**.
4. [ ] In the center pane, review the **Overview** section.
5. [ ] Review the profile sections for:
   - **Domain Profile**
   - **Private Profile**
   - **Public Profile**

::: success
**Results**: After completing this task, you have opened the advanced firewall console and reviewed the firewall profiles.
:::

### Task 2: Review Firewall Profile Properties

1. [ ] In the **Actions** pane, select **Properties**.
2. [ ] In **Windows Defender Firewall with Advanced Security on Local Computer Properties**, review the tabs:
   - **Domain Profile**
   - **Private Profile**
   - **Public Profile**
   - **IPsec Settings**
3. [ ] On each profile tab, review:
   - **Firewall state**
   - **Inbound connections**
   - **Outbound connections**
   - **Settings**
   - **Logging**
4. [ ] Do not change any settings.
5. [ ] Select **Cancel**.

::: warning
**Note**: A server normally keeps the firewall enabled. Administrators should open only the ports, programs, profiles, and remote addresses required by the workload.
:::

::: success
**Results**: After completing this task, you have reviewed the firewall profile posture without weakening the server.
:::

### Task 3: Inspect Remote Management Inbound Rules

1. [ ] In the left pane, select **Inbound Rules**.
2. [ ] Select the **Name** column header to sort the rules by name.
3. [ ] Locate rules that begin with **Windows Remote Management**.
4. [ ] Select **Windows Remote Management (HTTP-In)** if it is present.
5. [ ] Review the columns for the selected rule, including:
   - **Enabled**
   - **Profile**
   - **Action**
   - **Protocol**
   - **Local Port**
6. [ ] Double-click **Windows Remote Management (HTTP-In)**.
7. [ ] On the **General** tab, review whether the rule is enabled and whether it allows traffic.
8. [ ] Select the **Protocols and Ports** tab.
9. [ ] Verify that the local port is `5985`.
10. [ ] Select the **Scope** tab and review the remote IP address settings.
11. [ ] Select the **Advanced** tab and review which profiles the rule applies to.
12. [ ] Select **Cancel** to close the properties window without making changes.

::: warning
**Note**: Broad remote management rules can be acceptable inside a controlled lab domain, but production servers should use firewall scope, management networks, administrative groups, and monitoring to reduce risk.
:::

::: success
**Results**: After completing this task, you have inspected the inbound firewall rule that supports WinRM traffic.
:::

### Task 4: Validate Firewall Profiles with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-NetFirewallProfile -PolicyStore ActiveStore | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

2. [ ] Verify that each profile shows **Enabled** as **True**.
3. [ ] Run the following command:

```powershell
Get-NetFirewallRule -DisplayGroup "Windows Remote Management" |
    Select-Object DisplayName, Enabled, Direction, Action, Profile
```

4. [ ] Review which Windows Remote Management rules are enabled and which profiles they apply to.

::: success
**Results**: After completing this task, you have validated firewall profile and remote management rule posture with PowerShell.
:::

## Exercise 7: Review Installed Roles, Features, and Services

::: secondary
**Scenario**

Security hardening starts with workload-aware reduction. A server should not run unnecessary roles, features, or services. You will review what is installed, connect it to the previous IIS lab, and harden one commonly exposed service if needed.
:::

### Task 1: Review Installed Roles and Features in Server Manager

1. [ ] In **Server Manager**, select **Manage**.
2. [ ] Select **Remove Roles and Features**.
3. [ ] On the **Before You Begin** page, select **Next >**.
4. [ ] On the **Server Selection** page, verify that **LON-SVR1.contoso.com** is selected.
5. [ ] Select **Next >**.
6. [ ] On the **Server Roles** page, review which roles are selected.
7. [ ] Confirm whether **Web Server (IIS)** is selected from Lab 0501.
8. [ ] Do not clear any role checkboxes.
9. [ ] Select **Next >**.
10. [ ] On the **Features** page, review selected features.
11. [ ] Do not clear any feature checkboxes.
12. [ ] Select **Cancel** to exit the wizard.

::: warning
**Note**: This task uses the Remove Roles and Features Wizard as a safe review tool. Removing a role can break applications, firewall rules, management tools, scheduled tasks, monitoring, and course dependencies.
:::

::: success
**Results**: After completing this task, you have reviewed installed roles and features without removing required components.
:::

### Task 2: Validate Installed Roles with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-WindowsFeature | Where-Object Installed | Select-Object Name, DisplayName, InstallState
```

2. [ ] Review the installed roles and features.
3. [ ] Record whether **Web-Server** appears in the list.
4. [ ] Run the following command:

```powershell
Get-WindowsFeature -Name Web-Server
```

5. [ ] Verify whether **Install State** shows **Installed**.

::: success
**Results**: After completing this task, you have validated installed roles and features by using PowerShell.
:::

### Task 3: Review Service Exposure in Services

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Services**.
3. [ ] In the **Services** console, select any service in the list.
4. [ ] Type **Remote Registry** to move near that service.
5. [ ] Select **Remote Registry**.
6. [ ] Review the **Status** and **Startup Type** columns.
7. [ ] Double-click **Remote Registry**.
8. [ ] On the **General** tab, review:
   - **Service name**: `RemoteRegistry`
   - **Startup type**
   - **Service status**
9. [ ] If **Startup type** is already **Disabled**, select **Cancel**.
10. [ ] If **Startup type** is not **Disabled**, change it to **Disabled**.
11. [ ] If **Service status** shows **Running**, select **Stop**.
12. [ ] Select **OK**.

::: warning
**Note**: Remote Registry can be useful for specific administrative workflows, but leaving it available when it is not required increases management exposure. In production, confirm application and support requirements before disabling services.
:::

::: success
**Results**: After completing this task, you have reviewed and hardened the Remote Registry service if it was not already disabled.
:::

### Task 4: Validate Service State with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-Service RemoteRegistry | Select-Object Name, DisplayName, Status, StartType
```

2. [ ] Verify that **StartType** shows **Disabled**.
3. [ ] Run the following command to review automatic services:

```powershell
Get-Service | Where-Object StartType -eq Automatic | Select-Object Name, DisplayName, Status | Sort-Object Name
```

4. [ ] Review the list and notice that hardening requires understanding what each service supports before changing it.

::: success
**Results**: After completing this task, you have validated one service-hardening setting and reviewed other automatically starting services.
:::

## Exercise 8: Review Local Security Policy and Sign-In Controls

::: secondary
**Scenario**

Security baselines often include password, account lockout, audit, and interactive sign-in settings. On a domain-joined server, domain Group Policy may control many settings, but administrators should still know where to review local policy.
:::

### Task 1: Open Local Security Policy

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Local Security Policy**.
3. [ ] In the left pane, expand **Account Policies**.
4. [ ] Select **Password Policy**.
5. [ ] Review settings such as:
   - **Enforce password history**
   - **Maximum password age**
   - **Minimum password length**
   - **Password must meet complexity requirements**
6. [ ] Select **Account Lockout Policy**.
7. [ ] Review settings such as:
   - **Account lockout duration**
   - **Account lockout threshold**
   - **Reset account lockout counter after**

::: warning
**Note**: Domain accounts are normally controlled by domain password and lockout policy, not only by local policy on one member server. In this task, you are reviewing the policy locations and learning what the settings mean.
:::

::: success
**Results**: After completing this task, you have reviewed password and account lockout policy locations.
:::

### Task 2: Review Interactive Logon Policy

1. [ ] In **Local Security Policy**, expand **Local Policies**.
2. [ ] Select **Security Options**.
3. [ ] In the center pane, find policies that begin with **Interactive logon:**.
4. [ ] Select **Interactive logon: Do not display last user name**.
5. [ ] Review the **Security Setting** column.
6. [ ] Double-click **Interactive logon: Do not display last user name**.
7. [ ] Review the available options.
8. [ ] Select **Cancel** without changing the setting.
9. [ ] Review other **Interactive logon:** policies, such as message text, message title, and smart card behavior.

::: warning
**Note**: Interactive sign-in policy affects the user experience and can be controlled by domain Group Policy. Do not change these settings in the lab unless your instructor asks you to.
:::

::: success
**Results**: After completing this task, you have reviewed where sign-in hardening settings are located.
:::

### Task 3: Review Effective Account Policy with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
net accounts
```

2. [ ] Review the password and lockout information shown by the command.
3. [ ] Run the following command:

```powershell
gpresult /scope computer /r
```

4. [ ] Review the **Applied Group Policy Objects** section.
5. [ ] Record whether domain policies are applied to the computer.

::: success
**Results**: After completing this task, you have compared local policy locations with effective policy information.
:::

## Exercise 9: Assess Secured-Core and Platform Protection Readiness

::: secondary
**Scenario**

Secured-core server combines hardware, firmware, boot, and virtualization-backed protections. Some settings may not be available in a virtual lab, but administrators should know how to assess readiness and record the result.
:::

### Task 1: Review System Information

1. [ ] Select **Start**.
2. [ ] Type **System Information**.
3. [ ] Select **System Information** from the search results.
4. [ ] In the left pane, select **System Summary**.
5. [ ] In the right pane, review the following items if they are present:
   - **BIOS Mode**
   - **Secure Boot State**
   - **Virtualization-based security**
   - **Virtualization-based security Services Running**
   - **Kernel DMA Protection**
6. [ ] Record whether each setting is enabled, disabled, not present, or not supported in the lab environment.

::: warning
**Note**: A virtual training environment may not expose every firmware or hardware-backed protection. The goal is to practice assessment, not force unsupported settings.
:::

::: success
**Results**: After completing this task, you have reviewed platform security information in the graphical System Information tool.
:::

### Task 2: Review Device Security in Windows Security

1. [ ] Select **Start**.
2. [ ] Type **Windows Security**.
3. [ ] Select **Windows Security** from the search results.
4. [ ] Select **Device security**.
5. [ ] Review the available sections, such as **Core isolation** or **Security processor**, if they appear.
6. [ ] Do not change any settings.
7. [ ] Select **Home** in Windows Security.
8. [ ] Review the protection area status indicators.

::: warning
**Note**: Some Device security pages depend on virtual hardware, TPM exposure, Secure Boot, and virtualization features. Missing sections are common in labs and should be documented rather than guessed.
:::

::: success
**Results**: After completing this task, you have reviewed Windows Security for platform protection indicators.
:::

### Task 3: Validate Platform Protections with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-Tpm
```

2. [ ] Review whether a TPM is present and ready.
3. [ ] Run the following command:

```powershell
Confirm-SecureBootUEFI
```

4. [ ] Review the result. If the command reports that Secure Boot is not supported in the current environment, record that result.
5. [ ] Run the following command:

```powershell
Get-CimInstance -Namespace root\Microsoft\Windows\DeviceGuard -ClassName Win32_DeviceGuard |
    Select-Object VirtualizationBasedSecurityStatus, SecurityServicesConfigured, SecurityServicesRunning
```

6. [ ] Review whether virtualization-based security services are configured or running.

::: warning
**Note**: These commands are assessment commands. They do not enable Secured-core by themselves. Production Secured-core planning must include hardware support, firmware settings, virtualization-backed protections, and security baseline alignment.
:::

::: success
**Results**: After completing this task, you have collected Secured-core and platform protection evidence.
:::

## Exercise 10: Review Security and System Events

::: secondary
**Scenario**

After setup and hardening tasks, administrators review events to understand whether changes caused errors, warnings, or security-relevant activity. You will use Event Viewer to inspect recent logs.
:::

### Task 1: Open Event Viewer and Review the System Log

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Event Viewer**.
3. [ ] In the left pane, expand **Windows Logs**.
4. [ ] Select **System**.
5. [ ] Review recent events in the center pane.
6. [ ] In the **Actions** pane, select **Filter Current Log...**.
7. [ ] In **Filter Current Log**, select **Critical**, **Warning**, and **Error**.
8. [ ] Select **OK**.
9. [ ] Select a recent event and review the **General** tab in the lower pane.
10. [ ] In the **Actions** pane, select **Clear Filter**.

::: warning
**Note**: Warnings and errors require context. Review the event source, event ID, time, and message before deciding whether the event indicates a real problem.
:::

::: success
**Results**: After completing this task, you have reviewed recent system events.
:::

### Task 2: Review the Security Log

1. [ ] In **Event Viewer**, under **Windows Logs**, select **Security**.
2. [ ] Review recent events.
3. [ ] Select a recent **Audit Success** event.
4. [ ] Review the **General** tab.
5. [ ] Look for information such as:
   - **Account Name**
   - **Logon Type**
   - **Source Network Address**
   - **Process Name**
6. [ ] Do not clear the log.

::: warning
**Note**: Security logs are operational evidence. In production, clearing security logs is a controlled administrative action and may be monitored.
:::

::: success
**Results**: After completing this task, you have reviewed recent security events without modifying the log.
:::

### Task 3: Validate Recent Events with PowerShell

1. [ ] In elevated **Windows PowerShell**, run the following command:

```powershell
Get-WinEvent -LogName System -MaxEvents 10 |
    Select-Object TimeCreated, ProviderName, Id, LevelDisplayName
```

2. [ ] Review the recent System events.
3. [ ] Run the following command:

```powershell
Get-WinEvent -LogName Security -MaxEvents 10 |
    Select-Object TimeCreated, ProviderName, Id, LevelDisplayName
```

4. [ ] Review the recent Security events.

::: success
**Results**: After completing this task, you have validated that event information can be reviewed through both Event Viewer and PowerShell.
:::

## Exercise 11: Complete the Post-Installation Hardening Checklist

::: secondary
**Scenario**

Administrators should finish configuration work by recording what they verified, what they changed, and what risk remains. You will complete a brief checklist and administrative change summary.
:::

### Task 1: Complete the Configuration Checklist

Verify and record the following in your lab notes:

1. [ ] **Connection method**: Connected to **LON-SVR1** through the lab platform.
2. [ ] **Server identity**: Computer name is **LON-SVR1**.
3. [ ] **Domain membership**: Server is joined to **contoso.com**.
4. [ ] **Installation option**: Server is using **Server with Desktop Experience**.
5. [ ] **Network configuration**: IPv4 address and DNS server are present.
6. [ ] **Name resolution**: **LON-DC1.contoso.com** resolves from **LON-SVR1**.
7. [ ] **Server-to-server validation**: **LON-SVR2** can resolve **LON-SVR1.contoso.com**.
8. [ ] **Time configuration**: Time zone and time synchronization were reviewed.
9. [ ] **Update posture**: Windows Update and recent hotfixes were reviewed.
10. [ ] **Remote management**: Server Manager, WinRM service, and WinRM firewall rules were reviewed.
11. [ ] **Firewall posture**: Firewall profiles are enabled.
12. [ ] **Roles and features**: Installed roles and features were reviewed.
13. [ ] **Service hardening**: **Remote Registry** is disabled or confirmed as already disabled.
14. [ ] **Local policy**: Password, lockout, and interactive logon policy locations were reviewed.
15. [ ] **Platform protection**: TPM, Secure Boot, and VBS readiness were assessed.
16. [ ] **Event review**: System and Security logs were reviewed.

::: success
**Results**: After completing this task, you have a concise record of the server's post-installation configuration and hardening posture.
:::

### Task 2: Record the Administrative Change Summary

Record the following change summary in your lab notes:

1. [ ] **Server reviewed**: **LON-SVR1**
2. [ ] **Domain**: **contoso.com**
3. [ ] **Primary tools used**:
   - Server Manager
   - Settings
   - Services
   - Windows Defender Firewall with Advanced Security
   - Local Security Policy
   - System Information
   - Windows Security
   - Event Viewer
   - Windows PowerShell
   - SConfig
4. [ ] **Configuration changed**: **Remote Registry** was disabled if it was not already disabled.
5. [ ] **Configuration reviewed but not changed**:
   - Server name and domain membership
   - Network addressing and DNS
   - Time zone and time synchronization
   - Windows Update status
   - Firewall profiles and WinRM rules
   - Installed roles and features
   - Local security policy
   - Secured-core and platform protection readiness
6. [ ] **Security impact**: The lab reduced unnecessary service exposure and confirmed that required management paths remain visible and reviewable.
7. [ ] **Production note**: In a production environment, these settings should be applied through approved baselines, Group Policy, change control, maintenance windows, and monitoring.

::: success
**Results**: After completing this task, you have documented the manual checks and administrative decisions from the lab.
:::

## Exercise 12: Generate a PowerShell HTML Validation Report

::: secondary
**Scenario**

You have completed the manual post-installation and hardening review. You will now run a provided PowerShell script that checks the same areas and exports the results to an HTML report. The script is supplied in the lab supporting content so you do not need to type the script manually.
:::

### Task 1: Locate the Lab 6 Report Script

1. [ ] Confirm that you are connected to **LON-SVR1** in the lab platform.
2. [ ] Select **Start**.
3. [ ] Type **File Explorer**.
4. [ ] Select **File Explorer** from the search results.
5. [ ] Browse to the course lab files folder provided by your instructor.
6. [ ] Open **supporting content**.
7. [ ] Open **Lab6**.
8. [ ] Verify that the folder contains `Get-Lab6PostInstallReport.ps1`.

::: success
**Results**: After completing this task, you have located the prepared Lab 6 validation script.
:::

### Task 2: Run the Report Script

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] In the search results, right-click **Windows PowerShell**.
4. [ ] Select **Run as administrator**.
5. [ ] If a **User Account Control** prompt appears, select **Yes**.
6. [ ] Change to the folder that contains the Lab 6 script. For example, if your lab files are in `C:\LabFiles`, run:

```powershell
Set-Location "C:\LabFiles\supporting content\Lab6"
```

7. [ ] Run the script:

```powershell
.\Get-Lab6PostInstallReport.ps1
```

8. [ ] Review the output in PowerShell. The script displays the full path to the generated HTML report.
9. [ ] Record the report path in your lab notes.

::: warning
**Note**: The default report folder is `C:\LabOutput`. If your instructor asks you to save the report somewhere else, run the script with the `-OutputFolder` parameter.
:::

::: success
**Results**: After completing this task, you have generated an HTML validation report from LON-SVR1.
:::

### Task 3: Review the HTML Report

1. [ ] Open **File Explorer**.
2. [ ] Browse to `C:\LabOutput`.
3. [ ] Open the newest file named similar to `Lab6-PostInstall-Report-YYYYMMDD-HHMMSS.html`.
4. [ ] Microsoft Edge opens the report.
5. [ ] Review the **Summary** section.
6. [ ] Review the sections for:
   - **Server Identity and Installation Option**
   - **Network Configuration**
   - **Time Synchronization Status**
   - **Recent Installed Updates**
   - **WinRM Service**
   - **Firewall Profiles**
   - **Remote Registry Service**
   - **Account Policy**
   - **TPM State**
   - **Secure Boot State**
   - **Virtualization-Based Security**
   - **Recent System Events**
   - **Recent Security Events**
7. [ ] Compare the report with your manual checklist from Exercise 11.
8. [ ] Record any items marked **Review** in your lab notes.

::: warning
**Note**: A **Review** result does not automatically mean the server is misconfigured. Some checks depend on virtual hardware, lab networking, firewall behavior, or domain policy. Administrators use the report as evidence to review, not as a substitute for understanding the configuration.
:::

::: success
**Results**: After completing this task, you have reviewed the generated HTML report and compared it with the manual validation steps.
:::

### Task 4: Understand What the Script Checks

1. [ ] Return to the **Lab6** supporting content folder.
2. [ ] Right-click `Get-Lab6PostInstallReport.ps1`.
3. [ ] Select **Edit** or **Open with** > **Notepad**.
4. [ ] Review the major sections in the script.
5. [ ] Confirm that the script collects evidence for:
   - Computer name, domain, operating system, and Desktop Experience shell
   - Network adapter, DNS, and connectivity checks
   - Time zone and time synchronization
   - Installed updates
   - WinRM service and firewall rules
   - Firewall profiles
   - Installed Windows roles and features
   - Remote Registry service state
   - Account policy and applied computer Group Policy
   - TPM, Secure Boot, and virtualization-based security indicators
   - Recent System and Security events
6. [ ] Close the script without making changes.

::: warning
**Note**: The script runs on **LON-SVR1**. It can test connectivity to other servers, but it cannot fully replace the earlier manual step where you used **LON-SVR2** as a second client perspective.
:::

::: success
**Results**: You have completed Lab 0601. You can now:

- Verify a Windows Server 2025 system after installation
- Distinguish Desktop Experience from Server Core as setup-time choices
- Review server name, domain membership, networking, DNS, time, and update posture
- Use SConfig as a first-configuration comparison tool
- Review remote management and firewall exposure
- Inspect installed roles, features, and services
- Disable an unnecessary service when appropriate
- Review local policy and effective policy evidence
- Assess Secured-core readiness indicators
- Review System and Security events
- Record an administrative hardening summary
- Run a prepared PowerShell script that exports validation evidence to an HTML report

These tasks build the habit of validating, reducing exposure, and documenting the server before adding more roles or placing the server into service.
:::
