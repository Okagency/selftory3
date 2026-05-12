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

// id의 위치 직전 (역방향)에서 가장 가까운 #N.M 라벨
function getSceneNumber(id) {
  const idIdx = c.indexOf(`id="${id}"`);
  if (idIdx < 0) return null;

  const before = c.slice(0, idIdx);
  const labelRe = /<div style="color:#bbb;[^"]*">#(\d+)\.(\d+)<\/div>/g;
  let lastN = null;
  let lastM = null;
  let mm;
  while ((mm = labelRe.exec(before)) !== null) {
    lastN = mm[1];
    lastM = mm[2];
  }
  if (lastN !== null) return `#${lastN}.${lastM}`;
  return null;
}

const newItems = items.map(item => {
  let num = getSceneNumber(item.id);

  // 마커 추출
  const markerMatch = item.label.match(/^([★◆◇]+\s)?/);
  const marker = markerMatch && markerMatch[0] ? markerMatch[0] : '';

  // 마커 이후 — "N장" 또는 "N장 끝" / "N장 직후" / "N장 마지막" 등 + "—" 제거
  let rest = item.label.slice(marker.length);
  rest = rest.replace(/^\d+장(?:\s+\S+)?\s*—\s*/, '');

  // num 없으면 라벨에서 추측 (id가 chN인 경우)
  if (!num) {
    const chMatch = item.id.match(/^ch(\d+)$/);
    if (chMatch) num = `#${chMatch[1]}.1`;
    else if (item.id === 'prologue') num = '#0.1';
  }

  const numPart = num ? num + ' ' : '';
  return `['${item.id}', '${marker}${numPart}${rest}']`;
});

const newSumText = 'var sumScenes = [\n ' + newItems.join(',\n ') + '\n ];';

c = c.slice(0, sumStart) + newSumText + c.slice(sumEnd + 2);

fs.writeFileSync(src, c, 'utf8');

console.log(`sumScenes 정비: ${newItems.length}건`);
console.log('\n[변경 결과]');
items.forEach((item, i) => {
  const before = item.label.length > 50 ? item.label.slice(0, 50) + '…' : item.label;
  const newRaw = newItems[i].replace(/\['[^']+', '/, '').replace(/'\]$/, '');
  const after = newRaw.length > 50 ? newRaw.slice(0, 50) + '…' : newRaw;
  console.log(`  ${item.id}`);
  console.log(`    Before: ${before}`);
  console.log(`    After : ${after}`);
});
