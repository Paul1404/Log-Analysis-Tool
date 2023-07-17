function Get-LastSystemEvents {
    <#
    .SYNOPSIS
    Retrieves the last system events specified by the user and displays them in a grid view.
    .DESCRIPTION
    This function retrieves the last system events as specified by the user from the event log they choose. It creates a custom object for each event and displays them in a grid view using Out-GridView.
    .PARAMETER LogName
    Specifies the event log name from which the events will be retrieved.
    .PARAMETER MaxEvents
    Specifies the maximum number of events to retrieve.
    .PARAMETER Level
    Specifies the level of the events to retrieve.
    .PARAMETER After
    Specifies the start of the date range for the events to retrieve.
    .PARAMETER Before
    Specifies the end of the date range for the events to retrieve.
    .PARAMETER SortBy
    Specifies the property to sort the events by.
    .PARAMETER ExportPath
    Specifies the path of the file where the events will be exported.
    
    .EXAMPLE
    Get-LastSystemEvents -LogName System -MaxEvents 10 -Level Error -After (Get-Date).AddDays(-7)
    
    This example retrieves the last 10 error events from the System log that occurred within the last 7 days.
    
    .EXAMPLE
    Get-LastSystemEvents -LogName Application -MaxEvents 50 -Before (Get-Date).AddHours(-1) -SortBy Provider

    This example retrieves the last 50 events from the Application log that occurred in the last hour and sorts them by Provider name.
    
    .EXAMPLE
    Get-LastSystemEvents -LogName Security -Level Critical -After (Get-Date).AddDays(-30) -SortBy ID

    This example retrieves the critical events from the Security log that occurred in the last 30 days and sorts them by event ID.
    #>

    
    param (
        [string]$LogName = "System",
        [int]$MaxEvents = 10,
        [ValidateSet('Critical', 'Error', 'Warning', 'Information', 'Verbose')][string]$Level,
        [DateTime]$After,
        [DateTime]$Before,
        [string]$ExportPath,
        [ValidateSet('ID', 'Level', 'Provider', 'TimeCreated')][string]$SortBy = "TimeCreated"
    )

    # Build a hash table for the Get-WinEvent parameters
    $winEventParams = @{
        'LogName' = $LogName
        'MaxEvents' = $MaxEvents
    }

    # Level mapping
    $levelMap = @{
        'Critical'    = 1
        'Error'       = 2
        'Warning'     = 3
        'Information' = 4
        'Verbose'     = 5
    }

    # Create an XPath filter string for Get-WinEvent
    $xpathFilter = "*"
    if ($PSBoundParameters.ContainsKey('Level')) {
        $xpathFilter += "[System/Level=$($levelMap[$Level])]"
    }
    if ($PSBoundParameters.ContainsKey('After')) {
        $xpathFilter += "[System/TimeCreated[@SystemTime>='$($After.ToUniversalTime().ToString('o'))']]"
    }
    if ($PSBoundParameters.ContainsKey('Before')) {
        $xpathFilter += "[System/TimeCreated[@SystemTime<='$($Before.ToUniversalTime().ToString('o'))']]"
    }

    $winEventParams['FilterXPath'] = $xpathFilter

    try {
        # Get the system events
        $events = Get-WinEvent @winEventParams
    }
    catch {
        Write-Error -Message "Failed to retrieve system events. Detailed error: $_"
        return
    }
    
    # Create an ArrayList to hold the event data
    $eventData = New-Object System.Collections.ArrayList

    foreach ($event in $events) {
        # Add the object to the array
        $null = $eventData.Add([PSCustomObject]@{
            "ID"          = $event.Id
            "Level"       = $event.LevelDisplayName
            "Provider"    = $event.ProviderName
            "TimeCreated" = $event.TimeCreated
            "Message"     = $event.Message
        })
    }

    # Sort the array by the specified property
    $eventData = $eventData | Sort-Object $SortBy

    if ($PSBoundParameters.ContainsKey('ExportPath')) {
        # Export the data to a CSV file
        try {
            $eventData | Export-Csv -Path $ExportPath -NoTypeInformation
            Write-Output "Events have been successfully exported to $ExportPath."
        }
        catch {
            Write-Error -Message "Failed to export events to $ExportPath. Detailed error: $_"
            return
        }
    }
    else {
        # Display the data in a new window
        $eventData | Out-GridView
    }
}

Export-ModuleMember -Function Get-LastSystem