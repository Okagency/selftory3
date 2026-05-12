const fs = require('fs');

const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

// 1) 기존 라벨 (div 형태) 제거 (멱등 처리)
content = content.replace(/<div style="color:#bbb;font-size:10px;font-weight:normal;margin-top:6px;margin-bottom:-2px;">#\d+\.\d+<\/div>\s*/g, '');
// 기존 추가했던 id 제거 (다른 id는 보존)
content = content.replace(/\s+id="p\d+-\d+"/g, '');

const BOX_CLASSES = ['case', 'check', 'side', 'keypoint', 'dialogue', 'cost', 'flow', 'ledger'];
const boxRe = new RegExp(`<div\\s+class="(?:${BOX_CLASSES.join('|')})"[^>]*>[\\s\\S]*?</div>`, 'g');
const QUOTES = ['"', '“', '”', "'", '‘', '’'];

// 모든 chapter (ch1, ch2, ...) 시작 위치
const chRegex = /<h3 class="chapter" id="ch(\d+)">/g;
const chList = [];
let m;
while ((m = chRegex.exec(content)) !== null) {
  chList.push({ num: parseInt(m[1]), index: m.index });
}
chList.sort((a, b) => a.num - b.num);

// 부록 시작 위치 (마지막 챕터 끝)
const appRegex = /<h3 class="chapter" id="app-[a-z]/;
const appMatch = content.search(appRegex);
const lastEnd = appMatch >= 0 ? appMatch : content.length;

function labelChapter(text, chNum) {
  const boxes = [];
  const noBoxes = text.replace(boxRe, (mm) => {
    boxes.push(mm);
    return ` BOX${boxes.length - 1} `;
  });

  let counter = 0;
  let needsNewNumber = true;

  const tokenRe = /<hr\s+class="scene"\s*\/?>|<h[45][^>]*>|<p((?:\s[^>]*)?)>|<blockquote\s+class="story"((?:\s[^>]*)?)>/gi;

  const result = noBoxes.replace(tokenRe, function(mm, pAttrs, bqAttrs, offset, str) {
    if (mm.startsWith('<hr')) {
      needsNewNumber = true;
      return mm;
    }
    if (/^<h[45]/i.test(mm)) {
      needsNewNumber = true;
      return mm;
    }
    let tag, attrs;
    if (mm.startsWith('<p')) {
      tag = 'p';
      attrs = pAttrs || '';
    } else {
      tag = 'blockquote class="story"';
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

// 챕터 영역별 처리 — 뒤에서 앞으로 처리하면 인덱스 변하지 않음
const ranges = [];
for (let i = 0; i < chList.length; i++) {
  const start = chList[i].index;
  const end = i + 1 < chList.length ? chList[i + 1].index : lastEnd;
  ranges.push({ num: chList[i].num, start, end });
}

let totalCount = 0;
const summary = [];

// 뒤에서 앞으로 — 인덱스 안전
for (let i = ranges.length - 1; i >= 0; i--) {
  const r = ranges[i];
  const chText = content.slice(r.start, r.end);
  const result = labelChapter(chText, r.num);
  content = content.slice(0, r.start) + result.text + content.slice(r.end);
  summary.push(`ch${r.num}: ${result.count}`);
  totalCount += result.count;
}

fs.writeFileSync(src, content, 'utf8');

console.log(`총 ${chList.length}개 챕터, ${totalCount}개 장면번호 부여`);
summary.reverse().forEach(s => console.log('  ' + s));
