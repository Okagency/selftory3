[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 깨진 마침표 정리 (이전 정리 부산물)
$c = $c -replace '"\.\.', '"...'
$c = $c -replace '"\.([가-힣])', '"$1'
$c = $c -replace '\.\.아,', '"아,'
$c = $c -replace '\(\s*"\)', ''

# 2) "86도\.평소" 같은 공백 누락
$c = $c -replace '도\.평소', '도. 평소'
$c = $c -replace '톤\.한', '톤. 한'
$c = $c -replace '소\.([가-힣])', '소. $1'

# 3) "한 톤이 한 톤으로" 류 중복
$c = $c -replace ' 한 톤이 한 톤으로 ', ' 한 톤으로 '
$c = $c -replace ' 한 톤으로 한 톤으로 ', ' 한 톤으로 '
$c = $c -replace ' 한 자리에 한 자리로 ', ' 한 자리로 '
$c = $c -replace ' 한 모습으로 한 모습이 ', ' 한 모습으로 '
$c = $c -replace ' 한 자세로 한 자세가 ', ' 한 자세로 '

# 4) "옆에서 ~ 한 명이었다" 단독 잔여
$c = $c -replace '\s+옆에서 [가-힣 ,]{0,30}한 명이었다\.', ''

# 5) "그 [가-힣]+가 그 [가-힣]+의 [가-힣]+이었다" 류 잔여
$c = $c -replace ' 그 [가-힣]+가 그 [가-힣]+의 [가-힣]+이었다\.', ''

# 6) 단독 한 마디
$c = $c -replace ' 끝음에\.\.\.\s', ' 끝음이 흐려졌다. '
$c = $c -replace '\s*끝음에\s*$', ''

# 7) 이중 "한 한" 같은 깨진 흐름
$c = $c -replace ' 한 한 ', ' 한 '
$c = $c -replace ' 그 그 ', ' 그 '
$c = $c -replace ' 평소 평소 ', ' 평소 '

# 8) "한 결" 잔여 외자
$c = $c -replace ' 한 결\b', ''

# 9) "사진첩 사전에" 같은 어색한 한국어
$c = $c -replace '카톡 사진첩 사전에', '카톡 사진첩에'

# 10) 한 톤으로 너무 많음 — 일부 제거
# (caution: 캐릭터 마커이므로 너무 공격적으로 안 함)
$c = $c -replace ' 한 톤으로 가지런히', ' 가지런히'
$c = $c -replace ' 한 톤으로 정확', ' 정확'

# 11) 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '\.\s+\.', '.'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
