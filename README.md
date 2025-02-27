# PowerShell Scripts Portfolio

Welcome to my Powershell scripts Portifolio! Below a collection of scripts that I created for many different tasks, I will regularly upload more codes.  
[My LinkedIn Profile](https://linkedin.com/in/angelo-polatto)

Created: 13/Feb/2025  
Last Update: 26/Feb/2025

## Scripts List

### Script 1: # Copy Files Remotely – PowerShell GUI Tool (2019)

## Overview  
This project is a PowerShell-based GUI application designed to facilitate **remote file browsing and transfer**. It was developed as a study case to explore the capabilities of **PowerShell remoting, multi-threading, and GUI design**. The script provides an interactive interface for copying files from remote systems while maintaining responsiveness and efficiency.  

## Key Features  
- **Graphical User Interface (GUI):** Built using Windows Forms for an intuitive user experience.  
- **Remote File System Browsing:** Dynamically assembles and displays remote directory structures.  
- **Optimized Remote File Copying:** Transfers files in controlled chunks to ensure reliability.  
- **Multi-Threading with Runspaces:** Keeps the UI responsive while handling operations in the background.  
- **Progress Tracking & Logging:** Provides real-time feedback and logs operations for auditing.  

## Technical Highlights  
This project incorporates several advanced PowerShell techniques:  

### 1. Remote File Copying with Chunked Transfers  
Rather than using a simple `Copy-Item` approach, this script implements a method to **split large files into smaller parts** (4096-byte chunks) during remote transfers. This helps ensure stability over network connections and allows **fine-grained progress tracking**.  

### 2. Dynamic Remote Tree Assembly  
The script includes a **custom recursive method to query remote file systems**, assembling the directory structure dynamically. This process:  
- Uses **PowerShell remoting (`New-PSSession`)** to execute queries efficiently.  
- Leverages **runspaces** for parallel execution, improving performance.  
- Implements **custom logic to filter system and hidden files** when needed.  

### 3. Multi-Threading for Performance & UI Responsiveness  
Unlike conventional PowerShell scripts that can become unresponsive during execution, this project utilizes **runspaces** to process tasks asynchronously. This allows:  
- The GUI to remain interactive while background operations run.  
- Multiple tasks to execute in parallel without blocking user input.  
- Improved efficiency when handling large datasets.  

### 4. Robust Error Handling & Logging  
- Operations are logged in real-time within the application.  
- The script can write entries to the **Windows Event Log**, making it useful for enterprise environments.  
- Detailed error handling ensures graceful recovery from failures.  

## Project Intent & Learning Outcomes  
This project was developed as a **study case to explore the limits of PowerShell scripting**. It demonstrates:  
- **A structured approach to building complex PowerShell applications.**  
- **Best practices in GUI development and user interaction within PowerShell.**  
- **A deeper understanding of PowerShell remoting, session management, and concurrency.**  

While this is a personal learning project, the methods used here could be valuable in real-world automation scenarios, particularly in **enterprise IT environments requiring remote file management solutions**.  

## Final Thoughts  
This project represents an exploration of **what is possible with PowerShell beyond traditional scripting**. The focus was on **building a functional, efficient, and user-friendly tool**, while also learning about **PowerShell’s strengths and limitations in GUI development, remoting, and parallel execution**.  

Any feedback or suggestions for improvement are always welcome!  


<img src="Scripts/Images/Copy_Files_Remotely_Beta.jpg" alt="Copy Files Remotely Beta GUI" width="350" />

**Script's Path:** [Scripts/Copy_Files_Remotely_Beta.ps1](Scripts/Copy_Files_Remotely_Beta.ps1)

### Script 2: Reset Password Remotely (2019)
After learning a bit about the concept of threads I started developing small other pieces of code to help the IT staff.
This one allows you to reset an user local account password in a remote computer.

<img src="Scripts/Images/Reset_Computer_Pass.png" alt="Reset Password Remotely GUI" width="350" />

**Script's Path:** [Scripts/Reset_Password_Remotely.ps1](Scripts/Reset_Password_Remotely.ps1)

### Script 3: Coming soon
