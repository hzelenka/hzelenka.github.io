---
title: Intuitionistic type theory in a nutshell
description: An attempt to explain things
tags: type-theory
---

Here are three apparent tautologies:

- If a proposition is not not true, it is true.
- Either a proposition is true or it is not true.
- If propositions A and B are not both true, one of them is false.

These statements seem not just true, but *trivially* true. Their truth is so obvious as to be meaningless. Kant would call them [*analytic* statements](https://en.wikipedia.org/wiki/Analytic%E2%80%93synthetic_distinction), like "all bachelors are unmarried men".

I claim that these statements are not quite tautologies. Interactive theorem provers such as Coq, Agda and Idris subscribe to intuitionistic type theory, in which these three statements are – well, not exactly *false*, but not *true* either. We can prove them in certain instances, but they do not hold in general.

Denying double negation in particular might sound nonsensical. Many research mathematicians I have spoken to express shock and even offense that a double negative is not a positive in interactive theorem provers. (As David Hilbert put it, "Dieses Tiertum non datur dem Mathematiker zu nehmen, wäre etwa, wie wenn man dem Astronomen das Ferhrohr oder dem Boxer den Gebrauch der Fäuste untersagen wollte": to deny the mathematician double negation would be like to deny the astronomer the telescope or the boxer the fists.) In fact, in intuitionistic type theory, it is perfectly logical to leave these three axioms out, even a good idea, and we can learn why with a detour into programming data types.

A fundamental data structure in computer science is a linked list. A list is a container for some integer number of objects of the same type; a *linked* list is one where every element either is the end of the list or offers directions to the memory address of the next element. To get to some particular element, you have to pass through each element ahead of it, like Indiana Jones jumping over the train cars.

Linked lists exist in both C++ and Haskell, but I think Haskell's syntax for declaring new data types is prettier, and that's all we ever need:

``` haskell
data List a = Nil | Cons a (List a)
```

What I like about Haskell is that the meaning of code fragments tends to match intuition. The left side of the equality says what we're declaring: namely, that for any type `a`, we can define a data type `List a`. We have `List Int`s, `List String`s, and even `List (List (List Char))` (lists of lists of lists of chars). The right side of the equality tells us how to make lists concretely. Namely, a list is either empty, or it's an element of type `a` attached to another list. For example, we have the list `Cons 3 (Cons 2 (Cons 1 Nil))` – a `List Int` containing a `3`, a `2` and then a `1`.

Another and, as we'll see, equivalent way of looking at the Haskell definition of lists is as an axiomatic construction of `List a`s. `Nil` is an axiom saying "the empty list is always a `List a`". `Cons` is an axiom saying "given a `List a` and a value of type `a`, there exists a list consisting of the value appended to the rest of the list." In that vein, consider [Giuseppe Peano](https://en.wikipedia.org/wiki/Giuseppe_Peano)'s elegant definition of the natural numbers:

- Zero is a natural number.
- For every natural number \\( n \\), the successor of that natural number, written \\( S(n) \\) and corresponding to \\(n+1\\) is also a natural number.

That description sounds a lot like the Haskell definition of lists. The similarity is so obvious, we just *have* to write the Peano numbers as a Haskell data type:

``` haskell
data Peano = Zero | Succ Peano
```

`Zero` is now a Haskell variable of type `Peano`. So is `Succ (Succ Zero)`, representing 2, and so is `Succ (Succ (Succ (Succ (Succ Zero))))`, representing 5. Obviously representing natural numbers in this way quickly gets unwieldy, but bear with me.

By the way, a shorter and Haskellier way of writing "`Succ (Succ Zero)` has type `Peano`" is `Succ (Succ Zero) :: Peano`. This will come in handy later.

The greatest feeling in mathematics is recognizing that two seemingly unrelated concepts are actually related, or even the same thing. So it is with data types and mathematical axiomatizations. The Haskell definition of `List a`s exhaustively defines all valid `List a`s and the Peano definition of natural numbers exhaustively defines all valid natural numbers.

The [Curry-Howard isomorphism](https://en.wikipedia.org/wiki/Curry%E2%80%93Howard_corresponden) says that *types are propositions, and propositions are types*. The type `Peano` we just defined is a proposition that we could paraphrase as: "natural numbers exist". Each instance of `Peano` proves the proposition, in the same way that 2 proves that natural numbers exist. With Curry-Howard in mind, we could also pronounce `::` in Haskell as "is a proof of", so that `Succ (Succ Zero) :: Peano` says "2 is a proof that natural numbers exist".

Curry-Howard goes deeper still. It is often the case that trivialities remain trivial under the other interpretation. The trivial logical property of *modus ponens* says that, if we have an implication \\( A \\implies B \\) (read "A implies B") and \\( A \\) is true, then \\( B \\) is true. In Haskell, we can link two types with a `->` to form the type of a function. If we have a function of type `a -> b`, and we have a value of type `a`, we can get a value of type `b` by applying the function to the value.

These tentative steps into intuitionistic type theory are enough to recognize the key way it differs from classical logic. Classically, truth and falsity are a fundamental part of any proposition. In a sense, all there is to a proposition in classical logic is whether it's true or false. That's all we need to know to join propositions together with fun symbols like \\( \\implies \\) and \\( \\iff \\).

Intutionistic type theory is concerned with not only *if* a given proposition is true, but *why* it's true – what its proof is. Proving a proposition amounts to defining an object fitting some specifications. Proofs are mathematical objects in intuitionistic type theory, just like integers or polynomials.

Identifying proof with the instantiation of a particular mathematic object is called *constructivism*. Strictly speaking, constructivism is a restriction – under the alternative, classical logic, more potential lines of reasoning are valid – but it's the best way of thinking if we want logic to correspond to programming. Imagine trying to hail an Uber on your phone, only for the app to claim that it's not going to get a cab, but it would be theoretically possible to do so if it really wanted to. That would be the equivalent of a nonconstructive proof.

Axiomatizations are rarely as elegant as Peano's definition of the natural numbers, but they are often more involved. Consider this axiomatization that defines what it means for one natural number to be less than or equal  to another:

- Zero is less than or equal to all natural numbers.
- If \\( n \\) is less than or equal to \\( m \\), then \\( S(n) \\) is less than or equal to \\( S(m) \\).

The fact that this axiomatization *works* is not as obvious as it was with the Peano natural numbers. Take a moment to think about it, if you need to, and convince yourself that it's impossible to derive, say, that two is less than or equal to one.

Again, it's tempting to write a Haskell data type building off of the `Peano`s from earlier. Remember what we learned about the Curry-Howard isomorphism: to prove a proposition is to present a value having its type. Therefore we want to make an `LTE` type in Haskell such that we can present a value of type `LTE (Succ Zero) (Succ (Succ Zero))`, but not `LTE (Succ (Succ Zero)) (Succ Zero)`:

``` haskell
data LTE ?? ?? = LTEZero ?? | LTESucc ??
```

I left some `?`s strewn about since there's a lot going on in this data type that Haskell just can't handle. Haskell's type system forms a fuzzier overlay over the language. 2 and 65536 are obviously different as values, but they both have the type `Int`. Recall that a `->` is used for function types, so we have `neg :: Int -> Int` for the function negating an integer: it takes an integer and maps it to another integer. In the Haskell version of `Peano` earlier, `Zero :: Peano` and `Succ :: Peano -> Peano`, so that `Succ` was really just a function from `Peano`s to `Peano`s. Functions like `Succ` (called *data constructors*) are somewhat restricted in comparison to ones like `neg`, though. Functions like `neg` are allowed to *pattern match*, responding differently to different particular `Int`s. `Succ` needs to treat all `Peano`s equally.

Thinking back to Curry-Howard, we don't actually even want `LTE (Succ Zero) Zero` and `LTE Zero (Succ Zero)` to be the same type. After all, the latter can be proved and the former can't be. We need LTE to be a *family* of types -- a function that takes two `Peano`s and returns a new type.

Yet this is impossible in Haskell ([unless you use a lot of pragmas](https://twitter.com/lexi_lambda/status/854088127127867392)). Suppose this were possible; then `LTE` would be a function and it would need to have a type, something like `Peano -> Peano -> Type` -- a mapping from two `Peano`s to a new type. But there is no type of all types in Haskell! Like the shadows dancing on the wall in Plato's cave, Haskell types are doomed to forever see values in silhouette. 

We need a programming language where types and values are on the same footing, where they can live and laugh together in harmony. We need Idris.

(Or any language with dependent types, but I like Idris.)

We can define `Peano`s in Idris exactly the same as we did in Haskell:

``` idris
data Peano = Zero | Succ Peano
```

Declaring the `LTE` type is a breeze, too:

```idris
data LTE : Peano -> Peano -> Type where
  LTEZero : (m : Peano) -> LTE Zero m
  LTESucc : LTE m n -> LTE (Succ m) (Succ n)
```

Unlike in Haskell, Idris allows data constructors to more carefully define the specifications (the *type signature* of data constructors). Note that has-type-of is spelled `:` instead of `::` in Idris. `LTEZero` says: "for any Peano natural number, I can give you a proof that zero is less than that natural number". Simple as that is, it's something Haskell just can't do. Haskell can't map a natural number to a type representing zero being less than the number. That would require types and values to interact.

`LTESucc` is a bit more complicated, but I'm sure you can understand it! It says: "if you give me a proof that one natural number is less than or equal to another, I can prove to you that the successor of the first is less than or equal to the successor of the second". That's a mouthful, but it's obviously true when you read it carefully.

By the way, here's a more formal way of writing out the mathematical axiomatization of less-than-or-equal-to:

- \\( \\forall n \\in \\mathbb{N}, 0 \\leq n \\)
- \\( \\forall n, m \\in \\mathbb{N}, n \\leq m \\implies S(n) \\leq S(m) \\)

See how closely it parallels the `LTE` type?

We can fire up the Idris command line interpreter and try out the data constructors for LTE live:

```idris
Idris> LTESucc (LTESucc (LTEZero 1))
LTESucc (LTESucc LTEZero) : LTE 2 3
Idris> LTESucc (LTEZero 0)
LTESucc LTEZero : LTE 1 1
```

After executing a line, Idris tells us the type of the result. Note how `LTESucc` and `LTEZero` are allowed to vary the *type* of their output depending on the particular *value* they receive. That's an example of dependent types!

In intuitionistic type theory, we call a function from a value that returns a particular type a pi-type, often written with a fancy capital pi: \\( \\Pi \\). \\( \\Pi \\)-types, believe it or not, correspond to the phrase *for all* or \\( \\forall \\) in conventional mathematics. \\( \\forall \\) says in a purely mathematical context that, given any element of a set or a topologic space or what have you, we can prove that some property holds for that particular element. Since propositions are types, proving a property that varies based on the input is just a function from values to types!

\\( \\forall \\) and \\( \\Pi \\)-types are there to prove something for everything. Sometimes, though, we're more interested in proving something holds true in just one specific case – say, if we want to come up with the prime factorization of a natural number, there's clearly one and only one in every case. Proving something is true in just one case corresponds to the existential quantifier \\( \\exists \\), pronounced "there exists".

\\( \\exists \\) is somewhat more challenging to describe in a type-theoretic context than \\( \\forall \\), but we can absolutely do it! The operator `**` – two asterisks – embodies "there exists" in Idris. Consider the Archimedean property of the natural numbers, which says that, for any natural number, we can come up with a bigger natural number. We'd write this in logical notation as (by the way, read \\(\\ni\\) as "such that"):

\$$ \\forall m \\in \\mathbb{N}, \\exists n\\in \\mathbb{N} \\ni m \\leq n\$$

To prove a theorem in Idris, you need to start by declaring a particular type explaining exactly what it is you want to prove. For the Archimedean property, it's:

``` idris
archimedeanProperty : (m : Peano) -> (n : Nat ** LTE m n)
```

Read the type from left to right and it's more or less the same as the logical version!

Remember that we prove a theorem by presenting a valid member of the type. Since `archimedeanProperty` is a function, we need to write a function and demonstrate to the typechecker that it does everything it's supposed to. The details of this process are fascinating, but rather technical, so it'll have to wait for a future blog post. (I'm sure you're waiting on the edge of your seat).

We call types like this one \\( \\Sigma \\)-types (that's a capital Greek sigma). Concretely, \\( \\Sigma \\)-types are ordered pairs where the type of the second element is allowed to depend on the type of the first; that's so much more confusing than just saying that they correspond to \\( \\exists \\), so let's stay away from that definition!

There's one last thing we need to define: negation. In classical logic, we could just say something like "the negation of \\(A\\) is defined to be the statement that is true precisely when \\(A\\) is false". That definition isn't exactly wrong, but it treats the truth or falsity of a proposition as a given. Either that, or it's like we have superpowers: I can take a proposition and generate its exact opposite! In the proof-aware mathematics of type theory, where we prove a proposition by presenting an object embodying it, we can't maintain constructivism by defining negation this way.

A better idea is to define the following data type in Idris:

``` idris
data Void where
```

That's all! Wait, what? `Void` is a type that has no inhabitants! It's a viable proposition, but a trivially false one, because it doesn't have any proofs. In logical notation, we usually call `Void` \\( False \\) or \\( \\bot \\) (pronounced "bottom"). I like the latter because it's like a dead mathematician flipping you off.

`Void` feels a bit like cheating, I admit, but it's quite useful. If we want to embody the negation of some type – say `SqrtTwoIsRational` – we can just write `SqrtTwoIsRational -> Void`. `SqrtTwoIsRational -> Void` says "if I get a proof that the square root of two is rational, then I can return a proof of bottom". There are, of course, *no* proofs of \\( \\bot \\), so that type is equivalent to demonstrating to the compiler that `SqrtTwoIsRational` has no proofs either. The only way to do something impossible is to condition it on something impossible happening.

That definition of negation obeys *most* of the expected ones. For instance, the logical principle of *ex false quodlibet* says that, if we prove something contradictory, then it implies anything. If pigs fly, then London is the capital of Germany. Similarly, it's possible to write a type-checking Idris function from `Void` to any other type. Writing a valid function amounts to coming up with a value in the return type for every value in the input type. If the input type is `Void`, "every value in the input type" is precisely nothing, so we're done before we even started!

The key property that our form of negation doesn't obey is double negative elimination. It does hold in constructive logic that \\(A \\implies \\neg \\neg A \\). Here's the proof: suppose we have a proof of the proposition \\( A \\), call it \\( a \\). We need to prove \\( (A \\implies \\bot) \\implies \\bot \\). To prove that implication, suppose we have a proof of \\( A \\implies \\bot\\). Then we can apply that implication to \\( a \\) from earlier and we have a value of type \\( \\bot \\), which is exactly what we needed.

Double negative elimination -- \\( \\neg \\neg A \\implies A \\) -- does not necessarily hold! Suppose we have a proof of \\( \\neg \\neg A \\), which expands to \\( (A \\implies \\bot) \\implies \\bot \\). If the implication of \\( A \\) to \\( \\bot \\) implies \\( \\bot \\), then, in a sense, there must exist some proof of \\( A \\) somewhere -- but in the proof-conscious mathematics of type theory, there are no ambient proofs. Proving \\( A \\) requires us to come up a value of type \\( A \\), and \\( (A \\implies \\bot) \\implies \\bot \\) tells us nothing about what a value of type \\( A \\) looks like.

There were two other seeming tautologies I mentioned at the top of the post that don't hold in type theory. First, that a proposition is either true or not true. In type theory, proving "A or B" obliges you to present a value of type \\( A \\) or a value of type \\( B \\). Thus proving \\( A \\vee \\neg A \\) says we are always capable of proving a statement true or false. That isn't true until every unsolved problem in mathematics is solved, which is actually impossible anyway. [I blame Kurt Gödel](https://en.wikipedia.org/wiki/G%C3%B6del%27s_incompleteness_theorems).

Second, that if \\( A \\) and \\( B \\) are not both true, then either \\( A \\) is not true or \\( B \\) is not true. We'd write this as \\( \\neg (A \\wedge B) \\implies \\neg A \\vee \\neg B \\). To prove the conclusion true, we'd need to decide *which* of \\( A \\) and \\( B \\) is not true. One of them needs to be, clearly, but we can't decide which with any sort of regularity.

With intuitionistic type theory in hand, we can think of logic as being just like manipulating functions and values, just with types mixed into the values. The more I study mathematics, the better everything I know seems to fit together.
