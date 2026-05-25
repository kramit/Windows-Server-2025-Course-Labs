# Practice Lab 1201: Understanding Windows Server Licensing and Activation

## Summary

::: secondary
In this lab, you will review Windows Server licensing models, check your current license status, and understand activation. You will verify that your server is properly licensed and activated.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Administrator access to LON-SVR1
- Understanding of licensing concepts (basic)
:::

## Exercise 1: Checking Current License Status

::: secondary
**Scenario**

You need to verify that your Windows Server is properly licensed and activated. You will check the current license status.
:::

### Task 1: Check License Status in Settings

1. [ ] Connect to LON-SVR1 using Remote Desktop.
2. [ ] Right-click the **Windows Start button** and select **Settings**.
3. [ ] In the search box, type **Activation** and press **Enter**.
4. [ ] Click on **Activation** in the results.
5. [ ] You will see the current license status:
   - **Activation status**: Windows is activated (or not activated)
   - **Edition**: Windows Server 2025
   - **Product ID**: The unique identifier for this installation
   - **License expires**: (if using a time-limited license)
6. [ ] Look for a message stating **"Windows is activated"** or **"You need to activate Windows"**
7. [ ] If activated, you will see a date like "Windows will never expire" or a specific expiration date.

::: success
**Results**: After completing this task, you know the current license status of your server.
:::

### Task 2: Check License Status via PowerShell

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command:

```powershell
Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object {$_.PartialProductKey} | Select-Object Description, LicenseStatus, LicenseStatusReason | Format-Table
```

3. [ ] Press **Enter**.
4. [ ] PowerShell will display license information:
   - **Description**: Windows Server 2025 (edition)
   - **LicenseStatus**: 1 (activated) or 0 (not activated)
   - **LicenseStatusReason**: Activation reason

::: success
**Results**: After completing this task, you can check license status using PowerShell.
:::

## Exercise 2: Understanding Windows Server Editions

::: secondary
**Scenario**

Windows Server comes in different editions with different capabilities and pricing. You will understand the differences.
:::

### Task 1: Review Server Edition

Your server is running **Windows Server 2025**. The main editions are:

| Edition | Use Case | Licensing |
|---------|----------|-----------|
| **Standard** | General purpose, up to 2 processors | Licensed per 2-processor pack |
| **Datacenter** | Virtualization-heavy, unlimited VMs | Licensed per 2-processor pack |
| **Essentials** | Small business (max 25 users, 50 devices) | Per-server license |

1. [ ] Check which edition is installed by checking the activation status screen from Task 1.
2. [ ] Your server is likely **Standard** or **Datacenter** edition.

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
| **Device CAL** | Per-device license (each computer needs a CAL) |
| **User CAL** | Per-user license (each user needs a CAL) |
| **Processor License** | Based on server processors (2-processor packs) |
| **Azure Hybrid Benefit** | License mobility from on-premises to Azure |
| **Pay-as-you-go** | Running on Azure, pay hourly |

Most on-premises deployments use **Processor Licensing** where you purchase licenses in 2-processor packs.

::: success
**Results**: After completing this task, you understand licensing models.
:::

## Exercise 4: Checking Windows Defender Licensing

::: secondary
**Scenario**

You should verify that security features are available under your current license.
:::

### Task 1: Verify Security Features

1. [ ] In the Settings window, click **Windows Security** or **Windows Defender Security**.
2. [ ] You should see:
   - **Virus & threat protection**: Active
   - **Firewall & network protection**: Active
   - **App & browser control**: Available
   - **Device performance & health**: Available
3. [ ] These security features are included with all Windows Server editions.

::: success
**Results**: After completing this task, you have verified security features are available.
:::

## Exercise 5: Understanding Volume Licensing

::: secondary
**Scenario**

Organizations with multiple servers use Volume Licensing to reduce costs.
:::

### Task 1: Volume Licensing Benefits

If your organization has 5 or more servers, **Volume Licensing** offers benefits such as:

1. **Discounted pricing** per 2-processor pack
2. **Flexible deployment** across different servers
3. **License portability** (move licenses between servers)
4. **Software Assurance** (SA) benefits including:
   - Free upgrades to newer versions
   - Azure Hybrid Benefit (run on-premises OR Azure)
5. **Simplified reporting** and tracking

Without Volume Licensing, each server needs its own license purchased separately at higher cost.

::: success
**Results**: After completing this task, you understand Volume Licensing benefits.
:::

## Exercise 6: Verification and Summary

::: secondary
**Scenario**

You have reviewed Windows Server licensing and verified your current status.
:::

### Task 1: License Compliance Checklist

Ensure your organization stays compliant:

1. ✓ Windows Server is activated
2. ✓ Correct edition is installed for intended use
3. ✓ Sufficient licenses purchased for all servers
4. ✓ CALs purchased for users/devices accessing the server
5. ✓ License tracking maintained for audits
6. ✓ Volume Licensing agreements current (if applicable)
7. ✓ Azure Hybrid Benefit configured (if using Azure)

::: success
**Results**: You have successfully completed Lab 1201. You now understand:
- How to check Windows Server license status
- Different Windows Server editions and their use cases
- Licensing models (Device CAL, User CAL, Processor)
- Volume Licensing benefits
- License compliance requirements

Proper licensing ensures your organization remains in compliance with Microsoft licensing agreements and avoids significant penalties for unlicensed software.
:::
