[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 측정값 정리 부산물 — 깨진 마침표/공백/잔여 단어
$c = $c -replace '\.\.\.\s*\.', '.'
$c = $c -replace '\.\.\s+', '. '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '\s{3,}', ' '
$c = $c -replace '<p>\s*</p>', ''
$c = $c -replace '<p>\s*\.\s*</p>', ''

# 2) 도배된 "한 톤으로 머물렀다 사라졌다" 일부 제거
$c = $c -replace ' 한 톤으로 머물렀다 사라졌다\.', '.'
$c = $c -replace ' 한 번 머물렀다 사라졌다\.', '.'
$c = $c -replace ' 한 자리에 머물러 있었다\.', '.'

# 3) "옆에서 그 자리를 본 사람이 (회의실에)? 한 명이었다" 도배 패턴
$c = $c -replace ' 옆에서 그 자리를 본 사람(이|은) 회의실에 한 명이었다\.', ''
$c = $c -replace ' 옆에서 그 자리를 본 사람(이|은) (그 자리에 )?한 명이었다\.', ''
$c = $c -replace ' 알아챈 사람(이|은) 회의실에 한 명이었다\.', ''
$c = $c -replace ' 알아챈 사람(이|은) 한 명이었다\.', ''

# 4) "그게 ~의 정확함이었다" 도배 일부 제거
$c = $c -replace ' 그게 [가-힣 ]{0,30}의 정확함이었다\.', ''

# 5) "한 호 머물렀다 사라졌다" 도배 일부
$c = $c -replace ' 한 호 머물렀다 사라졌다\.', '.'
$c = $c -replace ' 한 자락 비쳤다 사라졌다\.', '.'

# 6) "(평소|평서문) 한 마디" 단독 문장 일부 제거
$c = $c -replace '\s*평서문\s*\.', '.'

# 7) 깨진 ".네" 같은 dialog 시작 정리
$c = $c -replace '<p>"\.\.', '<p>"...'
$c = $c -replace '"\.\.\.', '"...'

# 8) 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '<p>\s*</p>', ''

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
