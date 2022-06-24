# Veeam Backup and Restore Notifications for Teams

## VeeamTeamsNotifications has been replaced by [VeeamNotify](https://github.com/tigattack/VeeamNotify).

This repository is now archived.

---

Sends notifications from Veeam Backup & Restore to Teams

![Chat Example](https://raw.githubusercontent.com/tigattack/VeeamTeamsNotifications/master/asset/img/screens/sh-2.png)    
[Better example.](https://raw.githubusercontent.com/tigattack/VeeamTeamsNotifications/master/asset/img/screens/sh-4.png)

---
## [Slack fork.](https://github.com/tigattack/VeeamSlackNotifications)
## [MS Teams fork.](https://github.com/tigattack/VeeamTeamsNotifications)
---
## Teams setup

Make a scripts directory: `C:\VeeamScripts`

```powershell
# To make the directory run the following command in PowerShell
New-Item C:\VeeamScripts PowerShell -type directory
```

#### Get code

Then clone this repository:

```shell
cd C:\VeeamScripts
git clone https://github.com/tigattack/VeeamTeamsNotifications.git
cd VeeamTeamsNotifications
```

Or without git:

Download release, there may be later releases take a look and replace the version number with newer release numbers.
Unzip the archive and make sure the folder is called: `VeeamTeamsNotifications`
```powershell
Invoke-WebRequest -Uri https://github.com/tigattack/VeeamTeamsNotifications/archive/v1.1.zip -OutFile C:\VeeamScripts\VeeamTeamsNotifications-v1.1.zip
```

#### Extract and clean up
```shell
Expand-Archive C:\VeeamScripts\VeeamTeamsNotifications-v1.1.zip -DestinationPath C:\VeeamScripts
Ren C:\VeeamScripts\VeeamTeamsNotifications-1.1 C:\VeeamScripts\VeeamTeamsNotifications
rm C:\VeeamScripts\VeeamTeamsNotifications-v1.1.zip
```

#### Configure the project:
Make a new config file
```shell
cp C:\VeeamScripts\VeeamTeamsNotifications\config\vsn.example.json C:\VeeamScripts\VeeamTeamsNotifications\config\vsn.json
```
 Edit your config file. You must replace the webhook field with your own Teams url.
 ```shell
notepad.exe C:\VeeamScripts\VeeamTeamsNotifications\config\vsn.json
```

Finally open Veeam and configure your jobs. Edit them and click on the <img src="asset/img/screens/sh-3.png" height="20"> button.

Navigate to the "Scripts" tab and paste the following line the script that runs after the job is completed:

```shell
Powershell.exe -File C:\VeeamScripts\VeeamTeamsNotifications\TeamsNotificationBootstrap.ps1
```

![screen](asset/img/screens/sh-1.png)

---
