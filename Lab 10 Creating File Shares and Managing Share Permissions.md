# Practice Lab 1001: Creating File Shares and Managing Share Permissions

## Summary

::: secondary
In this lab, you will create shared folders on your Windows Server and configure share permissions. You will learn the difference between NTFS permissions and share permissions, how they work together to control access, and how Access-Based Enumeration hides folders that users do not have permission to open.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0801 (Managing Disks, Volumes, and NTFS Permissions)
- Administrator access to **LON-DC1**, **LON-SVR1**, and **CLIENT1**
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

## Exercise 4: Configure Access-Based Enumeration

::: secondary
**Scenario**

Your organization wants one shared location for departmental folders. Finance users should see only Finance content, and IT users should see only IT content. You will create test users and groups, configure folder permissions, enable Access-Based Enumeration, and then test the result from CLIENT1.
:::

### Task 1: Create Department Test Users and Groups

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-DC1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.

7. [ ] In **Server Manager**, select **Tools**.

8. [ ] Select **Active Directory Users and Computers**.

9. [ ] In the left pane, expand **contoso.com**.

10. [ ] Select **Users**.

11. [ ] Right-click in the empty area of the right pane and select **New** > **User**.

12. [ ] On the **New Object - User** page, enter the following values:
   - **First name**: `Finance`
   - **Last name**: `User`
   - **User logon name**: `finuser`

13. [ ] Select **Next >**.

14. [ ] Enter `Pa55w.rd123!` in **Password** and **Confirm password**.

15. [ ] Clear **User must change password at next logon**.

16. [ ] Select **Password never expires**.

17. [ ] Select **Next >**.

18. [ ] Select **Finish**.

19. [ ] Create a second user with the following values:
   - **First name**: `IT`
   - **Last name**: `User`
   - **User logon name**: `ituser`
   - **Password**: `Pa55w.rd123!`
   - **User must change password at next logon**: cleared
   - **Password never expires**: selected

20. [ ] Right-click in the empty area of the right pane and select **New** > **Group**.

21. [ ] In **Group name**, enter `Lab10 Finance Share Users`.

22. [ ] Verify that **Group scope** is set to **Global**.

23. [ ] Verify that **Group type** is set to **Security**.

24. [ ] Select **OK**.

25. [ ] Create a second security group named `Lab10 IT Share Users`.

26. [ ] Double-click **Lab10 Finance Share Users**.

27. [ ] Select the **Members** tab.

28. [ ] Select **Add...**.

29. [ ] In **Enter the object names to select**, enter `finuser`.

30. [ ] Select **Check Names**.

31. [ ] Verify that the name resolves.

32. [ ] Select **OK**.

33. [ ] Select **OK** to close the group properties.

34. [ ] Add `ituser` to **Lab10 IT Share Users** by using the same process.

::: success
**Results**: After completing this task, you have created department test users and groups for the Access-Based Enumeration exercise.
:::

### Task 2: Create the Department Folder Structure

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Open **File Explorer** from **Start**.

7. [ ] Open **Local Disk (C:)**.

8. [ ] Right-click in the empty area and select **New** > **Folder**.

9. [ ] Name the folder `DepartmentData`.

10. [ ] Open `DepartmentData`.

11. [ ] Create two folders named `Finance` and `IT`.

12. [ ] Open the `Finance` folder.

13. [ ] Right-click in the empty area and select **New** > **Text Document**.

14. [ ] Name the file `Finance-Readme.txt`.

15. [ ] Open `Finance-Readme.txt`.

16. [ ] Enter `Finance department test content.`

17. [ ] Select **File** > **Save**.

18. [ ] Close **Notepad**.

19. [ ] Return to `C:\DepartmentData`.

20. [ ] Open the `IT` folder.

21. [ ] Create a text document named `IT-Readme.txt`.

22. [ ] Open `IT-Readme.txt`.

23. [ ] Enter `IT department test content.`

24. [ ] Select **File** > **Save**.

25. [ ] Close **Notepad**.

::: success
**Results**: After completing this task, you have created the folder structure and test files for the departmental share.
:::

### Task 3: Configure NTFS Permissions for Department Folders

1. [ ] In **File Explorer**, return to **Local Disk (C:)**.

2. [ ] Right-click `DepartmentData` and select **Properties**.

3. [ ] Select the **Security** tab.

4. [ ] Select **Advanced**.

5. [ ] In **Advanced Security Settings for DepartmentData**, select **Disable inheritance**.

6. [ ] When prompted, select **Convert inherited permissions into explicit permissions on this object**.

7. [ ] In the **Permission entries** list, select **Users** if it is present.

8. [ ] Select **Remove**.

9. [ ] Select **Authenticated Users** if it is present.

10. [ ] Select **Remove**.

11. [ ] Select **Add**.

12. [ ] Select **Select a principal**.

13. [ ] Enter `Lab10 Finance Share Users`.

14. [ ] Select **Check Names**.

15. [ ] Verify that the group resolves.

16. [ ] Select **OK**.

17. [ ] In **Applies to**, select **This folder only**.

18. [ ] Under **Basic permissions**, select **Read & execute** if it is not already selected.

19. [ ] Verify that **List folder contents** and **Read** are selected.

20. [ ] Select **OK**.

21. [ ] Add `Lab10 IT Share Users` with the same permissions and **Applies to** set to **This folder only**.

22. [ ] Select **Apply**.

23. [ ] Select **OK** to close **Advanced Security Settings for DepartmentData**.

24. [ ] Select **OK** to close **DepartmentData Properties**.

25. [ ] Open `DepartmentData`.

26. [ ] Right-click `Finance` and select **Properties**.

27. [ ] Select the **Security** tab.

28. [ ] Select **Edit...**.

29. [ ] Select **Add...**.

30. [ ] Enter `Lab10 Finance Share Users`.

31. [ ] Select **Check Names**.

32. [ ] Select **OK**.

33. [ ] With **Lab10 Finance Share Users** selected, allow **Modify**.

34. [ ] Select **Apply**.

35. [ ] Select **OK**.

36. [ ] Select **OK** to close the folder properties.

37. [ ] Give `Lab10 IT Share Users` **Modify** permission on the `IT` folder by using the same process.

   ::: warning
   **Note**: Do not give the Finance group permissions on the IT folder, and do not give the IT group permissions on the Finance folder. Access-Based Enumeration depends on NTFS permissions to decide which folders a user can see.
   :::

::: success
**Results**: After completing this task, each department group can list the shared root folder but can access only its matching department folder.
:::

### Task 4: Share DepartmentData and Enable Access-Based Enumeration

1. [ ] In **File Explorer**, right-click `DepartmentData` and select **Properties**.

2. [ ] Select the **Sharing** tab.

3. [ ] Select **Advanced Sharing...**.

4. [ ] Select **Share this folder**.

5. [ ] Verify that **Share name** is `DepartmentData`.

6. [ ] Select **Permissions**.

7. [ ] Select **Everyone**.

8. [ ] Select **Remove**.

9. [ ] Select **Add...**.

10. [ ] Enter `Lab10 Finance Share Users`.

11. [ ] Select **Check Names**.

12. [ ] Select **OK**.

13. [ ] Verify that **Read** is allowed for **Lab10 Finance Share Users**.

14. [ ] Add `Lab10 IT Share Users` with **Read** allowed.

15. [ ] Select **OK** to close **Permissions for DepartmentData**.

16. [ ] Select **OK** to close **Advanced Sharing**.

17. [ ] Select **Close** to close the folder properties.

18. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.

19. [ ] In **Server Manager**, select **File and Storage Services**.

20. [ ] Select **Shares**.

21. [ ] In the **Shares** tile, select **DepartmentData**.

22. [ ] In the lower **Properties** pane, select **Tasks**.

23. [ ] Select **Properties**.

24. [ ] In **DepartmentData Properties**, select **Settings**.

25. [ ] Select **Enable access-based enumeration**.

26. [ ] Select **OK**.

27. [ ] Verify that the share path is `\\LON-SVR1\DepartmentData`.

   ::: warning
   **Note**: Access-Based Enumeration changes what users can see in a share. NTFS permissions still control whether users can actually open, read, or modify files.
   :::

::: success
**Results**: After completing this task, you have shared DepartmentData and enabled Access-Based Enumeration.
:::

### Task 5: Test Access-Based Enumeration from CLIENT1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **CLIENT1**.

3. [ ] Use the **Username** and **Password** values shown for **CLIENT1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows desktop to appear.

6. [ ] Open **File Explorer** from **Start**.

7. [ ] Select **This PC**.

8. [ ] In the command bar, select **See more**.

9. [ ] Select **Map network drive**.

10. [ ] In **Drive**, select **F:**.

11. [ ] In **Folder**, enter `\\LON-SVR1\DepartmentData`.

12. [ ] Select **Connect using different credentials**.

13. [ ] Select **Finish**.

14. [ ] When prompted for credentials, enter `contoso\finuser` and the password `Pa55w.rd123!`.

15. [ ] Select **OK**.

16. [ ] Verify that drive **F:** opens.

17. [ ] Verify that only the `Finance` folder is visible.

18. [ ] Open the `Finance` folder.

19. [ ] Verify that `Finance-Readme.txt` is visible.

20. [ ] Return to **This PC**.

21. [ ] Right-click mapped drive **F:** and select **Disconnect**.

22. [ ] Map `\\LON-SVR1\DepartmentData` again to drive **F:**.

23. [ ] Select **Connect using different credentials**.

24. [ ] When prompted for credentials, enter `contoso\ituser` and the password `Pa55w.rd123!`.

25. [ ] Verify that only the `IT` folder is visible.

26. [ ] Open the `IT` folder.

27. [ ] Verify that `IT-Readme.txt` is visible.

28. [ ] Return to **This PC**.

29. [ ] Right-click mapped drive **F:** and select **Disconnect**.

   ::: warning
   **Note**: If Windows reports that multiple connections to the same server are already in use, disconnect any mapped drives to `\\LON-SVR1`, close File Explorer windows that are using the share, and try the mapping again.
   :::

::: success
**Results**: After completing this task, you have verified that Access-Based Enumeration shows each test user only the folder that matches their NTFS permissions.
:::

## Exercise 5: Testing Share Access

::: secondary
**Scenario**

You will verify that shared folders are accessible from the network.
:::

### Task 1: Access Shares from CLIENT1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **CLIENT1**.

3. [ ] Use the **Username** and **Password** values shown for **CLIENT1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows desktop to appear.

6. [ ] Open **File Explorer** from **Start**.

7. [ ] Select the address bar.

8. [ ] Enter `\\LON-SVR1\TeamDocuments`.

9. [ ] Verify that the shared folder opens.

10. [ ] Try to create a new file:
   - Right-click in the empty space
   - Select **New** > **Text Document**
   - You should get a permission error because the share is Read-only

11. [ ] Select the address bar.

12. [ ] Enter `\\LON-SVR1\ProjectFiles`.

13. [ ] Verify that the shared folder opens.

14. [ ] Try to create a new file:
   - Right-click in the empty space
   - Select **New** > **Text Document**
   - Verify that the new text document is created successfully because Contributor permissions allow modifications

   ::: warning
   **Note**: If credentials are requested, use the **Username** and **Password** values shown for **CLIENT1** on the lab platform **HOME** tab.
   :::

::: success
**Results**: After completing this exercise, you have verified that share permissions are working correctly from CLIENT1.
:::

## Exercise 6: Using PowerShell to Manage Shares

::: secondary
**Scenario**

PowerShell can manage shares with powerful scripting capabilities. You will use PowerShell to view and modify share settings.
:::

### Task 1: List All Shares

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Select **Start**.

7. [ ] Type **PowerShell**.

8. [ ] In the search results, right-click **Windows PowerShell**.

9. [ ] Select **Run as administrator**.

10. [ ] If a **User Account Control** prompt appears, select **Yes**.

11. [ ] Type the following command:

```powershell
Get-SmbShare | Select-Object Name, Path, Description | Format-Table
```

12. [ ] Press **Enter**.

13. [ ] PowerShell will display all shares on the server:
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

### Task 3: Verify Access-Based Enumeration with PowerShell

1. [ ] In the same PowerShell window on **LON-SVR1**, type the following command:

```powershell
Get-SmbShare -Name DepartmentData | Select-Object Name, Path, FolderEnumerationMode
```

2. [ ] Press **Enter**.

3. [ ] Verify that **FolderEnumerationMode** shows `AccessBased`.

::: success
**Results**: After completing this task, you can verify Access-Based Enumeration by using PowerShell.
:::

## Exercise 7: Understanding Security Best Practices

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
5. **Use Access-Based Enumeration when appropriate** - Hide folders from users who do not have NTFS permission to access them
6. **Monitor shares** - Regularly review who has access to what

For example, instead of sharing with "Everyone", you might share with:
- **Finance Team** group (only finance department members)
- **Project Managers** group
- Specific user accounts

This is much more secure!

Access-Based Enumeration improves the user experience and reduces unnecessary information exposure because users do not see folders they cannot open. It does not replace NTFS permissions. Always configure NTFS permissions correctly first, then use Access-Based Enumeration to control folder visibility inside the share.

::: success
**Results**: After completing this task, you understand share security best practices.
:::

## Exercise 8: Verification and Summary

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
5. **Configured Access-Based Enumeration** - Hid department folders from users without matching NTFS permissions
6. **Used PowerShell** - Listed and managed shares with commands
7. **Understood permission interaction** - Know how share and NTFS permissions combine
8. **Applied security best practices** - Understand least privilege principle

### Administrative Change Summary

During this lab, you made the following administrative changes:

- Created the **Finance User (finuser)** and **IT User (ituser)** domain user accounts.
- Created the **Lab10 Finance Share Users** and **Lab10 IT Share Users** security groups.
- Created `C:\DepartmentData` on **LON-SVR1**.
- Created the `Finance` and `IT` department folders and test files.
- Shared `C:\DepartmentData` as `\\LON-SVR1\DepartmentData`.
- Enabled Access-Based Enumeration on the **DepartmentData** share.
- Configured department-specific NTFS permissions for the Finance and IT folders.

::: success
**Results**: You have successfully completed Lab 1001. You now understand:
- How to create network file shares
- How to configure share permissions
- How to configure NTFS permissions
- How share and NTFS permissions work together
- How Access-Based Enumeration changes folder visibility inside a share
- How to use PowerShell to manage shares

File sharing is a critical feature of Windows Server. In future labs, you will configure more advanced sharing scenarios, implement access controls, and manage group policy for shares.
:::
