# Practice Lab 0801: Managing Disks, Volumes, and NTFS Permissions

## Summary

::: secondary
In this lab, you will manage local storage on your Windows Server. You will view disk configuration, create partitions/volumes, format drives, and configure NTFS permissions. Understanding storage management is critical for server operations.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SRV1
- Understanding of disk management concepts
:::

## Exercise 1: Viewing Current Disk Configuration

::: secondary
**Scenario**

You need to understand the current storage configuration of your server before making any changes. You will view disk information using both Disk Management and PowerShell.
:::

### Task 1: Open Disk Management

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Open Server Manager.
3. [ ] Click on **Tools** menu at the top.
4. [ ] Click on **Disk Management**.
5. [ ] The Disk Management window will open showing:
   - **Top panel**: List of volumes currently on the server
   - **Bottom panel**: Graphical view of disks and partitions
6. [ ] You should see:
   - **Disk 0** - Your system disk (typically C: drive)
   - Possibly other disks depending on your lab configuration

### Task 2: Examine Disk Details

1. [ ] In the top panel, look at the volume information showing:
   - **Volume**: The drive letter (C:)
   - **Layout**: Simple (single disk)
   - **Type**: NTFS (the file system type)
   - **File System**: NTFS
   - **Status**: Healthy (all is working properly)
   - **Capacity**: Total size of the drive
   - **Free Space**: Available space
   - **% Free**: Percentage of disk space available
2. [ ] Check the free space percentage. It should be more than 20% free.
3. [ ] In the bottom panel, you can see a graphical view of:
   - **Disk 0** (your system disk)
   - **C:\ drive** labeled as "System, Active, Primary partition"

::: warning
**Note**: If free space is less than 10%, this is a concern. Contact your instructor if storage is critically low.
:::

::: success
**Results**: After completing this task, you understand the current disk configuration.
:::

### Task 3: View Disk Information with PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to view disk information:

```powershell
Get-Disk | Select-Object Number, FriendlyName, Size, PartitionStyle | Format-Table
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will display:
   - **Number**: Disk 0, Disk 1, etc.
   - **FriendlyName**: The display name of the disk
   - **Size**: Total size in bytes
   - **PartitionStyle**: MBR (old) or GPT (newer standard)
5. [ ] For each disk, get volume information:

```powershell
Get-Volume | Select-Object DriveLetter, FileSystem, Size, SizeRemaining | Format-Table
```

6. [ ] Press **Enter**.
7. [ ] PowerShell will display all volumes showing:
   - **DriveLetter**: C:, D:, etc.
   - **FileSystem**: NTFS or other file system
   - **Size**: Total capacity
   - **SizeRemaining**: Free space available

::: success
**Results**: After completing this task, you can view disk configuration using PowerShell.
:::

## Exercise 2: Creating a New Volume (if additional disk is available)

::: secondary
**Scenario**

If additional disk space is available in your lab environment, you will create a new volume. If no additional disks are available, review the steps for reference.
:::

### Task 1: Check for Unallocated Space

1. [ ] In Disk Management, look at the bottom panel.
2. [ ] Check if there is any black section labeled **Unallocated** space.
3. [ ] If there is unallocated space:
   - Right-click on the **Unallocated** space
   - Click **New Simple Volume**
4. [ ] A wizard will open titled **New Simple Volume Wizard**.
5. [ ] Click **Next >** to begin.

::: warning
**Note**: If there is no unallocated space, your lab only has the system disk. This is normal. You can skip this task or ask your instructor about additional disk configuration.
:::

### Task 2: Specify Volume Size

1. [ ] On the **Specify Volume Size** page, you will see:
   - **Simple volume size**: The amount of space to allocate
   - Maximum available space shown
2. [ ] Leave the default (which allocates all available unallocated space).
3. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have specified the volume size.
:::

### Task 3: Assign Drive Letter

1. [ ] On the **Assign Drive Letter or Path** page, you will see:
   - **Assign the following drive letter**: A dropdown showing available letters (D:, E:, F:, etc.)
2. [ ] Select **D:** from the dropdown.
3. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have assigned drive letter D: to the new volume.
:::

### Task 4: Format the Volume

1. [ ] On the **Format Partition** page, you will see options for:
   - **File system**: Select **NTFS** (the default)
   - **Allocation unit size**: Leave as **Default**
   - **Volume label**: Type a name for the drive (for example, `Data`
2. [ ] Check **Perform a quick format** to speed up formatting.
3. [ ] Leave **Enable file and folder compression** unchecked.
4. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have configured volume formatting.
:::

### Task 5: Complete Volume Creation

1. [ ] The **Summary** page will show a review of the new volume:
   - Size
   - Drive letter (D:)
   - File system (NTFS)
   - Volume label
2. [ ] Click **Finish** to create the volume.
3. [ ] The formatting will begin. Wait for it to complete (typically 1-2 minutes).
4. [ ] Once complete, you will see the new D: drive in Disk Management.

::: success
**Results**: After completing this task, you have created a new volume on your server.
:::

## Exercise 3: Configuring NTFS Permissions

::: secondary
**Scenario**

NTFS permissions control who can access files and folders. You will create a folder and configure permissions to restrict access.
:::

### Task 1: Create a Folder

1. [ ] On your server, open **File Explorer** by pressing **Windows key + E**.
2. [ ] Navigate to **C:\ drive** (usually shown in the left sidebar).
3. [ ] Right-click in the empty space of C:\ drive.
4. [ ] Select **New** > **Folder**.
5. [ ] A new folder will be created named **New Folder**.
6. [ ] Rename it to **SecureFolder** by typing the name and pressing **Enter**.

::: success
**Results**: After completing this task, you have created a folder named SecureFolder.
:::

### Task 2: Modify Folder Permissions

1. [ ] Right-click on the **SecureFolder** folder.
2. [ ] Click **Properties**.
3. [ ] The **SecureFolder Properties** dialog will open with several tabs.
4. [ ] Click on the **Security** tab.
5. [ ] You will see the **Group or user names** list showing:
   - **SYSTEM**: Full Control
   - **Administrators**: Full Control
   - **Users**: Read & Execute, List Folder Contents, Read
6. [ ] Click the **Edit** button to modify permissions.
7. [ ] A new **SecureFolder Permissions** dialog will open showing the same groups.

### Task 3: Restrict Access

1. [ ] In the permissions dialog, click on **Users** in the **Group or user names** list.
2. [ ] In the bottom panel, you will see permissions for Users:
   - **Modify**: Unchecked
   - **Read & Execute**: Checked
   - **List Folder Contents**: Checked
   - **Read**: Checked
   - **Write**: Unchecked
3. [ ] Click on the **Modify** permission checkbox to uncheck it (if you want to prevent users from modifying files).
4. [ ] Click on the **Write** permission checkbox to uncheck it.
5. [ ] This will make the folder read-only for regular users.
6. [ ] Click **Apply** and **OK** to apply the changes.

::: warning
**Note**: These permission changes only affect users other than Administrators. Your Administrator account will still have full control.
:::

::: success
**Results**: After completing this task, you have restricted write permissions on the folder.
:::

### Task 4: Verify Permissions with PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to view folder permissions:

```powershell
Get-Acl -Path C:\SecureFolder | Format-List
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will display detailed access control information for the folder.
5. [ ] You can also view it in a table format:

```powershell
Get-Acl -Path C:\SecureFolder | Select-Object -ExpandProperty Access | Select-Object IdentityReference, FileSystemRights | Format-Table
```

6. [ ] Press **Enter**.
7. [ ] This will show each user/group and their permissions.

::: success
**Results**: After completing this task, you have verified folder permissions using PowerShell.
:::

## Exercise 4: Understanding NTFS vs Other File Systems

::: secondary
**Scenario**

NTFS is the modern file system for Windows. You should understand why NTFS is superior to older file systems like FAT32.
:::

### Task 1: Review File System Benefits

NTFS provides:

1. **Security**: Permissions and encryption
2. **Large file support**: Files larger than 4GB (FAT32 limitation)
3. **Compression**: Built-in file compression
4. **Journaling**: Recovery features if power fails
5. **Quotas**: Limit disk space per user
6. **Encryption**: Built-in file encryption (EFS)

In contrast, FAT32:
- Maximum file size: 4GB
- No security permissions
- No journaling or recovery
- No encryption

::: success
**Results**: After completing this task, you understand why NTFS is the standard for Windows Server.
:::

## Exercise 5: Checking Disk Health

::: secondary
**Scenario**

You need to monitor disk health to prevent failures. You will check the status of your disks.
:::

### Task 1: Check Disk Status in Disk Management

1. [ ] Return to Disk Management.
2. [ ] In the bottom panel, look at the disk status.
3. [ ] All disks and volumes should show **Healthy** in green.
4. [ ] If any disk shows:
   - **Online**: Disk is working properly
   - **Offline**: Disk is not responding (problem!)
   - **Unknown**: Disk problem
   Contact your instructor immediately if you see anything other than "Healthy" or "Online".

::: success
**Results**: After completing this task, you have verified disk health.
:::

### Task 2: Run Disk Check

1. [ ] Open PowerShell as Administrator.
2. [ ] To check for disk errors (this is an informational command, do NOT run it without instructor approval):

```powershell
Get-Volume | Select-Object DriveLetter, FileSystem, Size, SizeRemaining, HealthStatus
```

3. [ ] Press **Enter**.
4. [ ] You will see the **HealthStatus** for each volume:
   - **Healthy**: All is good
   - **Warning**: Issues detected
   - **Unknown**: Unable to determine status

::: success
**Results**: After completing this task, you can check disk health using PowerShell.
:::

## Exercise 6: Verification and Summary

::: secondary
**Scenario**

You have completed all storage management tasks.
:::

### Task 1: Review What You've Accomplished

You have successfully:

1. **Viewed disk configuration** - Understood current storage layout
2. **Used Disk Management** - Accessed graphical storage tools
3. **Used PowerShell for storage** - Viewed disk information from command line
4. **Created volumes** (if space available) - Added new storage
5. **Configured NTFS permissions** - Restricted folder access
6. **Verified permissions** - Checked folder security settings
7. **Understood file systems** - Know why NTFS is better than FAT32
8. **Checked disk health** - Verified drives are functioning properly

::: success
**Results**: You have successfully completed Lab 0801. You now understand:
- How to view and manage disk configuration
- How to create new volumes
- How to configure NTFS permissions
- How to maintain disk health

These skills are essential for managing server storage. In future labs, you will manage file shares, implement backup strategies, and configure advanced storage features.
:::
