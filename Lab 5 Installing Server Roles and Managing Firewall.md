# Practice Lab 0501: Installing Server Roles and Managing Firewall

## Summary

::: secondary
In this lab, you will install the Web Server (IIS) role on Windows Server 2025 and manage Windows Defender Firewall rules. You will complete most tasks by using graphical administration tools, including Server Manager, Internet Information Services (IIS) Manager, Services, Windows Defender Firewall with Advanced Security, Event Viewer, File Explorer, Notepad, and Microsoft Edge.

You will also use a small number of PowerShell commands to validate the final configuration. The main focus is learning where common administrative tools are located and how they fit together during a routine server change.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0401 (PowerShell Command-Line Administration)
- Administrator access to LON-SVR1
- Basic familiarity with Server Manager
- Basic familiarity with Windows PowerShell
:::

## Exercise 1: Connect to LON-SVR1 and Review Server Manager

::: secondary
**Scenario**

Your organization needs to host internal web content on Windows Server. Before making changes, you need to connect to the server and review the current Server Manager dashboard.
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

### Task 2: Review Server Manager

1. [ ] If **Server Manager** is already open, bring it to the front.
2. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.
3. [ ] On the left side of Server Manager, select **Dashboard**.
4. [ ] Review the **Welcome to Server Manager** section.
5. [ ] Review the **Roles and Server Groups** section.
6. [ ] Notice whether **Web Server (IIS)** is already listed. If it is already installed, you can still continue through the verification and management tasks in this lab.

::: success
**Results**: After completing this task, you have reviewed the current Server Manager view before making changes.
:::

## Exercise 2: Install the Web Server (IIS) Role by Using Server Manager

::: secondary
**Scenario**

You need to install the Web Server (IIS) role on LON-SVR1. You will use the graphical Add Roles and Features Wizard so you can see the installation decisions that administrators make when adding a server capability.
:::

### Task 1: Start the Add Roles and Features Wizard

1. [ ] In **Server Manager**, select **Dashboard**.
2. [ ] In the upper-right corner, select **Manage**.
3. [ ] Select **Add Roles and Features**.
4. [ ] The **Add Roles and Features Wizard** opens.
5. [ ] On the **Before You Begin** page, review the information.
6. [ ] Select **Next >**.

::: warning
**Note**: Do not select **Skip this page by default** unless your instructor asks you to.
:::

### Task 2: Select the Installation Type

1. [ ] On the **Installation Type** page, verify that **Role-based or feature-based installation** is selected.
2. [ ] Do not select the second option on this page. That option is for a different deployment type.
3. [ ] Select **Next >**.

::: success
**Results**: After completing this task, you have selected the standard role and feature installation type.
:::

### Task 3: Select the Destination Server

1. [ ] On the **Server Selection** page, verify that **Select a server from the server pool** is selected.
2. [ ] In the **Server Pool** list, select **LON-SVR1.contoso.com** if it is not already selected.
3. [ ] Select **Next >**.

::: success
**Results**: After completing this task, you have selected LON-SVR1 as the destination server.
:::

### Task 4: Select the Web Server Role

1. [ ] On the **Server Roles** page, scroll through the role list.
2. [ ] Select the checkbox next to **Web Server (IIS)**.
3. [ ] When the **Add features that are required for Web Server (IIS)?** dialog appears, review the listed management tools and required features.
4. [ ] Select **Add Features**.
5. [ ] Verify that **Web Server (IIS)** is checked.
6. [ ] Select **Next >**.

::: warning
**Note**: The wizard can automatically add required features and management tools. This helps administrators avoid missing dependencies.
:::

### Task 5: Review Features and IIS Information

1. [ ] On the **Features** page, do not select additional features.
2. [ ] Select **Next >**.
3. [ ] On the **Web Server Role (IIS)** page, review the description of IIS.
4. [ ] Select **Next >**.

### Task 6: Review Role Services

1. [ ] On the **Role Services** page, review the selected role services.
2. [ ] Expand **Web Server** if it is not already expanded.
3. [ ] Review the selected default role services, such as **Common HTTP Features**.
4. [ ] Do not change the selected role services unless your instructor asks you to.
5. [ ] Select **Next >**.

::: warning
**Note**: Production IIS servers often require specific role services, but this lab uses the default selection so the installation stays focused.
:::

### Task 7: Confirm and Install

1. [ ] On the **Confirmation** page, review the list of selected roles, role services, and features.
2. [ ] Verify that **Web Server (IIS)** appears in the confirmation list.
3. [ ] Select **Install**.
4. [ ] Wait for the **Results** page to show the installation progress.
5. [ ] When the installation completes, verify that the wizard shows **Installation succeeded**.
6. [ ] Select **Close**.

::: warning
**Note**: Do not close the wizard or turn off the server while installation is still running.
:::

::: success
**Results**: After completing this exercise, the Web Server (IIS) role is installed on LON-SVR1.
:::

## Exercise 3: Review IIS by Using Graphical Tools

::: secondary
**Scenario**

Now that IIS is installed, you need to confirm that the web server role appears in Server Manager, inspect the default website in IIS Manager, and browse the website.
:::

### Task 1: Confirm IIS in Server Manager

1. [ ] In **Server Manager**, select **Dashboard**.
2. [ ] In **Roles and Server Groups**, look for **IIS** or **Web Server (IIS)**.
3. [ ] Select **IIS** in the left navigation pane if it appears.
4. [ ] Review the IIS overview page.
5. [ ] In the **Servers** tile, verify that **LON-SVR1** is listed.
6. [ ] Review the **Services** tile and notice the service information shown for the server.

::: success
**Results**: After completing this task, you have confirmed that Server Manager recognizes IIS as an installed role.
:::

### Task 2: Open Internet Information Services (IIS) Manager

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Internet Information Services (IIS) Manager**.
3. [ ] In the **Connections** pane, expand **LON-SVR1**.
4. [ ] Expand **Sites**.
5. [ ] Select **Default Web Site**.
6. [ ] In the center pane, review the feature icons for the selected website.
7. [ ] In the **Actions** pane, look for the **Manage Website** section and confirm that options such as **Restart**, **Start**, and **Stop** are available.

::: success
**Results**: After completing this task, you have opened IIS Manager and located the Default Web Site.
:::

### Task 3: Browse the Default Web Site

1. [ ] In **IIS Manager**, select **Default Web Site**.
2. [ ] In the **Actions** pane, locate the **Browse Website** section.
3. [ ] Select **Browse *:80 (http)**.
4. [ ] Microsoft Edge opens and displays the default IIS web page.
5. [ ] Verify that the page loads successfully.
6. [ ] Close Microsoft Edge when you are finished reviewing the page.

::: warning
**Note**: If the browser does not open immediately, return to IIS Manager and verify that **Default Web Site** is selected and started.
:::

::: success
**Results**: After completing this task, you have tested the default IIS website by using IIS Manager.
:::

### Task 4: Review the Website Binding

1. [ ] In **IIS Manager**, select **Default Web Site**.
2. [ ] In the **Actions** pane, select **Bindings...**.
3. [ ] In the **Site Bindings** window, select the binding with:
   - **Type**: `http`
   - **Port**: `80`
4. [ ] Select **Edit...**.
5. [ ] Review the **Edit Site Binding** window.
6. [ ] Verify that **Port** is set to `80`.
7. [ ] Select **Cancel** to close **Edit Site Binding** without making changes.
8. [ ] Select **Close** to close **Site Bindings**.

::: success
**Results**: After completing this task, you have confirmed that the Default Web Site listens on HTTP port 80.
:::

## Exercise 4: Create and Test a Simple Web Page

::: secondary
**Scenario**

The default IIS page confirms that the web server is installed, but administrators often need to place or verify real content. You will create a simple lab web page by using Notepad and then browse to it from IIS Manager.
:::

### Task 1: Open Notepad as Administrator

1. [ ] Select **Start**.
2. [ ] Type **Notepad**.
3. [ ] In the search results, right-click **Notepad**.
4. [ ] Select **Run as administrator**.
5. [ ] If a **User Account Control** prompt appears, select **Yes**.

::: warning
**Note**: Running Notepad as administrator is important because the IIS website folder is protected by Windows permissions.
:::

### Task 2: Create a Lab Web Page

1. [ ] In Notepad, type the following content:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Lab 5 IIS Test</title>
</head>
<body>
    <h1>LON-SVR1 Web Server Lab</h1>
    <p>IIS is installed and serving custom content.</p>
</body>
</html>
```

2. [ ] In Notepad, select **File** > **Save As...**.
3. [ ] In the address bar or folder path field, enter `C:\inetpub\wwwroot`.
4. [ ] In **File name**, enter `lab5.html`.
5. [ ] In **Save as type**, select **All files (*.*)**.
6. [ ] Select **Save**.
7. [ ] Close Notepad.

::: warning
**Note**: Make sure the file is named `lab5.html`, not `lab5.html.txt`.
:::

### Task 3: Browse to the Lab Web Page

1. [ ] Return to **IIS Manager**.
2. [ ] Select **Default Web Site**.
3. [ ] In the **Actions** pane, select **Browse *:80 (http)**.
4. [ ] In Microsoft Edge, select the address bar.
5. [ ] Change the address to `http://localhost/lab5.html` and load the page.
6. [ ] Verify that the page displays **LON-SVR1 Web Server Lab**.
7. [ ] Close Microsoft Edge.

::: success
**Results**: After completing this exercise, you have created and tested custom website content.
:::

## Exercise 5: Manage the IIS Service by Using Services

::: secondary
**Scenario**

A server role usually depends on one or more Windows services. For IIS, the World Wide Web Publishing Service must be running for websites to respond to HTTP requests.
:::

### Task 1: Open Services

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Services**.
3. [ ] In the **Services** console, select any service in the list.
4. [ ] Type **World** to move near services that begin with that word.
5. [ ] Select **World Wide Web Publishing Service**.
6. [ ] Review the **Status** and **Startup Type** columns.

::: success
**Results**: After completing this task, you have located the IIS service in the Services console.
:::

### Task 2: Review Service Properties

1. [ ] Double-click **World Wide Web Publishing Service**.
2. [ ] On the **General** tab, review:
   - **Service name**: `W3SVC`
   - **Display name**: **World Wide Web Publishing Service**
   - **Startup type**
   - **Service status**
3. [ ] Select the **Dependencies** tab.
4. [ ] Review the listed dependency information.
5. [ ] Select **Cancel** to close the properties window without making changes.

::: success
**Results**: After completing this task, you have reviewed the service that supports IIS website traffic.
:::

### Task 3: Stop and Start the IIS Service

1. [ ] In the **Services** console, select **World Wide Web Publishing Service**.
2. [ ] In the left side of the Services console or from the service context menu, select **Stop**.
3. [ ] Wait for the **Status** column to no longer show **Running**.
4. [ ] Return to **IIS Manager**.
5. [ ] Select **Default Web Site**.
6. [ ] In the **Actions** pane, select **Browse *:80 (http)**.
7. [ ] Verify that the website does not load while the service is stopped.
8. [ ] Return to the **Services** console.
9. [ ] Select **World Wide Web Publishing Service**.
10. [ ] Select **Start**.
11. [ ] Wait for the **Status** column to show **Running**.
12. [ ] Return to **IIS Manager** and browse the website again.
13. [ ] Verify that the website loads successfully.

::: warning
**Note**: This stop and start action is safe for the lab environment. In production, administrators should review workload impact before restarting services.
:::

::: success
**Results**: After completing this exercise, you have demonstrated that the IIS website depends on the World Wide Web Publishing Service.
:::

## Exercise 6: Review Windows Defender Firewall with Advanced Security

::: secondary
**Scenario**

The IIS service can be running, but network clients still need a firewall rule that allows HTTP traffic. You will review firewall profiles and inspect the inbound rules that control access to the web server.
:::

### Task 1: Open Windows Defender Firewall with Advanced Security

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Windows Defender Firewall with Advanced Security**.
3. [ ] In the left pane, select **Windows Defender Firewall with Advanced Security on Local Computer**.
4. [ ] In the center pane, review the **Overview** section.
5. [ ] Notice the profile sections for:
   - **Domain Profile**
   - **Private Profile**
   - **Public Profile**

::: success
**Results**: After completing this task, you have opened the advanced firewall management console and reviewed the firewall profiles.
:::

### Task 2: Review Firewall Profile Properties

1. [ ] In the **Actions** pane, select **Properties**.
2. [ ] In the **Windows Defender Firewall with Advanced Security on Local Computer Properties** window, review the tabs:
   - **Domain Profile**
   - **Private Profile**
   - **Public Profile**
   - **IPsec Settings**
3. [ ] On each profile tab, review the **Firewall state**, **Inbound connections**, and **Outbound connections** settings.
4. [ ] Do not change any settings.
5. [ ] Select **Cancel**.

::: warning
**Note**: Avoid turning off the firewall. Server administration should usually focus on creating and scoping rules, not disabling firewall protection.
:::

### Task 3: Find IIS Inbound Rules

1. [ ] In the left pane, select **Inbound Rules**.
2. [ ] Select the **Name** column header to sort the rules by name.
3. [ ] Scroll through the list and look for rules named similar to:
   - **World Wide Web Services (HTTP Traffic-In)**
   - **World Wide Web Services (HTTPS Traffic-In)**
4. [ ] If the list is long, use the **Actions** pane to select **Filter by Group** or **Filter by State** if available.
5. [ ] Select **World Wide Web Services (HTTP Traffic-In)** if it is present.
6. [ ] Review the columns for the selected rule, including **Profile**, **Enabled**, **Action**, **Protocol**, and **Local Port**.

::: warning
**Note**: The exact rule list can vary depending on the lab image and installed role services. If the IIS HTTP rule is not present, continue to the next task and create a custom rule.
:::

::: success
**Results**: After completing this task, you have reviewed the inbound firewall rules related to IIS.
:::

### Task 4: Enable the Built-In HTTP Rule if Needed

1. [ ] If **World Wide Web Services (HTTP Traffic-In)** is present and **Enabled** shows **Yes**, no change is required.
2. [ ] If **World Wide Web Services (HTTP Traffic-In)** is present and **Enabled** shows **No**, select the rule.
3. [ ] In the **Actions** pane, select **Enable Rule**.
4. [ ] Verify that **Enabled** now shows **Yes**.

::: success
**Results**: After completing this task, the built-in IIS HTTP firewall rule is enabled if it exists in your lab environment.
:::

### Task 5: Create a Custom HTTP Inbound Rule if Needed

Complete this task only if you do not see a built-in HTTP rule for IIS or if your instructor asks you to create a custom rule.

1. [ ] In **Windows Defender Firewall with Advanced Security**, select **Inbound Rules**.
2. [ ] In the **Actions** pane, select **New Rule...**.
3. [ ] On the **Rule Type** page, select **Port**.
4. [ ] Select **Next >**.
5. [ ] On the **Protocol and Ports** page, verify that **TCP** is selected.
6. [ ] Select **Specific local ports**.
7. [ ] In the port field, enter `80`.
8. [ ] Select **Next >**.
9. [ ] On the **Action** page, verify that **Allow the connection** is selected.
10. [ ] Select **Next >**.
11. [ ] On the **Profile** page, review **Domain**, **Private**, and **Public**.
12. [ ] For this lab, leave all three profiles selected.
13. [ ] Select **Next >**.
14. [ ] On the **Name** page, enter **Allow HTTP Traffic** in the **Name** field.
15. [ ] In the **Description** field, enter **Allow inbound web traffic on TCP port 80 for Lab 5**.
16. [ ] Select **Finish**.
17. [ ] Verify that the new rule appears in the **Inbound Rules** list.

::: warning
**Note**: Leaving all profiles selected is acceptable for this lab. In production, administrators should scope firewall rules to the required profiles, addresses, programs, and ports.
:::

::: success
**Results**: After completing this task, you have created a custom inbound firewall rule for HTTP traffic if one was needed.
:::

### Task 6: Inspect Rule Properties

1. [ ] Select the enabled HTTP rule you are using for the lab. This can be **World Wide Web Services (HTTP Traffic-In)** or **Allow HTTP Traffic**.
2. [ ] Double-click the rule.
3. [ ] On the **General** tab, review:
   - **Enabled**
   - **Action**
4. [ ] Select the **Protocols and Ports** tab.
5. [ ] Verify that the rule uses **TCP** and local port `80`.
6. [ ] Select the **Scope** tab.
7. [ ] Review the local and remote IP address settings.
8. [ ] Select the **Advanced** tab.
9. [ ] Review the selected profiles.
10. [ ] Select **Cancel** to close the properties window without making changes.

::: success
**Results**: After completing this task, you have inspected the most important settings in an inbound firewall rule.
:::

## Exercise 7: Use a GUI Troubleshooting Workflow

::: secondary
**Scenario**

You need to prove that website availability depends on both the IIS service and the firewall rule. You already tested the service. Now you will disable and re-enable the HTTP firewall rule using the graphical firewall console.
:::

### Task 1: Disable the HTTP Rule and Test the Website

1. [ ] In **Windows Defender Firewall with Advanced Security**, select **Inbound Rules**.
2. [ ] Select the enabled HTTP rule you are using for the lab.
3. [ ] In the **Actions** pane, select **Disable Rule**.
4. [ ] Verify that **Enabled** changes to **No**.
5. [ ] Return to **IIS Manager**.
6. [ ] Select **Default Web Site**.
7. [ ] In the **Actions** pane, select **Browse *:80 (http)**.
8. [ ] Review the browser result.

::: warning
**Note**: Browsing from the same server by using `localhost` may still succeed in some configurations because local traffic does not always test the same path as remote client traffic. The rule state is still important for network clients.
:::

### Task 2: Re-Enable the HTTP Rule

1. [ ] Return to **Windows Defender Firewall with Advanced Security**.
2. [ ] Select **Inbound Rules**.
3. [ ] Select the HTTP rule you disabled.
4. [ ] In the **Actions** pane, select **Enable Rule**.
5. [ ] Verify that **Enabled** changes to **Yes**.
6. [ ] Return to **IIS Manager**.
7. [ ] Browse **Default Web Site** again.
8. [ ] Verify that the website loads.

::: success
**Results**: After completing this exercise, you have used the firewall console to disable and re-enable HTTP access.
:::

## Exercise 8: Review Related Events by Using Event Viewer

::: secondary
**Scenario**

Administrators should validate changes and review events after installing roles or changing service and firewall behavior. You will use Event Viewer to inspect recent events, then create a small custom event and find it in the Application log.
:::

### Task 1: Open Event Viewer

1. [ ] In **Server Manager**, select **Tools**.
2. [ ] Select **Event Viewer**.
3. [ ] In the left pane, expand **Windows Logs**.
4. [ ] Select **System**.
5. [ ] Review the recent events in the center pane.

::: success
**Results**: After completing this task, you have opened the System log in Event Viewer.
:::

### Task 2: Filter the System Log

1. [ ] With **System** selected, look in the **Actions** pane.
2. [ ] Select **Filter Current Log...**.
3. [ ] In the **Filter Current Log** window, find **Event level**.
4. [ ] Select **Critical**, **Warning**, and **Error**.
5. [ ] Select **OK**.
6. [ ] Review the filtered event list.
7. [ ] Select one event and review the **General** tab in the lower pane.
8. [ ] In the **Actions** pane, select **Clear Filter** to return to the full log view.

::: warning
**Note**: Warnings and errors do not always mean the lab is broken. Administrators review event source, event ID, time, and context before deciding what action to take.
:::

### Task 3: Review the Application Log

1. [ ] In the left pane, under **Windows Logs**, select **Application**.
2. [ ] Review recent events.
3. [ ] Use **Filter Current Log...** if you want to show only **Warning** and **Error** events.
4. [ ] Select a recent event and review the **General** tab.
5. [ ] If you applied a filter, select **Clear Filter** when finished.

::: success
**Results**: After completing this task, you have reviewed recent Application log events.
:::

### Task 4: Create a Custom Application Event with PowerShell

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] In the search results, right-click **Windows PowerShell**.
4. [ ] Select **Run as administrator**.
5. [ ] If a **User Account Control** prompt appears, select **Yes**.
6. [ ] In Windows PowerShell, type the following script:

```powershell
$source = "Lab5-IIS-Firewall"

if (-not [System.Diagnostics.EventLog]::SourceExists($source)) {
    New-EventLog -LogName Application -Source $source
}

Write-EventLog `
    -LogName Application `
    -Source $source `
    -EntryType Information `
    -EventId 5051 `
    -Message "Lab 5 custom event: IIS and firewall review completed on LON-SVR1."
```

7. [ ] Run the script.
8. [ ] Verify that no error message appears.
9. [ ] Leave Windows PowerShell open.

::: warning
**Note**: Creating a new event source requires administrative permissions. After the source exists, applications and scripts can use it to write events to the configured log.
:::

::: success
**Results**: After completing this task, you have created a custom informational event in the Application log.
:::

### Task 5: Find the Custom Event in Event Viewer

1. [ ] Return to **Event Viewer**.
2. [ ] In the left pane, under **Windows Logs**, select **Application**.
3. [ ] In the **Actions** pane, select **Refresh**.
4. [ ] In the **Actions** pane, select **Find...**.
5. [ ] In the **Find what** field, enter `Lab5-IIS-Firewall`.
6. [ ] Select **Find Next**.
7. [ ] Select **Cancel** to close the **Find** window.
8. [ ] Review the selected event in the center pane.
9. [ ] In the lower pane, on the **General** tab, verify that the message includes **Lab 5 custom event**.
10. [ ] Review these event details:
   - **Log Name**: **Application**
   - **Source**: **Lab5-IIS-Firewall**
   - **Event ID**: `5051`
   - **Level**: **Information**

::: success
**Results**: After completing this exercise, you have used Event Viewer to review recent system and application events.
:::

## Exercise 9: Validate the Configuration with PowerShell

::: secondary
**Scenario**

The main lab tasks used graphical tools. You will now run a few PowerShell commands to validate the same configuration in a repeatable way.
:::

### Task 1: Open PowerShell as Administrator

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] In the search results, right-click **Windows PowerShell**.
4. [ ] Select **Run as administrator**.
5. [ ] If a **User Account Control** prompt appears, select **Yes**.

### Task 2: Validate IIS and the Firewall Rule

1. [ ] Run the following command to confirm the Web Server role is installed:

```powershell
Get-WindowsFeature -Name Web-Server
```

2. [ ] Verify that **Install State** shows **Installed**.
3. [ ] Run the following command to confirm that the IIS service is running:

```powershell
Get-Service -Name W3SVC | Select-Object Name, DisplayName, Status
```

4. [ ] Verify that **Status** shows **Running**.
5. [ ] If you created the custom firewall rule, run:

```powershell
Get-NetFirewallRule -DisplayName "Allow HTTP Traffic" | Format-List DisplayName, Direction, Action, Enabled
```

6. [ ] Verify that **Enabled** shows **True**.

### Task 3: Validate the Web Page

1. [ ] Run the following command:

```powershell
Invoke-WebRequest -Uri http://localhost/lab5.html | Select-Object StatusCode, StatusDescription
```

2. [ ] Verify that **StatusCode** shows `200`.
3. [ ] Close PowerShell.

::: success
**Results**: After completing this exercise, you have validated the IIS role, service state, firewall rule, and web page response by using PowerShell.
:::

## Exercise 10: Record the Administrative Change

::: secondary
**Scenario**

Administrators should be able to describe what changed, how it was validated, and what risk was considered. You will record a brief change summary for the lab.
:::

### Task 1: Complete the Change Summary

Record the following information in your lab notes:

1. [ ] Server changed: **LON-SVR1**
2. [ ] Role installed: **Web Server (IIS)**
3. [ ] Website reviewed: **Default Web Site**
4. [ ] Test page created: `C:\inetpub\wwwroot\lab5.html`
5. [ ] IIS service reviewed: **World Wide Web Publishing Service**
6. [ ] Firewall rule reviewed or created:
   - **World Wide Web Services (HTTP Traffic-In)**, or
   - **Allow HTTP Traffic**
7. [ ] Validation methods used:
   - IIS Manager browse test
   - Services console service check
   - Firewall rule review
   - Event Viewer review
   - PowerShell validation

::: success
**Results**: You have completed Lab 0501. You can now:

- Install a Windows Server role by using Server Manager
- Review IIS by using IIS Manager
- Create and test a simple web page
- Manage the IIS service by using Services
- Review and configure inbound firewall rules
- Inspect firewall profiles and rule properties
- Review recent events in Event Viewer
- Validate the final configuration with PowerShell

These are common administrative tasks that you will use throughout Windows Server administration.
:::
