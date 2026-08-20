# Chocolatey Packages

choco pack && choco install pipx -s

Added the README.md and an update.ps1 that actually wires up the auto-update. Quick summary of "how it wires up":

Chocolatey itself has no update mechanism — packages are static until something edits them. The community standard for that is AU (majkinetor/au), a PowerShell module that looks for an update.ps1 next to the .nuspec and expects two functions:

au_GetLatest — hits pypa/pipx's GitHub releases API, returns the new version + the pipx.pyz asset URL.
au_SearchReplace — regex rules for which lines in chocolateyinstall.ps1 to rewrite with that data.

I only needed a rule for $version and $checksum — $url already interpolates $version in the install script, so it self-corrects once that line is rewritten. The last line, update -ChecksumFor 32, is what actually triggers the check-and-rewrite (pipx publishes no checksum of its own, so AU downloads and hashes the file itself).

To use it: choco install au once, then run .\update.ps1 from that directory whenever you want to check for a new pipx release — it edits chocolateyinstall.ps1 and the nuspec version in place if one's found. Update-AUPackages is the batch form if you ever have multiple packages here; I didn't wire that into CI since none exists yet for this repo.

I validated all three .ps1 files parse correctly with pwsh (it's on this Mac), though the Chocolatey-specific cmdlets (Get-ChocolateyWebFile, Install-BinFile) only exist inside choco's own helper module, so a real choco pack/install run on Windows is still the way to fully confirm it end-to-end.