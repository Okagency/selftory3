[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 도배된 마무리 패턴 모두 제거
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}자리였다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}모습이었다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}무게였다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}자세였다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}톤이었다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}한 마디였다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}동력이었다\.', ''
$c = $c -replace ' 그게 [가-힣 ,·]{0,40}진짜 동력이었다\.', ''

# 2) "평소 마침표." 단독 도배 정리
$c = $c -replace '\.\s*평소 마침표\.\s*', '.'
$c = $c -replace ' 평소 마침표\.', '.'
$c = $c -replace ' 평소 톤\. 평소 마침표\.', '.'
$c = $c -replace ' 평소 톤이었다\. 평소 마침표였다\.', '.'

# 3) "평소 톤. 평소 마침표." 반복 패턴 일부 정리
$c = $c -replace ' 평소 톤\. 평소 마침표\.', ' 평소 톤.'

# 4) "그러나 — 마지막 마침표 끝에" 패턴 정리
$c = $c -replace ' 마지막 마침표 끝에', ' 끝에'

# 5) 단독 "평서문." 류
$c = $c -replace '\s*평서문\s*\.', '.'
$c = $c -replace '\s*평서문이었다\.', '.'

# 6) 깨진 ".네" "..아" 정리
$c = $c -replace '"\.네\b', '"네'
$c = $c -replace '"\.\.네\b', '"네'
$c = $c -replace '"\.아\b', '"아'

# 7) "옆에서 그 자리를 본 사람의 자세였다" 잡소리
$c = $c -replace ' 옆에서 그 자리를 본 사람의 [가-힣]+였다\.', ''

# 8) "한 호흡이 있었다" 단독 잡소리
$c = $c -replace '\s+그 한 호흡이 [가-힣 ]{0,20}이었다\.', ''

# 9) 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '\s+\.', '.'
$c = $c -replace '\.\s+\.', '.'
$c = $c -replace '<p>\s*</p>', ''
$c = $c -replace '<p>\s+', '<p>'
$c = $c -replace '\s+</p>', '</p>'
$c = $c -replace '<p>\.\s*</p>', ''
$c = $c -replace '<p>\.</p>', ''

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
