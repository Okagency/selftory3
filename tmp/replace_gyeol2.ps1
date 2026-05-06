[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '결')).Count

# 본래 단어 보호 (마커)
$protect = @{
  '결혼'='@@P1@@'; '결산'='@@P2@@'; '결과'='@@P3@@'; '결정'='@@P4@@'; '결심'='@@P5@@'
  '결국'='@@P6@@'; '결말'='@@P7@@'; '결합'='@@P8@@'; '결제'='@@P9@@'; '결재'='@@P10@@'
  '연결'='@@P11@@'; '체결'='@@P12@@'; '단결'='@@P13@@'; '타결'='@@P14@@'; '해결'='@@P15@@'
  '종결'='@@P16@@'; '결손'='@@P17@@'; '결식'='@@P18@@'; '결렬'='@@P19@@'; '결행'='@@P20@@'
  '결격'='@@P21@@'; '결자'='@@P22@@'; '결석'='@@P23@@'; '결함'='@@P24@@'; '결근'='@@P25@@'
  '청결'='@@P26@@'; '결단'='@@P27@@'; '미결'='@@P28@@'; '대결'='@@P29@@'; '결별'='@@P30@@'
  '결집'='@@P31@@'; '결정성'='@@P32@@'; '결품'='@@P33@@'; '응결'='@@P34@@'; '동결'='@@P35@@'
  '결론'='@@P36@@'; '무심결'='@@P37@@'; '숨결'='@@P38@@'
}
foreach ($k in $protect.Keys) { $c = $c -replace $k, $protect[$k] }

# 잔여 추상어 패턴 적극 치환
$c = $c -replace '있는 결</td>', '있는 자리</td>'
$c = $c -replace '있는 결은', '있는 자리는'
$c = $c -replace '있는 결이', '있는 자리가'
$c = $c -replace '없는 결의', '없는'
$c = $c -replace '없는 결로', '없는 자세로'
$c = $c -replace '없는 결\.', '없는 모습.'
$c = $c -replace '에 한 결로', '에 한 모습으로'
$c = $c -replace '결이 무너', '흐름이 무너'
$c = $c -replace '아래의 결은', '아래의 모습은'
$c = $c -replace '아래의 결이', '아래의 모습이'
$c = $c -replace '스터의 결</td>', '스터의 모습</td>'
$c = $c -replace '비치는 결', '비치는 자리'
$c = $c -replace '보내는 결인', '보내는 사람인'
$c = $c -replace '보내는 결은', '보내는 사람은'
$c = $c -replace '수 결</td>', '수 모습</td>'
$c = $c -replace '결</td>', '모습</td>'
$c = $c -replace '결의 묶음', '의미'
$c = $c -replace '결 시퀀스', '시퀀스'
$c = $c -replace '의 결로 섞', '의 자세로 섞'
$c = $c -replace '의 결로 ', '의 자세로 '
$c = $c -replace '의 결이었', '의 모습이었'
$c = $c -replace '의 결이 ', '의 모습이 '
$c = $c -replace '의 결을 ', '의 모습을 '
$c = $c -replace '의 결의 ', '의 '
$c = $c -replace '의 결\.', '의 모습.'
$c = $c -replace '의 결,', '의 모습,'
$c = $c -replace ' 결,', ' 자세,'
$c = $c -replace ' 결\.', ' 자세였다.'
$c = $c -replace ' 결\)', ' 자세)'
$c = $c -replace ' 결$', ' 자세'

# 보호 단어 복원
foreach ($k in $protect.Keys) { $c = $c -replace $protect[$k], $k }

$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "결 출현: $before -> $after"
