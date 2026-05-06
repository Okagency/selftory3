[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 추가 도배 패턴 정리
# 1) "그게 그 ~의 ~이었다" 도배 마무리 패턴
$c = $c -replace ' 그게 그 회의실의 마지막 자리였다\.', ''
$c = $c -replace ' 그게 그날 [가-힣 ]{0,20}의 마지막 자리였다\.', ''
$c = $c -replace ' 그게 그 [가-힣 ]{0,15}의 자리였다\.', ''
$c = $c -replace ' 그게 [가-힣 ]{0,30}의 자리였다\.', ''
$c = $c -replace ' 그게 그날 [가-힣 ]{0,20}의 자리였다\.', ''

# 2) "한 사람이 한 사람을 한 번 다르게 본" 류 잡소리
$c = $c -replace ' 한 사람이 한 사람을 한 번 다르게 본', ' 한 사람을 다르게 본'
$c = $c -replace ' 한 사람이 또 한 사람을', ' 한 사람이 또 한 사람을'

# 3) "옆에서 본 사람의 자세" 도배
$c = $c -replace ' 옆에서 본 모습으로는 분명했다\.', ''
$c = $c -replace ' 옆에서 본 사람의 자세', ''

# 4) "12년 동안 한 번도 ~ 적 없던" 일부 — 중복 시 제거
$c = $c -replace ' 평소 [가-힣 ]{0,15} 사전에 한 번도 등재된 적 없던 ', ' 평소 안 쓰던 '

# 5) "PM의 웃음이 아니라 — 다른 웃음" 도배
$c = $c -replace ' PM의 웃음이 아니라 — 한 사람이 [가-힣 ]{0,30}\.', ' PM의 웃음이 아니었다.'
$c = $c -replace ' 평소 PM의 웃음이 아니라', ' PM의 웃음이 아니라'

# 6) 도배된 "한 톤" 일부
$c = $c -replace ' 한 톤으로 한 번 머물렀다', ' 머물렀다'
$c = $c -replace ' 한 톤으로 흩어졌다', ' 흩어졌다'

# 7) "평소 80cm가 한 번 ~cm로" 같은 거리 변환 표기 정돈 — KEEP (캐릭터 마커)

# 8) 깨진 마침표 / 공백 추가 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '\.\s+\.', '.'
$c = $c -replace '<p>\s*</p>', ''
$c = $c -replace '<p>\.\s*</p>', ''
$c = $c -replace '<p>\s+', '<p>'
$c = $c -replace '\s+</p>', '</p>'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
