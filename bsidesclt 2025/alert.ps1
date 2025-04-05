param(
    [Parameter(Mandatory = $true)]
    [string]$threat,

    [Parameter(Mandatory = $true)]
    [string]$user,

    [Parameter(Mandatory = $true)]
    [string]$path,

    [Parameter(Mandatory = $true)]
    [string]$hostname
)

try {
    # Create the content to write to the file
    $Content = @(
		"Defender detected $threat on $hostname for $user.`nPath: $path"
    )
	$Content = $Content -replace "http", "hxxp"
	try{
	$webhookUrl = "<HOOK URL>"
    $body = @{
        text = "$Content"
    } | ConvertTo-Json
    
    Invoke-WebRequest -Uri $webhookUrl -UseBasicParsing -Method Post -Body $body -ContentType "application/json"
	} catch {
		 $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  $errorMessage = $_.Exception.Message
  $errorRecord = $_
    
  # Format the error message with timestamp and details
  $logMessage = "[$timestamp] Error: $errorMessage`n`tDetails: $($errorRecord | Out-String)"

  # Append the error message to the log file
  Add-Content -Path "C:\errorlog.txt" -Value $logMessage
	}
    # Write the content to the specified file
    $Content | Out-File -FilePath "C:\alert_out.txt" -Encoding UTF8

} catch {
}