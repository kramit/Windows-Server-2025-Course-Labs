# Practice Lab 0501: Installing Server Roles and Managing Firewall

## Summary

::: secondary
In this lab, you will install a Windows Server role (Web Server/IIS) and manage Windows Firewall rules. You will use both Server Manager and PowerShell to accomplish these tasks. This lab demonstrates core administrative tasks that you will perform regularly.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0401 (PowerShell Command-Line Administration)
- Administrator access to LON-SRV1
- Understanding of Server Manager and PowerShell
:::

## Exercise 1: Installing the Web Server Role

::: secondary
**Scenario**

Your organization needs to host web content on Windows Server. You need to install the Web Server (IIS) role on LON-SRV1 using Server Manager. IIS (Internet Information Services) is a core Windows Server role.
:::

### Task 1: Open Server Manager and Add Roles

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Open **Server Manager** by clicking its icon in the taskbar.
3. [ ] On the Server Manager dashboard, look in the **Welcome to Server Manager** section.
4. [ ] Click the **Add roles and features** button (or look for it in the quick start section).
5. [ ] A wizard window titled **Add Roles and Features Wizard** will open.
6. [ ] You will see several steps at the top: **Before You Begin**, **Installation Type**, **Server Selection**, **Server Roles**, **Features**, **Confirmation**, and **Results**.
7. [ ] The first page is **Before You Begin**. This is informational. Click **Next >** to proceed.

::: warning
**Note**: Do NOT select "Skip this page by default" unless your instructor asks you to. We will go through the full wizard.
:::

### Task 2: Select Installation Type

1. [ ] The **Installation Type** page will appear.
2. [ ] You will see two options:
   - **Role-based or Feature-based Installation** (should be selected)
   - **Remote Desktop Services installation**
3. [ ] Leave **Role-based or Feature-based Installation** selected (the default).
4. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have selected the standard installation type for server roles.
:::

### Task 3: Select the Destination Server

1. [ ] The **Server Selection** page will appear.
2. [ ] You will see a list of available servers. The current server (LON-SRV1) should be highlighted.
3. [ ] Click on **LON-SRV1.contoso.com** to select it (if not already selected).
4. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have selected LON-SRV1 as the destination for the role installation.
:::

### Task 4: Select the Web Server Role

1. [ ] The **Server Roles** page will appear showing a list of available roles.
2. [ ] Look through the list for **Web Server (IIS)**. The list may be long, so scroll if needed.
3. [ ] Click on the checkbox next to **Web Server (IIS)** to select it.
4. [ ] A dialog box will appear asking **Add features that are required for Web Server (IIS)?**
5. [ ] Click **Add Features** to include the required features automatically.
6. [ ] The **Web Server (IIS)** role should now be checked (marked with a checkmark).
7. [ ] Click **Next >** to continue.

::: warning
**Note**: The wizard automatically adds required features. You do not need to manually add them.
:::

::: success
**Results**: After completing this task, you have selected the Web Server (IIS) role for installation.
:::

### Task 5: Confirm Features and Install

1. [ ] The **Features** page may appear, showing additional features to install. These are required features that support IIS. You can simply click **Next >** to accept the defaults.
2. [ ] The **Confirmation** page will appear showing a summary of what will be installed:
   - **Web Server (IIS)** role
   - Required features and management tools
3. [ ] Review the list to confirm. If everything looks correct, click **Install**.
4. [ ] Installation will begin. You will see a **Results** page with a progress bar showing **Configuration in progress**.
5. [ ] Wait for installation to complete. This may take 2-5 minutes depending on server speed.
6. [ ] When installation is complete, you will see **Installation succeeded** message.
7. [ ] Click **Close** to complete the wizard.

::: warning
**Note**: Do not close the wizard or turn off the server during installation. Wait for the installation to complete successfully.
:::

::: success
**Results**: After completing this task, the Web Server (IIS) role has been successfully installed on LON-SRV1.
:::

### Task 6: Verify the Web Server Role is Installed

1. [ ] Server Manager will return to the main dashboard.
2. [ ] You should now see **Web Server (IIS)** listed under the **Roles** section on the Server Manager dashboard.
3. [ ] If you want to verify from command line, open PowerShell as Administrator and type:

```powershell
Get-WindowsFeature -Name Web-Server
```

4. [ ] Press **Enter**.
5. [ ] PowerShell will show:
   - **Display Name**: Web Server (IIS)
   - **Install State**: Installed
   - This confirms that the Web Server role has been successfully installed.

::: success
**Results**: After completing this task, you have confirmed that the Web Server (IIS) role is installed and functional.
:::

## Exercise 2: Managing Windows Firewall

::: secondary
**Scenario**

By default, Windows Firewall blocks all inbound traffic except for essential services. Now that you have installed IIS (web server), you need to open firewall port 80 (HTTP) to allow web traffic. You will manage firewall rules using both the GUI and PowerShell.
:::

### Task 1: Open Windows Defender Firewall with Advanced Security

1. [ ] In Server Manager, click on the **Tools** menu at the top.
2. [ ] Look for **Windows Defender Firewall with Advanced Security** in the Tools menu.
3. [ ] Click on it to open the Windows Firewall advanced settings.
4. [ ] A window titled **Windows Defender Firewall with Advanced Security** will open showing:
   - **Overview**: Summary of firewall status
   - Left panel: **Inbound Rules**, **Outbound Rules**, **Connection Security Rules**
   - Right panel: Actions you can perform

::: success
**Results**: After completing this task, you have opened the Windows Firewall management interface.
:::

### Task 2: Review Current Inbound Rules

1. [ ] Click on **Inbound Rules** in the left panel.
2. [ ] The right panel will show a list of inbound rules. There may be many rules, so scroll through to see examples:
   - Rules for **Core Networking** (DNS, DHCP, etc.)
   - Rules for **Windows Remote Management** (WinRM)
   - Rules for **File and Printer Sharing**
   - Once IIS is installed, there may be rules for **World Wide Web Services** (HTTP/HTTPS)
3. [ ] Look for a rule related to **World Wide Web Services** or **HTTP**. If you don't see one, we will create it.

::: success
**Results**: After completing this task, you understand the current firewall inbound rules on your server.
:::

### Task 3: Create an Inbound Firewall Rule for HTTP

Since IIS is installed but we may need to create a firewall rule:

1. [ ] On the right side of the Windows Firewall window, look for **Actions** panel (on the right).
2. [ ] Click on **New Rule** in the Actions panel.
3. [ ] The **New Inbound Rule Wizard** will open.
4. [ ] The first page is **Rule Type**. Select **Port** (click on the radio button next to Port).
5. [ ] Click **Next >**.

::: warning
**Note**: We are creating a rule for a specific port (port 80 for HTTP) rather than for an application.
:::

### Task 4: Specify the Port

1. [ ] The **Protocol and Ports** page will appear.
2. [ ] Select **TCP** (should be the default).
3. [ ] Select **Specific local ports** radio button.
4. [ ] In the port field, type **80** (this is the HTTP port).
5. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have specified that the rule will apply to TCP port 80.
:::

### Task 5: Set the Rule Action

1. [ ] The **Action** page will appear with three options:
   - **Allow the connection** (should be selected)
   - **Allow the connection if it is secure**
   - **Block the connection**
2. [ ] Make sure **Allow the connection** is selected.
3. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have specified that this rule will allow (not block) traffic on port 80.
:::

### Task 6: Specify When the Rule Applies

1. [ ] The **Profile** page will appear asking when the rule applies:
   - **Domain** (when connected to a domain network)
   - **Private** (when connected to a private network)
   - **Public** (when connected to a public network)
2. [ ] Leave all three checked (the defaults). This ensures the rule applies in all network scenarios.
3. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have specified that the rule applies in all network scenarios.
:::

### Task 7: Name and Complete the Rule

1. [ ] The **Name** page will appear asking for the rule name.
2. [ ] In the **Name** field, type **Allow HTTP Traffic**.
3. [ ] In the **Description** field, type **Allow inbound web traffic on port 80**.
4. [ ] Click **Finish** to create the rule.
5. [ ] The rule is now created and active. You should see it in the Inbound Rules list.

::: success
**Results**: After completing this task, you have created a firewall rule to allow HTTP traffic on port 80.
:::

### Task 8: Verify the Rule Using PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to verify the firewall rule exists:

```powershell
Get-NetFirewallRule -DisplayName "Allow HTTP Traffic" | Format-List DisplayName, Direction, Action, Enabled
```

3. [ ] Press **Enter**.
4. [ ] PowerShell should display:
   - **DisplayName**: Allow HTTP Traffic
   - **Direction**: Inbound
   - **Action**: Allow
   - **Enabled**: True
5. [ ] This confirms the firewall rule is active.

::: success
**Results**: After completing this task, you have confirmed the firewall rule is in place using PowerShell.
:::

## Exercise 3: Testing the Web Server

::: secondary
**Scenario**

Now that IIS is installed and the firewall is configured, you should verify that the web server is running and responding to requests.
:::

### Task 1: Verify IIS is Running

1. [ ] In PowerShell, type the following command to check if the IIS service is running:

```powershell
Get-Service -Name W3SVC | Select-Object Name, DisplayName, Status
```

2. [ ] Press **Enter**.
3. [ ] PowerShell should display:
   - **Name**: W3SVC
   - **DisplayName**: World Wide Web Publishing Service
   - **Status**: Running
4. [ ] If the status is not "Running", the web server is not active yet.

::: success
**Results**: After completing this task, you have confirmed that the IIS service is running.
:::

### Task 2: Test Web Server Connectivity

1. [ ] Still in PowerShell, type the following command to test the web server:

```powershell
curl http://localhost
```

2. [ ] Press **Enter**.
3. [ ] If IIS is working, you will see HTML content returned (the default IIS welcome page).
4. [ ] If you get an error, wait a few seconds and try again, as IIS may still be starting up.

::: warning
**Note**: If curl is not available, use Invoke-WebRequest instead: `Invoke-WebRequest -Uri http://localhost`
:::

::: success
**Results**: After completing this task, you have verified that the web server is responding to requests.
:::

## Exercise 4: Understanding Services and Firewall Together

::: secondary
**Scenario**

You now understand that to provide a service on Windows Server, you need both the service running AND a firewall rule allowing traffic to reach it.
:::

### Task 1: Summary of What You've Accomplished

You have successfully:

1. **Installed a Windows Server role** - Web Server (IIS)
2. **Verified the installation** - Used both Server Manager and PowerShell
3. **Managed Windows Firewall** - Created an inbound rule for HTTP traffic
4. **Verified the service is running** - Used PowerShell to check service status
5. **Tested connectivity** - Verified the web server responds to requests

::: success
**Results**: You have successfully completed Lab 0501. You understand:
- How to install server roles using Server Manager
- How to manage Windows Firewall rules
- That services require both the role installed AND firewall rules to function
- How to verify installations using both GUI tools and PowerShell

In future labs, you will install additional server roles and manage firewall rules for different services. These are core skills for Windows Server administration.
:::
