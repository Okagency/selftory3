[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$utf8NoBom = New-Object System.Text.UTF8Encoding $false
$imgDir = "D:/dev/selftory3/output/MES구축가이드/images"

Add-Type -AssemblyName System.Drawing
function Resize-Jpeg {
 param($src, $dst, $maxW = 1000, $quality = 75)
 $img = [System.Drawing.Image]::FromFile($src)
 if ($img.Width -le $maxW) { $newW = $img.Width; $newH = $img.Height }
 else { $ratio = $maxW / $img.Width; $newW = $maxW; $newH = [int]($img.Height * $ratio) }
 $bmp = New-Object System.Drawing.Bitmap $newW, $newH
 $g = [System.Drawing.Graphics]::FromImage($bmp)
 $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
 $g.DrawImage($img, 0, 0, $newW, $newH)
 $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object {$_.MimeType -eq "image/jpeg"}
 $params = New-Object System.Drawing.Imaging.EncoderParameters 1
 $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
 $bmp.Save($dst, $encoder, $params)
 $g.Dispose(); $bmp.Dispose(); $img.Dispose()
}

# 큰 사진 리사이즈
Resize-Jpeg "$imgDir/headlights_modern.jpg" "$imgDir/headlights_modern_r.jpg" 1000 75
Resize-Jpeg "$imgDir/ferrari_grille.jpg" "$imgDir/ferrari_grille_r.jpg" 1000 75
Resize-Jpeg "$imgDir/bentley_grill.jpg" "$imgDir/bentley_grill_r.jpg" 1000 75
Resize-Jpeg "$imgDir/injection_mold_cavities.jpg" "$imgDir/injection_mold_cavities_r.jpg" 1000 75
Resize-Jpeg "$imgDir/injection_mold_1.jpg" "$imgDir/injection_mold_1_r.jpg" 1000 75
Resize-Jpeg "$imgDir/bumper_basic.jpg" "$imgDir/bumper_basic_r.jpg" 1000 75
Write-Host "resized"

function B64 { param($path, $mime); $bytes = [System.IO.File]::ReadAllBytes($path); return "data:$mime;base64," + [Convert]::ToBase64String($bytes) }
function Fig { param($src, $caption); return '<figure><img src="' + $src + '" alt=""><figcaption>' + $caption + '</figcaption></figure>' }

# 사출편 사진 12장
$el_exis = B64 "$imgDir/el_exis_sp300.jpg" "image/jpeg"
$plastic_m = B64 "$imgDir/plastic_moulding.jpg" "image/jpeg"
$pellets = B64 "$imgDir/pellets.jpg" "image/jpeg"
$robot = B64 "$imgDir/industrial_robot.jpg" "image/jpeg"
$mold1 = B64 "$imgDir/injection_mold_1_r.jpg" "image/jpeg"
$mold_2plate = B64 "$imgDir/injection_mold_2plate.jpg" "image/jpeg"
$mold_cavities = B64 "$imgDir/injection_mold_cavities_r.jpg" "image/jpeg"
$lens = B64 "$imgDir/headlight_lens.jpg" "image/jpeg"
$headlights = B64 "$imgDir/headlights_modern_r.jpg" "image/jpeg"
$ferrari_grille = B64 "$imgDir/ferrari_grille_r.jpg" "image/jpeg"
$bentley = B64 "$imgDir/bentley_grill_r.jpg" "image/jpeg"
$bumper = B64 "$imgDir/bumper_basic_r.jpg" "image/jpeg"

$injection_section = @"
<section id="ch1-images">
 <h2 class="part">사출 설비·금형·자동차 부품 사진
 <small>1·2장 본문 보조 자료 — Wikimedia Commons CC-BY-SA · 12장</small>
 </h2>

 <p>사출 핵심 설비·금형·자재·자동차 부품 시각 자료. 본문 1·2장과 함께 본다.</p>

"@ + (Fig $el_exis "사진 1.2a — Sumitomo Demag El-Exis SP 300 사출기. 정밀·반복성·전동식. 자동차 광학·전장 부품 양산. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $plastic_m "사진 1.2b — 플라스틱 사출 머신 — 수평형 표준 구성. 호퍼·스크류·사출 노즐·금형·이형. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $pellets "사진 1.4a — 플라스틱 펠릿 (Resin Pellets) — 사출 신원료. PP·ABS·PC·PA·PBT 등 도메인별 등급. Regrind는 이 펠릿에 일정 비율 혼합. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $robot "사진 1.5a — 산업용 로봇 (인출용). Euromap 67 표준으로 사출기와 통신. 1샷 N캐비티 동시 인출·이송. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $mold1 "사진 1.5b — 사출 금형 (Injection Mold). 1금형 4~32 캐비티 동시 성형. 캐비티별 분리 추적이 사출 MES 핵심. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $mold_2plate "도식 1.5c — Standard Two-Plate Injection Molding Tool. 사출 금형의 가장 기본 구조 — 캐비티 + 코어. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $mold_cavities "사진 1.5d — 2 캐비티 사출 금형. 한 샷에 2개 부품 동시 성형. 캐비티별 Hot Runner zone 온도 분리 관리. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $lens "사진 2.1a — 자동차 헤드램프 렌즈 광학 구조. 폴리카보네이트(PC) 사출 + 하드 코팅 + UV 보호층. 광학 정밀도가 OEM 인증 핵심. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $headlights "사진 2.1b — Proton Suprima S 자동차 헤드램프. PC 사출 렌즈 + LED 반사판. 사출 광학 부품 표준. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $ferrari_grille "사진 2.1c — Ferrari 458 라디에이터 그릴. ABS·PC/ABS 사출 + 크롬 도금 후공정. 외장 표면 Class A 등급. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $bentley "사진 2.1d — Bentley 라디에이터 그릴. 자동차 사출 외장 부품의 표면 정밀도 사례. (Wikimedia · CC-BY-SA)") + "`r`n" + `
(Fig $bumper "사진 2.1e — 자동차 범퍼. PP/EPDM·TPO 사출. 차량 외장 가장 큰 사출 부품 (5~9kg). 도색·코팅 후공정 필수. (Wikimedia · CC-BY-SA)") + @"

</section>

"@

$injection_file = "D:/dev/selftory3/output/MES구축가이드/mes구축가이드-사출.html"
$content = [System.IO.File]::ReadAllText($injection_file, [System.Text.Encoding]::UTF8)
$pattern = '(?s)<section id="ch1-images">.*?</section>\s*'
$content = $content -replace $pattern, $injection_section
[System.IO.File]::WriteAllText($injection_file, $content, $utf8NoBom)
Write-Host "injection images: 12 photos"
