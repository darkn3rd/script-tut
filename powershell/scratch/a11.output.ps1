<#
.SYNOPSIS
Writes text to stderr when running in the regular PS console,
to the host's error stream otherwise.

.DESCRIPTION
Writing to true stderr allows you to write a well-behaved CLI
as a PS script that can be invoked from a batch file, for instance.

Note that PS sends ALL its streams to *stdout* when invoked from cmd.exe.

This function acts similarly to Write-Host in that it simply calls
.ToString() on its input; to get the default output format, invoke
it via a pipeline and precede with Out-String.

#> 
function Write-StdErr {
    param ([PSObject] $InputObject)
    $outFunc = if ($Host.Name -eq 'ConsoleHost') { 
        [Console]::Error.WriteLine
    } else {
        $host.ui.WriteErrorLine
    }
    if ($InputObject) {
        [void] $outFunc.Invoke($InputObject.ToString())
    } else {
        [string[]] $lines = @()
        $Input | % { $lines += $_.ToString() }
        [void] $outFunc.Invoke($lines -join "`r`n")
    }
}

# output message to standard error
#  Note: Test by redirecting stdout to nowhere, e.g.
#    C:\> powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File script.ps1 > NUL
Write-StdErr "This is a test of the emergency script system.  This is only a test."




