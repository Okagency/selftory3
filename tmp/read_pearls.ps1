[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$files = @(
  'D:\dev\selftory\docs\html\가디언_006_막장로맨스.html',
  'D:\dev\selftory\docs\html\가이드모드_001_30대프리랜서.html',
  'D:\dev\selftory\docs\html\가디언_013_병맛에디션.html'
)
foreach ($f in $files) {
  Write-Host "===== $($f.Split('\')[-1]) ====="
  $c = Get-Content $f -Raw -Encoding UTF8
  $no_style = $c -replace '(?s)<style.*?</style>',''
  $no_script = $no_style -replace '(?s)<script.*?</script>',''
  $no_tag = $no_script -replace '<[^>]+>',' '
  $clean = ($no_tag -replace '\s+',' ').Trim()
  $len = [Math]::Min(2000, $clean.Length)
  Write-Host $clean.Substring(0, $len)
  Write-Host ""
  Write-Host ""
}
