[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# "꼴통" 두 곳 → 완곡·미묘한 표현으로
$c = $c.Replace(
    '<strong>서책임은 술이 한 잔 더 들어가는 자리에서는 약간 꼴통이 되는 습성이 있었다.</strong>',
    '<strong>서책임은 술이 한 잔 더 들어가는 자리에서는 평소의 자제력이 한 번 풀리는 사람이었다.</strong>'
)
$c = $c.Replace(
    '꼴통이 되는 자리에서도 — 한 자락의 선만은 12년차 무게로 한 톤으로 지켜졌다.',
    '평소의 자제력이 풀린 자리에서도 — 한 자락의 선만은 12년차의 무게로 지켜졌다.'
)

$c | Set-Content $f -Encoding UTF8 -NoNewline

$cnt = ([regex]::Matches($c, '꼴통')).Count
Write-Host "꼴통 잔여: $cnt"
