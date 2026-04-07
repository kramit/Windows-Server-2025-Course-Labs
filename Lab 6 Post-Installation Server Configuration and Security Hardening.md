# Practice Lab 0601: Post-Installation Server Configuration and Security Hardening

## Summary

::: secondary
In this lab, you will perform essential post-installation configuration tasks on a Windows Server. These tasks are critical for security and operational readiness. You will configure the server name, network settings, and apply security hardening measures.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Administrator access to LON-SRV1
- Understanding of basic network concepts (IP addresses, DNS)
:::

## Exercise 1: Verifying Server Name and Network Configuration

::: secondary
**Scenario**

After a Windows Server installation, you must verify that the server name and network configuration are correct. The server should be properly named and have valid network settings.
:::

### Task 1: Verify Server Name

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Open Server Manager.
3. [ ] Click on **Local Server** in the left panel.
4. [ ] In the right panel, look for **Computer name**. It should display **LON-SRV1**.
5. [ ] If the name is incorrect, you would need to rename it:
   - Click on the current computer name
   - Click **Change** in the System Properties dialog
   - Type the new name
   - Click **OK** and restart the server
6. [ ] Since the name should be correct, verify it matches your lab requirements.

::: success
**Results**: After completing this task, you have verified the server name is correctly configured.
:::

### Task 2: Verify Network Configuration

1. [ ] In Server Manager's Local Server view, look for **Ethernet** or **Network** settings.
2. [ ] Click on the Ethernet adapter listed (typically shows as something like "Ethernet: IPv4 address DHCP enabled" or similar).
3. [ ] The **Network Settings** window will open.
4. [ ] You should see your network adapter with:
   - **Status**: Connected
   - **IP address**: An IPv4 address (for example, 192.168.1.100)
   - **Default gateway**: A gateway IP address (for example, 192.168.1.1)
   - **DNS servers**: At least one DNS server address
5. [ ] These settings confirm the server is properly connected to the network.

::: warning
**Note**: If you see "No Internet connection" or other connection problems, contact your instructor before proceeding.
:::

::: success
**Results**: After completing this task, you have verified network connectivity and IP configuration.
:::

## Exercise 2: Configuring Time and Time Zone

::: secondary
**Scenario**

Correct time and time zone settings are critical for Windows Server. Many security features, logs, and domain authentication depend on accurate time. You will verify and configure time settings.
:::

### Task 1: Check Current Time and Time Zone

1. [ ] In Server Manager's Local Server view, look for **Time Zone**.
2. [ ] It should display your current time zone (for example, "GMT Standard Time" for London).
3. [ ] You should also see the current date and time displayed in the System Tray at the bottom right of the screen.
4. [ ] If the time zone is incorrect:
   - Click on the time zone in Server Manager
   - The **Date and Time** settings window will open
   - Click **Change time zone...**
   - Select the correct time zone from the dropdown
   - Click **Apply** and **OK**

::: warning
**Note**: Incorrect time settings can cause domain authentication failures and security issues. Ensure this is correct for your environment.
:::

::: success
**Results**: After completing this task, you have verified the time zone is correctly configured.
:::

### Task 2: Verify Network Time Protocol (NTP)

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to check NTP configuration:

```powershell
w32tm /query /status
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will display time synchronization status:
   - **Leap Indicator**: Should show "0 - no warning"
   - **Stratum**: Should show "3" or higher (not 0, which means not synchronized)
   - **Reference ID**: Shows the NTP server being used for synchronization
   - **Precision**: Shows time accuracy
5. [ ] This confirms the server is synchronized with a time source.

::: success
**Results**: After completing this task, you have verified that the server is synchronized with a time source.
:::

## Exercise 3: Applying Windows Updates

::: secondary
**Scenario**

Windows Updates are critical for security. You need to ensure that Windows Update is enabled and that the latest updates are installed. This is one of the most important security hardening steps.
:::

### Task 1: Check Windows Update Status

1. [ ] Open Server Manager.
2. [ ] Look for a **Windows Update** section in the dashboard. It might show:
   - "X important updates available"
   - Or "Your system is up to date"
3. [ ] If updates are available, click on the update notification.
4. [ ] Alternatively, right-click the **Windows Start button** and select **Settings**.
5. [ ] Type **Windows Update** in the search box and press **Enter**.
6. [ ] The Windows Update settings page will open showing:
   - **Current status**: Up to date or updates available
   - **Last checked**: When updates were last checked
   - **Check for updates** button

::: success
**Results**: After completing this task, you understand how to access Windows Update settings.
:::

### Task 2: Install Available Updates

1. [ ] If updates are available, click **Check for updates** (if needed).
2. [ ] If the system offers updates, click **Install** or **Download and install**.
3. [ ] Windows will download and install the updates. This may take several minutes.
4. [ ] You may be prompted to restart the server. If asked:
   - Click **Restart now** if instructed by your instructor
   - Or **Schedule installation** if you need to restart at a specific time

::: warning
**Note**: Be prepared for a server restart. Do not have any unsaved work open. Schedule the restart for an appropriate time if the server is in production.
:::

5. [ ] After updates are installed, verify:

```powershell
Get-HotFix | Measure-Object | Select-Object Count
```

6. [ ] This shows how many updates are currently installed.

::: success
**Results**: After completing this task, you have ensured that the latest Windows updates are installed on the server.
:::

## Exercise 4: Configuring and Enabling Windows Firewall

::: secondary
**Scenario**

Windows Firewall is your primary line of defense against unauthorized network access. You will verify that Firewall is enabled and properly configured.
:::

### Task 1: Verify Firewall Status

1. [ ] Right-click the **Windows Start button** or press **Windows key + X**.
2. [ ] Select **Windows Security** (or **Windows Defender Security**).
3. [ ] Click on **Firewall & network protection** in the left menu.
4. [ ] You should see:
   - **Domain networks**: Firewall is On (green checkmark)
   - **Private networks**: Firewall is On (green checkmark)
   - **Public networks**: Firewall is On (green checkmark)
5. [ ] If any firewall is Off (shows red X), click on that network type and click the toggle to turn it **On**.

::: warning
**Note**: Always keep Windows Firewall enabled. Disabling it exposes your server to network attacks.
:::

::: success
**Results**: After completing this task, you have confirmed Windows Firewall is enabled on all network types.
:::

### Task 2: Configure Firewall from PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] To check firewall status on all profiles, type:

```powershell
Get-NetFirewallProfile -PolicyStore ActiveStore | Select-Object Name, Enabled
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will show firewall status for each profile:
   - **Domain**: Should show True (enabled)
   - **Private**: Should show True (enabled)
   - **Public**: Should show True (enabled)
5. [ ] If any is False (disabled), enable it with:

```powershell
Set-NetFirewallProfile -Profile Domain,Private,Public -Enabled True
```

::: success
**Results**: After completing this task, you have verified Windows Firewall is enabled using PowerShell.
:::

## Exercise 5: Configuring Automatic Login Behavior

::: secondary
**Scenario**

You need to prevent unauthorized physical access to your server. Proper configuration of login behavior is important for security.
:::

### Task 1: Require Login on Startup

1. [ ] Right-click the **Windows Start button** and select **Settings**.
2. [ ] Search for **Lock screen** and select it.
3. [ ] Look for **Sign-in options** settings.
4. [ ] Verify that:
   - **Require sign-in** is set to **On** (not "When PC wakes up from sleep")
   - This ensures someone must log in to access the server
5. [ ] If settings need to be changed, adjust them appropriately.

::: success
**Results**: After completing this task, you have configured the server to require login.
:::

### Task 2: Disable Unnecessary Services

1. [ ] Open PowerShell as Administrator.
2. [ ] View services that are set to automatic but might not be needed:

```powershell
Get-Service | Where-Object {$_.StartType -eq 'Automatic'} | Select-Object Name, DisplayName, Status | Format-Table -AutoSize
```

3. [ ] Press **Enter**.
4. [ ] Review this list. Common services that might be disabled if not needed:
   - **Print Spooler** (if not printing)
   - **Remote Registry** (security risk if not needed)
   - **Bluetooth Support Service** (if no Bluetooth devices)
5. [ ] Do NOT disable critical services like:
   - DNS Client
   - Network services
   - Security services
6. [ ] This is an informational step. Do not disable services without instructor approval.

::: warning
**Note**: Disabling the wrong service can cause server problems. Only disable services you are certain are not needed.
:::

::: success
**Results**: After completing this task, you understand which services are configured to start automatically.
:::

## Exercise 6: Verification and Security Checklist

::: secondary
**Scenario**

You have completed critical post-installation configuration and security hardening tasks. Before completing the lab, verify everything is properly configured.
:::

### Task 1: Security Configuration Checklist

Verify the following have been completed:

1. **Server Name**: ✓ Server is correctly named (LON-SRV1)
2. **Network Configuration**: ✓ Network adapter is configured with IP address and DNS
3. **Time Zone**: ✓ Time zone is set to correct region
4. **Time Synchronization**: ✓ Server is synchronized with NTP time source
5. **Windows Updates**: ✓ Latest security updates are installed
6. **Windows Firewall**: ✓ Firewall is enabled on all profiles
7. **Login Requirements**: ✓ Server requires login to access

::: success
**Results**: You have successfully completed Lab 0601. Your Windows Server 2025 machine is now:
- Properly named and configured
- Connected to the network with correct IP settings
- Synchronized with the correct time
- Protected with the latest security updates
- Protected by an active Windows Firewall
- Configured to require login for security

These post-installation steps are essential for every Windows Server deployment. Skipping them leaves the server vulnerable to attacks and misconfiguration. In future labs, you will continue building on this secure foundation by configuring additional server roles and features.
:::
