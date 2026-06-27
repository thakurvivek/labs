# Ubuntu 24.04 CPU Fan Control & Troubleshooting Summary

This document summarizes the process of diagnosing and configuring CPU fan control on an Ubuntu 24.04 desktop workstation.

## Problem Statement

The initial goal was to control the CPU fan speed on an Ubuntu Server 24.04 desktop workstation. The primary obstacle was the error message received when attempting to run the standard fan configuration utility:



This indicated that the kernel did not have the necessary drivers loaded to communicate with the motherboard's fan controller.

## Journey to Solution

The process involved several key steps, from hardware detection to configuration and validation.

1.  **Hardware Detection**: The `sensors-detect` script was used to probe the system for hardware monitoring chips. Answering "yes" to all questions was crucial for a thorough scan.

2.  **Identifying the Correct Module**: The `nct6775` kernel module was identified as the correct driver for the motherboard's Super I/O chip. This was confirmed by manually loading the module (`sudo modprobe nct6775`) and then successfully finding PWM control files in `/sys/devices/platform/nct6775.2592/hwmon/hwmon4/`.

3.  **Running `pwmconfig`**: With the `nct6775` module loaded, the `sudo pwmconfig` script ran successfully. It correctly identified that the fan at `hwmon4/fan1_input` was controlled by the PWM controller at `hwmon4/pwm2`.

4.  **Mapping the Temperature Sensor**: A critical step was selecting the correct temperature sensor to base the fan control on. By analyzing the output of the `sensors` command, we correctly chose `hwmon0/temp1_input` (a reading from the `coretemp` driver) as the source for the CPU temperature, avoiding the motherboard sensors on `hwmon4`.

5.  **Generating the Initial Config**: This process generated a basic `/etc/fancontrol` configuration file with a simple linear fan curve.

6.  **Stress Testing**: The `stress-ng` utility was used to place a heavy load on the CPU, allowing us to monitor and validate that the fan speed increased in direct response to the rising CPU temperature, confirming the configuration was working.

7.  **Addressing Faulty Sensors**: The `sensors` output revealed several sensors (`AUXTIN1/2/3` and various voltage inputs) on the `nct6779` chip reporting spurious data (e.g., 106°C, 0V). We correctly diagnosed this as a common issue with unused motherboard sensor inputs and determined they could be safely ignored.

8.  **Fixing the Login Message**: The same faulty sensor was causing the Ubuntu welcome message (motd) to display an alarming and incorrect 107°C temperature. We identified the responsible script within `/etc/update-motd.d/` and disabled it using `sudo chmod -x <script_name>`.

## Key Findings

*   **The Key Driver**: The `nct6775` kernel module was essential for enabling fan control on this specific motherboard.
*   **Fan Mapping**: The main CPU fan was controlled by `hwmon4/pwm2` and its speed was reported by `hwmon4/fan1_input`.
*   **Correct Temp Sensor**: The correct CPU temperature sensor for fan control was `hwmon0/temp1_input` (from the `coretemp` driver), not any of the sensors on the `nct6775` chip itself.
*   **Faulty Sensors**: Multiple sensors (`AUXTIN1/2/3` and several voltage inputs) on the `nct6779` chip were reporting spurious data (106°C, 0V) and should be ignored.

## Learnings

*   **Hardware Dependency**: Fan control in Linux is highly dependent on motherboard-specific kernel drivers. The "no pwm-capable modules" error often means the right driver isn't loaded.
*   **`sensors-detect` is Crucial**: This script is the first and most important step in identifying the correct hardware drivers.
*   **Sensor Interpretation**: Not all sensor readings are valid. It's crucial to cross-reference and identify which sensors correspond to actual hardware (like the CPU) and which are unused or faulty.
*   **`fancontrol` Limitations**: The standard `fancontrol` utility only supports a simple two-point (linear) fan curve. For more advanced, multi-point curves, a tool like `CoolerControl` would be required.
*   **motd is Customizable**: The message of the day is a collection of scripts in `/etc/update-motd.d/` that can be easily enabled or disabled by changing file permissions.

## Final Configuration

The final, working `/etc/fancontrol` configuration file:



This configuration sets the fan to start ramping up at 60°C and reach its maximum speed (PWM 195) at 77°C.

## Useful Commands

*   **Detect hardware sensors**: `sudo sensors-detect`
*   **Monitor temperatures and fan speeds**: `sensors`
*   **Monitor specific values in real-time**: `watch -n 2 "sensors | grep -E 'hwmon0/temp1_input|hwmon4/fan1_input'"`
*   **Run fan configuration script**: `sudo pwmconfig`
*   **Start/stop fan control service**: `sudo systemctl start/stop fancontrol`
*   **Enable/disable fan control on boot**: `sudo systemctl enable/disable fancontrol`
*   **Stress test the CPU**: `stress-ng --cpu 0 --timeout 300s`
*   **Disable a motd script**: `sudo chmod -x /etc/update-motd.d/<script_name>`
