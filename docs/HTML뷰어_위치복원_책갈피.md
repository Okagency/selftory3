# HTML 뷰어 — 마지막 위치 복원 + 책갈피 모듈

`output/ERP컨설팅/ERP컨설팅.html`에서 추출한 재사용 모듈. 다른 책 HTML에 그대로 붙이면 동일 동작을 얻는다.

## 기능 요약
- 스크롤 위치를 `localStorage`에 저장하여 **파일을 다시 열면 마지막 위치로 자동 이동**
- 책갈피 추가/이동/삭제 (이름·시각·scrollY 저장)
- 진행률 바 + 현재 챕터 표시 (h2.part / h3.chapter 기준)
- 단축키: `T`(Top) `M`(목차) `I`(색인) `B`(책갈피 추가) `L`(목록) `Q`(메뉴) `H`(도움말) `Esc`(닫기) `←/→/Space/PageUp/PageDown`(한 화면씩)

## localStorage 키
```
<FILE_KEY>_lastpos      // 마지막 scrollY (정수)
<FILE_KEY>_bookmarks    // [{name, pos, time}, ...]
```
`FILE_KEY = 'erp_guide_' + 파일명`. **다른 책에 적용할 때 prefix를 책 식별자로 바꿀 것**(`'gongguppmang_' + …` 등). 그래야 책마다 위치/책갈피가 분리된다.

## 적용 방법
1. `</body>` 직전에 아래 두 블록(툴바 HTML + 스크립트)을 그대로 삽입
2. 첫 줄 `FILE_KEY` 의 `'erp_guide_'` 부분을 책별 고유 prefix로 교체
3. (선택) 진행률·현재 챕터를 표시하려면 페이지 안에 다음 요소가 있어야 함:
   - `#progress-bar` `#position-indicator` `#pos-chapter` `#pos-percent`
   - 챕터 인식: `h2.part`, `h3.chapter` 클래스
4. (선택) 색인 점프(`I` 키, "색인" 버튼)를 쓰려면 `#index` 요소 필요
5. (선택) 목차 점프(`M` 키, "목차" 버튼)를 쓰려면 `#toc` 요소 필요 — 없으면 맨 위로 이동

## 툴바 HTML

```html
<div id="bm-toolbar" style="position:fixed;bottom:14px;right:14px;z-index:9999;font-family:'Noto Sans KR',sans-serif;display:flex;flex-direction:row;gap:6px;align-items:center;">
 <div id="bm-actions" style="display:none;flex-direction:row;gap:6px;align-items:center;">
  <button id="goto-top" title="맨 위로 (T)" style="background:#2c5f5d;color:#fff;border:0;padding:7px 14px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12.5px;font-weight:600;letter-spacing:0.3px;">위로</button>
  <button id="goto-toc" title="목차로 (M)" style="background:#a68a3f;color:#fff;border:0;padding:7px 14px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12.5px;font-weight:600;letter-spacing:0.3px;">목차</button>
  <button id="goto-index" title="색인 (I)" style="background:#5d4a8b;color:#fff;border:0;padding:7px 14px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12.5px;font-weight:600;letter-spacing:0.3px;">색인</button>
  <button id="bm-toggle" title="책갈피 (L)" style="background:#8b3a2a;color:#fff;border:0;padding:7px 14px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12.5px;font-weight:600;letter-spacing:0.3px;">책갈피</button>
 </div>
 <button id="bm-handle" title="메뉴 (Q)" style="background:#444;color:#fff;border:0;padding:7px 13px;border-radius:14px;cursor:pointer;box-shadow:0 2px 8px rgba(0,0,0,.18);font-size:12.5px;font-weight:600;letter-spacing:0.3px;">메뉴</button>
 <div id="bm-panel" style="display:none;position:absolute;bottom:48px;right:0;width:280px;max-height:380px;overflow-y:auto;background:#fff;color:#1a1a1a;border:1px solid #b8a988;border-radius:8px;box-shadow:0 4px 14px rgba(0,0,0,.15);padding:12px 14px;">
  <div style="font-weight:700;border-bottom:1px solid #ddd;padding-bottom:6px;margin-bottom:8px;">📑 책갈피 목록</div>
  <div id="bm-list" style="font-size:12.5px;line-height:1.5;"></div>
  <div style="border-top:1px solid #ddd;margin-top:8px;padding-top:8px;font-size:11px;color:#666;">
   <button id="bm-add" style="background:#2c5f5d;color:#fff;border:0;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:12px;margin-right:4px;">+ 현재 위치 추가</button>
   <button id="bm-clear" style="background:#f0e0e0;color:#8b3a2a;border:0;padding:5px 10px;border-radius:4px;cursor:pointer;font-size:12px;">전체 삭제</button>
   <div style="margin-top:6px;">단축키: T(Top) M(목차) B(추가) L(목록) H(도움말)</div>
  </div>
 </div>
</div>
```

## 스크립트

```html
<script>
(function() {
 'use strict';
 const FILE_KEY = 'erp_guide_' + (location.pathname.split('/').pop() || 'main');
 const POS_KEY = FILE_KEY + '_lastpos';
 const BM_KEY = FILE_KEY + '_bookmarks';

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

 // ===== 2. 스크롤 시 위치 저장 (throttle 250ms) =====
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
 function saveBookmarks(arr) {
  localStorage.setItem(BM_KEY, JSON.stringify(arr));
 }
 function findNearestHeading() {
  const headings = document.querySelectorAll('h1, h2, h3, h4');
  let nearest = null, minDiff = Infinity;
  const y = window.scrollY + 80;
  for (const h of headings) {
   const top = h.getBoundingClientRect().top + window.scrollY;
   if (top <= y) {
    const diff = y - top;
    if (diff < minDiff) { minDiff = diff; nearest = h; }
   }
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
  if (bm[idx]) {
   window.scrollTo({ top: bm[idx].pos, behavior: 'smooth' });
   togglePanel(false);
  }
 }
 function deleteBookmark(idx) {
  const bm = getBookmarks();
  bm.splice(idx, 1);
  saveBookmarks(bm);
  renderList();
 }
 function clearAll() {
  if (confirm('모든 책갈피를 삭제하시겠습니까?')) {
   saveBookmarks([]);
   renderList();
  }
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
    '<a href="#" onclick="window._bmGoto(' + i + ');return false;" style="color:#8b3a2a;text-decoration:none;font-weight:500;display:block;">📍 ' + escapeHtml(b.name) + '</a>' +
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

 // ===== 4. 패널 토글 =====
 function togglePanel(force) {
  const p = document.getElementById('bm-panel');
  const show = (typeof force === 'boolean') ? force : (p.style.display === 'none');
  p.style.display = show ? 'block' : 'none';
  if (show) renderList();
 }

 // ===== 5. 알림 플래시 =====
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

 // ===== 6. 외부 노출 =====
 window._bmGoto = gotoBookmark;
 window._bmDelete = deleteBookmark;

 // ===== 7. Top·목차 이동 =====
 function gotoTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' });
 }
 function gotoToc() {
  const toc = document.getElementById('toc');
  if (toc) {
   toc.scrollIntoView({ behavior: 'smooth', block: 'start' });
  } else {
   gotoTop();
  }
 }

 // ===== 8. 메뉴 핸들 토글 =====
 function toggleActions(force) {
  const a = document.getElementById('bm-actions');
  const handle = document.getElementById('bm-handle');
  const indicator = document.getElementById('position-indicator');
  if (!a) return;
  const show = (typeof force === 'boolean') ? force : (a.style.display === 'none');
  a.style.display = show ? 'flex' : 'none';
  if (handle) handle.textContent = show ? '닫기' : '메뉴';
  if (handle) handle.style.background = show ? '#666' : '#444';
  if (indicator) indicator.style.display = show ? 'none' : 'block';
  if (!show) togglePanel(false);
 }

 // ===== 9. 이벤트 바인딩 =====
 document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('bm-toggle').addEventListener('click', function() { togglePanel(); });
  document.getElementById('bm-add').addEventListener('click', addBookmark);
  document.getElementById('bm-clear').addEventListener('click', clearAll);
  document.getElementById('goto-top').addEventListener('click', gotoTop);
  document.getElementById('goto-toc').addEventListener('click', gotoToc);
  document.getElementById('goto-index').addEventListener('click', function() {
   const el = document.getElementById('index');
   if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
  });
  document.getElementById('bm-handle').addEventListener('click', function() { toggleActions(); });

  // 진행률 클릭 → 메뉴 팝업 열기
  const posInd = document.getElementById('position-indicator');
  if (posInd) {
   posInd.style.cursor = 'pointer';
   posInd.addEventListener('click', function() { toggleActions(true); });
  }

  // 진행 바 + 현재 위치 업데이트
  const progressBar = document.getElementById('progress-bar');
  const posChapter = document.getElementById('pos-chapter');
  const posPercent = document.getElementById('pos-percent');
  const chapters = Array.from(document.querySelectorAll('h2.part, h3.chapter'));
  function updatePosition() {
   const scrollTop = window.scrollY || document.documentElement.scrollTop;
   const docHeight = document.documentElement.scrollHeight - window.innerHeight;
   const pct = docHeight > 0 ? Math.round((scrollTop / docHeight) * 100) : 0;
   if (progressBar) progressBar.style.width = pct + '%';
   if (posPercent) posPercent.textContent = pct + '%';
   let current = chapters[0];
   for (const ch of chapters) {
    const rect = ch.getBoundingClientRect();
    if (rect.top <= 100) current = ch;
    else break;
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

  // 전자책 — 좌/우 화살표·스페이스로 한 화면씩 이동
  document.addEventListener('keydown', function(e) {
   if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
   if (e.ctrlKey || e.metaKey || e.altKey) return;
   const pageStep = window.innerHeight - 80;
   if (e.key === 'ArrowRight' || e.key === 'PageDown' || (e.key === ' ' && !e.shiftKey)) {
    e.preventDefault();
    window.scrollBy({ top: pageStep, behavior: 'smooth' });
   } else if (e.key === 'ArrowLeft' || e.key === 'PageUp' || (e.key === ' ' && e.shiftKey)) {
    e.preventDefault();
    window.scrollBy({ top: -pageStep, behavior: 'smooth' });
   }
  });

  // 외부 탭 시 메뉴 자동 접힘
  document.addEventListener('click', function(e) {
   const tb = document.getElementById('bm-toolbar');
   if (tb && !tb.contains(e.target)) {
    toggleActions(false);
   }
  });
 });

 // ===== 10. 단축키 =====
 document.addEventListener('keydown', function(e) {
  if (e.target.tagName === 'INPUT' || e.target.tagName === 'TEXTAREA') return;
  if (e.ctrlKey || e.metaKey || e.altKey) return;
  const key = e.key.toLowerCase();
  if (key === 'b') { e.preventDefault(); addBookmark(); }
  else if (key === 'l') { e.preventDefault(); togglePanel(); }
  else if (key === 't') { e.preventDefault(); gotoTop(); }
  else if (key === 'm') { e.preventDefault(); gotoToc(); }
  else if (key === 'i') { e.preventDefault(); const el = document.getElementById('index'); if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' }); }
  else if (key === 'q') { e.preventDefault(); toggleActions(); }
  else if (key === 'escape') { togglePanel(false); toggleActions(false); }
  else if (key === 'h' && !e.shiftKey) {
   alert('📖 단축키\n\nQ — 메뉴 펼치기/접기\nT — 맨 위로\nM — 목차로\nI — 색인\nB — 책갈피 추가\nL — 책갈피 목록\nEsc — 모두 닫기\nH — 이 도움말\n\n📌 마지막 본 위치는 자동 저장됩니다.\n파일을 다시 열어도 그 위치부터 시작합니다.');
  }
 });
})();
</script>
```

## 주의 / 한계
- `file://` 로 열 때도 `localStorage` 는 origin(파일 경로)별로 저장됨 → **파일을 다른 폴더로 복사·이동하면 위치가 따라오지 않음**
- 시크릿/프라이빗 브라우징에서는 저장되지 않음
- 같은 prefix 를 다른 책에 쓰면 키 충돌로 위치가 섞임 — 반드시 책별 prefix 분리
- 스크롤 저장은 250ms throttle. 마지막 스크롤 후 250ms 안에 탭을 닫으면 그 이전 위치로 복원될 수 있음 (실용상 무시 가능)

## 원본
[output/ERP컨설팅/ERP컨설팅.html](../output/ERP컨설팅/ERP컨설팅.html) 12513–12752행
