function Get-LastSystemEvents {
    <#
    .SYNOPSIS
       Retrieves the last 10 system events and displays them in a grid view.
    .DESCRIPTION
       This function retrieves the last 10 events from the System event log. It creates a custom object for each event and displays them in a grid view using Out-GridView.
    .EXAMPLE
       Get-LastSystemEvents
    #>
    
    # Get the last 10 System events
    $events = Get-WinEvent -LogName System -MaxEvents 10

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
