const fs = require('fs');

const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

const ch1Start = content.indexOf('<h3 class="chapter" id="ch1">');
const ch3Start = content.indexOf('<h3 class="chapter" id="ch3">');

let middle = content.slice(ch1Start, ch3Start);

// 기존 라벨 (span 형태) 제거
middle = middle.replace(/<span style="color:#bbb;font-size:10px;font-weight:normal;margin-right:6px;">\[#\d+[-.]\d+\]<\/span>/g, '');
// 기존 라벨 (div 형태, - 또는 . 형식) 제거
middle = middle.replace(/<div style="color:#bbb;font-size:10px;font-weight:normal;margin-top:6px;margin-bottom:-2px;">#\d+[-.]\d+<\/div>\s*/g, '');
// 추가했던 id 제거
middle = middle.replace(/\s+id="p[12]-\d+"/g, '');

const BOX_CLASSES = ['case', 'check', 'side', 'keypoint', 'dialogue', 'cost', 'flow', 'ledger'];
const boxRe = new RegExp(`<div\\s+class="(?:${BOX_CLASSES.join('|')})"[^>]*>[\\s\\S]*?</div>`, 'g');
const QUOTES = ['"', '“', '”', "'", '‘', '’'];

const ch2StartLocal = middle.indexOf('<h3 class="chapter" id="ch2">');
const ch1Text = middle.slice(0, ch2StartLocal);
const ch2Text = middle.slice(ch2StartLocal);

function labelChapter(text, chNum) {
  const boxes = [];
  const noBoxes = text.replace(boxRe, (m) => {
    boxes.push(m);
    return ` BOX${boxes.length - 1} `;
  });

  let counter = 0;
  let needsNewNumber = true;

  const tokenRe = /<hr\s+class="scene"\s*\/?>|<h[45][^>]*>|<p((?:\s[^>]*)?)>|<blockquote\s+class="story"((?:\s[^>]*)?)>/gi;

  const result = noBoxes.replace(tokenRe, function(m, pAttrs, bqAttrs, offset, str) {
    if (m.startsWith('<hr')) {
      needsNewNumber = true;
      return m;
    }
    if (/^<h[45]/i.test(m)) {
      needsNewNumber = true;
      return m;
    }
    let tag, attrs;
    if (m.startsWith('<p')) {
      tag = 'p';
      attrs = pAttrs || '';
    } else {
      tag = 'blockquote class="story"';
      attrs = bqAttrs || '';
    }
    const afterIdx = offset + m.length;
    const after = str.slice(afterIdx);
    const firstNonSpace = after.match(/^\s*(.)/);
    const c = firstNonSpace ? firstNonSpace[1] : '';
    if (QUOTES.includes(c)) return m;
    if (needsNewNumber) {
      counter++;
      needsNewNumber = false;
      const n = counter;
      let newOpen;
      if (/\sid=/i.test(attrs)) {
        newOpen = m;
      } else {
        newOpen = m.replace(/>$/, ` id="p${chNum}-${n}">`);
      }
      // 라벨: #1.1 형식 (점)
      const labelLine = `<div style="color:#bbb;font-size:10px;font-weight:normal;margin-top:6px;margin-bottom:-2px;">#${chNum}.${n}</div>\n`;
      return labelLine + newOpen;
    }
    return m;
  });

  const restored = result.replace(/ BOX(\d+) /g, (m, idx) => boxes[parseInt(idx, 10)]);
  return { text: restored, count: counter };
}

const r1 = labelChapter(ch1Text, 1);
const r2 = labelChapter(ch2Text, 2);

const newMiddle = r1.text + r2.text;
const newContent = content.slice(0, ch1Start) + newMiddle + content.slice(ch3Start);

fs.writeFileSync(src, newContent, 'utf8');

console.log(`1장 장면/주제 단락: ${r1.count}`);
console.log(`2장 장면/주제 단락: ${r2.count}`);
