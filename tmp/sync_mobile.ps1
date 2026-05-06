[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$desktop = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$mobile = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'

# 1. 모바일 head 추출
$mobileContent = Get-Content $mobile -Raw -Encoding UTF8
$mobileHeadMatch = [regex]::Match($mobileContent, '(?s)<head>.*?</head>')
$mobileHead = $mobileHeadMatch.Value

# 2. 데스크탑 전체
$desktopContent = Get-Content $desktop -Raw -Encoding UTF8

# 3. 데스크탑 head를 모바일 head로 치환 (일반 무한 스크롤 유지)
$result = $desktopContent -replace '(?s)<head>.*?</head>', $mobileHead

$result | Set-Content $mobile -Encoding UTF8 -NoNewline
Write-Host "모바일 (일반 무한 스크롤): $($result.Length) chars"
