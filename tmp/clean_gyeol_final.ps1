[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$before = ([regex]::Matches($c, '결')).Count

# 보호: 정상 복합어들 임시 치환
$builtin = @(
    '결산','결과','결정','결심','결국','결말','결합','결제','결재','연결','체결','단결',
    '타결','해결','종결','결손','결식','결렬','결행','결격','결자','결석','결함','결근',
    '청결','결단','미결','대결','결별','결집','결정성','결정자','결정권','결자해지',
    '결재선','결품','응결','동결','결론','숨결','머리결','무심결','순결','결박','결국'
)
$i = 0
$protect_map = @{}
foreach ($word in $builtin | Sort-Object Length -Descending | Select-Object -Unique) {
    $token = "@@G$i@@"
    $protect_map[$token] = $word
    $c = $c -replace [regex]::Escape($word), $token
    $i++
}

# 외자 결 패턴 일괄 제거/치환
$c = $c -replace ' 한 결로', ' 한 톤으로'
$c = $c -replace ' 한 결의', ''
$c = $c -replace ' 한 결에', ''
$c = $c -replace ' 한 결이', ''
$c = $c -replace ' 한 결\.', '.'
$c = $c -replace ' 한 결,', ','
$c = $c -replace ' 한 결 ', ' '
$c = $c -replace '다른 결로', '다른 모습으로'
$c = $c -replace '다른 결의', '다른'
$c = $c -replace '다른 결', '다른 모습'
$c = $c -replace '어떤 결', '어떤 자세'
$c = $c -replace '그 결로', '그렇게'
$c = $c -replace '그 결의', '그'
$c = $c -replace '그 결\.', '.'
$c = $c -replace '그 결 ', ' '
$c = $c -replace '깊은 결', '깊은 자리'
$c = $c -replace '둔 결', '둔 자세'
$c = $c -replace '같은 결', '같은 자세'
$c = $c -replace '평소 결', '평소'
$c = $c -replace ' 결로 ', ' 모습으로 '
$c = $c -replace ' 결에 ', ' 자세에 '
$c = $c -replace ' 결인 ', ' 자세인 '
$c = $c -replace ' 결인지', ' 자세인지'
$c = $c -replace ' 결처럼', ' 모습처럼'
$c = $c -replace ' 결안에', ' 안에'
$c = $c -replace ' 결 안에', ' 안에'
$c = $c -replace ' 결과 같은', ' 같은'
$c = $c -replace ' 결과 함께', ' 함께'
$c = $c -replace ' 결과 다른', ' 다른'
$c = $c -replace '한 자락의 결', '한 자락'
$c = $c -replace '책임의 결', '책임의 모습'
$c = $c -replace '시니어의 결', '시니어의 모습'
$c = $c -replace '회의실의 결', '회의실의'
$c = $c -replace '단정한 결', '단정한'
$c = $c -replace '한 결씩', '한 번씩'
$c = $c -replace '한 결을', ''
$c = $c -replace '한 결도', ''

# 보호 복원
foreach ($token in $protect_map.Keys) {
    $c = $c -replace [regex]::Escape($token), $protect_map[$token]
}

# 정돈
$c = $c -replace '  +', ' '
$c = $c -replace '<p>\s*</p>', ''

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "결 출현 (before): $before"
Write-Host "결 출현 (after): $after"
Write-Host "감소: $($before - $after)"
