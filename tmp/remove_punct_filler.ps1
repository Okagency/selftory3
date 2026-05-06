[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) "마침표 N개" 패턴 — 한자/숫자 동시 처리
#    예) "마침표 한 개", "마침표 두 개", "마침표 세 개", "마침표 네 개", "마침표 다섯 개"
$c = $c -replace '\s*마침표 (한|두|세|네|다섯|여섯|일곱|여덟|아홉|열) 개\.?', ''
$c = $c -replace '\s*마침표 \d+개\.?', ''

# 2) "점 세 개" / "세 점" / "점 N개" 잡소리
$c = $c -replace '\s*점 (한|두|세|네|다섯) 개\.?', ''
$c = $c -replace '\s*\.{2,3}\s*세 점이 한 번 따라붙었다\.?', '...'
$c = $c -replace '\s*세 점이 한 번 따라붙었다\.?', ''
$c = $c -replace '\s*\.{2,3} 세 점\.?', '...'

# 3) "평서문 N마디" 카운팅 잡소리 — 너무 반복적
$c = $c -replace '\s*평서문 (한|두|세|네|다섯|여섯|일곱|여덟) 마디\.\s*', ' '
$c = $c -replace '\s*평서문 (한|두|세|네|다섯|여섯|일곱|여덟) 마디\s*', ' '

# 4) 정리: 연속 공백 정돈, 문장부호 앞 공백 제거
$c = $c -replace '  +', ' '
$c = $c -replace ' \.', '.'
$c = $c -replace ' ,', ','

# 5) 인영 → 사람 그림자
$c = $c -replace '인영이', '사람 그림자가'
$c = $c -replace '인영의', '사람 그림자의'
$c = $c -replace '인영은', '사람 그림자는'
$c = $c -replace '인영을', '사람 그림자를'
$c = $c -replace '인영', '사람 그림자'

$afterLen = $c.Length

$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "Length: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host "마침표 N개 잔여: $(([regex]::Matches($c, '마침표 (한|두|세|네|다섯) 개')).Count)"
Write-Host "평서문 N마디 잔여: $(([regex]::Matches($c, '평서문 (한|두|세|네) 마디')).Count)"
Write-Host "인영 잔여: $(([regex]::Matches($c, '인영')).Count)"
