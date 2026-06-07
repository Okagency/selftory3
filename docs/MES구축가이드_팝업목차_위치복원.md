# MES구축가이드 — 팝업 목차 + 마지막 위치 복원 인프라

`output/MES구축가이드/MES구축가이드.html` 하단(`</body>` 직전)에 박혀있는 재사용 모듈. 다른 책 HTML에 그대로 복붙하고 두 군데만 바꾸면 동일 동작을 얻는다.

## 두 가지 핵심 기능

1. **팝업 목차** — 좌측 하단 `위치 인디케이터`를 탭/클릭하면 풀스크린 오버레이로 목차가 펼쳐지고, 항목을 누르면 해당 섹션으로 부드럽게 스크롤
2. **마지막 위치 자동 복원** — 스크롤 위치가 `localStorage`에 250ms throttle로 저장되어, 파일을 다시 열면 그 위치에서 시작

추가로 우측 하단 책갈피 버튼(🔖)과 단축키(B·L·Esc·H·←→·Space·PageUp/Down)도 같은 코드 안에 묶여있다.

---

## 적용 방법 — 다른 책에 옮길 때 4단계

### 1. 페이지 사전 조건 확인

본문에 다음 마크업이 있어야 동작한다.

- 부 헤더: `<h2 class="part" id="part1">…</h2>`
- 장 헤더: `<h3 class="chapter" id="ch1">…</h3>`
- 또는 헤더에 id가 없으면 가장 가까운 부모 `<section id="…">`의 id를 fallback으로 사용 (프롤로그·부록 처리)

이 두 셀렉터(`h2.part`, `h3.chapter`)와 id 조건이 안 맞으면 목차가 비어버린다.

### 2. `</body>` 직전에 아래 HTML+스크립트 블록 통째로 삽입

(아래 「전체 코드」 섹션 참조)

### 3. 책별로 바꿔야 할 2곳

| 위치 | MES 값 | 책별 교체 |
|---|---|---|
| `FILE_KEY` prefix | `'mes_guide_'` | `'erp_guide_'` · `'sc_guide_'` 등 책 식별자 |
| 액센트 색상 | `#2c5f5d` (teal) | 책 표지·테마 색에 맞춤 |

`FILE_KEY` prefix가 같으면 localStorage가 책끼리 섞인다. **반드시 책별로 분리**.

색상은 5곳에 박혀있다: `progress-bar` 그라데이션, `bm-toggle` 배경, `bm-add` 배경, h2 텍스트 색, `bm-flash` 배경.

### 4. (선택) 기타 색인 추가

핵심 장면(썸 정점·베드·헛물 등)을 한 화면에서 즉시 점프할 수 있는 색인. 아래 변수 한 줄에 `[id, 라벨]` 쌍을 채우면 목차 아래 별도 섹션으로 표시된다.

```javascript
var sumScenes = [
  ['ch11', '#11.1 ★ 시즈카 1대1 ("그날") | E3'],
  ['scene-final-return', '★◆ 호텔 14층 새벽 4시 47분']
];
```

빈 배열이면 색인 섹션 자체가 안 그려진다. MES구축가이드는 비어있다(D~H 라인 없음).

---

## 전체 코드 — `</body>` 직전에 통째로 박을 것

### 진행률 바 + 위치 인디케이터 + 팝업 목차

```html
<!-- ============================================================
 책갈피 · 진행률 · 팝업 목차 · 마지막 위치 인프라
============================================================ -->
<div id="progress-bar" style="position:fixed;top:0;left:0;width:0%;height:3px;background:linear-gradient(90deg,#2c5f5d,#a68a3f);z-index:10000;transition:width 0.1s ease-out;"></div>

<div id="position-indicator" onclick="toggleTocPopup();" ontouchend="event.preventDefault();toggleTocPopup();" style="position:fixed;bottom:14px;left:14px;z-index:9999;font-family:'Noto Sans KR',sans-serif;background:rgba(26,26,26,0.85);color:#fff;padding:10px 16px;border-radius:14px;font-size:11.5px;font-weight:600;letter-spacing:0.3px;box-shadow:0 2px 8px rgba(0,0,0,.18);cursor:pointer;-webkit-tap-highlight-color:rgba(255,255,255,0.2);user-select:none;">
 <span id="pos-chapter">표지</span> · <span id="pos-percent">0%</span>
</div>

<div id="toc-popup" style="display:none;position:fixed;left:14px;right:14px;bottom:60px;max-height:60vh;overflow-y:auto;overscroll-behavior:contain;background:#fff;color:#1a1a1a;border:1px solid #b8a988;border-radius:10px;box-shadow:0 6px 20px rgba(0,0,0,.25);padding:14px 18px;z-index:10000;font-family:'Noto Sans KR',sans-serif;-webkit-overflow-scrolling:touch;">
 <div style="display:flex;justify-content:space-between;align-items:center;border-bottom:1px solid #ddd;padding-bottom:8px;margin-bottom:10px;position:sticky;top:-14px;background:#fff;z-index:5;padding-top:14px;margin-top:-14px;">
  <span style="font-weight:700;font-size:14px;">📖 목차</span>
  <span onclick="toggleTocPopup(false);" ontouchend="event.preventDefault();toggleTocPopup(false);" style="cursor:pointer;color:#888;font-size:18px;font-weight:700;padding:0 6px;">×</span>
 </div>
 <div id="toc-popup-list" style="font-size:13px;line-height:1.7;"></div>
</div>

<script>
function toggleTocPopup(force) {
 var popup = document.getElementById('toc-popup');
 if (!popup) return;
 var show = (typeof force === 'boolean') ? force : (popup.style.display === 'none');
 if (show) {
  var list = document.getElementById('toc-popup-list');
  if (list && !list.dataset.built) {
   var items = document.querySelectorAll('h2.part, h3.chapter');
   var html = '';
   items.forEach(function(el) {
    var id = el.id;
    if (!id) {
     var parentSection = el.closest('section');
     if (parentSection && parentSection.id) id = parentSection.id;
    }
    if (!id) return;
    var clone = el.cloneNode(true);
    clone.querySelectorAll('small').forEach(function(s){s.remove();});
    var title = clone.textContent.trim();
    if (title.length > 50) title = title.substring(0, 48) + '…';
    var indent = el.tagName === 'H2' ? 0 : (el.tagName === 'H3' ? 12 : 24);
    var weight = el.tagName === 'H2' ? '700' : (el.tagName === 'H3' ? '600' : '400');
    var color  = el.tagName === 'H2' ? '#2c5f5d' : (el.tagName === 'H3' ? '#1a1a1a' : '#555');
    html += '<div onclick="gotoSection(\'' + id + '\');" style="cursor:pointer;padding:8px 0 8px ' + indent + 'px;font-weight:' + weight + ';color:' + color + ';border-bottom:1px dotted #eee;-webkit-tap-highlight-color:rgba(44,95,93,0.15);">' + title + '</div>';
   });
   // 기타 색인 (필요 시 채움 — 비어있으면 섹션 미표시)
   var sumScenes = [];
   if (sumScenes.length > 0) {
    html += '<div style="border-top:2px solid #2c5f5d;margin-top:8px;padding-top:8px;font-weight:700;color:#2c5f5d;">기타 색인</div>';
    sumScenes.forEach(function(s) {
     html += '<div onclick="gotoSection(\'' + s[0] + '\');" style="cursor:pointer;padding:6px 0 6px 16px;font-size:12.5px;color:#555;border-bottom:1px dotted #eee;-webkit-tap-highlight-color:rgba(44,95,93,0.15);">' + s[1] + '</div>';
    });
   }
   list.innerHTML = html;
   list.dataset.built = '1';
  }
  popup.style.display = 'block';
  document.body.dataset.scrollY = window.scrollY;
  document.body.style.position = 'fixed';
  document.body.style.top = '-' + window.scrollY + 'px';
  document.body.style.left = '0';
  document.body.style.right = '0';
  document.body.style.width = '100%';
 } else {
  popup.style.display = 'none';
  var y = parseInt(document.body.dataset.scrollY || '0', 10);
  document.body.style.position = '';
  document.body.style.top = '';
  document.body.style.left = '';
  document.body.style.right = '';
  document.body.style.width = '';
  window.scrollTo(0, y);
 }
}
function gotoSection(id) {
 document.body.style.position = '';
 document.body.style.top = '';
 document.body.style.left = '';
 document.body.style.right = '';
 document.body.style.width = '';
 var popup = document.getElementById('toc-popup');
 if (popup) popup.style.display = 'none';
 setTimeout(function() {
  var el = document.getElementById(id);
  if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
 }, 50);
}
</script>
```

### 책갈피 + 마지막 위치 복원 + 단축키

```html
<div id="bm-toolbar" style="position:fixed;bottom:14px;right:14px;z-index:9999;font-family:'Noto Sans KR',sans-serif;">
 <button id="bm-toggle" title="책갈피 (L)" style="background:#2c5f5d;color:#fff;border:0;padding:7px 12px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:16px;">🔖</button>
 <div id="bm-panel" style="display:none;position:absolute;bottom:48px;right:0;width:280px;max-height:380px;overflow-y:auto;background:#fff;color:#1a1a1a;border:1px solid #b8a988;border-radius:8px;box-shadow:0 4px 14px rgba(0,0,0,.15);padding:12px 14px;">
  <div style="font-weight:700;border-bottom:1px solid #ddd;padding-bottom:6px;margin-bottom:8px;">📑 책갈피 목록</div>
  <div id="bm-list" style="font-size:12.5px;line-height:1.5;"></div>
  <div style="border-top:1px solid #ddd;margin-top:8px;padding-top:8px;font-size:11px;color:#666;">
   <button id="bm-add" style="background:#8b3a2a;color:#fff;border:0;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:12px;margin-right:4px;">+ 현재 위치 추가</button>
   <button id="bm-clear" style="background:#f0e0e0;color:#2c5f5d;border:0;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:12px;">전체 삭제</button>
   <div style="margin-top:6px;">단축키: B(추가) L(목록) Esc(닫기) H(도움말)</div>
  </div>
 </div>
</div>

<script>
(function() {
 'use strict';
 // ★★★ 책별로 바꿀 prefix — localStorage 충돌 방지 ★★★
 const FILE_KEY = 'mes_guide_' + (location.pathname.split('/').pop() || 'main');
 const POS_KEY  = FILE_KEY + '_lastpos';
 const BM_KEY   = FILE_KEY + '_bookmarks';

 // ===== 1. 마지막 위치 자동 복원 =====
 window.addEventListener('load', function() {
  const saved = localStorage.getItem(POS_KEY);
  if (saved) {
   setTimeout(function() {
    window.scrollTo({ top: parseInt(saved, 10), behavior: 'auto' });
   }, 80);
  }
  renderList();
 });

 // ===== 2. 스크롤 시 위치 저장 (250ms throttle) =====
 let scrollTimer;
 window.addEventListener('scroll', function() {
  clearTimeout(scrollTimer);
  scrollTimer = setTimeout(function() {
   localStorage.setItem(POS_KEY, window.scrollY);
  }, 250);
 });

 // ===== 3. 책갈피 관리 =====
 function getBookmarks() {
  try { return JSON.parse(localStorage.getItem(BM_KEY) || '[]'); }
  catch(e) { return []; }
 }
 function saveBookmarks(arr) { localStorage.setItem(BM_KEY, JSON.stringify(arr)); }
 function findNearestHeading() {
  const headings = document.querySelectorAll('h1, h2, h3, h4');
  let nearest = null, minDiff = Infinity;
  const y = window.scrollY + 80;
  for (const h of headings) {
   const top = h.getBoundingClientRect().top + window.scrollY;
   if (top <= y) { const diff = y - top; if (diff < minDiff) { minDiff = diff; nearest = h; } }
  }
  return nearest ? nearest.textContent.trim().substring(0, 40) : '제목 없음';
 }
 function addBookmark() {
  const name = prompt('책갈피 이름 (취소 시 자동 제목):', findNearestHeading());
  if (name === null) return;
  const bm = getBookmarks();
  bm.push({
   name: (name || findNearestHeading()).substring(0, 50),
   pos: window.scrollY,
   time: new Date().toLocaleString('ko-KR')
  });
  saveBookmarks(bm);
  renderList();
  flash('✓ 책갈피 추가됨');
 }
 function gotoBookmark(idx) {
  const bm = getBookmarks();
  if (bm[idx]) { window.scrollTo({ top: bm[idx].pos, behavior: 'smooth' }); togglePanel(false); }
 }
 function deleteBookmark(idx) {
  const bm = getBookmarks(); bm.splice(idx, 1); saveBookmarks(bm); renderList();
 }
 function clearAll() {
  if (confirm('모든 책갈피를 삭제하시겠습니까?')) { saveBookmarks([]); renderList(); }
 }
 function renderList() {
  const list = document.getElementById('bm-list');
  if (!list) return;
  const bm = getBookmarks();
  if (bm.length === 0) {
   list.innerHTML = '<div style="color:#999;padding:8px 0;">저장된 책갈피가 없습니다.</div>';
   return;
  }
  list.innerHTML = bm.map(function(b, i) {
   return '<div style="padding:6px 0;border-bottom:1px dotted #eee;">' +
    '<a href="#" onclick="window._bmGoto(' + i + ');return false;" style="color:#2c5f5d;text-decoration:none;font-weight:500;display:block;">📍 ' + escapeHtml(b.name) + '</a>' +
    '<div style="display:flex;justify-content:space-between;align-items:center;margin-top:2px;">' +
    '<span style="color:#999;font-size:10.5px;">' + escapeHtml(b.time) + '</span>' +
    '<button onclick="window._bmDelete(' + i + ')" style="background:none;border:0;color:#c66;cursor:pointer;font-size:11px;">🗑️</button>' +
    '</div></div>';
  }).join('');
 }
 function escapeHtml(s) {
  return String(s).replace(/[&<>"']/g, function(c) {
   return { '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;' }[c];
  });
 }
 function togglePanel(force) {
  const p = document.getElementById('bm-panel');
  const show = (typeof force === 'boolean') ? force : (p.style.display === 'none');
  p.style.display = show ? 'block' : 'none';
  if (show) renderList();
 }
 let flashTimer;
 function flash(msg) {
  let el = document.getElementById('bm-flash');
  if (!el) {
   el = document.createElement('div');
   el.id = 'bm-flash';
   el.style.cssText = 'position:fixed;top:18px;left:50%;transform:translateX(-50%);background:#2c5f5d;color:#fff;padding:8px 18px;border-radius:20px;z-index:10000;font-family:sans-serif;font-size:13px;box-shadow:0 2px 10px rgba(0,0,0,.2);transition:opacity.3s;';
   document.body.appendChild(el);
  }
  el.textContent = msg;
  el.style.opacity = '1';
  clearTimeout(flashTimer);
  flashTimer = setTimeout(function() { el.style.opacity = '0'; }, 1500);
 }
 window._bmGoto = gotoBookmark;
 window._bmDelete = deleteBookmark;

 // ===== 4. 진행률 + 현재 챕터 + 키보드 페이지 이동 =====
 document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('bm-toggle').addEventListener('click', function() { togglePanel(); });
  document.getElementById('bm-add').addEventListener('click', addBookmark);
  document.getElementById('bm-clear').addEventListener('click', clearAll);

  const progressBar = document.getElementById('progress-bar');
  const posChapter  = document.getElementById('pos-chapter');
  const posPercent  = document.getElementById('pos-percent');
  const chapters    = Array.from(document.querySelectorAll('h2.part, h3.chapter'));

  function updatePosition() {
   const scrollTop = window.scrollY || document.documentElement.scrollTop;
   const docHeight = document.documentElement.scrollHeight - window.innerHeight;
   const pct = docHeight > 0 ? Math.round((scrollTop / docHeight) * 100) : 0;
   if (progressBar) progressBar.style.width = pct + '%';
   if (posPercent)  posPercent.textContent  = pct + '%';
   let current = chapters[0];
   for (const ch of chapters) {
    const rect = ch.getBoundingClientRect();
    if (rect.top <= 100) current = ch; else break;
   }
   if (current && posChapter) {
    const text = current.cloneNode(true);
    text.querySelectorAll('small').forEach(s => s.remove());
    let title = text.textContent.trim();
    if (title.length > 30) title = title.substring(0, 28) + '…';
    posChapter.textContent = title;
   }
  }
  window.addEventListener('scroll', updatePosition, { passive: true });
  updatePosition();

  // ===== 5. 한 화면씩 페이지 이동 =====
  document.addEventListener('keydown', function(e) {
   if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
   if (e.ctrlKey || e.metaKey || e.altKey) return;
   const pageStep = window.innerHeight - 80;
   if (e.key === 'ArrowRight' || e.key === 'PageDown' || (e.key === ' ' && !e.shiftKey)) {
    e.preventDefault(); window.scrollBy({ top: pageStep, behavior: 'smooth' });
   } else if (e.key === 'ArrowLeft' || e.key === 'PageUp' || (e.key === ' ' && e.shiftKey)) {
    e.preventDefault(); window.scrollBy({ top: -pageStep, behavior: 'smooth' });
   }
  });
 });

 // ===== 6. 책갈피·도움말 단축키 =====
 document.addEventListener('keydown', function(e) {
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
  if (e.ctrlKey || e.metaKey || e.altKey) return;
  const key = e.key.toLowerCase();
  if (key === 'b') { e.preventDefault(); addBookmark(); }
  else if (key === 'l') { e.preventDefault(); togglePanel(); }
  else if (key === 'escape') { togglePanel(false); if (typeof toggleTocPopup === 'function') toggleTocPopup(false); }
  else if (key === 'h' && !e.shiftKey) {
   alert('📖 단축키\n\nB — 책갈피 추가\nL — 책갈피 목록 토글\nEsc — 책갈피·목차 팝업 닫기\nH — 이 도움말\n\n📌 마지막 본 위치는 자동 저장됩니다.\n파일을 다시 열어도 그 위치부터 시작합니다.');
  }
 });
})();
</script>
```

---

## 팝업 목차 동작 — 자동 빌드 룰 핵심

| 항목 | 동작 |
|---|---|
| 셀렉터 | `h2.part`, `h3.chapter` 만 항목으로 잡음 (h4 제외) |
| id 우선순위 | (1) 헤더 element 자체의 id → (2) 가장 가까운 부모 `<section>`의 id (fallback) |
| 들여쓰기 | h2 = 0px·`#2c5f5d`·700 / h3 = 12px·`#1a1a1a`·600 |
| 캐싱 | 첫 토글 시 빌드 후 `list.dataset.built = '1'`로 표시 — 두 번째 호출부터 재빌드 안 함 |
| 본문 스크롤 잠금 | 팝업 열리면 `body { position:fixed }` 적용, 닫으면 원래 위치로 복원 (모바일 백그라운드 스크롤 차단) |
| 점프 | `gotoSection(id)` → `scrollIntoView({behavior:'smooth'})` |

**중요**: 본문 마크업이 `h2.part`·`h3.chapter` 클래스를 안 쓰면 셀렉터를 바꾸거나 본문에 클래스를 박아야 한다.

---

## 마지막 위치 복원 — 동작 흐름

1. 페이지 `load` 이벤트 → `localStorage[POS_KEY]` 읽음 → 80ms 후 그 위치로 jump (`behavior:'auto'`)
2. 스크롤 발생 → 250ms throttle → `localStorage[POS_KEY] = window.scrollY`
3. 다른 파일이거나 다른 prefix면 localStorage 키가 다르므로 위치 독립

---

## 책별 적용 체크리스트

- [ ] `FILE_KEY` prefix를 `'<책식별자>_'`로 교체 (필수)
- [ ] 액센트 색상 5곳 교체 (선택 — 표지 톤과 맞춤)
- [ ] 본문에 `h2.part`·`h3.chapter` 클래스 + id 부여 확인
- [ ] (선택) `sumScenes` 배열에 핵심 장면 색인 추가
- [ ] 브라우저로 열어 동작 검증 — 목차 빌드·점프·새로고침 후 위치 복원·책갈피 저장

---

## 주의 / 한계

- `file://` 로 열어도 `localStorage`는 origin(파일 경로)별로 저장 → **파일을 다른 폴더로 복사·이동하면 위치가 따라오지 않음**
- 시크릿/프라이빗 브라우징에서는 저장 안 됨
- 같은 prefix를 다른 책에 쓰면 키 충돌 — 반드시 책별 분리
- 스크롤 저장은 250ms throttle — 마지막 스크롤 후 250ms 내에 탭을 닫으면 이전 위치로 복원될 수 있음 (실용상 무시 가능)
- `chapters` 배열은 DOMContentLoaded 시점에 한 번만 수집 — 본문이 동적으로 추가되면 갱신 안 됨

---

## 원본 위치

[output/MES구축가이드/MES구축가이드.html](../output/MES구축가이드/MES구축가이드.html) 9962~10226행

기존 ERP 구버전(메뉴 펼침형·다중 버튼) 문서: [HTML뷰어_위치복원_책갈피.md](HTML뷰어_위치복원_책갈피.md)
