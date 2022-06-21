#include <utility>
#include <vector>
#include <string>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;



// Process a batch with given edge adding process.
template <class G, class F>
void runBatch(const G& x, const char *name, int batch, int step, F fn) {
  using T = float;
  vector<T> r, *init = nullptr;
  auto y = duplicate(x);
  auto a = pagerankMonolithicCudaS(y, init);
  r = move(a.ranks);
  for (int i=0; i<batch;) {
    for (int j=0; j<step; i++, j++) {
      // Get edge to add.
      auto [u, v] = fn(y, r);
      // Add new edge.
      y.addEdge(u, v);
      y.correct();
    }
    // Find gini coefficient of ranks.
    auto b  = pagerankMonolithicCudaS(y, init);
    auto lc = lorenzCurve(b.ranks);
    auto gc = giniCoefficient(lc);
    printf("[%05d edges; %.10f gini_coef.] %s\n", i, gc, name);
    r = move(b.ranks);
  }
}


template <class G>
void runExperiment(const G& x, int batch, int step) {
  using T = float;
  enum NormFunction { L0=0, L1=1, L2=2, Li=3 };
  vector<T> *init = nullptr;

  // Find original static PageRank.
  auto a  = pagerankMonolithicCudaS(x, init);
  auto lc = lorenzCurve(a.ranks);
  auto gc = giniCoefficient(lc);
  printf("[%05d edges; %.10f gini_coef.] original\n", 0, gc);
  // Try different heuristics.
  const char *name;
  name = "edgeInsertLowRank";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    return edgeInsertLowRank(y, r);
  });
  name = "edgeInsertLowContrib";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    return edgeInsertLowContrib(y, r);
  });
  name = "edgeInsertLowRankHighReverse";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    auto yt = transpose(y);
    auto b  = pagerankMonolithicCudaS(yt, init);
    return edgeInsertLowRankHighReverse(y, r, b.ranks);
  });
  name = "edgeInsertLowContribHighReverse";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    auto yt = transpose(y);
    auto b  = pagerankMonolithicCudaS(yt, init);
    return edgeInsertLowContribHighReverse(y, r, b.ranks);
  });
  name = "edgeInsertHighReverse";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    auto yt = transpose(y);
    auto b  = pagerankMonolithicCudaS(yt, init);
    return edgeInsertHighReverse(y, r, b.ranks);
  });
  name = "edgeInsertHighRevrank";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    vector<T> f(y.order());
    y.forEachVertexKey([&](auto u) { f[u] = 1/r[u]; });
    auto yt = transpose(y);
    auto b  = pagerankMonolithicCudaS(yt, init, {&f});
    return edgeInsertHighReverse(y, r, b.ranks);
  });
  name = "edgeInsertHighRevcontrib";
  runBatch(x, name, batch, step, [&](auto y, auto r) {
    vector<T> f(y.order());
    y.forEachVertexKey([&](auto u) { f[u] = (y.degree(u) + 1)/r[u]; });
    auto yt = transpose(y);
    auto b  = pagerankMonolithicCudaS(yt, init, {&f});
    return edgeInsertHighReverse(y, r, b.ranks);
  });
}


int main(int argc, char **argv) {
  char *file = argv[1];
  int batch = argc>2? stoi(argv[2]) : 10000;
  int step  = argc>3? stoi(argv[3]) : 10;
  printf("Loading graph %s ...\n", file);
  auto x  = readMtxOutDiGraph(file); println(x);
  selfLoopW(x, [](auto u) { return true; }); print(x); printf(" (selfLoopAllVertices)\n");
  runExperiment(x, batch, step);
  printf("\n");
  return 0;
}
