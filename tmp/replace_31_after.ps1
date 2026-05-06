$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8

# Start marker (right after 31장 핵심 박스)
$startMarker = '<p>베트남 출장에서 돌아온 후 2주가 흘렀다.'
$endMarker = '<hr class="scene"> <!-- 32장 MES -->'

$startIdx = $content.IndexOf($startMarker)
$endIdx = $content.IndexOf($endMarker)

if ($startIdx -lt 0) { throw 'Start marker not found' }
if ($endIdx -lt 0) { throw 'End marker not found' }

Write-Host "Start: $startIdx, End: $endIdx"
Write-Host "Old length: $($endIdx - $startIdx)"

$newSequence = @"
<p>베트남에서 돌아온 후 2주. 회의실에서 서책임의 86도가 그대로였다. 다만 한 단계 더 정확했다.</p>

 <p>둘은 묻지 않았다.</p>

 <p>UAT 종료. 컷오버 D-30. 12월 컷오버. Go-Live. 안정화 8주. Hyper Care. 5개월이 흘러갔다.</p>

 <hr class="scene">

 <p>5월의 어느 금요일 밤 11시 47분. 결산 회식이 9시쯤 끝나고 오피스텔에 들어와 누워 있었다. 초인종이 울렸다.</p>

 <p>서책임이었다. 정장이 아니라 카디건과 청바지. 손에 와인 한 병.</p>

 <p>"잠깐."</p>

 <p>문을 열었다.</p>

 <p id="scene-may-table">새벽 5시 23분. 그녀가 떠났다. 협탁에 단정하게 접힌 A4 한 장.</p>

 <p>그날 아침. 빛이 창을 가만히 두드렸다. 베개에 향이 남아 있었다. 비 온 다음 날 아침의 풀 같은 향. 협탁의 종이는 — 책의 첫 페이지에 있다.</p>

 <hr class="scene">

 <p>다음 주 월요일 9시. 서책임이 회의실에 평소처럼 들어왔다.</p>

 <p>"Hyper Care 결산 항목 12개를 오늘 마무리합시다."</p>

 <p>나도 평소처럼 답했다.</p>
"@

# Replace from startIdx to endIdx (exclusive of endMarker, so we keep <hr class="scene"> <!-- 32장 MES -->)
$before = $content.Substring(0, $startIdx)
$after = $content.Substring($endIdx)

$newContent = $before + $newSequence + ' ' + $after

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
Write-Host "Diff: $($newContent.Length - $content.Length)"
Write-Host "Done"
