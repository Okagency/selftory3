[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# === 추가 정리 — 단락 단위 ===

# 36장 컷오버 D-1 작가 풀이 류
$c = $c -replace ' [가-힣 ]{0,20}본인 자세[가는] [가-힣 ,·]{0,40}\.', ''

# 26살 직감 작가 풀이
$c = $c -replace ' 26살 직감의 정확도가 그 정도였다\.', ''
$c = $c -replace ' 26살은 회복이 빠르다\.', ''

# 5년차 어소시에이트 도배
$c = $c -replace ' 5년차 어소시에이트의 [가-힣 ]{0,20}자세', ' 5년차의 자세'
$c = $c -replace ' 5년차 어소시에이트의 [가-힣 ]{0,20}모습', ' 5년차의 모습'

# 표면/내면 분석
$c = $c -replace ' 표면 \d+% 합리, 내면 \d+% 합리, \d+% [가-힣 ]{0,20}이었다\.', ''

# 마음은 X 자리인데, 겉으론 Y인 자리였다
$c = $c -replace ' 마음은 [가-힣 ]{0,20}자리인데, 겉으론 [가-힣 ]{0,20}이었다\.', ''
$c = $c -replace ' <strong>마음은 [가-힣 ]{0,20}자리인데, 겉으론 [가-힣 ]{0,20}이었다\.</strong>', ''

# "그게 ~의 가장 깊은 자리였다"
$c = $c -replace ' 그게 [가-힣 ]{0,30}의 가장 깊은 자리였다\.', ''
$c = $c -replace ' 그게 [가-힣 ]{0,30}의 가장 정직한 자리였다\.', ''

# "한 번도 ~ 적 없는 사람" 도배
$c = $c -replace ' 12년 동안 한 번도 [가-힣 ,·]{0,40} 적 없는 사람이었다\.', '.'
$c = $c -replace ' 12년 동안 한 번도 [가-힣 ,·]{0,40}\.', '.'

# 평소 X가 아니라 Y의 모습
$c = $c -replace ' 평소 [가-힣 ]{1,15}이 아니라 — [가-힣 ,·]{5,40}모습이었다\.', '.'
$c = $c -replace ' 평소 [가-힣 ]{1,15}이 아니라 — [가-힣 ,·]{5,40}자세였다\.', '.'

# "X의 가장 정직한 측정값이었다" 잔여
$c = $c -replace ' [가-힣 ]{0,30}의 가장 정직한 측정값이었다\.', '.'
$c = $c -replace ' [가-힣 ]{0,30}의 가장 분명한 측정값이었다\.', '.'

# "옆에서 본 사람의 자세" 잔여
$c = $c -replace ' 옆에서 본 사람의 [가-힣]+ ', ' '

# "두 사람만 알고 있었다" 도배
$c = $c -replace ' 표면 아래의 모습은 — 두 사람만 알고 있었다\.', ''
$c = $c -replace ' 두 사람만 알고 있었다\.', ''

# 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\.\s+\.', '.'
$c = $c -replace '\s+\.', '.'
$c = $c -replace '<p>\s*</p>', ''
$c = $c -replace '<p>\s*\.\s*</p>', ''
$c = $c -replace '<p>\s+', '<p>'
$c = $c -replace '\s+</p>', '</p>'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "추가 정리: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
