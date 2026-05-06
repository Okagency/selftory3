[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$idx = $c.IndexOf('경주')
$start = [Math]::Max(0, $idx-150)
$length = [Math]::Min(400, $c.Length - $start)
Write-Host $c.Substring($start, $length)
