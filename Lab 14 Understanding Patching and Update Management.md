# Practice Lab 1401: Understanding Patching and Update Management

## Summary

::: secondary
In this lab, you will understand Windows Server patching and update management strategies. You will review available updates, understand Windows Hotpatch, and learn best practices for keeping servers secure and current.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SRV1
- Understanding of Windows Server security basics
:::

## Exercise 1: Checking Available Updates

::: secondary
**Scenario**

You need to understand what updates are available for your server and how to manage them. You will review available patches and understand update types.
:::

### Task 1: Check for Windows Updates

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Open **Settings** by pressing **Windows key + I**.
3. [ ] Search for **Windows Update** in the search box.
4. [ ] Click on **Windows Update**.
5. [ ] Click **Check for updates**.
6. [ ] Windows will scan for available updates. Wait for the scan to complete (1-2 minutes).
7. [ ] You will see:
   - **Current status**: Updates available (or "Your device is up to date")
   - **Windows Updates**: Security and quality updates
   - **Optional updates**: Non-critical updates
8. [ ] Look for the types of updates available:
   - **Security updates**: Fix vulnerabilities
   - **Quality updates**: Fix bugs and improve performance
   - **Feature updates**: Major version updates (rare for in-service servers)

::: success
**Results**: After completing this task, you understand update types available.
:::

### Task 2: View Installed Updates

1. [ ] Open **Settings** > **System** > **Windows Update**.
2. [ ] Click **Update history** or **Windows Update** > **View update history**.
3. [ ] You will see a list of previously installed updates:
   - **Date installed**: When the patch was applied
   - **Name**: Update name
   - **Status**: Successfully installed or failed
   - **KB number**: Knowledge base article (e.g., KB5001234)
4. [ ] Each update has a KB number you can look up on Microsoft Support for details.

::: success
**Results**: After completing this task, you understand installed updates on your server.
:::

## Exercise 2: Understanding Update Management Strategies

::: secondary
**Scenario**

Different organizations use different strategies for managing updates. You will understand the main approaches.
:::

### Task 1: Review Update Management Options

| Strategy | Description | Pros | Cons |
|----------|-------------|------|------|
| **Manual Updates** | Admin installs updates manually | Full control | Time-consuming |
| **Windows Update** | Automatic from Windows Update | Easy setup | Less control |
| **WSUS** | Internal server for updates | Control, bandwidth savings | Complex setup |
| **Azure Update Management** | Cloud-based management | Scalable, modern | Requires Azure |

Most organizations use either:
- **Windows Update** for small deployments
- **WSUS** (Windows Server Update Services) for enterprise deployments
- **Azure Update Management** for cloud-connected servers

::: success
**Results**: After completing this task, you understand update management strategies.
:::

## Exercise 3: Understanding Windows Hotpatch

::: secondary
**Scenario**

Windows Hotpatch is a feature that allows security updates without rebooting. You will understand this technology.
:::

### Task 1: Hotpatch Basics

**Hotpatch** allows:
- Security updates without server reboot
- Updates applied to running kernel
- Reduced downtime
- Only available on certain Azure VMs
- Requires specific Windows Server editions
- Managed through Azure Arc or Azure Update Management

**Traditional Updates**:
- Require server restart to apply
- Downtime required
- Quality/Security updates both may require restart

**When to Use**:
- Production servers (avoid downtime)
- Cloud-hosted servers (Azure Hybrid Benefit)
- Servers managed through Azure Arc

::: success
**Results**: After completing this task, you understand Windows Hotpatch benefits.
:::

### Task 2: Check Hotpatch Eligibility

1. [ ] Hotpatch requires specific conditions:
   - **Windows Server 2022 or later** (your server is 2025, so eligible)
   - **Running on Azure**
   - **Managed through Azure Arc**
   - **Azure Hybrid Benefit active**
2. [ ] Since your server is on-premises (LON-SRV1), it may not be Hotpatch-eligible unless configured in Azure.
3. [ ] If the server were connected to Azure Arc and running there, you could enable Hotpatch.

::: success
**Results**: After completing this task, you understand Hotpatch eligibility.
:::

## Exercise 4: Configuring Automatic Updates

::: secondary
**Scenario**

For production servers, you should configure automatic updates but with restart scheduling to minimize disruption.
:::

### Task 1: Configure Update Schedule

1. [ ] Open **Settings** > **System** > **Windows Update**.
2. [ ] Click **Advanced options**.
3. [ ] Look for:
   - **Receive updates for other Microsoft products**: Toggle On (recommended)
   - **Automatic updates**: Should be enabled
   - **Schedule installs**: Look for an option to schedule updates
4. [ ] Some organizations prefer:
   - **Tuesday updates**: Patch Tuesday is the second Tuesday of each month
   - **After-hours installation**: Minimize disruption to users
   - **Weekend installation**: Avoid business hours

::: success
**Results**: After completing this task, you understand update scheduling.
:::

## Exercise 5: Using PowerShell for Update Management

::: secondary
**Scenario**

PowerShell provides powerful tools for managing updates at scale.
:::

### Task 1: Check Update Status

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to check for available updates:

```powershell
Get-WUInstall -ListOnly -Verbose
```

3. [ ] Press **Enter**.
4. [ ] This may require the PSWindowsUpdate module. If not available, Windows Update cmdlets work differently:

```powershell
Get-HotFix | Select-Object HotFixID, Description, InstalledOn | Sort-Object InstalledOn -Descending | Select-Object -First 10
```

5. [ ] This shows the 10 most recent updates installed.

::: success
**Results**: After completing this task, you can check updates using PowerShell.
:::

## Exercise 6: Understanding Patch Management Best Practices

::: secondary
**Scenario**

Proper patch management is critical for security and stability.
:::

### Task 1: Patch Management Best Practices

1. **Test Before Production**:
   - Test patches in a lab/staging environment
   - Ensure no compatibility issues
   - Check application compatibility

2. **Patch Regularly**:
   - Apply security updates promptly (within 30 days)
   - Schedule quality updates monthly
   - Don't delay patches

3. **Schedule Restarts**:
   - Plan reboot windows
   - Communicate with users
   - Avoid critical business hours

4. **Document Patches**:
   - Track what was installed
   - Record patch dates and times
   - Maintain change control

5. **Monitor After Patching**:
   - Check server performance
   - Verify services are running
   - Monitor application functionality

6. **Automate Where Possible**:
   - Use WSUS for enterprise
   - Use Azure Update Management for cloud
   - Reduce manual work

::: success
**Results**: After completing this task, you understand best practices for patching.
:::

## Exercise 7: Verification and Summary

::: secondary
**Scenario**

You have reviewed update management strategies and best practices.
:::

### Task 1: Update Management Checklist

For your server, verify:

1. ✓ Windows Update is enabled
2. ✓ Security updates are installed
3. ✓ Update history is visible
4. ✓ Automatic updates are configured
5. ✓ Restart schedule is set
6. ✓ Optional updates are reviewed
7. ✓ Patch policy documented

::: success
**Results**: You have successfully completed Lab 1401. You now understand:
- How to check for available Windows updates
- Different update management strategies
- What Windows Hotpatch is and when to use it
- How to configure automatic updates
- Best practices for patch management

Proper patching is essential for security and stability. Regular updates prevent security vulnerabilities and ensure servers remain stable. In future labs, you will configure advanced update management at scale.
:::
