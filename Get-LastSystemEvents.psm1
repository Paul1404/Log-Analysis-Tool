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
    .EXAMPLE
       Get-LastSystemEvents -LogName System -MaxEvents 10
    #>
    param (
        [string]$LogName = "System",
        [int]$MaxEvents = 10
    )

    # Get the system events
    $events = Get-WinEvent -LogName $LogName -MaxEvents $MaxEvents

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
