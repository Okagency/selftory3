const fs = require('fs');

const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let content = fs.readFileSync(src, 'utf8');

// blockquote.story의 모든 인라인 style 제거
const re = /<blockquote\s+class="story"\s+style="[^"]*"\s*>/g;
const matches = content.match(re) || [];
content = content.replace(re, '<blockquote class="story">');

fs.writeFileSync(src, content, 'utf8');

console.log(`blockquote.story 인라인 style 제거: ${matches.length}건`);

// 점검 — 남은 blockquote 중 style이 있는 것 (다른 클래스)
const remaining = content.match(/<blockquote[^>]*style=[^>]*>/g) || [];
console.log(`잔존 blockquote(style 포함): ${remaining.length}건`);
if (remaining.length > 0) {
  console.log('샘플:');
  remaining.slice(0, 5).forEach((m, i) => console.log(`  ${i + 1}. ${m.slice(0, 120)}`));
}
