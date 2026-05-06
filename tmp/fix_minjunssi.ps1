[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$c = Get-Content $f -Raw -Encoding UTF8
$c = $c -replace 'C/O Form AK', 'C/O Form VK'
$c = $c -replace 'Form AK \(한-베트남', 'Form VK (한-베트남'
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host 'Form AK → Form VK 일괄 치환 완료'
