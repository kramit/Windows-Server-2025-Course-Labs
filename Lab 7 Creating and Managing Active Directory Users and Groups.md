# Practice Lab 0701: Creating and Managing Active Directory Users and Groups

## Summary

::: secondary
In this lab, you will create user accounts and groups in Active Directory. You will use both the Active Directory Users and Computers graphical tool and PowerShell to manage domain users. This is one of the most common administrative tasks in a Windows Server environment.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to a server with Active Directory (LON-DC1)
- Understanding of organizational units (OUs) and user management
:::

## Exercise 1: Connecting to Active Directory

::: secondary
**Scenario**

You need to manage users and groups in the contoso.com domain. You will connect to the domain controller (LON-DC1) and access Active Directory management tools.
:::

### Task 1: Open Active Directory Users and Computers

1. [ ] Connect to LON-DC1 using Remote Desktop (RDP to LON-DC1.contoso.com).
2. [ ] Open Server Manager.
3. [ ] Click on **Tools** menu at the top.
4. [ ] Look for and click on **Active Directory Users and Computers**.
5. [ ] The Active Directory Users and Computers window will open showing:
   - Left panel: A tree structure with **Active Directory Users and Computers**
   - Right panel: Contents of the selected container
6. [ ] The tree should show:
   - **contoso.com** (your domain)
   - **Built-in**
   - **Computers**
   - **Users**
   - And possibly other organizational units (OUs)

::: success
**Results**: After completing this task, you have opened Active Directory management tools.
:::

### Task 2: Navigate the Active Directory Structure

1. [ ] Click on the **+** symbol next to **contoso.com** to expand it.
2. [ ] You will see the organizational structure of your domain:
   - **Builtin** - System accounts and groups
   - **Computers** - Computer accounts joined to the domain
   - **Users** - User accounts in the domain
   - Possibly **OUs** (organizational units) for specific departments
3. [ ] Click on **Users** to see user accounts in your domain.
4. [ ] You should see accounts like:
   - **Administrator** - The domain administrator account
   - **Guest** - Default guest account
   - **Krbtgt** - Kerberos service account (used internally)

::: success
**Results**: After completing this task, you understand the Active Directory structure.
:::

## Exercise 2: Creating a New User Account

::: secondary
**Scenario**

You need to create a new user account for an employee joining the company. You will create a domain user account in Active Directory and configure initial settings.
:::

### Task 1: Create a User Account

1. [ ] In Active Directory Users and Computers, click on **Users** in the left panel.
2. [ ] Right-click in the empty area of the right panel.
3. [ ] A context menu will appear. Click on **New** > **User**.
4. [ ] The **New Object - User** dialog will open with fields for:
   - **First name**: Type `John`
   - **Last name**: Type `Smith`
   - **Full name**: Should auto-populate as `John Smith`
   - **User logon name**: Type `jsmith`
   - **User logon name (pre-Windows 2000)**: Should auto-populate as `contoso\jsmith`

::: warning
**Note**: The user logon name must be unique in the domain. If "jsmith" already exists, use a different name like "jsmith2" or "jsmith123".
:::

### Task 2: Set User Password

1. [ ] Click **Next >** to proceed to the next page.
2. [ ] The **Password** page will appear.
3. [ ] Enter a temporary password in both **Password** and **Confirm password** fields. For example: `TempPassword123!`

::: warning
**Note**: This should be a strong password with uppercase, lowercase, numbers, and special characters. The user will be forced to change this password on first login.
:::

4. [ ] Check the checkbox for **User must change password at next logon**. This forces the user to change their temporary password.
5. [ ] Make sure **Password never expires** is NOT checked (unless specifically required by your organization).
6. [ ] Click **Next >** to continue.

::: success
**Results**: After completing this task, you have configured the user's password and set it to expire.
:::

### Task 3: Complete User Creation

1. [ ] The **Summary** page will show a review of the new user details:
   - Full name: John Smith
   - User logon name: CONTOSO\jsmith
   - Password: [hidden]
2. [ ] Click **Finish** to create the user account.
3. [ ] The user account **John Smith (jsmith)** will now appear in the Users list in the right panel.

::: success
**Results**: After completing this task, you have successfully created a new domain user account.
:::

### Task 4: Verify User Creation with PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command to verify the user was created:

```powershell
Get-ADUser -Identity jsmith | Select-Object Name, SamAccountName, UserPrincipalName, Enabled
```

3. [ ] Press **Enter**.
4. [ ] PowerShell should display:
   - **Name**: John Smith
   - **SamAccountName**: jsmith (the short username)
   - **UserPrincipalName**: jsmith@contoso.com
   - **Enabled**: True (the account is active)

::: success
**Results**: After completing this task, you have confirmed the user account was created successfully.
:::

## Exercise 3: Creating and Managing Groups

::: secondary
**Scenario**

You need to organize users into security groups to manage permissions and access control. You will create a group and add the user you created to it.
:::

### Task 1: Create a Security Group

1. [ ] In Active Directory Users and Computers, click on **Users** in the left panel.
2. [ ] Right-click in the empty area of the right panel.
3. [ ] Click on **New** > **Group**.
4. [ ] The **New Object - Group** dialog will open.
5. [ ] In the **Group name** field, type `IT Administrators`.
6. [ ] The **Group name (pre-Windows 2000)** field should auto-populate as `IT Administrators`.
7. [ ] For **Group scope**, select **Global** (the default).
8. [ ] For **Group type**, select **Security** (the default).
9. [ ] Click **OK** to create the group.
10. [ ] The new group **IT Administrators** will appear in the Users list.

::: success
**Results**: After completing this task, you have created a security group.
:::

### Task 2: Add User to Group

1. [ ] In the Users list, find the group **IT Administrators** that you just created.
2. [ ] Double-click on **IT Administrators** to open its properties.
3. [ ] The **IT Administrators** group properties window will open with several tabs.
4. [ ] Click on the **Members** tab.
5. [ ] The tab will show "Members of this group" (currently empty).
6. [ ] Click the **Add...** button.
7. [ ] The **Select Users, Contacts, Computers, Service Accounts, or Groups** dialog will open.
8. [ ] In the **Enter the object names to select** field, type `jsmith` (the user we created).
9. [ ] Click **Check Names** to verify the name.
10. [ ] The name should resolve and be underlined (showing it was found).
11. [ ] Click **OK** to add the user to the group.

::: success
**Results**: After completing this task, you have added the user to the IT Administrators group.
:::

### Task 3: Verify Group Membership

1. [ ] The Members tab should now show:
   - **jsmith**: John Smith
2. [ ] Click **Apply** and **OK** to close the properties window.
3. [ ] Now verify using PowerShell:

```powershell
Get-ADGroupMember -Identity "IT Administrators" | Select-Object Name, SamAccountName
```

4. [ ] Press **Enter**.
5. [ ] PowerShell should display:
   - **Name**: John Smith
   - **SamAccountName**: jsmith
6. [ ] This confirms the user is a member of the group.

::: success
**Results**: After completing this task, you have confirmed that the user is a member of the group.
:::

## Exercise 4: Creating Organizational Units (Optional Advanced)

::: secondary
**Scenario**

Organizational Units (OUs) help organize users and computers by department or function. You will create an OU for a department.
:::

### Task 1: Create an Organizational Unit

1. [ ] In Active Directory Users and Computers, click on **contoso.com** in the left panel.
2. [ ] Right-click on **contoso.com**.
3. [ ] Click on **New** > **Organizational Unit**.
4. [ ] The **New Object - Organizational Unit** dialog will open.
5. [ ] In the **Name** field, type `Finance` (creating an OU for the Finance department).
6. [ ] Click **OK** to create the OU.
7. [ ] The new OU **Finance** will appear in the contoso.com tree structure.

::: success
**Results**: After completing this task, you have created an organizational unit.
:::

### Task 2: Move User to Organizational Unit

1. [ ] Click on the **+** symbol next to **Finance** OU to expand it.
2. [ ] Click on **Users** in the left panel to show all current users.
3. [ ] Find the user **John Smith (jsmith)** in the right panel.
4. [ ] Drag **jsmith** from the Users folder to the **Finance** OU.

::: warning
**Note**: Alternatively, you can right-click jsmith, select Cut, then right-click in the Finance OU and select Paste.
:::

5. [ ] The user will be moved to the Finance OU.
6. [ ] You can now see the organizational structure is **Finance** > **Users** > **jsmith**.

::: success
**Results**: After completing this task, you have organized the user into a department-specific OU.
:::

## Exercise 5: Managing User Properties

::: secondary
**Scenario**

User accounts have many properties you can configure including contact information, office location, and manager information. You will configure these details.
:::

### Task 1: Open User Properties

1. [ ] Find the user **John Smith (jsmith)** in Active Directory Users and Computers.
2. [ ] Right-click on **jsmith**.
3. [ ] Click **Properties**.
4. [ ] The user properties dialog will open with multiple tabs:
   - **General**: Basic information
   - **Address**: Office location and contact information
   - **Telephones**: Phone numbers
   - **Organization**: Department, title, manager
   - **Account**: Logon information
   - **Profile**: Home folder and login script
   - **Dial-in**: Remote access settings
   - **Sessions**: Active sessions
   - **Environment**: Terminal Services settings
   - **Remote control**: Remote assistance options
   - **Terminal Services Profile**: Terminal Services settings
   - **COM+**: Component Services settings
   - **Member Of**: Group membership

### Task 2: Configure User Information

1. [ ] Click on the **General** tab to see the basic user information.
2. [ ] In the **Description** field, type `Finance Department Employee`.
3. [ ] Click on the **Organization** tab.
4. [ ] Fill in the following information:
   - **Title**: `Junior Accountant`
   - **Department**: `Finance`
   - **Company**: `Contoso Ltd`
5. [ ] Click on the **Telephones** tab.
6. [ ] In the **Telephone number** field, type a phone number (for example, `555-1234`).
7. [ ] Click on the **Address** tab.
8. [ ] Fill in office location information if available.

::: success
**Results**: After completing this task, you have configured detailed user properties.
:::

## Exercise 6: Disable a User Account

::: secondary
**Scenario**

When an employee leaves the company, you need to disable their user account rather than delete it (in case you need to recover data). You will learn how to disable an account.
:::

### Task 1: Disable a User Account

1. [ ] In Active Directory Users and Computers, find the user **John Smith (jsmith)**.
2. [ ] Right-click on **jsmith**.
3. [ ] Click **Properties**.
4. [ ] Click on the **Account** tab.
5. [ ] Look for the **Account is disabled** checkbox near the bottom of the tab.

::: warning
**Note**: Do NOT disable the account in this lab. We are just examining how it would be done. Leave this unchecked.
:::

6. [ ] If you needed to disable the account, you would check this box and click OK.
7. [ ] Once disabled, the user would be unable to log in, but their account and data would remain in Active Directory.
8. [ ] Close the properties window without making changes.

::: success
**Results**: After completing this task, you know how to disable user accounts.
:::

## Exercise 7: Verification and Summary

::: secondary
**Scenario**

You have completed all user and group management tasks.
:::

### Task 1: Review What You've Accomplished

You have successfully:

1. **Created a domain user account** - John Smith (jsmith)
2. **Set user password** - Configured to require change at next logon
3. **Created a security group** - IT Administrators
4. **Added user to group** - Added jsmith to IT Administrators
5. **Created an organizational unit** - Finance department OU
6. **Organized users** - Moved user to Finance OU
7. **Configured user properties** - Added detailed user information
8. **Understood account management** - Know how to disable/enable accounts

::: success
**Results**: You have successfully completed Lab 0701. You now understand:
- How to create domain user accounts in Active Directory
- How to manage user properties and information
- How to create security groups
- How to manage group membership
- How to organize users in organizational units
- How to disable accounts

These are core skills for managing a Windows Server Active Directory environment. In future labs, you will use these skills to manage permissions, apply group policies, and maintain domain security.
:::
