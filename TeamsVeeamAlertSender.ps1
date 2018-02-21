Param(
	[String]$JobName,
	[String]$Id
)

####################
# Import Functions #
####################
Import-Module "$PSScriptRoot\Helpers"

# Get the config from our config file
$config = (Get-Content "$PSScriptRoot\config\vsn.json") -Join "`n" | ConvertFrom-Json

# Logging
if($config.Debug_Log) {
	Start-Logging "$PSScriptRoot\log\debug.log"
}

# Add Veeam commands
Add-PSSnapin VeeamPSSnapin

# Get the session
$session = Get-VBRBackupSession | ?{($_.OrigJobName -eq $JobName) -and ($Id -eq $_.Id.ToString())}

# Wait for the session to finish up
while ($session.IsCompleted -eq $false) {
	Write-LogMessage 'Info' 'Session not finished Sleeping...'
	Start-Sleep -m 200
	$session = Get-VBRBackupSession | ?{($_.OrigJobName -eq $JobName) -and ($Id -eq $_.Id.ToString())}
}

# Save same session info
$Status = $session.Result
$JobName = $session.Name.ToString().Trim()
$JobType = $session.JobTypeString.Trim()
[Float]$JobSize = $session.BackupStats.DataSize
[Float]$TransfSize = $session.BackupStats.BackupSize

# Report job/data size in B, KB, MB, GB, or TB depending on completed size.
## Job size
If([Float]$JobSize -lt 1KB) {
	[String]$JobSizeRound = [Float]$JobSize
	[String]$JobSizeRound += ' B'
}
ElseIf([Float]$JobSize -lt 1MB) {
	[Float]$JobSize = [Float]$JobSize / 1KB
	[String]$JobSizeRound = [math]::Round($JobSize,2)
	[String]$JobSizeRound += ' KB'
}
ElseIf([Float]$JobSize -lt 1GB) {
	[Float]$JobSize = [Float]$JobSize / 1MB
	[String]$JobSizeRound = [math]::Round($JobSize,2)
	[String]$JobSizeRound += ' MB'
}
ElseIf([Float]$JobSize -lt 1TB) {
	[Float]$JobSize = [Float]$JobSize / 1GB
	[String]$JobSizeRound = [math]::Round($JobSize,2)
	[String]$JobSizeRound += ' GB'
}
ElseIf([Float]$JobSize -ge 1TB) {
	[Float]$JobSize = [Float]$JobSize / 1TB
	[String]$JobSizeRound = [math]::Round($JobSize,2)
	[String]$JobSizeRound += ' TB'
}
### If no match then report in bytes
Else{
	[String]$JobSizeRound = [Float]$JobSize
	[String]$JobSizeRound += ' B'
}
## Transfer size
If([Float]$TransfSize -lt 1KB) {
	[String]$TransfSizeRound = [Float]$TransfSize
	[String]$TransfSizeRound += ' B'
}
ElseIf([Float]$TransfSize -lt 1MB) {
	[Float]$TransfSize = [Float]$TransfSize / 1KB
	[String]$TransfSizeRound = [math]::Round($TransfSize,2)
	[String]$TransfSizeRound += ' KB'
}
ElseIf([Float]$TransfSize -lt 1GB) {
	[Float]$TransfSize = [Float]$TransfSize / 1MB
	[String]$TransfSizeRound = [math]::Round($TransfSize,2)
	[String]$TransfSizeRound += ' MB'
}
ElseIf([Float]$TransfSize -lt 1TB) {
	[Float]$TransfSize = [Float]$TransfSize / 1GB
	[String]$TransfSizeRound = [math]::Round($TransfSize,2)
	[String]$TransfSizeRound += ' GB'
}
ElseIf([Float]$TransfSize -ge 1TB) {
	[Float]$TransfSize = [Float]$TransfSize / 1TB
	[String]$TransfSizeRound = [math]::Round($TransfSize,2)
	[String]$TransfSizeRound += ' TB'
}
### If no match then report in bytes
Else{
	[String]$TransfSizeRound = [Float]$TransfSize
	[String]$TransfSizeRound += ' B'
}

# Job duration
$Duration = $session.Info.EndTime - $session.Info.CreationTime
$TimeSpan = $Duration
$Duration = '{0:00}h {1:00}m {2:00}s' -f $TimeSpan.Hours, $TimeSpan.Minutes, $TimeSpan.Seconds

# Switch for card theme colour
Switch ($Status) {
	None {$Colour = ''}
	Failed {$Colour = 'ff0000'}
	Warning {$Colour = 'ffe100'}
	Success {$Colour = '00ff00'}
	Default {$Colour = ''}
}
# Switch for status image
Switch ($Status) {
	None {$StatusImg = $config.VeeamBRIcon}
	Failed {$StatusImg = $config.JobFailureImage}
	Warning {$StatusImg = $config.JobWarningImage}
	Success {$StatusImg = $config.JobSuccessImage}
	Default {$StatusImg = $config.VeeamBRIcon}
}

# Build the payload
$Card = ConvertTo-Json -Depth 4 @{
	Summary = 'Veeam B&R Report - ' + ($JobName)
	themeColor = $Colour
	sections = @(
		@{
			title = '**Veeam Backup & Replication**'
			activityImage = $StatusImg
			activityTitle = $JobName
			activitySubtitle = (Get-Date -Format U)
			facts = @(
				@{
					name = "Job status:"
					value = $Status
				},
				@{
					name = "Backup size:"
					value = $JobSizeRound
				},
				@{
					name = "Transferred data:"
					value = $TransfSizeRound
				},
				@{
					name = "Dedupe ratio:"
					value = $session.BackupStats.DedupRatio
				},
				@{
					name = "Compress ratio:"
					value =	$session.BackupStats.CompressRatio
				},
				@{
					name = "Duration:"
					value = $Duration
				}
			)
		}
	)
}

# Send report to Teams
Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body $Card -Uri $config.webhook
$Status | Out-File 'C:\Users\Administrator\Desktop\jobstat.txt'
