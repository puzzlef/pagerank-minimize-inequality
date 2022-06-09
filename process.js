const fs   = require('fs');
const os   = require('os');
const path = require('path');

const RFILEN = /^(\S+?)(?:_(loop|loopall))?$/;
const RGINIC = /^gini_coefficient: (\S+)$/m;
const RLOREN = /^lorenz_curve:$/m;
const RVALUE = /^- (\S+)/m;
const GRAPHS = [
  'web-Stanford',
  'web-BerkStan',
  'web-Google',
  'web-NotreDame',
  'indochina-2004',
  'arabic-2005',
  'uk-2005',
  'it-2004',
  'amazon-2008',
  'soc-Slashdot0811',
  'soc-Slashdot0902',
  'soc-Epinions1',
  'soc-LiveJournal1',
  'wiki-Talk',
  'coAuthorsDBLP',
  'coAuthorsCiteseer',
  'coPapersCiteseer',
  'coPapersDBLP',
  'cit-Patents',
  'italy_osm',
  'great-britain_osm',
  'germany_osm',
  'asia_osm',
  'Linux_call_graph',
];




// FILE, CSV
// ---------

function readFile(pth) {
  var d = fs.readFileSync(pth, 'utf8');
  return d.replace(/\r?\n/g, '\n');
}

function writeFile(pth, d) {
  d = d.replace(/\r?\n/g, os.EOL);
  fs.writeFileSync(pth, d);
}

function writeCsv(pth, rows) {
  var cols = Object.keys(rows[0]);
  var a = cols.join()+'\n';
  for (var r of rows)
    a += [...Object.values(r)].map(v => `"${v}"`).join()+'\n';
  writeFile(pth, a);
}




// MAIN
// ----

function orderGraphs(a, b) {
  var fa = path.basename(a, path.extname(a));
  var fb = path.basename(b, path.extname(b));
  var ga = RFILEN.exec(fa)[1];
  var gb = RFILEN.exec(fb)[1];
  return GRAPHS.indexOf(ga) - GRAPHS.indexOf(gb);
}


function readYamlLine(ln, data) {
  if (RGINIC.test(ln)) {
    var [, gini_coefficient] = RGINIC.exec(ln);
    data.gini_coefficient = parseFloat(gini_coefficient);
  }
  else if (RLOREN.test(ln)) {
    data.lorenz_curve = [];
  }
  else if (RVALUE.test(ln) && data.lorenz_curve) {
    var [, value] = RVALUE.exec(ln);
    data.lorenz_curve.push(parseFloat(value));
  }
}

function readYaml(pth) {
  var d = readFile(pth).trim();
  var lines = d.split('\n'), a = {};
  for (var ln of lines)
    readYamlLine(ln, a);
  return a;
}

function readYamls() {
  var a = new Map();
  var files = fs.readdirSync('out').sort(orderGraphs);
  for (var f of files) {
    var name = path.basename(f, path.extname(f));
    a.set(name, readYaml(`out/${f}`));
  }
  return a;
}


function groupGiniCoefficient(yamls) {
  var a = new Map();
  for ([k, v] of yamls) {
    var [, graph, variant] = RFILEN.exec(k);
    variant = variant || 'default';
    if (!a.has(graph)) a.set(graph, {graph});
    a.get(graph)[variant] = v.gini_coefficient;
  }
  return [...a.values()];
}

function groupLorenzCurve(yamls) {
  var a = [];
  for (var [k, v] of yamls) {
    for (var i=0; i<v.lorenz_curve.length; i++) {
      a[i] = a[i] || {};
      a[i][k] = v.lorenz_curve[i];
    }
  }
  return a;
}


function main() {
  var yamls = readYamls();
  writeCsv('gini_coefficient.csv', groupGiniCoefficient(yamls));
  writeCsv('lorenz_curve.csv', groupLorenzCurve(yamls));
}
main();
