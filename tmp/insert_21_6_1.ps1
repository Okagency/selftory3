$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$insertPath = 'D:\dev\selftory\tmp\21_6_1_master_owner_real.txt'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8
$insert = Get-Content -Path $insertPath -Raw -Encoding UTF8

# Insert before "<h5>부서간 책임 갈등의 흔한 패턴 5가지</h5>"
$marker = '</table> <h5>부서간 책임 갈등의 흔한 패턴 5가지</h5>'

$idx = $content.IndexOf($marker)
if ($idx -lt 0) { throw 'Marker not found' }
Write-Host "Marker idx: $idx"

# Insert content before marker, but after the </table> closing
# Strategy: replace marker with new content + marker
$newMarker = '</table> ' + $insert.TrimEnd() + ' <h5>부서간 책임 갈등의 흔한 패턴 5가지</h5>'

$newContent = $content.Replace($marker, $newMarker)

if ($newContent.Length -eq $content.Length) { throw 'No replacement happened' }

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
Write-Host "Diff: $($newContent.Length - $content.Length)"
Write-Host "Done"
