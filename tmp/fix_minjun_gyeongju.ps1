[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$before = ([regex]::Matches($c, '민준아')).Count

# 1) 회의실/공적 자리의 "민준아"는 모두 "민준씨"로 (전체 일괄)
# 2) 경주 시퀀스 14회 중 핵심 사적 4-5개 KEEP, 나머지 변경

# 경주 섹션 일괄 변경 후 핵심 4개 복원
# 핵심 보존 패턴 임시 보호
$c = $c -replace '민준아, 정말 미안한데 — 결혼식까지', '@@KEEP_M1@@'
$c = $c -replace '민준아, 잠이 안 와서', '@@KEEP_M2@@'
$c = $c -replace '\.\.\.민준아\. 비치지 않은', '@@KEEP_M3@@'
$c = $c -replace '잘 자, 민준아\.', '@@KEEP_M4@@'
$c = $c -replace '민준아, 오늘 밤 — 정말 고마워\. 황룡사지', '@@KEEP_M5@@'

# 회식 2차 포장마차 핵심 보존 (사적·빗장 풀림)
$c = $c -replace '"민준아\." 평소 톤이 아니었다\. "사실은 — 나는 12년 전에', '@@KEEP_M6@@'
$c = $c -replace '"민준아, 오늘 이거 못 들은 걸로 해 줘\."', '@@KEEP_M7@@'
$c = $c -replace '"민준아, 우리 진짜 30분 됐다\.', '@@KEEP_M8@@'
$c = $c -replace '"민준아, 너 처음 회의실에서', '@@KEEP_M9@@'
$c = $c -replace '"민준아, 이 일 재미있니\?"', '@@KEEP_M10@@'

# 라면 보존
$c = $c -replace '"민준아, 라면 먹고 가\."', '@@KEEP_M11@@'

# 베트남 천막 보존
$c = $c -replace '"민준아\." 평소 톤이 아니었다\. "여기는 회의실이 아니야\."', '@@KEEP_M12@@'

# 회의실 단둘 + 미안해 자리 보존
$c = $c -replace '"\.\.\.민준아\. 평소대로 안 비치는 게', '@@KEEP_M13@@'

# 마지막 작별 보존
$c = $c -replace '"민준아\." 평소 톤이었다\. "다음 프로젝트', '@@KEEP_M14@@'

# 마지막 가르침 (구두) 보존
$c = $c -replace '"민준아, 컨설턴트의 가치는', '@@KEEP_M15@@'
$c = $c -replace '"민준아, 컨설턴트로 10년', '@@KEEP_M16@@'
$c = $c -replace '"민준아, 한 회사가 진짜로', '@@KEEP_M17@@'

# 라면 썸 리스트 라벨 보존
$c = $c -replace '"민준아, 라면 먹고 가"', '@@KEEP_M18@@'

# 강 책임 떠난 후 회의실 단둘 가르침 보존
$c = $c -replace '"\.\.\.민준아, 회사 안에는', '@@KEEP_M19@@'

# 이제 남은 "민준아"는 모두 "민준씨"로 변경
$c = $c -replace '민준아', '민준씨'

# 보존 복원
$c = $c -replace '@@KEEP_M1@@', '민준아, 정말 미안한데 — 결혼식까지'
$c = $c -replace '@@KEEP_M2@@', '민준아, 잠이 안 와서'
$c = $c -replace '@@KEEP_M3@@', '...민준아. 비치지 않은'
$c = $c -replace '@@KEEP_M4@@', '잘 자, 민준아.'
$c = $c -replace '@@KEEP_M5@@', '민준아, 오늘 밤 — 정말 고마워. 황룡사지'
$c = $c -replace '@@KEEP_M6@@', '"민준아." 평소 톤이 아니었다. "사실은 — 나는 12년 전에'
$c = $c -replace '@@KEEP_M7@@', '"민준아, 오늘 이거 못 들은 걸로 해 줘."'
$c = $c -replace '@@KEEP_M8@@', '"민준아, 우리 진짜 30분 됐다.'
$c = $c -replace '@@KEEP_M9@@', '"민준아, 너 처음 회의실에서'
$c = $c -replace '@@KEEP_M10@@', '"민준아, 이 일 재미있니?"'
$c = $c -replace '@@KEEP_M11@@', '"민준아, 라면 먹고 가."'
$c = $c -replace '@@KEEP_M12@@', '"민준아." 평소 톤이 아니었다. "여기는 회의실이 아니야."'
$c = $c -replace '@@KEEP_M13@@', '"...민준아. 평소대로 안 비치는 게'
$c = $c -replace '@@KEEP_M14@@', '"민준아." 평소 톤이었다. "다음 프로젝트'
$c = $c -replace '@@KEEP_M15@@', '"민준아, 컨설턴트의 가치는'
$c = $c -replace '@@KEEP_M16@@', '"민준아, 컨설턴트로 10년'
$c = $c -replace '@@KEEP_M17@@', '"민준아, 한 회사가 진짜로'
$c = $c -replace '@@KEEP_M18@@', '"민준아, 라면 먹고 가"'
$c = $c -replace '@@KEEP_M19@@', '"...민준아, 회사 안에는'

$after = ([regex]::Matches($c, '민준아')).Count
$cnt_ssi = ([regex]::Matches($c, '민준씨')).Count

$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "민준아 출현: $before -> $after"
Write-Host "민준씨 출현: $cnt_ssi"
