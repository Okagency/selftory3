const fs = require('fs');
const src = 'd:/dev/selftory3/output/ERP컨설팅/ERP컨설팅.html';
let c = fs.readFileSync(src, 'utf8');

const sumStart = c.indexOf('var sumScenes = [');
const sumEnd = c.indexOf('];', sumStart);
const sumText = c.slice(sumStart, sumEnd + 2);

const itemRe = /\[\s*'([^']+)',\s*'([^']*)'\s*\]/g;
const items = [];
let m;
while ((m = itemRe.exec(sumText)) !== null) {
  items.push({ id: m[1], label: m[2] });
}

function getSceneNumber(id) {
  const idIdx = c.indexOf(`id="${id}"`);
  if (idIdx < 0) return null;
  const before = c.slice(0, idIdx);
  const labelRe = /<div style="color:#bbb;[^"]*">#(\d+)\.(\d+)<\/div>/g;
  let lastN = null, lastM = null, mm;
  while ((mm = labelRe.exec(before)) !== null) { lastN = mm[1]; lastM = mm[2]; }
  if (lastN !== null) return `#${lastN}.${lastM}`;
  return null;
}

const newItems = items.map(item => {
  const num = getSceneNumber(item.id);
  // 라벨에서 기존 #N.M 제거 (마커 보존)
  let rest = item.label.replace(/^#\d+\.\d+\s*/, '');
  // 마커가 #N.M 뒤에 있던 경우도 처리 (예: '#31.13 ◇ ...')
  // 위 정규식에서 '#N.M ' 제거 후 '◇ ...' 만 남음
  // 마커가 라벨 처음에 있던 경우 (예: '★◆ 프롤로그') — 그대로 보존

  if (num) {
    const markerMatch = rest.match(/^([★◆◇]+)\s/);
    if (markerMatch) {
      return `['${item.id}', '${num} ${rest}']`;
    } else {
      return `['${item.id}', '${num} ${rest}']`;
    }
  } else {
    return `['${item.id}', '${rest}']`;
  }
});

// 새 꿈자리 항목 추가 — scene-vn-trip-3-night 직후
const dreamLabel = `['scene-pearl-dream', '#31.15 ◆ 한국 새벽 꿈 (진주 한 쌍·주인없는 귀걸이·"시즈카"·"서지원" 시드)']`;
const insertIdx = newItems.findIndex(s => s.includes("'scene-vn-trip-3-night'"));
const updatedItems = insertIdx >= 0
  ? [...newItems.slice(0, insertIdx + 1), dreamLabel, ...newItems.slice(insertIdx + 1)]
  : [...newItems, dreamLabel];

const newSumText = 'var sumScenes = [\n ' + updatedItems.join(',\n ') + '\n ];';

c = c.slice(0, sumStart) + newSumText + c.slice(sumEnd + 2);
fs.writeFileSync(src, c, 'utf8');

console.log(`sumScenes 갱신: ${updatedItems.length}건`);
console.log(`새 꿈자리 항목: scene-pearl-dream`);
