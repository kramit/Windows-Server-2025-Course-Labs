# Practice Lab 0201: Using Remote Administration Tools and PowerShell

## Summary

::: secondary
In this lab, you will use multiple administration tools to manage Windows Server remotely. You will connect to servers using Server Manager's multi-server administration, use PowerShell for remote command execution, and understand the differences between local and remote administration. This lab demonstrates why remote administration is the standard approach for Windows Server management.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0101 (Exploring Windows Server Interface and Basic Configuration)
- Administrator access to LON-DC1 and LON-SRV1
- PowerShell execution policy understanding (basic)
:::

## Exercise 1: Adding Multiple Servers to Server Manager

::: secondary
**Scenario**

You are managing multiple servers in your environment. Instead of connecting to each server individually, you can manage them all from a single Server Manager window. You need to add LON-DC1 (the domain controller) and LON-SRV1 to the server management list.
:::

### Task 1: Add Servers to Server Manager

1. [ ] Connect to **LON-SRV1** using Remote Desktop (press **Windows key + R**, type `mstsc`, and connect to `LON-SRV1.contoso.com`).
2. [ ] Open **Server Manager** by clicking its icon in the taskbar.
3. [ ] Look at the top of Server Manager window. Click on **Manage** in the menu bar.
4. [ ] A dropdown menu will appear. Click on **Add Servers**.
5. [ ] A window titled **Add Servers** will open with several tabs at the top:
   - **Active Directory**
   - **DNS**
   - **Import**
6. [ ] Make sure the **Active Directory** tab is selected (it should be by default).
7. [ ] In the search field, you will see **Location** with your current domain.
8. [ ] Click on **Find Now** button. A list of computers in the CONTOSO domain will appear below.

::: warning
**Note**: If the search does not return results immediately, wait a few seconds. The domain search can take time on first query.
:::

### Task 2: Select and Add Servers

1. [ ] In the list of computers that appeared, look for **LON-DC1** (the domain controller).
2. [ ] Click on **LON-DC1** to select it (it will be highlighted in blue).
3. [ ] Click the **Add >** button to move it to the **Selected** panel on the right.
4. [ ] LON-DC1 should now appear in the **Selected** panel on the right side of the window.
5. [ ] Now look for **LON-SRV1** in the computer list on the left.
6. [ ] Click on **LON-SRV1** to select it.
7. [ ] Click the **Add >** button to move it to the **Selected** panel.
8. [ ] Both LON-DC1 and LON-SRV1 should now be in the **Selected** panel.
9. [ ] Click **OK** at the bottom of the window.

::: warning
**Note**: Server Manager will attempt to connect to these servers. This may take 30-60 seconds as it queries their status.
:::

::: success
**Results**: After completing this task, LON-DC1 and LON-SRV1 will be added to your Server Manager server list. You can now manage both servers from one interface.
:::

### Task 3: Verify Servers Appear in Server Manager

1. [ ] Server Manager will return to the main dashboard.
2. [ ] On the left side, you should now see:
   - Local Server (your current connection)
   - LON-DC1 (the domain controller you just added)
   - LON-SRV1 (the member server you just added)
3. [ ] Click on **LON-DC1** in the left panel.
4. [ ] The right panel will show information about LON-DC1 including:
   - Computer name
   - Domain
   - Operating system
   - Any installed roles
5. [ ] Click on **LON-SRV1** in the left panel.
6. [ ] The right panel will now show information about LON-SRV1.

::: success
**Results**: After completing this task, you can see information about all managed servers in a single Server Manager window. This is the foundation of multi-server administration.
:::

## Exercise 2: Using PowerShell for Remote Administration

::: secondary
**Scenario**

PowerShell is the modern command-line tool for Windows Server administration. You will use PowerShell remoting to execute commands on LON-DC1 from your current connection to LON-SRV1. This demonstrates remote command execution without needing a separate Remote Desktop session.
:::

### Task 1: Open PowerShell

1. [ ] On LON-SRV1, right-click on the **Windows Start button** (bottom left) or press **Windows key + X**.
2. [ ] Click on **Terminal (Admin)** or **Windows PowerShell (Admin)** (the option name may vary in Windows Server 2025).

::: warning
**Note**: It's critical that you open PowerShell **as Administrator**. If you just see "Terminal" or "PowerShell" without "(Admin)", right-click it and choose **Run as Administrator**.
:::

3. [ ] A PowerShell window will open. You should see a blue background with white text.
4. [ ] The prompt will show something like `PS C:\Windows\System32>` indicating you are at the PowerShell prompt and ready to type commands.

::: success
**Results**: After completing this task, you have opened PowerShell as Administrator and are ready to execute commands.
:::

### Task 2: Test Local Commands

Before using remote commands, you'll test a simple local command to ensure PowerShell is working:

1. [ ] In the PowerShell window, type the following command exactly:

```powershell
Get-ComputerInfo -Property CsComputerName,CsDomain,OsVersion
```

2. [ ] Press **Enter** on your keyboard.
3. [ ] PowerShell will execute the command and return information about your local computer:
   - **CsComputerName**: Should show `LON-SRV1`
   - **CsDomain**: Should show `CONTOSO`
   - **OsVersion**: Should show information about Windows Server 2025
4. [ ] This confirms PowerShell is working and you have the correct permissions.

::: success
**Results**: After completing this task, you have verified that local PowerShell commands execute successfully.
:::

### Task 3: Execute a Remote Command

Now you will execute a command on LON-DC1 from your PowerShell session on LON-SRV1:

1. [ ] In the PowerShell window, type the following command exactly:

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-ComputerInfo -Property CsComputerName,CsDomain }
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will connect to LON-DC1 and execute the command remotely. This may take 5-10 seconds as it establishes the remote connection.
4. [ ] The output should show:
   - **CsComputerName**: `LON-DC1`
   - **CsDomain**: `CONTOSO`
5. [ ] This confirms that you can execute commands on a remote server without opening a separate Remote Desktop session.

::: warning
**Note**: If you receive an error message, it may indicate that PowerShell remoting is not enabled on LON-DC1. Contact your instructor if this occurs.
:::

::: success
**Results**: After completing this task, you have successfully executed a command on a remote server using PowerShell remoting. This is a key administration technique for Windows Server environments.
:::

### Task 4: Query Remote Services

You will now check what services are running on LON-DC1 using a remote PowerShell command:

1. [ ] In PowerShell, type the following command:

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Service | Where-Object {$_.Status -eq 'Running'} | Select-Object Name,DisplayName,Status | Format-Table }
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will query LON-DC1 and display a list of all running services. You should see services like:
   - ADWS (Active Directory Web Services)
   - Dns (DNS Server)
   - EventLog
   - NTDS (Active Directory Domain Services)
   - Others depending on roles installed
4. [ ] This demonstrates how you can gather information from remote servers without being directly connected to them.

::: success
**Results**: After completing this task, you understand how to use PowerShell remoting to query and retrieve information from remote servers.
:::

## Exercise 3: Using Windows Admin Center (Optional)

::: secondary
**Scenario**

Windows Admin Center is a modern web-based management tool for Windows Server. If your lab environment has Windows Admin Center installed, you will use it to manage your servers from a browser-based interface. This is optional and depends on your lab setup.
:::

### Task 1: Check for Windows Admin Center

1. [ ] Return to Server Manager on LON-SRV1.
2. [ ] In the **Tools** menu at the top, scroll down to find **Windows Admin Center**.
3. [ ] If **Windows Admin Center** appears in the menu, click on it.
4. [ ] Windows Admin Center will open in your default web browser. It typically appears as a secure connection (HTTPS) to `https://localhost:6516` or similar.

::: warning
**Note**: If Windows Admin Center is not installed in your lab environment, this task is optional. Ask your instructor if it should be available.
:::

5. [ ] If prompted for credentials, log in with your domain administrator account.
6. [ ] You should see a dashboard with available servers listed.
7. [ ] Click on a server name to see management options for that server.

::: success
**Results**: After completing this task, you have explored Windows Admin Center if it's available in your environment. This tool provides an alternative to Server Manager and RDP for modern server management.
:::

## Exercise 4: Understanding Role-Based Administration

::: secondary
**Scenario**

Windows Server uses role-based administration (RBAC) to control who can perform specific administrative tasks. You will examine the concept of built-in administrator groups and understand how security is managed.
:::

### Task 1: Review Administrator Groups

1. [ ] Return to your PowerShell window on LON-SRV1 (or open a new one with **Windows key + X** > **Terminal (Admin)**).
2. [ ] Type the following command to view members of the local Administrators group:

```powershell
Get-LocalGroupMember -Group "Administrators"
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will display the local administrators on LON-SRV1. You should see entries like:
   - CONTOSO\Domain Admins (the domain administrator group)
   - CONTOSO\Administrator (the domain administrator account)
   - Possibly other administrators depending on your configuration

::: success
**Results**: After completing this task, you understand how administrator groups control who can perform administrative tasks.
:::

## Exercise 5: Verification and Summary

::: secondary
**Scenario**

You have now explored multiple administration methods for Windows Server. Before completing the lab, verify your understanding of these approaches.
:::

### Task 1: Summary of Administration Tools

You have successfully used three different administration methods:

1. **Server Manager**: Graphical multi-server management tool
   - Add multiple servers for centralized monitoring
   - View server roles and features
   - Manage servers from a single console

2. **PowerShell Remoting**: Command-line remote administration
   - Execute commands on remote servers without RDP
   - Automate administrative tasks
   - Retrieve information quickly from multiple servers

3. **Windows Admin Center** (if available): Modern web-based management
   - Browser-based interface
   - Alternative to Remote Desktop
   - Modern replacement for some Server Manager functions

4. **Role-Based Administration**: Security and access control
   - Administrator groups control who can perform tasks
   - Domain admins vs. local admins
   - Security principle of least privilege

::: success
**Results**: You have successfully completed Lab 0201. You now understand multiple methods for administering Windows Server:
- Using Server Manager to manage multiple servers
- Using PowerShell for remote command execution
- Understanding role-based administration
- Using modern tools like Windows Admin Center

In future labs, you will use these administration methods to configure and manage Windows Server features and services. PowerShell will be your primary tool for most administrative tasks.
:::
