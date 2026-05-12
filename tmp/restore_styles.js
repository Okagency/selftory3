const { execSync } = require('child_process');
const fs = require('fs');

const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';

// git에서 이전 버전 가져오기
process.chdir('d:/dev/selftory3');
const orig = execSync('git show HEAD:output/ERP컨설팅/ERP컨설팅.html', { encoding: 'utf8', maxBuffer: 50 * 1024 * 1024 });

// 이전 버전 — blockquote.story + style + body 매핑
const origRe = /<blockquote\s+class="story"\s+style="([^"]*)"\s*>([\s\S]*?)<\/blockquote>/g;
const origMap = new Map();
let m;
while ((m = origRe.exec(orig)) !== null) {
  const text = m[2].trim();
  if (text.length > 0 && !origMap.has(text)) {
    origMap.set(text, m[1]);
  }
}
console.log(`이전 버전 인라인 style blockquote.story: ${origMap.size}건`);

// 현재 파일 — blockquote.story (style 없음) 매칭하고 복원
let current = fs.readFileSync(src, 'utf8');
const curRe = /<blockquote\s+class="story"\s*>([\s\S]*?)<\/blockquote>/g;
let restored = 0;
let kept = 0;
let newAdded = 0;

current = current.replace(curRe, (full, body) => {
  const text = body.trim();
  // 1.1 박스 — 통합 · 표준 · 가시성 — 그대로 (디폴트 유지)
  if (text === '통합 · 표준 · 가시성') {
    kept++;
    return full;
  }
  if (origMap.has(text)) {
    restored++;
    return `<blockquote class="story" style="${origMap.get(text)}">${body}</blockquote>`;
  }
  newAdded++;
  return full;
});

fs.writeFileSync(src, current, 'utf8');
console.log(`복원: ${restored}건 / 1.1 박스 유지(디폴트): ${kept}건 / 새로 추가됐던 것: ${newAdded}건`);
