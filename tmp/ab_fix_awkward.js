const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

const fixes = [
  ['거인 것 같아요', '거예요'],
  ['거라고 봐요', '거예요'],
  ['감사라고 봐요', '감사합니다'],
  ['가야 라고 봐요', '가야 한다고 봐요'],
  ['서지원인 것 같아요', '서지원이에요'],
  ['것라고 봐요', '것이라고 봐요'],
  ['것인 것 같아요', '것 같아요'],
];

let total = 0;
const log = [];
for (const [pat, rep] of fixes) {
  const escaped = pat.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const re = new RegExp(escaped, 'g');
  const m = c.match(re) || [];
  if (m.length > 0) {
    c = c.replace(re, rep);
    total += m.length;
    log.push(`  "${pat}" → "${rep}": ${m.length}건`);
  }
}
fs.writeFileSync(src, c, 'utf8');
console.log(`${total}건 정정`);
log.forEach(l => console.log(l));
