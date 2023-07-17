# :computer: PowerShell Event Log Viewer :mag:

This PowerShell module retrieves the last 10 events from the Windows System event log, saves them to an XML file, and displays them in a grid view using `Out-GridView`.

## :wrench: Installation :wrench:

1. Clone the repository: `git clone https://github.com/Paul1404/Log-Analysis-Tool.git`
2. Navigate to the cloned directory: `cd Log-Analysis-Tool`
3. Import the module: `Import-Module ./Log-Analysis-Tool.psm1`

## :rocket: Usage :rocket:

Use the `Get-LastSystemEvents` function to retrieve and display the last 10 system events. The function will also save the data to an XML file in the current directory, or to a specified path if provided.

The Get-Last10SystemEvents function takes an optional Path parameter that specifies the path to the XML file. If no path is specified, the file will be saved in the current directory. For example:

```powershell
Get-Last10SystemEvents -Path .\Output.xml
```

## License 📃
This project is licensed under the terms of the MIT license. See the LICENSE file for details.
