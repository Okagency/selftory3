[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$before = ([regex]::Matches($c, '측정값')).Count
Write-Host "측정값 출현 (before): $before"

# 1) "그게 그날 ~의 측정값이었다." 패턴 — 문장 통째 제거
$c = $c -replace '\s*그게 [^.]{0,50}측정값이었다\.', ''
$c = $c -replace '\s*그것이 [^.]{0,50}측정값이었다\.', ''
$c = $c -replace '\s*그 [^.]{0,30}측정값이었다\.', ''

# 2) "~ 측정값이었다" 단순 패턴
$c = $c -replace '[가-힣 ]{0,40}측정값이었다\.', ''
$c = $c -replace '[가-힣 ]{0,40}측정값이었다\s*', ''

# 3) "측정값" 단어 자체 잔여 — 자리/모습으로 교체
$c = $c -replace '측정값', '자리'

# 4) 연속 공백 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s*\.\s*\.', '.'
$c = $c -replace '<p>\s*</p>', ''

$after = ([regex]::Matches($c, '측정값')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "측정값 출현 (after): $after"
Write-Host "감소: $($before - $after)"
