---
title: Charting the Bertrand paradox in Haskell
description: If you try to informally describe the length of a random chord in a circle, you might end up with three different answers.
tags: probability, haskell
---

The [Bertrand paradox](https://wikipedia.org/wiki/Bertrand_paradox_(probability)) may be set up as follows. Draw a unit circle (radius 1) and inscribe an equilateral triangle; each side has length \\( \sqrt{3} \\). Now draw a random _chord_, or line joining two points along the side of the circle. What is the probability that the chord is longer than a side of the inscribed triangle?

Here's the paradox: Joseph Bertrand presented three different heuristic arguments, each giving a different probability. Let's walk through all three. Along the way, I'll use some Haskell code available [here](https://github.com/hzelenka/bertrand-paradox) to generate some diagrams through the [chart](https://hackage.haskell.org/package/Chart) package. The code is not critical to understanding the post, but it _is_ pretty cool that it generated all of these charts in only 100 lines!

By the way, Haskell is a great programming language for something like this. Because Haskell is _pure_ and _functional_, all any computational process can do is take an input and then return a deterministic output. Functional programming is excellent for inherently mathematical problems. Let's get to it.

A chord is uniquely identified by its two endpoints along the edge of a circle. We can just designate the uppermost point on the circle as an endpoint – we always could have rotated the triangle anyway – so really, we just need to choose one endpoint. Here's a picture:

[<img src="/images/ex1.png" width="600">](https://hzelenka.github.io/images/ex1.png)

(As an aside, all the images in this post are scaled down slightly with minor loss of definition. You can click on them to view their full 800 by 600 pixel glory.)

The three sides of the triangle establish three "zones", in which every endpoint will land. The chord will be longer than \\( \\sqrt{3} \\) if and only if the second endpoint lands in the furthest zone, which makes up a third of the circle. We have a \\( \\frac{1}{3} \\) chance of a long chord.

That's the first heuristic, anyway. Here's the second. Draw a line from the center of the circle to an edge point (i.e. a radius). Again, we can rotate the triangle if we need to, so we might as well draw the radius to the very bottom of the circle. Now choose an arbitrary point on the radius and draw a chord perpendicular to it:

[<img src="/images/ex2.png" width="600">](https://hzelenka.github.io/images/ex2.png)

The radius crosses the triangle exactly halfway along its length. (We could geometrically prove this, but fortunately, the gridlines on the chart show this already). The chance of choosing a point past the halfway point is...half, so we have a \\( \\frac{1}{2} \\) chance of a long chord.

One last heuristic, I promise. A chord is uniquely identified by its midpoint, provided we don't choose the center of the circle. (Don't believe me? Draw a circle yourself and choose a point; see how many chords you can find with that midpoint). The chord will be longer than \\( \\sqrt{3} \\) if its midpoint lands inside a second circle inscribed within the triangle:

[<img src="/images/ex3.png" width="600">](https://hzelenka.github.io/images/ex3.png)

The second circle has half the radius of the first, so it has a quarter of the area. That means a \\( \\frac{1}{4} \\) chance of a long chord.

We have three different answers to the same problem. What gives?

Notice that it's called Russell's Paradox, not Russell's Contradiction. A paradox just means we formulated our assumptions improperly, and indeed we have: for above we have solved three different problems!

I've linked the Haskell code above to a function that generates one thousand random chords according to each heuristic, then calculates how many were longer than \\( \\sqrt{3} \\). Here's a graph I got for the first heuristic:

[<img src="/images/method1.png" width="600">](https://hzelenka.github.io/images/method1.png)

Looks...random. 353 out of 1000 is pretty close to \\( \\frac{1}{3} \\), so no worries there. There's not much to say until we have another randomly generated chart to compare it to:

[<img src="/images/method2.png" width="600">](https://hzelenka.github.io/images/method2.png)

Now the ratio is 472 out of 1000 – about \\( \\frac{1}{2} \\) – but it's not immediately clear what's different about the graph. Look close to the edges – there were a lot more chords on the first chart that ended very near to where they started. By the first heuristic, we choose a substantial number of second endpoints that are very close to the first endpoint, so we end up with a lot of short chords.

[<img src="/images/method3.png" width="600">](https://hzelenka.github.io/images/method3.png)

Finally, a chart that's obviously different! Just 228 out of 1000, about \\( \\frac{1}{4} \\) To use the technical mathematical term, it looks like a donut. Think about where the midpoints fall using the first two methods. That inner circle represents only a quarter of the area of the outer circle, but we have a higher chance than that of landing inside if we choose two random endpoints or choose a random point along a radius.

Let's back up a bit. What is the chance that any particular chord will be picked by one of these three processes? Because there are infinitely many possible chords, the answer is actually zero for all three! You can think of the math as \\( \\frac{1}{\\infty} = 0 \\). Strictly speaking, division by infinity is undefined, but the formula at least points in the right direction.

A better question is the chance that any particular chord will fall in a given range. Now the heuristic we're using matters. Each defines chord ranges – the first one based on their endpoints, the second one based on their positions along a perpendicular radius, the third one based on their midpoints – and asserts plausible but ultimately arbitrary probabilities that a random chord will fall within.

So what _is_ the chance that a random chord is longer than the side of an equilateral triangle? One might as well ask what the prettiest chord of a circle is. I actually like the problem of the prettiest chord more than Bertrand's problem. At least the ambiguity is obvious.
