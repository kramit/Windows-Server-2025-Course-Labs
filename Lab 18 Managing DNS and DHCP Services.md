# Practice Lab 1801: Managing DNS and DHCP Services

## Summary

::: secondary
In this lab, you will manage DNS and DHCP services in a Windows Server 2025 domain environment. You will use LON-DC1 to manage DNS records, LON-SRV1 to install and configure the DHCP Server role, and LON-SRV2 to validate name resolution and cross-server behavior.

The lab focuses on graphical administration tools, including Server Manager, DNS Manager, DHCP Manager, Microsoft Edge, and Event Viewer. PowerShell is used only for focused validation where it makes the result easier to confirm.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Completed Lab 1701 (Configuring Network Settings and TCP/IP)
- Administrator access to LON-DC1, LON-SRV1, and LON-SRV2
- Basic familiarity with DNS names, IP addresses, and server roles
:::

::: warning
**Note**: This lab creates DNS records and configures a DHCP scope for learning purposes. Do not activate a DHCP scope on a production network unless the address range, exclusions, options, and authorization have been reviewed by a network administrator.
:::

## Exercise 1: Review the Lab Servers and Collect Network Details

::: secondary
**Scenario**

Before changing DNS or DHCP services, you need to confirm which servers are available and record the network details that will be used later in the lab.
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

### Task 2: Review Server Manager on LON-DC1 and Record Its IPv4 Address

1. [ ] If **Server Manager** is already open, bring it to the front.

2. [ ] If **Server Manager** is not open, select **Start**, type **Server Manager**, and select **Server Manager** from the search results.

3. [ ] In **Server Manager**, select **Dashboard**.

4. [ ] Review the **Roles and Server Groups** section.

5. [ ] Verify that **AD DS** and **DNS** are listed.

6. [ ] In the left navigation pane, select **DNS**.

7. [ ] Verify that **LON-DC1** appears in the **Servers** tile.

8. [ ] Select **Local Server** in the left navigation pane.

9. [ ] In the **Properties** tile, find the **Ethernet** entry.

10. [ ] Select the linked value next to **Ethernet** to open **Network Connections**.

11. [ ] In **Network Connections**, right-click the active network adapter and select **Status**.

12. [ ] In the **Ethernet Status** window, select **Details...**.

13. [ ] Record the value shown next to **IPv4 Address**.

14. [ ] Select **Close** to close **Network Connection Details**.

15. [ ] Select **Close** to close **Ethernet Status**.

Record the value:

| Setting | Value |
|---|---|
| LON-DC1 IPv4 address |  |

::: success
**Results**: After completing this task, you have confirmed that LON-DC1 is the domain controller and DNS server for the lab and recorded its IPv4 address.
:::

### Task 3: Record the IPv4 Address of LON-SRV1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV1**.

3. [ ] Sign in by using the **Username** and **Password** values shown for LON-SRV1 on the **HOME** tab.

4. [ ] In the **Tools** section, verify that **Enhanced mode** is turned on.

5. [ ] Open **Server Manager** if it is not already open.

6. [ ] Select **Local Server** in the left navigation pane.

7. [ ] In the **Properties** tile, find the **Ethernet** entry.

8. [ ] Select the linked value next to **Ethernet** to open **Network Connections**.

9. [ ] In **Network Connections**, right-click the active network adapter and select **Status**.

10. [ ] In the **Ethernet Status** window, select **Details...**.

11. [ ] Record the value shown next to **IPv4 Address**.

12. [ ] Record the value shown next to **IPv4 DNS Server**.

13. [ ] Select **Close** to close **Network Connection Details**.

14. [ ] Select **Close** to close **Ethernet Status**.

Record the values:

| Setting | Value |
|---|---|
| LON-SRV1 IPv4 address |  |
| LON-SRV1 IPv4 DNS server |  |

::: success
**Results**: After completing this task, you have recorded the LON-SRV1 network details needed for DNS and DHCP configuration.
:::

### Task 4: Confirm LON-SRV2 Is Available for Validation

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Sign in by using the **Username** and **Password** values shown for LON-SRV2 on the **HOME** tab.

4. [ ] In the **Tools** section, verify that **Enhanced mode** is turned on.

5. [ ] Open **Server Manager** if it is not already open.

6. [ ] Select **Local Server**.

7. [ ] Verify that **Computer name** shows **LON-SRV2**.

8. [ ] Verify that **Domain** shows **contoso.com**.

::: success
**Results**: After completing this exercise, you have confirmed the three lab servers and recorded the network information needed for the lab.
:::

## Exercise 2: Create and Validate DNS Records on LON-DC1

::: secondary
**Scenario**

Your organization wants users to access an internal web service by using a friendly DNS name instead of a server name or IP address. You will create DNS records on LON-DC1 and validate the result from LON-SRV2.
:::

### Task 1: Open DNS Manager on LON-DC1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] Verify that you are signed in to the LON-DC1 desktop.

4. [ ] In **Server Manager**, select **Tools**.

5. [ ] Select **DNS**.

6. [ ] In **DNS Manager**, expand **LON-DC1**.

7. [ ] Expand **Forward Lookup Zones**.

8. [ ] Select **contoso.com**.

9. [ ] Review the existing records in the center pane.

::: success
**Results**: After completing this task, you have opened the contoso.com DNS zone on LON-DC1.
:::

### Task 2: Create an A Record for an Internal Web Name

1. [ ] In **DNS Manager**, verify that **Forward Lookup Zones** > **contoso.com** is selected.

2. [ ] In the **Actions** pane, select **New Host (A or AAAA)...**.

3. [ ] In the **New Host** window, in **Name**, enter `intranet`.

4. [ ] In **IP address**, enter the IPv4 address you recorded for **LON-SRV1**.

5. [ ] Verify that **Create associated pointer (PTR) record** is selected if the option is available.

6. [ ] Select **Add Host**.

7. [ ] When the confirmation message appears, select **OK**.

8. [ ] Select **Done**.

9. [ ] In the center pane, verify that the **intranet** record appears.

   ::: warning
   **Note**: If a record named **intranet** already exists, open its **Properties** and verify that it points to the IPv4 address of LON-SRV1. Do not create a duplicate record with the same name.
   :::

::: success
**Results**: After completing this task, you have created a DNS A record that maps intranet.contoso.com to LON-SRV1.
:::

### Task 3: Create a CNAME Alias

1. [ ] In **DNS Manager**, verify that **Forward Lookup Zones** > **contoso.com** is selected.

2. [ ] In the **Actions** pane, select **New Alias (CNAME)...**.

3. [ ] In **Alias name**, enter `web`.

4. [ ] In **Fully qualified domain name (FQDN) for target host**, enter `intranet.contoso.com`.

5. [ ] Select **OK**.

6. [ ] In the center pane, verify that the **web** alias appears.

   ::: warning
   **Note**: If a CNAME record named **web** already exists, open its **Properties** and verify that it points to `intranet.contoso.com`. Do not create a duplicate alias with the same name.
   :::

   ::: warning
   **Note**: A CNAME record points one DNS name to another DNS name. This is useful when you want a friendly service name but do not want to maintain multiple IP address records.
   :::

::: success
**Results**: After completing this task, you have created web.contoso.com as an alias for intranet.contoso.com.
:::

### Task 4: Validate DNS from LON-SRV2 by Using Microsoft Edge

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Verify that you are signed in to the LON-SRV2 desktop.

4. [ ] Open **Microsoft Edge**.

5. [ ] In the address bar, enter `http://intranet.contoso.com`.

6. [ ] Verify that the website hosted on LON-SRV1 loads.

7. [ ] In the address bar, enter `http://web.contoso.com`.

8. [ ] Verify that the same website loads by using the alias.

   ::: warning
   **Note**: If the web page does not load, verify that the Web Server (IIS) role is installed and the Default Web Site is running on LON-SRV1. Lab 0501 installs and tests IIS on LON-SRV1.
   :::

::: success
**Results**: After completing this task, you have validated the new DNS records from a different server.
:::

### Task 5: Validate DNS from LON-SRV2 by Using a Focused Command

1. [ ] On LON-SRV2, select **Start**.

2. [ ] Type **Terminal**.

3. [ ] Select **Run as administrator** for **Terminal**.

4. [ ] If prompted by **User Account Control**, select **Yes**.

5. [ ] Run the following command to resolve the A record:

```powershell
Resolve-DnsName intranet.contoso.com
```

6. [ ] Verify that the returned IP address matches the IPv4 address of LON-SRV1.

7. [ ] Run the following command to resolve the alias:

```powershell
Resolve-DnsName web.contoso.com
```

8. [ ] Verify that the result shows the alias and resolves to the LON-SRV1 address.

::: success
**Results**: After completing this exercise, you have created and validated DNS records that direct traffic from LON-SRV2 to a service on LON-SRV1.
:::

## Exercise 3: Configure a Reverse Lookup Zone and PTR Record

::: secondary
**Scenario**

Forward lookup resolves a name to an IP address. Reverse lookup resolves an IP address back to a name. You will configure reverse lookup so administrators can identify servers during troubleshooting.
:::

### Task 1: Create a Reverse Lookup Zone on LON-DC1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] In **DNS Manager**, expand **LON-DC1**.

4. [ ] Right-click **Reverse Lookup Zones**.

5. [ ] Select **New Zone...**.

6. [ ] On the **Welcome to the New Zone Wizard** page, select **Next >**.

7. [ ] On the **Zone Type** page, verify that **Primary zone** is selected.

8. [ ] Verify that **Store the zone in Active Directory** is selected if the option appears.

9. [ ] Select **Next >**.

10. [ ] On the **Active Directory Zone Replication Scope** page, select **To all DNS servers running on domain controllers in this domain: contoso.com**.

11. [ ] Select **Next >**.

12. [ ] On the **Reverse Lookup Zone Name** page, select **IPv4 Reverse Lookup Zone**.

13. [ ] Select **Next >**.

14. [ ] On the **Reverse Lookup Zone Name** page, select **Network ID**.

15. [ ] Enter the network portion of the LON-SRV1 IPv4 address.

16. [ ] Select **Next >**.

17. [ ] On the **Dynamic Update** page, select **Allow only secure dynamic updates**.

18. [ ] Select **Next >**.

19. [ ] On the **Completing the New Zone Wizard** page, review the settings.

20. [ ] Select **Finish**.

   ::: warning
   **Note**: For example, if LON-SRV1 uses `192.168.10.21` with a typical /24 subnet, the network ID is `192.168.10`. Use the actual network used by your lab environment.
   :::

::: success
**Results**: After completing this task, you have created an Active Directory-integrated reverse lookup zone.
:::

### Task 2: Create or Verify the PTR Record for LON-SRV1

1. [ ] In **DNS Manager**, expand **Reverse Lookup Zones**.

2. [ ] Select the reverse lookup zone you created.

3. [ ] Review the records in the center pane.

4. [ ] If a PTR record for LON-SRV1 already exists, open the record and verify that it points to `LON-SRV1.contoso.com`.

5. [ ] If a PTR record for LON-SRV1 does not exist, right-click the reverse lookup zone and select **New Pointer (PTR)...**.

6. [ ] In **Host IP address**, enter the IPv4 address of LON-SRV1.

7. [ ] In **Host name**, enter `LON-SRV1.contoso.com`.

8. [ ] Select **OK**.

9. [ ] Verify that the PTR record appears in the center pane.

::: success
**Results**: After completing this task, reverse DNS lookup can identify LON-SRV1 by IP address.
:::

### Task 3: Validate Reverse Lookup from LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Open **Terminal** as administrator if it is not already open.

4. [ ] Run the following command, replacing the IP address with the IPv4 address of LON-SRV1:

```powershell
Resolve-DnsName 192.168.10.21
```

5. [ ] Verify that the result returns `LON-SRV1.contoso.com`.

   ::: warning
   **Note**: Replace `192.168.10.21` with the actual IPv4 address of LON-SRV1. The example address is only a placeholder.
   :::

::: success
**Results**: After completing this exercise, you have configured and validated reverse DNS lookup for LON-SRV1.
:::

## Exercise 4: Install and Configure the DHCP Server Role on LON-SRV1

::: secondary
**Scenario**

Your organization wants to understand how Windows Server can centrally assign IP configuration to clients. You will install the DHCP Server role on LON-SRV1, authorize it in Active Directory, and create a controlled scope for lab review.
:::

### Task 1: Open Server Manager on LON-SRV1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV1**.

3. [ ] Verify that you are signed in to the LON-SRV1 desktop.

4. [ ] Open **Server Manager** if it is not already open.

5. [ ] Select **Dashboard**.

::: success
**Results**: After completing this task, you are ready to install a server role on LON-SRV1.
:::

### Task 2: Install the DHCP Server Role

1. [ ] In **Server Manager**, select **Manage**.

2. [ ] Select **Add Roles and Features**.

3. [ ] On the **Before You Begin** page, select **Next >**.

4. [ ] On the **Installation Type** page, verify that **Role-based or feature-based installation** is selected.

5. [ ] Select **Next >**.

6. [ ] On the **Server Selection** page, verify that **Select a server from the server pool** is selected.

7. [ ] Select **LON-SRV1.contoso.com**.

8. [ ] Select **Next >**.

9. [ ] On the **Server Roles** page, select **DHCP Server**.

10. [ ] When the **Add features that are required for DHCP Server?** dialog appears, select **Add Features**.

11. [ ] Verify that **DHCP Server** is selected.

12. [ ] Select **Next >**.

13. [ ] On the **Features** page, do not select additional features.

14. [ ] Select **Next >**.

15. [ ] On the **DHCP Server** page, review the information.

16. [ ] Select **Next >**.

17. [ ] On the **Confirmation** page, verify that **DHCP Server** appears in the list.

18. [ ] Select **Install**.

19. [ ] Wait for the **Results** page to show **Installation succeeded**.

20. [ ] Select **Close**.

::: success
**Results**: After completing this task, the DHCP Server role is installed on LON-SRV1.
:::

### Task 3: Complete DHCP Post-Install Configuration

1. [ ] In **Server Manager**, select the notification flag near the upper-right corner.

2. [ ] Select **Complete DHCP configuration**.

3. [ ] On the **Description** page of the **DHCP Post-Install configuration wizard**, review the information.

4. [ ] Select **Next >**.

5. [ ] On the **Authorization** page, verify that **Use the following user's credentials** is selected.

6. [ ] Verify that the displayed account has domain administrative rights.

7. [ ] Select **Commit**.

8. [ ] Wait for the wizard to complete the security group creation and DHCP authorization tasks.

9. [ ] Verify that the status shows **Done** for each task.

10. [ ] Select **Close**.

   ::: warning
   **Note**: DHCP authorization helps prevent unauthorized DHCP servers from assigning addresses in an Active Directory domain.
   :::

::: success
**Results**: After completing this task, LON-SRV1 is authorized to provide DHCP services in the contoso.com domain.
:::

### Task 4: Open DHCP Manager

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **DHCP**.

3. [ ] In **DHCP Manager**, expand **lon-srv1.contoso.com**.

4. [ ] Expand **IPv4**.

5. [ ] Verify that no active production scope is created unless your instructor has already configured one.

::: success
**Results**: After completing this task, you have opened DHCP Manager and located the IPv4 configuration area.
:::

## Exercise 5: Create a Controlled DHCP Scope and Reservation

::: secondary
**Scenario**

You need to create a DHCP scope that includes the values clients would need, but you will keep the scope inactive until it has been reviewed. This shows the correct administrative workflow without unexpectedly changing address assignment in the lab network.
:::

### Task 1: Start the New Scope Wizard

1. [ ] On LON-SRV1, in **DHCP Manager**, right-click **IPv4**.

2. [ ] Select **New Scope...**.

3. [ ] On the **Welcome to the New Scope Wizard** page, select **Next >**.

4. [ ] On the **Scope Name** page, in **Name**, enter `Contoso Lab Scope`.

5. [ ] In **Description**, enter `Controlled DHCP scope for Windows Server 2025 lab validation`.

6. [ ] Select **Next >**.

::: success
**Results**: After completing this task, you have started the DHCP scope creation process.
:::

### Task 2: Define the Address Range

1. [ ] On the **IP Address Range** page, enter a small address range from the same network as LON-SRV1.

2. [ ] In **Start IP address**, enter the first address in the lab range provided by your instructor.

3. [ ] In **End IP address**, enter the last address in the lab range provided by your instructor.

4. [ ] Verify that **Length** and **Subnet mask** match the lab network.

5. [ ] Select **Next >**.

   ::: warning
   **Note**: Use only an address range approved for this lab. Do not guess a production DHCP range. If your instructor has not provided an address range, use the wizard for review only and do not activate the scope.
   :::

::: success
**Results**: After completing this task, you have defined the address range that the DHCP scope would manage.
:::

### Task 3: Add Exclusions

1. [ ] On the **Add Exclusions and Delay** page, enter an exclusion range that protects existing static server addresses.

2. [ ] In **Start IP address**, enter the first static server address to exclude.

3. [ ] In **End IP address**, enter the last static server address to exclude.

4. [ ] Select **Add**.

5. [ ] Verify that the exclusion appears in the **Excluded address range** list.

6. [ ] Leave **Subnet delay** set to `0`.

7. [ ] Select **Next >**.

   ::: warning
   **Note**: Exclusions help prevent DHCP from assigning addresses that are already used by servers, routers, printers, or other statically configured devices.
   :::

::: success
**Results**: After completing this task, you have protected static addresses from DHCP assignment.
:::

### Task 4: Configure Lease Duration

1. [ ] On the **Lease Duration** page, review the default lease duration.

2. [ ] Leave the lease duration at the default value unless your instructor provides a different value.

3. [ ] Select **Next >**.

::: success
**Results**: After completing this task, you have reviewed the DHCP lease duration for the scope.
:::

### Task 5: Configure DHCP Options

1. [ ] On the **Configure DHCP Options** page, verify that **Yes, I want to configure these options now** is selected.

2. [ ] Select **Next >**.

3. [ ] On the **Router (Default Gateway)** page, enter the default gateway address for the lab network if one is provided.

4. [ ] Select **Add**.

5. [ ] Verify that the router address appears in the list.

6. [ ] Select **Next >**.

7. [ ] On the **Domain Name and DNS Servers** page, verify that **Parent domain** shows `contoso.com`.

8. [ ] In **IP address**, enter the IPv4 address of **LON-DC1** that you recorded earlier.

9. [ ] Select **Add**.

10. [ ] Verify that LON-DC1 appears in the DNS server list.

11. [ ] Select **Next >**.

12. [ ] On the **WINS Servers** page, do not add a WINS server.

13. [ ] Select **Next >**.

   ::: warning
   **Note**: Most modern Windows environments use DNS instead of WINS. This lab leaves WINS unconfigured.
   :::

::: success
**Results**: After completing this task, the DHCP scope includes the domain name and DNS server settings clients need.
:::

### Task 6: Leave the Scope Inactive for Review

1. [ ] On the **Activate Scope** page, select **No, I will activate this scope later**.

2. [ ] Select **Next >**.

3. [ ] On the **Completing the New Scope Wizard** page, select **Finish**.

4. [ ] In **DHCP Manager**, expand **IPv4**.

5. [ ] Verify that **Contoso Lab Scope** appears.

6. [ ] Select the scope.

7. [ ] Verify that the scope icon indicates that it is not active.

   ::: warning
   **Note**: Keeping the scope inactive prevents the lab DHCP server from assigning addresses before the range has been reviewed.
   :::

::: success
**Results**: After completing this task, you have created a DHCP scope without activating it.
:::

### Task 7: Record the Network Adapter Address for LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Open **Server Manager** if it is not already open.

4. [ ] Select **Local Server**.

5. [ ] In the **Properties** tile, select the linked value next to **Ethernet**.

6. [ ] In **Network Connections**, right-click the active network adapter and select **Status**.

7. [ ] In the **Ethernet Status** window, select **Details...**.

8. [ ] Record the value shown next to **Physical Address**.

9. [ ] Record the value shown next to **IPv4 Address**.

10. [ ] Select **Close** to close **Network Connection Details**.

11. [ ] Select **Close** to close **Ethernet Status**.

Record the values:

| Setting | Value |
|---|---|
| LON-SRV2 physical address |  |
| LON-SRV2 IPv4 address |  |

::: success
**Results**: After completing this task, you have collected the LON-SRV2 adapter information needed for a DHCP reservation.
:::

### Task 8: Create a DHCP Reservation for LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV1**.

3. [ ] In **DHCP Manager**, expand **IPv4**.

4. [ ] Expand **Contoso Lab Scope**.

5. [ ] Right-click **Reservations**.

6. [ ] Select **New Reservation...**.

7. [ ] In **Reservation name**, enter `LON-SRV2`.

8. [ ] In **IP address**, enter the reservation address approved by your instructor.

9. [ ] In **MAC address**, enter the physical address you recorded from LON-SRV2 without hyphens.

10. [ ] In **Description**, enter `Reserved address for LON-SRV2`.

11. [ ] Under **Supported types**, verify that **Both** is selected.

12. [ ] Select **Add**.

13. [ ] Select **Close**.

14. [ ] Select **Reservations** and verify that the LON-SRV2 reservation appears.

   ::: warning
   **Note**: A reservation ensures a specific device receives the same IP address from DHCP. In production, reservations are useful for devices that should be centrally managed but still need predictable addressing.
   :::

::: success
**Results**: After completing this exercise, you have created a controlled DHCP scope and a reservation for LON-SRV2.
:::

## Exercise 6: Review DHCP and DNS Operational Status

::: secondary
**Scenario**

After adding DNS records and configuring DHCP, you need to review the operational status and confirm that the services are healthy.
:::

### Task 1: Review DHCP Server Status in DHCP Manager

1. [ ] On LON-SRV1, in **DHCP Manager**, select **lon-srv1.contoso.com**.

2. [ ] Review the server icon and verify that it does not show an error indicator.

3. [ ] Expand **IPv4**.

4. [ ] Select **Contoso Lab Scope**.

5. [ ] Review **Address Pool**, **Address Leases**, **Reservations**, and **Scope Options**.

6. [ ] Verify that the scope is still inactive unless your instructor specifically told you to activate it.

::: success
**Results**: After completing this task, you have reviewed the DHCP scope and confirmed its current activation state.
:::

### Task 2: Review DHCP Events

1. [ ] On LON-SRV1, open **Server Manager**.

2. [ ] Select **Tools**.

3. [ ] Select **Event Viewer**.

4. [ ] In **Event Viewer**, expand **Applications and Services Logs**.

5. [ ] Expand **Microsoft**.

6. [ ] Expand **Windows**.

7. [ ] Expand **DHCP-Server**.

8. [ ] Select **Microsoft-Windows-DHCP Server Events/Operational** if it appears.

9. [ ] Review recent DHCP events.

10. [ ] Look for events related to authorization, service startup, or scope configuration.

   ::: warning
   **Note**: Event Viewer is useful when a DHCP server is installed but clients are not receiving addresses. Authorization, service startup, and scope state are common items to check first.
   :::

::: success
**Results**: After completing this task, you have reviewed DHCP operational events on LON-SRV1.
:::

### Task 3: Review DNS Server Events

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] Open **Server Manager**.

4. [ ] Select **Tools**.

5. [ ] Select **Event Viewer**.

6. [ ] In **Event Viewer**, expand **Windows Logs**.

7. [ ] Select **DNS Server**.

8. [ ] Review recent DNS service events.

9. [ ] If **DNS Server** is not listed under **Windows Logs**, expand **Applications and Services Logs** > **Microsoft** > **Windows** > **DNS-Server**.

10. [ ] Select **Operational** if it is available.

11. [ ] Review recent DNS operational events.

::: success
**Results**: After completing this task, you have reviewed DNS operational events on LON-DC1.
:::

### Task 4: Confirm DNS Results Again from LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Open **Microsoft Edge**.

4. [ ] Go to `http://intranet.contoso.com`.

5. [ ] Verify that the site hosted on LON-SRV1 still loads.

6. [ ] Go to `http://web.contoso.com`.

7. [ ] Verify that the alias still reaches the same site.

::: success
**Results**: After completing this exercise, you have reviewed DHCP and DNS operational status across all three lab servers.
:::

## Exercise 7: Perform Controlled DNS Troubleshooting

::: secondary
**Scenario**

Administrators often need to diagnose name resolution problems. You will temporarily create a DNS issue, observe the failure from LON-SRV2, and then restore the correct record.
:::

### Task 1: Temporarily Change the Web Alias Target

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] In **DNS Manager**, expand **LON-DC1**.

4. [ ] Expand **Forward Lookup Zones**.

5. [ ] Select **contoso.com**.

6. [ ] In the center pane, double-click the **web** CNAME record.

7. [ ] Record the current value in **Fully qualified domain name (FQDN) for target host**.

8. [ ] Change **Fully qualified domain name (FQDN) for target host** to `missing.contoso.com`.

9. [ ] Select **OK**.

   ::: warning
   **Note**: This change intentionally breaks the alias for troubleshooting practice. You will restore the original value later in this exercise.
   :::

::: success
**Results**: After completing this task, the web.contoso.com alias points to a name that should not resolve.
:::

### Task 2: Observe the DNS Failure from LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] Open **Terminal** as administrator.

4. [ ] Run the following command to clear the local DNS cache:

```powershell
Clear-DnsClientCache
```

5. [ ] Open **Microsoft Edge**.

6. [ ] Go to `http://web.contoso.com`.

7. [ ] Verify that the page does not load as expected.

8. [ ] Return to **Terminal**.

9. [ ] Run the following command:

```powershell
Resolve-DnsName web.contoso.com
```

10. [ ] Review the result and notice that the alias points to `missing.contoso.com`.

::: success
**Results**: After completing this task, you have observed how an incorrect DNS alias affects access from another server.
:::

### Task 3: Restore the Web Alias

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-DC1**.

3. [ ] In **DNS Manager**, select **Forward Lookup Zones** > **contoso.com**.

4. [ ] In the center pane, double-click the **web** CNAME record.

5. [ ] Change **Fully qualified domain name (FQDN) for target host** back to `intranet.contoso.com`.

6. [ ] Select **OK**.

7. [ ] Verify that the **web** alias shows the corrected target in the center pane.

::: success
**Results**: After completing this task, you have restored the web.contoso.com alias to the correct target.
:::

### Task 4: Confirm Recovery from LON-SRV2

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SRV2**.

3. [ ] In **Terminal**, run the following command:

```powershell
Clear-DnsClientCache
```

4. [ ] In **Microsoft Edge**, go to `http://web.contoso.com`.

5. [ ] Verify that the site hosted on LON-SRV1 loads again.

::: success
**Results**: After completing this exercise, you have diagnosed and corrected a DNS alias problem by using DNS Manager and validation from LON-SRV2.
:::

## Exercise 8: Review the Administrative Change Summary

::: secondary
**Scenario**

You need to summarize the administrative changes made during the lab so another administrator can understand what was configured and what still requires production review.
:::

### Task 1: Review DNS Changes

1. [ ] On LON-DC1, open **DNS Manager**.

2. [ ] Select **Forward Lookup Zones** > **contoso.com**.

3. [ ] Verify that the **intranet** A record exists.

4. [ ] Verify that the **web** CNAME record exists and points to `intranet.contoso.com`.

5. [ ] Select the reverse lookup zone created in this lab.

6. [ ] Verify that the PTR record for LON-SRV1 exists.

::: success
**Results**: After completing this task, you have reviewed the DNS records created in this lab.
:::

### Task 2: Review DHCP Changes

1. [ ] On LON-SRV1, open **DHCP Manager**.

2. [ ] Expand **lon-srv1.contoso.com**.

3. [ ] Expand **IPv4**.

4. [ ] Select **Contoso Lab Scope**.

5. [ ] Review the configured **Address Pool**.

6. [ ] Review **Scope Options** and verify that DNS settings point clients to LON-DC1.

7. [ ] Review **Reservations** and verify that the LON-SRV2 reservation exists.

8. [ ] Verify that the scope is inactive unless your instructor specifically directed you to activate it.

::: success
**Results**: After completing this task, you have reviewed the DHCP configuration created in this lab.
:::

### Task 3: Review Security and Production Considerations

1. [ ] Confirm that DHCP authorization was completed for LON-SRV1.

2. [ ] Confirm that the DHCP scope remains inactive until the address range is approved.

3. [ ] Confirm that DNS records use service names that are clear and easy to support.

4. [ ] Confirm that the reverse lookup zone matches the correct lab subnet.

5. [ ] Note that production DHCP scopes should include documented exclusions for servers, routers, printers, and infrastructure devices.

6. [ ] Note that production DNS changes should follow naming standards and change control.

::: success
**Results**: After completing this exercise, you have reviewed the DNS, DHCP, and security impact of the administrative changes made in this lab.
:::
