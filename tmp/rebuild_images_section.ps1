[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$imgDir = "D:/dev/selftory3/output/MES구축가이드/images"

function B64 {
 param($path, $mime)
 $bytes = [System.IO.File]::ReadAllBytes($path)
 return "data:$mime;base64," + [Convert]::ToBase64String($bytes)
}
function Fig {
 param($src, $caption)
 return '<figure><img src="' + $src + '" alt=""><figcaption>' + $caption + '</figcaption></figure>'
}

# ===========================================
# 주조편 — 실제 다운로드 성공 7장
# ===========================================
$cold_die = B64 "$imgDir/cold_chamber_die_casting.svg" "image/svg+xml"
$hot_die = B64 "$imgDir/hot_chamber_die_casting.svg" "image/svg+xml"
$hpdc_4000 = B64 "$imgDir/hpdc_4000t.jpg" "image/jpeg"
$buhler = B64 "$imgDir/buhler_diecasting.jpg" "image/jpeg"
$hpdc_plant = B64 "$imgDir/hpdc_bay_urse.jpg" "image/jpeg"
$engine_bare = B64 "$imgDir/engine_block_bare.jpg" "image/jpeg"
$engine_18xer = B64 "$imgDir/engine_block_18xer.jpg" "image/jpeg"

$casting_section = @"
<section id="ch1-images">
 <h2 class="part">주조 도식·설비·부품 사진
 <small>1·2장 본문 보조 자료 — Wikimedia Commons CC-BY-SA</small>
 </h2>

 <p>주조 설비·부품 시각 자료 — 본문 1·2장과 함께 본다. 다이캐스팅 머신 스키매틱·실제 4000톤·Bühler·자동차 엔진 블록 사진. (용해로·CNC·휠 사진은 Wikimedia rate limit으로 추후 보강 예정 — 본문 1.3·1.7에서 텍스트 dictionary-grade로 다룬다.)</p>

"@ + (Fig $cold_die "도식 1.5a — 콜드 챔버 다이캐스팅 머신 스키매틱. 알루미늄 합금 표준. 슬리브에서 사출 플런저가 용탕을 금형 캐비티로 700~1,000 bar 고압 주입. (Wikimedia · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $hot_die "도식 1.5b — 핫 챔버 다이캐스팅 머신 스키매틱. 아연·마그네슘 합금에 주로 사용. 융탕이 머신 안 보온로에 직접 들어있음. (Wikimedia · CC-BY-SA 3.0)") + "`r`n" + `
(Fig $hpdc_4000 "사진 1.5c — 4000톤 고압 다이캐스팅 머신. 미션 케이스·엔진 블록 등 대형 구조 부품 양산 설비. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $buhler "사진 1.5d — Bühler 다이캐스팅 머신. 스위스 Bühler는 글로벌 자동차 다이캐스팅 머신 1위. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $hpdc_plant "사진 1.5e — HPDC 공장 라인 (Bay-Urse Plant). 머신·금형·인출 로봇·후공정의 일체화 라인. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $engine_bare "사진 2.1a — 자동차 엔진 블록 (B8444S Volvo). 알루미늄 합금 HPDC·CNC 가공 완료 상태. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $engine_18xer "사진 2.1b — 18XER 엔진 블록. 자동차 엔진 블록의 캐스트·머시닝 후 표면. (Wikimedia · CC-BY-SA)") + @"

</section>

"@

# ===========================================
# 사출편 — 실제 다운로드 성공 4장
# ===========================================
$el_exis = B64 "$imgDir/el_exis_sp300.jpg" "image/jpeg"
$plastic_mold_m = B64 "$imgDir/plastic_moulding.jpg" "image/jpeg"
$pellets = B64 "$imgDir/pellets.jpg" "image/jpeg"
$robot = B64 "$imgDir/industrial_robot.jpg" "image/jpeg"

$injection_section = @"
<section id="ch1-images">
 <h2 class="part">사출 설비·금형·자재 사진
 <small>1·2장 본문 보조 자료 — Wikimedia Commons CC-BY-SA</small>
 </h2>

 <p>사출 설비·자재 시각 자료 — 본문 1·2장과 함께 본다. 사출기·로봇·플라스틱 펠릿. (자동차 사출 부품 사진은 Wikimedia rate limit으로 추후 보강 예정 — 본문 1.3·2.1에서 텍스트 dictionary-grade로 다룬다.)</p>

"@ + (Fig $el_exis "사진 1.2a — Sumitomo Demag El-Exis SP 300 사출기. 정밀·반복성·전동식 사출기. 자동차 광학·전장 부품 양산. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $plastic_mold_m "사진 1.2b — 플라스틱 사출 머신 — 수평형 사출기 표준 구성. 호퍼·스크류·사출 노즐·금형·이형. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $pellets "사진 1.4a — 플라스틱 펠릿 (Resin Pellets) — 사출 신원료. PP·ABS·PC·PA·PBT 등 도메인별 등급. Regrind는 이 펠릿에 일정 비율 혼합. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $robot "사진 1.5a — 산업용 로봇 (인출용). Euromap 67 표준으로 사출기와 통신. 1샷 N캐비티 동시 인출·이송. (Wikimedia · CC-BY-SA)") + @"

</section>

"@

# 주조편 교체
$casting_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-주조.html"
$content = [System.IO.File]::ReadAllText($casting_file, [System.Text.Encoding]::UTF8)
$pattern = '(?s)<section id="ch1-images">.*?</section>\s*'
$content = $content -replace $pattern, $casting_section
[System.IO.File]::WriteAllText($casting_file, $content, $utf8NoBom)
Write-Host "casting images rebuilt"

# 사출편 교체
$injection_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($injection_file, [System.Text.Encoding]::UTF8)
$content = $content -replace $pattern, $injection_section
[System.IO.File]::WriteAllText($injection_file, $content, $utf8NoBom)
Write-Host "injection images rebuilt"

Write-Host "All done"
