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
    .EXAMPLE
       Get-LastSystemEvents -LogName System -MaxEvents 10 -Level Error -After (Get-Date).AddDays(-7)
    #>
    param (
        [string]$LogName = "System",
        [int]$MaxEvents = 10,
        [ValidateSet('Critical', 'Error', 'Warning', 'Information', 'Verbose')][string]$Level,
        [DateTime]$After,
        [DateTime]$Before
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

    # Get the system events
    $events = Get-WinEvent @winEventParams

    # Create an ArrayList to hold the event data
    $eventData = New-Object System.Collections.ArrayList

    foreach ($event in $events) {
        # Create a custom object for each event
        $eventObj = New-Object PSObject -Property @{
            "ID"          = $event.Id
            "Level"       = $event.LevelDisplayName
            "Provider"    = $event.ProviderName
            "TimeCreated" = $event.TimeCreated
            "Message"     = $event.Message
        }

        # Add the object to the array
        $null = $eventData.Add($eventObj)
    }

    # Display the data in a new window
    $eventData | Out-GridView
}

Export-ModuleMember -Function Get-LastSystemEvents
