[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot ".."))
)

$ErrorActionPreference = "Stop"

$patterns = [ordered]@{
    "email address" = '(?i)\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}\b'
    "GUID / cloud identifier" = '(?i)\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b'
    "possible secret assignment" = '(?i)\b(client[_-]?secret|access[_-]?token|refresh[_-]?token|api[_-]?key|password)\b\s*[:=]\s*[^\s`"'']+'
}

$excludedDirectories = @('.git', '.azure', 'evidence/private', 'screenshots/raw', 'exports/raw')
$extensions = @('.md', '.txt', '.json', '.yaml', '.yml', '.kql', '.ps1', '.sh', '.conf')

$findings = New-Object System.Collections.Generic.List[object]

Get-ChildItem -Path $Root -Recurse -File | ForEach-Object {
    $file = $_
    $relative = [System.IO.Path]::GetRelativePath($Root, $file.FullName).Replace('\', '/')

    foreach ($excluded in $excludedDirectories) {
        if ($relative -eq $excluded -or $relative.StartsWith("$excluded/")) {
            return
        }
    }

    if ($extensions -notcontains $file.Extension.ToLowerInvariant()) {
        return
    }

    $lineNumber = 0
    Get-Content -LiteralPath $file.FullName | ForEach-Object {
        $lineNumber++
        $line = $_

        foreach ($entry in $patterns.GetEnumerator()) {
            if ($line -match $entry.Value) {
                $findings.Add([pscustomobject]@{
                    File = $relative
                    Line = $lineNumber
                    Pattern = $entry.Key
                    Preview = $line.Trim()
                })
            }
        }
    }
}

if ($findings.Count -eq 0) {
    Write-Host "Privacy check passed: no obvious identifiers or secret assignments found."
    exit 0
}

Write-Warning "Privacy check found $($findings.Count) item(s) that require review."
$findings | Format-Table -AutoSize
Write-Host "Review each finding before committing. A match is not automatically a secret."
exit 1
