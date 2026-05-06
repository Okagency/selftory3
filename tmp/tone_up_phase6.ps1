[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 4개 점 → 3개 점 정리
$c = $c -replace '\.{4,}', '...'

# 2) "마침표 끝에" 잔여 정리
$c = $c -replace '\s*마침표 끝에 ', ' '
$c = $c -replace ' 평소 마침표\s', ' '

# 3) "한 톤으로" 도배 추가 정리 (캐릭터 마커 일부 KEEP하되 도배 줄임)
$c = $c -replace ' 한 톤으로 한 자락 ', ' 한 자락 '
$c = $c -replace ' 한 톤으로 짧게 ', ' 짧게 '
$c = $c -replace ' 한 톤으로 그대로 ', ' 그대로 '
$c = $c -replace ' 한 톤으로 더 ', ' 더 '

# 4) 도배된 "한 번 ~ 사라졌다" 일부
$c = $c -replace ' 한 번 떠올랐다 사라졌다\.', ' 떠올랐다 사라졌다.'
$c = $c -replace ' 한 번 흘렀다 다시 ', ' 흘렀다 다시 '

# 5) "한 사람의 ~" 도배 단순화
$c = $c -replace ' 한 사람의 짧은 웃음\.', ' 짧은 웃음이었다.'

# 6) 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
