const fs   = require('fs');
const path = require('path');

const RFILEN = /^(\S+)(?:_(loop|loopall))?$/;
const RGINIC = /^gini_coefficient: (\S+)$/m;
const RLOREN = /^lorenz_curve:$/m;
const RVALUE = /^- (\S+)/m;




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
  var files = fs.readdirSync('out');
  for (var f of files)
    a.set(path.basename(f), readYaml(`out/${f}`));
  return a;
}


function groupGiniCoefficient(yamls) {
  var a = new Map();
  for ([k, v] of yamls) {
    var [, graph, variant] = RFILEN.exec(k);
    variant = variant || 'default';
    if (!a.has(graph)) a.set(graph, {graph});
    a.set(graph)[variant] = v.gini_coefficient;
  }
  return [...a.values()];
}

function groupLorenzCurve(yamls, variantSel) {
  var a = [];
  for (var [k, v] of yamls) {
    var [, graph, variant] = RFILEN.exec(k);
    variant = variant || 'default';
    if (variant!==variantSel) continue;
    for (var i=0; i<v.lorenz_curve.length; i++) {
      a[i] = a[i] || {};
      a[i][graph] = v.lorenz_curve[i];
    }
  }
  return a;
}


function main() {
  var yamls = readYamls();
  writeCsv('out/gini_coefficient.csv', groupGiniCoefficient(yamls));
  writeCsv('out/lorenz_curve-default.csv', groupLorenzCurve(yamls, 'default'));
  writeCsv('out/lorenz_curve-loop.csv',    groupLorenzCurve(yamls, 'loop'));
  writeCsv('out/lorenz_curve-loopall.csv', groupLorenzCurve(yamls, 'loopall'));
}
main();
