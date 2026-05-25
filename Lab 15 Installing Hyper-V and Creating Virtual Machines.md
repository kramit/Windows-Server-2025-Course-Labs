# Practice Lab 1501: Installing Hyper-V and Creating Virtual Machines

## Summary

::: secondary
In this lab, you will install the Hyper-V role on your Windows Server and create a virtual machine. You will understand virtual networking and storage configuration for VMs.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0501 (Installing Server Roles and Managing Firewall)
- Administrator access to LON-SVR1
- Understanding of virtual machine concepts (basic)
- Sufficient disk space (at least 10 GB free)
:::

## Exercise 1: Installing Hyper-V

::: secondary
**Scenario**

You need to install the Hyper-V virtualization role on your server. This enables you to create and manage virtual machines.
:::

### Task 1: Install Hyper-V Role

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

4. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Open **Server Manager**.

7. [ ] Click **Manage** > **Add Roles and Features**.

8. [ ] Follow the wizard to the **Server Roles** page.

9. [ ] Look for **Hyper-V** in the roles list and check the box next to it.

10. [ ] A dialog will appear asking to add required features. Click **Add Features**.

11. [ ] Continue through the wizard to **Confirmation** page.

12. [ ] Click **Install** to install Hyper-V.

13. [ ] Installation may take 5-10 minutes. Wait for completion.

14. [ ] You will be prompted to restart the server. Click **Restart Now** or schedule the restart.

   ::: warning
   **Note**: The server MUST restart to complete Hyper-V installation. Save all work before restarting.
   :::

### Task 2: Verify Hyper-V Installation

After restart, verify Hyper-V is installed:

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] Sign in by using the **Username** and **Password** values shown for **LON-SVR1** if prompted.

4. [ ] Wait for the Windows Server desktop to appear.

5. [ ] Open **Server Manager**.

6. [ ] Click on **Hyper-V** in the left panel if it is available.

7. [ ] If **Hyper-V** is not available in the left panel, open **Tools** > **Hyper-V Manager**.

8. [ ] Verify that **Hyper-V Manager** opens and shows your server.

9. [ ] Confirm that you can now create and manage virtual machines.

::: success
**Results**: After completing this task, Hyper-V is installed and ready to use.
:::

## Exercise 2: Creating a Virtual Machine

::: secondary
**Scenario**

You will create a new virtual machine with basic configuration. This VM will be used for testing purposes.
:::

### Task 1: Open Hyper-V Manager

1. [ ] In Server Manager, click **Tools** > **Hyper-V Manager**.

2. [ ] Hyper-V Manager will open showing:
   - Left panel: Server name (LON-SVR1)
   - Middle panel: Actions and tasks
   - Right panel: Virtual machines (currently empty)

::: success
**Results**: After completing this task, Hyper-V Manager is open and ready.
:::

### Task 2: Create New Virtual Machine

1. [ ] In Hyper-V Manager, on the right panel, click **New** > **Virtual Machine**.

2. [ ] The **New Virtual Machine Wizard** will open.

3. [ ] Click **Next >** on the **Before You Begin** page.

4. [ ] On the **Specify Name and Location** page:
   - **Name**: Type `TestVM`
   - **Store the virtual machine in a different location**: Leave unchecked

5. [ ] Click **Next >**.

6. [ ] On the **Specify Generation** page:
   - Select **Generation 2** (newer, better security)

7. [ ] Click **Next >**.

### Task 3: Configure Memory

1. [ ] On the **Assign Memory** page:
   - **Startup memory**: Type `1024` (1 GB)
   - **Enable Dynamic Memory**: Check this box (allows VM to adjust memory use)

2. [ ] Click **Next >**.

### Task 4: Configure Network

1. [ ] On the **Configure Networking** page:
   - **Connection**: Select **Default Switch** (or ask instructor for network configuration)
   - This allows the VM to connect to the network

2. [ ] Click **Next >**.

### Task 5: Create Virtual Disk

1. [ ] On the **Connect Virtual Hard Disk** page:
   - **Create a virtual hard disk**: Should be selected
   - **Size**: Type `20` (20 GB for the VM disk)

2. [ ] Click **Next >**.

### Task 6: Installation Options

1. [ ] On the **Installation Options** page:
   - **Install an operating system from a boot CD/DVD-ROM**: Would require Windows Server installation media
   - **Install an operating system from a bootable floppy disk**: Not typically used
   - Leave blank for now (we won't install an OS in this lab)

2. [ ] Click **Next >**.

### Task 7: Complete Creation

1. [ ] Review the summary page.

2. [ ] Click **Finish** to create the virtual machine.

3. [ ] The VM **TestVM** will appear in the Hyper-V Manager list.

4. [ ] It shows **State: Off** (not running yet).

::: success
**Results**: After completing this task, you have created a virtual machine.
:::

## Exercise 3: Managing Virtual Machines

::: secondary
**Scenario**

You will learn how to start, stop, and manage the virtual machine you created.
:::

### Task 1: Start the Virtual Machine

1. [ ] In Hyper-V Manager, right-click on **TestVM**.

2. [ ] Click **Connect** to open a console window to the VM.

3. [ ] A console window will open. The VM is powered off (black screen).

4. [ ] Right-click on **TestVM** again and click **Start**.

5. [ ] The VM will power on. You will see boot sequence in the console window.

6. [ ] Since no OS is installed, the VM will boot from the network or show a boot error, which is normal for this lab.

::: success
**Results**: After completing this task, you have started the virtual machine.
:::

### Task 2: Stop the Virtual Machine

1. [ ] Right-click on **TestVM**.

2. [ ] Click **Turn Off...** or **Shut Down**.

3. [ ] The VM will power off.

4. [ ] The State column will change to **Off**.

   ::: warning
   **Note**: "Turn Off" is like pulling the power cord. "Shut Down" gracefully shuts down the OS (only works if OS is running). In this case, Turn Off is fine.
   :::

::: success
**Results**: After completing this task, you have stopped the virtual machine.
:::

## Exercise 4: Understanding Hyper-V Networking

::: secondary
**Scenario**

Virtual machines need network connectivity. You will understand Hyper-V virtual network types.
:::

### Task 1: Review Virtual Network Types

Hyper-V supports three virtual switch types:

1. **External Switch**:
   - Connects VMs to physical network
   - VMs can communicate with other computers
   - Use when VMs need full network access

2. **Internal Switch**:
   - Connects VMs to each other and host
   - No access to physical network
   - Use for private VM-to-VM communication

3. **Private Switch**:
   - Connects VMs only to each other
   - No host access, no external access
   - Most isolated option

The **Default Switch** used in the lab is an internal switch managed automatically.

::: success
**Results**: After completing this task, you understand virtual network types.
:::

## Exercise 5: Understanding Hyper-V Storage

::: secondary
**Scenario**

Virtual machines require storage for their disks. You will understand storage options.
:::

### Task 1: Virtual Disk Types

Hyper-V supports different virtual disk types:

| Type | Description | Use Case |
|------|-------------|----------|
| **VHDX** | Modern format, larger files, newer features | Recommended for new VMs |
| **VHD** | Older format, smaller file size limit (2 TB) | Legacy VMs |

Virtual disk allocation methods:

| Method | Description |
|--------|-------------|
| **Dynamically Expanding** | Grows as data is added (starts small) |
| **Fixed Size** | Allocates full size immediately (faster performance) |

For the lab, the TestVM uses a dynamically expanding VHDX disk (20 GB maximum).

::: success
**Results**: After completing this task, you understand virtual disk types.
:::

## Exercise 6: Hyper-V Management with PowerShell

::: secondary
**Scenario**

PowerShell can manage Hyper-V at scale using commands and scripts.
:::

### Task 1: List Virtual Machines

1. [ ] Open PowerShell as Administrator.

2. [ ] Type the following command:

```powershell
Get-VM | Select-Object Name, State, MemoryAssigned, Uptime | Format-Table
```

3. [ ] Press **Enter**.

4. [ ] PowerShell will list all virtual machines:
   - **Name**: VM name (TestVM)
   - **State**: Running or Off
   - **MemoryAssigned**: Memory allocated
   - **Uptime**: How long it's been running

::: success
**Results**: After completing this task, you can manage VMs with PowerShell.
:::

## Exercise 7: Verification and Summary

::: secondary
**Scenario**

You have successfully installed Hyper-V and created a virtual machine.
:::

### Task 1: Hyper-V Checklist

Verify the following are complete:

1. ✓ Hyper-V role is installed
2. ✓ Hyper-V Manager opens successfully
3. ✓ TestVM virtual machine was created
4. ✓ VM can be started and stopped
5. ✓ Virtual disk was created
6. ✓ Network configuration understood
7. ✓ PowerShell VM management works

::: success
**Results**: You have successfully completed Lab 1501. You now understand:
- How to install Hyper-V role
- How to create virtual machines
- How to manage VM lifecycle (start, stop)
- Virtual networking options
- Virtual storage types
- How to manage VMs with PowerShell

Hyper-V enables server consolidation, test environments, and infrastructure as code. In future labs, you will configure advanced Hyper-V features like high availability and live migration.
:::
