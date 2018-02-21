# Veeam Backup and Restore Notifications for Slack

Sends notifications from Veeam Backup & Restore to Slack

![Chat Example](https://raw.githubusercontent.com/tigattack/VeeamSlackNotifications/1d6bd61e93a11ce22e1d228d6f30deadc7c91489/asset/img/screens/sh-2.png)

---
## [Discord Setup](https://blog.tiga.tech/veeam-b-r-notifications-in-discord/)

## Slack Setup

Make a scripts directory: `C:\VeeamScripts`

```powershell
# To make the directory run the following command in PowerShell
New-Item C:\VeeamScripts PowerShell -type directory
```

#### Get code

Then clone this repository:

```shell
cd C:\VeeamScripts
git clone https://github.com/tigattack/VeeamSlackNotifications.git
cd VeeamSlackNotifications
git checkout master
```

Or without git:

Download release, there may be later releases take a look and replace the version number with newer release numbers.
Unzip the archive and make sure the folder is called: `VeeamSlackNotifications`
```powershell
Invoke-WebRequest -Uri https://github.com/tigattack/VeeamSlackNotifications/archive/2.1.zip -OutFile C:\VeeamScripts\VeeamSlackNotifications-v1.0.zip
```

Configure the project:

```shell
# Make a new config file
cp C:\VeeamScripts\VeeamSlackNotifications\config\vsn.example.json C:\VeeamScripts\VeeamSlackNotifications\config\vsn.json
# Edit your config file. You must replace the webhook field with your own slack url.
notepad.exe C:\VeeamScripts\VeeamSlackNotifications\config\vsn.json
```

Finally open Veeam and configure your jobs. Edit them and click on the <img src="asset/img/screens/sh-3.png" height="20"> button.

Navigate to the "Scripts" tab and paste the following line the script that runs after the job is completed:

```shell
Powershell.exe -File C:\VeeamScripts\VeeamSlackNotifications\SlackNotificationBootstrap.ps1
```

![screen](asset/img/screens/sh-1.png)

---

## Example Configuration:

Below is an example configuration file.

```shell
{
	"webhook": "https://...",
	"channel": "#veeam",
	"service_name": "Veeam B&R",
	"icon_url": "https://raw.githubusercontent.com/tigattack/VeeamSlackNotifications/master/asset/img/icon/VeeamB%26R.png",
	"debug_log": false
}
```
