Comparison of deterministic heuristics for minimization of inequality in ranks of vertices.

This experiment compares *six deterministic heuristics* for *inequality minimization*:
1. Add an edge from the vertex with *highest contribution*, to the one with *lowest rank* (**edgeInsertCxrx**).
2. Add an edge from the vertex with *highest contribution*, to the one with *highest reverse rank* (**edgeInsertCxSx**).
3. Add an edge from the vertex with *highest contribution*, to the one with *highest reverse rank but mostly linking to low rank vertices* (**edgeInsertCxSr**).
4. Add an edge from the vertex with *highest contribution to the highest rank vertex*, to the one with *lowest rank* (**edgeInsertCRrx**).
5. Add an edge from the vertex with *highest contribution to the highest rank vertex*, to the one with *highest reverse rank* (**edgeInsertCRSx**).
6. Add an edge from the vertex with *highest contribution to the highest rank vertex*, to the one with *highest reverse rank but mostly linking to low rank vertices* (**edgeInsertCRSr**).

[Gini coefficient] is a value which represents **income/wealth inequality**
within a nation or group. It ranges from `0` to `1`, with `0` representing
*total equality* and `1` representing *total inequality*. It is calculated from
the [Lorenz curve], which plots *cumulative income/wealth* against *cumulative*
*number of households/people*. [PageRank] is a *random-walk* based metric which
**ranks** *webpages* based on the idea that *popular pages* are pointed to by
*other popular pages*. This is *one* of the *important metrics* used by
**search** **engines** to order the *results of a query*.

This ranking **affects our decision** to visit a *website*, and thus
*indirectly* controls the amount of **traffic** to a site, and by extension, the
amount of **money made** by the site (through *ads*, *sales*, or *investments*).
While there is nothing wrong with this (as we want to visit more useful
websites), it also ends up *skewing* the **future linking behavior** of the web
in favor of *already popular sites*. This is a **positive feedback loop** (rich
get richer), and it further **enhances the inequality** that already exists on
the web. High levels of inequality are *not sustainable*, and beyond a tipping
point can lead to **significant social unrest**. This motivates us to study
**inequality in ranking** (based on *PageRank*) on graphs, and find ways to
**keep it under control**.

In this experiment we study the minimization of **Gini coefficient** of
**PageRank values** on a number of graphs, using *six different deterministic
heuristics* for **adding edges** to the graph. First, the PageRank of each
vertex is computed in the original graph, and the original gini coefficient is
obtained. A heuristic is then run to obtain the *most suitable edge to be
added*. After this edge is added, the same heuristic is *run again*. For each
heuristic *1000 edges* are added. We plot the **variation of gini coefficient**
with each added edge for each heuristic.

Our first heuristic called **edgeInsertCxrx** adds an edge between the (current)
*highest contributing* vertex to the *lowest rank* vertex. The idea behind this
heuristic is to provide the highest possible increase in rank to the lowest rank
vertex. We obtained the highest contributing vertex by finding the vertex with
highest `R/d+1` value.

The second heuristic called **edgeInsertCxSx** is based on the idea of providing
the highest possible increase in rank to a vertex which directly or indirectly
links to many other vertices (so that it increases the rank of a large number of
other vertices as well). This is achieved by adding an edge from the *highest*
*contributing* vertex to the vertex with *highest reverse PageRank*. Here, the
reverse PageRank of a vertex is obtained by reversing (transposing) the graph,
and calculating the PageRanks.

The third heuristic called **edgeInsertCxSr** is an extension of
*edgeInsertCxSx*, and it prioritizes increasing the rank of vertices which link
(directly or indirectly) to a large number of vertices *having a low PageRank*
*score*. This is done by calculating a modified reverse PageRank, that
prioritizes contribution from vertices with low forward PageRank. Here, the
reverse rank of each vertex is calculated as `rᵤ = αRᵤrᵥ/dᵥ + (1-α)/N`, where
*rᵤ* is the reverse rank of a given vertex and *Rᵤ* is its forward rank
(precomputed), *rᵥ* is the reverse rank of a target vertex and *dᵥ* is its
in-degree, *α* is the damping factor, and *N* is the number of vertices in the
graph.

The remaining three heuristics **edgeInsertCRrx**, **edgeInsertCRSx**, and
**edgeInsertCRSr** are a variation of the three heuristics mentioned above where
the source vertex is chosen such that it minimizes the rank of the highest
ranked vertex. That is, we choose the source vertex with *highest contribution*
*to the highest rank* vertex. The idea is to reduce rank of high-ranked vertices
and increase the rank of low-ranked vertices at the same time, thus reducing
inequality.

It is observed that **web graphs** tend to have the **highest inequality**
(*gini coefficient*), while **road networks** tend to have the **lowest**.
Results indicate that the heuristics **unsually succeed** in reducing inequality
**on graphs with high gini coefficient** (such as *web graphs* and *social*
*networks*), but **mostly fail on graphs with low gini coefficient** (such as
*road networks* and *collaboration networks*). It is also observed that the
**rate of decrease in gini coefficient decreases** as more and more edges are
added to graph. In general, we observe that the heuristics **edgeInsertCxrx**,
**edgeInsertCxSx**, and **edgeInsertCxSr** perform the best, with
*edgeInsertCxSx*, and *edgeInsertCxSr* performing *almost identically*.
**edgeInsertCxrx** and **edgeInsertCxSx** heuristics would therefore be the
**best choices**, given that *edgeInsertCxSr* requires a modified PageRank
computation.

Based on these results, a **suitable approach to minimizing inequality** would
be to apply both the **edgeInsertCxrx** and **edgeInsertCxSx** heuristics and
**choose the the best** among them **for each edge addition**. Future research
work can include exploring *randomized heuristics* or looking for *better*
*deterministic heuristics*.

All outputs are saved in a [gist] and a small part of the output is listed here.
Some [charts] are also included below, generated from [sheets]. The input data
used for this experiment is available from the [SuiteSparse Matrix Collection].
This experiment was done with guidance from [Prof. Kishore Kothapalli].

<br>

```bash
$ g++ -std=c++17 -O3 main.cxx
$ ./a.out ~/data/web-Stanford.mtx
$ ./a.out ~/data/web-BerkStan.mtx
$ ...

# Loading graph /home/subhajit/data/web-Stanford.mtx ...
# order: 281903 size: 2312497 [directed] {}
# order: 281903 size: 2594400 [directed] {} (selfLoopAllVertices)
# [00000 edges; 0.6614511013 gini_coef.] edgeInsertCxrx
# [00001 edges; 0.6611226201 gini_coef.] edgeInsertCxrx
# [00002 edges; 0.6609632373 gini_coef.] edgeInsertCxrx
# ...
# [00000 edges; 0.6614511013 gini_coef.] edgeInsertCxSx
# [00001 edges; 0.6605761051 gini_coef.] edgeInsertCxSx
# [00002 edges; 0.6602863669 gini_coef.] edgeInsertCxSx
# ...
```

[![](https://i.imgur.com/qQayDDB.png)][sheetp]
[![](https://i.imgur.com/a71aWLg.png)][sheetp]
[![](https://i.imgur.com/YLx4vPa.png)][sheetp]
[![](https://i.imgur.com/F6M0Cok.png)][sheetp]
[![](https://i.imgur.com/lsmpyA8.png)][sheetp]
[![](https://i.imgur.com/o2S2aTB.png)][sheetp]
[![](https://i.imgur.com/lRS739g.png)][sheetp]
[![](https://i.imgur.com/tKFQU7k.png)][sheetp]
[![](https://i.imgur.com/0rX6PmQ.png)][sheetp]
[![](https://i.imgur.com/aEJ1dCs.png)][sheetp]
[![](https://i.imgur.com/LgIaVxh.png)][sheetp]
[![](https://i.imgur.com/Re7XGTt.png)][sheetp]
[![](https://i.imgur.com/bTRRojR.png)][sheetp]
[![](https://i.imgur.com/1gHGY17.png)][sheetp]
[![](https://i.imgur.com/8i1mpi5.png)][sheetp]
[![](https://i.imgur.com/4mOA5xR.png)][sheetp]
[![](https://i.imgur.com/TBLcHba.png)][sheetp]

<br>
<br>


## References

- [Inequality and inequity in network‑based ranking and recommendation algorithms](https://gist.github.com/wolfram77/67073abb335516949883656abcfc4b4a)
- [Understanding the Gini Coefficient](https://www.youtube.com/watch?v=BwSB__Ugo1s)
- [Gini Coefficient and Lorenz Curve](https://www.youtube.com/watch?v=y8y-gaNbe4U)
- [Deeper Inside PageRank](https://gist.github.com/wolfram77/1337a3fcf5bded2bb67d9e66e20bc2ef)
- [PageRank Algorithm, Mining massive Datasets (CS246), Stanford University](https://www.youtube.com/watch?v=ke9g8hB0MEo)
- [SuiteSparse Matrix Collection]

<br>
<br>

[![](https://i.imgur.com/lytcS7x.jpg)](https://www.youtube.com/watch?v=b6Zjb_t6wxk)


[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://cstar.iiit.ac.in/~kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
[Gini coefficient]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[Lorenz curve]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[PageRank]: https://www.youtube.com/watch?v=ke9g8hB0MEo
[gist]: https://gist.github.com/wolfram77/cdf07ba91fa5d057533dde5fb9a78278
[charts]: https://imgur.com/a/3azdXxR
[sheets]: https://docs.google.com/spreadsheets/d/19H2jAAWb3t_t-uIl9YYECtIXlkSnM6DDurq7Y5_Nz6o/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vSovE-6BFlsxug7_drbLdOda4N3Hu-QnU8VaqTboBPU6DkPPY438Cm2vpKaVKKOe_dz5e4sfiuMWu_J/pubhtml
