[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# 31장 핵심 위치
$idx = $c.IndexOf('31장 핵심')
Write-Host "31장 핵심 위치: $idx"

if ($idx -ge 0) {
    $start = [Math]::Max(0, $idx - 100)
    $len = [Math]::Min(200, $c.Length - $start)
    Write-Host "주변 컨텍스트:"
    Write-Host $c.Substring($start, $len)
}
