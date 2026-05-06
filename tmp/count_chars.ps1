[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$html = Get-Content -Path 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html' -Raw -Encoding UTF8
$noStyle = $html -replace '(?s)<style.*?</style>', ''
$noScript = $noStyle -replace '(?s)<script.*?</script>', ''
$noTags = $noScript -replace '<[^>]+>', ' '
$noEntities = $noTags -replace '&[a-zA-Z]+;', ' '
$clean = ($noEntities -replace '\s+', ' ').Trim()

$totalChars = $clean.Length
$noSpace = ($clean -replace ' ', '')
$noSpaceCount = $noSpace.Length
$korChars = ([regex]::Matches($clean, '[가-힣]')).Count
$engChars = ([regex]::Matches($clean, '[a-zA-Z]')).Count
$digitChars = ([regex]::Matches($clean, '[0-9]')).Count

Write-Host '====== ERP Guide - Length Analysis ======'
Write-Host ''
Write-Host ('Total chars (with space)    : ' + $totalChars.ToString('N0'))
Write-Host ('Total chars (no space)      : ' + $noSpaceCount.ToString('N0'))
Write-Host ('Korean chars                : ' + $korChars.ToString('N0'))
Write-Host ('English chars               : ' + $engChars.ToString('N0'))
Write-Host ('Digit chars                 : ' + $digitChars.ToString('N0'))
Write-Host ''
Write-Host '====== Page Estimate ======'
Write-Host ''
$p_novel = [math]::Round($totalChars / 800)
$p_std   = [math]::Round($totalChars / 1000)
$p_tech  = [math]::Round($totalChars / 1200)
$p_dense = [math]::Round($totalChars / 1500)
$wongoji = [math]::Round($totalChars / 200)

Write-Host ('Novel/Light book  (800 chars/page)   = ' + $p_novel + ' pages')
Write-Host ('Standard book     (1,000 chars/page) = ' + $p_std   + ' pages')
Write-Host ('Tech/Practice     (1,200 chars/page) = ' + $p_tech  + ' pages')
Write-Host ('Dense reference   (1,500 chars/page) = ' + $p_dense + ' pages')
Write-Host ''
Write-Host ('200-char manuscript paper = ' + $wongoji.ToString('N0') + ' sheets')
Write-Host ''
Write-Host '====== Reference ======'
Write-Host '- Typical Korean novel: 250-350 pages (200,000-280,000 chars)'
Write-Host '- Tech/practice book : 300-500 pages (300,000-600,000 chars)'
Write-Host '- Murakami "Norwegian Wood": ~460 pages (~380,000 chars)'
