Comparison of inequality in ranks of vertices with different dead end handling strategies.

This experiment was for comparing the **Lorenz curve** and **Gini coefficient** between:
1. Find *PageRank* by *teleporting* to a random vertex from every dead end (**default**).
2. Find *PageRank* by *self-looping dead ends* (**loop**).
3. Find *PageRank* by *self-looping all vertices* (**loopall**).

[Gini coefficient] is a value which represents **income/wealth inequality**
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
obtained with three **different dead-end handling strategies**.


[Gini coefficient]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[Lorenz curve]: https://www.youtube.com/watch?v=BwSB__Ugo1s
[PageRank]: https://www.youtube.com/watch?v=ke9g8hB0MEo
