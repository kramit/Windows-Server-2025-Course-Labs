# Practice Lab 0601: Post-Installation Server Configuration and Security Hardening

## Summary

::: secondary
In this lab, you will capture a starting HTML report from **LON-SVR1**, review the OSConfig security baseline definition, apply the Windows Server 2025 **MemberServer** baseline, verify the change by running the report again, and then remove the baseline before finishing the lab.

The lab focuses on a realistic administrative workflow: collect evidence first, apply a standard baseline, confirm the result, inspect the baseline source, and then cleanly disable the baseline at the end.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Administrator access to **LON-SVR1**
- Internet access from **LON-SVR1** to Microsoft Learn, GitHub, and the PowerShell Gallery
- Basic familiarity with File Explorer, Microsoft Edge, and Windows PowerShell
:::

::: warning
**Important**: This lab is designed for the course lab environment. Do not rename servers, change domain membership, remove roles, or change IP addressing unless the step explicitly tells you to do so or your instructor directs you.
:::

## Exercise 1: Connect to LON-SVR1 and Capture the Starting Report

::: secondary
**Scenario**

Before changing a security baseline, you need a point-in-time record of the server's current state. You will connect through the lab platform and run the provided post-install report script.
:::

### Task 1: Connect to LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.

5. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.

6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SVR1 through the lab platform.
:::

### Task 2: Run the Lab 6 Post-Install Report Script

1. [ ] If **File Explorer** is already open, bring it to the front.

2. [ ] If **File Explorer** is not open, select **Start**, type **File Explorer**, and select **File Explorer** from the search results.

3. [ ] Browse to the course lab files folder provided by your instructor.

4. [ ] Open **supporting content**.

5. [ ] Open **Lab6**.

6. [ ] Verify that the folder contains `Get-Lab6PostInstallReport.ps1`.

7. [ ] Select **Start**.

8. [ ] Type **PowerShell**.

9. [ ] In the search results, right-click **Windows PowerShell**.

10. [ ] Select **Run as administrator**.

11. [ ] If a **User Account Control** prompt appears, select **Yes**.

12. [ ] Change to the folder that contains the Lab 6 script. For example, if your lab files are in `C:\LabFiles`, run:

```powershell
Set-Location "C:\LabFiles\supporting content\Lab6"
```

13. [ ] Run the report script:

```powershell
.\Get-Lab6PostInstallReport.ps1
```

14. [ ] Review the output in PowerShell. The script displays the full path to the generated HTML report.

15. [ ] Record the report path in your lab notes.

   ::: warning
   **Note**: The default report folder is `C:\LabOutput`. If your instructor asks you to save the report somewhere else, run the script with the `-OutputFolder` parameter.
   :::

::: success
**Results**: After completing this task, you have generated a starting HTML validation report from LON-SVR1.
:::

## Exercise 2: Review the OSConfig Baseline Definition

::: secondary
**Scenario**

OSConfig baselines are stored as YAML definitions in the Microsoft `osconfig` GitHub repository. You will open the Windows Server 2025 member server baseline and inspect the kinds of settings it contains before applying anything to the server.
:::

### Task 1: Open the Baseline Repository

1. [ ] Open **Microsoft Edge**.

2. [ ] In the address bar, go to:

```text
https://github.com/microsoft/osconfig/tree/main/security/ws2025
```

3. [ ] Review the directory listing.

4. [ ] Notice the baseline files for:
   - `domain_controller.osc.yaml`
   - `member_server.osc.yaml`
   - `secured_core.osc.yaml`
   - `workgroup_member.osc.yaml`

::: success
**Results**: After completing this task, you have located the Windows Server 2025 baseline definitions in the GitHub repository.
:::

### Task 2: Open the Member Server Baseline File

1. [ ] Select `member_server.osc.yaml`.

2. [ ] Review the top of the file and locate the `resources:` section.

3. [ ] Scroll through the file and notice that each baseline item has a friendly name, a resource type, and a desired value.

4. [ ] Use the browser search feature to find `Allow log on locally`.

5. [ ] Use the browser search feature to find `Windows Firewall: Domain: Firewall state`.

6. [ ] Use the browser search feature to find `Audit Logon`.

7. [ ] Notice that the file is a long YAML list of configuration items, not a single monolithic setting.

   ::: warning
   **Note**: The baseline file contains hundreds of named entries. In this lab, you are learning how to recognize the structure and identify a few representative settings, not memorizing every item.
   :::

::: success
**Results**: After completing this task, you have reviewed the structure of an OSConfig baseline definition.
:::

## Exercise 3: Install OSConfig and Apply the Member Server Baseline

::: secondary
**Scenario**

Now that you know what the baseline looks like, you will install the OSConfig module if needed and apply the Windows Server 2025 member server baseline to LON-SVR1.
:::

### Task 1: Install or Verify the OSConfig Module

1. [ ] Return to the elevated **Windows PowerShell** window.

2. [ ] Run the following command:

```powershell
Get-Module -ListAvailable -Name Microsoft.OSConfig
```

3. [ ] If the module is not listed, run the following command:

```powershell
Install-Module -Name Microsoft.OSConfig -Scope AllUsers -Force
```

4. [ ] If PowerShell prompts you to install or update the NuGet provider, select **Yes**.

5. [ ] Load the module into the current session:

```powershell
Import-Module Microsoft.OSConfig
```

::: success
**Results**: After completing this task, the OSConfig module is available in the current PowerShell session.
:::

### Task 2: Apply the Windows Server 2025 Member Server Baseline

1. [ ] Run the following command:

```powershell
Set-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer -Default
```

2. [ ] Read the PowerShell output and watch for any prompts or warnings.

3. [ ] Run the following command to review the current baseline compliance details:

```powershell
Get-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer | Format-Table Name, @{ Name = "Status"; Expression = { $_.Compliance.Status } }, @{ Name = "Reason"; Expression = { $_.Compliance.Reason } } -AutoSize -Wrap
```

4. [ ] Review the table and confirm that OSConfig is reporting the baseline items for the member server scenario.

   ::: warning
   **Note**: Microsoft states that applying or removing a security baseline requires a restart before the changes take effect. Some settings may also trigger additional prompts or sign-in behavior after the restart.
   :::

::: success
**Results**: After completing this task, you have applied the OSConfig member server baseline and reviewed its compliance output.
:::

### Task 3: Restart the Server

1. [ ] Select **Start**.

2. [ ] Select the **Power** button.

3. [ ] Select **Restart**.

4. [ ] Wait for the restart to finish.

5. [ ] If you are disconnected, return to the lab platform and reconnect to **LON-SVR1** by using **HOME**, the **Select VM** dropdown, and the credentials shown on the **HOME** tab.

::: success
**Results**: After completing this task, the baseline changes are ready to be verified after restart.
:::

## Exercise 4: Verify the Baseline by Running the Report Again

::: secondary
**Scenario**

The easiest way to confirm that the baseline affected the server is to generate a new report and compare it with the starting report. You will use the same supplied script so the comparison stays consistent.
:::

### Task 1: Rerun the Report Script

1. [ ] Return to the elevated **Windows PowerShell** window.

2. [ ] Run the report script again:

```powershell
.\Get-Lab6PostInstallReport.ps1
```

3. [ ] Review the output and note the new HTML report path.

::: success
**Results**: After completing this task, you have generated a second HTML report after applying the OSConfig baseline.
:::

### Task 2: Compare the Before and After Reports

1. [ ] Open **File Explorer**.

2. [ ] Browse to `C:\LabOutput`.

3. [ ] Open the newest report in Microsoft Edge.

4. [ ] Compare it with the earlier report you created before the baseline was applied.

5. [ ] Focus on the sections that are most likely to change after a baseline is applied:
   - **Time Synchronization Status**
   - **Recent Installed Updates**
   - **WinRM Service**
   - **Firewall Profiles**
   - **Remote Registry Service**
   - **Account Policy**
   - **Recent System Events**
   - **Recent Security Events**

6. [ ] Record any meaningful differences in your lab notes.

   ::: warning
   **Note**: A changed report does not always mean a problem. A baseline often changes default behaviors by design. Use the report as evidence of change, not as a substitute for understanding which security settings the baseline enforces.
   :::

::: success
**Results**: After completing this task, you have verified the effect of the OSConfig baseline by comparing two generated reports.
:::

## Exercise 5: Disable the OSConfig Baseline

::: secondary
**Scenario**

Security baselines should be removable as well as deployable. You will disable the member server baseline so the lab ends in a clean state.
:::

### Task 1: Remove the Baseline Assignment

1. [ ] Return to the elevated **Windows PowerShell** window.

2. [ ] Run the following command:

```powershell
Remove-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer
```

3. [ ] Read the PowerShell output and note any restart prompt or warning.

4. [ ] Run the compliance command again if you want to see the updated baseline state:

```powershell
Get-OSConfigDesiredConfiguration -Scenario SecurityBaseline/WS2025/MemberServer | Format-Table Name, @{ Name = "Status"; Expression = { $_.Compliance.Status } }, @{ Name = "Reason"; Expression = { $_.Compliance.Reason } } -AutoSize -Wrap
```

   ::: warning
   **Note**: Microsoft documents that removing a baseline does not guarantee every setting returns to its exact previous value. In a real environment, you should plan and validate baseline removal carefully.
   :::

::: success
**Results**: After completing this task, you have removed the OSConfig baseline assignment from LON-SVR1.
:::

### Task 2: Restart and Confirm the Final State

1. [ ] Restart LON-SVR1 by using **Start** > **Power** > **Restart**.

2. [ ] After the server restarts, reconnect through the lab platform if needed.

3. [ ] Run the report script one final time:

```powershell
.\Get-Lab6PostInstallReport.ps1
```

4. [ ] Open the newest report in `C:\LabOutput`.

5. [ ] Confirm that you have a clean final record of the server after the baseline was removed.

::: success
**Results**: After completing this task, you have disabled the OSConfig baseline and generated a final post-install report for the lab record.
:::

::: success
**Results**: You have completed Lab 0601. You can now:

- Capture a server baseline report before making security changes
- Locate and inspect the OSConfig Windows Server 2025 baseline source
- Apply the `SecurityBaseline/WS2025/MemberServer` configuration
- Verify the applied baseline with OSConfig and with a report rerun
- Remove the baseline assignment and return the lab to a neutral state

These tasks build the habit of collecting evidence, applying standard security posture, and confirming the outcome before and after a baseline change.
:::
