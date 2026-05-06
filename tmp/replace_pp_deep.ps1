$ErrorActionPreference = 'Stop'
$bookPath = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$ppDeepPath = 'D:\dev\selftory\tmp\pp_deep_v2.txt'

$content = Get-Content -Path $bookPath -Raw -Encoding UTF8
$ppDeep = Get-Content -Path $ppDeepPath -Raw -Encoding UTF8

# Find start marker (h4 10.3) and end marker (h4 10.4)
$startMarker = '<h4>10.3 PP 모듈 인터뷰 표준 질문 35개</h4>'
$endMarker = '<h4>10.4 MM 모듈 인터뷰 표준 질문 35개'

$startIdx = $content.IndexOf($startMarker)
$endIdx = $content.IndexOf($endMarker)

if ($startIdx -lt 0) { throw 'Start marker not found' }
if ($endIdx -lt 0) { throw 'End marker not found' }

Write-Host "Start: $startIdx, End: $endIdx"
Write-Host "Old length: $($endIdx - $startIdx)"

# Replace from start marker through (but not including) end marker
$before = $content.Substring(0, $startIdx)
$after = $content.Substring($endIdx)

# Add closing transition phrase before MM section
$transition = ' <p>"이 35개를 다 묻는 건 아니야." 이 차장이 말했다. "10~15개를 미리 골라가고, 나머지는 대화 흐름에 따라 던지는 거야. 인터뷰는 시험이 아니라 대화야. 그리고 — 표면 답이 아니라 진짜 답을 끌어내는 게 12년차의 일이야."</p> '

$newContent = $before + $ppDeep.TrimEnd() + ' ' + $transition + $after

# Need to remove the old transition phrase that's already in $after
# Actually $after starts with `<h4>10.4` so the old transition was before it.
# We need to find and skip the old transition phrase too
# Old transition is right before <h4>10.4 — search for it
# The old text from $endIdx backwards has '</ol> <p>"이 35개를...'
# But we cut at startIdx so we lost the old <ol> opening. Let's look at what comes after
# Actually $after starts with the endMarker text directly because we sliced at $endIdx
# But there was text between </ol> and <h4>10.4 — the transition paragraph
# This text is BEFORE $endIdx (the start of <h4>10.4), so it's IN the part we cut

# Re-checking: $startIdx to $endIdx = from <h4>10.3 to before <h4>10.4
# This includes the OLD transition text. We replaced it with new transition. Good.

Set-Content -Path $bookPath -Value $newContent -Encoding UTF8 -NoNewline
Write-Host "New file size: $($newContent.Length)"
Write-Host "Done"
