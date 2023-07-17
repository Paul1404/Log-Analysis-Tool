@{
    # Script module or binary module file associated with this manifest
    RootModule = 'EventLogViewer.psm1'

    # Version number of this module.
    ModuleVersion = '1.0.0.0'

    # ID used to uniquely identify this module
    GUID = 'your-guid-here'

    # Author of this module
    Author = 'your-name-here'

    # Company or vendor of this module
    CompanyName = 'your-company-here'

    # Copyright statement for this module
    Copyright = '(c) your-company-here. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'This module retrieves the last 10 events from the System event log, saves them to an XML file, and displays them in a grid view.'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
    FunctionsToExport = 'Get-Last10SystemEvents'

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = 'Windows', 'Event', 'Log', 'Viewer'

            # A URL to the license for this module.
            LicenseUri = 'http://opensource.org/licenses/MIT'

            # A URL to the main website for this project.
            ProjectUri = 'http://your-project-url-here'

            # A URL to an icon representing this module.
            IconUri = ''
        }
    }
}
