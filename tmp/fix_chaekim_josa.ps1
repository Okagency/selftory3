[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$desktop = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드.html'
$ebook = 'D:\dev\selftory\docs\html\ERP_컨설팅_가이드_전자책.html'

$c = Get-Content $desktop -Raw -Encoding UTF8

# 전자책 CSS 삽입 (head 끝에)
$ebookCss = @"
<style>
  /* 전자책 모드 — 가로 페이지 방식 */
  html, body {
    margin: 0 !important;
    padding: 0 !important;
    height: 100vh !important;
    width: 100vw !important;
    overflow: hidden !important;
    max-width: none !important;
  }
  body {
    column-width: 720px;
    column-gap: 80px;
    column-fill: auto;
    height: calc(100vh - 80px) !important;
    padding: 40px 60px !important;
    overflow-x: auto !important;
    overflow-y: hidden !important;
    scroll-snap-type: x mandatory;
    -webkit-overflow-scrolling: touch;
  }
  /* 챕터/부 헤더는 컬럼 break */
  h2.part, h3.chapter {
    break-before: column;
    -webkit-column-break-before: always;
    page-break-before: always;
  }
  /* 페이지 시작 anchor 정착 */
  section, h2.part, h3.chapter {
    scroll-snap-align: start;
  }
  /* 큰 요소 세로 잘림 방지 */
  table, .case, .keypoint, .check, .side, .cost, blockquote, ol, ul, .flow, .ledger {
    break-inside: avoid;
    -webkit-column-break-inside: avoid;
    page-break-inside: avoid;
  }
  hr.pageline {
    break-after: column;
  }
  /* 진행 바 위치 보정 */
  #progress-bar {
    top: auto !important;
    bottom: 0 !important;
  }
  #position-indicator {
    bottom: 14px !important;
    left: 14px !important;
  }
  #bm-toolbar {
    bottom: 14px !important;
    right: 14px !important;
  }
</style>
"@

# </head> 직전에 삽입
$c = $c -replace '</head>', "$ebookCss`r`n</head>"

# JS — 좌우 키로 가로 페이지 이동
$ebookJs = @"
<script>
(function() {
  document.addEventListener('keydown', function(e) {
    if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
    if (e.ctrlKey || e.metaKey || e.altKey) return;
    const pageStep = window.innerWidth - 100;
    if (e.key === 'ArrowRight' || e.key === 'PageDown' || (e.key === ' ' && !e.shiftKey)) {
      e.preventDefault();
      document.body.scrollBy({ left: pageStep, behavior: 'smooth' });
    } else if (e.key === 'ArrowLeft' || e.key === 'PageUp' || (e.key === ' ' && e.shiftKey)) {
      e.preventDefault();
      document.body.scrollBy({ left: -pageStep, behavior: 'smooth' });
    }
  });
  // 휠 — 가로 스크롤로 변환
  document.body.addEventListener('wheel', function(e) {
    if (Math.abs(e.deltaY) > Math.abs(e.deltaX)) {
      e.preventDefault();
      document.body.scrollBy({ left: e.deltaY * 2, behavior: 'auto' });
    }
  }, { passive: false });
  // 진행 바 / 위치 — 가로 스크롤 기반
  const progressBar = document.getElementById('progress-bar');
  const posPercent = document.getElementById('pos-percent');
  function updateEbookPos() {
    const scrollLeft = document.body.scrollLeft;
    const maxScroll = document.body.scrollWidth - document.body.clientWidth;
    const pct = maxScroll > 0 ? Math.round((scrollLeft / maxScroll) * 100) : 0;
    if (progressBar) progressBar.style.width = pct + '%';
    if (posPercent) posPercent.textContent = pct + '%';
  }
  document.body.addEventListener('scroll', updateEbookPos, { passive: true });
  setTimeout(updateEbookPos, 500);
})();
</script>
"@

# </body> 직전에 삽입
$c = $c -replace '</body>', "$ebookJs`r`n</body>"

# 책 제목에 [전자책] 표시
$c = $c -replace 'ERP 컨설팅 가이드 — 재훈의 18개월', 'ERP 컨설팅 가이드 — 재훈의 18개월 [전자책판]'

$c | Set-Content $ebook -Encoding UTF8 -NoNewline
Write-Host "전자책판 생성: $ebook"
Write-Host "크기: $($c.Length) chars"
