[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# 1) 프롤로그/서문의 부 응 따우 예시 → 베트남 매핑 207건으로 변경
$c = $c -replace '일요일 부 응 따우 해변의 거친 파도를 기억하는 독자는 그 옆에 깔린 한-베트남 FTA C/O Form VK를 잊지 않는다\.', '베트남 빈증성 공장의 매핑 207건을 기억하는 독자는 그 옆에 깔린 본사-자회사 통합 거버넌스 헌장 5조항을 잊지 않는다.'

# 2) 매핑 인덱스 부 응 따우 / 432호 초인종 행 제거
$c = $c -replace ' <tr><td>31장 부 응 따우 해변 거친 파도</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>31장 베트남 호텔 일요일 밤 산책 / 지수의 432호 초인종</td><td>[^<]*</td><td>[^<]*</td></tr>', ''

# 3) 매핑 인덱스 베트남 출장 4시간 1 행도 제거
$c = $c -replace ' <tr><td>31장 베트남 출장 4시간 1 \(호텔 432호\)</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>31장 신입 지수 합류 / "선배 이상형은\?"</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>31장 거실의 다섯 마디 다짐</td><td>[^<]*</td><td>[^<]*</td></tr>', ''
$c = $c -replace ' <tr><td>31장 한국 본사 수출입 5모습</td><td>[^<]*</td><td>[^<]*</td></tr>', ''

# 4) 색인 ㅂ 부 응 따우 제거
$c = $c -replace ' <li>부 응 따우 해변 — <a href="#scene-vung-tau">31장</a></li>', ''

# 5) 색인 ㅂ 베트남 출장 — anchor 변경
$c = $c -replace ' <li>베트남 출장 \(4박 5일\) — <a href="#scene-vn-departure">31장</a></li>', ' <li>베트남 출장 (4박 5일, 매핑 207건+거버넌스 합의) — <a href="#ch31">31장 31.5</a></li>'

# 6) 색인 ㅇ 응우옌 부장 — anchor 변경
$c = $c -replace ' <li>응우옌 부장 \(베트남 법인\) — <a href="#scene-vn-departure">31장</a></li>', ' <li>응우옌 부장 (베트남 법인장) — <a href="#ch31">31장 31.10</a></li>'

# 7) 썸 리스트 베트남 4개 항목 제거
$c = $c -replace ' <li><a href="#scene-vn-departure">31장 — 베트남 출장 / 인천공항 환송</a></li>', ''
$c = $c -replace ' <li><a href="#scene-vn-1hour">31장 — 베트남 호텔 4시간의 1[^<]*</a></li>', ''
$c = $c -replace ' <li><a href="#scene-vung-tau">31장 — 부 응 따우 해변 거친 파도</a></li>', ''
$c = $c -replace ' <li><a href="#scene-432-bell">31장 — 신입 432호 초인종 \+ 일요일 밤 산책</a></li>', ''

# 8) 새로운 베트남 시퀀스 항목 추가 (썸 리스트는 로맨스 전용, 베트남 합방은 살짝 추가)
# 정원 산책 시퀀스가 사라졌으니 썸 리스트에 추가 안 함

# 9) 본문 마지막 다섯 명제 단락의 다섯이 두였으니 — 이전에 5월 토요일 정리에서 처리됨

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "잔재 정리: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host ""
Write-Host "scene-vn-departure 잔여: $(([regex]::Matches($c, 'scene-vn-departure')).Count)"
Write-Host "scene-vn-1hour 잔여: $(([regex]::Matches($c, 'scene-vn-1hour')).Count)"
Write-Host "scene-vung-tau 잔여: $(([regex]::Matches($c, 'scene-vung-tau')).Count)"
Write-Host "scene-432-bell 잔여: $(([regex]::Matches($c, 'scene-432-bell')).Count)"
Write-Host "부 응 따우 잔여: $(([regex]::Matches($c, '부 응 따우')).Count)"
Write-Host "432호 초인종 잔여: $(([regex]::Matches($c, '432호 초인종')).Count)"
