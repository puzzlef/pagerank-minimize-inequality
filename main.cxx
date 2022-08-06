#include <utility>
#include <vector>
#include <string>
#include <cstdio>
#include <iostream>
#include "src/main.hxx"

using namespace std;



// Find the best possible edge to insert (that reduces gini coefficient).
template <class G, class T=float>
auto edgeInsertBest(const G& x, const vector<T> *init=nullptr) {
  using K = typename G::key_type;
  T min = T(); K minu = K(), minv = K();
  auto a  = pagerankMonolithicSeq(x, init);
  auto lc = lorenzCurve(a.ranks);
  auto gc = giniCoefficient(lc);
  x.forEachVertexKey([&](auto u) {
    x.forEachVertexKey([&](auto v) {
      if (x.hasEdge(u, v)) return;
      auto y  = duplicate(x);
      y.addEdge(u, v);
      y.correct();
      auto b  = pagerankMonolithicSeq(y, &a.ranks);
      auto ld = lorenzCurve(b.ranks);
      auto gd = giniCoefficient(ld);
      if (gd>=gc || (minu && gd>=min)) return;
      min = gd; minu = u; minv = v;
    });
  });
  return make_pair(minu, minv);
}


// Process a batch with given edge adding process.
template <class G, class T, class F>
auto tryHeuristic(G& x, const vector<T>& r, F fn) {
  auto [u, v] = fn(x, r);
  bool has = x.hasEdge(u, v);
  x.addEdge(u, v);
  x.correct();
  auto a  = pagerankMonolithicSeq(x, &r);
  auto lc = lorenzCurve(a.ranks);
  auto gc = giniCoefficient(lc);
  if (!has) { x.removeEdge(u, v); x.correct(); }
  return make_tuple(u, v, gc);
}


template <class G>
void runExperiment(const G& x, int batch) {
  using K = typename G::key_type;
  using T = float; vector<T> *init = nullptr;
  enum NormFunction { L0=0, L1=1, L2=2, Li=3 };
  auto a  = pagerankMonolithicSeq(x, init);
  auto lc = lorenzCurve(a.ranks);
  auto gc = giniCoefficient(lc);
  printf("[%05d edges; %.10f gini_coef.] %s\n", 0, gc, "noop");

  // Try different heuristics.
  auto y  = duplicate(x);
  auto r  = a.ranks;

  for (int n=0; n<batch; n++) {
    vector<string> heuristics;
    vector<tuple<K, K, T>> results;

    heuristics.push_back("edgeInsertCxrx");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      return edgeInsertCxrx(y, r);
    }));
    heuristics.push_back("edgeInsertCxSx");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      auto yt = transpose(y);
      auto b  = pagerankMonolithicSeq(yt, init);
      return edgeInsertCxSx(y, r, b.ranks);
    }));
    heuristics.push_back("edgeInsertCxSr");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      vector<T> f(y.span());
      y.forEachVertexKey([&](auto u) { f[u] = 1 - r[u]; });
      auto yt = transpose(y);
      auto b  = pagerankMonolithicSeq(yt, init, {&f});
      return edgeInsertCxSr(y, r, b.ranks);
    }));
    heuristics.push_back("edgeInsertCRrx");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      return edgeInsertCRrx(y, r);
    }));
    heuristics.push_back("edgeInsertCRSx");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      auto yt = transpose(y);
      auto b  = pagerankMonolithicSeq(yt, init);
      return edgeInsertCRSx(y, r, b.ranks);
    }));
    heuristics.push_back("edgeInsertCRSr");
    results.push_back(tryHeuristic(y, r, [&](auto y, auto r) {
      vector<T> f(y.span());
      y.forEachVertexKey([&](auto u) { f[u] = 1 - r[u]; });
      auto yt = transpose(y);
      auto b  = pagerankMonolithicSeq(yt, init, {&f});
      return edgeInsertCRSr(y, r, b.ranks);
    }));
    T minGc = T(1); int minI = 0;
    for (int i=0; i<heuristics.size(); i++) {
      auto [u, v, gc] = results[i];
      if (gc < minGc) { minGc = gc; minI = i; }
    }
    string heuristic = heuristics[minI];
    auto [u, v, gd]  = results[minI];
    printf("[%05d edges; %.10f gini_coef.] %s\n", n+1, gd, heuristic.c_str());
    y.addEdge(u, v);
    y.correct();
  }
}


int main(int argc, char **argv) {
  char *file = argv[1];
  int batch = argc>2? stoi(argv[2]) : 10000;
  printf("Loading graph %s ...\n", file);
  auto x  = readMtxOutDiGraph(file); println(x);
  selfLoopW(x, [](auto u) { return true; }); print(x); printf(" (selfLoopAllVertices)\n");
  runExperiment(x, batch);
  printf("\n");
  return 0;
}
