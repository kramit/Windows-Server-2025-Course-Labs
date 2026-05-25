# Practice Lab 1001: Creating File Shares and Managing Share Permissions

## Summary

::: secondary
In this lab, you will create shared folders on your Windows Server and configure share permissions. You will learn the difference between NTFS permissions and share permissions, and how they work together to control access.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0801 (Managing Disks, Volumes, and NTFS Permissions)
- Administrator access to LON-SVR1
- Understanding of NTFS permissions from previous lab
:::

## Exercise 1: Creating a File Share

::: secondary
**Scenario**

Your organization needs to share documents with team members. You will create a shared folder and configure it for network access.
:::

### Task 1: Create a Folder for Sharing

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Open **File Explorer** from the taskbar or from **Start**.

7. [ ] Navigate to the **C:** drive.

8. [ ] Right-click in the empty space and select **New** > **Folder**.

9. [ ] Name the new folder **TeamDocuments**.

10. [ ] Press **Enter** to confirm.

::: success
**Results**: After completing this task, you have created a folder named TeamDocuments.
:::

### Task 2: Create a Share

1. [ ] Right-click on the **TeamDocuments** folder.

2. [ ] Click on **Give access to** > **Specific people...** (or **Properties** if the first option is not available).

3. [ ] If you clicked Properties, go to the **Sharing** tab and click **Share...**.

4. [ ] A **File Sharing** window will open asking **Who do you want to share with?**

5. [ ] In the field, type **Everyone** to share with all network users.

6. [ ] Click **Add**.

7. [ ] You will see **Everyone** appears in the user list.

8. [ ] Look at the **Permission Level** dropdown next to Everyone. It should default to **Reader**.

9. [ ] This gives read-only access. Leave it as **Reader** for now.

10. [ ] Click **Share** to create the network share.

::: success
**Results**: After completing this task, TeamDocuments is shared on the network.
:::

### Task 3: Find the Share Path

1. [ ] Once sharing is configured, a dialog will show the share path.

2. [ ] The share path will be something like: `\\LON-SVR1\TeamDocuments`

3. [ ] This is the network path other users can use to access the share.

4. [ ] Click **Done** to close the dialog.

   ::: warning
   **Note**: Other computers on the network can now access this folder using the path \\LON-SVR1\TeamDocuments.
   :::

::: success
**Results**: After completing this task, you know the network path to your share.
:::

## Exercise 2: Understanding Share Permissions vs NTFS Permissions

::: secondary
**Scenario**

Share permissions and NTFS permissions work together. You need to understand how both apply to control access.
:::

### Task 1: View Share Permissions

1. [ ] Right-click on the **TeamDocuments** folder.

2. [ ] Click **Properties**.

3. [ ] Click on the **Sharing** tab.

4. [ ] Click **Advanced Sharing...** button.

5. [ ] The **Advanced Sharing** dialog will open.

6. [ ] You should see:
   - **Share this folder**: Checked (folder is shared)
   - **Share name**: TeamDocuments
   - **Comments**: (empty, for optional description)
   - **User limit**: Maximum users allowed (typically "No limit")

7. [ ] Click the **Permissions** button to view share permissions.

### Task 2: Examine Share Permissions

1. [ ] The **Permissions for TeamDocuments** dialog will open.

2. [ ] You will see:
   - **Group or user names**: Everyone
   - **Permissions**: 
     - Allow: Read (checked)
     - Allow: Change (unchecked)
     - Allow: Full Control (unchecked)

3. [ ] This means users with the share have **Read-only** access.

4. [ ] If you wanted users to be able to create and modify files, you would check **Change**.

5. [ ] Click **Cancel** to close without making changes.

6. [ ] Click **Cancel** again to close Advanced Sharing.

::: success
**Results**: After completing this task, you understand share permissions.
:::

### Task 3: Understand Permission Combination

The effective permission is the **most restrictive** of:
- **Share Permission** (e.g., Reader = Read-only)
- **NTFS Permission** (e.g., Modify = can change files)

Example: If share permission is "Read" and NTFS permission is "Modify", the effective permission is "Read" (the more restrictive one).

This is important to remember when configuring access!

::: success
**Results**: After completing this task, you understand how share and NTFS permissions interact.
:::

## Exercise 3: Creating Additional Shares with Different Permissions

::: secondary
**Scenario**

You need to create another share where users can create and modify files (higher permissions). You will set both share and NTFS permissions appropriately.
:::

### Task 1: Create Another Folder

1. [ ] Open File Explorer and navigate to C:\.

2. [ ] Create a new folder named **ProjectFiles**.

3. [ ] Right-click on **ProjectFiles**.

4. [ ] Click **Properties**.

5. [ ] Click the **Sharing** tab.

6. [ ] Click **Share...**.

7. [ ] Type **Everyone** in the user field and click **Add**.

8. [ ] Change the **Permission Level** from **Reader** to **Contributor** (this allows users to modify files).

9. [ ] Click **Share**.

10. [ ] Note the share path (\\LON-SVR1\ProjectFiles).

11. [ ] Click **Done**.

::: success
**Results**: After completing this task, ProjectFiles is shared with higher permissions (Contributor).
:::

### Task 2: Configure NTFS Permissions

1. [ ] The sharing dialog should still be open. Click on the **Security** tab.

2. [ ] If Properties closed, right-click **ProjectFiles** and select **Properties** > **Security** tab.

3. [ ] Click **Edit** to modify permissions.

4. [ ] Click **Everyone** in the user list.

5. [ ] Verify the following permissions are checked for Everyone:
   - **Modify**: This allows users to change files
   - **Read & Execute**: This allows users to read and run files
   - **List Folder Contents**: This allows users to see files in the folder
   - **Read**: This allows reading files
   - **Write**: This allows writing/creating files

6. [ ] If **Modify** is not checked, check it now.

7. [ ] Click **Apply** and **OK**.

::: success
**Results**: After completing this task, ProjectFiles has both share and NTFS permissions set to allow modifications.
:::

## Exercise 4: Testing Share Access

::: secondary
**Scenario**

You will verify that shared folders are accessible from the network.
:::

### Task 1: Access Share from Another Machine

If you have access to another computer (such as CLIENT1):

1. [ ] On the other computer, open **File Explorer**.

2. [ ] In the address bar, type: `\\LON-SVR1\TeamDocuments`

3. [ ] Press **Enter**.

4. [ ] You should see the contents of the shared folder (currently empty).

5. [ ] Try to create a new file:
   - Right-click in the empty space
   - Select **New** > **Text Document**
   - You should get a permission error because the share is Read-only

6. [ ] Try the **ProjectFiles** share:
   - In the address bar, type: `\\LON-SVR1\ProjectFiles`
   - Press **Enter**
   - Try to create a new file - this should succeed because Contributor permissions allow modifications

   ::: warning
   **Note**: If you don't have access to another computer, you can test shares locally by mapping network drives. Ask your instructor for assistance.
   :::

::: success
**Results**: After completing this task, you have verified that share permissions are working correctly.
:::

## Exercise 5: Using PowerShell to Manage Shares

::: secondary
**Scenario**

PowerShell can manage shares with powerful scripting capabilities. You will use PowerShell to view and modify share settings.
:::

### Task 1: List All Shares

1. [ ] Open PowerShell as Administrator.

2. [ ] Type the following command:

```powershell
Get-SmbShare | Select-Object Name, Path, Description | Format-Table
```

3. [ ] Press **Enter**.

4. [ ] PowerShell will display all shares on the server:
   - **Name**: Share name (TeamDocuments, ProjectFiles, etc.)
   - **Path**: Full folder path (C:\TeamDocuments, C:\ProjectFiles, etc.)
   - **Description**: Optional description of the share

::: success
**Results**: After completing this task, you can view all server shares using PowerShell.
:::

### Task 2: View Share Permissions

1. [ ] Type the following command to view detailed share permissions:

```powershell
Get-SmbShareAccess -Name TeamDocuments | Select-Object AccountName, AccessRight, AccessControlType | Format-Table
```

2. [ ] Press **Enter**.

3. [ ] PowerShell will show:
   - **AccountName**: Which user/group has access (Everyone, Domain Admins, etc.)
   - **AccessRight**: What permission (Read, Change, Full)
   - **AccessControlType**: Allow or Deny

::: success
**Results**: After completing this task, you can view share permissions using PowerShell.
:::

## Exercise 6: Understanding Security Best Practices

::: secondary
**Scenario**

There are important security considerations when creating shares.
:::

### Task 1: Share Security Principles

Remember these principles:

1. **Use Everyone sparingly** - Sharing with "Everyone" means anyone on the network can access the data
2. **Use specific users/groups** - Better to grant access to specific users or groups
3. **Least privilege** - Give only the minimum permissions needed
4. **Combine permissions** - Use both share and NTFS permissions for maximum control
5. **Monitor shares** - Regularly review who has access to what

For example, instead of sharing with "Everyone", you might share with:
- **Finance Team** group (only finance department members)
- **Project Managers** group
- Specific user accounts

This is much more secure!

::: success
**Results**: After completing this task, you understand share security best practices.
:::

## Exercise 7: Verification and Summary

::: secondary
**Scenario**

You have successfully created and managed file shares.
:::

### Task 1: Review What You've Accomplished

You have successfully:

1. **Created shared folders** - TeamDocuments and ProjectFiles
2. **Configured share permissions** - Read-only and Contributor levels
3. **Configured NTFS permissions** - Controlled who can modify files
4. **Tested share access** - Verified shares are accessible
5. **Used PowerShell** - Listed and managed shares with commands
6. **Understood permission interaction** - Know how share and NTFS permissions combine
7. **Applied security best practices** - Understand least privilege principle

::: success
**Results**: You have successfully completed Lab 1001. You now understand:
- How to create network file shares
- How to configure share permissions
- How to configure NTFS permissions
- How share and NTFS permissions work together
- How to use PowerShell to manage shares

File sharing is a critical feature of Windows Server. In future labs, you will configure more advanced sharing scenarios, implement access controls, and manage group policy for shares.
:::
