[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$before_jw = ([regex]::Matches($c, '한지원')).Count
$before_chk_space = ([regex]::Matches($c, '한 책임')).Count
$before_chk_nospace = ([regex]::Matches($c, '한책임')).Count
Write-Host "===== BEFORE ====="
Write-Host "한지원: $before_jw"
Write-Host "한 책임 (with space): $before_chk_space"
Write-Host "한책임 (no space): $before_chk_nospace"

# 1) 한지원 → 서지원
$c = $c -replace '한지원', '서지원'

# 2) 한 책임 → 서책임 (띄어쓰기 제거)
$c = $c -replace '한 책임', '서책임'

# 3) 한책임 (혹시 있다면) → 서책임
$c = $c -replace '한책임', '서책임'

$after_jw = ([regex]::Matches($c, '한지원')).Count
$after_chk_space = ([regex]::Matches($c, '한 책임')).Count
$after_chk_nospace = ([regex]::Matches($c, '한책임')).Count
$seo_jw = ([regex]::Matches($c, '서지원')).Count
$seo_chk = ([regex]::Matches($c, '서책임')).Count

$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "===== AFTER ====="
Write-Host "한지원 잔여: $after_jw"
Write-Host "한 책임 잔여: $after_chk_space"
Write-Host "한책임 잔여: $after_chk_nospace"
Write-Host "서지원: $seo_jw"
Write-Host "서책임: $seo_chk"
