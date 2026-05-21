# Practice Lab 0801: Creating Storage Pools and SMB Shares

## Summary

::: secondary
In this lab, you will prepare shared iSCSI storage, connect that storage to a Windows Server 2025 member server, create a storage pool, create a volume from the pool, and publish an SMB file share from that volume. You will then switch to the domain controller and map the shared folder as a network drive.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to **LON-SRV2**, **LON-SRV1**, and **LON-DC1**
- Access to the course supporting content folder for Lab 8
- Basic familiarity with Server Manager and File Explorer
:::

::: warning
**Note**: This lab uses **LON-SRV2** to host three dynamic 20 GB iSCSI virtual disks. **LON-SRV1** connects to those disks and uses them to create the storage pool and file share. Do not initialize or format the three iSCSI disks in Disk Management before you create the storage pool.
:::

## Exercise 1: Prepare iSCSI Storage on LON-SRV2

::: secondary
**Scenario**

Your organization wants to present storage from one server to another server over the network. You will run a prepared script on **LON-SRV2** that creates three dynamic expanding VHDX files and presents them to **LON-SRV1** by using the iSCSI Target Server role.
:::

### Task 1: Connect to LON-SRV2

1. [ ] In the lab platform, select **HOME**.
2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.
3. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.
4. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.
5. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.
6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SRV2 through the lab platform.
:::

### Task 2: Locate the Lab 8 Supporting Script

1. [ ] Open **File Explorer** from **Start**.
2. [ ] Browse to the location where the course lab files are stored.
3. [ ] Open **supporting content**.
4. [ ] Open **Lab8**.
5. [ ] Verify that the folder contains `Prepare-Lab8IscsiTarget.ps1`.

::: warning
**Note**: If your lab files are stored in `C:\LabFiles`, the full folder path is `C:\LabFiles\supporting content\Lab8`.
:::

::: success
**Results**: After completing this task, you have located the script that prepares the iSCSI target on LON-SRV2.
:::

### Task 3: Run the iSCSI Target Preparation Script

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] Right-click **Windows PowerShell** and select **Run as administrator**.
4. [ ] In the **User Account Control** dialog, select **Yes** if prompted.
5. [ ] Change to the folder that contains the Lab 8 script. For example, if your lab files are in `C:\LabFiles`, run:

```powershell
Set-Location "C:\LabFiles\supporting content\Lab8"
```

6. [ ] Run the script:

```powershell
.\Prepare-Lab8IscsiTarget.ps1
```

7. [ ] Wait for the script to finish.
8. [ ] Verify that the output lists three virtual disks named `Lab8Disk01.vhdx`, `Lab8Disk02.vhdx`, and `Lab8Disk03.vhdx`.
9. [ ] Verify that each disk shows a size of approximately **20 GB**.

::: warning
**Note**: The script installs the **iSCSI Target Server** role service if it is not already installed. This may take a few moments the first time the script runs.
:::

::: success
**Results**: After completing this task, LON-SRV2 is presenting three 20 GB iSCSI virtual disks for LON-SRV1.
:::

### Task 4: Review the iSCSI Target in Server Manager

1. [ ] Open **Server Manager**.
2. [ ] In the left navigation pane, select **File and Storage Services**.
3. [ ] Select **iSCSI**.
4. [ ] In the **iSCSI Virtual Disks** tile, verify that three virtual disks are listed.
5. [ ] In the **iSCSI Targets** tile, verify that `Lab8-StoragePool-Target` is listed.
6. [ ] Select `Lab8-StoragePool-Target`.
7. [ ] Review the **Virtual Disks** area and verify that the three Lab 8 virtual disks are assigned to the target.

::: warning
**Note**: Server Manager may take a short time to refresh after the script completes. If the iSCSI page does not show the target immediately, select **Refresh** in Server Manager.
:::

::: success
**Results**: After completing this exercise, you will have verified the iSCSI target and virtual disks on LON-SRV2.
:::

## Exercise 2: Connect LON-SRV1 to the iSCSI Disks

::: secondary
**Scenario**

LON-SRV1 will use the iSCSI disks as raw storage for a new storage pool. You will run a prepared script to configure the iSCSI Initiator service, connect to LON-SRV2, and make the disks visible to Windows.
:::

### Task 1: Connect to LON-SRV1

1. [ ] In the lab platform, select **HOME**.
2. [ ] From the **Select VM** dropdown, select **LON-SRV1**.
3. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.
4. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.
5. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.
6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SRV1 through the lab platform.
:::

### Task 2: Run the iSCSI Connection Script

1. [ ] Select **Start**.
2. [ ] Type **PowerShell**.
3. [ ] Right-click **Windows PowerShell** and select **Run as administrator**.
4. [ ] In the **User Account Control** dialog, select **Yes** if prompted.
5. [ ] Change to the folder that contains the Lab 8 script. For example, if your lab files are in `C:\LabFiles`, run:

```powershell
Set-Location "C:\LabFiles\supporting content\Lab8"
```

6. [ ] Run the script:

```powershell
.\Connect-Lab8IscsiDisks.ps1
```

7. [ ] Wait for the script to finish.
8. [ ] Verify that the output shows an iSCSI target with **IsConnected** set to **True**.
9. [ ] Verify that the output lists three disks with **BusType** shown as iSCSI or with the iSCSI disks shown in the disk list.

::: success
**Results**: After completing this task, LON-SRV1 is connected to the three iSCSI disks hosted by LON-SRV2.
:::

### Task 3: Confirm the Disks in Disk Management

1. [ ] Open **Server Manager**.
2. [ ] Select **Tools**.
3. [ ] Select **Computer Management**.
4. [ ] In **Computer Management**, expand **Storage**.
5. [ ] Select **Disk Management**.
6. [ ] If the **Initialize Disk** dialog appears, select **Cancel**.
7. [ ] In the lower pane, locate the three new disks of approximately **20 GB** each.
8. [ ] Verify that the disks are visible and do not contain volumes.
9. [ ] Leave **Disk Management** open while you review the disks, but do not create volumes here.

::: warning
**Note**: The disks must remain available as raw disks so Storage Spaces can add them to a storage pool. Initializing or formatting them in Disk Management would use them as standard disks instead of pooled storage.
:::

::: success
**Results**: After completing this exercise, you will have confirmed that LON-SRV1 can see the three iSCSI disks that will be used for the storage pool.
:::

## Exercise 3: Create a Storage Pool and Volume on LON-SRV1

::: secondary
**Scenario**

The raw iSCSI disks are now visible to LON-SRV1. You will use Server Manager to combine them into a storage pool, create a virtual disk, and create a formatted volume for shared data.
:::

### Task 1: Open Storage Pools in Server Manager

1. [ ] On **LON-SRV1**, bring **Server Manager** to the front.
2. [ ] In the left navigation pane, select **File and Storage Services**.
3. [ ] Select **Storage Pools**.
4. [ ] Review the **Storage Pools** tile.
5. [ ] Verify that a **Primordial** storage pool is listed.
6. [ ] Select the **Primordial** storage pool and review the **Physical Disks** tile.
7. [ ] Verify that the three iSCSI disks are shown as available physical disks.

::: success
**Results**: After completing this task, you have located the available iSCSI disks in Server Manager.
:::

### Task 2: Create the Storage Pool

1. [ ] In the **Storage Pools** tile, select **Tasks**.
2. [ ] Select **New Storage Pool**.
3. [ ] On the **Before you begin** page, select **Next >**.
4. [ ] On the **Specify a storage pool name and subsystem** page, enter `Lab8Pool` in **Name**.
5. [ ] Verify that **LON-SRV1** is selected as the server.
6. [ ] Verify that **Windows Storage** is selected as the storage subsystem.
7. [ ] Select **Next >**.
8. [ ] On the **Select physical disks for the storage pool** page, select the checkboxes for the three 20 GB iSCSI disks.
9. [ ] Leave **Allocation** set to **Automatic** for each selected disk.
10. [ ] Select **Next >**.
11. [ ] On the **Confirm selections** page, review the storage pool name and selected disks.
12. [ ] Select **Create**.
13. [ ] Wait for the **View results** page to show that the task completed successfully.
14. [ ] Clear **Create a virtual disk when this wizard closes** if it is selected.
15. [ ] Select **Close**.

::: success
**Results**: After completing this task, you have created a storage pool named Lab8Pool on LON-SRV1.
:::

### Task 3: Create a Virtual Disk from the Pool

1. [ ] In **Server Manager**, select the **Lab8Pool** storage pool.
2. [ ] In the **Virtual Disks** tile, select **Tasks**.
3. [ ] Select **New Virtual Disk**.
4. [ ] On the **Before you begin** page, select **Next >**.
5. [ ] On the **Select the server and storage pool** page, verify that **LON-SRV1** and **Lab8Pool** are selected.
6. [ ] Select **Next >**.
7. [ ] On the **Specify the virtual disk name** page, enter `Lab8VirtualDisk` in **Name**.
8. [ ] Select **Next >**.
9. [ ] On the **Configure storage enclosure resiliency** page, leave the default selection and select **Next >**.
10. [ ] On the **Select the storage layout** page, select **Parity**.
11. [ ] Select **Next >**.
12. [ ] On the **Select the provisioning type** page, select **Thin**.
13. [ ] Select **Next >**.
14. [ ] On the **Specify the size of the virtual disk** page, select **Specify size**.
15. [ ] Enter `30` in the size box and select **GB** as the unit.
16. [ ] Select **Next >**.
17. [ ] On the **Confirm selections** page, review the selected options.
18. [ ] Select **Create**.
19. [ ] Wait for the **View results** page to show that the virtual disk was created successfully.
20. [ ] Select **Create a volume when this wizard closes**.
21. [ ] Select **Close**.

::: warning
**Note**: A parity layout uses capacity across multiple disks and can tolerate a disk failure in many production designs. This lab uses iSCSI-backed virtual disks, so the goal is to learn the workflow rather than to build production-grade fault tolerance.
:::

::: success
**Results**: After completing this task, you have created a virtual disk named Lab8VirtualDisk from the storage pool.
:::

### Task 4: Create and Format the Volume

1. [ ] In the **New Volume Wizard**, on the **Before you begin** page, select **Next >**.
2. [ ] On the **Select the server and disk** page, verify that **LON-SRV1** is selected.
3. [ ] Verify that the disk associated with `Lab8VirtualDisk` is selected.
4. [ ] Select **Next >**.
5. [ ] On the **Specify the size of the volume** page, leave the default size selected.
6. [ ] Select **Next >**.
7. [ ] On the **Assign to a drive letter or folder** page, select **Drive letter**.
8. [ ] Select **S:** from the drive letter dropdown.
9. [ ] Select **Next >**.
10. [ ] On the **Select file system settings** page, set **File system** to **NTFS**.
11. [ ] Leave **Allocation unit size** set to **Default**.
12. [ ] Enter `Lab8Data` in **Volume label**.
13. [ ] Select **Next >**.
14. [ ] On the **Confirm selections** page, review the volume settings.
15. [ ] Select **Create**.
16. [ ] Wait for the **Completion** page to show that the volume was created successfully.
17. [ ] Select **Close**.
18. [ ] Open **File Explorer** from **Start**.
19. [ ] Select **This PC**.
20. [ ] Verify that drive **S:** appears with the label **Lab8Data**.

::: success
**Results**: After completing this exercise, you will have created and formatted an NTFS volume from the storage pool on LON-SRV1.
:::

## Exercise 4: Create an SMB Share on the Storage Pool Volume

::: secondary
**Scenario**

Now that LON-SRV1 has a volume backed by the storage pool, you will create a shared folder on that volume. This gives other domain computers a standard SMB path to reach data stored on the pooled storage.
:::

### Task 1: Create the Shared Folder Location

1. [ ] On **LON-SRV1**, open **File Explorer**.
2. [ ] Select **This PC**.
3. [ ] Open **Lab8Data (S:)**.
4. [ ] Right-click in the empty area of the drive.
5. [ ] Select **New**.
6. [ ] Select **Folder**.
7. [ ] Name the folder `Lab8Share`.
8. [ ] Open the `Lab8Share` folder.
9. [ ] Right-click in the empty area of the folder.
10. [ ] Select **New**.
11. [ ] Select **Text Document**.
12. [ ] Name the file `StoragePoolTest.txt`.
13. [ ] Open `StoragePoolTest.txt`.
14. [ ] Enter `This file is stored on the Lab8 storage pool.`
15. [ ] Select **File**.
16. [ ] Select **Save**.
17. [ ] Close **Notepad**.

::: success
**Results**: After completing this task, you have created a folder and test file on the storage pool volume.
:::

### Task 2: Start the New Share Wizard

1. [ ] Bring **Server Manager** to the front.
2. [ ] In the left navigation pane, select **File and Storage Services**.
3. [ ] Select **Shares**.
4. [ ] In the **Shares** tile, select **Tasks**.
5. [ ] Select **New Share**.
6. [ ] On the **Select the profile for this share** page, select **SMB Share - Quick**.
7. [ ] Select **Next >**.

::: success
**Results**: After completing this task, you have started the wizard for creating an SMB share.
:::

### Task 3: Configure the Share Path and Name

1. [ ] On the **Select the server and path for this share** page, verify that **LON-SRV1** is selected.
2. [ ] Select **Type a custom path**.
3. [ ] Enter `S:\Lab8Share` in the path box.
4. [ ] Select **Next >**.
5. [ ] On the **Specify share name** page, enter `Lab8Share` in **Share name**.
6. [ ] Verify that **Remote path to share** shows `\\LON-SRV1\Lab8Share`.
7. [ ] Select **Next >**.

::: success
**Results**: After completing this task, the share wizard is configured to publish S:\Lab8Share as \\LON-SRV1\Lab8Share.
:::

### Task 4: Review Share Settings and Permissions

1. [ ] On the **Configure share settings** page, leave the default selections.
2. [ ] Select **Next >**.
3. [ ] On the **Specify permissions to control access** page, review the default permissions.
4. [ ] Verify that administrators have full control.
5. [ ] Verify that users have at least read access.
6. [ ] Select **Next >**.
7. [ ] On the **Confirm selections** page, review the share path and settings.
8. [ ] Select **Create**.
9. [ ] Wait for the **View results** page to show that the share was created successfully.
10. [ ] Select **Close**.

::: warning
**Note**: Production file shares should be scoped to the groups that need access. Broad read access can be useful in a lab, but production shares usually require tighter NTFS and share permissions.
:::

::: success
**Results**: After completing this task, you have created an SMB share named Lab8Share on the storage pool volume.
:::

### Task 5: Validate the Share from LON-SRV1

1. [ ] Open **File Explorer**.
2. [ ] Select the address bar.
3. [ ] Enter `\\LON-SRV1\Lab8Share`.
4. [ ] Verify that the shared folder opens.
5. [ ] Verify that `StoragePoolTest.txt` is visible.
6. [ ] Close **File Explorer**.

::: success
**Results**: After completing this exercise, you will have created and tested an SMB share stored on the storage pool volume.
:::

## Exercise 5: Map the SMB Share from LON-DC1

::: secondary
**Scenario**

You will now switch to the domain controller and access the share across the lab network. This confirms that the SMB share is reachable from another domain computer.
:::

### Task 1: Connect to LON-DC1

1. [ ] In the lab platform, select **HOME**.
2. [ ] From the **Select VM** dropdown, select **LON-DC1**.
3. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.
4. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.
5. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.
6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-DC1 through the lab platform.
:::

### Task 2: Map the Network Drive

1. [ ] Open **File Explorer** from **Start**.
2. [ ] Select **This PC**.
3. [ ] In the command bar, select **See more**.
4. [ ] Select **Map network drive**.
5. [ ] In the **Map Network Drive** window, select **Z:** for **Drive**.
6. [ ] In **Folder**, enter `\\LON-SRV1\Lab8Share`.
7. [ ] Leave **Reconnect at sign-in** selected.
8. [ ] Select **Finish**.
9. [ ] If you are prompted for credentials, enter the username and password shown in the lab platform for the selected VM.

::: warning
**Note**: If your File Explorer shows a ribbon instead of the command bar, select **Computer** and then select **Map network drive**.
:::

::: success
**Results**: After completing this task, the SMB share is mapped to drive Z: on LON-DC1.
:::

### Task 3: Validate Access to the Shared File

1. [ ] In **File Explorer**, select **This PC**.
2. [ ] Open mapped drive **Z:**.
3. [ ] Verify that `StoragePoolTest.txt` is visible.
4. [ ] Open `StoragePoolTest.txt`.
5. [ ] Verify that the file contains the text `This file is stored on the Lab8 storage pool.`
6. [ ] Close **Notepad**.

::: success
**Results**: After completing this exercise, you will have mapped and validated the SMB share from LON-DC1.
:::

## Exercise 6: Review the Storage Configuration

::: secondary
**Scenario**

You have created a complete storage path: iSCSI virtual disks on LON-SRV2, a storage pool and volume on LON-SRV1, and an SMB share accessed from LON-DC1. You will review what changed and the security impact of the configuration.
:::

### Task 1: Review the Administrative Change Summary

1. [ ] Review the following changes completed in this lab:

| Server | Administrative change |
| --- | --- |
| **LON-SRV2** | Installed or confirmed the iSCSI Target Server role service. |
| **LON-SRV2** | Created three dynamic 20 GB VHDX-backed iSCSI virtual disks in `C:\Lab8-iSCSI`. |
| **LON-SRV2** | Created the iSCSI target `Lab8-StoragePool-Target` and allowed LON-SRV1 to connect. |
| **LON-SRV1** | Started and configured the Microsoft iSCSI Initiator service. |
| **LON-SRV1** | Connected to the three iSCSI disks from LON-SRV2. |
| **LON-SRV1** | Created the storage pool `Lab8Pool`. |
| **LON-SRV1** | Created the virtual disk `Lab8VirtualDisk` and the NTFS volume `Lab8Data (S:)`. |
| **LON-SRV1** | Created the SMB share `\\LON-SRV1\Lab8Share`. |
| **LON-DC1** | Mapped `\\LON-SRV1\Lab8Share` to drive **Z:**. |

::: success
**Results**: After completing this task, you have reviewed the administrative changes made during the lab.
:::

### Task 2: Review Security and Operational Impact

1. [ ] Review the iSCSI design used in this lab.
2. [ ] Note that only **LON-SRV1** should be allowed to connect to the iSCSI target.
3. [ ] Review the SMB share permissions used in this lab.
4. [ ] Note that production shares should usually grant access to specific domain groups instead of broad user groups.
5. [ ] Review the storage layout used in this lab.
6. [ ] Note that production storage design should account for disk performance, fault tolerance, backup, monitoring, and recovery.
7. [ ] Keep the lab configuration in place unless your instructor asks you to remove it.

::: success
**Results**: After completing this exercise, you will have reviewed the security and operational impact of the storage pool and SMB share configuration.
:::

::: success
**Results**: You have successfully completed Lab 0801. You can now prepare iSCSI-backed lab storage, connect it to a Windows Server 2025 member server, create a storage pool, create an SMB share on the pooled storage, and map the share from another domain server.
:::
