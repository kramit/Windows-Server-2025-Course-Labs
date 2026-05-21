# Practice Lab 0201: Using Remote Administration Tools and PowerShell

## Summary

::: secondary
In this lab, you will use Server Manager, PowerShell remoting, and administrator group membership checks to manage Windows Server remotely. You will connect to multiple servers from one console, run commands against a remote server, and review how administrative access is controlled.
:::

## Exercise 1: Adding Multiple Servers to Server Manager

::: secondary
**Scenario**

You need to manage multiple servers from a single administrative console. You will add LON-DC1 and LON-SRV1 to Server Manager so you can view and manage them from one location.
:::

### Task 1: Connect to LON-SRV1 and Open Server Manager

1. [ ] In the lab environment, select **HOME**.
2. [ ] From the server list, select **LON-SRV1**.
3. [ ] In the **Username** field, enter the username shown for the selected VM on the **HOME** tab.
4. [ ] In the **Password** field, enter the password shown for the selected VM on the **HOME** tab.
5. [ ] In the **Tools** section, turn on **Enhanced mode**.
6. [ ] Verify that the virtual machine display adjusts to use the best screen resolution for your monitor.
7. [ ] Wait for the Windows Server desktop to load.
8. [ ] Select the **Server Manager** icon on the taskbar.
9. [ ] Verify that **Server Manager** opens to the **Dashboard**.

### Task 2: Add Servers to Server Manager

1. [ ] In **Server Manager**, select **Manage**.
2. [ ] Select **Add Servers**.
3. [ ] Verify that the **Active Directory** tab is selected.
4. [ ] Select **Find Now**.
5. [ ] Wait for the list of domain computers to appear.

::: warning
**Note**: If the search does not return results immediately, wait a few seconds and select **Find Now** again.
:::

6. [ ] In the computer list, select **LON-DC1**.
7. [ ] Select **Add >**.
8. [ ] Verify that **LON-DC1** appears in the **Selected** list.
9. [ ] In the computer list, select **LON-SRV1**.
10. [ ] Select **Add >**.
11. [ ] Verify that **LON-SRV1** appears in the **Selected** list.
12. [ ] Select **OK**.
13. [ ] Wait while Server Manager queries the selected servers.

### Task 3: Verify Managed Servers

1. [ ] In **Server Manager**, review the left navigation pane.
2. [ ] Verify that **LON-DC1** appears in the server list.
3. [ ] Verify that **LON-SRV1** appears in the server list.
4. [ ] Select **LON-DC1**.
5. [ ] Verify that the details pane shows information for **LON-DC1**, such as the computer name, domain, operating system, and installed roles.
6. [ ] Select **LON-SRV1**.
7. [ ] Verify that the details pane shows information for **LON-SRV1**.

::: success
**Results**: After completing this exercise, you will have added LON-DC1 and LON-SRV1 to Server Manager for centralized administration.
:::

## Exercise 2: Using PowerShell for Remote Administration

::: secondary
**Scenario**

You need to run administrative commands on LON-DC1 without opening a separate Remote Desktop session. You will use PowerShell remoting from LON-SRV1 to query information from LON-DC1.
:::

### Task 1: Open PowerShell as Administrator

1. [ ] On LON-SRV1, open **Start**.
2. [ ] Search for **Terminal**.
3. [ ] Select **Run as administrator** for **Terminal**.
4. [ ] If prompted by **User Account Control**, select **Yes**.
5. [ ] Verify that an elevated PowerShell session opens.

::: warning
**Note**: If **Terminal** is not available, search for **Windows PowerShell** and select **Run as administrator**.
:::

### Task 2: Test a Local PowerShell Command

1. [ ] Run the following command to display local computer information.

```powershell
Get-ComputerInfo -Property CsComputerName,CsDomain,OsVersion
```

2. [ ] Verify that **CsComputerName** shows `LON-SRV1`.
3. [ ] Verify that **CsDomain** shows `CONTOSO`.
4. [ ] Verify that **OsVersion** displays the Windows Server version.

### Task 3: Execute a Remote PowerShell Command

1. [ ] Run the following command to query computer information from LON-DC1.

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-ComputerInfo -Property CsComputerName,CsDomain }
```

2. [ ] Wait for PowerShell to establish the remote connection.
3. [ ] Verify that **CsComputerName** shows `LON-DC1`.
4. [ ] Verify that **CsDomain** shows `CONTOSO`.

::: warning
**Note**: If you receive a remoting error, PowerShell remoting may not be enabled or reachable on LON-DC1. Ask your instructor before changing remoting settings.
:::

### Task 4: Query Remote Services

1. [ ] Run the following command to display running services on LON-DC1.

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name,DisplayName,Status | Format-Table }
```

2. [ ] Review the returned service list.
3. [ ] Verify that services such as **ADWS**, **Dns**, **EventLog**, or **NTDS** appear if those roles are installed on LON-DC1.
4. [ ] Confirm that the command output is from LON-DC1 and not the local LON-SRV1 session.

::: success
**Results**: After completing this exercise, you will have used PowerShell remoting to run commands and retrieve service information from LON-DC1.
:::

## Exercise 3: Using Windows Admin Center

::: secondary
**Scenario**

You need a browser-based tool for managing Windows Server. You will download and install Windows Admin Center on LON-SRV1, then open it and review the management interface.
:::

### Task 1: Download Windows Admin Center

1. [ ] Return to the elevated PowerShell session on LON-SRV1.
2. [ ] Run the following command to download the Windows Admin Center installer from Microsoft.

```powershell
$parameters = @{
    Source = "https://aka.ms/WACdownload"
    Destination = "$env:USERPROFILE\Downloads\WindowsAdminCenter.exe"
}
Start-BitsTransfer @parameters
```

3. [ ] Wait for the download to complete.
4. [ ] Run the following command to verify that the installer was downloaded.

```powershell
Test-Path "$env:USERPROFILE\Downloads\WindowsAdminCenter.exe"
```

5. [ ] Verify that the command returns `True`.


### Task 2: Install Windows Admin Center

1. [ ] Run the following command to start the Windows Admin Center installer.

```powershell
Start-Process "$env:USERPROFILE\Downloads\WindowsAdminCenter.exe"
```

2. [ ] On **Welcome to the Windows Admin Center setup wizard**, select **Next**.
3. [ ] On **License Terms and Privacy Statement**, select **I accept these terms and understand the privacy statement** if you agree.
4. [ ] Select **Next**.
5. [ ] On **Select installation mode**, select **Express setup**.
6. [ ] Select **Next**.
7. [ ] On **Select TLS certificate**, select the option to generate a self-signed certificate if no trusted certificate is available.
8. [ ] Select **Next**.
9. [ ] On **Automatic updates**, keep the recommended option selected.
10. [ ] Select **Next**.
11. [ ] On **Send diagnostic data to Microsoft**, select the option required by your instructor.
12. [ ] Select **Next**.
13. [ ] On **Ready to install**, select **Install**.
14. [ ] Wait for the installation to finish.
15. [ ] Select **Start Windows Admin Center**.
16. [ ] Select **Finish**.

::: warning
**Note**: A self-signed certificate is suitable for this lab environment. Production deployments should use a certificate from a trusted certificate authority.
:::

### Task 3: Open Windows Admin Center

1. [ ] Verify that your browser opens to the Windows Admin Center sign-in page after the install is complete.
2. [ ] Confirm the certifice warnings due to a self signed cert
3. [ ] Log in with Contoso\Adminstrator and Pa55w.rd
4. [ ] If prompted with a certificate warning, continue to the site for this lab environment.
5. [ ] Sign in with the administrator credentials shown for the selected VM on the **HOME** tab.
6. [ ] Verify that the **All connections** page appears.
7. [ ] Review the available server connections.
8. [ ] Select a listed server  (lon-svr1 should be listed).
9. [ ] Review the available management tools for that server.

### Task 4: Use Windows Admin Center

1. [ ] After selecting lon-svr1 select **Roles and Features**
2. [ ] Mouse over **Web Server (IIS)** select the check box
3. [ ] Click **+ Install at the top**
4. [ ] Select yes to continue the install
5. [ ] Retun to the overview at the top to observe the computer usage in real time for the install
6. [ ] Select **Powershell** to open PowerShell in the browser session
7. [ ] Type get-process to see the current active threads on the computer
8. [ ] Continue to explore the Windows Admin Center, this is a lab environment so you can click around without breaking anything. 

### Task 5: Use Windows Admin Center to add another server

1. [ ] In Windows Admin Centre, click all connection in the dropdown box on the top left, it is next to the "Windows Admin Centre" text
2. [ ] Select **All Connections**
3. [ ] Select **+ Add**
4. [ ] Under **Servers** Press **Add**
5. [ ] Type **LON-DC1** and press **Add**
6. [ ] This will return you to the list of servers and you can now select LON-DC1 and explore it remotely using Windows Admin Centre.



::: warning
**Note**: If Windows Admin Center does not open automatically, open **Start**, search for **Windows Admin Center**, and select it.
:::

::: success
**Results**: After completing this exercise, you will have downloaded, installed, and opened Windows Admin Center on LON-SRV1.
:::

## Exercise 4: Reviewing Role-Based Administration

::: secondary
**Scenario**

You need to understand which users and groups can administer a server. You will review the local Administrators group on LON-SRV1 and identify domain-based administrative membership.
:::

### Task 1: Review Local Administrator Group Membership

1. [ ] Return to the elevated PowerShell session on LON-SRV1.
2. [ ] Run the following command to view members of the local **Administrators** group.

```powershell
Get-LocalGroupMember -Group "Administrators"
```

3. [ ] Review the returned users and groups.
4. [ ] Verify whether **CONTOSO\Domain Admins** appears in the output.
5. [ ] Verify whether **CONTOSO\Administrator** appears in the output.
6. [ ] Record any additional administrator entries required by your instructor.

::: warning
**Note**: The exact group membership may differ depending on the lab image, domain policy, or instructor configuration.
:::

::: success
**Results**: After completing this exercise, you will have reviewed how the local Administrators group controls administrative access on LON-SRV1.
:::

## Exercise 5: Verifying Remote Administration Skills

::: secondary
**Scenario**

You have used several Windows Server administration methods. You will verify that you can identify when to use each method and confirm the key outcomes from this lab.
:::

### Task 1: Verify Lab Outcomes

1. [ ] In **Server Manager**, verify that **LON-DC1** is listed as a managed server.
2. [ ] In **Server Manager**, verify that **LON-SRV1** is listed as a managed server.
3. [ ] In PowerShell, run the following command to confirm remote command execution still works.

```powershell
Invoke-Command -ComputerName LON-DC1 -ScriptBlock { hostname }
```

4. [ ] Verify that the command returns `LON-DC1`.
5. [ ] Identify **Server Manager** as the graphical tool used for multi-server management.
6. [ ] Identify **PowerShell remoting** as the command-line method used to run commands on remote servers.
7. [ ] Identify the local **Administrators** group as one place where server administrative access is controlled.
8. [ ] Close any open administration windows if instructed by your instructor.

::: success
**Results**: After completing this exercise, you will have verified the core remote administration methods used to manage Windows Server in this lab.
:::


