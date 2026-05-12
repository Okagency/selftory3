const fs = require('fs');
const c = fs.readFileSync('d:/dev/selftory3/output/공급망컨설팅/공급망컨설팅.html', 'utf8');
const cases = ['McKinsey','Bain','Deloitte','Accenture','BCG','P&G','Unilever','L\'Oréal','Estée Lauder','Sephora','Toyota','Apple','Walmart','Amazon','Tesla','Boeing','Henkel','Shiseido','Nestle','Zara','H&M','Uniqlo','DHL','Forrester','Conner','Bartlett','아모레','LG생활건강','이니스프리','닥터자르트','코웨이','현대차','LG화학','삼성전자','풍원'];
cases.forEach(name => {
  const idx = c.indexOf(name);
  let count = 0;
  let pos = 0;
  while ((pos = c.indexOf(name, pos)) >= 0) { count++; pos += name.length; }
  console.log(name + ' : ' + count);
});
