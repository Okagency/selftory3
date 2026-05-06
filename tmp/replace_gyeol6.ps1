[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '결')).Count

# 본래 단어 보호 (마커 치환)
$protect = @{
  '결혼' = '@@P1@@'
  '결산' = '@@P2@@'
  '결과' = '@@P3@@'
  '결정' = '@@P4@@'
  '결심' = '@@P5@@'
  '결국' = '@@P6@@'
  '결말' = '@@P7@@'
  '결합' = '@@P8@@'
  '결제' = '@@P9@@'
  '결재' = '@@P10@@'
  '연결' = '@@P11@@'
  '체결' = '@@P12@@'
  '단결' = '@@P13@@'
  '타결' = '@@P14@@'
  '해결' = '@@P15@@'
  '종결' = '@@P16@@'
  '결손' = '@@P17@@'
  '결식' = '@@P18@@'
  '결렬' = '@@P19@@'
  '결행' = '@@P20@@'
  '결격' = '@@P21@@'
  '결자' = '@@P22@@'
  '결석' = '@@P23@@'
  '결함' = '@@P24@@'
  '결근' = '@@P25@@'
  '청결' = '@@P26@@'
  '결단' = '@@P27@@'
  '미결' = '@@P28@@'
  '대결' = '@@P29@@'
  '결별' = '@@P30@@'
  '결집' = '@@P31@@'
  '결정성' = '@@P32@@'
}
foreach ($k in $protect.Keys) {
  $c = $c -replace $k, $protect[$k]
}

# 어색한 자동 치환 결과 정리
$c = $c -replace '한 자세였다\.', '한 번이었다.'
$c = $c -replace '한 자세였\)', '한 번)'
$c = $c -replace '한 자세였', '그랬'
$c = $c -replace '한 자세\.', '한 모습.'
$c = $c -replace '한 자세 ', '한 모습 '
$c = $c -replace '한 자세를 ', '한 모습을 '
$c = $c -replace '한 자세가 ', '한 모습이 '
$c = $c -replace '한 자세에', '한 모습에'

# 잔여 "결" 적극 정리
$c = $c -replace ' 결의 ', ' '
$c = $c -replace ' 결로 ', ' 모습으로 '
$c = $c -replace ' 결로\.', ' 모습으로.'
$c = $c -replace ' 결이 ', ' 모습이 '
$c = $c -replace ' 결을 ', ' 모습을 '
$c = $c -replace ' 결도 ', ' 모습도 '
$c = $c -replace ' 결까지 ', ' 모습까지 '
$c = $c -replace '한 결', '한 번'
$c = $c -replace '그 결', '그 모습'
$c = $c -replace '평소 결', '평소 모습'
$c = $c -replace '어떤 결', '어떤 모습'
$c = $c -replace '다른 결', '다른 모습'
$c = $c -replace '같은 결', '같은 모습'
$c = $c -replace '결의', ''
$c = $c -replace '흐른 결', '흐른 시간'
$c = $c -replace '흐름 결', '흐름'

# 후처리
$c = $c -replace '  +', ' '
$c = $c -replace ' \.', '.'
$c = $c -replace ' ,', ','

# 보호 단어 복원
foreach ($k in $protect.Keys) {
  $c = $c -replace $protect[$k], $k
}

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "결 출현 횟수: $before -> $after"
