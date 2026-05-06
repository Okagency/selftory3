[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$before = ([regex]::Matches($c, '결')).Count

# 잔여 외자 결 처리
$c = $c -replace '들어간 결의 새벽', '들어간 새벽'
$c = $c -replace '박힌 결\.', '박힌 자세.'
$c = $c -replace '누른 결\.', '누른 자세.'
$c = $c -replace '읽은 결\.', '읽은 자세.'
$c = $c -replace '회의실 결로는', '회의실 모습으로는'
$c = $c -replace '않은 결\.', '않은 자세.'
$c = $c -replace '없는 결의 사진', '없는 사진'

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "결 출현: $before -> $after"
