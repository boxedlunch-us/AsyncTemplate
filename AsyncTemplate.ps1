#get current script directory 
$ScriptDir = Split-Path $script:MyInvocation.mycommand.path

# JSON data; can also be a URL
$json = "\\servername\http_host\data\server_data.json"

# Retrieve daily server list content
$serverInfo = (Get-Content $json) -join "`n" | ConvertFrom-Json

#convert into searchable object
$serverInfo = $serverInfo.data



foreach ($server in $serverInfo) {
    $running = @(Get-Job | Where-Object { $_.State -eq 'Running' })
    if ($running.Count -ge 4) {
        $running | Wait-Job -Any | Out-Null
    }

    Write-Host "Starting job for " $server.hostname
    Start-Job {
        # dew something
        # then return it
        
    } | Out-Null
}

# Wait for all jobs to complete and results ready to be received
Wait-Job * | Out-Null

# Process the results
foreach($job in Get-Job)
{
    
    $result = Receive-Job $job
    Write-Host $result
}

Remove-Job -State Completed