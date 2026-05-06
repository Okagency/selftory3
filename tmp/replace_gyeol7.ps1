[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# 모바일 전자책 별도 파일 생성
$desktop = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$mobile = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일.html'
$mobileEbook = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_모바일전자책.html'

# 1. 모바일 head 추출
$mobileContent = Get-Content $mobile -Raw -Encoding UTF8
$mobileHeadMatch = [regex]::Match($mobileContent, '(?s)<head>.*?</head>')
$mobileHead = $mobileHeadMatch.Value

# 2. 데스크탑 전체
$desktopContent = Get-Content $desktop -Raw -Encoding UTF8

# 3. 데스크탑 head를 모바일 head로 치환
$result = $desktopContent -replace '(?s)<head>.*?</head>', $mobileHead

# 4. 모바일 전자책 CSS + JS 추가
$css = @"
<style>
  html, body { margin: 0 !important; padding: 0 !important; height: 100vh !important; width: 100vw !important; overflow: hidden !important; max-width: none !important; }
  body {
    column-width: calc(100vw - 40px); column-gap: 40px; column-fill: auto;
    height: calc(100vh - 60px) !important; padding: 30px 20px !important;
    font-size: 15px !important; line-height: 1.7 !important;
    overflow-x: auto !important; overflow-y: hidden !important;
    scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch;
  }
  h2.part, h3.chapter { break-before: column; -webkit-column-break-before: always; page-break-before: always; }
  section, h2.part, h3.chapter { scroll-snap-align: start; }
  table, .case, .keypoint, .check, .side, .cost, blockquote, ol, ul, .flow, .ledger { break-inside: avoid; -webkit-column-break-inside: avoid; page-break-inside: avoid; }
  hr.pageline { break-after: column; }
  h1.book-title { font-size: 32px !important; margin: 60px 0 20px !important; }
  h2.part { font-size: 22px !important; }
  h3.chapter { font-size: 18px !important; }
  table { font-size: 12.5px !important; }
  #progress-bar { top: auto !important; bottom: 0 !important; }
  #position-indicator { bottom: 14px !important; left: 14px !important; font-size: 10.5px !important; padding: 5px 10px !important; }
  #bm-toolbar { bottom: 14px !important; right: 14px !important; }
  #bm-toolbar button { padding: 6px 10px !important; font-size: 11px !important; }
</style>
"@

$js = @"
<script>
(function() {
  let touchStartX = 0, touchStartY = 0;
  document.body.addEventListener('touchstart', function(e) {
    touchStartX = e.touches[0].clientX; touchStartY = e.touches[0].clientY;
  }, { passive: true });
  document.body.addEventListener('touchend', function(e) {
    const dx = e.changedTouches[0].clientX - touchStartX;
    const dy = e.changedTouches[0].clientY - touchStartY;
    if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) {
      const pageStep = window.innerWidth - 60;
      if (dx < 0) document.body.scrollBy({ left: pageStep, behavior: 'smooth' });
      else document.body.scrollBy({ left: -pageStep, behavior: 'smooth' });
    }
  }, { passive: true });
  document.addEventListener('keydown', function(e) {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
    const pageStep = window.innerWidth - 60;
    if (e.key === 'ArrowRight' || e.key === 'PageDown' || (e.key === ' ' && !e.shiftKey)) {
      e.preventDefault(); document.body.scrollBy({ left: pageStep, behavior: 'smooth' });
    } else if (e.key === 'ArrowLeft' || e.key === 'PageUp' || (e.key === ' ' && e.shiftKey)) {
      e.preventDefault(); document.body.scrollBy({ left: -pageStep, behavior: 'smooth' });
    }
  });
  const progressBar = document.getElementById('progress-bar');
  const posPercent = document.getElementById('pos-percent');
  function updatePos() {
    const sl = document.body.scrollLeft;
    const max = document.body.scrollWidth - document.body.clientWidth;
    const pct = max > 0 ? Math.round((sl / max) * 100) : 0;
    if (progressBar) progressBar.style.width = pct + '%';
    if (posPercent) posPercent.textContent = pct + '%';
  }
  document.body.addEventListener('scroll', updatePos, { passive: true });
  setTimeout(updatePos, 500);
})();
</script>
"@

$result = $result -replace '</head>', "$css`r`n</head>"
$result = $result -replace '</body>', "$js`r`n</body>"
$result = $result -replace 'ERP 컨설팅 가이드 — 민준의 18개월', 'ERP 컨설팅 가이드 — 민준의 18개월 [모바일 전자책판]'

$result | Set-Content $mobileEbook -Encoding UTF8 -NoNewline
Write-Host "모바일 전자책판 별도 생성: $mobileEbook"
Write-Host "크기: $($result.Length) chars"
