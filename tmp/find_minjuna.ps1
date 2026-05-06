[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

# 새 미묘한 자리에 id 부여
$replacements = @(
  @('<p>그 순간 — 손가락 끝에서 마커가 한 번 미끄러져', '<p id="scene-marker-drop">그 순간 — 손가락 끝에서 마커가 한 번 미끄러져'),
  @('<p>구축 4개월 말 어느 월요일 새벽 1시 47분\. 회의실에 한 책임 혼자 남아 IST', '<p id="scene-hair-tie">구축 4개월 말 어느 월요일 새벽 1시 47분. 회의실에 한 책임 혼자 남아 IST'),
  @('<p>D-Day까지 30영업일\. 이 30일은 18개월 프로젝트의 가장 압축된 시간이다\. 한 책임이 회의실 한쪽 벽에', '<p id="scene-chair-shirt">D-Day까지 30영업일. 이 30일은 18개월 프로젝트의 가장 압축된 시간이다. 한 책임이 회의실 한쪽 벽에'),
  @('<p>Go-Live \+ 5주차 첫째 날 새벽 3시 47분\. 한 책임이', '<p id="scene-dawn-hair">Go-Live + 5주차 첫째 날 새벽 3시 47분. 한 책임이')
)
$count = 0
foreach ($r in $replacements) {
  if ($c -match $r[0]) {
    $c = $c -replace $r[0], $r[1]
    $count++
  }
}
$c | Set-Content $f -Encoding UTF8 -NoNewline
Write-Host "id 부여: $count / $($replacements.Count)"
