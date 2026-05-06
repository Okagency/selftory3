$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$insertPath = 'D:\dev\selftory\tmp\10_12_master_owner_check.txt'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8
$insert = Get-Content -Path $insertPath -Raw -Encoding UTF8

# Insert before "<div class="keypoint">\n <div class="keypoint-title">10장 핵심"
$marker = '</div> <div class="keypoint">' + "`r`n" + ' <div class="keypoint-title">10장 핵심</div>'
$markerSimple = '<div class="keypoint-title">10장 핵심</div>'

$idx = $content.IndexOf($markerSimple)
if ($idx -lt 0) { throw 'Marker not found' }
Write-Host "Marker idx: $idx"

# Find the start of the keypoint div before this title
$kpStart = $content.LastIndexOf('<div class="keypoint">', $idx)
if ($kpStart -lt 0) { throw 'Keypoint div start not found' }
Write-Host "Keypoint start: $kpStart"

# Insert insert content before the keypoint div opening
$before = $content.Substring(0, $kpStart)
$after = $content.Substring($kpStart)

$newContent = $before + $insert.TrimEnd() + ' ' + $after

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
Write-Host "Diff: $($newContent.Length - $content.Length)"
Write-Host "Done"
