// 공급망컨설팅 전체 챕터(ch1~ch88) 장면번호 부여
// 지침 docs/지침.txt [장면번호] 정수 따름
// 멱등: 기존 라벨·id 제거 후 재부여

const fs = require('fs');

const src = 'd:/dev/selftory3/output/공급망컨설팅/공급망컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

// 기존 라벨 제거 (span·div 두 형식, 점·하이픈 두 구분자 모두)
content = content.replace(/<span style="color:#bbb;font-size:10px;font-weight:normal;margin-right:6px;">\[#\d+[-.]\d+\]<\/span>/g, '');
content = content.replace(/<div style="color:#bbb;font-size:10px;font-weight:normal;margin-top:6px;margin-bottom:-2px;">#\d+[-.]\d+<\/div>\s*/g, '');
// 추가했던 id 제거 (p1-1·p88-12 등)
content = content.replace(/\s+id="p\d+-\d+"/g, '');

const BOX_CLASSES = ['case', 'check', 'side', 'keypoint', 'dialogue', 'cost', 'flow', 'ledger'];
const boxRe = new RegExp(`<div\\s+class="(?:${BOX_CLASSES.join('|')})"[^>]*>[\\s\\S]*?</div>`, 'g');
const QUOTES = ['"', '“', '”', "'", '‘', '’'];

// 모든 챕터 위치 탐지
const chapterRe = /<h3 class="chapter" id="ch(\d+)">/g;
const chapterPositions = [];
let m;
while ((m = chapterRe.exec(content)) !== null) {
  chapterPositions.push({ num: parseInt(m[1], 10), index: m.index });
}

// 마지막 챕터 종료 — 다음 section 또는 부록 시작
// 챕터들은 순차이므로 다음 챕터의 시작 = 현재 챕터의 끝
// 마지막 챕터(ch88)의 끝은 — 부록 또는 </section>에서 끝남
// 안전하게: 마지막 챕터 다음의 <section id="app-a"> 또는 <h2 class="part"> 까지

const appAStart = content.indexOf('<section id="app-a">');
const lastBoundary = appAStart > 0 ? appAStart : content.length;

function labelChapter(text, chNum) {
  const boxes = [];
  const noBoxes = text.replace(boxRe, (mm) => {
    boxes.push(mm);
    return ` BOX${boxes.length - 1} `;
  });

  let counter = 0;
  let needsNewNumber = true;

  const tokenRe = /<hr\s+class="scene"\s*\/?>|<h[45][^>]*>|<p((?:\s[^>]*)?)>|<blockquote\s+class="story"((?:\s[^>]*)?)>/gi;

  const result = noBoxes.replace(tokenRe, function (mm, pAttrs, bqAttrs, offset, str) {
    if (mm.startsWith('<hr')) {
      needsNewNumber = true;
      return mm;
    }
    if (/^<h[45]/i.test(mm)) {
      needsNewNumber = true;
      return mm;
    }
    let attrs;
    if (mm.startsWith('<p')) {
      attrs = pAttrs || '';
    } else {
      attrs = bqAttrs || '';
    }
    const afterIdx = offset + mm.length;
    const after = str.slice(afterIdx);
    const firstNonSpace = after.match(/^\s*(.)/);
    const c = firstNonSpace ? firstNonSpace[1] : '';
    if (QUOTES.includes(c)) return mm;
    if (needsNewNumber) {
      counter++;
      needsNewNumber = false;
      const n = counter;
      let newOpen;
      if (/\sid=/i.test(attrs)) {
        newOpen = mm;
      } else {
        newOpen = mm.replace(/>$/, ` id="p${chNum}-${n}">`);
      }
      const labelLine = `<div style="color:#bbb;font-size:10px;font-weight:normal;margin-top:6px;margin-bottom:-2px;">#${chNum}.${n}</div>\n`;
      return labelLine + newOpen;
    }
    return mm;
  });

  const restored = result.replace(/ BOX(\d+) /g, (mm, idx) => boxes[parseInt(idx, 10)]);
  return { text: restored, count: counter };
}

// 챕터별 처리
const segments = [];
let cursor = 0;
const counts = {};

for (let i = 0; i < chapterPositions.length; i++) {
  const cur = chapterPositions[i];
  const next = i + 1 < chapterPositions.length ? chapterPositions[i + 1].index : lastBoundary;

  // 현재 챕터 시작 전까지의 영역 그대로
  if (cur.index > cursor) {
    segments.push(content.slice(cursor, cur.index));
  }

  const chapterText = content.slice(cur.index, next);
  const { text, count } = labelChapter(chapterText, cur.num);
  segments.push(text);
  counts[cur.num] = count;
  cursor = next;
}

// 마지막 챕터 이후 (부록 등) 그대로
if (cursor < content.length) {
  segments.push(content.slice(cursor));
}

const newContent = segments.join('');
fs.writeFileSync(src, newContent, 'utf8');

const total = Object.values(counts).reduce((a, b) => a + b, 0);
const chapterCount = Object.keys(counts).length;
console.log(`처리 챕터: ${chapterCount}`);
console.log(`총 라벨: ${total}`);
const sample = Object.entries(counts).slice(0, 6).map(([k, v]) => `ch${k}: ${v}`).join(', ');
console.log(`샘플: ${sample}`);
const last = Object.entries(counts).slice(-3).map(([k, v]) => `ch${k}: ${v}`).join(', ');
console.log(`끝: ${last}`);
