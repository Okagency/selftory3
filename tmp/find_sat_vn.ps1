[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$idx = $c.IndexOf('토요일 오전 9시. 한성정밀 베트남')
$start = [Math]::Max(0, $idx-50)
$len = [Math]::Min(1500, $c.Length - $start)
Write-Host $c.Substring($start, $len)
