[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$files = @(
  'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html',
  'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
)
foreach ($f in $files) {
  $c = Get-Content $f -Raw -Encoding UTF8
  $c = $c -replace '김 이사','송 이사'
  $c = $c -replace '김이사','송 이사'
  $c | Set-Content $f -Encoding UTF8 -NoNewline
  Write-Host "Done: $f"
}
