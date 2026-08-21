# AU (https://github.com/majkinetor/au) update script - checks GitHub for
#  a newer pipx release and rewrites this package's own version/checksum
#  in place. Requires the `au` PowerShell module (`choco install au` or
#  `Install-Module au`); not invoked by `choco pack`/`choco install`
#  themselves, only by a maintainer (or CI) running `Update-AUPackages`/
#  `.\update.ps1` directly.
#
# au_GetLatest fetches what's new; au_SearchReplace tells au which lines
#  in chocolateyinstall.ps1 to rewrite with it. $checksum is deliberately
#  the only line replaced besides $version - $url already interpolates
#  $version (see chocolateyinstall.ps1), so once $version's own line is
#  rewritten, $url is correct with no separate replace needed.

function global:au_GetLatest {
    $release = Invoke-RestMethod 'https://api.github.com/repos/pypa/pipx/releases/latest'
    $asset   = $release.assets | Where-Object name -eq 'pipx.pyz'

    @{
        Version = $release.tag_name
        URL32   = $asset.browser_download_url
    }
}

function global:au_SearchReplace {
    @{
        '.\tools\chocolateyinstall.ps1' = @{
            "(?i)^(\`$version\s*=\s*)'.*'"  = "`$1'$($Latest.Version)'"
            "(?i)^(\`$checksum\s*=\s*)'.*'" = "`$1'$($Latest.Checksum32)'"
        }
    }
}

# `-ChecksumFor 32` - pipx.pyz has no published hash (GitHub's release
#  API exposes no checksum for it, confirmed directly against the
#  pypa/pipx releases API), so au must download URL32 itself and hash it
#  rather than trust a vendor-supplied value. There's no 32/64 split to
#  make here - .pyz is architecture-independent - au's own model just
#  requires the URL to live in URL32 or URL64; 32 was picked arbitrarily.
if ($MyInvocation.InvocationName -ne '.') { update -ChecksumFor 32 }
