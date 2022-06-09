src="pagerank-gini-coefficient"
req="graph-generate"
out="/home/resources/Documents/subhajit/$src.log"
ulimit -s unlimited
printf "" > "$out"

# Download requirement
rm -rf $req
git clone https://github.com/puzzlef/$req
cd $req

# Run
g++ -std=c++17 -O3 main.cxx

log() {
  stdbuf --output=L "$@" 2>&1 | tee -a "$out"
}

# main <graph>
main() {
  G="$1"
  log echo "# main $1"
  cp ~/data/"${G}.mtx" ~/out/"${G}.mtx"
  log nvgraph pagerank ~/out/"${G}.mtx" -o ~/out/"${G}.yaml"
  rm ~/out/"${G}.mtx"
  log ./a.out rewrite ~/data/"${G}.mtx" -t "loop-deadends" -o ~/out/"${G}_loop.mtx"
  log nvgraph pagerank ~/out/"${G}_loop.mtx" -o ~/out/"${G}_loop.yaml"
  rm ~/out/"${G}_loop.mtx"
  log ./a.out rewrite ~/data/"${G}.mtx" -t "loop-all" -o ~/out/"${G}_loopall.mtx"
  log nvgraph pagerank ~/out/"${G}_loopall.mtx" -o ~/out/"${G}_loopall.yaml"
  rm ~/out/"${G}_loopall.mtx"
}

main web-Stanford
main web-BerkStan
main web-Google
main web-NotreDame
main soc-Slashdot0811
main soc-Slashdot0902
main soc-Epinions1
main coAuthorsDBLP
main coAuthorsCiteseer
main soc-LiveJournal1
main coPapersCiteseer
main coPapersDBLP
main indochina-2004
main italy_osm
main great-britain_osm
main germany_osm
main asia_osm

main arabic-2005
main uk-2005
main it-2004
# main soc-Epinions1
# main soc-LiveJournal1
main wiki-Talk
main cit-Patents
# main coPapersDBLP
main amazon-2008
# main italy_osm
main Linux_call_graph
