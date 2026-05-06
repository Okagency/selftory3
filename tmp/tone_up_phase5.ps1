[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 잔여 "마침표 N개" / "평서문 N 마디"
$c = $c -replace ' 마침표 (한|두|세|네|다섯|여섯|일곱|여덟|아홉|열) 개\.?', ''
$c = $c -replace ' 평서문 (한|두|세|네|다섯|여섯|일곱|여덟) 마디\.?', ''
$c = $c -replace ' 평서문이었다\.', '.'
$c = $c -replace ' 평서문이었으나', '이었으나'

# 2) 깨진 인용 시작 ".."
$c = $c -replace '"\.\.([가-힣])', '"...$1'
$c = $c -replace '<p>"\.\.', '<p>"..'

# 3) "..아" 같은 이상한 시작
$c = $c -replace '\.\.아,', '..아,'

# 4) 도배된 "한 톤" 추가 정리
$c = $c -replace ' 한 톤으로 한 번 ', ' 한 번 '
$c = $c -replace ' 한 톤으로 두 번 ', ' 두 번 '
$c = $c -replace ' 한 톤으로 잠깐 ', ' 잠깐 '

# 5) "옆에서 본 사람" 잡소리 잔여
$c = $c -replace ' 옆에서 본 사람의 모습 ', ' '
$c = $c -replace ' 옆에서 본 사람의 자세 ', ' '

# 6) "12년차 PM의 무게" 일부 정리 (너무 도배)
# 이거 캐릭터 마커이긴 한데 너무 자주 나옴
$c = $c -replace ' 12년차 PM의 무게로\b', ' 12년차 무게로'
$c = $c -replace ' 12년차 PM의 정확함\b', ' 12년차의 정확함'
$c = $c -replace ' 12년차 PM의 단정함\b', ' 12년차의 단정함'

# 7) 도배된 "한 마디" 단독
$c = $c -replace ' 한 마디 던졌다\. 한 마디 ', ' 한 마디 던졌다. '
$c = $c -replace ' 한 마디 더\. 한 마디 ', ' 한 마디 더. '

# 8) "그러나 — 마침표 끝에" 류
$c = $c -replace ' 마침표 끝에 ', ' 끝에 '

# 9) "한 호흡이 그 자리에" 류 잔여
$c = $c -replace '\s+그 한 호흡이\s+', ' '

# 10) 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '\.\s+\.', '.'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host "마침표 N 개 잔여: $(([regex]::Matches($c,'마침표 (한|두|세|네|다섯) 개')).Count)"
Write-Host "평서문 N 마디 잔여: $(([regex]::Matches($c,'평서문 (한|두|세|네) 마디')).Count)"
