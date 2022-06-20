#include <vector>
#include <string>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;




template <class G>
void runExperiment(const G& x, int batch) {
  using T = float;
  enum NormFunction { L0=0, L1=1, L2=2, Li=3 };
  vector<T> *init = nullptr;

  // Find original static PageRank.
  auto xt = transposeWithDegree(x);
  auto a  = pagerankMonolithicCuda(x, xt, init);
  auto lc = lorenzCurve(a.ranks);
  auto gc = giniCoefficient(lc);
  printf("[%05d edges; %.10f gini_coef.] original\n", 0, gc);
  for (int i=0; i<batch; i++) {
    auto [u, v] = edgeInsertLowRank(x, a.ranks);
    x.addEdge(u, v);  x.correct();
    xt.addEdge(v, u); xt.correct();
    auto b  = pagerankMonolithicCuda(x, xt, init);
    auto lc = lorenzCurve(b.ranks);
    auto gc = giniCoefficient(lc);
    printf("[%05d edges; %.10f gini_coef.] edgeInsertLowRank\n", b+1, gc);
  }
}


int main(int argc, char **argv) {
  char *file = argv[1];
  int batch = argc>2? stoi(argv[2]) : 1000;
  printf("Loading graph %s ...\n", file);
  auto x  = readMtxOutDiGraph(file); println(x);
  selfLoopW(x, [](auto u) { return true; }); print(x); printf(" (selfLoopAllVertices)\n");
  runExperiment(x, batch);
  printf("\n");
  return 0;
}
