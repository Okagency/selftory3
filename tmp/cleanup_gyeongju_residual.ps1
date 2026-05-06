[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 매핑 인덱스에서 경주 관련 3행 제거
$c = $c -replace ' <tr><td>경주 1박 2일 — 황룡사지 빈 터</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>경주 1박 2일 — 무영탑[^<]*</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>경주 1박 2일 — 천마총 봉분</td><td>[^<]*</td><td>[^<]*</td></tr>', ''

# "5월 토요일 — 동궁과 월지 새벽 침묵" — 5월 토요일에 동궁과 월지는 없음 (경주에 있던 것). 제거
$c = $c -replace ' <tr><td>5월 토요일 — 동궁과 월지 새벽 침묵</td><td>[^<]*</td><td>[^<]*</td></tr>', ''

# 0.2 핵심 명제 — 황룡사지·천마총·동궁과 월지 항목 제거 (무영탑은 5월 토요일에 이식했으니 살림)
$c = $c -replace ' <li><strong>흐름이 무너진 자리에 무게이 더 정확해진다\.</strong>[^<]*</li>', ''
$c = $c -replace ' <li><strong>비치지 않은 톤으로 두는 결정이 무게을 만든다\.</strong>[^<]*</li>', ' <li><strong>비치지 않은 톤으로 두는 결정이 무게을 만든다.</strong> — 무영탑 / 5월 토요일 협탁의 한 마디</li>'
$c = $c -replace ' <li><strong>표면은 흐르고, 내면은 가만히 살아 있다\.</strong>[^<]*</li>', ''
$c = $c -replace ' <li><strong>입 밖으로 꺼내지 않은 채 긴장이 살아 있다\.</strong>[^<]*</li>', ''

# 마지막 정리 멘트 — 다섯 명제 → 두 명제 (무영탑·5월 토요일)
$c = $c -replace '다섯 명제가 ERP 컨설팅의 무게과 한 톤으로 흐른다\. 다섯 명제 중 하나만 기억해도 — 18개월의 ERP 결과 두 사람의 모습이 한 톤으로 따라온다\.', '두 명제가 ERP 컨설팅의 무게와 한 톤으로 흐른다. 한 명제만 기억해도 — 18개월의 ERP와 두 사람의 모습이 한 톤으로 따라온다.'

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "추가 정리: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host "황룡사지 잔여: $(([regex]::Matches($c, '황룡사지')).Count)"
Write-Host "천마총 잔여: $(([regex]::Matches($c, '천마총')).Count)"
Write-Host "동궁과 월지 잔여: $(([regex]::Matches($c, '동궁과 월지')).Count)"
Write-Host "경주 잔여: $(([regex]::Matches($c, '경주')).Count)"
Write-Host "무영탑 잔여: $(([regex]::Matches($c, '무영탑')).Count) (5월 토요일에 이식)"
