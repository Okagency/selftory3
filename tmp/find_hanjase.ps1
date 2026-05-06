[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$matches = Select-String -Path 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html' -Pattern '한 자세' -Encoding UTF8
foreach ($m in $matches) {
  $idx = $m.Line.IndexOf('한 자세')
  $start = [Math]::Max(0, $idx - 30)
  $len = [Math]::Min(120, $m.Line.Length - $start)
  Write-Host "$($m.LineNumber): ...$($m.Line.Substring($start, $len))..."
}
