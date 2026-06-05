# Practice Lab 0401: PowerShell Command-Line Administration

## Summary

::: secondary
In this lab, you will use PowerShell to perform common Windows Server administration tasks. You will run cmdlets, use help, pipe and filter command output, gather system information, review services and processes, customize the terminal prompt with Oh My Posh, practice scripting logic, export objects, and create a basic graphical interface.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0201 (Using Remote Administration Tools and PowerShell)
- Completed Lab 0301 (Working with Git and GitHub)
- Administrator access to LON-SVR1
- Basic familiarity with Server Manager and elevated PowerShell sessions
- Internet access for installing Visual Studio Code and Oh My Posh
:::

::: warning
**Note**: The PowerShell examples used in this lab are also provided in the course GitHub repository folder `supporting content/Lab4`. If time is limited, open the prepared scripts instead of typing each script manually.
:::

## Exercise 1: Opening PowerShell and Running Basic Cmdlets

::: secondary
**Scenario**

You need to use PowerShell as your primary command-line administration tool. You will connect to LON-SVR1, open an elevated PowerShell session, verify the PowerShell version, and run your first cmdlets.
:::

### Task 1: Connect to LON-SVR1

1. [ ] In the lab environment, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode**.

4. [ ] In the **Username** field, enter the username shown for the selected VM on the **HOME** tab.

5. [ ] In the **Password** field, enter the password shown for the selected VM on the **HOME** tab.

6. [ ] Verify that the virtual machine display adjusts to use the best screen resolution for your monitor.

7. [ ] Wait for the Windows Server desktop to load.

### Task 2: Open PowerShell as Administrator

1. [ ] Open **Start**.

2. [ ] Search for **Terminal**.

3. [ ] Select **Run as administrator** for **Terminal**.

4. [ ] If prompted by **User Account Control**, select **Yes**.

5. [ ] Verify that an elevated PowerShell session opens.

   ::: warning
   **Note**: If **Terminal** is not available, search for **Windows PowerShell** and select **Run as administrator**.
   :::

### Task 3: Check the PowerShell Version

1. [ ] Run the following command to display the PowerShell version.

```powershell
$PSVersionTable.PSVersion
```

2. [ ] Verify that the version output is displayed.

3. [ ] Record the **Major** and **Minor** version values if instructed by your instructor.

### Task 4: Run Basic Cmdlets

1. [ ] Run the following command to list the contents of the current folder.

```powershell
Get-ChildItem
```

2. [ ] Review the **Mode**, **LastWriteTime**, **Length**, and **Name** columns.

3. [ ] Run the following command to display the current location.

```powershell
Get-Location
```

4. [ ] Verify that PowerShell displays the current path.

::: success
**Results**: After completing this exercise, you will have opened an elevated PowerShell session and run basic PowerShell cmdlets on LON-SVR1.
:::

## Exercise 2: Using PowerShell Help and Command Discovery

::: secondary
**Scenario**

You need to find and understand PowerShell commands without memorizing every cmdlet. You will use PowerShell help, command discovery, and aliases to identify useful administration commands.
:::

### Task 1: Use Help for a Cmdlet

1. [ ] Run the following command to display help for `Get-ChildItem`.

```powershell
Get-Help Get-ChildItem
```

2. [ ] Review the **SYNOPSIS** section.

3. [ ] Review the **SYNTAX** section.

4. [ ] Run the following command to display examples for `Get-ChildItem`.

```powershell
Get-Help Get-ChildItem -Examples
```

5. [ ] Review at least one example.

   ::: warning
   **Note**: If full help content is not available, PowerShell may display partial help. Do not run `Update-Help` unless instructed.
   :::

### Task 2: Discover Commands

1. [ ] Run the following command to find commands that use the verb `Get`.

```powershell
Get-Command -Verb Get | Select-Object -First 20 Name, Source
```

2. [ ] Review the command names returned.

3. [ ] Run the following command to find commands related to services.

```powershell
Get-Command -Noun Service
```

4. [ ] Verify that service-related cmdlets are displayed.

### Task 3: Review Aliases

1. [ ] Run the following command to display common aliases.

```powershell
Get-Alias | Select-Object Name, Definition | Sort-Object Name | Format-Table -AutoSize
```

2. [ ] Locate the alias **dir**.

3. [ ] Verify that **dir** maps to `Get-ChildItem`.

4. [ ] Locate the alias **cls**.

5. [ ] Verify that **cls** maps to `Clear-Host`.

::: success
**Results**: After completing this exercise, you will have used PowerShell help, command discovery, and aliases to identify command-line administration options.
:::

## Exercise 3: Gathering System Information

::: secondary
**Scenario**

You need to gather server inventory information quickly from the command line. You will use PowerShell to retrieve computer, operating system, update, and network configuration details.
:::

### Task 1: Get Computer Information

1. [ ] Run the following command to display basic computer information.

```powershell
Get-ComputerInfo -Property CsComputerName,CsDomain,OsVersion,OsProductType
```

2. [ ] Verify that **CsComputerName** shows `LON-SVR1`.

3. [ ] Verify that **CsDomain** shows `CONTOSO`.

4. [ ] Review the **OsVersion** and **OsProductType** values.

### Task 2: Get Operating System Information

1. [ ] Run the following command to display operating system information.

```powershell
Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber,InstallDate
```

2. [ ] Verify that **Caption** displays Windows Server.

3. [ ] Review the **Version**, **BuildNumber**, and **InstallDate** values.

### Task 3: View Installed Updates

1. [ ] Run the following command to display recent installed updates.

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending | Select-Object -First 10 HotFixID,Description,InstalledOn | Format-Table -AutoSize
```

2. [ ] Review the **HotFixID**, **Description**, and **InstalledOn** columns.

3. [ ] Verify whether any updates are listed.

   ::: warning
   **Note**: A freshly created lab server may show few or no installed hotfixes.
   :::

### Task 4: View IP Configuration

1. [ ] Run the following command to display IPv4 address information.

```powershell
Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias,IPAddress,PrefixLength | Format-Table -AutoSize
```

2. [ ] Review the **InterfaceAlias**, **IPAddress**, and **PrefixLength** values.

3. [ ] Identify the IPv4 address used by LON-SVR1.

::: success
**Results**: After completing this exercise, you will have gathered key system, update, and network information from LON-SVR1 by using PowerShell.
:::

## Exercise 4: Filtering, Sorting, and Formatting Output

::: secondary
**Scenario**

PowerShell commands often return more information than you need. You will use the pipeline to filter, sort, select, and format command output for administrative review.
:::

### Task 1: Filter Running Services

1. [ ] Run the following command to display running services.

```powershell
Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name,DisplayName,Status | Format-Table -AutoSize
```

2. [ ] Verify that each listed service has a **Status** value of `Running`.

3. [ ] Review the **Name** and **DisplayName** columns.

### Task 2: Check a Specific Service

1. [ ] Run the following command to display the DNS Client service.

```powershell
Get-Service -Name Dnscache | Select-Object Name,DisplayName,Status,StartType
```

2. [ ] Verify that **DisplayName** shows `DNS Client`.

3. [ ] Review the **Status** and **StartType** values.

### Task 3: Sort Processes by Memory Use

1. [ ] Run the following command to display the five processes using the most memory.

```powershell
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 5 Name,Id,@{Name='MemoryMB';Expression={[math]::Round($_.WorkingSet / 1MB, 2)}} | Format-Table -AutoSize
```

2. [ ] Review the **Name**, **Id**, and **MemoryMB** values.

3. [ ] Identify the process currently using the most memory.

### Task 4: Export Output to a File

1. [ ] Run the following command to create a folder for lab output.

```powershell
New-Item -Path C:\LabOutput -ItemType Directory -Force
```

2. [ ] Run the following command to export running services to a CSV file.

```powershell
Get-Service | Where-Object { $_.Status -eq 'Running' } | Select-Object Name,DisplayName,Status | Export-Csv -Path C:\LabOutput\RunningServices.csv -NoTypeInformation
```

3. [ ] Run the following command to verify that the file was created.

```powershell
Test-Path C:\LabOutput\RunningServices.csv
```

4. [ ] Verify that the command returns `True`.

::: success
**Results**: After completing this exercise, you will have filtered, sorted, formatted, and exported PowerShell command output.
:::

## Exercise 5: Reviewing Services and Processes Safely

::: secondary
**Scenario**

You need to inspect services and processes without making disruptive changes. You will review stopped services, inspect process details, and avoid changing service state in this foundational lab.
:::

### Task 1: View Stopped Services

1. [ ] Run the following command to display stopped services.

```powershell
Get-Service | Where-Object { $_.Status -eq 'Stopped' } | Select-Object Name,DisplayName,StartType | Format-Table -AutoSize
```

2. [ ] Review the stopped services returned.

3. [ ] Identify at least one service with a **StartType** value of `Manual`.

   ::: warning
   **Note**: Do not start, stop, or restart services in this lab unless your instructor specifically tells you to do so.
   :::

### Task 2: View Process Details

1. [ ] Run the following command to display process details.

```powershell
Get-Process | Select-Object -First 15 Name,Id,Handles,CPU,WorkingSet | Format-Table -AutoSize
```

2. [ ] Review the **Name**, **Id**, **Handles**, **CPU**, and **WorkingSet** columns.

3. [ ] Identify the process ID for one listed process.

### Task 3: Search for a Process by Name

1. [ ] Run the following command to search for PowerShell-related processes.

```powershell
Get-Process | Where-Object { $_.Name -like '*powershell*' -or $_.Name -like '*pwsh*' -or $_.Name -like '*terminal*' } | Select-Object Name,Id,StartTime
```

2. [ ] Verify whether a PowerShell or Terminal process is displayed.

3. [ ] Review the **Name**, **Id**, and **StartTime** values.

::: success
**Results**: After completing this exercise, you will have reviewed services and processes safely without changing their running state.
:::

## Exercise 6: Installing Visual Studio Code and Running PowerShell Scripts

::: secondary
**Scenario**

You need a script editor for writing and testing PowerShell scripts. You will install Visual Studio Code with winget, add the PowerShell extension, write a basic FizzBuzz script, and run a prepared system information script that exports an HTML report.
:::

### Task 1: Install Visual Studio Code with winget

1. [ ] Return to the elevated PowerShell session on LON-SVR1.

2. [ ] Run the following command to verify that winget is available.

```powershell
winget --version
```

3. [ ] Verify that a winget version is displayed.

4. [ ] Run the following command to install Visual Studio Code.

```powershell
winget install --id Microsoft.VisualStudioCode --exact --source winget --accept-package-agreements --accept-source-agreements
```

5. [ ] Wait for the installation to finish.

6. [ ] Open **Start**.

7. [ ] Search for **Visual Studio Code**.

8. [ ] Open **Visual Studio Code**.

9. [ ] If prompted by the first-run experience, select the options required by your instructor.

   ::: warning
   **Note**: If winget is not available or the download is blocked, ask your instructor for the approved Visual Studio Code installer location.
   :::

### Task 2: Install the PowerShell Extension

1. [ ] Return to the elevated PowerShell session.

2. [ ] Run the following command to install the PowerShell extension for Visual Studio Code.

```powershell
code --install-extension ms-vscode.PowerShell
```

3. [ ] Wait for the extension installation to finish.

4. [ ] In **Visual Studio Code**, select **Extensions**.

5. [ ] Search for **PowerShell**.

6. [ ] Verify that the **PowerShell** extension from **Microsoft** is installed.

   ::: warning
   **Note**: If the `code` command is not recognized, close and reopen PowerShell, then run the command again.
   :::

### Task 3: Review a Basic FizzBuzz Script

1. [ ] Download the `06-FizzBuzz.ps1` file from the course GitHub repository folder `supporting content/Lab4`.

2. [ ] Save the script to `C:\LabOutput\06-FizzBuzz.ps1`.

3. [ ] Open `C:\LabOutput\06-FizzBuzz.ps1` in **Visual Studio Code**.

4. [ ] Review the following PowerShell script.

```powershell
foreach ($number in 1..30) {
    if ($number % 15 -eq 0) {
        "FizzBuzz"
    }
    elseif ($number % 3 -eq 0) {
        "Fizz"
    }
    elseif ($number % 5 -eq 0) {
        "Buzz"
    }
    else {
        $number
    }
}
```

5. [ ] Verify that the script uses `if`, `elseif`, and `else` statements.

6. [ ] Verify that the script uses a `foreach` loop.

### Task 4: Run the FizzBuzz Script in Visual Studio Code

1. [ ] In **Visual Studio Code**, select **Terminal**.

2. [ ] Select **New Terminal**.

3. [ ] Verify that the integrated terminal opens.

4. [ ] In the integrated terminal, run the following command to move to the lab output folder.

```powershell
Set-Location C:\LabOutput
```

5. [ ] Run the following command to allow scripts in the current PowerShell process.

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

6. [ ] Run the following command to execute the script.

```powershell
.\06-FizzBuzz.ps1
```

7. [ ] Verify that the output includes numbers, `Fizz`, `Buzz`, and `FizzBuzz`.

### Task 5: Run the System Information HTML Report Script

1. [ ] Download the `Get-SystemInformationReport.ps1` file from the course GitHub repository folder `supporting content/Lab4`.

2. [ ] Save the script to `C:\LabOutput\Get-SystemInformationReport.ps1`.

3. [ ] In the Visual Studio Code integrated terminal, run the following command.

```powershell
C:\LabOutput\Get-SystemInformationReport.ps1
```

4. [ ] Verify that the script creates `C:\LabOutput\SystemInformationReport.html`.

5. [ ] Run the following command to open the HTML report.

```powershell
Start-Process C:\LabOutput\SystemInformationReport.html
```

6. [ ] Review the **Computer Summary**, **Operating System**, **Network Configuration**, **Disk Volumes**, and **Recent Hotfixes** sections.

::: success
**Results**: After completing this exercise, you will have installed Visual Studio Code, added the PowerShell extension, written a PowerShell script, and generated a system information HTML report.
:::

## Exercise 7: Customizing the PowerShell Prompt with Oh My Posh

::: secondary
**Scenario**

You want the terminal to provide useful context while you work. You will install Oh My Posh, configure a lab prompt theme, and verify that the prompt shows the current Git branch when you are inside a repository.
:::

### Task 1: Prepare the Oh My Posh Lab Files

1. [ ] Return to the elevated PowerShell session on LON-SVR1.

2. [ ] Run the following command to create the lab output folder.

```powershell
New-Item -Path C:\LabOutput -ItemType Directory -Force
```

3. [ ] Download `07-SetupOhMyPoshPrompt.ps1` from the course GitHub repository folder `supporting content/Lab4`.

4. [ ] Save the script to `C:\LabOutput\07-SetupOhMyPoshPrompt.ps1`.

5. [ ] Download `Lab4-GitBranch.omp.json` from the course GitHub repository folder `supporting content/Lab4`.

6. [ ] Save the file to `C:\LabOutput\Lab4-GitBranch.omp.json`.

7. [ ] Open `C:\LabOutput\07-SetupOhMyPoshPrompt.ps1` in **Visual Studio Code**.

8. [ ] Review the script before running it.

### Task 2: Install Oh My Posh

1. [ ] In the elevated PowerShell session, run the following command to install Oh My Posh.

```powershell
winget install JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements
```

2. [ ] Wait for the installation to finish.

3. [ ] Run the following command to verify that Oh My Posh is available.

```powershell
oh-my-posh --version
```

4. [ ] Verify that a version number is displayed.

5. [ ] Run the following command to install the recommended Nerd Font.

```powershell
oh-my-posh font install meslo
```

6. [ ] If prompted to confirm the font installation, follow the prompts provided by Oh My Posh.

   ::: warning
   **Note**: If icons appear as boxes or question marks, configure Windows Terminal to use the installed `MesloLGM Nerd Font` font.
   :::

### Task 3: Configure the PowerShell Profile

1. [ ] Run the following command to allow scripts in the current PowerShell process.

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force
```

2. [ ] Run the following command to open notepas to check the profile. Then add the following line to the $PROFILE file and save it 

```powershell
notepad $PROFILE
```

```code
oh-my-posh init pwsh | Invoke-Expression
```

3. [ ] Run the following command to reload the PowerShell profile.

```powershell
. $PROFILE
```

4. [ ] Verify that the prompt appearance changes.

### Task 4: Verify the Git Branch Prompt

1. [ ] Run the following command to create a test Git repository.

```powershell
New-Item -Path C:\LabOutput\PromptTestRepo -ItemType Directory -Force
```

2. [ ] Run the following command to move to the test repository folder.

```powershell
Set-Location C:\LabOutput\PromptTestRepo
```

3. [ ] Run the following command to initialize a Git repository.

```powershell
git init
```

4. [ ] Run the following command to create and switch to a branch.

```powershell
git checkout -b feature/lab4-prompt
```

5. [ ] Run the following command to create a test file.

```powershell
"Lab 4 prompt test" | Out-File -FilePath .\README.md -Encoding utf8
```

6. [ ] Run the following command to stage the test file.

```powershell
git add .\README.md
```

7. [ ] Verify that the prompt shows the `feature/lab4-prompt` branch.

8. [ ] Run the following command to confirm the active branch.

```powershell
git branch --show-current
```

9. [ ] Verify that the command returns `feature/lab4-prompt`.

::: success
**Results**: After completing this exercise, you will have installed Oh My Posh and configured PowerShell to show Git branch context in the prompt.
:::

## Exercise 8: Using If/Else Logic, Loops, and Variables

::: secondary
**Scenario**

You need to understand the scripting building blocks used in administrative automation. You will review variable types, conditional logic, and common loop patterns in PowerShell.
:::

### Task 1: Review Variable Types

1. [ ] Download the `08-IfElseLoopsAndVariables.ps1` file from the course GitHub repository folder `supporting content/Lab4`.

2. [ ] Save the script to `C:\LabOutput\08-IfElseLoopsAndVariables.ps1`.

3. [ ] Open `C:\LabOutput\08-IfElseLoopsAndVariables.ps1` in **Visual Studio Code**.

4. [ ] Locate the following variable examples in the script.

```powershell
$serverName = $env:COMPUTERNAME
$maxServicesToShow = 5
$minimumFreePercent = [double]$DiskWarningPercent
$includeStoppedServices = $true
$today = Get-Date
$serviceNames = @("Dnscache", "EventLog", "Winmgmt")
$serviceFriendlyNames = @{
    Dnscache = "DNS Client"
    EventLog = "Windows Event Log"
    Winmgmt = "Windows Management Instrumentation"
}
```

5. [ ] Identify one string variable.

6. [ ] Identify one integer variable.

7. [ ] Identify one Boolean variable.

8. [ ] Identify one array variable.

9. [ ] Identify one hash table variable.

### Task 2: Run If, Elseif, and Else Logic

1. [ ] In the Visual Studio Code integrated terminal, run the following command.

```powershell
C:\LabOutput\08-IfElseLoopsAndVariables.ps1
```

2. [ ] Review the output from the `if`, `elseif`, and `else` section.

3. [ ] Verify that the script reports the free space condition for the C drive.

4. [ ] Run the following command with a different warning percentage.

```powershell
C:\LabOutput\08-IfElseLoopsAndVariables.ps1 -DiskWarningPercent 50
```

5. [ ] Verify that the script still runs successfully with the parameter value.

### Task 3: Review Loop Types

1. [ ] In `C:\LabOutput\08-IfElseLoopsAndVariables.ps1`, locate the `foreach` loop.

2. [ ] Verify that the `foreach` loop checks each service name in the `$serviceNames` array.

3. [ ] Locate the `for` loop.

4. [ ] Verify that the `for` loop uses a counter.

5. [ ] Locate the `while` loop.

6. [ ] Verify that the `while` loop continues while a condition is true.

7. [ ] Locate the `do while` loop.

8. [ ] Verify that the `do while` loop runs at least once.

::: success
**Results**: After completing this exercise, you will have used variables, conditional logic, and common PowerShell loop patterns.
:::

## Exercise 9: Exporting PowerShell Object Output

::: secondary
**Scenario**

You need to save PowerShell object output for reporting and later review. You will collect service status objects and export the same data to CSV, XML, JSON, and HTML formats.
:::

### Task 1: Create Service Status Objects

1. [ ] Run the following command to collect service status objects.

```powershell
$serviceStatus = Get-Service | Select-Object Name,DisplayName,Status,StartType
```

2. [ ] Run the following command to display the first five objects.

```powershell
$serviceStatus | Select-Object -First 5
```

3. [ ] Verify that each object includes **Name**, **DisplayName**, **Status**, and **StartType**.

### Task 2: Export Objects to Multiple Formats

1. [ ] Download the `09-ExportServiceStatusObjects.ps1` file from the course GitHub repository folder `supporting content/Lab4`.

2. [ ] Save the script to `C:\LabOutput\09-ExportServiceStatusObjects.ps1`.

3. [ ] Run the following command to export the service status objects.

```powershell
C:\LabOutput\09-ExportServiceStatusObjects.ps1
```

4. [ ] Verify that the script displays paths for CSV, XML, JSON, and HTML files.

5. [ ] Run the following command to list the exported files.

```powershell
Get-ChildItem C:\LabOutput\ServiceStatus.*
```

6. [ ] Verify that `ServiceStatus.csv`, `ServiceStatus.xml`, `ServiceStatus.json`, and `ServiceStatus.html` are listed.

### Task 3: Review the Exported Files

1. [ ] Run the following command to preview the CSV file.

```powershell
Import-Csv C:\LabOutput\ServiceStatus.csv | Select-Object -First 5
```

2. [ ] Run the following command to preview the XML file.

```powershell
Import-Clixml C:\LabOutput\ServiceStatus.xml | Select-Object -First 5
```

3. [ ] Run the following command to preview the JSON file.

```powershell
Get-Content C:\LabOutput\ServiceStatus.json -TotalCount 10
```

4. [ ] Run the following command to open the HTML file.

```powershell
Start-Process C:\LabOutput\ServiceStatus.html
```

5. [ ] Verify that the HTML report opens and displays service status information.

::: success
**Results**: After completing this exercise, you will have exported PowerShell object output to CSV, XML, JSON, and HTML formats.
:::

## Exercise 10: Creating a Basic GUI with PowerShell

::: secondary
**Scenario**

You want to see how PowerShell can create a simple graphical tool. You will run a Windows Forms script that displays service status information in a basic GUI.
:::

### Task 1: Review the GUI Script

1. [ ] Download the `10-BasicPowerShellGui.ps1` file from the course GitHub repository folder `supporting content/Lab4`.

2. [ ] Save the script to `C:\LabOutput\10-BasicPowerShellGui.ps1`.

3. [ ] Open `C:\LabOutput\10-BasicPowerShellGui.ps1` in **Visual Studio Code**.

4. [ ] Locate the following lines that load Windows Forms and drawing support.

```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
```

5. [ ] Locate the code that creates the form.

6. [ ] Locate the code that creates the **Get Services** button.

7. [ ] Locate the button click event that runs `Get-Service`.

### Task 2: Run the GUI Script

1. [ ] In the Visual Studio Code integrated terminal, run the following command.

```powershell
C:\LabOutput\10-BasicPowerShellGui.ps1
```

2. [ ] Verify that the **Lab 4 Service Status Viewer** window opens.

3. [ ] Select **Get Services**.

4. [ ] Verify that service status output appears in the text box.

5. [ ] Select **Close**.

6. [ ] Verify that the GUI window closes.

::: success
**Results**: After completing this exercise, you will have created and run a basic PowerShell GUI that displays service status information.
:::

## Exercise 11: Verifying PowerShell Administration Skills

::: secondary
**Scenario**

You have used PowerShell to collect and shape administrative information, customize the prompt, write scripts, export objects, and run a basic GUI. You will verify the key skills from this lab by running a short set of commands and confirming their output.
:::

### Task 1: Verify Core Commands

1. [ ] Run the following command to verify the computer name.

```powershell
hostname
```

2. [ ] Verify that the command returns `LON-SVR1`.

3. [ ] Run the following command to verify that the lab output file exists.

```powershell
Get-Item C:\LabOutput\RunningServices.csv | Select-Object Name,Length,LastWriteTime
```

4. [ ] Verify that **Name** shows `RunningServices.csv`.

5. [ ] Run the following command to display the first five lines of the exported CSV file.

```powershell
Get-Content C:\LabOutput\RunningServices.csv -TotalCount 5
```

6. [ ] Verify that the file contains service information.

7. [ ] Run the following command to verify that the HTML system information report exists.

```powershell
Test-Path C:\LabOutput\SystemInformationReport.html
```

8. [ ] Verify that the command returns `True`.

9. [ ] Run the following command to verify that the service status exports exist.

```powershell
Get-ChildItem C:\LabOutput\ServiceStatus.* | Select-Object Name,Length,LastWriteTime
```

10. [ ] Verify that CSV, XML, JSON, and HTML files are listed.

11. [ ] Run the following command to verify the current Git branch in the prompt test repository.

```powershell
Set-Location C:\LabOutput\PromptTestRepo
git branch --show-current
```

12. [ ] Verify that the command returns `feature/lab4-prompt`.

13. [ ] Close PowerShell and Visual Studio Code if instructed by your instructor.

::: success
**Results**: After completing this exercise, you will have verified PowerShell administration skills for command discovery, system inventory, output filtering, prompt customization, script editing, object export, and GUI execution.
:::
