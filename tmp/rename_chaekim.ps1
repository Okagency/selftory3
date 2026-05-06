[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$files = @(
  'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html',
  'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
)
foreach ($f in $files) {
  $c = Get-Content $f -Raw -Encoding UTF8
  $before = $c.Length
  $c = $c -replace '한 이사','한 책임'
  $c = $c -replace '한이사','한 책임'
  $c = $c -replace '이사님','책임님'
  $after = $c.Length
  $c | Set-Content $f -Encoding UTF8 -NoNewline
  Write-Host "Done: $f (len $before -> $after)"
}
