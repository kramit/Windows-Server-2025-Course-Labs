# Practice Lab 0901: Installing OpenSSH and Configuring Secure Remote Access

## Summary

::: secondary
In this lab, you will install and configure OpenSSH Server on Windows Server, enabling secure SSH connections as an alternative to RDP. You will generate SSH keys and configure key-based authentication for secure remote access.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SVR1
- Understanding of encryption concepts (basic)
:::

## Exercise 1: Installing OpenSSH Server

::: secondary
**Scenario**

You need to enable secure SSH access to your Windows Server. OpenSSH provides a secure alternative to Telnet and RDP for remote administration.
:::

### Task 1: Install OpenSSH Server via Server Manager

1. [ ] Connect to LON-SVR1 using Remote Desktop.
2. [ ] Open Server Manager.
3. [ ] Click **Manage** menu and select **Add Roles and Features**.
4. [ ] Follow the wizard to the **Features** page.
5. [ ] Scroll down to find **OpenSSH Server**.
6. [ ] Check the checkbox next to **OpenSSH Server**.
7. [ ] Click **Next >** and then **Install**.
8. [ ] Wait for installation to complete, then click **Close**.

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

2. [ ] Press **Enter**.
3. [ ] Set the service to start automatically on boot:

```powershell
Set-Service -Name sshd -StartupType Automatic
```

4. [ ] Press **Enter**.
5. [ ] Verify the service is running:

```powershell
Get-Service -Name sshd | Select-Object Name, Status, StartType
```

6. [ ] Press **Enter**.
7. [ ] PowerShell should show:
   - **Name**: sshd
   - **Status**: Running
   - **StartType**: Automatic

::: success
**Results**: After completing this task, the SSH service is running and will start automatically.
:::

## Exercise 2: Configuring Firewall for SSH

::: secondary
**Scenario**

SSH uses port 22. You need to open the firewall to allow SSH connections from remote clients.
:::

### Task 1: Create SSH Firewall Rule

1. [ ] In PowerShell, create a firewall rule for SSH:

```powershell
New-NetFirewallRule -Name "Allow SSH" -DisplayName "Allow SSH" -Direction Inbound -Action Allow -Protocol TCP -LocalPort 22
```

2. [ ] Press **Enter**.
3. [ ] PowerShell will create the rule.
4. [ ] Verify the rule was created:

```powershell
Get-NetFirewallRule -DisplayName "Allow SSH" | Select-Object DisplayName, Direction, Action, Enabled
```

5. [ ] Press **Enter**.
6. [ ] PowerShell should show:
   - **DisplayName**: Allow SSH
   - **Direction**: Inbound
   - **Action**: Allow
   - **Enabled**: True

::: success
**Results**: After completing this task, the firewall allows SSH traffic on port 22.
:::

## Exercise 3: Generating SSH Keys

::: secondary
**Scenario**

SSH key authentication is more secure than password authentication. You will generate a public/private key pair.
:::

### Task 1: Generate SSH Keys

1. [ ] In PowerShell, generate a new SSH key pair:

```powershell
ssh-keygen -t rsa -b 4096 -f "$env:USERPROFILE\.ssh\id_rsa" -N ""
```

2. [ ] Press **Enter**.
3. [ ] This command generates:
   - **id_rsa**: Private key (keep this secret!)
   - **id_rsa.pub**: Public key (share this with servers)
4. [ ] PowerShell will confirm the keys were generated.

### Task 2: Verify SSH Keys

1. [ ] List the SSH keys:

```powershell
dir $env:USERPROFILE\.ssh\
```

2. [ ] Press **Enter**.
3. [ ] You should see:
   - **id_rsa** (private key)
   - **id_rsa.pub** (public key)

::: success
**Results**: After completing this task, you have generated SSH keys for authentication.
:::

## Exercise 4: Testing SSH Connection

::: secondary
**Scenario**

You will test SSH connectivity to ensure the service is working properly.
:::

### Task 1: Test Local SSH Connection

1. [ ] In PowerShell, test SSH connectivity to localhost:

```powershell
ssh -V
```

2. [ ] Press **Enter**.
3. [ ] This displays the SSH client version (confirming it's installed).
4. [ ] Test connecting to the local server:

```powershell
ssh Administrator@localhost
```

5. [ ] Press **Enter**.
6. [ ] You may be prompted:
   - "Are you sure you want to continue connecting? (yes/no/[fingerprint])"
   - Type **yes** and press **Enter**
7. [ ] You may be prompted for a password. Type your Administrator password.
8. [ ] If successful, you will see a PowerShell prompt indicating you are connected via SSH.
9. [ ] Type **exit** to close the SSH connection.

::: warning
**Note**: If the connection fails, verify that the SSH service is running and the firewall rule is in place.
:::

::: success
**Results**: After completing this task, you have verified SSH is working.
:::

## Exercise 5: Understanding SSH Security

::: secondary
**Scenario**

SSH provides encryption and secure authentication. Understanding these security features is important.
:::

### Task 1: Review SSH Configuration

1. [ ] The SSH configuration file is located at: `C:\ProgramData\ssh\sshd_config`
2. [ ] Open PowerShell as Administrator and view key configuration settings:

```powershell
Get-Content "C:\ProgramData\ssh\sshd_config" | Select-String "Port|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication" | Where-Object {$_ -notmatch "^#"}
```

3. [ ] Press **Enter**.
4. [ ] This shows important SSH settings:
   - **Port 22**: The port SSH uses
   - **PasswordAuthentication**: Should be "yes" for password login
   - **PubkeyAuthentication**: Should be "yes" for key-based authentication

::: success
**Results**: After completing this task, you understand SSH configuration.
:::

## Exercise 6: Summary and Verification

::: secondary
**Scenario**

You have successfully configured OpenSSH on Windows Server.
:::

### Task 1: Final Verification

Verify the following are complete:

1. ✓ OpenSSH Server is installed
2. ✓ SSH service is running
3. ✓ SSH service set to automatic startup
4. ✓ Firewall rule allows port 22
5. ✓ SSH keys have been generated
6. ✓ SSH connectivity works

::: success
**Results**: You have successfully completed Lab 0901. You now understand:
- How to install OpenSSH Server on Windows Server
- How to configure SSH service
- How to open firewall for SSH traffic
- How to generate SSH key pairs
- How to test SSH connectivity

SSH provides a modern, secure alternative to RDP for remote administration. In future labs, you will configure certificate-based authentication and understand PKI concepts in more detail.
:::
