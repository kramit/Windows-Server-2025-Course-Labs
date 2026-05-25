# Practice Lab 1701: Configuring Network Settings and TCP/IP

## Summary

::: secondary
In this lab, you will configure network settings on Windows Server. You will understand IP addressing, configure static IP addresses, manage DNS settings, and troubleshoot network connectivity.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0601 (Post-Installation Server Configuration and Security Hardening)
- Administrator access to LON-SVR1
- Understanding of basic networking concepts (IP addresses, DNS, gateways)
:::

## Exercise 1: Viewing Current Network Configuration

::: secondary
**Scenario**

You need to understand the current network configuration of your server. You will view IP addresses, DNS settings, and network adapters.
:::

### Task 1: View Network Configuration in Settings

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Open **Start**, type **Settings**, and select **Settings**.

7. [ ] Search for **Network settings** and select it.

8. [ ] Select **Ethernet** or your network adapter name.

9. [ ] You will see:
   - **Status**: Connected
   - **IP address**: Your server's IPv4 address (e.g., 192.168.1.100)
   - **Subnet mask**: Network mask (e.g., 255.255.255.0)
   - **Gateway**: Default gateway (e.g., 192.168.1.1)
   - **DNS servers**: One or more DNS server addresses

10. [ ] Select **Edit** if you want to modify settings.

::: success
**Results**: After completing this task, you can view network configuration.
:::

### Task 2: View Network Configuration via Command Line

1. [ ] Open **Command Prompt** or **PowerShell** as Administrator.

2. [ ] Type the following command to see all network adapters:

```powershell
Get-NetAdapter | Select-Object Name, Status, MacAddress | Format-Table
```

3. [ ] Press **Enter**.

4. [ ] This shows:
   - **Name**: Adapter name (Ethernet)
   - **Status**: Connected or Disconnected
   - **MacAddress**: Physical hardware address

5. [ ] View IP configuration:

```powershell
Get-NetIPAddress | Select-Object InterfaceAlias, AddressFamily, IPAddress, PrefixLength | Format-Table
```

6. [ ] Press **Enter**.

7. [ ] This shows:
   - **InterfaceAlias**: Adapter name
   - **AddressFamily**: IPv4 or IPv6
   - **IPAddress**: The IP address
   - **PrefixLength**: Subnet mask (e.g., /24 = 255.255.255.0)

::: success
**Results**: After completing this task, you can view network configuration using PowerShell.
:::

## Exercise 2: Configuring Static IP Address

::: secondary
**Scenario**

Servers typically need static (permanent) IP addresses rather than DHCP-assigned addresses. You will configure a static IP address.
:::

### Task 1: Identify Current Configuration

First, note your current configuration (you can view this from Exercise 1).

Record:
- Current IP address: ___________
- Current subnet mask/prefix: ___________
- Current gateway: ___________
- Current DNS: ___________

::: success
**Results**: After noting current configuration, you can proceed to static configuration.
:::

### Task 2: Change to Static IP (Using Settings)

1. [ ] Open **Settings** > **Network & Internet** > **Ethernet**.

2. [ ] Click **Edit** next to "IP assignment".

3. [ ] A dropdown will appear. Change from **Automatic (DHCP)** to **Manual**.

4. [ ] Toggle **IPv4** to **On**.

5. [ ] Fill in the fields:
   - **IP address**: Your server's static IP (use current IP or assign a new one from your network admin)
   - **Subnet mask**: Your network's subnet mask (e.g., 255.255.255.0)
   - **Gateway**: Your network's default gateway

6. [ ] Scroll down to DNS settings.

7. [ ] Change **Automatic** to **Manual**.

8. [ ] Enter DNS server addresses:
   - **Preferred DNS**: Usually your domain controller IP or ISP DNS (e.g., 8.8.8.8 for Google DNS)
   - **Alternate DNS**: Backup DNS server (optional)

9. [ ] Click **Save**.

10. [ ] The network adapter will be reconfigured. You may briefly lose connectivity.

   ::: warning
   **Note**: Choose IP address carefully. Duplicate IPs will cause network problems. Consult your network administrator.
   :::

::: success
**Results**: After completing this task, the server has a static IP address.
:::

### Task 3: Verify Static Configuration

1. [ ] Return to **Settings** > **Ethernet**.

2. [ ] Verify that:
   - **IP assignment** shows your static IP address
   - **DNS servers** show your configured DNS
   - Status shows **Connected**

3. [ ] Via PowerShell, verify:

```powershell
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, IPAddress, PrefixLength | Format-Table
```

4. [ ] Your static IP should be displayed.

::: success
**Results**: After completing this task, static IP configuration is verified.
:::

## Exercise 3: Troubleshooting Network Connectivity

::: secondary
**Scenario**

You need to troubleshoot network problems. You will use tools to diagnose connectivity issues.
:::

### Task 1: Test Basic Connectivity

1. [ ] Open PowerShell as Administrator.

2. [ ] Test connectivity to the default gateway:

```powershell
Test-NetConnection -ComputerName 192.168.1.1
```

3. [ ] Replace 192.168.1.1 with your actual gateway IP.

4. [ ] Press **Enter**.

5. [ ] You should see:
   - **ComputerName**: The computer you pinged
   - **RemoteAddress**: The IP you pinged
   - **PingSucceeded**: True (if connectivity works)
   - **PingReplyDetails**: Latency information

6. [ ] If PingSucceeded shows False, there's a connectivity problem.

::: success
**Results**: After completing this task, you can test basic connectivity.
:::

### Task 2: Test DNS Resolution

1. [ ] Test DNS resolution:

```powershell
Resolve-DnsName -Name contoso.com
```

2. [ ] Press **Enter**.

3. [ ] PowerShell should return:
   - **Name**: The domain name
   - **Type**: A (IPv4 address record)
   - **IPAddress**: The resolved IP address

4. [ ] If resolution fails, DNS is not configured properly.

::: success
**Results**: After completing this task, you can test DNS resolution.
:::

### Task 3: View Network Statistics

1. [ ] See detailed network statistics:

```powershell
Get-NetStatistics -AddressFamily IPv4 | Format-List
```

2. [ ] Or view active network connections:

```powershell
Get-NetTCPConnection -State Established | Select-Object LocalAddress, LocalPort, RemoteAddress, RemotePort, State | Format-Table
```

3. [ ] This shows active TCP connections from your server.

::: success
**Results**: After completing this task, you understand network connectivity tools.
:::

## Exercise 4: Configuring DNS Settings

::: secondary
**Scenario**

DNS is critical for name resolution. You will configure DNS properly for your domain.
:::

### Task 1: Verify DNS Configuration

1. [ ] Open PowerShell as Administrator.

2. [ ] View current DNS configuration:

```powershell
Get-DnsClientServerAddress -AddressFamily IPv4 | Select-Object InterfaceAlias, ServerAddresses | Format-Table
```

3. [ ] Press **Enter**.

4. [ ] You should see your DNS servers listed.

5. [ ] For a domain-joined server, the primary DNS should typically be the domain controller (LON-DC1).

::: success
**Results**: After completing this task, you can verify DNS configuration.
:::

### Task 2: Configure DNS via PowerShell

If you need to change DNS servers:

1. [ ] Type the following command (replace values with your actual servers):

```powershell
Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses 192.168.1.50, 8.8.8.8
```

2. [ ] Press **Enter**.

3. [ ] This sets:
   - Primary DNS: 192.168.1.50 (your domain controller)
   - Secondary DNS: 8.8.8.8 (Google DNS for backup)

4. [ ] Verify with:

```powershell
Get-DnsClientServerAddress -InterfaceAlias Ethernet -AddressFamily IPv4
```

::: success
**Results**: After completing this task, you can configure DNS using PowerShell.
:::

## Exercise 5: Understanding Network Security

::: secondary
**Scenario**

Network configuration should include security considerations.
:::

### Task 1: Network Security Basics

1. **Firewall**:
   - Windows Firewall should be enabled (covered in Lab 0601)
   - Opens only necessary ports
   - Blocks unauthorized access

2. **IP Configuration**:
   - Static IPs prevent spoofing (someone using your server's IP)
   - Private IP ranges for internal networks (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)
   - Don't expose servers directly to internet without VPN/reverse proxy

3. **DNS Security**:
   - Use trusted DNS servers
   - Consider DNSSEC for DNS validation
   - Protect DNS servers from attacks

4. **Network Monitoring**:
   - Monitor unusual network activity
   - Check for unexpected outbound connections
   - Use Performance Monitor to track network usage

::: success
**Results**: After completing this task, you understand network security considerations.
:::

## Exercise 6: Verification and Summary

::: secondary
**Scenario**

You have configured and verified network settings on your Windows Server.
:::

### Task 1: Network Configuration Checklist

Verify the following are complete:

1. ✓ Current network configuration understood
2. ✓ Static IP address configured
3. ✓ DNS servers configured
4. ✓ Gateway configured
5. ✓ Network connectivity verified (ping test)
6. ✓ DNS resolution working
7. ✓ Network adapter properly configured
8. ✓ Firewall is enabled

::: success
**Results**: You have successfully completed Lab 1701. You now understand:
- How to view network configuration
- How to configure static IP addresses
- How to configure DNS settings
- How to troubleshoot network connectivity
- How to use PowerShell for network management
- Network security considerations

Proper network configuration is fundamental for Windows Server operations. All future server roles and services depend on correct network setup. In production, collaborate with network administrators to ensure proper IP addressing and DNS configuration.
:::
