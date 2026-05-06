[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# === 1) 경주 시퀀스 통째 제거 ===
# 시작: scene-gyeongju-call <p id> 시작
# 끝: <hr class="scene"> <!-- 31장 UAT --> 직전까지

$startMarker = '<p id="scene-gyeongju-call">'
$endMarker = '<!-- 31장 UAT -->'

$startIdx = $c.IndexOf($startMarker)
$endIdx = $c.IndexOf($endMarker)

if ($startIdx -lt 0) { Write-Host "시작 marker 못 찾음"; exit 1 }
if ($endIdx -lt 0) { Write-Host "끝 marker 못 찾음"; exit 1 }

# scene-gyeongju-call 시작부터 31장 직전 hr까지 제거
# hr class="scene" + 공백 포함해서 정확히 잘라내기
# 31장 직전 hr.scene 보존하고 그 사이만 제거
$hrBeforeCh31 = '<hr class="scene"> <!-- 31장 UAT -->'
$hrIdx = $c.IndexOf($hrBeforeCh31)
if ($hrIdx -lt 0) { Write-Host "hr+31장 marker 못 찾음"; exit 1 }

$before = $c.Substring(0, $startIdx)
$after = $c.Substring($hrIdx)
$result = $before + " " + $after

Write-Host "1단계: 경주 시퀀스 제거 ($($hrIdx - $startIdx)자)"

# === 2) 무영탑 한 줄을 5월 토요일 협탁 시퀀스에 이식 ===
# scene-may-table 단락 직전에 짧은 회상 한 줄 추가
$mayTableMarker = '<p id="scene-may-table">5월 토요일 아침 7시 47분.'
$mayTableIdx = $result.IndexOf($mayTableMarker)
if ($mayTableIdx -lt 0) { Write-Host "scene-may-table marker 못 찾음"; exit 1 }

$insertion = '<p>불국사 석가탑이 무영탑(無影塔)이라는 건 — 어디서 한 번 들은 적이 있다. <em>비치지 않은 자리가 그 탑의 자리를 만든다</em>고. 그날 협탁 위 종이 한 장이 같은 톤이었다.</p> '

$result2 = $result.Substring(0, $mayTableIdx) + $insertion + $result.Substring($mayTableIdx)
Write-Host "2단계: 무영탑 한 줄 이식 ($($insertion.Length)자)"

# === 3) 색인의 경주 관련 항목 제거 ===
# ㄱ: 경주 1박 2일
$result2 = $result2 -replace ' <li>경주 1박 2일 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
# ㄴ: (없음 - 누나 회식만)
# ㄷ: 다보탑·석가탑·대릉원·천마총·동궁과 월지
$result2 = $result2 -replace ' <li>다보탑·석가탑 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
$result2 = $result2 -replace ' <li>대릉원·천마총 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
$result2 = $result2 -replace ' <li>동궁과 월지 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
# ㅁ: 무영탑
$result2 = $result2 -replace ' <li>무영탑 \(석가탑\) — <a href="#scene-gyeongju">30장 직후</a></li>', ''
# ㅊ: 첨성대·천마총
$result2 = $result2 -replace ' <li>첨성대 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
$result2 = $result2 -replace ' <li>천마총 — <a href="#scene-gyeongju">30장 직후</a></li>', ''
# ㅎ: 황룡사지
$result2 = $result2 -replace ' <li>황룡사지 — <a href="#scene-gyeongju">30장 직후</a></li>', ''

# === 4) 썸 리스트 30장 직후 경주 1박 2일 항목 제거 ===
$result2 = $result2 -replace ' <li><a href="#scene-gyeongju">30장 직후 — 경주 1박 2일[^<]*</a></li>', ''

Write-Host "3-4단계: 색인·썸 리스트 정리"

$afterLen = $result2.Length
$result2 | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host "총 변화: $beforeLen -> $afterLen (감소 $($beforeLen - $afterLen)자)"
Write-Host "scene-gyeongju 잔여 참조: $(([regex]::Matches($result2,'scene-gyeongju')).Count)"
