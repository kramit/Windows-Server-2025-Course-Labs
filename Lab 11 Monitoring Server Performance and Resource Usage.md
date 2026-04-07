# Practice Lab 1101: Monitoring Server Performance and Resource Usage

## Summary

::: secondary
In this lab, you will use Windows Server tools to monitor system performance. You will check CPU, memory, disk, and network usage. Performance monitoring helps identify bottlenecks and ensure the server is healthy.
:::

### Prerequisites

::: secondary
To complete this lab, you must have:
- Completed Lab 0401 (PowerShell Command-Line Administration)
- Administrator access to LON-SRV1
- Understanding of system resources (CPU, Memory, Disk)
:::

## Exercise 1: Using Task Manager for Real-Time Monitoring

::: secondary
**Scenario**

Task Manager provides real-time monitoring of system resources. You will use it to identify resource usage by application.
:::

### Task 1: Open Task Manager and View Performance

1. [ ] Connect to LON-SRV1 using Remote Desktop.
2. [ ] Right-click on the **Windows Start button** or press **Windows key + X**.
3. [ ] Click on **Task Manager**.
4. [ ] Task Manager will open. Click on the **Performance** tab.
5. [ ] You will see four graphs:
   - **CPU**: Processor usage (should be low at idle, typically 0-5%)
   - **Memory**: RAM usage (should show used vs. total)
   - **Disk**: Disk I/O activity
   - **Network**: Network activity
6. [ ] Look at the **CPU** section:
   - **Utilization**: Current percentage of CPU being used
   - **Speed**: Current processor clock speed
   - **Processes**: Number of processes running
   - **Threads**: Number of threads running
7. [ ] Look at the **Memory** section:
   - **In use**: RAM currently being used
   - **Available**: RAM still available
   - **Committed**: Memory committed (in use + reserved)

::: success
**Results**: After completing this task, you understand real-time performance monitoring.
:::

### Task 2: Create Load to Test Monitoring

1. [ ] To generate some CPU load, open PowerShell and run a simple calculation:

```powershell
$sum = 0; for($i=0; $i -lt 100000000; $i++) { $sum += $i }; Write-Host "Calculation complete"
```

2. [ ] While this runs, watch the Task Manager Performance tab.
3. [ ] You should see the **CPU** graph spike upward indicating increased processor usage.
4. [ ] When complete, the CPU graph should return to normal levels.

::: success
**Results**: After completing this task, you have observed CPU usage changes.
:::

## Exercise 2: Using Performance Monitor

::: secondary
**Scenario**

Performance Monitor provides detailed performance tracking with customizable counters and logging capabilities. You will set up a performance monitoring session.
:::

### Task 1: Open Performance Monitor

1. [ ] In Server Manager, click **Tools** menu.
2. [ ] Click **Performance Monitor**.
3. [ ] Performance Monitor will open showing a graph view.
4. [ ] On the left panel, click **Performance Monitor** to see real-time graphing.
5. [ ] The display will show a real-time graph with several colored lines representing different performance counters.

### Task 2: Add Performance Counters

1. [ ] In Performance Monitor, click the **+** (green plus) button on the toolbar.
2. [ ] The **Add Counters** dialog will open.
3. [ ] You will see:
   - **Select counters from computer**: Choose which computer to monitor
   - **Available counters**: Counters you can monitor
4. [ ] Expand **Processor** by clicking the arrow.
5. [ ] Select **% Processor Time** (shows overall CPU usage).
6. [ ] Click **Add >** to add this counter to the display.
7. [ ] Expand **Memory**.
8. [ ] Select **Available MBytes**.
9. [ ] Click **Add >**.
10. [ ] Expand **PhysicalDisk**.
11. [ ] Select **Disk Time (%)**.
12. [ ] Click **Add >**.
13. [ ] Click **OK** to close the dialog.

::: success
**Results**: After completing this task, Performance Monitor is displaying three key performance counters.
:::

### Task 3: Observe Performance Trends

1. [ ] Watch the graph as the counters update in real-time.
2. [ ] Each colored line represents one counter:
   - Red might be CPU usage
   - Blue might be Available Memory
   - Green might be Disk Time
3. [ ] Normal server behavior shows:
   - CPU: Usually low (0-10%), spikes during activity
   - Available Memory: Should be above 0 MBytes (if it reaches 0, server may slow down)
   - Disk Time: Low during idle, increases during file operations
4. [ ] These baselines help you identify problems later.

::: success
**Results**: After completing this task, you understand how to observe performance trends.
:::

## Exercise 3: Using Resource Monitor

::: secondary
**Scenario**

Resource Monitor shows detailed information about resource usage by individual processes. You will use it to identify which applications consume the most resources.
:::

### Task 1: Open Resource Monitor

1. [ ] Close Performance Monitor.
2. [ ] In Server Manager **Tools** menu, click **Resource Monitor**.
3. [ ] Resource Monitor will open with several tabs:
   - **Overview**: Summary of all resources
   - **CPU**: CPU usage by process
   - **Memory**: Memory usage by process
   - **Disk**: Disk activity by process
   - **Network**: Network activity by process

### Task 2: Analyze Process Resource Usage

1. [ ] Click on the **CPU** tab.
2. [ ] You will see a list of processes with columns:
   - **Image**: Process name (e.g., System, csrss, services)
   - **PID**: Process ID
   - **Description**: What the process is
   - **CPU %**: Percentage of CPU the process is using
   - **Avg. CPU Time**: Average CPU time per operation
3. [ ] Look for any process using significant CPU (more than 5% when idle).
4. [ ] High CPU usage by an unexpected process might indicate a problem.

### Task 3: Monitor Memory Usage

1. [ ] Click on the **Memory** tab.
2. [ ] You will see processes sorted by memory usage.
3. [ ] Look at the columns:
   - **Image**: Process name
   - **Memory (Private)**: Unique memory used by the process
   - **Memory (Working Set)**: Total memory used by the process
4. [ ] Normal Windows Server processes (System, services, etc.) should use reasonable memory.
5. [ ] If a third-party application uses more than 50% of total memory, it might need investigation.

::: success
**Results**: After completing this task, you can identify resource-hungry processes.
:::

## Exercise 4: Using PowerShell for Performance Analysis

::: secondary
**Scenario**

PowerShell can gather performance data programmatically and is useful for automated monitoring and alerts.
:::

### Task 1: Check CPU and Memory Usage

1. [ ] Open PowerShell as Administrator.
2. [ ] Type the following command:

```powershell
Get-Process | Select-Object Name, @{Name="CPUPercent";Expression={$_.CPU}}, @{Name="MemoryMB";Expression={$_.WorkingSet/1MB}} | Where-Object {$_.MemoryMB -gt 50} | Sort-Object MemoryMB -Descending | Format-Table
```

3. [ ] Press **Enter**.
4. [ ] This shows processes using more than 50 MB of memory.

### Task 2: Check Disk Space Usage

1. [ ] Type the following command:

```powershell
Get-Volume | Select-Object DriveLetter, FileSystem, Size, @{Name="SizeGB";Expression={$_.Size/1GB}}, @{Name="FreeGB";Expression={$_.SizeRemaining/1GB}}, @{Name="PercentUsed";Expression={[Math]::Round((($_.Size - $_.SizeRemaining) / $_.Size) * 100, 2)}} | Format-Table
```

2. [ ] Press **Enter**.
3. [ ] This shows disk usage in gigabytes and percentage used.
4. [ ] If any disk is more than 90% full, it needs attention.

::: success
**Results**: After completing this task, you can analyze performance using PowerShell.
:::

## Exercise 5: Identifying Performance Baselines

::: secondary
**Scenario**

A baseline is normal performance under typical load. Comparing current performance to a baseline helps identify problems.
:::

### Task 1: Establish Performance Baseline

Your server baseline (when idle with normal services running) should be:

1. **CPU Usage**: 0-10%
2. **Memory Available**: At least 20% of total RAM
3. **Disk Usage**: Less than 80% of capacity
4. **Network**: Low utilization (depends on environment)

If current metrics exceed these baselines, investigate what's changed:
- New application installed?
- Increased user load?
- Process consuming unusual resources?
- Disk filling up unexpectedly?

::: success
**Results**: After completing this task, you understand performance baselines.
:::

## Exercise 6: Identifying Performance Problems

::: secondary
**Scenario**

You should know the warning signs of performance problems.
:::

### Task 1: Recognize Performance Issues

**CPU Issues**:
- CPU consistently above 80%
- Server responses slow
- Applications hang or freeze

**Memory Issues**:
- Available memory near 0%
- Page file usage very high
- Performance degrades significantly

**Disk Issues**:
- Drive over 90% capacity
- Disk consistently at high activity
- Slow file operations

**Network Issues**:
- Network adapter showing errors
- High percentage utilization
- Packet loss indicated

If you observe these signs, troubleshoot by:
1. Identifying the problematic process with Resource Monitor
2. Checking Event Viewer for errors
3. Checking for recent configuration changes
4. Contacting application vendor if it's a third-party application

::: success
**Results**: After completing this task, you can identify performance problems.
:::

## Exercise 7: Summary and Verification

::: secondary
**Scenario**

You have learned multiple ways to monitor server performance.
:::

### Task 1: Review Monitoring Tools

You have learned:

1. **Task Manager**: Quick real-time view of resources
2. **Performance Monitor**: Detailed tracking with custom counters
3. **Resource Monitor**: Process-level resource analysis
4. **PowerShell**: Programmatic performance data gathering
5. **Baselines**: Normal performance for comparison
6. **Problem identification**: Warning signs of issues

::: success
**Results**: You have successfully completed Lab 1101. You now understand:
- How to use Task Manager for real-time monitoring
- How to use Performance Monitor with custom counters
- How to use Resource Monitor for process analysis
- How to use PowerShell for performance data
- How to establish and use performance baselines
- How to identify performance problems

Proactive performance monitoring helps prevent server issues. In future labs, you will configure advanced monitoring and alerting.
:::
