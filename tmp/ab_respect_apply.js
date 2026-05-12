const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

// 서책임 → 재훈/세빈 대사만 변환 (em 태그 또는 p 태그 안 + "재훈씨/세빈씨" 시작)
const re = /(<(?:em|p)(?:\s[^>]*)?>)"((?:재훈씨|세빈씨)[^"]+?)"(<\/(?:em|p)>)/g;

let count = 0;
const log = [];

c = c.replace(re, (m, open, text, close) => {
  let nt = text;
  let changed = false;

  // 종결어미 변환 (AB존중어조)
  // "X예요." / "X이에요." → "X인 것 같아요."
  const patterns = [
    [/예요\./g, '인 것 같아요.'],
    [/이에요\./g, '인 것 같아요.'],
    [/합니다\./g, '라고 봐요.'],
    [/입니다\./g, '라고 봐요.'],
    [/거예요\./g, '거라고 봐요.'],
    [/거고요\./g, '거라고 봐요.'],
  ];

  for (const [p, r] of patterns) {
    const newer = nt.replace(p, r);
    if (newer !== nt) {
      nt = newer;
      changed = true;
    }
  }

  if (changed) {
    count++;
    log.push(`Before: ${text.slice(0, 80)}${text.length > 80 ? '…' : ''}`);
    log.push(`After : ${nt.slice(0, 80)}${nt.length > 80 ? '…' : ''}`);
    log.push('');
  }

  return open + '"' + nt + '"' + close;
});

fs.writeFileSync(src, c, 'utf8');

console.log(`${count}건 변환`);
log.forEach(l => console.log(l));
