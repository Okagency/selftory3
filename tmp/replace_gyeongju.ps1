[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$nf = 'D:\dev\selftory\tmp\new_gyeongju.txt'

$c = Get-Content $f -Raw -Encoding UTF8
$new = Get-Content $nf -Raw -Encoding UTF8

# 시작·끝 marker
$startMarker = '<p id="scene-gyeongju-call">'
$endMarker = '<hr class="scene"> <!-- 31장 UAT -->'

$startIdx = $c.IndexOf($startMarker)
$endIdx = $c.IndexOf($endMarker)

if ($startIdx -lt 0) { Write-Host "시작 marker 못 찾음"; exit 1 }
if ($endIdx -lt 0) { Write-Host "끝 marker 못 찾음"; exit 1 }

$beforeLen = $endIdx - $startIdx
Write-Host "교체 영역 길이: $beforeLen 자"

# 교체
$before = $c.Substring(0, $startIdx)
$after = $c.Substring($endIdx)
$result = $before + $new + " " + $after

$result | Set-Content $f -Encoding UTF8 -NoNewline

$newLen = $new.Length
Write-Host "신규 콘텐츠 길이: $newLen 자"
Write-Host "변화: $beforeLen -> $newLen (감소 $($beforeLen - $newLen)자)"
