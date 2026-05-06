$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8

# Start: right after APICS box closing </blockquote>
$startMarker = '<p>IST 통과 후 UAT(User Acceptance Test). 클라이언트 사용자가 직접 테스트하고, 통과 여부를 결정한다. 컨설턴트는 보조 역할.</p>'
# End: right before 31.5 베트남 출장 section
$endMarker = '<h4>31.5 베트남 출장'

$startIdx = $content.IndexOf($startMarker)
$endIdx = $content.IndexOf($endMarker)

if ($startIdx -lt 0) { throw 'Start marker not found' }
if ($endIdx -lt 0) { throw 'End marker not found' }

# Move startIdx to after startMarker (we keep the IST 통과 후 sentence)
$startIdxAfter = $startIdx + $startMarker.Length

Write-Host "Start: $startIdxAfter, End: $endIdx"
Write-Host "Old length: $($endIdx - $startIdxAfter)"

$newSequence = @"

 <hr class="scene">

 <p>회식 다음 날부터 서책임이 한 단계 새침해졌다. 평소 시선이 짧아졌다. 점심 자리에서 박 부장에게는 농담을 던졌고, 이 차장에게도 던졌고, 내게는 던지지 않았다.</p>

 <hr class="scene">

 <p>그 주 금요일. 서책임이 평소 톤으로 말했다.</p>

 <p>"윤지수씨, 다음 주부터 내 옆자리로 와요. 신입 양성 6개월 다 채웠고, 이제 PM 옆에서 본격 운영 보좌해야 할 자리예요."</p>

 <p>"네 책임님, 감사합니다."</p>

 <p>월요일 아침. 지수의 명함 케이스가 서책임 옆자리 책상 위에 가지런히 옮겨져 있었다. 핑크 골드 라인이 형광등 아래에서 살짝 빛났다.</p>

 <hr class="scene">

 <p>나흘째 오후. 카톡 한 줄.</p>

 <p>"책임님, 소주 한잔 하실래요"</p>

 <p>마침표 없이.</p>

 <p>답이 8분 후에 왔다.</p>

 <p>"8시. 회사 앞 한식집."</p>

 <hr class="scene">

 <p>한식집 안쪽 자리. 단둘. 소주 한 병이 30분 안에 비워졌다. 서책임이 잔을 든 손목이 평소보다 천천히 움직였다.</p>

 <p>네 잔째에 그녀가 평소 톤이 아닌 한 마디를 던졌다.</p>

 <p>"민준씨. 너 요새 왜 그래."</p>

 <p>나는 답을 못 했다.</p>

 <p>다섯 잔째.</p>

 <p>"나는 30대 후반인데 — 누구한테 말할 수가 없는 게 너무 많아."</p>

 <p>그녀가 자기 잔만 보고 있었다.</p>

 <p>여섯 잔째에 단어 셋이 흘러나왔다. 외로움. 무서움. 한 번도. 평소 사전에 없던 단어 셋.</p>

 <p>그녀가 잠깐 손을 들어 내 손목을 짚었다. 한 번. "고마워." 다시 거뒀다.</p>

 <p>새벽 1시 반. 그녀가 택시를 잡으면서 한 마디 던졌다.</p>

 <p>"내일은 평소처럼."</p>

 <p>택시 미등이 시화 거리 끝으로 멀어졌다.</p>

 <hr class="scene">

 <p>이튿날 밤 10시 47분. 회의실에 지수와 나, 둘만 남아 있었다. 서책임은 다른 회의실에서 컷오버 점검 중. 지수가 결함 분류 시트를 들고 옆자리로 왔다. 30분쯤 같이 분류했다.</p>

 <p>지수가 펜을 잠깐 내려놨다.</p>

 <p>"선배, 이상형이 어떻게 되세요?"</p>

 <p>"그런 거 없어요. 야근하느라 누구 만날 시간도 없어요."</p>

 <p>"에이, 그게 어디 있어요. 솔직하게요."</p>

 <p>지수가 펜을 다시 들었다.</p>

 <p>"저는 일 잘하는 선배가 좋아요. ...같이 야근하면서 이렇게 가르쳐주는 선배 같은."</p>

 <p>그 순간 회의실 문이 살짝 열린 채로 — 그 문 밖 복도를 서책임이 지나갔다. 발걸음이 한 번 멈췄다. 다시 평소 속도로 자기 자리로 갔다.</p>

 <p>11시 31분에 지수가 퇴근했다. 회의실에 서책임과 나, 둘만 남았다.</p>

 <p>서책임이 자기 자리에서 음성으로 불렀다.</p>

 <p>"민준씨, 207번 컷오버 항목 잠깐 와서 봐 주세요."</p>

 <p>30분쯤 207번을 같이 봤다. 그 30분 동안 한 번도 신입 이야기를 꺼내지 않았다. "이상형"이라는 단어도 한 번도. 자정이 지나서 207번을 마무리했다.</p>

 <p>"수고했어."</p>

 <p>같이 회의실을 나섰다.</p>

 <hr class="scene">

"@

# Replace
$before = $content.Substring(0, $startIdxAfter)
$after = $content.Substring($endIdx)

$newContent = $before + $newSequence + $after

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "Old size: $($content.Length)"
Write-Host "New size: $($newContent.Length)"
Write-Host "Diff: $($newContent.Length - $content.Length)"
Write-Host "Done"
