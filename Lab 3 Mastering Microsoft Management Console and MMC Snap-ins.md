# Practice Lab 0301: Mastering Microsoft Management Console and MMC Snap-ins

## Summary

::: secondary
In this lab, you will explore the Microsoft Management Console (MMC) and common snap-ins that Windows Server administrators use daily. You will create a custom MMC console, add snap-ins, and learn how to manage servers through the MMC interface. MMC is a fundamental tool for graphical server administration.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0101 (Exploring Windows Server Interface and Basic Configuration)
- Administrator access to LON-SRV1
- Basic understanding of Windows Server navigation
:::

## Exercise 1: Understanding the Microsoft Management Console

::: secondary
**Scenario**

You need to become familiar with MMC and the various snap-ins that are available. Each snap-in provides administration capabilities for different server features. Understanding how to access these tools will make your administrative work more efficient.
:::

### Task 1: Open Built-in MMC Snap-ins via Server Manager

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Open Server Manager by clicking its icon in the taskbar.
3. [ ] At the top of Server Manager, click on the **Tools** menu.
4. [ ] You will see a list of available administrative tools. These are all MMC snap-ins and related utilities. Scroll through the list to see options such as:
   - **Device Manager**
   - **Disk Management**
   - **Services**
   - **Event Viewer**
   - **Task Scheduler**
   - **Windows Defender Firewall with Advanced Security**
   - **System Information**
5. [ ] Click on **Services** to open the Services MMC snap-in.

::: success
**Results**: After completing this task, you understand that Server Manager provides quick access to many MMC snap-ins through its Tools menu.
:::

### Task 2: Explore the Services Snap-in

1. [ ] The Services MMC snap-in window will open. You will see:
   - Left panel: **Services** (tree view)
   - Center panel: A list of all services running on the server
   - Right panel: Details and actions available
2. [ ] Look at the center panel. Each row shows a service with columns:
   - **Name**: The service name (such as "Dnscmd" or "EventLog")
   - **Display Name**: The friendly name of the service
   - **Status**: Running or Stopped
   - **Startup Type**: Automatic, Manual, or Disabled
3. [ ] Scroll through the list to see various services. Look for:
   - **DNS Client** (should be Running)
   - **EventLog** (should be Running)
   - **Networking** services (various network-related services)

::: warning
**Note**: Do NOT stop any services in this lab. Stopping critical services can make the server unavailable. We are only viewing services at this point.
:::

::: success
**Results**: After completing this task, you understand the Services snap-in and how to view installed services and their status.
:::

### Task 3: View Service Properties

1. [ ] In the Services list, find a service called **DNS Client**.
2. [ ] Right-click on **DNS Client**.
3. [ ] A context menu will appear. Click on **Properties**.
4. [ ] The DNS Client Properties dialog will open with several tabs:
   - **General**: Shows the service name, display name, description, status, and startup type
   - **Log On**: Shows which account the service runs under
   - **Recovery**: Shows what happens if the service fails
   - **Dependencies**: Shows what other services this service depends on
5. [ ] Click on the **Log On** tab to see which account runs this service. You should see:
   - **Log on as**: Typically **Local System** or another system account
6. [ ] Click on the **Dependencies** tab to see what services must be running for DNS Client to work.
7. [ ] Click **Cancel** to close this dialog without making changes.

::: success
**Results**: After completing this task, you understand how to view detailed properties of services including startup type and dependencies.
:::

## Exercise 2: Creating a Custom MMC Console

::: secondary
**Scenario**

While Server Manager provides quick access to common snap-ins, you can create your own custom MMC console with only the snap-ins you need. This customization makes your administrative work more efficient.
:::

### Task 1: Open MMC to Create a Custom Console

1. [ ] Close the Services snap-in window by clicking the **X** button.
2. [ ] Open a Run dialog by pressing **Windows key + R**.
3. [ ] Type `mmc` exactly as shown.
4. [ ] Click **OK**.
5. [ ] A blank MMC console window will open. The window title will say "Console1 - [Console Root]".
6. [ ] You will see:
   - Left panel: Empty (this is where snap-ins will appear)
   - Right panel: Empty message saying "To add snap-ins, click File, then click Add/Remove Snap-in"
7. [ ] At the top, click on **File** menu.

::: success
**Results**: After completing this task, you have opened a blank MMC console where you can add snap-ins.
:::

### Task 2: Add Snap-ins to Your Custom Console

1. [ ] In the File menu, click on **Add/Remove Snap-in** (or **Add/Remove Snap-ins** depending on Windows version).
2. [ ] The **Add or Remove Snap-ins** dialog will open showing two panels:
   - Left panel: **Available snap-ins** (all available snap-ins you can add)
   - Right panel: **Selected snap-ins** (snap-ins currently in your console)
3. [ ] In the left panel, look for **Device Manager**. Click on it to select it.
4. [ ] Click the **Add >** button to move it to the Selected snap-ins panel.
5. [ ] Now look for **Disk Management**. Click on it to select it.
6. [ ] Click the **Add >** button.
7. [ ] Look for **Event Viewer**. Click on it to select it.
8. [ ] Click the **Add >** button.
9. [ ] Look for **Services**. Click on it to select it.
10. [ ] Click the **Add >** button.
11. [ ] Your Selected snap-ins panel should now contain:
    - Device Manager
    - Disk Management
    - Event Viewer
    - Services
12. [ ] Click **OK** to apply these snap-ins to your custom console.

::: warning
**Note**: The order of snap-ins in the selected panel determines how they appear in your custom console.
:::

::: success
**Results**: After completing this task, you have created a custom MMC console with four useful administrative snap-ins.
:::

### Task 3: Use Your Custom Console

1. [ ] Your custom MMC console will now show all four snap-ins in the left panel:
   - Device Manager
   - Disk Management
   - Event Viewer
   - Services
2. [ ] Click on **Disk Management** in the left panel to view the disk management tools.
3. [ ] The right panel will show your disk configuration including:
   - Disk list (typically Disk 0 for the system disk)
   - Partitions and volumes
   - File system information
4. [ ] Click on **Event Viewer** in the left panel.
5. [ ] The right panel will show the Event Viewer interface with categories:
   - Windows Logs
   - Applications and Services Logs
6. [ ] Click on **Windows Logs** to expand it and see:
   - System
   - Security
   - Application
7. [ ] These logs contain important events that occurred on your server.

::: success
**Results**: After completing this task, you can navigate between snap-ins in your custom console and access different administrative tools.
:::

### Task 4: Save Your Custom Console

1. [ ] Click on **File** menu at the top.
2. [ ] Click on **Save** (or **Save As** if you want to give it a specific name).
3. [ ] A "Save As" dialog will open.
4. [ ] In the **File name** field, type `My Admin Console`.
5. [ ] The location should default to `C:\Users\Administrator\AppData\Roaming\Microsoft\MMC\` or similar.
6. [ ] Click **Save**.
7. [ ] The console is now saved. You can access this custom console in the future by:
   - Running MMC and opening it from the saved location
   - Or creating a shortcut to it

::: success
**Results**: After completing this task, you have created and saved a custom MMC console that you can reuse.
:::

## Exercise 3: Using Event Viewer to Monitor Server Health

::: secondary
**Scenario**

Event Viewer is a critical tool for monitoring server health and troubleshooting problems. You will explore the Event Viewer snap-in to understand how to view and interpret server events.
:::

### Task 1: Open Event Viewer

1. [ ] In your custom console, click on **Event Viewer** in the left panel.
2. [ ] Click on the **+** symbol next to **Event Viewer** to expand it if needed.
3. [ ] Click on **Windows Logs** to expand it.
4. [ ] You will see four log types:
   - **System**: Events related to system components, drivers, and system services
   - **Security**: Events related to user logins and security-relevant actions
   - **Application**: Events generated by applications running on the server
   - **Setup**: Events related to Windows installation and updates
5. [ ] Click on **System** to view system events.

::: warning
**Note**: If the System log is empty or shows few events, this is normal on a fresh server. Events accumulate over time as the server runs.
:::

### Task 2: Examine System Events

1. [ ] The right panel will show a list of system events. Each row contains:
   - **Level**: Information (blue circle), Warning (yellow triangle), or Error (red circle)
   - **Date and Time**: When the event occurred
   - **Source**: What component generated the event
   - **Event ID**: A unique identifier for the event type
   - **Task Category**: The category of the event
2. [ ] Click on one of the events to select it. If available, a details pane will appear below showing:
   - Event title
   - Event level
   - Date and Time
   - Event ID
   - Source
   - Full event details and description

::: success
**Results**: After completing this task, you can interpret system events and understand what is happening on your server.
:::

### Task 3: View Security Events

1. [ ] Click on **Security** in the Windows Logs section.
2. [ ] The right panel will show security events. These include:
   - Logon events (when users log in or out)
   - Privilege escalation (when users request administrator access)
   - File access (if auditing is enabled)
3. [ ] You may see entries such as:
   - **Event ID 4688**: A process was created
   - **Event ID 4672**: Special privileges assigned to a new logon
   - **Event ID 4624**: A user successfully logged in
4. [ ] Click on an event to view its details.

::: warning
**Note**: Security events are particularly important for monitoring access to your server and detecting suspicious activity.
:::

::: success
**Results**: After completing this task, you understand how to review security events to monitor server access.
:::

## Exercise 4: Using Device Manager

::: secondary
**Scenario**

Device Manager allows you to view and manage hardware devices on your server. You will examine the hardware configuration and understand how to manage device drivers.
:::

### Task 1: Open Device Manager

1. [ ] In your custom console, click on **Device Manager** in the left panel.
2. [ ] The right panel will show your device configuration organized in categories:
   - **Batteries** (if applicable)
   - **Computer** (the system itself)
   - **Disk drives** (storage devices)
   - **Display adapters** (graphics cards)
   - **IDE ATA/ATAPI controllers** (storage controllers)
   - **Network adapters** (network devices)
   - **Storage controllers** (SCSI and RAID controllers if present)
   - **System devices** (various system devices)

::: success
**Results**: After completing this task, you can see what hardware devices are installed on the server.
:::

### Task 2: Examine Specific Device Categories

1. [ ] Click on the **+** symbol next to **Network adapters** to expand that category.
2. [ ] You will see the network adapter(s) installed on LON-SRV1. Typically, you might see:
   - Ethernet adapter (such as Intel 82574L Gigabit Network Connection or VMware adapter depending on your virtual environment)
3. [ ] Right-click on the network adapter and click **Properties**.
4. [ ] The network adapter properties dialog will open showing:
   - **General tab**: Device name, status (should be "This device is working properly")
   - **Driver tab**: Driver details including version and provider
   - **Details tab**: Advanced properties of the device
5. [ ] Click on the **Driver** tab to see driver information:
   - **Driver Provider**: The manufacturer
   - **Driver Date**: When the driver was released
   - **Driver Version**: The version number
6. [ ] Click **Cancel** to close this dialog.

::: success
**Results**: After completing this task, you understand how to view device information and drivers in Device Manager.
:::

### Task 3: Check Disk Configuration

1. [ ] Collapse Network adapters by clicking the **-** symbol next to it.
2. [ ] Click on the **+** symbol next to **Disk drives** to expand that category.
3. [ ] You will see the disk drive(s) in your virtual machine. Typically you might see:
   - One or more disk drives depending on your lab configuration
   - The drives will have names like "QEMU HARDDISK" (KVM/QEMU virtual machine) or "VMware Virtual SATA Hard Drive" (VMware virtual machine) depending on your virtual platform
4. [ ] This confirms that your system storage is functioning properly.

::: success
**Results**: After completing this task, you can verify that storage devices are properly recognized by the system.
:::

## Exercise 5: Verification and Saving Your Work

::: secondary
**Scenario**

Before completing the lab, you will save your custom console so you can use it in future labs.
:::

### Task 1: Ensure Your Console is Saved

1. [ ] Click on **File** menu.
2. [ ] You should see "My Admin Console" in the recent items or in the saved consoles list.
3. [ ] If not already saved, click **Save** to save your custom console.
4. [ ] Close the custom console window by clicking the **X** button.

::: success
**Results**: You have successfully completed Lab 0301. You now understand:
- How to access MMC snap-ins through Server Manager
- How to create custom MMC consoles with specific snap-ins
- How to use Event Viewer to monitor system and security events
- How to use Device Manager to view hardware configuration
- How to view network adapter and disk configuration

In future labs, you will use these MMC snap-ins to configure network settings, manage storage, and monitor server health.
:::
