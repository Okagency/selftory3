[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$c = $c.Replace('경주 1박 2일의 와인 한 잔, ', '')
$c | Set-Content $f -Encoding UTF8 -NoNewline
$cnt = ([regex]::Matches($c, '경주')).Count
Write-Host "경주 잔여: $cnt"
