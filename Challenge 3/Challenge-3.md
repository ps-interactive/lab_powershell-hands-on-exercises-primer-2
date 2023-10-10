# Monitoring Disk Space Usage with PowerShell Challenge

## Overview

In this challenge, you will use a PowerShell script to monitor disk space usage on your Windows computer. The script will retrieve partition information, calculate used and free space, and alert you when free space drops below a threshold.  

## Requirements

- Windows 10 or Windows Server 2016 or later
- Administrative privileges  
- PowerShell 5.0 or later
- Visual Studio Code
- PowerShell Extension for VS Code

## Steps

1. Open Visual Studio Code and open the PowerShell Extension.

2. Copy the PowerShell script below and paste it into the PowerShell session in VS Code.

    ```powershell
    # Script code goes here
    ```

![Pasting the script into PowerShell in VS Code](images/paste-script.png)

3. Run the script by pressing Enter. This will output partition information including total, used, and free space.

![Sample output from the partition info script](images/script-output.png)

4. Notice the script has a `while` loop to retrieve partition info every 10 seconds. Let this run for a bit and observe the output.

5. To test the threshold alert, modify the `$thresholdInPercent` variable to a higher value like 90. This will trigger the warning when free space drops below 90%.

![Modifying the threshold variable to 90%](images/threshold-90.png)

6. Run the script again. When a partition's free space drops below 90%, you should see a warning message displayed for that partition.

![Warning message displayed when free space is below threshold](images/warning.png)

7. To stop the loop, press CTRL+C in the PowerShell session.

This completes the walkthrough of using PowerShell to monitor disk space! You can customize the script further to suit your needs.
