[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$builtin = @(
    '결산','결과','결정','결심','결국','결말','결합','결제','결재','연결','체결','단결',
    '타결','해결','종결','결손','결식','결렬','결행','결격','결자','결석','결함','결근',
    '청결','결단','미결','대결','결별','결집','결정성','결정자','결정권','결자해지',
    '결재선','결품','응결','동결','결론','숨결','머리결','무심결','순결','결박'
)
$ms = [regex]::Matches($c, '.{0,4}결.{0,4}')
$abstract = @()
foreach ($m in $ms) {
    $val = $m.Value
    $isBuiltin = $false
    foreach ($b in $builtin) { if ($val -match $b) { $isBuiltin = $true; break } }
    if (-not $isBuiltin) { $abstract += $val }
}
Write-Host "추상 외자 결 잔여: $($abstract.Count)"
$abstract | Group-Object | Sort-Object Count -Descending | Select-Object -First 30 | Format-Table Count, Name -AutoSize
