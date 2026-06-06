# Practice Lab 1401: Understanding Patching and Update Management

## Summary

::: secondary
In this lab, you will review Windows Server patching and update management strategies on LON-SVR1. You will use graphical tools first to review Windows Update status, update history, update-related services, event logs, policy locations, Azure Update Manager options, and Windows Server Hotpatch concepts. You will then use PowerShell to validate the same update posture in a repeatable way.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SVR1
- Understanding of Windows Server security basics
:::

::: warning
**Note**: This lab focuses on reviewing and documenting update posture. Do not install updates, restart the server, or enable Hotpatch unless your instructor specifically tells you to do so.
:::

## Exercise 1: Connect to LON-SVR1 and Collect a Patch Baseline

::: secondary
**Scenario**

Before changing update settings, administrators should collect a baseline. You will connect to LON-SVR1, review the operating system version, and identify the current Windows Update state.
:::

### Task 1: Connect to LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.

5. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.

6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SVR1 through the lab platform.
:::

### Task 2: Review Windows Server Version Information

1. [ ] Select **Start**.

2. [ ] Type **Settings**.

3. [ ] Select **Settings** from the search results.

4. [ ] In **Settings**, select **System**.

5. [ ] Select **About**.

6. [ ] Review the **Windows specifications** section.

7. [ ] Review the following information:
   - **Edition**
   - **Version**
   - **OS build**
   - **Experience**

   ::: warning
   **Note**: The exact build number can vary depending on the lab image and installed updates.
   :::

::: success
**Results**: After completing this task, you have collected operating system version information for LON-SVR1.
:::

### Task 3: Review Current Windows Update Status

1. [ ] In **Settings**, select **Windows Update**.

2. [ ] Review the current update status at the top of the page.

3. [ ] Note whether the page shows **You're up to date**, **Updates available**, **Restart required**, or another status.

4. [ ] Note the **Last checked** time if it is displayed.

5. [ ] Look for any message that indicates a restart is pending.

6. [ ] Do not select **Download**, **Install**, **Restart now**, or any similar action unless your instructor specifically tells you to.

   ::: warning
   **Note**: Update installation can require a restart and can change the lab environment. In production, administrators normally install updates during an approved maintenance window.
   :::

::: success
**Results**: After completing this exercise, you have collected a patch baseline for LON-SVR1.
:::

## Exercise 2: Review Windows Update Settings and History

::: secondary
**Scenario**

You need to understand how Windows Update presents available updates, installed updates, optional updates, and restart-related options. You will review the Windows Update interface without installing updates.
:::

### Task 1: Check for Available Updates

1. [ ] In **Settings**, select **Windows Update** if it is not already selected.

2. [ ] Select **Check for updates**.

3. [ ] Wait for the scan to complete.

4. [ ] Review the update status after the scan finishes.

5. [ ] If updates are listed, review the update names and any visible KB numbers.

6. [ ] If the page shows **You're up to date**, confirm that no updates were offered during the scan.

7. [ ] Do not install updates unless your instructor specifically tells you to.

   ::: warning
   **Note**: Windows Update results can vary by lab image, network access, Microsoft update availability, and policy configuration.
   :::

::: success
**Results**: After completing this task, you have checked the current update availability on LON-SVR1.
:::

### Task 2: Review Update History

1. [ ] On the **Windows Update** page, select **Update history**.

2. [ ] Review the update categories that appear, such as **Quality Updates**, **Driver Updates**, **Definition Updates**, or **Other Updates**.

3. [ ] Expand **Quality Updates** if it is available.

4. [ ] Locate the most recent installed update.

5. [ ] Review the update name, KB number, and installation date if they are displayed.

6. [ ] Select any available link for an update only if you want to review Microsoft support information for that KB.

::: success
**Results**: After completing this task, you have reviewed installed update history on LON-SVR1.
:::

### Task 3: Review Advanced Options

1. [ ] Return to the main **Windows Update** page.

2. [ ] Select **Advanced options**.

3. [ ] Review whether **Receive updates for other Microsoft products** is available.

4. [ ] Review any visible restart, notification, active hours, or update behavior options.

5. [ ] Do not change the options unless your instructor specifically tells you to.

6. [ ] Identify any setting that appears important for restart planning or update scheduling.

   ::: warning
   **Note**: Some Windows Update options can be hidden, disabled, or controlled by policy. If a setting is unavailable, continue with the lab and note what you see.
   :::

::: success
**Results**: After completing this task, you have reviewed Windows Update advanced options.
:::

### Task 4: Review Optional Updates

1. [ ] On the **Advanced options** page, look for **Optional updates**.

2. [ ] Select **Optional updates** if it is available.

3. [ ] Review whether driver updates or other optional updates are listed.

4. [ ] Do not select or install optional updates unless your instructor specifically tells you to.

5. [ ] Return to the main **Windows Update** page.

   ::: warning
   **Note**: Optional updates are not always required for server security. Administrators review optional updates carefully because driver and preview updates can affect stability.
   :::

::: success
**Results**: After completing this exercise, you have reviewed Windows Update status, history, advanced options, and optional updates.
:::

## Exercise 3: Review Update-Related Services

::: secondary
**Scenario**

Windows Update depends on several services. You will use the Services console to locate the services that commonly support update detection, download, installation, and package validation.
:::

### Task 1: Open Services

1. [ ] If **Server Manager** is already open, bring it to the front.

2. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.

3. [ ] In **Server Manager**, select **Tools**.

4. [ ] Select **Services**.

5. [ ] In the **Services** console, select any service in the list.

::: success
**Results**: After completing this task, you have opened the Services console.
:::

### Task 2: Review Windows Update Service

1. [ ] In the **Services** console, type **Windows** to move near services that begin with that word.

2. [ ] Select **Windows Update**.

3. [ ] Review the **Status** and **Startup Type** columns.

4. [ ] Double-click **Windows Update**.

5. [ ] On the **General** tab, review:
   - **Service name**: `wuauserv`
   - **Display name**: **Windows Update**
   - **Startup type**
   - **Service status**

6. [ ] Select **Cancel** to close the properties window without making changes.

   ::: warning
   **Note**: Do not stop the Windows Update service unless your instructor specifically asks you to test update troubleshooting behavior.
   :::

::: success
**Results**: After completing this task, you have reviewed the Windows Update service.
:::

### Task 3: Review Supporting Update Services

1. [ ] In the **Services** console, locate **Background Intelligent Transfer Service**.

2. [ ] Review the **Status** and **Startup Type** columns.

3. [ ] Double-click **Background Intelligent Transfer Service**.

4. [ ] On the **General** tab, verify that the **Service name** is `BITS`.

5. [ ] Select **Cancel**.

6. [ ] Locate **Cryptographic Services**.

7. [ ] Review the **Status** and **Startup Type** columns.

8. [ ] Double-click **Cryptographic Services**.

9. [ ] On the **General** tab, verify that the **Service name** is `CryptSvc`.

10. [ ] Select **Cancel**.

   ::: warning
   **Note**: BITS is commonly used for background downloads, and Cryptographic Services supports certificate and package validation. Production troubleshooting should review service dependencies and business impact before restarting services.
   :::

::: success
**Results**: After completing this exercise, you have reviewed key services that support Windows Update.
:::

## Exercise 4: Review Windows Update Events

::: secondary
**Scenario**

Administrators use event logs to confirm update activity and investigate update failures. You will review Windows Update events by using Event Viewer.
:::

### Task 1: Open Event Viewer and Review the Windows Update Log

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **Event Viewer**.

3. [ ] In the left pane, expand **Applications and Services Logs**.

4. [ ] Expand **Microsoft**.

5. [ ] Expand **Windows**.

6. [ ] Scroll to and expand **WindowsUpdateClient**.

7. [ ] Select **Operational**.

8. [ ] Review the recent events in the center pane.

9. [ ] Select a recent event.

10. [ ] In the lower pane, review the **General** tab.

   ::: warning
   **Note**: Warning or error events do not automatically mean the server is broken. Administrators compare the event time, source, event ID, and message with observed update behavior.
   :::

::: success
**Results**: After completing this task, you have opened Event Viewer and reviewed the WindowsUpdateClient Operational log.
:::

## Exercise 5: Review Automatic Update and WSUS Policy Locations

::: secondary
**Scenario**

Larger organizations often control update behavior with Group Policy and WSUS. You will review the local policy locations that administrators use to configure automatic updates and internal update servers.
:::

### Task 1: Open Local Group Policy Editor

1. [ ] Select **Start**.

2. [ ] Type **Edit group policy**.

3. [ ] Select **Edit group policy** from the search results.

4. [ ] If **Local Group Policy Editor** opens, continue to the next task.

   ::: warning
   **Note**: Domain-joined servers can receive update settings from domain Group Policy. This lab reviews local policy locations so you know where these settings are defined.
   :::

::: success
**Results**: After completing this task, you have opened Local Group Policy Editor.
:::

### Task 2: Review Windows Update Policy Location

1. [ ] In **Local Group Policy Editor**, expand **Computer Configuration**.

2. [ ] Expand **Administrative Templates**.

3. [ ] Expand **Windows Components**.

4. [ ] Select **Windows Update**.

5. [ ] Review the policy folders and settings shown in the center pane.

6. [ ] Do not change any policy settings.

::: success
**Results**: After completing this task, you have located Windows Update policy settings.
:::

### Task 3: Inspect Automatic Update and WSUS Policies

1. [ ] In the **Windows Update** policy area, locate **Configure Automatic Updates**.

2. [ ] Double-click **Configure Automatic Updates**.

3. [ ] Review the available settings: **Not Configured**, **Enabled**, and **Disabled**.

4. [ ] Select **Cancel** to close the policy without changing it.

5. [ ] Locate **Specify intranet Microsoft update service location**.

6. [ ] Double-click **Specify intranet Microsoft update service location**.

7. [ ] Review the fields that would be used to configure an internal WSUS server.

8. [ ] Select **Cancel** to close the policy without changing it.

9. [ ] Close **Local Group Policy Editor**.

   ::: warning
   **Note**: WSUS is commonly configured through domain Group Policy so many servers receive the same update source and approval behavior. This lab does not install or configure WSUS.
   :::

::: success
**Results**: After completing this exercise, you have reviewed where automatic update and WSUS policies are configured.
:::

## Exercise 6: Compare Update Management Strategies and Hotpatch

::: secondary
**Scenario**

Different environments need different update management strategies. You will compare common options and review where Windows Server Hotpatch fits into a modern patching plan.
:::

::: tip
**Recommended reading**:

- [Hotpatch for Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/hotpatch)
- [Enable Hotpatch for Azure Arc-enabled servers](https://learn.microsoft.com/en-us/windows-server/get-started/enable-hotpatch-azure-arc-enabled-servers)

Hotpatch is different from standard patching because supported security updates can be applied without an immediate restart. Standard cumulative updates still require planned reboots, and Hotpatch also uses periodic baseline updates that do require a restart.
:::

### Task 1: Compare Update Management Options

Review the following update management options:

| Strategy | Common use case | Benefits | Considerations |
|----------|-----------------|----------|----------------|
| **Manual review with Windows Update** | Small labs or isolated servers | Simple and built in | Does not scale well and can lead to inconsistent patch timing |
| **Windows Update with policy settings** | Small managed environments | Uses built-in Windows behavior with some control | Limited reporting and approval workflow |
| **WSUS** | On-premises enterprise environments | Central approval, reporting, and bandwidth control | Requires WSUS infrastructure and regular maintenance |
| **Azure Update Manager** | Azure, Azure Arc-enabled, hybrid, and multicloud servers | Central scheduling, assessment, deployment, and reporting | Requires Azure connectivity and appropriate onboarding |
| **Non-Microsoft patch management tools** | Environments with existing endpoint or server management platforms | Can integrate with broader operations processes | Capabilities and reporting vary by product |

Most organizations choose a strategy based on:

1. [ ] Number of servers.

2. [ ] Required approval process.

3. [ ] Maintenance window requirements.

4. [ ] Reporting and compliance needs.

5. [ ] Whether servers are on-premises, in Azure, or connected through Azure Arc.

::: success
**Results**: After completing this task, you have compared common update management strategies.
:::

### Task 2: Review Windows Server Hotpatch Concepts

Review the following Hotpatch concepts. Use the Microsoft Learn articles above as the reference for this task:

1. [ ] Hotpatch can apply certain Windows Server security updates without requiring an immediate restart.

2. [ ] Hotpatch helps reduce planned downtime for servers that have strict availability requirements.

3. [ ] Hotpatch does not eliminate every restart. Baseline updates still require restarts periodically.

4. [ ] Hotpatch updates are commonly discussed as monthly hotpatch updates and periodic baseline updates.

5. [ ] Some updates, drivers, firmware, applications, and non-Windows components can still require separate restart planning.

::: success
**Results**: After completing this task, you understand the basic purpose and limits of Windows Server Hotpatch.
:::

### Task 3: Review Windows Server 2025 Hotpatch Eligibility

1. [ ] Review the following Windows Server 2025 Hotpatch eligibility checklist:
   - The server runs a supported Windows Server 2025 edition and build.
   - The server supports virtualization-based security.
   - The server uses UEFI and Secure Boot where required.
   - Windows Server 2025 Standard and Datacenter servers outside Azure Edition scenarios are Azure Arc-enabled before Hotpatch is enabled.
   - Azure Update Manager or another supported update management approach is used to assess, schedule, and install updates.
   - Maintenance windows still account for baseline updates that require restarts.

2. [ ] Compare the checklist with LON-SVR1 in this lab environment.

3. [ ] Confirm that LON-SVR1 can be reviewed for Hotpatch concepts, but Hotpatch should not be enabled in this lab unless your instructor specifically provides Azure Arc and Hotpatch instructions.

   ::: warning
   **Note**: Hotpatch eligibility depends on edition, build, security capabilities, Azure Arc onboarding, and update management configuration. Do not assume every Windows Server 2025 system is ready for Hotpatch without checking the requirements.
   :::

::: success
**Results**: After completing this exercise, you have compared update management strategies and reviewed Windows Server 2025 Hotpatch eligibility.
:::

## Exercise 7: Validate Update Posture with PowerShell

::: secondary
**Scenario**

The main lab tasks used graphical tools. You will now use PowerShell to validate update-related services, installed updates, and pending restart state.
:::

### Task 1: Open PowerShell as Administrator

1. [ ] Select **Start**.

2. [ ] Type **PowerShell**.

3. [ ] In the search results, right-click **Windows PowerShell**.

4. [ ] Select **Run as administrator**.

5. [ ] If a **User Account Control** prompt appears, select **Yes**.

::: success
**Results**: After completing this task, you have opened an elevated Windows PowerShell session.
:::

### Task 2: Validate Update-Related Services

1. [ ] Run the following command to review update-related services.

```powershell
Get-Service -Name wuauserv,bits,cryptsvc | Select-Object Name, DisplayName, Status, StartType
```

2. [ ] Verify that the command returns **Windows Update**, **Background Intelligent Transfer Service**, and **Cryptographic Services**.

3. [ ] Compare the PowerShell output with what you saw in the Services console.

::: success
**Results**: After completing this task, you have validated update-related service status with PowerShell.
:::

### Task 3: Review Recent Installed Updates

1. [ ] Run the following command to list the 10 most recent installed updates.

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10
```

2. [ ] Review the **HotFixID**, **Description**, and **InstalledOn** columns.

3. [ ] Compare the most recent KB information with the update history you reviewed in Settings.

   ::: warning
   **Note**: Some update types that appear in Settings might not appear in `Get-HotFix`. Administrators often use more than one tool when collecting update evidence.
   :::

::: success
**Results**: After completing this task, you have reviewed recent installed updates with PowerShell.
:::

### Task 4: Check for Pending Restart Evidence

1. [ ] Run the following command to check one common pending restart location.

```powershell
Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
```

2. [ ] Review the result.

3. [ ] Review whether the command returns `True` or `False`.

4. [ ] If the command returns `True`, do not restart the server unless your instructor specifically tells you to.

   ::: warning
   **Note**: A `True` result means Windows has pending component servicing restart evidence. Administrators should still review maintenance windows, service impact, and change approval before restarting production servers.
   :::

::: success
**Results**: After completing this exercise, you have validated update services, recent updates, and pending restart evidence with PowerShell.
:::

## Exercise 8: Review the Administrative Patch Summary

::: secondary
**Scenario**

Administrators should be able to describe patch posture, management approach, and restart risk. You will review a short administrative summary for LON-SVR1.
:::

### Task 1: Review the Patch Management Summary

Review the following information:

1. [ ] Server reviewed: **LON-SVR1**

2. [ ] Operating system edition and build from **Settings** > **System** > **About**.

3. [ ] Windows Update status from **Settings** > **Windows Update**.

4. [ ] **Last checked** time, if displayed.

5. [ ] Most recent installed update or KB from **Update history**.

6. [ ] Pending restart state from Settings and PowerShell.

7. [ ] Update-related services reviewed:
   - **Windows Update**
   - **Background Intelligent Transfer Service**
   - **Cryptographic Services**

8. [ ] Event log reviewed: **WindowsUpdateClient** > **Operational**.

9. [ ] Policy location reviewed: **Computer Configuration** > **Administrative Templates** > **Windows Components** > **Windows Update**.

10. [ ] Management approach recommendation:
   - **Small environment**: Windows Update with clear maintenance windows and documentation.
   - **On-premises enterprise**: WSUS or another centralized patch management platform.
   - **Hybrid or Azure-connected environment**: Azure Update Manager with Azure Arc where appropriate.
   - **High-availability Windows Server 2025 workloads**: Evaluate Hotpatch eligibility and baseline restart planning.

::: success
**Results**: You have completed Lab 1401. You can now review Windows Update status and history, inspect update-related services and events, locate automatic update and WSUS policy settings, compare patch management strategies, explain Windows Server Hotpatch eligibility, validate update posture with PowerShell, and review an administrative patch summary.
:::
