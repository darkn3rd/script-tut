# Pulls in the shared task definitions - mirrors how each Rakefile does
# `import("../../testbox/testbox.rake")`. Run from this directory, e.g.:
#   Invoke-psake .\psakefile.ps1
#   Invoke-psake .\psakefile.ps1 -taskList F0
. (Join-Path $PSScriptRoot '..\..\testbox\testbox.psake.ps1')
