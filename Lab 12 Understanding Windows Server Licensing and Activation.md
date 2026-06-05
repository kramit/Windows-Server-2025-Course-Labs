# Practice Lab 1201: Understanding Windows Server Licensing and Activation

## Summary

::: secondary
In this lab, you will review Windows Server licensing models, check your current license status, and understand activation. You will verify the activation state of **LON-SVR1** and connect what you see in Windows Server 2025 to Microsoft licensing and activation guidance.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Administrator access to LON-SVR1
- Understanding of licensing concepts (basic)
:::

::: secondary
**Microsoft references**

- [Select Windows Server editions, servicing options, and activation](https://learn.microsoft.com/en-us/training/modules/select-windows-server-editions-servicing-options-activation/)
- [Slmgr.vbs options for obtaining volume activation information](https://learn.microsoft.com/en-us/windows-server/get-started/activation-slmgr-vbs-options)
- [Key Management Services (KMS) activation planning](https://learn.microsoft.com/en-us/windows-server/get-started/kms-activation-planning)
- [Azure Hybrid Benefit for Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit)
- [Windows Server 2025 licensing guidance](https://www.microsoft.com/licensing/guidance/Windows-Server-2025)
- [Microsoft licensing documents for Windows Server](https://www.microsoft.com/licensing/docs/view/Windows-Server)
:::

## Exercise 1: Checking Current License Status

::: secondary
**Scenario**

You need to verify that your Windows Server is properly licensed and activated. You will check the current license status.
:::

### Task 1: Check License Status in Settings

::: secondary
Microsoft Learn introduces Windows Server edition selection, servicing, licensing, and activation in [Select Windows Server editions, servicing options, and activation](https://learn.microsoft.com/en-us/training/modules/select-windows-server-editions-servicing-options-activation/).
:::

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** and **Password** values shown for **LON-SVR1** on the **HOME** tab.

5. [ ] Wait for the Windows Server desktop to appear.

6. [ ] Right-click the **Start** button and select **Settings**.

7. [ ] In the search box, type **Activation** and press **Enter**.

8. [ ] Select **Activation** in the results.

9. [ ] Review the information shown on the **Activation** page. Depending on the lab image and activation method, you may see:
   - **Activation status**: Windows is activated (or not activated)
   - **Edition**: Windows Server 2025 Standard or Windows Server 2025 Datacenter
   - **Product ID**: The unique identifier for this installation
   - **License expires**: If the installation uses a time-limited or evaluation license

10. [ ] Look for a message stating **Windows is activated** or **You need to activate Windows**.

11. [ ] Record the activation status and edition in your lab notes.

::: success
**Results**: After completing this task, you know the current license status of your server.
:::

### Task 2: Check License Status via PowerShell

::: secondary
Microsoft documents `slmgr.vbs` as a command-line tool for checking activation and licensing status in [Slmgr.vbs options for obtaining volume activation information](https://learn.microsoft.com/en-us/windows-server/get-started/activation-slmgr-vbs-options).
:::

1. [ ] Select **Start**, type **PowerShell**, right-click **Windows PowerShell**, and select **Run as administrator**.

2. [ ] Type the following command:

```powershell
Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object {$_.PartialProductKey} | Select-Object Description, LicenseStatus, LicenseStatusReason | Format-Table
```

3. [ ] Press **Enter**.

4. [ ] PowerShell will display license information:
   - **Description**: Windows Server 2025 (edition)
   - **LicenseStatus**: 1 (activated) or 0 (not activated)
   - **LicenseStatusReason**: Activation reason

5. [ ] Type the following command:

```powershell
slmgr.vbs /dli
```

6. [ ] Review the **License Status** and **Partial Product Key** values in the **Windows Script Host** dialog box, and then select **OK**.

::: success
**Results**: After completing this task, you can check license status by using PowerShell and the Windows licensing script.
:::

## Exercise 2: Understanding Windows Server Editions

::: secondary
**Scenario**

Windows Server comes in different editions with different capabilities and pricing. You will understand the differences.
:::

### Task 1: Review Server Edition

::: secondary
For edition planning, review the Microsoft Learn module [Select Windows Server editions, servicing options, and activation](https://learn.microsoft.com/en-us/training/modules/select-windows-server-editions-servicing-options-activation/) and the official [Windows Server 2025 licensing guidance](https://www.microsoft.com/licensing/guidance/Windows-Server-2025).
:::

Your server is running **Windows Server 2025**. The main editions are:

| Edition | Use Case | Licensing |
|---------|----------|-----------|
| **Standard** | General purpose servers and low-density virtualization | Core-based licensing plus appropriate Client Access Licenses (CALs) |
| **Datacenter** | Highly virtualized and software-defined datacenter environments | Core-based licensing plus appropriate CALs |
| **Essentials** | Small business first-server scenarios, up to 25 users and 50 devices | OEM-only server license |

1. [ ] Check which edition is installed by checking the activation status screen from Task 1.

2. [ ] Your server is likely **Standard** or **Datacenter** edition.

3. [ ] In your lab notes, write one sentence explaining why **Standard** is usually appropriate for a server with limited virtualization needs.

::: success
**Results**: After completing this task, you understand Windows Server editions.
:::

## Exercise 3: Understanding Licensing Models

::: secondary
**Scenario**

Windows Server has different licensing models. You should understand the main options.
:::

### Task 1: Review Licensing Models

| Model | Description |
|-------|-------------|
| **Core license** | Windows Server 2025 Standard and Datacenter are licensed by physical cores or, when eligible, by virtual machine cores |
| **User CAL** | A Client Access License assigned to a user who accesses Windows Server services |
| **Device CAL** | A Client Access License assigned to a device that accesses Windows Server services |
| **External Connector** | A license option for external users who access Windows Server services |
| **Azure Hybrid Benefit** | Uses qualifying Windows Server licenses with active Software Assurance or qualifying subscription licenses for reduced Azure costs |
| **Pay-as-you-go** | A cloud or Azure Arc-enabled option where Windows Server licensing cost is paid through the Azure subscription |

Most on-premises deployments of Windows Server 2025 Standard and Datacenter use **core-based licensing**. According to the official Windows Server 2025 licensing guidance, physical-core licensing requires all physical cores to be licensed, with minimums of 8 core licenses per physical processor and 16 core licenses per server. Core licenses are commonly sold in 2-packs and 16-packs.

::: secondary
For full licensing terms, always use your organization's Microsoft agreement and the [Microsoft Product Terms](https://www.microsoft.com/licensing/terms/productoffering/WindowsServer/all). The [Windows Server 2025 licensing guidance](https://www.microsoft.com/licensing/guidance/Windows-Server-2025) is an informational guide and does not replace the Product Terms.
:::

1. [ ] Review the licensing model table.

2. [ ] Identify whether each model licenses the server software, the users/devices accessing the server, or a cloud/hybrid usage right.

::: success
**Results**: After completing this task, you understand licensing models.
:::

## Exercise 4: Checking Windows Defender Licensing

::: secondary
**Scenario**

You should verify that security features are available under your current license.
:::

### Task 1: Verify Security Features

1. [ ] In the **Settings** window, select **Privacy & security**.

2. [ ] Select **Windows Security**.

3. [ ] Review the available security areas. Depending on the lab image, you may see:
   - **Virus & threat protection**: Active
   - **Firewall & network protection**: Active
   - **App & browser control**: Available
   - **Device performance & health**: Available

4. [ ] Select **Firewall & network protection**.

5. [ ] Verify that the domain network firewall is turned on.

6. [ ] Return to the main **Windows Security** page.

7. [ ] These built-in security features are part of Windows Server. Some advanced Microsoft Defender offerings, cloud security services, or management features may require separate licensing.

::: success
**Results**: After completing this task, you have verified security features are available.
:::

## Exercise 5: Understanding Volume Licensing

::: secondary
**Scenario**

Organizations with multiple servers use Volume Licensing to reduce costs.
:::

### Task 1: Volume Licensing Benefits

::: secondary
Use the [Microsoft licensing documents for Windows Server](https://www.microsoft.com/licensing/docs/view/Windows-Server) and [Windows Server 2025 licensing guidance](https://www.microsoft.com/licensing/guidance/Windows-Server-2025) when planning production licensing. For hybrid usage, review [Azure Hybrid Benefit for Windows Server](https://learn.microsoft.com/en-us/windows-server/get-started/azure-hybrid-benefit).
:::

Commercial Licensing can offer benefits such as:

1. **Centralized procurement** for Windows Server licenses, CALs, and related agreements
2. **Core license packs** for Windows Server Standard and Datacenter
3. **Software Assurance** benefits, when included in the agreement
4. **Version rights** while Software Assurance is active
5. **Azure Hybrid Benefit** eligibility when the licenses and agreement qualify
6. **Simplified license tracking** for compliance and renewal planning

Without a licensing program or agreement, each server and access license must still be acquired and tracked according to the terms under which it was purchased.

::: success
**Results**: After completing this task, you understand Volume Licensing benefits.
:::

### Task 2: Review Volume Activation Concepts

::: secondary
Microsoft Learn documents enterprise activation in [Key Management Services (KMS) activation planning](https://learn.microsoft.com/en-us/windows-server/get-started/kms-activation-planning), [KMS client activation and product keys](https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys), and [Guidelines for troubleshooting the Key Management Service (KMS)](https://learn.microsoft.com/en-us/windows-server/get-started/activation-troubleshoot-kms-general).
:::

1. [ ] Review the following common activation methods:
   - **Retail or OEM activation**: Activation tied to a retail key or hardware/vendor purchase
   - **Multiple Activation Key (MAK)**: A volume activation key used for a set number of activations
   - **Key Management Services (KMS)**: An internal activation service used by many organizations
   - **Automatic Virtual Machine Activation (AVMA)**: Activation for Windows Server virtual machines on a properly activated Hyper-V host

2. [ ] In the elevated PowerShell window, type the following command:

```powershell
slmgr.vbs /dlv
```

3. [ ] Review the detailed license information. Look for:
   - **Name**
   - **Description**
   - **License Status**
   - **Partial Product Key**
   - **Volume activation expiration**, if present

4. [ ] Select **OK** to close the **Windows Script Host** dialog box.

   ::: warning
   **Note**: Do not install or change product keys in this lab. The goal is to observe the current activation state, not to modify the lab image.
   :::

::: success
**Results**: After completing this task, you understand where activation details appear and which Microsoft Learn pages explain enterprise activation.
:::

## Exercise 6: Verification and Summary

::: secondary
**Scenario**

You have reviewed Windows Server licensing and verified your current status.
:::

### Task 1: License Compliance Checklist

Ensure your organization stays compliant:

1. [ ] Windows Server is activated.

2. [ ] The correct Windows Server edition is installed for the intended workload.

3. [ ] Sufficient core licenses are assigned for each Windows Server Standard or Datacenter deployment.

4. [ ] User CALs, Device CALs, External Connector licenses, or equivalent access licenses are assigned where required.

5. [ ] Remote Desktop Services CALs are tracked separately if users connect to full remote desktop sessions.

6. [ ] License records are maintained for audits and renewals.

7. [ ] Software Assurance or subscription terms are current where required for benefits such as Azure Hybrid Benefit or VM-based licensing.

8. [ ] Azure Hybrid Benefit is configured only for eligible workloads when using Azure.

9. [ ] Product Terms, agreement terms, and purchasing records are reviewed before production deployment.

### Task 2: Administrative Change Summary

No configuration changes were required in this lab unless you opened administrative tools to inspect the current state. You verified activation and licensing information, reviewed Windows Server 2025 edition and licensing concepts, and identified Microsoft references for production planning.

::: success
**Results**: You have successfully completed Lab 1201. You now understand:
- How to check Windows Server license status
- Different Windows Server editions and their use cases
- Licensing models, including core licensing, CALs, External Connector licensing, Azure Hybrid Benefit, and pay-as-you-go options
- Volume Licensing benefits
- Common volume activation concepts
- License compliance requirements

Proper licensing ensures your organization remains in compliance with Microsoft licensing agreements and avoids significant penalties for unlicensed software.
:::
