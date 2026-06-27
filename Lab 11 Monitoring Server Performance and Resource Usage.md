# Practice Lab 1101: Monitoring Server Performance and Resource Usage

## Summary

::: secondary
In this lab, you will use Windows Server tools to monitor system performance, collect a short performance baseline, generate controlled activity, and compare the results. You will use Task Manager, Resource Monitor, Performance Monitor, Data Collector Sets, Event Viewer, File Explorer, Windows PowerShell, Process Explorer, and Process Monitor.

The goal is to learn how administrators move from "the server feels slow" to a structured investigation of CPU, memory, disk, network, services, and related events.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:

- Completed Lab 0401 (PowerShell Command-Line Administration)
- Administrator access to **LON-SVR1**
- Basic familiarity with Server Manager
- Basic familiarity with Windows PowerShell
- Understanding of system resources such as CPU, memory, disk, and network
- Internet access from LON-SVR1 for downloading Microsoft Sysinternals utilities
:::

## Exercise 1: Connect to LON-SVR1 and Review the Monitoring Goal

::: secondary
**Scenario**

Users sometimes report that a server is slow, but "slow" is a symptom, not a diagnosis. You need to connect to LON-SVR1 and prepare to observe resource usage with multiple Windows Server tools.
:::

### Task 1: Connect to LON-SVR1

1. [ ] In the lab platform, select **HOME**.

2. [ ] From the **Select VM** dropdown, select **LON-SVR1**.

3. [ ] In the **Tools** section, turn on **Enhanced mode** so the virtual machine uses the best screen resolution for your monitor.

4. [ ] Use the **Username** value shown for the selected VM on the **HOME** tab.

5. [ ] Use the **Password** value shown for the selected VM on the **HOME** tab.

6. [ ] Wait for the Windows Server desktop to appear.

::: success
**Results**: After completing this task, you are connected to LON-SVR1 through the lab platform.
:::

## Exercise 2: Use Task Manager for Real-Time Monitoring

::: secondary
**Scenario**

Task Manager is often the fastest way to confirm whether a server is experiencing CPU, memory, disk, or network pressure. You will use it first because it gives a quick operational view before you open deeper tools.
:::

### Task 1: Open Task Manager and Review Running Processes

1. [ ] Right-click the **Start** button.

2. [ ] Select **Task Manager**.

3. [ ] If Task Manager opens in compact view, select **More details**.

4. [ ] Select the **Processes** tab.

5. [ ] Review the columns for **CPU**, **Memory**, **Disk**, and **Network**.

6. [ ] Select the **CPU** column header to sort processes by CPU usage.

7. [ ] Select the **Memory** column header to sort processes by memory usage.

8. [ ] Select the **Disk** column header to sort processes by disk activity.

9. [ ] Identify the process currently using the most CPU.

10. [ ] Identify the process currently using the most memory.

   ::: warning
   **Note**: A process at the top of the list is not automatically a problem. Administrators compare usage with the server role, current workload, and recent changes before deciding what to do.
   :::

::: success
**Results**: After completing this task, you can use Task Manager to identify which processes are using the most visible resources.
:::

### Task 2: Review the Performance Tab

1. [ ] In **Task Manager**, select the **Performance** tab.

2. [ ] Select **CPU**.

3. [ ] Review **Utilization**, **Speed**, **Processes**, **Threads**, and **Up time**.

4. [ ] Select **Memory**.

5. [ ] Review **In use**, **Available**, **Committed**, and **Cached**.

6. [ ] Select **Disk 0** or the main disk shown in the list.

7. [ ] Review **Active time**, **Average response time**, **Read speed**, and **Write speed**.

8. [ ] Select the active network adapter.

9. [ ] Review the send and receive activity.

10. [ ] Keep Task Manager open.

::: success
**Results**: After completing this task, you have reviewed real-time CPU, memory, disk, and network performance on LON-SVR1.
:::

### Task 3: Generate a Short CPU Load

1. [ ] Select **Start**.

2. [ ] Type **PowerShell**.

3. [ ] In the search results, right-click **Windows PowerShell**.

4. [ ] Select **Run as administrator**.

5. [ ] If a **User Account Control** prompt appears, select **Yes**.

6. [ ] In Windows PowerShell, run the following command:

```powershell
$end = (Get-Date).AddSeconds(45)
while ((Get-Date) -lt $end) {
    [Math]::Sqrt((Get-Random)) | Out-Null
}
Write-Host "CPU load test complete."
```

7. [ ] While the command runs, return to **Task Manager**.

8. [ ] On the **Performance** tab, watch the **CPU** graph.

9. [ ] On the **Processes** tab, sort by **CPU**.

10. [ ] Confirm that **Windows PowerShell** appears near the top while the command runs.

11. [ ] Wait for the command to finish.

12. [ ] Verify that CPU usage returns closer to its previous idle level.

::: success
**Results**: After completing this task, you have observed a controlled CPU increase and identified the process responsible for it.
:::

## Exercise 3: Use Resource Monitor for Process-Level Investigation

::: secondary
**Scenario**

Task Manager shows a quick summary. Resource Monitor provides more detail about which processes are using CPU, memory, disk, and network resources. You will use it to investigate the same server from a deeper view.
:::

### Task 1: Open Resource Monitor

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **Resource Monitor**.

3. [ ] In **Resource Monitor**, select the **Overview** tab.

4. [ ] Review the sections for **CPU**, **Disk**, **Network**, and **Memory**.

5. [ ] Expand any collapsed section by selecting its section header.

::: success
**Results**: After completing this task, you have opened Resource Monitor and reviewed the overview layout.
:::

### Task 2: Investigate CPU Activity

1. [ ] In **Resource Monitor**, select the **CPU** tab.

2. [ ] Review the **Processes** section.

3. [ ] Review the **CPU** and **Average CPU** columns.

4. [ ] Select the checkbox next to a process with visible CPU activity.

5. [ ] Review how the lower sections filter to show details for the selected process.

6. [ ] Clear the checkbox when you are finished.

   ::: warning
   **Note**: Selecting a checkbox in Resource Monitor filters the view. If a later section appears empty, check whether a process filter is still selected.
   :::

::: success
**Results**: After completing this task, you can use Resource Monitor to focus CPU details on a selected process.
:::

### Task 3: Investigate Memory Usage

1. [ ] Select the **Memory** tab.

2. [ ] Review the **Processes** section.

3. [ ] Locate the columns for **Commit**, **Working Set**, **Shareable**, and **Private**.

4. [ ] Select the **Working Set** column header to sort processes by total memory currently in use.

5. [ ] Review the **Physical Memory** bar near the bottom of the window.

6. [ ] Notice the sections for **Hardware Reserved**, **In Use**, **Modified**, **Standby**, and **Free** memory.

::: success
**Results**: After completing this task, you can review process memory usage and the current physical memory state.
:::

### Task 4: Create and Observe Disk Activity

1. [ ] Return to **Windows PowerShell**.

2. [ ] Run the following command to create a temporary folder and several test files:

```powershell
$folder = "C:\PerfLab"
New-Item -ItemType Directory -Path $folder -Force | Out-Null
1..4 | ForEach-Object {
    $file = Join-Path $folder "diskload$_.bin"
    fsutil file createnew $file 67108864 | Out-Null
}
Write-Host "Temporary disk test files created in C:\PerfLab."
```

3. [ ] Open **File Explorer**.

4. [ ] In the address bar, enter `C:\PerfLab`.

5. [ ] Select all four `diskload` files.

6. [ ] In the command bar, select **Copy**.

7. [ ] Create a new folder named `CopyTest`.

8. [ ] Open the `CopyTest` folder.

9. [ ] In the command bar, select **Paste**.

10. [ ] While the files copy, return to **Resource Monitor**.

11. [ ] Select the **Disk** tab.

12. [ ] Review **Processes with Disk Activity** and **Disk Activity**.

13. [ ] Look for disk activity related to File Explorer, PowerShell, or system processes writing to `C:\PerfLab`.

14. [ ] Wait for the copy operation to finish.

::: success
**Results**: After completing this task, you have generated controlled disk activity and observed it in Resource Monitor.
:::

### Task 5: Review Network Activity

1. [ ] In **Resource Monitor**, select the **Network** tab.

2. [ ] Review **Processes with Network Activity**.

3. [ ] Return to **Windows PowerShell**.

4. [ ] Run the following command:

```powershell
Test-Connection LON-DC1 -Count 20
```

5. [ ] Return to **Resource Monitor**.

6. [ ] Review the **Network Activity** and **TCP Connections** sections.

7. [ ] Notice whether any activity appears while the test runs.

   ::: warning
   **Note**: The network activity from a small connectivity test may be brief. In production, administrators often monitor network activity while users or services are actively connecting to the server.
   :::

::: success
**Results**: After completing this task, you have reviewed network activity and tested connectivity to another lab server.
:::

## Exercise 4: Use Performance Monitor for Custom Counters

::: secondary
**Scenario**

Performance Monitor lets you select specific counters and watch them over time. This is useful when you need more detail than Task Manager or Resource Monitor can provide.
:::

### Task 1: Open Performance Monitor

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **Performance Monitor**.

3. [ ] In the left pane, expand **Monitoring Tools** if it is not already expanded.

4. [ ] Select **Performance Monitor**.

5. [ ] Review the graph in the center pane.

6. [ ] If counters are already shown, select the graph and review the counter list below it.

::: success
**Results**: After completing this task, you have opened the real-time Performance Monitor graph.
:::

### Task 2: Add Core Performance Counters

1. [ ] In **Performance Monitor**, select the green **Add** button on the toolbar.

2. [ ] In the **Add Counters** window, verify that **Select counters from computer** is set to **<Local computer>** or **LON-SVR1**.

3. [ ] In **Available counters**, expand **Processor**.

4. [ ] Select **% Processor Time**.

5. [ ] Under **Instances of selected object**, select **_Total**.

6. [ ] Select **Add >>**.

7. [ ] Expand **System**.

8. [ ] Select **Processor Queue Length**.

9. [ ] Select **Add >>**.

10. [ ] Expand **Memory**.

11. [ ] Select **Available MBytes**.

12. [ ] Select **Add >>**.

13. [ ] In **Memory**, select **Pages/sec**.

14. [ ] Select **Add >>**.

15. [ ] Expand **LogicalDisk**.

16. [ ] Select **% Free Space**.

17. [ ] Under **Instances of selected object**, select **C:**.

18. [ ] Select **Add >>**.

19. [ ] Expand **PhysicalDisk**.

20. [ ] Select **Avg. Disk sec/Read**.

21. [ ] Under **Instances of selected object**, select **_Total**.

22. [ ] Select **Add >>**.

23. [ ] Expand **Network Interface**.

24. [ ] Select **Bytes Total/sec**.

25. [ ] Under **Instances of selected object**, select the active network adapter.

26. [ ] Select **Add >>**.

27. [ ] Select **OK**.

::: success
**Results**: After completing this task, Performance Monitor is displaying counters for CPU, memory, disk, and network activity.
:::

### Task 3: Interpret the Counters

1. [ ] In the counter list below the graph, select **Processor(_Total)\% Processor Time**.

2. [ ] Review the **Last**, **Average**, **Minimum**, and **Maximum** values.

3. [ ] Select **System\Processor Queue Length**.

4. [ ] Review whether the value remains low while the server is idle.

5. [ ] Select **Memory\Available MBytes**.

6. [ ] Review how much memory is currently available.

7. [ ] Select **Memory\Pages/sec**.

8. [ ] Review whether paging activity is low while the server is idle.

9. [ ] Select **LogicalDisk(C:)\% Free Space**.

10. [ ] Review the available free space percentage.

11. [ ] Select **PhysicalDisk(_Total)\Avg. Disk sec/Read**.

12. [ ] Review whether disk latency appears low while the server is idle.

13. [ ] Select **Network Interface(*)\Bytes Total/sec** for the active adapter.

14. [ ] Review the current network throughput.

   ::: warning
   **Note**: A single counter value rarely tells the whole story. For example, high CPU with a low processor queue may be normal during a short task, while sustained high CPU with a growing queue can indicate pressure.
   :::

::: success
**Results**: After completing this task, you can describe what each selected counter helps you investigate.
:::

## Exercise 5: Create a Data Collector Set for a Short Baseline

::: secondary
**Scenario**

A baseline is a record of normal performance during a known period. You will create a short Data Collector Set so you can compare idle performance against later activity.
:::

### Task 1: Create a User Defined Data Collector Set

1. [ ] In **Performance Monitor**, expand **Data Collector Sets**.

2. [ ] Right-click **User Defined**.

3. [ ] Select **New**.

4. [ ] Select **Data Collector Set**.

5. [ ] In **Name**, enter `LON-SVR1 Baseline`.

6. [ ] Select **Create manually (Advanced)**.

7. [ ] Select **Next >**.

8. [ ] On the **What type of data do you want to include?** page, select **Performance counter**.

9. [ ] Select **Next >**.

10. [ ] On the **Which performance counters would you like to log?** page, select **Add...**.

11. [ ] Add the same counters you used in Exercise 4:
   - **Processor(_Total)\% Processor Time**
   - **System\Processor Queue Length**
   - **Memory\Available MBytes**
   - **Memory\Pages/sec**
   - **LogicalDisk(C:)\% Free Space**
   - **PhysicalDisk(_Total)\Avg. Disk sec/Read**
   - **Network Interface** active adapter **Bytes Total/sec**

12. [ ] Select **OK**.

13. [ ] In **Sample interval**, enter `5`.

14. [ ] Verify that the unit is **Seconds**.

15. [ ] Select **Next >**.

16. [ ] On the **Where would you like the data to be saved?** page, accept the default location.

17. [ ] Select **Next >**.

18. [ ] On the **Create the data collector set?** page, select **Save and close**.

19. [ ] Select **Finish**.

::: success
**Results**: After completing this task, you have created a Data Collector Set named LON-SVR1 Baseline.
:::

### Task 2: Start and Stop the Baseline Collection

1. [ ] Under **Data Collector Sets**, expand **User Defined**.

2. [ ] Select **LON-SVR1 Baseline**.

3. [ ] In the **Actions** pane, select **Start**.

4. [ ] Wait approximately one minute while the server is mostly idle.

5. [ ] In the **Actions** pane, select **Stop**.

6. [ ] Expand **Reports**.

7. [ ] Expand **User Defined**.

8. [ ] Expand **LON-SVR1 Baseline**.

9. [ ] Select the newest report.

10. [ ] Review the collected counter information.

   ::: warning
   **Note**: If the report does not appear immediately, select **Reports**, then select **Refresh** in the **Actions** pane.
   :::

::: success
**Results**: After completing this task, you have captured a short idle performance baseline for LON-SVR1.
:::

### Task 3: Record Baseline Observations

Record the following information in your lab notes:

1. [ ] Server monitored: **LON-SVR1**

2. [ ] Baseline collection name: **LON-SVR1 Baseline**

3. [ ] Approximate CPU usage during idle baseline

4. [ ] Approximate available memory during idle baseline

5. [ ] Approximate free space on drive C:

6. [ ] Whether disk activity was low, moderate, or high

7. [ ] Whether network activity was low, moderate, or high

::: success
**Results**: After completing this task, you have recorded baseline observations that can be compared with later performance activity.
:::

## Exercise 6: Compare Baseline Activity with Controlled Load

::: secondary
**Scenario**

You need to understand how performance counters change when the server is doing work. You will start the same Data Collector Set, generate controlled CPU and disk activity, then compare the results with the idle baseline.
:::

### Task 1: Start a Second Performance Collection

1. [ ] In **Performance Monitor**, expand **Data Collector Sets**.

2. [ ] Expand **User Defined**.

3. [ ] Select **LON-SVR1 Baseline**.

4. [ ] In the **Actions** pane, select **Start**.

5. [ ] Leave Performance Monitor open.

::: success
**Results**: After completing this task, the Data Collector Set is collecting performance data while you generate activity.
:::

### Task 2: Generate CPU and Disk Activity

1. [ ] Return to **Windows PowerShell**.

2. [ ] Run the following command to generate CPU activity for 60 seconds:

```powershell
$end = (Get-Date).AddSeconds(60)
while ((Get-Date) -lt $end) {
    [Math]::Pow((Get-Random), 2) | Out-Null
}
Write-Host "CPU activity complete."
```

3. [ ] Open **File Explorer**.

4. [ ] Open `C:\PerfLab`.

5. [ ] If the `CopyTest` folder does not exist, create it.

6. [ ] If the `CopyTest` folder already contains copied test files, open it and delete the copied test files.

7. [ ] Return to `C:\PerfLab`.

8. [ ] Select the four `diskload` files.

9. [ ] In the command bar, select **Copy**.

10. [ ] Open the `CopyTest` folder.

11. [ ] In the command bar, select **Paste**.

12. [ ] Wait for the copy operation to finish.

::: success
**Results**: After completing this task, you have generated CPU and disk activity while the Data Collector Set is running.
:::

### Task 3: Stop the Collection and Compare Results

1. [ ] Return to **Performance Monitor**.

2. [ ] Under **Data Collector Sets** > **User Defined**, select **LON-SVR1 Baseline**.

3. [ ] In the **Actions** pane, select **Stop**.

4. [ ] Expand **Reports** > **User Defined** > **LON-SVR1 Baseline**.

5. [ ] Select the newest report.

6. [ ] Compare the newest report with the earlier idle baseline report.

7. [ ] Identify which counters changed the most during activity.

8. [ ] Record whether CPU, disk, memory, or network changed most visibly.

   ::: warning
   **Note**: The exact values can vary by lab host performance. Focus on the relationship between idle activity and controlled workload rather than matching a specific number.
   :::

::: success
**Results**: After completing this task, you have compared idle performance with controlled activity.
:::

## Exercise 7: Review Events Related to System Health

::: secondary
**Scenario**

Performance counters show symptoms. Event logs can provide supporting context, such as service failures, disk warnings, driver errors, or application issues. You will review recent events after collecting performance data.
:::

### Task 1: Open Event Viewer and Review the System Log

1. [ ] In **Server Manager**, select **Tools**.

2. [ ] Select **Event Viewer**.

3. [ ] In the left pane, expand **Windows Logs**.

4. [ ] Select **System**.

5. [ ] Review recent events in the center pane.

6. [ ] Select a recent event.

7. [ ] Review the **General** tab in the lower pane.

::: success
**Results**: After completing this task, you have reviewed recent System log events.
:::

### Task 2: Filter for Warnings and Errors

1. [ ] With **System** selected, locate the **Actions** pane.

2. [ ] Select **Filter Current Log...**.

3. [ ] In **Event level**, select **Critical**, **Warning**, and **Error**.

4. [ ] Select **OK**.

5. [ ] Review the filtered events.

6. [ ] Select one filtered event.

7. [ ] Review the **Source**, **Event ID**, **Level**, and **Logged** time.

8. [ ] In the **Actions** pane, select **Clear Filter**.

   ::: warning
   **Note**: Warnings and errors do not always mean the server has a current performance problem. Administrators check the event source, time, frequency, and affected component before taking action.
   :::

::: success
**Results**: After completing this task, you have filtered the System log for events that may require investigation.
:::

### Task 3: Review the Application Log

1. [ ] In **Event Viewer**, under **Windows Logs**, select **Application**.

2. [ ] Review recent events.

3. [ ] Use **Filter Current Log...** to show **Critical**, **Warning**, and **Error** events.

4. [ ] Review whether any recent application events occurred during the performance exercises.

5. [ ] In the **Actions** pane, select **Clear Filter** if a filter is applied.

::: success
**Results**: After completing this task, you have reviewed Application log events that may support a performance investigation.
:::

## Exercise 8: Validate Performance Information with PowerShell

::: secondary
**Scenario**

Graphical tools are useful for investigation. PowerShell is useful when you need repeatable checks, documented output, or automation. You will run a few focused commands to validate resource information.
:::

### Task 1: Review Top Processes by Memory

1. [ ] Return to **Windows PowerShell**.

2. [ ] Run the following command:

```powershell
Get-Process |
    Sort-Object WorkingSet -Descending |
    Select-Object -First 10 Name, Id, CPU, @{Name="MemoryMB";Expression={[Math]::Round($_.WorkingSet / 1MB, 1)}} |
    Format-Table -AutoSize
```

3. [ ] Review the top 10 processes by memory usage.

4. [ ] Compare the results with what you saw in Task Manager and Resource Monitor.

::: success
**Results**: After completing this task, you have validated process memory usage with PowerShell.
:::

### Task 2: Review Disk Free Space

1. [ ] Run the following command:

```powershell
Get-Volume |
    Where-Object DriveLetter |
    Select-Object DriveLetter, FileSystemLabel, FileSystem,
        @{Name="SizeGB";Expression={[Math]::Round($_.Size / 1GB, 2)}},
        @{Name="FreeGB";Expression={[Math]::Round($_.SizeRemaining / 1GB, 2)}},
        @{Name="PercentFree";Expression={[Math]::Round(($_.SizeRemaining / $_.Size) * 100, 2)}} |
    Format-Table -AutoSize
```

2. [ ] Review the free space on drive C:.

3. [ ] Compare the result with the **LogicalDisk(C:)\% Free Space** counter you collected.

::: success
**Results**: After completing this task, you have validated disk capacity with PowerShell.
:::

### Task 3: Capture Current Counter Values

1. [ ] Run the following command:

```powershell
Get-Counter '\Processor(_Total)\% Processor Time',
            '\Memory\Available MBytes',
            '\LogicalDisk(C:)\% Free Space',
            '\PhysicalDisk(_Total)\Avg. Disk sec/Read' |
    Select-Object -ExpandProperty CounterSamples |
    Select-Object Path, CookedValue |
    Format-Table -AutoSize
```

2. [ ] Review the current counter values.

3. [ ] Notice that PowerShell can query the same performance counter categories used by Performance Monitor.

::: success
**Results**: After completing this task, you have used PowerShell to query live performance counters.
:::

## Exercise 9: Complete a Guided Performance Troubleshooting Scenario

::: secondary
**Scenario**

A user reports that LON-SVR1 was slow a few minutes ago. You need to use the monitoring tools from this lab to decide which resource area you would investigate first.
:::

### Task 1: Review the Evidence

1. [ ] In **Task Manager**, review the **Processes** tab.

2. [ ] Sort by **CPU** and identify whether any process is currently using high CPU.

3. [ ] Sort by **Memory** and identify whether any process is using unexpectedly high memory.

4. [ ] Sort by **Disk** and identify whether any process is actively reading or writing.

5. [ ] In **Resource Monitor**, review the **Overview** tab.

6. [ ] In **Performance Monitor**, review the newest report under **Reports** > **User Defined** > **LON-SVR1 Baseline**.

7. [ ] In **Event Viewer**, review recent **System** warnings and errors.

::: success
**Results**: After completing this task, you have gathered evidence from multiple monitoring tools.
:::

### Task 2: Choose the First Area to Investigate

Record the following in your lab notes:

1. [ ] Which resource changed most visibly during the controlled workload: **CPU**, **memory**, **disk**, or **network**

2. [ ] Which tool showed the clearest evidence

3. [ ] Which process or activity appeared related to the change

4. [ ] Whether Event Viewer showed any related warnings or errors

5. [ ] What you would check next if this were a production server

   ::: warning
   **Note**: In production, administrators should avoid ending processes, restarting services, or changing resource limits until they understand business impact and have approval for disruptive actions.
   :::

::: success
**Results**: After completing this task, you have practiced turning monitoring data into a troubleshooting decision.
:::

## Exercise 10: Examine Running Processes with Process Explorer

::: secondary
**Scenario**

Task Manager and Resource Monitor provide useful process information, but some investigations require a more detailed view of process relationships, open handles, and loaded DLLs. You will download Microsoft Sysinternals Process Explorer and examine the processes running on LON-SVR1.
:::

### Task 1: Download and Extract Process Explorer

1. [ ] Open **Microsoft Edge**.

2. [ ] In the address bar, enter:

```text
https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer
```

3. [ ] On the **Process Explorer** page, review the introduction and supported operating systems.

4. [ ] Select **Download Process Explorer**.

5. [ ] When the download completes, select the downloaded `ProcessExplorer.zip` file from the Microsoft Edge downloads list.

6. [ ] In **File Explorer**, select **Extract all**.

7. [ ] Accept the default extraction location.

8. [ ] Verify that **Show extracted files when complete** is selected.

9. [ ] Select **Extract**.

   ::: warning
   **Note**: Download administrative utilities only from trusted sources. This lab uses the official Microsoft Sysinternals download page.
   :::

::: success
**Results**: After completing this task, Process Explorer is downloaded and extracted on LON-SVR1.
:::

### Task 2: Run Process Explorer

1. [ ] In the extracted **ProcessExplorer** folder, locate `procexp64.exe`.

2. [ ] Right-click `procexp64.exe`.

3. [ ] Select **Run as administrator**.

4. [ ] If a **User Account Control** prompt appears, select **Yes**.

5. [ ] If the **Process Explorer License Agreement** appears, review the agreement and select **Agree**.

6. [ ] Maximize the **Process Explorer** window.

7. [ ] Verify that the upper pane displays a tree of active processes.

   ::: warning
   **Note**: Process Explorer is a portable utility and does not use an installation wizard. Running it as administrator allows it to display more complete information about system processes.
   :::

::: success
**Results**: After completing this task, Process Explorer is running with administrative permissions.
:::

### Task 3: Examine the Process Tree and Process Properties

1. [ ] In the upper pane, review the process tree.

2. [ ] Expand one or more processes that have child processes.

3. [ ] Review the **Process**, **PID**, **CPU**, **Private Bytes**, **Working Set**, and **Description** columns.

4. [ ] Select the **CPU** column header to sort processes by current CPU activity.

5. [ ] Select the **Working Set** column header to sort processes by physical memory usage.

6. [ ] Locate and select `explorer.exe`.

7. [ ] Double-click `explorer.exe` to open its properties.

8. [ ] On the **Image** tab, review the image path, command line, current directory, and parent process information.

9. [ ] Select the **Performance** tab.

10. [ ] Review the CPU, memory, and input/output information.

11. [ ] Select **OK** to close the properties window.

   ::: warning
   **Note**: Do not use Process Explorer to end, suspend, or change the priority of processes in this exercise. Administrators should understand the role and business impact of a process before changing its state.
   :::

::: success
**Results**: After completing this task, you have used Process Explorer to examine process relationships, resource usage, and detailed process properties.
:::

### Task 4: Examine Handles and Loaded DLLs

1. [ ] In **Process Explorer**, select **View** > **Show Lower Pane** if the lower pane is not already visible.

2. [ ] Select `explorer.exe` in the upper pane.

3. [ ] Select **View** > **Lower Pane View** > **Handles**.

4. [ ] Review the operating system objects that `explorer.exe` currently has open.

5. [ ] Select **View** > **Lower Pane View** > **DLLs**.

6. [ ] Review the DLLs and memory-mapped files loaded by `explorer.exe`.

7. [ ] Compare the detail available in Process Explorer with the process information shown earlier in Task Manager.

8. [ ] Close **Process Explorer**.

::: success
**Results**: After completing this exercise, you have examined process relationships, properties, handles, and loaded DLLs with Process Explorer.
:::

## Exercise 11: Capture Notepad Activity with Process Monitor

::: secondary
**Scenario**

A single user action can cause many file system, Registry, process, and thread operations. You will use Microsoft Sysinternals Process Monitor to capture these events, filter the display to Notepad, and observe how many events are generated when you create and save a small text file.
:::

### Task 1: Download and Extract Process Monitor

1. [ ] Open **Microsoft Edge**.

2. [ ] In the address bar, enter:

```text
https://learn.microsoft.com/en-us/sysinternals/downloads/procmon
```

3. [ ] On the **Process Monitor** page, review the introduction and the overview of Process Monitor capabilities.

4. [ ] Select **Download Process Monitor**.

5. [ ] When the download completes, select the downloaded `ProcessMonitor.zip` file from the Microsoft Edge downloads list.

6. [ ] In **File Explorer**, select **Extract all**.

7. [ ] Accept the default extraction location.

8. [ ] Verify that **Show extracted files when complete** is selected.

9. [ ] Select **Extract**.

::: success
**Results**: After completing this task, Process Monitor is downloaded and extracted on LON-SVR1.
:::

### Task 2: Run Process Monitor and Prepare the Capture

1. [ ] In the extracted **ProcessMonitor** folder, locate `Procmon64.exe`.

2. [ ] Right-click `Procmon64.exe`.

3. [ ] Select **Run as administrator**.

4. [ ] If a **User Account Control** prompt appears, select **Yes**.

5. [ ] If the **Process Monitor License Agreement** appears, review the agreement and select **Agree**.

6. [ ] If Process Monitor begins capturing events, select **File** > **Capture Events** to stop the capture.

7. [ ] Select **Edit** > **Clear Display** to remove the events already shown.

8. [ ] Verify that the event list is empty.

   ::: warning
   **Note**: Process Monitor can collect a very large number of events in a short time. Stop and clear the initial capture before configuring the focused lab trace.
   :::

::: success
**Results**: After completing this task, Process Monitor is open and ready for a focused capture.
:::

### Task 3: Filter the Display to Notepad

1. [ ] In **Process Monitor**, select **Filter** > **Filter...**.

2. [ ] In the first dropdown, select **Process Name**.

3. [ ] In the comparison dropdown, select **is**.

4. [ ] In the value field, enter `notepad.exe`.

5. [ ] In the action dropdown, verify that **Include** is selected.

6. [ ] Select **Add**.

7. [ ] Verify that the filter list includes:

```text
Process Name is notepad.exe Include
```

8. [ ] Select **OK**.

9. [ ] Verify that the event list remains empty because Notepad has not yet generated any matching events.

   ::: warning
   **Note**: Process Monitor filters are non-destructive. The filter controls which events are displayed, but Process Monitor can still collect events from other processes during the capture.
   :::

::: success
**Results**: After completing this task, the Process Monitor display is filtered to events generated by notepad.exe.
:::

### Task 4: Capture the Creation and Saving of a Text File

1. [ ] In **Process Monitor**, select **File** > **Capture Events** to start capturing.

2. [ ] Select **Start**.

3. [ ] Type **Notepad**.

4. [ ] Select **Notepad** from the search results.

5. [ ] In Notepad, type:

```text
Process Monitor test on LON-SVR1.
This file was created while a filtered trace was running.
```

6. [ ] In Notepad, select **File** > **Save As**.

7. [ ] Browse to `C:\PerfLab`.

8. [ ] In **File name**, enter `Procmon-Notepad-Test.txt`.

9. [ ] Select **Save**.

10. [ ] Close Notepad.

11. [ ] Return to **Process Monitor**.

12. [ ] Select **File** > **Capture Events** to stop capturing.

13. [ ] Review the status bar, which shows the number of displayed events and the total number of captured events.

14. [ ] Record the displayed event count, which is the filtered count for `notepad.exe`, in your lab notes.

   ::: warning
   **Note**: The exact event count varies between systems. The important observation is that typing and saving one small text file can generate many file system, Registry, process, and thread events.
   :::

::: success
**Results**: After completing this task, you have captured and counted the displayed events generated by Notepad while creating and saving a text file.
:::

### Task 5: Examine the Captured Notepad Events

1. [ ] In **Process Monitor**, review the **Time of Day**, **Process Name**, **PID**, **Operation**, **Path**, **Result**, and **Detail** columns.

2. [ ] Select the **Operation** column header to group similar operations visually.

3. [ ] Look for file operations such as **CreateFile**, **WriteFile**, **QueryInformationFile**, and **CloseFile**.

4. [ ] Look for paths that include `Procmon-Notepad-Test.txt`.

5. [ ] Double-click an event associated with `Procmon-Notepad-Test.txt`.

6. [ ] In the **Event Properties** window, review the **Event**, **Process**, and **Stack** tabs.

7. [ ] Select **OK** to close the **Event Properties** window.

8. [ ] Select **Tools** > **Process Tree**.

9. [ ] Locate `notepad.exe` in the process tree and review its process ID and parent process.

10. [ ] Select **Close** to close the process tree.

11. [ ] Close **Process Monitor**.

::: success
**Results**: After completing this exercise, you have used Process Monitor to filter, capture, count, and examine the detailed activity generated by Notepad.
:::

## Exercise 12: Clean Up Temporary Lab Files and Utilities

::: secondary
**Scenario**

You created temporary files to generate disk activity and downloaded portable Sysinternals utilities. You should remove them before finishing the lab so the server is left in a cleaner state.
:::

### Task 1: Remove Temporary Files

1. [ ] Open **File Explorer**.

2. [ ] Open drive `C:`.

3. [ ] Locate the `PerfLab` folder.

4. [ ] Right-click the `PerfLab` folder.

5. [ ] Select **Delete**.

6. [ ] If a confirmation prompt appears, confirm the deletion.

7. [ ] Return to **Windows PowerShell**.

8. [ ] Run the following command to verify that the folder was removed:

```powershell
Test-Path C:\PerfLab
```

9. [ ] Verify that the result is `False`.

::: success
**Results**: After completing this task, you have removed the temporary files used for disk activity.
:::

### Task 2: Remove the Downloaded Sysinternals Files

1. [ ] Open **File Explorer**.

2. [ ] Open the **Downloads** folder for the signed-in user.

3. [ ] Locate the `ProcessExplorer.zip` and `ProcessMonitor.zip` files.

4. [ ] Delete both ZIP files.

5. [ ] Locate the extracted **ProcessExplorer** and **ProcessMonitor** folders.

6. [ ] Delete both extracted folders.

7. [ ] Verify that the ZIP files and extracted folders no longer appear in **Downloads**.

   ::: warning
   **Note**: Process Explorer and Process Monitor are portable utilities, so no application uninstallation is required. In a production environment, follow organizational policy for approved administrative tools and retained diagnostic logs.
   :::

::: success
**Results**: After completing this task, you have removed the downloaded Sysinternals files from LON-SVR1.
:::

## Exercise 13: Record the Administrative Monitoring Summary

::: secondary
**Scenario**

Administrators should be able to summarize what they monitored, what changed, and what evidence supported their conclusion. You will record a brief monitoring summary for the lab.
:::

### Task 1: Complete the Monitoring Summary

Record the following information in your lab notes:

1. [ ] Server monitored: **LON-SVR1**

2. [ ] Tools used:
   - **Task Manager**
   - **Resource Monitor**
   - **Performance Monitor**
   - **Data Collector Sets**
   - **Event Viewer**
   - **Windows PowerShell**
   - **Process Explorer**
   - **Process Monitor**

3. [ ] Data Collector Set created: **LON-SVR1 Baseline**

4. [ ] Counters collected:
   - **Processor(_Total)\% Processor Time**
   - **System\Processor Queue Length**
   - **Memory\Available MBytes**
   - **Memory\Pages/sec**
   - **LogicalDisk(C:)\% Free Space**
   - **PhysicalDisk(_Total)\Avg. Disk sec/Read**
   - **Network Interface\Bytes Total/sec**

5. [ ] Controlled workload generated:
   - CPU activity with Windows PowerShell
   - Disk activity by copying temporary files
   - Network connectivity test to **LON-DC1**

6. [ ] Most visible resource change observed

7. [ ] Event Viewer findings

8. [ ] Number of displayed Notepad events captured in Process Monitor

9. [ ] Process Explorer observations about process relationships, handles, or DLLs

10. [ ] Cleanup completed

::: success
**Results**: You have successfully completed Lab 1101. You can now:

- Use Task Manager to identify real-time resource usage
- Use Resource Monitor to investigate process-level CPU, memory, disk, and network activity
- Use Performance Monitor to add and interpret custom counters
- Create a Data Collector Set to capture a short performance baseline
- Compare idle performance with controlled activity
- Review System and Application logs for supporting evidence
- Validate resource information with PowerShell
- Examine process relationships, properties, handles, and DLLs with Process Explorer
- Filter and capture application activity with Process Monitor
- Record a concise administrative monitoring summary

Proactive performance monitoring helps administrators understand normal server behavior, detect unusual activity, and troubleshoot user reports with evidence instead of guesswork.
:::
