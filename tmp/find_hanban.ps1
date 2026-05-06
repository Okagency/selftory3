[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$lines = Get-Content $f -Encoding UTF8
$out = @()
for ($i = 0; $i -lt $lines.Length; $i++) {
  $line = $lines[$i]
  # 한 책임이 인용 발화 + 반말 종결어미 패턴
  if ($line -match '한 책임' -and $line -match '"' -and $line -match '(야\.|야\?|야\")|(지\.|지\?|지\")|(거든\.|거든\")|(해\.|해\")|(줘\.|줘\")|(돼\.|돼\")') {
    if ($line -notmatch '한 책임 왈') {
      $idx = $line.IndexOf('"')
      $start = [Math]::Max(0, $idx - 10)
      $len = [Math]::Min(180, $line.Length - $start)
      $out += "$($i+1): ...$($line.Substring($start, $len))..."
    }
  }
}
Write-Host "한 책임 인용 + 반말 종결 패턴: $($out.Count)"
$out | Select-Object -First 40 | ForEach-Object { Write-Host $_ }
