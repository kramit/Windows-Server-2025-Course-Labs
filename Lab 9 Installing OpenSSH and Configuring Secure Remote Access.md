# Practice Lab 0901: Installing OpenSSH and Configuring Certificate-Based HTTPS

## Summary

::: secondary
In this lab, you will enable OpenSSH Server on Windows Server 2025, validate SSH-based remote administration from another server, and configure key-based SSH authentication.

You will then build a production-style internal certificate workflow by installing Active Directory Certificate Services (AD CS) as an Enterprise Root CA, enabling certificate autoenrollment through Group Policy, enrolling a server certificate for IIS, and using HTTPS for an internal website.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to **LON-DC1**, **LON-SVR1**, and **LON-SVR2**
- Basic familiarity with Server Manager, IIS Manager, Group Policy Management, and Windows PowerShell
:::

::: warning
**Note**: This lab installs an Enterprise Root CA on **LON-DC1** for course lab purposes. In many production environments, CA placement, CA hierarchy, offline root CAs, backup, revocation, and certificate policy require additional planning.
:::

## Exercise 1: Connect to LON-SVR1 and Review OpenSSH

::: secondary
**Scenario**

Your organization wants to allow secure command-line administration in addition to graphical administration. Windows Server 2025 includes OpenSSH, but the SSH service must be enabled and validated before administrators can use it.
:::

### Task 1: Install OpenSSH Server via Server Manager

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Open **Server Manager**.

7. [ ] Click **Manage** menu and select **Add Roles and Features**.

8. [ ] Follow the wizard to the **Features** page.

9. [ ] Scroll down to find **OpenSSH Server**.

10. [ ] Check the checkbox next to **OpenSSH Server**.

11. [ ] Click **Next >** and then **Install**.

12. [ ] Wait for installation to complete, then click **Close**.

### Task 2: Verify OpenSSH Installation

1. [ ] Open PowerShell as Administrator.

2. [ ] Type the following command to verify OpenSSH is installed:

```powershell
Get-WindowsFeature -Name OpenSSH-Server* | Select-Object DisplayName, InstallState
```

3. [ ] Press **Enter**.

4. [ ] PowerShell should show:
   - **Display Name**: OpenSSH Server
   - **Install State**: Installed

::: success
**Results**: After completing this task, OpenSSH Server is installed on LON-SVR1.
:::

### Task 3: Start SSH Service

1. [ ] In PowerShell, start the SSH service:

```powershell
Start-Service -Name sshd
```

8. [ ] If the startup type is not **Automatic**, set it to **Automatic**:

```powershell
Set-Service -Name sshd -StartupType Automatic
```

::: success
**Results**: After completing this task, you have confirmed that OpenSSH is installed, running, and configured to start automatically.
:::

## Exercise 2: Review and Test the SSH Firewall Rule

::: secondary
**Scenario**

SSH uses TCP port 22. You need to verify that Windows Defender Firewall allows SSH traffic and then test the connection from another server.
:::

### Task 1: Review the SSH Rule in Windows Defender Firewall

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **Windows Defender Firewall with Advanced Security**.

3. [ ] In the left pane, select **Inbound Rules**.

4. [ ] In the center pane, find the rule named **OpenSSH Server (sshd)**.

5. [ ] Verify that the rule is **Enabled**.

6. [ ] Verify that the **Action** column shows **Allow**.

7. [ ] Double-click **OpenSSH Server (sshd)**.

8. [ ] On the **General** tab, verify that **Enabled** is selected.

9. [ ] On the **Protocols and Ports** tab, verify that **Protocol type** is **TCP** and **Local port** is **22**.

10. [ ] Select the **Advanced** tab.

11. [ ] In the **Profiles** section, verify that **Domain** and **Private** are selected.

12. [ ] If only **Private** is selected, select **Domain** so the rule applies when the server is using the domain network profile.

13. [ ] Verify that **Public** is not selected.

14. [ ] Select **OK** to save the rule settings.

   ::: warning
   **Note**: If the **OpenSSH Server (sshd)** rule is missing, create it from an elevated PowerShell window:

```powershell
New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' `
    -DisplayName 'OpenSSH Server (sshd)' `
    -Enabled True `
    -Direction Inbound `
    -Protocol TCP `
    -Action Allow `
    -Profile Domain,Private `
    -LocalPort 22
```
   :::

   ::: warning
   **Note**: If the rule exists but only applies to the **Private** profile, update it from an elevated PowerShell window:

```powershell
Set-NetFirewallRule -DisplayName 'OpenSSH Server (sshd)' -Profile Domain,Private
```
   :::

::: success
**Results**: After completing this task, you have verified that the firewall allows inbound SSH traffic to LON-SVR1.
:::

### Task 2: Test SSH from LON-SVR2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR2** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** if it is not already enabled.

5. [ ] Open **Windows PowerShell**.

6. [ ] Confirm that LON-SVR1 can be resolved by name:

```powershell
Resolve-DnsName LON-SVR1.contoso.com
```

7. [ ] Connect to LON-SVR1 by using SSH:

```powershell
ssh contoso\administrator@LON-SVR1.contoso.com
```

8. [ ] If prompted to trust the host fingerprint, type **yes** and press **Enter**.

9. [ ] When prompted, enter the Administrator password shown in the lab platform.

10. [ ] Verify that the prompt changes to a remote command shell on LON-SVR1.

11. [ ] Run the following command to confirm the server name:

```powershell
hostname
```

12. [ ] Verify that the output is `LON-SVR1`.

13. [ ] Type `exit` and press **Enter** to close the SSH session.

::: success
**Results**: After completing this task, you have tested SSH access to LON-SVR1 from another server.
:::

## Exercise 3: Configure SSH Key-Based Authentication

::: secondary
**Scenario**

Password-based SSH works, but administrators often use key-based authentication to reduce reliance on reusable passwords. You will generate an SSH key on LON-SVR2, copy the public key to LON-SVR1, and test key-based sign-in.
:::

### Task 1: Generate an SSH Key Pair on LON-SVR2

1. [ ] On **LON-SVR2**, open **Windows PowerShell** if it is not already open.

2. [ ] Generate an Ed25519 key pair:

```powershell
ssh-keygen -t ed25519 -f "$env:USERPROFILE\.ssh\id_ed25519" -C "administrator@contoso.com"
```

3. [ ] When prompted for a passphrase, press **Enter** to leave the passphrase empty for this lab.

4. [ ] When prompted to enter the same passphrase again, press **Enter**.

5. [ ] List the generated key files:

```powershell
Get-ChildItem "$env:USERPROFILE\.ssh"
```

6. [ ] Verify that the folder contains:
   - `id_ed25519`
   - `id_ed25519.pub`

   ::: warning
   **Note**: The private key file is equivalent to a sensitive credential. In production, protect private keys carefully and use a passphrase or other approved key-protection method.
   :::

::: success
**Results**: After completing this task, LON-SVR2 has an SSH key pair that can be used for authentication.
:::

### Task 2: Copy the Public Key to LON-SVR1

1. [ ] On **LON-SVR2**, run the following commands in **Windows PowerShell**:

```powershell
$authorizedKey = Get-Content -Path "$env:USERPROFILE\.ssh\id_ed25519.pub"

$remoteScript = @"
`$authorizedKey = '$authorizedKey'
Add-Content -Force -Path "`$env:ProgramData\ssh\administrators_authorized_keys" -Value `$authorizedKey
icacls.exe "`$env:ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "Administrators:F" /grant "SYSTEM:F"
"@

$encodedCommand = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($remoteScript))

ssh contoso\administrator@LON-SVR1.contoso.com "powershell -NoProfile -EncodedCommand $encodedCommand"
```

2. [ ] When prompted, enter the Administrator password shown in the lab platform.

3. [ ] Wait for the command to complete.

   ::: warning
   **Note**: Administrator accounts use `C:\ProgramData\ssh\administrators_authorized_keys` on Windows OpenSSH. Standard user accounts use an `authorized_keys` file in the user's profile.
   :::

::: success
**Results**: After completing this task, the public key from LON-SVR2 is authorized for administrator SSH access to LON-SVR1.
:::

### Task 3: Test Key-Based SSH Authentication

1. [ ] On **LON-SVR2**, connect to LON-SVR1 by using the private key:

```powershell
ssh -i "$env:USERPROFILE\.ssh\id_ed25519" contoso\administrator@LON-SVR1.contoso.com
```

2. [ ] Verify that the connection opens without prompting for the account password.

3. [ ] Run the following command:

```powershell
whoami
```

4. [ ] Verify that the output shows `contoso\administrator`.

5. [ ] Type `exit` and press **Enter** to close the SSH session.

::: success
**Results**: After completing this exercise, you have configured and tested key-based SSH authentication.
:::

## Exercise 4: Install Active Directory Certificate Services

::: secondary
**Scenario**

Your organization needs internally trusted certificates for services such as HTTPS. Instead of trusting individual self-signed certificates on every server, you will install AD CS as an Enterprise Root CA so domain members can trust certificates issued by the CA.
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

### Task 2: Install the AD CS Role

1. [ ] Open **Server Manager**.

2. [ ] Select **Dashboard**.

3. [ ] In the upper-right corner, select **Manage**.

4. [ ] Select **Add Roles and Features**.

5. [ ] On the **Before You Begin** page, select **Next >**.

6. [ ] On the **Installation Type** page, verify that **Role-based or feature-based installation** is selected, and then select **Next >**.

7. [ ] On the **Server Selection** page, verify that **LON-DC1.contoso.com** is selected, and then select **Next >**.

8. [ ] On the **Server Roles** page, select **Active Directory Certificate Services**.

9. [ ] If the **Add features that are required for Active Directory Certificate Services?** dialog appears, select **Add Features**.

10. [ ] Select **Next >**.

11. [ ] On the **Features** page, select **Next >**.

12. [ ] On the **AD CS** page, review the description, and then select **Next >**.

13. [ ] On the **Role Services** page, verify that **Certification Authority** is selected.

14. [ ] Do not select additional role services.

15. [ ] Select **Next >**.

16. [ ] On the **Confirmation** page, select **Install**.

17. [ ] Wait for the installation to complete.

18. [ ] Leave the wizard open when installation finishes.

::: success
**Results**: After completing this task, the AD CS role is installed on LON-DC1 but the CA is not yet configured.
:::

### Task 3: Configure the Enterprise Root CA

1. [ ] On the **Results** page of the Add Roles and Features Wizard, select **Configure Active Directory Certificate Services on the destination server**.

2. [ ] On the **Credentials** page, verify that the listed account has permission to configure AD CS.

3. [ ] Select **Next >**.

4. [ ] On the **Role Services** page, select **Certification Authority**.

5. [ ] Select **Next >**.

6. [ ] On the **Setup Type** page, select **Enterprise CA**.

7. [ ] Select **Next >**.

8. [ ] On the **CA Type** page, select **Root CA**.

9. [ ] Select **Next >**.

10. [ ] On the **Private Key** page, select **Create a new private key**.

11. [ ] Select **Next >**.

12. [ ] On the **Cryptography for CA** page, keep the default provider unless your instructor gives different guidance.

13. [ ] Verify that the hash algorithm is **SHA256** or stronger.

14. [ ] Select **Next >**.

15. [ ] On the **CA Name** page, review the suggested common name.

16. [ ] If needed, set the common name to `Contoso-LON-DC1-CA`.

17. [ ] Select **Next >**.

18. [ ] On the **Validity Period** page, keep the default validity period for this lab.

19. [ ] Select **Next >**.

20. [ ] On the **CA Database** page, keep the default database and log locations.

21. [ ] Select **Next >**.

22. [ ] On the **Confirmation** page, review the settings.

23. [ ] Select **Configure**.

24. [ ] Wait for the configuration to complete.

25. [ ] Verify that the wizard shows **Configuration succeeded**.

26. [ ] Select **Close**.

   ::: warning
   **Note**: This lab uses a simple Enterprise Root CA so you can focus on certificate enrollment and trust. Production PKI designs often use an offline root CA and one or more issuing CAs.
   :::

::: success
**Results**: After completing this exercise, LON-DC1 is configured as an Enterprise Root CA for the contoso.com domain.
:::

### Task 4: Create and Issue a Server Certificate Template

1. [ ] On **LON-DC1**, open **Server Manager**.

2. [ ] Select **Tools**.

3. [ ] Select **Certification Authority**.

4. [ ] In **Certification Authority**, expand **Contoso-LON-DC1-CA**.

5. [ ] Right-click **Certificate Templates**.

6. [ ] Select **Manage**.

7. [ ] In the **Certificate Templates Console**, locate **Computer**.

8. [ ] Right-click **Computer** and select **Duplicate Template**.

9. [ ] On the **Compatibility** tab, keep the default compatibility settings for this lab.

10. [ ] Select the **General** tab.

11. [ ] In **Template display name**, type `Lab 9 Web Server`.

12. [ ] Verify that **Template name** updates to `Lab9WebServer` or a similar name without spaces.

13. [ ] Select the **Subject Name** tab.

14. [ ] Verify that **Build from this Active Directory information** is selected.

15. [ ] Verify that **Subject name format** is set to **DNS name**.

16. [ ] Verify that **DNS name** is selected under **Include this information in alternate subject name**.

17. [ ] Select the **Security** tab.

18. [ ] Select **Domain Computers**.

19. [ ] In the permissions list, select **Read**, **Enroll**, and **Autoenroll**.

20. [ ] Select **OK** to create the template.

21. [ ] Close the **Certificate Templates Console**.

22. [ ] In **Certification Authority**, right-click **Certificate Templates**.

23. [ ] Select **New**.

24. [ ] Select **Certificate Template to Issue**.

25. [ ] Select **Lab 9 Web Server**.

26. [ ] Select **OK**.

27. [ ] Verify that **Lab 9 Web Server** appears in the **Certificate Templates** list for the CA.

   ::: warning
   **Note**: This lab grants autoenrollment to **Domain Computers** so the workflow is easy to validate. In production, administrators often scope autoenrollment to a specific security group that contains only the servers that need that certificate template.
   :::

::: success
**Results**: After completing this task, the CA can issue a server certificate template that domain computers can autoenroll.
:::

## Exercise 5: Configure Certificate Autoenrollment by Using Group Policy

::: secondary
**Scenario**

Domain members trust certificates issued by the Enterprise Root CA. You will now configure computer certificate autoenrollment so domain-joined servers can automatically receive certificates from the **Lab 9 Web Server** template.
:::

### Task 1: Create a Certificate Autoenrollment GPO

1. [ ] On **LON-DC1**, open **Server Manager**.

2. [ ] Select **Tools**.

3. [ ] Select **Group Policy Management**.

4. [ ] In **Group Policy Management**, expand **Forest: contoso.com**.

5. [ ] Expand **Domains**.

6. [ ] Expand **contoso.com**.

7. [ ] Right-click **contoso.com** and select **Create a GPO in this domain, and Link it here...**.

8. [ ] In **Name**, type `Lab 9 - Computer Certificate Autoenrollment`.

9. [ ] Select **OK**.

::: success
**Results**: After completing this task, you have created and linked a GPO for computer certificate autoenrollment.
:::

### Task 2: Enable Computer Certificate Autoenrollment

1. [ ] In **Group Policy Management**, right-click **Lab 9 - Computer Certificate Autoenrollment**.

2. [ ] Select **Edit**.

3. [ ] In **Group Policy Management Editor**, expand **Computer Configuration**.

4. [ ] Expand **Policies**.

5. [ ] Expand **Windows Settings**.

6. [ ] Expand **Security Settings**.

7. [ ] Expand **Public Key Policies**.

8. [ ] Select **Certificate Services Client - Auto-Enrollment**.

9. [ ] In the center pane, double-click **Certificate Services Client - Auto-Enrollment**.

10. [ ] In the properties window, set **Configuration Model** to **Enabled**.

11. [ ] Select **Renew expired certificates, update pending certificates, and remove revoked certificates**.

12. [ ] Select **Update certificates that use certificate templates**.

13. [ ] Select **OK**.

14. [ ] Close **Group Policy Management Editor**.

::: success
**Results**: After completing this task, domain computers can autoenroll certificates from AD CS when Group Policy refreshes.
:::

### Task 3: Refresh Group Policy on LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Open **Windows PowerShell** as administrator.

4. [ ] Refresh Group Policy:

```powershell
gpupdate /force
```

5. [ ] Trigger certificate autoenrollment:

```powershell
certutil -pulse
```

6. [ ] Wait for both commands to complete.

::: success
**Results**: After completing this task, LON-SVR1 has refreshed policy and requested certificates from the Enterprise CA.
:::

## Exercise 6: Verify the Server Certificate on LON-SVR1

::: secondary
**Scenario**

Before binding HTTPS in IIS, you need to verify that LON-SVR1 received a certificate issued by the new Enterprise CA.
:::

### Task 1: Open the Local Computer Certificate Store

1. [ ] On **LON-SVR1**, select **Start**.

2. [ ] Type **Manage computer certificates**.

3. [ ] Select **Manage computer certificates** from the search results.

4. [ ] In **certlm**, expand **Personal**.

5. [ ] Select **Certificates**.

6. [ ] Look for a certificate issued to **LON-SVR1.contoso.com** or **LON-SVR1**.

7. [ ] Verify that **Issued By** shows **Contoso-LON-DC1-CA**.

8. [ ] Double-click the certificate.

9. [ ] On the **General** tab, verify that the certificate has a private key.

10. [ ] Select the **Certification Path** tab.

11. [ ] Verify that the certificate chains to **Contoso-LON-DC1-CA**.

12. [ ] Select **OK**.

   ::: warning
   **Note**: If the certificate does not appear immediately, wait a minute and run `gpupdate /force` and `certutil -pulse` again from an elevated PowerShell window.
   :::

   ::: warning
   **Troubleshooting**: If only local self-signed certificates appear in the Personal store, verify the certificate template and enrollment path:

   1. [ ] On **LON-DC1**, open **Certification Authority**.
   2. [ ] Expand **Contoso-LON-DC1-CA**.
   3. [ ] Select **Certificate Templates**.
   4. [ ] Verify that **Lab 9 Web Server** is listed.
   5. [ ] If **Lab 9 Web Server** is missing, repeat Exercise 4, Task 4.
   6. [ ] On **LON-SVR1**, run:

```powershell
certutil -catemplates
```

   7. [ ] Verify that `Lab9WebServer` or **Lab 9 Web Server** appears in the template list.
   8. [ ] On **LON-SVR1**, run:

```powershell
gpresult /r /scope computer
```

   9. [ ] Verify that **Lab 9 - Computer Certificate Autoenrollment** appears under applied Group Policy Objects.
   10. [ ] On **LON-SVR1**, run:

```powershell
certutil -q -store my
```

   11. [ ] Review the Local Machine Personal certificate store output and look for a certificate issued by **Contoso-LON-DC1-CA**.
   :::

   ::: warning
   **Optional fallback**: If the certificate still does not appear, request it manually from the local computer certificate store:

   1. [ ] In **certlm**, right-click **Personal**.
   2. [ ] Select **All Tasks**.
   3. [ ] Select **Request New Certificate...**.
   4. [ ] On the **Before You Begin** page, select **Next >**.
   5. [ ] On the **Select Certificate Enrollment Policy** page, select **Active Directory Enrollment Policy**.
   6. [ ] Select **Next >**.
   7. [ ] On the **Request Certificates** page, select **Lab 9 Web Server**.
   8. [ ] Select **Enroll**.
   9. [ ] Verify that the wizard reports **Succeeded**.
   10. [ ] Select **Finish**.
   :::

::: success
**Results**: After completing this task, you have verified that LON-SVR1 received a certificate from the Enterprise CA.
:::

### Task 2: Validate the Certificate with PowerShell

1. [ ] On **LON-SVR1**, run the following command in an elevated PowerShell window:

```powershell
Get-ChildItem Cert:\LocalMachine\My |
    Where-Object { $_.Issuer -like '*Contoso-LON-DC1-CA*' } |
    Select-Object Subject, Issuer, NotAfter, HasPrivateKey
```

2. [ ] Verify that the certificate has:
   - **Issuer** containing `Contoso-LON-DC1-CA`
   - **HasPrivateKey** set to `True`
   - A future **NotAfter** date

::: success
**Results**: After completing this task, you have validated the server certificate from both the graphical certificate store and PowerShell.
:::

## Exercise 7: Bind the Certificate to the IIS Website

::: secondary
**Scenario**

LON-SVR1 already hosts an internal IIS website from an earlier lab. You will add an HTTPS binding that uses the domain-issued server certificate.
:::

### Task 1: Open IIS Manager

1. [ ] On **LON-SVR1**, open **Server Manager**.

2. [ ] Select **Tools**.

3. [ ] Select **Internet Information Services (IIS) Manager**.

4. [ ] In the **Connections** pane, expand **LON-SVR1**.

5. [ ] Expand **Sites**.

6. [ ] Select **Default Web Site**.

7. [ ] In the **Actions** pane, verify that the site is started.

   ::: warning
   **Note**: If **Internet Information Services (IIS) Manager** is not available, complete Lab 0501 before continuing.
   :::

::: success
**Results**: After completing this task, you have opened IIS Manager and selected the Default Web Site.
:::

### Task 2: Add an HTTPS Binding

1. [ ] With **Default Web Site** selected, locate the **Edit Site** section in the **Actions** pane.

2. [ ] Select **Bindings...**.

3. [ ] In the **Site Bindings** window, select **Add...**.

4. [ ] In **Type**, select **https**.

5. [ ] Verify that **IP address** is set to **All Unassigned**.

6. [ ] Verify that **Port** is set to `443`.

7. [ ] In **Host name**, type `LON-SVR1.contoso.com`.

8. [ ] In **SSL certificate**, select the certificate issued to **LON-SVR1.contoso.com** or **LON-SVR1** by **Contoso-LON-DC1-CA**.

9. [ ] Select **OK**.

10. [ ] In the **Site Bindings** window, verify that an `https` binding on port `443` is listed.

11. [ ] Select **Close**.

::: success
**Results**: After completing this task, the Default Web Site has an HTTPS binding that uses a certificate issued by the internal Enterprise CA.
:::

### Task 3: Verify the HTTPS Firewall Rule

1. [ ] On **LON-SVR1**, open **Server Manager**.

2. [ ] Select **Tools**.

3. [ ] Select **Windows Defender Firewall with Advanced Security**.

4. [ ] In the left pane, select **Inbound Rules**.

5. [ ] In the center pane, find **World Wide Web Services (HTTPS Traffic-In)**.

6. [ ] Verify that the rule is **Enabled** and that the **Action** column shows **Allow**.

7. [ ] Double-click **World Wide Web Services (HTTPS Traffic-In)**.

8. [ ] On the **Protocols and Ports** tab, verify that **Protocol type** is **TCP** and **Local port** is **443**.

9. [ ] Select **Cancel** to close the rule properties without making changes.

   ::: warning
   **Note**: If the HTTPS rule is missing or disabled, enable it from an elevated PowerShell window:

```powershell
$httpsRule = Get-NetFirewallRule -DisplayName 'World Wide Web Services (HTTPS Traffic-In)' -ErrorAction SilentlyContinue

if ($httpsRule) {
    $httpsRule | Enable-NetFirewallRule
} else {
    New-NetFirewallRule -Name 'Lab-IIS-HTTPS-In-TCP' `
        -DisplayName 'Lab IIS HTTPS (TCP 443)' `
        -Direction Inbound `
        -Action Allow `
        -Protocol TCP `
        -LocalPort 443
}
```
   :::

::: success
**Results**: After completing this task, LON-SVR1 allows inbound HTTPS traffic on TCP port 443.
:::

### Task 4: Verify the HTTPS Binding Locally

1. [ ] In **IIS Manager**, select **Default Web Site**.

2. [ ] In the **Actions** pane, locate **Browse Website**.

3. [ ] Select the HTTPS binding for port `443`.

4. [ ] Microsoft Edge opens.

5. [ ] Verify that the website loads by using `https://LON-SVR1.contoso.com`.

6. [ ] Select the certificate or site information control in Microsoft Edge.

7. [ ] Review the certificate information and confirm that it is issued by **Contoso-LON-DC1-CA**.

8. [ ] Close Microsoft Edge when you are finished.

::: success
**Results**: After completing this task, you have verified that IIS can serve the site over HTTPS.
:::

## Exercise 8: Test Internal HTTPS Trust from Another Server

::: secondary
**Scenario**

The real value of an Enterprise CA is that domain members can trust issued certificates consistently. You will test the HTTPS site from LON-SVR2 and review the certificate trust path.
:::

### Task 1: Refresh Policy on LON-SVR2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR2**.

3. [ ] Open **Windows PowerShell** as administrator.

4. [ ] Refresh Group Policy:

```powershell
gpupdate /force
```

5. [ ] Verify that LON-SVR2 can resolve LON-SVR1:

```powershell
Resolve-DnsName LON-SVR1.contoso.com
```

::: success
**Results**: After completing this task, LON-SVR2 has refreshed domain policy and can resolve the internal web server name.
:::

### Task 2: Confirm LON-SVR2 Trusts the Enterprise Root CA

1. [ ] On **LON-SVR2**, select **Start**.

2. [ ] Type **Manage computer certificates**.

3. [ ] Select **Manage computer certificates** from the search results.

4. [ ] In **certlm**, expand **Trusted Root Certification Authorities**.

5. [ ] Select **Certificates**.

6. [ ] Look for **Contoso-LON-DC1-CA** in the certificate list.

7. [ ] Double-click **Contoso-LON-DC1-CA**.

8. [ ] On the **General** tab, verify that Windows reports the certificate is trusted.

9. [ ] Select **OK**.

::: success
**Results**: After completing this task, you have verified that LON-SVR2 trusts the Enterprise Root CA.
:::

### Task 3: Browse to the HTTPS Site

1. [ ] On **LON-SVR2**, open **Microsoft Edge**.

2. [ ] In the address bar, enter:

```text
https://LON-SVR1.contoso.com
```

3. [ ] Verify that the website loads without a certificate warning.

4. [ ] Select the certificate or site information control in Microsoft Edge.

5. [ ] Review the certificate details.

6. [ ] Verify that:
   - The certificate is issued to **LON-SVR1.contoso.com** or **LON-SVR1**
   - The certificate is issued by **Contoso-LON-DC1-CA**
   - The certificate path is trusted

::: success
**Results**: After completing this task, you have verified that another domain-joined server trusts the internal HTTPS certificate.
:::

### Task 4: Validate HTTPS with PowerShell

1. [ ] On **LON-SVR2**, run the following command:

```powershell
Invoke-WebRequest -Uri "https://LON-SVR1.contoso.com" -UseBasicParsing |
    Select-Object StatusCode, StatusDescription
```

2. [ ] Verify that **StatusCode** is `200`.

3. [ ] If the command fails with a trust error, verify that LON-SVR2 has refreshed Group Policy and that the certificate on the IIS binding was issued by **Contoso-LON-DC1-CA**.

::: success
**Results**: After completing this exercise, you have validated internal HTTPS by using both Microsoft Edge and PowerShell.
:::

## Exercise 9: Review Security and Administrative Impact

::: secondary
**Scenario**

You made several remote access and PKI changes. Administrators should understand what changed, why it matters, and what would require tighter planning in production.
:::

### Task 1: Review the Administrative Changes

1. [ ] Review the changes completed in this lab:
   - Enabled OpenSSH Server on **LON-SVR1**
   - Allowed inbound SSH on TCP port `22`
   - Tested SSH from **LON-SVR2** to **LON-SVR1**
   - Configured SSH key-based authentication for an administrator account
   - Installed AD CS on **LON-DC1** as an Enterprise Root CA
   - Created a Group Policy Object for computer certificate autoenrollment
   - Enrolled a computer certificate for **LON-SVR1**
   - Added an HTTPS binding to the IIS Default Web Site
   - Tested trusted HTTPS access from **LON-SVR2**

2. [ ] Review the security considerations:
   - SSH access should be limited to approved administrators and management networks.
   - Private SSH keys must be protected because they can be used to authenticate without typing the account password.
   - Internal certificates should come from a managed CA rather than unmanaged self-signed certificates.
   - CA backup, CA private key protection, certificate revocation, and certificate renewal are operational responsibilities.
   - HTTPS protects traffic in transit, but it does not replace the need for correct IIS permissions and server hardening.

::: success
**Results**: After completing this lab, you understand how OpenSSH, SSH keys, AD CS, certificate autoenrollment, IIS bindings, and internal HTTPS trust fit together in a Windows Server environment.
:::
