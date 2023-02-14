<#
Start-LogoffUsersRestartServer
attempts to log off all users, and then Restarts server
perfect for use within Task scheduler (Run As SYSTEM)

Author: u/DoctroSix - https://www.reddit.com/user/DoctroSix/
Date: 02/14/2023
To do: 

#>




# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

[CmdletBinding()]
param()

################################################################
### Functions
################################################################
function Convert-QuserText {
    param(
        [switch]$asTable
    )
    
    ################################################################
    ### Sub-Functions
    ################################################################
    function Convert-TXTtoCSV {
        param(
            [string[]]$Text
        )
    
        # Creates CSV-formatted text array
        [string[]]$csv = @(
            foreach ($line in $Text) {
                # USERNAME
                $line.SubString(0, 23).Trim() + ',' +
                # SESSIONNAME
                $line.SubString(23, 16).Trim() + ',' +
                # ID
                $line.Substring(39, 5).Trim() + ',' +
                # STATE
                $line.Substring(46, 8).Trim() + ',' +
                # IDLE TIME
                $line.Substring(54, 9).Trim() + ',' +
                # LOGON TIME
                $line.Substring(65).Trim()
            }
        )
        # Converts CSV text array to [PSCustomObject] array
        [PSCustomObject[]]$pwshObj = $csv | ConvertFrom-Csv
        return $pwshObj
    }
    
    function Convert-UserName {
        param(
            [string]$txt
        )
    
        # looks for '>' prefix on username
        # Exec = $true when it's got the prefix, Otherwise Exec = $false
        if ($txt[0] -eq '>') {
            $userInfo = [PSCustomObject]@{
                Name = $txt.Substring(1).Trim()
                Exec = $true
            }
        }
        else {
            $userInfo = [PSCustomObject]@{
                Name = $txt.Trim()
                Exec = $false
            }
        }
        return $userInfo
    }
    
    function Convert-TXTtoSpan {
        param(
            [string]$txt
        )
    
        # converts TXT timestamp from quser.exe to a [TimeSpan]
        [string]$idleTimeRaw = $txt
        if ( $idleTimeRaw -eq '.' ) {
            [timespan]$idleTime = New-TimeSpan -Seconds 0
        }
        elseif ( $idleTimeRaw.ToCharArray() -contains '+') {
            $days = $idleTimeRaw.Split('+')[0]
            $hours = $idleTimeRaw.Split('+')[1].Split(':')[0]
            $mins = $idleTimeRaw.Split('+')[1].Split(':')[1]
            [timespan]$idleTime = New-TimeSpan -Days $days -Hours $hours -Minutes $mins
        }
        elseif ( $idleTimeRaw.ToCharArray() -contains ':' ) {
            $hours = $idleTimeRaw.Split(':')[0]
            $mins = $idleTimeRaw.Split(':')[1]
            [timespan]$idleTime = New-TimeSpan -Hours $hours -Minutes $mins
        }
        else {
            [timespan]$idleTime = New-TimeSpan -Minutes $idleTimeRaw
        }
    
        return $idleTime
    }
    
    ################################################################
    ### Convert-QuserText Main
    ################################################################
    
    # assigns powershell alias to quser.exe
    $quserPath = Join-Path -Path $Env:SystemRoot -ChildPath 'System32\quser.exe'
    Set-Alias -Name 'Get-QuserOutput' -Value (Get-Item -Path $quserPath)
    
    ($txtOutput = Get-QuserOutput 2>&1) | Out-null

    # Checks for an empty userlist, and handles false error positives
    $outputType = $txtOutput.GetType().FullName
    $isErrorRecord = $outputType -eq 'System.Management.Automation.ErrorRecord'
    if ($isErrorRecord) {
        [string]$errTXT = $txtOutput.CategoryInfo.TargetName
        $goodError = $errTXT -eq 'No User exists for *'
        if ($goodError) {
            [PSCustomObject[]]$quserLogins = @(
                [PSCustomObject]@{
                    UserName      = ''
                    SessionName   = ''
                    ID            = $null
                    State         = 'NoLogins'
                    IdleTime      = New-TimeSpan -Seconds 0
                    LogonTime     = $null
                    ExecutingUser = $false
                }
            )
            return $quserLogins
        }
        else {
            Throw "Unspecified quser error"
        }
    }
    else {
        [PSCustomObject[]]$stringDataRaw = Convert-TXTtoCSV -Text $txtOutput
    }
    
    # Convert each column to appropriate datatype
    # Add 'ExecutingUser' column
    # USERNAME = string, and detect '>' prefix
    # SESSIONNAME = string, or null
    # ID = Int32
    # STATE = string
    # IDLE TIME = timespan
    # LOGON TIME = DateTime
    # ExecutingUser = boolean. (the user that ran this script)
    #   only true if '>' prefix on username
    #   added to identify the user running script on an active session
    
    [PSCustomObject[]]$quserLogins = @(
        foreach ($item in $stringDataRaw) {
            [PSCustomObject]$userInfo = Convert-UserName -txt $item.USERNAME
            $loginObj = [PSCustomObject]@{
                UserName      = $userInfo.Name
                SessionName   = $item.SESSIONNAME.ToString()
                ID            = $item.ID.ToInt32($null)
                State         = $item.STATE.ToString()
                IdleTime      = Convert-TXTtoSpan -txt $item.'IDLE TIME'
                LogonTime     = Get-Date -Date $item.'LOGON TIME'
                ExecutingUser = $userInfo.Exec
            }
            $loginObj
            Remove-Variable -Name 'loginObj'
        }
    )
    
    if ($asTable) {
        $quserLogins | Sort-Object ID | Format-Table -Property @(
            'UserName',
            'SessionName',
            'ID',
            'State',
            @{
                Name       = 'IdleTime'
                Expression = 'IdleTime'
                Alignment  = 'Right'
            },
            @{
                Name       = 'LogonTime'
                Expression = { Get-Date -Date $_.LogonTime -Format 'yyyy-MM-dd hh:mm tt' }
                Alignment  = 'Right'
            },
            'ExecutingUser'
        )
    }
    else {
        return $quserLogins
    }
}

Function Disconnect-Users {
    # starts Logoff off all users
    param(
        [PSCustomObject[]]$ids
    )

    $logoffCMDpath = Join-Path -Path $ENV:windir -ChildPath 'System32\logoff.exe'
    $logoffCMDObj = Get-Item -Path $logoffCMDpath
    Set-Alias -Name 'Start-Logoff' -Value $logoffCMDObj

    foreach ($logon in $ids) {
        $notExecUser = -not $logon.ExecutingUser
        $logonID = $logon.ID.ToString()
        if ($notExecUser) {
            Start-Logoff $logonID
        }
    }
}

function Start-ServerReboot {
    # uses shutdown.exe for backwards compatibility
    # powershell's Restart-Computer may trigger 'unknown shutdown' 
    # warnings on older servers after reboot
    $exe = Join-Path -Path $env:windir -ChildPath 'System32\shutdown.exe'
    $comment = "`"Scheduled Restart`""
    $argList = @(
        '/r'
        '/t 1'
        '/d p:1:1'
        ('/c ' + $comment)
    )

    $splat = @{
        FilePath     = $exe
        ArgumentList = $argList
    }
    Start-Process @splat
}


################################################################
### Main
################################################################

[PSCustomObject[]]$userLogons = Convert-QuserText

$nologins = (
    ($userLogons[0].State -eq 'NoLogins') -or
    (
        ($userLogons.Length -eq 1) -and
        ($userLogons[0].ExecutingUser)
    )
)
[bool]$loginsActive = -not ($nologins)
If ($loginsActive) {
    Disconnect-Users -ids $userLogons
}

# Waits for a few minutes for all users to be logged off
# will Halt script if logoffs are freezing or hanging
# continues to check for active logins every 15s
[int]$minutes = 8
[datetime]$now = Get-Date
[datetime]$timeout = $now.AddMinutes($minutes)
if ($loginsActive) {
    do {
        Start-Sleep -Seconds 15
        [PSCustomObject[]]$userLogons = Convert-QuserText
        $nologins = (
            ($userLogons[0].State -eq 'NoLogins') -or
            (
                ($userLogons.Length -eq 1) -and
                ($userLogons[0].ExecutingUser)
            )
        )
        If ($nologins) {
            $loginsActive = $false
            break
        }
        $now = Get-Date
    }
    while ( $now -lt $timeout )
}

If ($loginsActive) {
    Throw "User logons are still active after " + $minutes.ToString() + " minutes"
}
else {
    Start-ServerReboot
}