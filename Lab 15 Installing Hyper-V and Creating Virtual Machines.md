# Practice Lab 1501: Installing Hyper-V and Performing Live Migration

## Summary

::: secondary
In this lab, you will install Hyper-V on LON-SVR1 and LON-SVR2, create matching private virtual switches, and configure Kerberos constrained delegation for live migration. You will then download a Windows Server 2025 evaluation virtual hard disk, create a running virtual machine on LON-SVR1, and move the virtual machine and its storage to LON-SVR2 without restarting the guest operating system.

The lab demonstrates nonclustered, shared-nothing live migration. The virtual machine files begin on local storage on LON-SVR1 and are copied to local storage on LON-SVR2 while the virtual machine remains running.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Nested virtualization enabled for both LON-SVR1 and LON-SVR2 in the lab platform
- Domain Administrator credentials for the contoso.com domain
- Internet access from LON-DC1 and LON-SVR1
- At least 25 GB of free disk space on both LON-SVR1 and LON-SVR2
- At least 2 GB of memory available for the nested virtual machine on LON-SVR1 and LON-SVR2
- Permission to restart LON-SVR1 and LON-SVR2
:::

::: warning
**Note**: The Microsoft Windows Server 2025 evaluation VHDX used in this lab is approximately 10.88 GB. The download can take a significant amount of time and uses additional disk space while the virtual machine is running and during migration.
:::

::: warning
**Note**: This lab changes Active Directory delegation settings. Constrained delegation should be limited to the required destination computers and services. Do not configure unrestricted delegation.
:::

## Exercise 1: Install Hyper-V and Configure Delegation

::: secondary
**Scenario**

Both servers will act as Hyper-V hosts. You will run a prepared PowerShell script from LON-DC1 that downloads the current installer from GitHub, configures Kerberos constrained delegation, installs Hyper-V and the management tools on LON-SVR1 and LON-SVR2, and restarts only the servers that require it.
:::

### Task 1: Run the Hyper-V Install Script from LON-DC1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** value shown for LON-DC1 on the **HOME** tab.

5. [ ] Use the **Password** value shown for LON-DC1 on the **HOME** tab.

6. [ ] Wait for the Windows Server desktop to appear.

7. [ ] Select **Start**.

8. [ ] Type **PowerShell**.

9. [ ] In the search results, right-click **Windows PowerShell**.

10. [ ] Select **Run as administrator**.

11. [ ] If a **User Account Control** prompt appears, select **Yes**.

12. [ ] Run the following one-line command:

```powershell
$u = "https://raw.githubusercontent.com/kramit/Windows-Server-2025-Course-Labs/refs/heads/master/supporting%20content/Lab15/Install-Lab15HyperV.ps1?cacheBust=$(Get-Date -Format yyyyMMddHHmmss)"; $p = Join-Path $env:TEMP "Install-Lab15HyperV.ps1"; Invoke-WebRequest -Uri $u -OutFile $p; Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force; & $p
```

13. [ ] Wait while the script configures constrained delegation, checks remote command access, checks the current Hyper-V status, installs Hyper-V on LON-SVR1 and LON-SVR2 if needed, and restarts servers that require it.

14. [ ] Verify that the final verification table shows `True` in the **HyperVInstalled** column for LON-SVR1 and LON-SVR2.

   ::: warning
   **Note**: The script installs Hyper-V and the management tools only. You will create virtual switches and configure live migration settings in later exercises.
   :::

   ::: danger
   **Stop**: Do not continue if the script reports that PowerShell remoting is unavailable, remote command access failed, the installation failed, or Hyper-V could not be verified on either server. Resolve the reported issue, then rerun the command.
   :::

::: success
**Results**: After completing this exercise, constrained delegation is configured and Hyper-V with its graphical management tools is installed on LON-SVR1 and LON-SVR2.
:::

## Exercise 2: Create Matching Private Virtual Switches

::: secondary
**Scenario**

A migrated virtual machine needs a compatible virtual switch on the destination host. You will create an isolated private switch with the same name on both Hyper-V hosts.
:::

### Task 1: Create Lab15-Private on LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Verify that **Enhanced mode** is turned on.

4. [ ] Use the **Username** and **Password** values shown for LON-SVR1 on the **HOME** tab.

5. [ ] Wait for the Windows Server desktop and Server Manager to appear.

6. [ ] In Server Manager, select **Tools** > **Hyper-V Manager**.

7. [ ] In the left pane, select **LON-SVR1**.

8. [ ] In the **Actions** pane, select **Virtual Switch Manager...**.

9. [ ] In the **Virtual Switch Manager** window, select **New virtual network switch**.

10. [ ] Select **Private**.

11. [ ] Select **Create Virtual Switch**.

12. [ ] In the **Name** field, enter `Lab15-Private`.

13. [ ] Verify that **Private network** is selected under **Connection type**.

14. [ ] Select **OK**.

15. [ ] If a warning appears, review it and select **Yes** to apply the change.

16. [ ] Reopen **Virtual Switch Manager...**.

17. [ ] Verify that **Lab15-Private** appears in the left pane and uses the **Private network** connection type.

18. [ ] Select **Cancel**.

### Task 2: Create Lab15-Private on LON-SVR2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.

3. [ ] Verify that **Enhanced mode** is turned on.

4. [ ] Use the **Username** and **Password** values shown for LON-SVR2 on the **HOME** tab.

5. [ ] Open **Server Manager**.

6. [ ] Select **Tools** > **Hyper-V Manager**.

7. [ ] In the left pane, select **LON-SVR2**.

8. [ ] In the **Actions** pane, select **Virtual Switch Manager...**.

9. [ ] Select **New virtual network switch**.

10. [ ] Select **Private**.

11. [ ] Select **Create Virtual Switch**.

12. [ ] In the **Name** field, enter `Lab15-Private`.

13. [ ] Verify that **Private network** is selected.

14. [ ] Select **OK**.

15. [ ] If a warning appears, review it and select **Yes**.

16. [ ] Reopen **Virtual Switch Manager...** and verify that **Lab15-Private** is listed as a private switch.

17. [ ] Select **Cancel**.

   ::: warning
   **Note**: The switch name must match exactly on both hosts. A private switch isolates the nested VM from the hosts and the lab network, so this exercise does not depend on nested-network MAC address spoofing.
   :::

::: success
**Results**: After completing this exercise, both Hyper-V hosts have a matching private virtual switch named Lab15-Private.
:::

## Exercise 3: Enable and Configure Live Migration

::: secondary
**Scenario**

The installation script configured the Active Directory constrained delegation permissions required for shared-nothing live migration. You will enable live migration on both Hyper-V hosts and select Kerberos authentication with compression.
:::

### Task 1: Configure Live Migration on LON-SVR2

1. [ ] On LON-SVR2, open **Server Manager**.

2. [ ] Select **Tools** > **Hyper-V Manager**.

3. [ ] In the left pane, select **LON-SVR2**.

4. [ ] In the **Actions** pane, select **Hyper-V Settings...**.

5. [ ] In the left pane of the **Hyper-V Settings** window, select **Live Migrations**.

6. [ ] Select **Enable incoming and outgoing live migrations**.

7. [ ] Leave **Simultaneous live migrations** set to `2`.

8. [ ] Under **Incoming live migrations**, verify that **Use any available network for live migration** is selected.

9. [ ] In the left pane, expand **Live Migrations**.

10. [ ] Select **Advanced Features**.

11. [ ] Under **Authentication protocol**, select **Use Kerberos**.

12. [ ] Under **Performance options**, select **Compression** if it is not already selected.

13. [ ] Select **Apply**.

14. [ ] Select **OK**.

### Task 2: Configure Live Migration on LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Verify that **Enhanced mode** is turned on.

4. [ ] Use the displayed credentials to sign in if prompted.

5. [ ] Open **Server Manager**.

6. [ ] Select **Tools** > **Hyper-V Manager**.

7. [ ] Select **LON-SVR1** in the left pane.

8. [ ] In the **Actions** pane, select **Hyper-V Settings...**.

9. [ ] Select **Live Migrations**.

10. [ ] Select **Enable incoming and outgoing live migrations**.

11. [ ] Leave **Simultaneous live migrations** set to `2`.

12. [ ] Verify that **Use any available network for live migration** is selected.

13. [ ] Expand **Live Migrations** in the left pane.

14. [ ] Select **Advanced Features**.

15. [ ] Select **Use Kerberos**.

16. [ ] Select **Compression**.

17. [ ] Select **Apply**.

18. [ ] Select **OK**.

   ::: warning
   **Note**: Using any available host network is acceptable in this isolated lab. Live migration traffic is not encrypted by default. Production environments should use a trusted, dedicated network or another protected network design for migration traffic.
   :::

### Task 3: Connect Hyper-V Manager to Both Hosts

1. [ ] In Hyper-V Manager on LON-SVR1, right-click **Hyper-V Manager** at the top of the left pane.

2. [ ] Select **Connect to Server...**.

3. [ ] Select **Another computer**.

4. [ ] Enter `LON-SVR2`.

5. [ ] Select **OK**.

6. [ ] Verify that both **LON-SVR1** and **LON-SVR2** appear under **Hyper-V Manager**.

7. [ ] Select each server and verify that its **Virtual Machines** pane opens without an error.

::: success
**Results**: After completing this exercise, both Hyper-V hosts accept Kerberos-authenticated live migrations using compression.
:::

## Exercise 4: Download the Evaluation VHDX and Create WS2025-LM1

::: secondary
**Scenario**

Installing a guest operating system from an ISO would consume much of the lab. You will instead download Microsoft’s prepared Windows Server 2025 Datacenter Evaluation VHDX and attach it to a new Generation 2 virtual machine.
:::

### Task 1: Create the VM Storage Folders on LON-SVR1

1. [ ] On LON-SVR1, open **File Explorer**.

2. [ ] In the address bar, enter `C:\`.

3. [ ] Select **New** > **Folder**.

4. [ ] Name the folder `Lab15`.

5. [ ] Open `C:\Lab15`.

6. [ ] Select **New** > **Folder**.

7. [ ] Name the folder `WS2025-LM1`.

8. [ ] Open `C:\Lab15\WS2025-LM1`.

9. [ ] Select **New** > **Folder**.

10. [ ] Name the folder `Virtual Hard Disks`.

11. [ ] Verify that the full folder path is `C:\Lab15\WS2025-LM1\Virtual Hard Disks`.

### Task 2: Prepare the Destination Folder on LON-SVR2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.

3. [ ] Use the displayed credentials to sign in if prompted.

4. [ ] Open **File Explorer**.

5. [ ] Browse to `C:\`.

6. [ ] Create a folder named `Lab15`.

7. [ ] Verify that `C:\Lab15` is empty and has at least 25 GB of free space available on the volume.

8. [ ] Close File Explorer.

### Task 3: Download the Windows Server 2025 Evaluation VHDX

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the displayed credentials to sign in if prompted.

4. [ ] Open **Microsoft Edge** from the Start menu.

5. [ ] In the address bar, enter the following Microsoft download link:

```text
https://go.microsoft.com/fwlink/?linkid=2345826&clcid=0x809&culture=en-gb&country=gb
```

6. [ ] Start the download if Microsoft Edge asks for confirmation.

7. [ ] Open the **Downloads** panel in Microsoft Edge.

8. [ ] Wait until the VHDX download is complete.

9. [ ] Verify that the completed file is approximately 10.88 GB.

   ::: warning
   **Note**: Do not create the virtual machine until the download is complete. An interrupted or incomplete VHDX cannot boot.
   :::

10. [ ] In the Downloads panel, select the folder icon for the downloaded VHDX to open its location in File Explorer.

11. [ ] Right-click the downloaded VHDX file.

12. [ ] Select **Cut**.

13. [ ] Browse to `C:\Lab15\WS2025-LM1\Virtual Hard Disks`.

14. [ ] Right-click an empty area in the folder.

15. [ ] Select **Paste**.

16. [ ] Wait for the file move to complete.

17. [ ] Right-click the VHDX file.

18. [ ] Select **Rename**.

19. [ ] Enter `WS2025-LM1.vhdx`.

20. [ ] Verify that the full path is `C:\Lab15\WS2025-LM1\Virtual Hard Disks\WS2025-LM1.vhdx`.

21. [ ] Close Microsoft Edge.

### Task 4: Create the Generation 2 Virtual Machine

1. [ ] On LON-SVR1, open **Server Manager**.

2. [ ] Select **Tools** > **Hyper-V Manager**.

3. [ ] In the left pane, select **LON-SVR1**.

4. [ ] In the **Actions** pane, select **New** > **Virtual Machine...**.

5. [ ] On the **Before You Begin** page, select **Next >**.

6. [ ] On the **Specify Name and Location** page, enter `WS2025-LM1` in the **Name** field.

7. [ ] Select **Store the virtual machine in a different location**.

8. [ ] In the **Location** field, enter `C:\Lab15`.

9. [ ] Select **Next >**.

10. [ ] On the **Specify Generation** page, select **Generation 2**.

11. [ ] Select **Next >**.

12. [ ] On the **Assign Memory** page, enter `2048` in **Startup memory**.

13. [ ] Select **Use Dynamic Memory for this virtual machine**.

14. [ ] Select **Next >**.

15. [ ] On the **Configure Networking** page, select `Lab15-Private` from the **Connection** dropdown.

16. [ ] Select **Next >**.

17. [ ] On the **Connect Virtual Hard Disk** page, select **Use an existing virtual hard disk**.

18. [ ] In the **Location** field, enter `C:\Lab15\WS2025-LM1\Virtual Hard Disks\WS2025-LM1.vhdx`.

19. [ ] Select **Next >**.

20. [ ] On the **Summary** page, review the settings.

21. [ ] Verify that the VM is Generation 2, uses 2048 MB of startup memory, connects to `Lab15-Private`, and uses the downloaded VHDX.

22. [ ] Select **Finish**.

23. [ ] In Hyper-V Manager, verify that **WS2025-LM1** appears in the **Virtual Machines** pane with a state of **Off**.

### Task 5: Enable Processor Compatibility

1. [ ] In Hyper-V Manager, right-click **WS2025-LM1**.

2. [ ] Select **Settings...**.

3. [ ] In the left pane, expand **Processor**.

4. [ ] Select **Compatibility**.

5. [ ] Select **Migrate to a physical computer with a different processor version**.

6. [ ] Select **Apply**.

7. [ ] Select **OK**.

   ::: warning
   **Note**: Processor compatibility reduces the processor features exposed to the VM so it can migrate between hosts with different processor versions from the same processor manufacturer. It does not permit migration between Intel and AMD hosts.
   :::

### Task 6: Start the VM and Complete First-Boot Setup

1. [ ] In Hyper-V Manager, right-click **WS2025-LM1**.

2. [ ] Select **Connect...**.

3. [ ] In the **Virtual Machine Connection** window, select **Start**.

4. [ ] Wait for Windows Server 2025 to start.

5. [ ] Complete any first-boot region, language, licence, or evaluation prompts that appear.

6. [ ] When prompted, create a password for the local **Administrator** account.

7. [ ] Record the password in the location specified by your instructor.

8. [ ] Sign in to the guest as **Administrator**.

9. [ ] Wait for the Windows Server desktop to appear inside the Virtual Machine Connection window.

10. [ ] In Hyper-V Manager, verify that **WS2025-LM1** shows a state of **Running** on LON-SVR1.

   ::: warning
   **Note**: The `Lab15-Private` switch does not provide internet or lab-network access. The guest may show that its network is unidentified or disconnected from the internet; this is expected.
   :::

::: success
**Results**: After completing this exercise, WS2025-LM1 is running Windows Server 2025 from local storage on LON-SVR1.
:::

## Exercise 5: Perform a Shared-Nothing Live Migration

::: secondary
**Scenario**

LON-SVR1 needs maintenance, but WS2025-LM1 must remain running. You will start a visible activity inside the guest and then move the running VM and all its files to LON-SVR2.
:::

### Task 1: Record the Guest Uptime

1. [ ] Inside the WS2025-LM1 guest desktop, select **Start**.

2. [ ] Type **PowerShell**.

3. [ ] In the search results, select **Windows PowerShell**.

4. [ ] Run the following command:

```powershell
(Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
```

5. [ ] Record the displayed uptime:

```text
Uptime before migration: ______________________________
```

6. [ ] Run the following script to display a timestamp every two seconds for up to one hour:

```powershell
1..1800 | ForEach-Object {
    Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Start-Sleep -Seconds 2
}
```

7. [ ] Leave the Windows PowerShell and Virtual Machine Connection windows open.

### Task 2: Start the Move Wizard

1. [ ] Return to Hyper-V Manager on LON-SVR1 without closing the VM connection.

2. [ ] In the left pane, select **LON-SVR1**.

3. [ ] In the **Virtual Machines** pane, verify that **WS2025-LM1** shows **Running**.

4. [ ] Right-click **WS2025-LM1**.

5. [ ] Select **Move...**.

6. [ ] On the **Before You Begin** page, select **Next >**.

7. [ ] On the **Choose Move Type** page, select **Move the virtual machine**.

8. [ ] Select **Next >**.

### Task 3: Select LON-SVR2 and Move the VM Storage

1. [ ] On the **Specify Destination** page, enter `LON-SVR2.contoso.com` in the **Name** field.

2. [ ] Select **Next >**.

3. [ ] On the **Choose Move Options** page, select **Move the virtual machine's data to a single location**.

4. [ ] Select **Next >**.

5. [ ] On the **Choose a new location for virtual machine** page, enter `C:\Lab15\WS2025-LM1`.

6. [ ] Select **Next >**.

7. [ ] On the **Summary** page, verify:

   - **Destination computer** is LON-SVR2
   - The VM data will be moved
   - The destination location is `C:\Lab15\WS2025-LM1`

8. [ ] Select **Finish**.

9. [ ] Observe the migration progress in Hyper-V Manager.

10. [ ] Do not close Hyper-V Manager or turn off either host while the migration is running.

   ::: warning
   **Note**: The first migration includes the approximately 10.88 GB VHDX and can take several minutes. Migration time depends on the lab platform’s storage and network performance.
   :::

### Task 4: Confirm That the VM Remained Running

1. [ ] Return to the open **Virtual Machine Connection** window.

2. [ ] Verify that timestamps continued to appear during the migration or resumed without a guest restart.

3. [ ] Close the Windows PowerShell window that is displaying timestamps.

4. [ ] In the guest, select **Start**.

5. [ ] Type **PowerShell**.

6. [ ] Select **Windows PowerShell** from the search results.

7. [ ] Run the following command:

```powershell
(Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
```

8. [ ] Record the displayed uptime:

```text
Uptime after migration: _______________________________
```

9. [ ] Compare the before and after values.

10. [ ] Verify that the uptime increased rather than restarting from zero.

   ::: warning
   **Note**: A brief pause in the console display can occur during the final migration switchover. The guest operating system should not restart.
   :::

### Task 5: Confirm the Destination Host

1. [ ] In Hyper-V Manager, select **LON-SVR1**.

2. [ ] Verify that **WS2025-LM1** no longer appears in the LON-SVR1 virtual machine list.

3. [ ] In the left pane, select **LON-SVR2**.

4. [ ] Verify that **WS2025-LM1** appears with a state of **Running**.

5. [ ] Right-click **WS2025-LM1** under LON-SVR2.

6. [ ] Select **Settings...**.

7. [ ] Select the virtual hard disk under the **SCSI Controller**.

8. [ ] Verify that the virtual hard disk path begins with `C:\Lab15\WS2025-LM1`.

9. [ ] Select **Cancel**.

::: success
**Results**: After completing this exercise, WS2025-LM1 and its storage are running on LON-SVR2 without a guest operating system restart.
:::

## Exercise 6: Validate, Troubleshoot, and Review the Configuration

::: secondary
**Scenario**

After a live migration, an administrator should verify host settings, VM placement, storage paths, and related events. You will validate the final state and review common migration failure points.
:::

### Task 1: Validate the Final State with PowerShell

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.

3. [ ] Verify that **Enhanced mode** is turned on.

4. [ ] Use the displayed credentials to sign in if prompted.

5. [ ] Open Windows PowerShell as Administrator from the Start menu.

6. [ ] Run the following command:

```powershell
Get-VMHost |
    Select-Object Name,
        VirtualMachineMigrationEnabled,
        VirtualMachineMigrationAuthenticationType,
        VirtualMachineMigrationPerformanceOption
```

7. [ ] Verify that:

   - **Name** identifies LON-SVR2
   - **VirtualMachineMigrationEnabled** is `True`
   - **VirtualMachineMigrationAuthenticationType** is `Kerberos`
   - **VirtualMachineMigrationPerformanceOption** is `Compression`

8. [ ] Run the following command:

```powershell
Get-VMSwitch -Name "Lab15-Private" |
    Select-Object Name, SwitchType
```

9. [ ] Verify that **SwitchType** is `Private`.

10. [ ] Run the following command:

```powershell
Get-VM -Name "WS2025-LM1" |
    Select-Object Name, ComputerName, State, Uptime, Path
```

11. [ ] Verify that:

   - **ComputerName** identifies LON-SVR2
   - **State** is `Running`
   - **Uptime** has not restarted
   - **Path** begins with `C:\Lab15\WS2025-LM1`

12. [ ] Run the following command:

```powershell
Get-VMHardDiskDrive -VMName "WS2025-LM1" |
    Select-Object VMName, ControllerType, Path
```

13. [ ] Verify that the VHDX path begins with `C:\Lab15\WS2025-LM1`.

14. [ ] Run the following command:

```powershell
Get-VMProcessor -VMName "WS2025-LM1" |
    Select-Object VMName, CompatibilityForMigrationEnabled
```

15. [ ] Verify that **CompatibilityForMigrationEnabled** is `True`.

16. [ ] Close Windows PowerShell.

::: success
**Results**: After completing this task, you have validated the destination host, virtual switch, migration settings, VM state, uptime, storage path, and processor compatibility.
:::

### Task 2: Review Hyper-V VMMS Events

1. [ ] On LON-SVR2, open **Server Manager**.

2. [ ] Select **Tools** > **Event Viewer**.

3. [ ] In the left pane, expand **Applications and Services Logs**.

4. [ ] Expand **Microsoft**.

5. [ ] Expand **Windows**.

6. [ ] Expand **Hyper-V-VMMS**.

7. [ ] Select **Admin**.

8. [ ] In the **Actions** pane, select **Refresh**.

9. [ ] Select the **Date and Time** column to place recent events together.

10. [ ] Review events created around the time of the migration.

11. [ ] Select recent events and review the **General** tab for references to WS2025-LM1 or migration activity.

12. [ ] Verify that no unresolved **Critical** or **Error** event indicates that WS2025-LM1 failed to register or start on LON-SVR2.

   ::: warning
   **Note**: Informational event IDs and wording can vary with the Windows Server build. Use the event time, level, source, and message together when evaluating migration activity.
   :::

::: success
**Results**: After completing this task, you have reviewed the Hyper-V Virtual Machine Management Service event log for migration-related activity.
:::

### Task 3: Review Common Live Migration Problems

1. [ ] Review the following troubleshooting table:

| Symptom | Likely cause | Corrective action |
|---|---|---|
| **No credentials are available in the security package** or error `0x8009030E` | Kerberos delegation is missing, points to the wrong host, or the current ticket predates the change | Verify both computer accounts in Active Directory Users and Computers, then sign out and sign in again |
| **General access denied** or error `0x80070005` | The account lacks rights on one host or constrained delegation is incomplete | Use an account that is an administrator on both hosts and verify the `cifs` and migration service entries |
| **No matching virtual switch was found** | The destination switch is missing or its name differs | Create a private switch named exactly `Lab15-Private` on both hosts |
| **Hardware is not compatible** | The hosts expose different processor features | Shut down the VM temporarily and enable **Migrate to a physical computer with a different processor version** |
| **There is not enough space on the disk** | The destination volume cannot hold the VHDX and VM files | Free space or select a destination with sufficient capacity |
| The **Move** operation cannot establish a migration connection | Live migration is disabled or authentication differs between hosts | Enable incoming and outgoing migrations and select Kerberos on both hosts |
| Migration is very slow | The VHDX is large or the lab network and storage are busy | Allow the operation to finish and avoid starting another large download or migration |

2. [ ] In Hyper-V Manager, select **LON-SVR2**.

3. [ ] Select **Hyper-V Settings...**.

4. [ ] Select **Live Migrations**.

5. [ ] Verify that **Enable incoming and outgoing live migrations** remains selected.

6. [ ] Expand **Live Migrations**.

7. [ ] Select **Advanced Features**.

8. [ ] Verify that **Use Kerberos** and **Compression** remain selected.

9. [ ] Select **Cancel** without changing the settings.

::: success
**Results**: After completing this task, you can identify and correct common authentication, networking, processor, storage, and host-configuration problems that affect live migration.
:::

### Task 4: Review the Administrative Changes

1. [ ] Review the following change summary:

| System | Administrative changes |
|---|---|
| **LON-DC1** | Configured constrained delegation on the LON-SVR1 and LON-SVR2 computer accounts for `cifs` and **Microsoft Virtual System Migration Service** |
| **LON-SVR1** | Installed Hyper-V, created `Lab15-Private`, enabled Kerberos live migration, downloaded the evaluation VHDX, and created WS2025-LM1 |
| **LON-SVR2** | Installed Hyper-V, created `Lab15-Private`, enabled Kerberos live migration, and received the running VM and its storage |
| **WS2025-LM1** | Deployed Windows Server 2025 Evaluation, enabled processor compatibility, and remained running during migration |

2. [ ] Verify that the final location of WS2025-LM1 is **LON-SVR2**.

3. [ ] Verify that the VM remains **Running**.

4. [ ] Leave WS2025-LM1 on LON-SVR2 for the end of the lab.

::: success
**Results**: After completing this exercise, you have validated and documented the final nonclustered Hyper-V live migration configuration.
:::

## Further Reading

- [Set up hosts for live migration without Failover Clustering](https://learn.microsoft.com/windows-server/virtualization/hyper-v/deploy/set-up-hosts-for-live-migration-without-failover-clustering)
- [Use live migration without Failover Clustering to move a virtual machine](https://learn.microsoft.com/windows-server/virtualization/hyper-v/manage/use-live-migration-without-failover-clustering-to-move-a-virtual-machine)
- [Windows Server 2025 Evaluation Center](https://www.microsoft.com/evalcenter/download-windows-server-2025)
- [Configure processor compatibility in Hyper-V virtual machines](https://learn.microsoft.com/windows-server/virtualization/hyper-v/configure-processor-compatibility-mode)

::: success
**Results**: You have completed Lab 1501. You can now install Hyper-V on multiple hosts, configure matching virtual networking, use Kerberos constrained delegation, deploy a VM from an existing VHDX, and perform a shared-nothing live migration without restarting the guest operating system.
:::
