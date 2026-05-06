[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '결')).Count

# 합성어 모두 보호
$protect = @(
  '결혼','결산','결과','결정','결심','결국','결말','결합','결제','결재',
  '연결','체결','단결','타결','해결','종결','결손','결식','결렬','결행',
  '결격','결자','결석','결함','결근','청결','결단','미결','대결','결별',
  '결집','결품','응결','동결','결론','숨결','머리결','무심결','순결',
  '결정성','결정자','결정권','결정과','결재선','결자해지'
)
$markers = @{}
$i = 0
foreach ($w in $protect) {
  $marker = "@@PRT$i@@"
  $markers[$marker] = $w
  $c = $c -replace $w, $marker
  $i++
}

# 이제 남은 모든 "결"은 외자 추상어 — 적극적 치환

# 긴 패턴부터
$c = $c -replace '결의 결의 결', '본질의 본질'
$c = $c -replace '결의 결', '본질'
$c = $c -replace '결의', ''

# 조사 패턴
$c = $c -replace ' 결로 ', ' 모습으로 '
$c = $c -replace ' 결로\.', ' 모습으로.'
$c = $c -replace ' 결이 ', ' 모습이 '
$c = $c -replace ' 결을 ', ' 모습을 '
$c = $c -replace ' 결도 ', ' 모습도 '
$c = $c -replace ' 결만 ', ' 모습만 '
$c = $c -replace ' 결까지 ', ' 모습까지 '
$c = $c -replace ' 결에 ', ' 자리에 '
$c = $c -replace ' 결씩 ', ' 자락씩 '
$c = $c -replace ' 결 ', ' '
$c = $c -replace ' 결\.', '.'
$c = $c -replace ' 결,', ','
$c = $c -replace ' 결\)', ')'
$c = $c -replace ' 결</', ' 모습</'
$c = $c -replace '한 결', '한 모습'
$c = $c -replace '그 결', '그 자리'
$c = $c -replace '평소 결', '평소 모습'
$c = $c -replace '어떤 결', '어떤 모습'
$c = $c -replace '다른 결', '다른 모습'
$c = $c -replace '같은 결', '같은 모습'

# 보호 단어 복원
foreach ($m in $markers.Keys) {
  $c = $c -replace $m, $markers[$m]
}

# 잔여 정리
$c = $c -replace '  +', ' '

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "결 출현: $before -> $after"
