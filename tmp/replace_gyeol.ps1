[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$c = Get-Content $f -Raw -Encoding UTF8
$before = ([regex]::Matches($c, '결')).Count

# 가장 긴 패턴부터 치환 (specific → general)
$c = $c -replace '결의 결의 결의 결', '무게 안의 무게'
$c = $c -replace '결의 결의 결', '본질의 본질'
$c = $c -replace '결의 결', '본질의 본질'
$c = $c -replace '결의 정확함', '단정함'
$c = $c -replace '결의 무게', '무게'
$c = $c -replace '결의 회수', '회수'
$c = $c -replace '결의 동력', '동력'
$c = $c -replace '결의 흔들림', '흔들림'
$c = $c -replace '결의 균열', '균열'
$c = $c -replace '결의 가르침', '가르침'
$c = $c -replace '결의 짧은 웃음', '짧은 웃음'
$c = $c -replace '결의 첫 측정값', '첫 측정값'
$c = $c -replace '결의 측정값', '측정값'
$c = $c -replace '결의 평서문', '평서문'
$c = $c -replace '결의 한 마디', '한 마디'
$c = $c -replace '결의 시작', '시작'
$c = $c -replace '결의 결정성', '결정성'
$c = $c -replace '결의 결정', '결정 자체'
$c = $c -replace '결의 결의', ''
$c = $c -replace '결의 자리', '자리'
$c = $c -replace '결의 표면', '표면'
$c = $c -replace '결의 침묵', '침묵'
$c = $c -replace '결의 회복', '회복'
$c = $c -replace '결의 시선', '시선'
$c = $c -replace '결의 미소', '미소'
$c = $c -replace '결의 호칭', '호칭'
$c = $c -replace '결의 인사', '인사'
$c = $c -replace '결의 답신', '답신'
$c = $c -replace '결의 평일', '평일'
$c = $c -replace '결의 카톡', '카톡 한 줄'
$c = $c -replace '결의 농담', '농담'
$c = $c -replace '결의 결의 결', ''  # noop after above

# 평소 결 패턴
$c = $c -replace '평소 결로는', '평소라면'
$c = $c -replace '평소 결의 결로', '평소 자리에서는'
$c = $c -replace '평소 결로', '평소 모습으로'
$c = $c -replace '평소 결의', '평소'
$c = $c -replace '평소 결', '평소 모습'

# 그 결 패턴
$c = $c -replace '그 결이', '그 자리가'
$c = $c -replace '그 결을', '그 자리를'
$c = $c -replace '그 결의', '그 자리의'
$c = $c -replace '그 결로', '그 톤으로'
$c = $c -replace '그 결도', '그 자리도'
$c = $c -replace '그 결까지', '그 자리까지'

# 한 결 패턴
$c = $c -replace '한 결로는', '한 톤으로는'
$c = $c -replace '한 결로', '한 톤으로'
$c = $c -replace '한 결의', '한 톤의'
$c = $c -replace '한 결을', '한 톤을'
$c = $c -replace '한 결이', '한 톤이'
$c = $c -replace '한 결도', '한 톤도'
$c = $c -replace '한 결씩', '한 톤씩'

# 어떤/다른/같은 결
$c = $c -replace '어떤 결', '어떤 자세'
$c = $c -replace '다른 결로', '다른 자세로'
$c = $c -replace '다른 결의', '다른'
$c = $c -replace '다른 결', '다른 모습'
$c = $c -replace '같은 결로', '같은 톤으로'
$c = $c -replace '같은 결의', '같은'
$c = $c -replace '같은 결', '같은 모습'

# 결의 단독 패턴 (조사 따라)
$c = $c -replace '결이 흐른', '흐름이 흐른'
$c = $c -replace '결이 비치', '한 톤이 비치'
$c = $c -replace '결이 머물', '한 톤이 머물'
$c = $c -replace '결이 한 번', '한 톤이 한 번'

# 30분의 결, 0.4초의 결 패턴
$c = $c -replace '의 결이었다', '의 모습이었다'
$c = $c -replace '의 결이라', '의 모습이라'
$c = $c -replace '의 결이지', '의 모습이지'

# 정리 후 횟수
$after = ([regex]::Matches($c, '결')).Count
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "결 출현 횟수: $before -> $after"
