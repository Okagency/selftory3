[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# 31장 안의 박 사장 → 김 사장 (한성정밀 대표 통일)
# 1) "박 사장 — 한성정밀 대표이사 —"
$c = $c -replace '박 사장 — 한성정밀 대표이사 —', '김 사장 — 한성정밀 대표이사 —'

# 2) "박 사장님, 알겠습니다." 답장
$c = $c -replace "'박 사장님, 알겠습니다\.", "'김 사장님, 알겠습니다."

# 3) "한성정밀 박 사장의 한 통 메일"
$c = $c -replace '한성정밀 박 사장의 한 통 메일', '한성정밀 김 사장의 한 통 메일'

# 검증
$cnt_park = ([regex]::Matches($c, '박 사장')).Count
$cnt_kim = ([regex]::Matches($c, '김 사장')).Count

$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "박 사장 잔여: $cnt_park (동성테크 11부만 정상)"
Write-Host "김 사장 출현: $cnt_kim"
