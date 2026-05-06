[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$c = Get-Content 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html' -Raw -Encoding UTF8
$startIdx = $c.IndexOf('<section id="part1">')
$endIdx = $c.IndexOf('<section id="part2">')
$part1 = $c.Substring($startIdx, $endIdx - $startIdx)
$matches = [regex]::Matches($part1, '결')
Write-Host "1부 결 출현: $($matches.Count)"
$abstract = [regex]::Matches($part1, '결의|평소 결|한 결|그 결|어떤 결|다른 결|같은 결| 결이| 결을| 결로| 결도')
Write-Host "1부 추상어 패턴: $($abstract.Count)"
