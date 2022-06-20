#pragma once
#include <vector>
#include <utility>

using std::vector;
using std::make_pair;




// Pick source vertex with high contrib.
template <class G, class T>
auto vertexHighContrib(const G& x, const vector<T>& r) {
  using K = typename G::key_type;
  T max  = T();
  K maxu = K();
  x.forEachVertexKey([&](auto u) {
    T val = r[u] / (x.degree(u) + 1);
    if (val > max) { max = val; maxu = u; }
  });
  return maxu;
}


// Generate insertion edge pointing to low vertex property.
template <class G, class F>
auto edgeInsertLowBy(const G& x, F fn) {
  using K = typename G::key_type;
  using T = decltype(fn(K()));
  T min  = T(1);
  T minv = K();
  K u = vertexHighContrib(x, r);
  x.forEachVertexKey([&](auto v) {
    T val = fn(u);
    if (val >= min) return;
    if (x.hasEdge(u, v)) return;
    min = val; minv = v;
  });
  return make_pair(u, v);
}

// Generate insertion edge pointing to low rank.
template <class G, class T>
auto edgeInsertLowRank(const G& x, const vector<T>& r) {
  auto fn = [&](auto v) { return r[v]; };
  return edgeInsertLowBy(x, fn);
}

// Generate insertion edge pointing to low contrib.
template <class G, class T>
auto edgeInsertLowContrib(const G& x, const vector<T>& r) {
  auto fn = [&](auto v) { return r[v] / (x.degree(v) + 1); };
  return edgeInsertLowBy(x, fn);
}

// Generate insertion edge pointing to low rank and high reverse rank.
template <class G, class T>
auto edgeInsertLowRankHighReverse(const G& x, const vector<T>& r, const vector<T>& s) {
  auto fn = [&](auto v) { return r[v] * (1 - s[v]); };
  return edgeInsertLowBy(x, fn);
}

// Generate insertion edge pointing to low contrib and high reverse rank.
template <class G, class T>
auto edgeInsertLowContribHighReverse(const G& x, const vector<T>& r, const vector<T>& s) {
  auto fn = [&](auto v) { return r[v] * (1 - s[v]) / (x.degree(v) + 1); };
  return edgeInsertLowBy(x, fn);
}
// edgeInsertLowRankHighRevrank
// edgeInsertLowRankHighRevcontrib
