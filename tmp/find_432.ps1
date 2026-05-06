[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$idx = $c.IndexOf('432호 초인종')
$start = [Math]::Max(0, $idx-150)
$len = [Math]::Min(400, $c.Length - $start)
Write-Host $c.Substring($start, $len)
