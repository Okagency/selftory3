$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$insertPath = 'D:\dev\selftory\tmp\21_6_3_dealing_with_resisters.txt'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8
$insert = Get-Content -Path $insertPath -Raw -Encoding UTF8

# Insert before "<h5>부서간 책임 갈등의 흔한 패턴 5가지</h5>"
# (which now appears AFTER 21.6.1 and 21.6.2)
$marker = '<h5>부서간 책임 갈등의 흔한 패턴 5가지</h5>'

$idx = $content.IndexOf($marker)
if ($idx -lt 0) { throw 'Marker not found' }
Write-Host "Marker idx: $idx"

# Insert content before marker
$before = $content.Substring(0, $idx)
$after = $content.Substring($idx)

$newContent = $before + $insert.TrimEnd() + ' ' + $after

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
Write-Host "Diff: $($newContent.Length - $content.Length)"
Write-Host "Done"
