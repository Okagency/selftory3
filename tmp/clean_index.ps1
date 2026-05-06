$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$content = Get-Content -Path $bookPath -Raw -Encoding UTF8

# Find #index section bounds
$indexStart = $content.IndexOf('<section id="index">')
$indexEnd = $content.IndexOf('</section>', $indexStart) + '</section>'.Length

if ($indexStart -lt 0) { throw 'Index section not found' }

$indexBlock = $content.Substring($indexStart, $indexEnd - $indexStart)

# Remove lines (li elements) in index that link to scene-* anchors or are character/sum entries
$itemsToRemove = @(
 # 썸 자리 (#scene-* 또는 인물 이벤트)
 '<li>강현수 책임 (라이벌 PM) — <a href="#scene-secret-leak">33장 직전</a></li>',
 '<li>누나 회식 — <a href="#scene-noona">35장</a></li>',
 '<li>라면 먹고 가 — <a href="#scene-ramyeon">30장</a></li>',
 '<li>박서연 (한성정밀 회계팀 3년차, "ERP 일 안 줄어든다" 짜증→석 달 후 자진 퇴사) — <a href="#scene-park-seoyeon">30장 직후</a></li>',
 '<li>셔츠 한 겹 (Hyper Care 마지막) — <a href="#ch38">38장 끝</a></li>',
 '<li>숨결이 들어왔다 (Hyper Care 마지막) — <a href="#ch38">38장 끝</a></li>',
 '<li>사진 한 장 ("지워주세요") — <a href="#scene-photo-mistake">31장 후반</a></li>',
 '<li>쪽지 한 장 ("이건 옵션이야") — <a href="#prologue">프롤로그 / 5월의 토요일 아침</a></li>',
 '<li>컷오버 D-1 새벽 — <a href="#scene-d1-dawn">37장 직전</a></li>',
 '<li>컷오버 D-3 War Room — <a href="#scene-d3-lip">36장</a></li>',
 '<li>합 맞춤 (새벽 GL 분개) — <a href="#scene-gl-handoff">28장</a></li>',
 '<li>해변 꿈 (베트남) — <a href="#scene-beach-dream">32장</a></li>',
 '<li>D-1 새벽 — <a href="#scene-d1-dawn">37장 직전</a></li>',
 '<li>D-3 War Room — <a href="#scene-d3-lip">36장</a></li>',

 # 인물 캐릭터 (썸 색인으로 이동)
 '<li>김 부장 (한성정밀 회계팀, 27년차) — <a href="#ch33">33장</a></li>',
 '<li>김 사장 (한성정밀 대표) — <a href="#ch4">4장</a>, <a href="#ch13">13장</a></li>',
 '<li>민준 (정민준, 5년차 시니어 어소시에이트) — <a href="#ch1">1장</a></li>',
 '<li>박 부장 (시니어 매니저, MM 담당) — <a href="#ch1">1장</a>, <a href="#ch16">16장</a></li>',
 '<li>송 PM (12년 전 멘토 회상) — 회식 자리</li>',
 '<li>신입 지수 (26세, 1년차 어소시에이트) — <a href="#ch1">1장</a>, <a href="#ch31">31장</a></li>',
 '<li>응우옌 부장 (베트남 법인장) — <a href="#ch31">31장 31.10</a></li>',
 '<li>이 차장 (PP 담당) — <a href="#ch1">1장</a></li>',
 '<li>서지원 책임 (PM, 37세, 12년차) — <a href="#ch1">1장</a></li>',
 '<li>한성정밀 (자동차 1차 협력사) — <a href="#ch1">1장</a>, <a href="#ch4">4장</a></li>',
 '<li>회식 (2차 30분 술자리) — <a href="#ch6">6장</a></li>',

 # 이벤트
 '<li>베트남 출장 (4박 5일, 매핑 207건+거버넌스 합의) — <a href="#ch31">31장 31.5</a></li>',

 # 책 메타·프롤로그
 '<li>프롤로그 (5월의 토요일 아침) — <a href="#prologue">책 시작</a></li>',
 '<li>회의실 31번 — <a href="#ch1">1장</a></li>'
)

$cleanedBlock = $indexBlock
$removedCount = 0
foreach ($item in $itemsToRemove) {
 if ($cleanedBlock.Contains($item)) {
 $cleanedBlock = $cleanedBlock.Replace($item, '')
 $removedCount++
 Write-Host "Removed: $($item.Substring(0, [Math]::Min(60, $item.Length)))..."
 }
}

$newContent = $content.Substring(0, $indexStart) + $cleanedBlock + $content.Substring($indexEnd)

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host ""
Write-Host "Removed $removedCount items"
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
