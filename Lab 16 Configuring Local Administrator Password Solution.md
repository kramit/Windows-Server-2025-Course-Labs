# Practice Lab 1601: Configuring Local Administrator Password Solution (LAPS)

## Summary

::: secondary
In this lab, you will configure Windows LAPS (Local Administrator Password Solution) in an on-premises, domain-based scenario to securely manage local administrator passwords across your domain. LAPS automatically manages local admin passwords and stores them in Active Directory for audited retrieval.

::: note
**Modern approach**: Microsoft’s current cloud-managed approach is to deploy Windows LAPS with Microsoft Intune and Microsoft Entra ID. For that method, see [Deploy Windows LAPS policy with Microsoft Intune](https://learn.microsoft.com/en-us/intune/device-security/laps/deploy-policy).
:::
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0701 (Creating and Managing Active Directory Users and Groups)
- Administrator access to LON-DC1 (domain controller)
- Access to LON-SVR1 (member server)
- Understanding of Group Policy basics
:::

## Exercise 1: Understanding LAPS

::: secondary
**Scenario**

LAPS solves a critical security problem: managing local administrator passwords. You will understand why LAPS is important.
:::

### Task 1: LAPS Security Problem and Solution

**The Problem**:
- Every computer has a local Administrator account
- Typically, all computers use the same password
- If one computer is compromised, all are at risk
- No audit trail of password access
- Password is difficult to change at scale

**LAPS Solution**:
- Generates unique random passwords for each computer
- Stores passwords encrypted in Active Directory
- Manages password changes automatically
- Provides audit trail of who accessed passwords
- Simplifies password management at scale

LAPS is **essential for any organization** with domain-joined computers.

::: success
**Results**: After completing this task, you understand LAPS benefits.
:::

## Exercise 2: Installing LAPS

::: secondary
**Scenario**

You need to install LAPS components on your domain. LAPS requires software on both domain controllers and member servers.
:::

### Task 1: Install LAPS on Domain Controller

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** and **Password** values shown for **LON-DC1** on the **HOME** tab.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Download LAPS from Microsoft:
   - Open Edge browser
   - Navigate to: `https://www.microsoft.com/download/details.aspx?id=46899`
   - Look for **Windows LAPS** (latest version)

7. [ ] Download the appropriate version (64-bit for Windows Server 2025).

8. [ ] Run the installer by double-clicking the downloaded MSI file.

9. [ ] The LAPS installer will open. Accept the license terms.

10. [ ] Click **Install** to install LAPS on the domain controller.

11. [ ] Once installation completes, click **Finish**.

   ::: warning
   **Note**: If LAPS is already installed, ask your instructor. You may skip this task.
   :::

::: success
**Results**: After completing this task, LAPS is installed on the domain controller.
:::

### Task 2: Extend Active Directory Schema

1. [ ] Open PowerShell as Administrator on LON-DC1.

2. [ ] Run the LAPS schema extension:

```powershell
Update-AdmPwdADSchema -Verbose
```

3. [ ] Press **Enter**.

4. [ ] PowerShell will extend the Active Directory schema to support LAPS password storage.

5. [ ] You should see a success message.

::: success
**Results**: After completing this task, Active Directory is prepared for LAPS.
:::

## Exercise 3: Configuring Group Policy for LAPS

::: secondary
**Scenario**

You will create a Group Policy that enables LAPS on domain member servers. This policy configures automatic password management.
:::

### Task 1: Create LAPS Group Policy

1. [ ] Open **Group Policy Management** on LON-DC1:
   - Open **Server Manager**
   - Click **Tools** > **Group Policy Management**

2. [ ] Expand **Forest** > **Domains** > **contoso.com**.

3. [ ] Right-click on **contoso.com** and select **Create a GPO in this domain, and Link it here**.

4. [ ] In the dialog:
   - **Name**: Type `LAPS Configuration`

5. [ ] Click **OK** to create the policy.

6. [ ] The new GPO will appear. Right-click on it and select **Edit**.

### Task 2: Configure LAPS Policy Settings

1. [ ] Group Policy Editor will open.

2. [ ] Navigate to: **Computer Configuration** > **Policies** > **Administrative Templates** > **LAPS**

3. [ ] Look for and configure:
   - **Enable local admin password management**: Double-click this policy
   - Select **Enabled**
   - Click **OK**

4. [ ] Back in the policies folder, also configure:
   - **Password Settings**: Double-click
   - Set password complexity and length requirements
   - Click **OK**

5. [ ] Close the Group Policy Editor.

::: success
**Results**: After completing this task, Group Policy is configured for LAPS.
:::

## Exercise 4: Installing LAPS on Member Servers

::: secondary
**Scenario**

You need to install LAPS client on LON-SVR1 so it can receive LAPS policy and manage its local administrator password.
:::

### Task 1: Install LAPS on LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Download and install LAPS the same way as on LON-DC1:
   - Download from Microsoft website
   - Run the MSI installer
   - Accept license and click Install

7. [ ] Once installation completes, the LAPS client is ready.

::: success
**Results**: After completing this task, LAPS is installed on the member server.
:::

### Task 2: Force Group Policy Update

1. [ ] On LON-SVR1, open PowerShell as Administrator.

2. [ ] Force the server to apply the LAPS Group Policy immediately:

```powershell
gpupdate /force
```

3. [ ] Press **Enter**.

4. [ ] PowerShell will apply Group Policy, including LAPS settings.

5. [ ] This may take 1-2 minutes.

::: success
**Results**: After completing this task, LAPS policy is applied to the server.
:::

## Exercise 5: Retrieving LAPS Passwords

::: secondary
**Scenario**

Once LAPS is configured, administrator passwords are automatically managed. You will retrieve the password from Active Directory.
:::

### Task 1: Wait for Password to Be Set

1. [ ] LAPS generates the first password within 30 minutes of policy application.

2. [ ] To force immediate password change, run on LON-SVR1:

```powershell
Invoke-LapsPolicyRefresh
```

3. [ ] This forces the local admin password to be changed immediately.

4. [ ] The new password is stored in Active Directory automatically.

::: success
**Results**: After completing this task, LAPS has generated a new password.
:::

### Task 2: Retrieve Password from Active Directory

1. [ ] Go back to LON-DC1.

2. [ ] Open **Active Directory Users and Computers**.

3. [ ] Navigate to the computer object **LON-SVR1**.

4. [ ] Right-click on **LON-SVR1** and select **Properties**.

5. [ ] Click on the **LAPS** tab (or look for LAPS properties if tab is not visible).

6. [ ] You should see:
   - **Stored password**: The encrypted password
   - **Password expiration time**: When it will change next
   - **MS-MCS-AdmPwd**: The attribute storing the password (encrypted)

7. [ ] To view the actual password, use PowerShell:

```powershell
Get-AdmPwdPassword -ComputerName LON-SVR1
```

8. [ ] This will display the current local admin password for the server.

   ::: warning
   **Note**: Only authorized administrators should have permission to retrieve LAPS passwords. Use discretion.
   :::

::: success
**Results**: After completing this task, you can retrieve LAPS passwords from Active Directory.
:::

## Exercise 6: Understanding LAPS Best Practices

::: secondary
**Scenario**

LAPS requires proper security practices to be effective.
:::

### Task 1: LAPS Best Practices

1. **Restrict Access**:
   - Only authorized IT staff should retrieve LAPS passwords
   - Use Active Directory permissions to control access

2. **Enable Auditing**:
   - Log who accesses LAPS passwords
   - Track password changes
   - Monitor for suspicious activity

3. **Set Appropriate Parameters**:
   - Password length: At least 14 characters
   - Password complexity: Require uppercase, lowercase, numbers, special characters
   - Change frequency: Every 30 days or more frequently

4. **Monitor Password Age**:
   - Ensure passwords are changing regularly
   - Alert if password hasn't changed recently

5. **Document Process**:
   - Document who needs access
   - Document password retrieval procedures
   - Train administrators on LAPS

::: success
**Results**: After completing this task, you understand LAPS best practices.
:::

