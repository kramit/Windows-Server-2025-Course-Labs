# Practice Lab 1301: Connecting Windows Server to Azure Arc

## Summary

::: secondary
In this lab, you will connect your on-premises Windows Server to Azure Arc for cloud-based management. Azure Arc extends Azure management capabilities to on-premises servers, enabling unified monitoring, compliance, and governance across hybrid infrastructure.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SVR1
- A student Azure account with an active subscription
- Access to the Azure Portal (https://portal.azure.com)
:::

## Exercise 1: Setting Up Azure Account and Permissions

::: secondary
**Scenario**

You need to prepare your Azure environment before connecting your server. You will log in to Azure and set up the required permissions.
:::

### Task 1: Log Into Azure Portal

1. [ ] On LON-SVR1, open **Microsoft Edge** browser.

2. [ ] Navigate to **https://portal.azure.com**.

3. [ ] You will be prompted to sign in with your Azure account.

4. [ ] Enter your **email address** provided by your instructor (format: student@company.onmicrosoft.com or similar).

5. [ ] Click **Next**.

6. [ ] Enter your **password**.

7. [ ] Click **Sign in**.

8. [ ] You may be prompted for **Multi-Factor Authentication (MFA)**. Complete this step as prompted.

9. [ ] Once signed in, you will see the Azure Portal dashboard.

   ::: warning
   **Note**: If you don't have an Azure account, contact your instructor. They will provide access to a student subscription.
   :::

::: success
**Results**: After completing this task, you are logged into the Azure Portal.
:::

### Task 2: Locate the Azure Arc Service

1. [ ] In the Azure Portal, use the search box at the top to search for **Azure Arc**.

2. [ ] Click on **Azure Arc** in the search results.

3. [ ] The Azure Arc overview page will open, expand the options on the left pane.

4. [ ] You will see options including:
   - **Machines**
   - **Kubernetes clusters**
   - **SQL Servers**
   - **Data Services**

5. [ ] Click on **Machines** under **Infrastructure** to manage connected servers.

::: success
**Results**: After completing this task, you can navigate to Azure Arc for server management.
:::

## Exercise 2: Preparing Azure for Server Connection

::: secondary
**Scenario**

Before connecting your server, you need to create an Azure resource group and set up permissions for the connection.
:::

### Task 1: Create a Resource Group (Optional if Not Existing)

1. [ ] In Azure Portal, search for **Resource groups**.

2. [ ] Click on **Resource groups**.

3. [ ] Click **+ Create** button.

4. [ ] Fill in the details:
   - **Subscription**: Select your student subscription
   - **Resource group name**: Type `WindowsServer-RG`
   - **Region**: Select a region close to your location (e.g., **East US** or **UK South**)

5. [ ] Click **Review + create**.

6. [ ] Click **Create** to create the resource group.

   ::: warning
   **Note**: If a resource group already exists, you can use that. Ask your instructor which resource group to use.
   :::

::: success
**Results**: After completing this task, you have a resource group ready for Azure Arc.
:::

### Task 2: Verify Sufficient Permissions

1. [ ] In Azure Portal, click your **profile icon** in the top right.

2. [ ] Click **My permissions** it might be under the 3 dots **...**.

3. [ ] Verify you have at least **Contributor** or **Owner** role on the subscription.

4. [ ] You need these permissions to register servers with Azure Arc.

   ::: warning
   **Note**: If you don't have sufficient permissions, contact your Azure administrator or instructor.
   :::

::: success
**Results**: After completing this task, you have verified necessary permissions.
:::

## Exercise 3: Connecting the Windows Server to Azure Arc

::: secondary
**Scenario**

You will now download and run the Azure Arc agent to connect LON-SVR1 to Azure.
:::

### Task 1: Generate Connection Script

1. [ ] In Azure Portal, go to **Azure Arc** > **Infrastructure** > **Machines**.

2. [ ] Click **+ Onboard/Create*** 

3. [ ] Select **Onboard Existing Machines**.

4. [ ] You will be prompted to **Generate a script** to connect the server.

5. [ ] Fill in:
   - **Subscription**: Your student subscription
   - **Resource group**: `WindowsServer-RG` (or your chosen group)
   - **Region**: Your chosen region (UK South or East US)
   - **Operating system**: **Windows**

6. [ ] Click **Download and run script** button.

7. [ ] A PowerShell script will be displayed. This is the connection script.

::: success
**Results**: After completing this task, you have the script to connect your server.
:::

### Task 2: Download and Run the Connection Script

1. [ ] Click **Download** to download the PowerShell script.

2. [ ] The script will be saved to your **Downloads** folder.

3. [ ] On LON-SVR1, open **PowerShell as Administrator**.

4. [ ] Navigate to the Downloads folder:

```powershell
cd $env:USERPROFILE\Downloads
```

5. [ ] [ ] Allow script execution (if needed):

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser -Force
```

6. [ ] Run the downloaded script (the filename may vary):

```powershell
.\OnboardingScript.ps1
```

7. [ ] The script will:
   - Download the Azure Connected Machine agent
   - Install the agent
   - Register the server with Azure Arc
   - This may take 2-5 minutes to complete

8. [ ] If requested to login, do so with your Azure account. Once complete, you should see a success message.

   ::: warning
   **Note**: The script may require internet connectivity to Azure. If connection fails, verify that LON-SVR1 has internet access.
   :::

::: success
**Results**: After completing this task, your server is connected to Azure Arc.
:::

## Exercise 4: Verifying the Connection

::: secondary
**Scenario**

You will verify that the server has successfully connected to Azure Arc.
:::

### Task 1: Check Connection in Azure Portal

1. [ ] Return to the Azure Portal in your browser.

2. [ ] Go to **Azure Arc** > **Infrasturcture** > **Machines**.

3. [ ] You should see your server **LON-SVR1** listed with status **Connected**.

4. [ ] Click on **LON-SVR1** to see detailed information:
   - **Status**: Connected (green indicator)
   - **OS**: Windows Server 2025
   - **Agent status**: Connected
   - **Last activity**: Recent timestamp
   - **IP address**: The server's IP address

5. [ ] This confirms the server is successfully registered with Azure Arc.

::: success
**Results**: After completing this task, you have verified Azure Arc connection.
:::

### Task 2: Verify Agent on Server

1. [ ] On LON-SVR1, open PowerShell as Administrator.

2. [ ] Verify the Azure Arc agent is running:

```powershell
Get-Service -Name himds | Select-Object Name, DisplayName, Status
```

3. [ ] Press **Enter**.

4. [ ] You should see:
   - **Name**: himds (Azure Arc agent)
   - **DisplayName**: Azure Arc Agent Service
   - **Status**: Running

::: success
**Results**: After completing this task, you have confirmed the agent is running on the server.
:::

## Exercise 5: Using Azure Arc for Server Management

::: secondary
**Scenario**

Now that your server is connected to Azure Arc, you can manage it from Azure Portal.
:::

### Task 1: Access Server Properties in Azure Arc

1. [ ] In Azure Portal, go to **Azure Arc** > **Machines** > **LON-SVR1**.

2. [ ] Review the available information:
   - **Overview**: Server status and properties
   - **Logs**: Connection and diagnostic logs
   - **Updates**: Show available Windows updates
   - **Extensions**: Installed Azure Arc extensions

3. [ ] Click on **Updates** under **Operations** to see what patches are available for this server.

4. [ ] Azure Arc shows available Windows updates that you can deploy from Azure.

5. [ ] To enable Updates on this machine click **Enable Now** next to periodic assesment

6. [ ] Enable periodic assesment and click save

7. [ ] Click **Check for updates** and trigger the assesment

8. [ ] You can refresh the updates section to see the state of the updates, it is checking updates so will take some time, do not wait around for this to complete. You can check it in 5 mins.

::: success
**Results**: After completing this task, you understand Azure Arc management capabilities.
:::

### Task 2: Enable Azure Arc Extensions

1. [ ] On the LON-SVR1 Azure Arc page, click **Extensions** and click **add**

2. [ ] You will see available extensions such as:
   - **Microsoft Monitoring Agent**: For monitoring and logging
   - **Custom Script Extension**: For running PowerShell scripts
   - **Desired State Configuration**: For compliance and configuration management

3. [ ] These extensions extend Azure capabilities to your on-premises server.

::: success
**Results**: After completing this task, you understand Azure Arc extensions.
:::

## Exercise 6: Benefits of Azure Arc

::: secondary
**Scenario**

You should understand why Azure Arc is valuable for hybrid infrastructure management.
:::

### Task 1: Azure Arc Benefits

Azure Arc provides:

1. **Unified Management**: Manage on-premises, edge, and cloud resources from one place
2. **Azure Services**: Use Azure services (updates, monitoring, compliance) on on-premises servers
3. **Policy Management**: Apply Azure Policy for compliance across hybrid infrastructure
4. **Inventory Management**: Track all servers across environments
5. **Security**: Threat assessment and security patching from Azure
6. **Compliance**: Audit and compliance monitoring across all servers
7. **Automation**: Use Azure Automation to automate tasks across hybrid servers

Without Azure Arc, you would need to manage on-premises and cloud servers separately.

::: success
**Results**: After completing this task, you understand the value of Azure Arc.
:::
