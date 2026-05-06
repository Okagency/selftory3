[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '결')).Count

# 보호: 직결·결여 추가
$c = $c -replace '직결', '@@PRT_J@@'
$c = $c -replace '결여', '@@PRT_Y@@'

# 잔여 외자 추상어 패턴
$c = $c -replace '깊은 결은', '깊은 자리는'
$c = $c -replace '깊은 결의', '깊은'
$c = $c -replace '둔 결처럼', '둔 모습처럼'
$c = $c -replace '둔 결인', '둔 자리인'
$c = $c -replace '둔 결의', '둔'
$c = $c -replace '울리는 결은', '울리는 일은'
$c = $c -replace '울리는 결의', '울리는'
$c = $c -replace '너졌을 결인', '너졌을 자리인'
$c = $c -replace '86도 결에', '86도 자세에'
$c = $c -replace '회사 결로', '회사 모습으로'
$c = $c -replace '표준 결입', '표준 자세입'
$c = $c -replace '책임 결에', '책임 자세에'
$c = $c -replace '신입 결에', '신입 자세에'
$c = $c -replace '빛의 결인', '빛의 자리인'
$c = $c -replace '보낸 결인', '보낸 자리인'
$c = $c -replace '던진 결인', '던진 자리인'
$c = $c -replace '깨는 결은', '깨는 자리는'
$c = $c -replace '입의 결인', '입의 모습인'
$c = $c -replace '해 둔 결인', '해 둔 자리인'

# 외자 결의 모든 패턴 — 마지막 깔끔히
$c = $c -replace ' 결인 ', ' 자리인 '
$c = $c -replace ' 결인지', ' 자리인지'
$c = $c -replace ' 결처럼', ' 모습처럼'

# 보호 복원
$c = $c -replace '@@PRT_J@@', '직결'
$c = $c -replace '@@PRT_Y@@', '결여'

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "결 출현: $before -> $after"
