[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$f = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$c = Get-Content $f -Raw -Encoding UTF8

$beforeLen = $c.Length

# === 회수 1: 41장 만년필 인계에 "사기꾼처럼 들리지?" + "우리는 다 그렇게 시작해" 추가 ===
$old1 = '"이거 내가 12년 전 송 PM한테 받은 거야. 그때 송 PM이 자기 12년 전 PM한테 받았다고 했어. 다음 신참한테 줘." 그게 다였다.'
$new1 = '"이거 내가 12년 전 송 PM한테 받은 거야. 그때 송 PM이 자기 12년 전 PM한테 받았다고 했어. 다음 신참한테 줘." 그러더니 잠깐의 침묵 끝에 한 마디 더 따라붙었다. <em>"그리고 — 그 신참한테 첫 한 마디 던질 때, 잊지 말아요. <strong>사기꾼처럼 들리지?</strong> — 그게 12년의 인계예요. 우리는 다 그렇게 시작해요. 그 신참만 그런 거 아니라고요."</em>'

if ($c.Contains($old1)) {
    $c = $c.Replace($old1, $new1)
    Write-Host "회수 1 (만년필 + 사기꾼처럼 들리지?): 완료"
} else {
    Write-Host "회수 1: marker 못 찾음"
}

# === 회수 2: 39장 D+5 결산 회식에 김 사장 어깨 두드림 + "술 잘 먹네" 추가 ===
$old2 = '회식 자리에서 김 사장은 마이크를 잡고 한 마디 했다. <em>"오늘 우리는 두 번째 창립을 완성했습니다."</em> 모두가 박수쳤다.'
$new2 = '회식 자리에서 김 사장은 마이크를 잡고 한 마디 했다. <em>"오늘 우리는 두 번째 창립을 완성했습니다."</em> 모두가 박수쳤다. 마이크 내려놓은 김 사장이 우리 자리로 한 번 와서 내 어깨를 두 번 두드렸다. <em>"민준씨, 18개월 됐네. 술도 그때보다 잘 먹지?"</em> 18개월 전 시화 횟집 1차에서 던졌던 같은 한 마디. 같은 어깨 두드림. 18개월 만의 회수.'

if ($c.Contains($old2)) {
    $c = $c.Replace($old2, $new2)
    Write-Host "회수 2 (김 사장 술 잘 먹네): 완료"
} else {
    Write-Host "회수 2: marker 못 찾음"
}

$afterLen = $c.Length
$c | Set-Content $f -Encoding UTF8 -NoNewline

Write-Host ""
Write-Host "총 변화: $beforeLen -> $afterLen (증가 $($afterLen - $beforeLen)자)"
