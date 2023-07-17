function Get-LastSystemEvents {
    <#
    .SYNOPSIS
       Retrieves the last 10 system events, saves them to an XML file, and displays them in a grid view.
    .DESCRIPTION
       This function retrieves the last 10 events from the System event log. It creates a custom object for each event and saves the objects to an XML file in the current directory. Then it re-imports the data from the XML file and displays it in a grid view using Out-GridView.
    .PARAMETER Path
       Specifies the path to the XML file. If no path is specified, the file will be saved to the current directory.
    .EXAMPLE
       Get-Last10SystemEvents -Path .\Output.xml
    #>
        param (
            [string]$Path = ".\Output.xml"
        )
    
        # Get the current working directory
        $currentDirectory = Get-Location
    
        # Get the last 10 System events
        $events = Get-WinEvent -LogName System -MaxEvents 10
    
        # Create an array to hold XML data
        $xmlData = @()
    
        foreach ($event in $events) {
            # Create a custom object for each event
            $eventObj = New-Object PSObject
            $eventObj | Add-Member -Type NoteProperty -Name "ID" -Value $event.Id
            $eventObj | Add-Member -Type NoteProperty -Name "Level" -Value $event.LevelDisplayName
            $eventObj | Add-Member -Type NoteProperty -Name "Provider" -Value $event.ProviderName
            $eventObj | Add-Member -Type NoteProperty -Name "TimeCreated" -Value $event.TimeCreated
            $eventObj | Add-Member -Type NoteProperty -Name "Message" -Value $event.Message
    
            # Add the object to the array
            $xmlData += $eventObj
        }
    
        # Create the output file path
        $outputFilePath = Join-Path -Path $currentDirectory -ChildPath $Path
    
        # Export the data to an XML file
        $xmlData | Export-Clixml -Path $outputFilePath
    
        # Import the data from the XML file
        $xmlData = Import-Clixml -Path $Path
    
        # Display the data in a new window
        $xmlData | Out-GridView
    }
    
    Export-ModuleMember -Function Get-Last10SystemEvents
    