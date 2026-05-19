# Practice Lab 0101: Exploring Windows Server Interface and Basic Configuration

  

## Summary

  

::: secondary

In this lab, you will connect to a Windows Server 2025 machine and explore the core user interface components. You will learn how to navigate Server Manager, access system information, and perform basic system checks. This is a foundational lab to familiarize yourself with the Windows Server environment.

:::

### Prerequisites

  

::: secondary

To complete this lab, you must have:

- Access to the LON-SRV1 virtual machine

- Administrator credentials for the contoso.com domain

- A remote connection capability (RDP)

:::

  

::: warning

**Note**: This lab assumes you have basic Windows operating system knowledge. If you need help connecting via RDP, ask your instructor before proceeding.

:::

  

## Exercise 1: Connecting to LON-SRV1 and Accessing Server Manager

  

::: secondary

**Scenario**

  

You need to connect to a member server in your domain and review its basic configuration using Server Manager. This is a common first task when managing Windows Server machines.

:::

  

### Task 1: Connect to LON-SRV1 via Remote Desktop

  

::: warning

**Note**: If working in an online lab  platform you can select HOME and then LON-SVR1 from the dropdown box rather than remoting via RDP.

:::

  

1. [ ] On your local machine, open **Remote Desktop Connection** by pressing **Start** then searching for **Run**.

2. [ ] Type `mstsc` in the **Run** dialog box.

3. [ ] Click **OK** to open Remote Desktop Connection.

4. [ ] In the **Computer** field, type `LON-SRV1.contoso.com`.

5. [ ] Click **Connect**.

6. [ ] When prompted for credentials, enter:

   - **Username**: `CONTOSO\Administrator` (or the username provided by your instructor)

   - **Password**: (the password provided by your instructor)

7. [ ] Click **OK**.

8. [ ] If a certificate warning appears, click **Yes** to accept the certificate and proceed.

9. [ ] Wait for the connection to establish. You should see the Windows Server 2025 desktop.

  

::: success

**Results**: After completing this task, you will be connected to LON-SRV1 and can see the Windows Server desktop with the taskbar at the bottom.

:::

  

### Task 2: Open Server Manager

  

1. [ ] Once connected to LON-SRV1, click start.

2. [ ] You should see a **Server Manager** icon (looks like a blue shield with gears).

3. [ ] Click the **Server Manager** icon.

4. [ ] Wait 10-15 seconds for Server Manager to fully load. You may see a blue progress bar while it loads.

5. [ ] Once Server Manager opens, you will see the **Dashboard** view with sections for:

   - Welcome to Server Manager

   - Roles and Server Groups

   - Recent Events

   - Services

   - Performance

  

::: warning

**Note**: If Server Manager does not open, try clicking the icon again. Server Manager can take up to 30 seconds to start on first launch.

:::

  

::: success

**Results**: After completing this task, Server Manager will be open and you can see the main dashboard with information about the server.

:::

  

## Exercise 2: Exploring Server Information

  

::: secondary

**Scenario**

  

You need to view critical server information such as the computer name, domain, operating system version, and hardware specifications. This information helps you confirm the server is properly configured.

:::

  

### Task 1: Access System Information

  

1. [ ] In Server Manager, look at the top right of the window.

2. [ ] Click on the **Tools** menu at the very top.

3. [ ] Scroll down through the menu to find **System Information**.

4. [ ] Click **System Information**.

5. [ ] A new window will open showing detailed system information. Look for the following fields in the **System Summary** section:

   - **Computer Name**: Should show `LON-SRV1`

   - **Domain**: Should show `CONTOSO`

   - **Operating System**: Should show `Windows Server 2025`

   - **System Manufacturer** and **System Model**: Details about the virtual machine

  

::: warning

**Note**: If you don't see all the fields, scroll down in the System Information window. The window may need to be expanded to see all details.

:::

  

::: success

**Results**: After completing this task, you will have verified that LON-SRV1 is correctly named, joined to the CONTOSO domain, and running Windows Server 2025.

:::

  

### Task 2: Check Network Configuration

  

1. [ ] Still in the System Information window, look on the left side for a list of categories.

2. [ ] Click on the **+** symbol next to **Components** Then expand **Network** to expand it.

3. [ ] You will see network adapter information for your server.

4. [ ] Look for the **IPv4 Address** field. It should show an IP address (for example, `192.168.1.101`).

5. [ ] Look for the **Default Gateway** field. It should show a gateway IP address.

  
  

::: success

**Results**: After completing this task, you will have verified that the server has valid network configuration with an IP address and gateway.

:::

  

## Exercise 3: Exploring Key Windows Server Interface Components

  

::: secondary

**Scenario**

  

You need to become familiar with the core Windows Server interface components that you will use throughout this course. Understanding where to find important system tools will make your work more efficient.

:::

  

### Task 1: Explore the Control Panel

  

1. [ ] Close the System Information window by clicking the **X** button in the top right corner.

2. [ ] Right-click on the **Windows Start button** (the Windows logo in the bottom left corner).

3. [ ] A menu will appear with options.

4. [ ] Look for and click on **System** (or **System and Security** if that appears instead).

5. [ ] You will see the Windows Settings page with system information including:

   - Device name (should be LON-SRV1)

   - Full device name (should be LON-SRV1.contoso.com)

   - Device ID

   - Processor information

   - Installed RAM

  

::: success

**Results**: After completing this task, you will understand how to access system information through the Settings interface.

:::

  

### Task 2: Access the Control Panel

  

1. [ ] Still in the Settings window, look at the top left for a **Search** box.

2. [ ] Click in the search box and type `Control Panel`.

3. [ ] Click on **Control Panel** when it appears in the search results.

4. [ ] The Control Panel window will open showing various system administration categories such as:

   - System and Security

   - Network and Internet

   - Hardware and Sound

   - Devices and Printers

5. [ ] Click on **System and Security**.

6. [ ] Review the options available, which include:

   - System

   - Windows Defender Firewall

   - Device Manager

   - Power Options

  

::: warning

**Note**: The Control Panel is a legacy interface. In newer Windows Server versions, many settings are moving to Settings, but Control Panel is still important for certain administrative tasks.

:::

  

::: success

**Results**: After completing this task, you will know how to navigate the Control Panel and locate system administration options.

:::

  

### Task 3: Open Task Manager

  

1. [ ] Right-click on the **Windows Start button** again (bottom left corner).

2. [ ] Click on **Task Manager**.

3. [ ] Task Manager will open. You will see the **Processes** tab by default.

4. [ ] Look at the columns, which show:

   - Name (application or process name)

   - Status (running or not running)

   - User (who is running the process)

   - CPU (percentage of processor being used)

   - Memory (amount of RAM being used)

5. [ ] Scroll through the list to see what processes are running on the server. You should see:

   - System

   - Taskhostw.exe

   - dwm.exe (Desktop Window Manager)

   - Server Manager (if it's still open)

  

::: success

**Results**: After completing this task, you understand how to use Task Manager to view running processes and system resource usage.

:::

  

## Exercise 4: Understanding Windows Server Roles and Features

  

::: secondary

**Scenario**

  

You need to understand what roles and features are installed on your server. A role is a major server function (like file server or domain controller), and features are additional capabilities.

:::

  

### Task 1: View Installed Roles and Features

  

1. [ ] Click on **Server Manager** icon in the taskbar to bring it back into focus.

2. [ ] On the left side of Server Manager, click on **Local Server**.

3. [ ] You will see the server properties including:

   - Computer name

   - Domain

   - Roles

   - Features

4. [ ] Look for a section titled **Roles and Server Groups** or **Roles**. You should see a list of installed roles. On a fresh LON-SRV1, there may be no roles installed yet, or you may see a role like **Web Server (IIS)** depending on your lab configuration.

5. [ ] Scroll down to see the **Features** section. You should see a list of installed features.

  

::: warning

**Note**: The exact roles and features installed will depend on how LON-SRV1 was configured for your lab environment. Ask your instructor what to expect.

:::

  
  

::: success

**Results**: You have successfully completed Lab 0101. You are now familiar with the basic Windows Server 2025 interface and can navigate to administrative tools and system information. You understand the structure of Server Manager and how to access key system information. In the next labs, you will use these interfaces to configure and manage Windows Server roles, features, and services.

:::

## Exercise 5: Checking Update and Security Status with PowerShell

::: secondary
**Scenario**

You need to use PowerShell to quickly review the server update state and common security settings. These checks help confirm the server is ready for further configuration.
:::

### Task 1: Open Windows PowerShell

1. [ ] Right-click the **Windows Start button**.
2. [ ] Select **Terminal** or **Windows PowerShell**.
3. [ ] If prompted by **User Account Control**, select **Yes**.
4. [ ] Verify that a PowerShell window opens.

::: success
**Results**: After completing this task, you will have opened PowerShell with administrative access.
:::

### Task 2: Check Windows Update Status

1. [ ] Run the following command to check the Windows Update service status.

```powershell
Get-Service -Name wuauserv
```

2. [ ] Verify that the **Status** value is displayed.

3. [ ] Run the following command to view recent installed updates.

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10
```

4. [ ] Review the **HotFixID**, **Description**, and **InstalledOn** values.

5. [ ] Run the following command to check whether the server is waiting for a restart after updates.

```powershell
Test-Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending'
```

6. [ ] Verify whether the command returns `True` or `False`.

::: warning
**Note**: A result of `True` means Windows has pending update-related restart activity. Do not restart the server unless instructed.
:::

::: success
**Results**: After completing this task, you will have checked the Windows Update service, recent installed updates, and pending restart state.
:::

### Task 3: Check Common Security Settings

1. [ ] Run the following command to check Windows Defender Firewall profile status.

```powershell
Get-NetFirewallProfile | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
```

2. [ ] Verify whether the **Domain**, **Private**, and **Public** firewall profiles are enabled.

3. [ ] Run the following command to check Microsoft Defender Antivirus service status.

```powershell
Get-Service -Name WinDefend
```

4. [ ] Verify that the **Status** value is displayed.

5. [ ] Run the following command to view Microsoft Defender Antivirus status.

```powershell
Get-MpComputerStatus | Select-Object AMServiceEnabled, AntivirusEnabled, RealTimeProtectionEnabled, AntispywareEnabled
```

6. [ ] Verify whether real-time protection is enabled.

7. [ ] Run the following command to check Remote Desktop firewall rules.

```powershell
Get-NetFirewallRule -DisplayGroup 'Remote Desktop' | Select-Object DisplayName, Enabled, Direction, Action
```

8. [ ] Review whether Remote Desktop firewall rules are enabled.

::: warning
**Note**: Some security settings may differ depending on the lab image, domain policy, or instructor configuration.
:::

::: success
**Results**: After completing this exercise, you will have reviewed common update and security settings by using PowerShell.
:::
