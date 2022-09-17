Comparison of inequality in ranks of vertices with different dead-end handling strategies.

This experiment was for comparing the **Lorenz curve** and **Gini coefficient** between:
1. Find *PageRank* by *teleporting* to a random vertex from every dead-end (**default**).
2. Find *PageRank* by *self-looping dead-ends* (**loop**).
3. Find *PageRank* by *self-looping all vertices* (**loopall**).

[Gini coefficient] is a value which represents [income/wealth inequality]
within a nation or group. It ranges from `0` to `1`, with `0` representing
*total equality* and `1` representing *total inequality*. It is calculated from
the [Lorenz curve], which plots *cumulative income/wealth* against *cumulative*
*number of households/people*. [PageRank] is a *random-walk* based metric which
**ranks** *webpages* based on the idea that *popular pages* are pointed to by
*other popular pages*. This is *one* of the *important metrics* used by **search**
**engines** to order the *results of a query*.

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

In this experiment we study the **Lorenz curve** and **Gini coefficient** of
**PageRank values** on a number of graphs, and compare between PageRank values
obtained with three **different dead-end handling strategies**: teleport from
dead-ends (*default*), self-loop dead-ends (*loop*), and self-loop all vertices
(*loopall*). The PageRank values of vertices in each graph is obtained with
[nvgraph.sh], which internally uses [nvGraph PageRank]. The **lorenz curve** of
ranks is obtained by *sorting the ranks* in ascending order and *cumulatively*
*summing* them up to obtain *100 samples*. These 100 samples are then compared
with the *ideal* (total equality) lorenz curve to obtain the **gini**
**coefficient**. Note that this is output into *YAML* files by `nvgraph.sh`
itself. This **measurement** process of *lorenz curve* and *gini coefficient* is
**repeated** for *loop* and *loopall* variants of graphs, which are generated
from the original graph using [graph-generate]. Finally we process all *YAML*
files into *CSV*, separately for *gini coefficient* and *lorenz curve*, and
compare the results.

Results indicate that **web graphs** in general (except `web-NotreDame`) have
**high** **gini coefficient** (i.e., high inequality) along with a *social*
*network* `soc-Epinions1`, and a *citation network* `cit-Patents`. **Road**
**networks** are observed to have the **lowest gini coefficient** (i.e., low
inequality) among all graph classes. If we take a look at the **average lorenz**
**curve** of all graphs, we observe that `50%` of popularity (ranks) is owned by
`~20%` of the vertices. However, on the `web-Stanford` graph `50%` of popularity
is owned by only `~3%` of vertices, and on the `arabic-2005` (another web graph)
is owned by only `~1%` of the vertices. This would be a *significantly worrying*
*level of inequality* if *each vertex* represented a *unique person*. However, it
is quite likely that many *low-ranked pages* are *low-effort ones* and thus have
a *high page-to-person ratio*.

On the *social network* `soc-Epinions1`, `50%` of popularity is owned by only
`~7%` of vertices (*gini coefficient* of `~0.66`), but on the `wiki-Talk` (a
*communication graph*) `50%` of popularity is owned by `~46%` of vertices (*gini*
*coefficient* of `~0.07`). This is quite interesting, given that *wiki users* are
usually *not ranked*, while search engines *always rank* web pages. *Road*
*networks*, such as `germany_osm`, are observed to have have a distribution
similar to that of `wiki-Talk`. Future work could focus on studying the
*variation* of the *lorenz* *curve* and *gini coefficient* of various graphs
*over time*.

All outputs are saved in [out](out/) and a small part of the output is listed
here. Some [charts] are also included below, generated from [sheets]. The input
data used for this experiment is available from the [SuiteSparse Matrix Collection].

<br>

```bash
$ ./main.sh

# # find-gini-coeff web-Stanford
# Loading graph /home/subhajit/out/web-Stanford.mtx ...
# order: 281903 size: 2312497 [directed] {}
# order: 281903 size: 2312497 [directed] {} (transposeWithDegree)
# [11.761 ms] nvgraphPagerank

# Loading graph /home/subhajit/data/web-Stanford.mtx ...
# order: 281903 size: 2312497 {}
# order: 281903 size: 2312669 {} (selfLoopDeadEnds)
# Writing to /home/subhajit/out/web-Stanford_loop.mtx ...

# Loading graph /home/subhajit/out/web-Stanford_loop.mtx ...
# order: 281903 size: 2312669 [directed] {}
# order: 281903 size: 2312669 [directed] {} (transposeWithDegree)
# [11.712 ms] nvgraphPagerank

# Loading graph /home/subhajit/data/web-Stanford.mtx ...
# order: 281903 size: 2312497 {}
# order: 281903 size: 2594400 {} (selfLoopVertices)
# Writing to /home/subhajit/out/web-Stanford_loopall.mtx ...

# Loading graph /home/subhajit/out/web-Stanford_loopall.mtx ...
# order: 281903 size: 2594400 [directed] {}
# order: 281903 size: 2594400 [directed] {} (transposeWithDegree)
# [10.477 ms] nvgraphPagerank
#
# ...
```

[![](https://i.imgur.com/3jz5lKB.png)][sheetp]
[![](https://i.imgur.com/Rn4Ro1H.png)][sheetp]
[![](https://i.imgur.com/pBzgWAi.png)][sheetp]
[![](https://i.imgur.com/LKu4xog.png)][sheetp]
[![](https://i.imgur.com/SZddZ8v.png)][sheetp]
[![](https://i.imgur.com/cYio1Bx.png)][sheetp]

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

[![](https://i.imgur.com/lKQtZEh.jpg)](https://www.humortimes.com/23794/rich-vs-poor-cartoon-news-report/)
[![ORG](https://img.shields.io/badge/org-puzzlef-green?logo=Org)](https://puzzlef.github.io)
[![DOI](https://zenodo.org/badge/501525015.svg)](https://zenodo.org/badge/latestdoi/501525015)


[Prof. Dip Sankar Banerjee]: https://sites.google.com/site/dipsankarban/
[Prof. Kishore Kothapalli]: https://cstar.iiit.ac.in/~kkishore/
[SuiteSparse Matrix Collection]: https://sparse.tamu.edu
[Gini coefficient]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[Lorenz curve]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[income/wealth inequality]: https://mkorostoff.github.io/1-pixel-wealth/
[PageRank]: https://www.youtube.com/watch?v=ke9g8hB0MEo
[nvGraph PageRank]: https://docs.nvidia.com/cuda/archive/10.0/nvgraph/index.html#nvgraph-pagerank-example
[nvgraph.sh]: https://www.npmjs.com/package/nvgraph.sh
[graph-generate]: https://github.com/puzzlef/graph-generate
[charts]: https://imgur.com/a/otAmltT
[sheets]: https://docs.google.com/spreadsheets/d/1-X7ci8i0r40EdBGdefUjQZZTwGD7lHCDl7PvMhTXkag/edit?usp=sharing
[sheetp]: https://docs.google.com/spreadsheets/d/e/2PACX-1vTNAOuYDQqBtYRju1dVLceVpinj2p15Mk_f8HaSGp0TbJrIYwRXTktpv0ZTfCY-8_vZmeJqYjcBPyPr/pubhtml
