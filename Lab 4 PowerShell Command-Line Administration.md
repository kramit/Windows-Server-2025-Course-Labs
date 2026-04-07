# Practice Lab 0401: PowerShell Command-Line Administration

## Summary

::: secondary
In this lab, you will explore PowerShell as a command-line administration tool. You will learn to use cmdlets, pipe commands together, retrieve system information, and understand why PowerShell is the modern standard for Windows Server administration. This lab builds on Lab 0201 and provides hands-on experience with essential PowerShell skills.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0201 (Using Remote Administration Tools and PowerShell)
- Administrator access to LON-SRV1
- Basic understanding of PowerShell from the previous labs
:::

## Exercise 1: Understanding PowerShell Basics

::: secondary
**Scenario**

PowerShell uses cmdlets (pronounced "command-lets") which are small, single-purpose tools that can be combined together. You will learn how to execute basic PowerShell commands and understand the syntax.
:::

### Task 1: Open PowerShell and Check Version

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Right-click on the **Windows Start button** or press **Windows key + X**.
3. [ ] Click on **Terminal (Admin)** or **Windows PowerShell (Admin)** - choose the one that appears.

::: warning
**Note**: It is critical to open PowerShell as Administrator. If you do not see "(Admin)" in the title, close it and right-click to select "Run as administrator".
:::

4. [ ] A PowerShell window with a blue background will open.
5. [ ] Type the following command to check the PowerShell version:

```powershell
$PSVersionTable.PSVersion
```

6. [ ] Press **Enter**.
7. [ ] PowerShell will display the version number. You should see version 5.1 or higher (PowerShell 7+ if newer versions are installed).

::: success
**Results**: After completing this task, you have confirmed that PowerShell is running and verified the version.
:::

### Task 2: Execute Your First Cmdlet

A cmdlet has the format **Verb-Noun** (for example, Get-Process, Set-Service):

1. [ ] In PowerShell, type the following command exactly:

```powershell
Get-ChildItem
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will list the contents of the current directory (C:\Windows\System32\). You will see folders and files displayed as a table with columns:
   - **Mode**: File type (d for directory, a for archive file)
   - **LastWriteTime**: When the file was last modified
   - **Length**: File size in bytes
   - **Name**: The filename or folder name
4. [ ] This is the PowerShell equivalent of the `dir` command in CMD.

::: success
**Results**: After completing this task, you have executed your first PowerShell cmdlet and seen its output.
:::

### Task 3: Use Help to Learn About Cmdlets

PowerShell includes built-in help for all cmdlets:

1. [ ] Type the following command:

```powershell
Get-Help Get-ChildItem
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display the help information for Get-ChildItem, including:
   - **SYNOPSIS**: One-line description of what the cmdlet does
   - **SYNTAX**: How to use the cmdlet and what parameters it accepts
   - **DESCRIPTION**: Detailed explanation
   - **PARAMETERS**: Details about each parameter
   - **EXAMPLES**: Example usage
4. [ ] You can scroll through the help using the spacebar or arrow keys. Press **Q** to exit help.

::: success
**Results**: After completing this task, you know how to access PowerShell help to learn about any cmdlet.
:::

## Exercise 2: Working with System Information

::: secondary
**Scenario**

You need to gather information about your server such as computer name, operating system version, installed updates, and processes running. PowerShell cmdlets make this quick and easy.
:::

### Task 1: Get Computer Information

1. [ ] In PowerShell, type the following command:

```powershell
Get-ComputerInfo -Property CsComputerName, CsDomain, OsVersion, OsProductType
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display:
   - **CsComputerName**: The computer name (LON-SRV1)
   - **CsDomain**: The domain name (CONTOSO)
   - **OsVersion**: The Windows version (10.0.26200 or similar for Windows Server 2025)
   - **OsProductType**: The OS type (ServerNT indicates a server operating system)

::: success
**Results**: After completing this task, you can quickly retrieve detailed system information with a single command.
:::

### Task 2: Get Operating System Information

1. [ ] Type the following command:

```powershell
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, InstallDate
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display Windows Server operating system information:
   - **Caption**: OS name (Windows Server 2025)
   - **Version**: Version number
   - **BuildNumber**: Build number (for example, 26200)
   - **InstallDate**: When Windows was installed
4. [ ] This command demonstrates piping (the **|** symbol) which sends output from one cmdlet to another.

::: success
**Results**: After completing this task, you understand how to retrieve detailed OS information and use piping in PowerShell.
:::

### Task 3: View Installed Hotfixes and Updates

1. [ ] Type the following command:

```powershell
Get-HotFix | Select-Object HotFixID, Description, InstalledOn | Format-Table
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display a list of all installed Windows updates (hotfixes) with columns showing:
   - **HotFixID**: The KB article number (for example, KB5001234)
   - **Description**: Description of the update
   - **InstalledOn**: Date the update was installed
4. [ ] If no hotfixes are shown, this is normal on a freshly installed server.

::: success
**Results**: After completing this task, you can view all installed updates and patches on your server.
:::

## Exercise 3: Managing Services with PowerShell

::: secondary
**Scenario**

You need to manage Windows services using PowerShell. You will view running services, check service status, and understand how to start and stop services (though you will not actually stop any critical services in this lab).
:::

### Task 1: Get Running Services

1. [ ] Type the following command to see all running services:

```powershell
Get-Service | Where-Object {$_.Status -eq 'Running'} | Select-Object Name, DisplayName, Status | Format-Table -AutoSize
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display a list of all running services, showing:
   - **Name**: Internal service name (for example, "Dnsclient")
   - **DisplayName**: Friendly service name (for example, "DNS Client")
   - **Status**: Should show "Running" for all listed services
4. [ ] The list will scroll. Use spacebar to see more or press **Q** to stop the output.

::: success
**Results**: After completing this task, you can view all running services with a single PowerShell command.
:::

### Task 2: Check Specific Service Status

1. [ ] Check the status of DNS Client service:

```powershell
Get-Service -Name DnsClient | Select-Object Name, DisplayName, Status, StartType
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display:
   - **Name**: DnsClient
   - **DisplayName**: DNS Client
   - **Status**: Running
   - **StartType**: Automatic (means it starts when the server boots)

::: success
**Results**: After completing this task, you can check the status and startup type of specific services.
:::

### Task 3: View Stopped Services

1. [ ] Type the following command to see all stopped services:

```powershell
Get-Service | Where-Object {$_.Status -eq 'Stopped'} | Select-Object Name, DisplayName, StartType | Format-Table
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display stopped services. You may see services like:
   - **Bluetooth Support Service** (stopped)
   - **Remote Access Connection Manager** (stopped)
   - **Routing and Remote Access** (stopped)
   - Other optional services that are not running

::: warning
**Note**: Do NOT attempt to start or stop services in this lab without instructor approval. Many services are interdependent and stopping the wrong service can cause server problems.
:::

::: success
**Results**: After completing this task, you can identify which services are installed but not currently running.
:::

## Exercise 4: Managing Processes with PowerShell

::: secondary
**Scenario**

A process is a running instance of a program. You will view processes, identify resource usage, and understand how to find specific processes.
:::

### Task 1: View All Running Processes

1. [ ] Type the following command:

```powershell
Get-Process | Select-Object Name, ID, Handles, WorkingSet | Format-Table -AutoSize
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display a list of all running processes with columns showing:
   - **Name**: Process name (for example, "System", "csrss", "services")
   - **ID**: Process ID (PID) - a unique identifier for each process
   - **Handles**: Number of handles (connections to resources)
   - **WorkingSet**: Memory used by the process in bytes
4. [ ] The output will be long. Press **Q** to stop scrolling.

::: success
**Results**: After completing this task, you can see all running processes and their resource usage.
:::

### Task 2: Find Memory-Hungry Processes

1. [ ] Type the following command to find the top processes by memory usage:

```powershell
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name, WorkingSet, @{Name="MemoryMB";Expression={$_.WorkingSet/1MB}} | Format-Table
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display the top 5 processes using the most memory, showing:
   - **Name**: Process name
   - **WorkingSet**: Memory in bytes
   - **MemoryMB**: Memory converted to megabytes for easier reading
4. [ ] This helps identify if any process is using excessive memory.

::: success
**Results**: After completing this task, you can identify which processes are using the most memory on your server.
:::

## Exercise 5: Using PowerShell Help and Aliases

::: secondary
**Scenario**

PowerShell includes aliases (shortcuts) for common commands and comprehensive help system. Learning these will make your work more efficient.
:::

### Task 1: Understand Common Aliases

1. [ ] PowerShell recognizes many common CMD.EXE commands as aliases. Type:

```powershell
dir
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will display the current directory contents. This works because **dir** is an alias for **Get-ChildItem**.
4. [ ] Try another alias:

```powershell
cls
```

5. [ ] Press **Enter**.
6. [ ] The screen clears. This is because **cls** is an alias for **Clear-Host**.
7. [ ] Get a list of all PowerShell aliases:

```powershell
Get-Alias | Format-Table Name, Definition | Format-Table -AutoSize
```

8. [ ] Press **Enter**.
9. [ ] PowerShell will show common aliases such as:
   - **gci** → Get-ChildItem
   - **gps** → Get-Process
   - **gsv** → Get-Service
   - **dir** → Get-ChildItem
   - **ls** → Get-ChildItem

::: success
**Results**: After completing this task, you understand that PowerShell supports aliases for faster command entry.
:::

### Task 2: Create Your Own Alias (Optional)

1. [ ] Type the following command to create a temporary alias:

```powershell
Set-Alias -Name gsi -Value Get-Service
```

2. [ ] Press **Enter**.
3. [ ] Now you can type **gsi** to quickly get services:

```powershell
gsi | Where-Object {$_.Status -eq 'Running'} | Select-Object Name, DisplayName | Format-Table
```

4. [ ] Press **Enter**.
5. [ ] This will list all running services using your new alias.

::: warning
**Note**: This alias only exists in the current PowerShell session. When you close PowerShell, the alias disappears. To make aliases permanent, you need to add them to your PowerShell profile.
:::

::: success
**Results**: After completing this task, you can create PowerShell aliases for commands you use frequently.
:::

## Exercise 6: Verification and Summary

::: secondary
**Scenario**

You have now mastered basic PowerShell commands for Windows Server administration.
:::

### Task 1: Review What You've Learned

You have successfully:

1. **Opened PowerShell as Administrator** - The first step for all administrative tasks
2. **Executed basic cmdlets** - Get-ChildItem, Get-ComputerInfo, Get-Service
3. **Used piping** - Sending output from one cmdlet to another using **|**
4. **Filtered results** - Using Where-Object to show only what you need
5. **Formatted output** - Using Format-Table and Select-Object to show only relevant columns
6. **Gathered system information** - Computer name, OS version, installed updates
7. **Managed services** - Viewed running and stopped services, checked status
8. **Identified resource usage** - Found processes using the most memory
9. **Used aliases** - Discovered shortcuts for common commands
10. **Found help** - Used Get-Help to learn about cmdlets

::: success
**Results**: You have successfully completed Lab 0401. You now have practical PowerShell skills for Windows Server administration. In future labs, you will use PowerShell to:
- Install and remove server roles and features
- Configure network settings
- Manage Active Directory users and groups
- Monitor and troubleshoot server problems
- Automate repetitive administrative tasks

PowerShell is your most powerful tool for Windows Server administration, and these skills will serve you throughout your career.
:::
